# yka-code stack audit — 2026-04-18

Audit as of **2026-04-18**. Scope: what `yka-code` deploys into `~/.claude/` and the user's machine (NOT the CLI installer code).

Method: `/do` → Phase 0 (karpathy-guidelines + coding-style + research-first + audit-rigor) → parallel fan-out, one subagent per bucket (7 buckets). Each subagent did its own retrieval (docfork / deepwiki / github MCPs) with a word budget and returned SWAP / ADD / DROP / KEEP-BUT-UPGRADE / SURPRISE / UNVERIFIED.

Confidence threshold: ≥70% on every non-UNVERIFIED bullet. Citations inline.

---

## 1 — MCPs (7 servers)

### SWAP
- **composio → arcade-mcp** (ArcadeAI/arcade-mcp). Composio deprecated its standalone MCP surface (`deprecated.mcp` namespace) and now defaults to `x-api-key` on all MCP calls (breaks current installer flow). Arcade ships Production/Stable classifier, 34 official toolkits, MCP-native. Evidence: deepwiki ComposioHQ/composio + ArcadeAI/arcade-mcp, 2026-04-18. Confidence: 72%.

### ADD
- **CodeGraphContext** (CodeGraphContext/CodeGraphContext, ~3k stars, daily pushes). Serena gives symbol-level navigation; CGC fills the call-graph / cross-repo impact gap for refactor-safely. Evidence: `gh search repos code-graph-mcp`, 2026-04-18. Confidence: 70%.

### DROP
- (none)

### KEEP-BUT-UPGRADE
- **serena → v1.1.2** (2026-04-14). Breaking: `replace_regex` → `ReplaceContentTool`, line-replacement tools deprecated. PyPI/uv install rework — installer config must update. Added Haxe/Crystal/Lean4/OCaml/Zig/Nix/Dart/Kotlin/Solidity support. Evidence: deepwiki oraios/serena CHANGELOG v1.1.2. Confidence: 95%.
- **claude-mem → v12.2.0** (npm 2026-04-18). v11 introduced Semantic Context Injection (ChromaDB relevance replacing recency), Multi-Machine Sync (`claude-mem-sync` CLI), Strict Observer Contract (breaking — requires `<observation>` XML). Evidence: npm `claude-mem@12.2.0` + deepwiki thedotmack/claude-mem. Confidence: 90%.
- **github-mcp-server → v1.0.0** (2026-04-16). 1.0 GA. New granular tool `set_issue_fields` (flag `issues_granular`). MCP Apps UI promoted to `remote_mcp_ui_apps` flag. Evidence: `gh api repos/github/github-mcp-server/releases/tags/v1.0.0`, 2026-04-16. Confidence: 95%.
- **composio → `@composio/cli@0.2.25-beta.215`** (2026-04-18). Migrate off `deprecated.mcp` before removal; set `x-api-key` on every request. Evidence: deepwiki ComposioHQ/composio MCP auth changes. Confidence: 88%.
- **context-mode → v1.0.89** (npm 2026-04-14, maintainer mksglu). Confidence: 80%.

### SURPRISE
- **Context7 (upstash/context7, 53k stars)** is the actual mindshare leader vs. docfork — 5× stars, free tier. Worth head-to-head evaluation next installer rev. Evidence: `gh api repos/upstash/context7`, 2026-04-17.
- **claude-mem jumped 5 major versions in ~4 months** (v7 → v12). Pin-or-track decision needed — unpinned updates = breaking-contract risk.
- **composio pivoted to ToolRouter** (scoped sessions) over standalone MCP. Installer assumption is now stale.

### UNVERIFIED
- arcade-mcp vs composio head-to-head integration coverage (34 listed vs. "500+" claimed — no apples-to-apples count).
- docfork.com project health: not on GitHub under that name; npm `docfork-mcp` was unpublished 2025-06-05. Remote MCP with unknown upstream.
- context-mode upstream repo location.

---

## 2 — Claude Code plugins (13 plugins)

### SWAP
- **code-simplifier** (standalone) → **pr-review-toolkit** bundled `code-simplifier.md` agent. Duplicate — pr-review-toolkit ships the same agent plus 5 more (silent-failure-hunter, type-design-analyzer, pr-test-analyzer, comment-analyzer, code-reviewer). Evidence: `gh api .../plugins/pr-review-toolkit/agents`, 2026-04-18. Confidence: 90%.
- **feature-dev** (solo) → always orchestrate via our `ship-feature` skill (already installed). Direct invocation bypasses the review gate. Evidence: `~/.claude/skills/ship-feature/SKILL.md`. Confidence: 85%.

### ADD
- **obra/superpowers-marketplace** (855 stars, pushed 2026-04-18). Covers `episodic-memory`, `elements-of-style`, `claude-session-driver` — gaps Anthropic's official set leaves. Evidence: `gh api repos/obra/superpowers-marketplace`, 2026-04-18. Confidence: 75%.
- **VoltAgent/awesome-claude-code-subagents** catalog (17.6k stars) — Tier-3 `find-skills` lookup target when 6 pr-review-toolkit roles aren't enough. Evidence: `gh search repos`, 2026-04-18. Confidence: 75%.

### DROP
- **code-simplifier** (standalone plugin) — superseded by pr-review-toolkit's bundled agent (same file). Confidence: 90%.
- **playground** — self-contained HTML scratch tool, no workflow integration, last substantive commit 2026-01-29. Evidence: `gh api .../commits?path=plugins/playground`, 2026-04-18. Confidence: 70%.

### KEEP-BUT-UPGRADE
- **claude-hud @ v0.0.12** (2026-04-04) — pin to latest. Actively maintained (push 2026-04-18). Evidence: `gh api repos/jarrodwatts/claude-hud/releases`. Confidence: 85%.
- **plugin-dev** — current tip deprecates `commands/` in favor of `skills/<name>/SKILL.md` (2026-03-17). Verify local copy. Confidence: 80%.
- **session-report** — most actively developed official plugin (commits 2026-04-10). Ensure ≥2026-04-10 tip for per-day timeline feature. Confidence: 80%.

### SURPRISE
- Most official plugins are in **maintenance mode** since Feb 2026 — feature-dev, code-review, commit-commands, frontend-design, claude-md-management have only license/metadata commits. Stable, not abandoned.
- **frontend-design** is now a pure skill-bundle plugin (no `agents/`, only `skills/`) — treat as a Tier-1 skill source, not a subagent provider.
- **pr-review-toolkit** is the real workhorse of the official set (6 specialized reviewer agents).

### UNVERIFIED
- Whether `playground` has unreleased value in interactive HTML workflows — drop call is activity-based, could flip with a usage review.

---

## 3 — Custom skills (18 skills)

### SWAP
- **knowledge-base** — keep, but move "problem-solving dispatch" into a lightweight `when-stuck`-style skill. `obra/superpowers` ships `when-stuck` + `collision-zone-thinking` / `inversion-exercise` / `meta-pattern-recognition` as small composable thinkers; our single `knowledge-base` blurs research-ingest with stuck-unblocking. Evidence: deepwiki `obra/superpowers`, 2026-04-18. Confidence: 75%.

### ADD
- **`evals-first`** (new skill). Gap: nothing enforces "write an eval harness before shipping LLM-touching code/prompts." `obra/superpowers:writing-skills` + `wshobson/agents:eval-orchestrator`+`eval-judge` both ship this. Our `tdd-first` covers units, not prompt/agent regression. Evidence: deepwiki on both repos, 2026-04-18. Confidence: 85%.
- **`skill-authoring`** (new skill). Gap: we have no RED-GREEN-REFACTOR discipline for adding/modifying the 18 skills. `anthropics/skills:skill-creator` ships this officially; `obra/superpowers:writing-skills` enforces observed-failure-first. For a repo whose *product is skills*, this is the biggest gap. Confidence: 90%.
- **`pre-review-checklist`** (new skill). Gap: `obra/superpowers:requesting-code-review` + `receiving-code-review` enforce a pre-submit self-review gate. Our `ship-feature` leans on `pr-review-toolkit` post-hoc; nothing pre-submit. Confidence: 72%.

### DROP
- **setup** — 30-line wrapper around `bunx @youssefKadaouiAbbassi/yka-code-setup`. README covers it. Absorb into `onboard-codebase` as a "no `.claude/` dir detected" branch. Evidence: `skills/setup/SKILL.md` lines 1-30. Confidence: 80%.
- **release-cut** — defers to `claude-mem:version-bump`; CHANGELOG/tag/`gh release` chain is 5 lines the sub-skill already documents. Low activation in practice. Absorb into `ship-feature` as a final-phase option. Evidence: `skills/release-cut/SKILL.md`. Confidence: 70%.

### KEEP-BUT-UPGRADE
- **do** — add `evals-first` + `skill-authoring` (+ already-added `audit-rigor`) to the Phase-1 routing table. Confidence: 95%.
- **knowledge-base** — merge the Karpathy workflow with a `when-stuck` dispatcher (collision-zone / inversion / scale-game). Confidence: 75%.
- **team-do** — add `obra/superpowers:dispatching-parallel-agents` patterns (1% meta-rule for skill invocation) to the lead's pre-flight. Confidence: 70%.
- **worktree-task** — align with `using-git-worktrees` nested-detection logic (skip re-entry when already in a linked worktree). Confidence: 80%.

### SURPRISE
- Our **`do` front-door classifier is a genuine moat** — neither obra/superpowers, wshobson/agents, nor anthropics/skills ships one.
- **`ci-hygiene`, `loop-patterns`, `audit-rigor`, `coding-style`, `doc-hygiene`, `research-first`** have no direct counterparts in surveyed ecosystems — keep as differentiators.
- The 2026 center-of-gravity shift is **evals + skill-authoring discipline**, not more domain sub-skills. That's our biggest gap.

### UNVERIFIED
- Activation frequency of each skill in practice (no telemetry); DROP calls on `setup`/`release-cut` inferred from content thinness + overlap, not usage data.

---

## 4 — Hooks (19 hooks)

### SWAP
- **pre-secrets-guard.sh** (~123 LOC, 20+ regex families) → **gitleaks-as-hook** (pattern DB maintained, >150 providers, monthly updates). Our hand-rolled regexes lag: no Datadog, Figma, Shopify, Doppler, Vercel tokens; the "generic high-entropy" rule is false-positive-prone. Evidence: `hesreallyhim/awesome-claude-code` lists `parry` + gitleaks as dominant hook-layer scanners, 2026-04-18. Confidence: 85%.
- **post-lint-gate.sh** stderr-only advisory → **PreToolUse lint gate with `permissionDecision: "ask"`** for TS/Py/Rs changes. CC 2.1.76+ supports `"ask"` + `updatedInput` — enables suggest-fix UX instead of silent stderr. Evidence: deepwiki anthropics/claude-code, 2026-04-18. Confidence: 75%.

### ADD
- **`UserPromptSubmit`** hook — intercept prompt pre-execution; auto-inject `date -I` + current branch every turn, killing the training-cutoff bug class at source. Present in CC since pre-2.1.67. Confidence: 90%.
- **`InstructionsLoaded`** hook (v2.1.67+) — fires when `CLAUDE.md` / `.claude/rules/*.md` load; ideal for auditing stale rules + `tasks/lessons.md` freshness. We do this at `SessionStart`, a weaker signal. Confidence: 80%.
- **`SubagentStart` / `SubagentStop`** — enables `audit-rigor` skill-load preamble verification (did the subagent actually invoke research-first?) + per-subagent cost accounting. Confidence: 78%.
- **`PermissionRequest`** hook (v2.0.45+) — finer-grained than `PermissionDenied`; auto-approve read-only bash via AST (like `Dippy`) to cut prompt spam. Confidence: 72%.
- **`ElicitationResult`** hook (v2.1.76+) — we have `Elicitation` but not its result-intercept counterpart. Confidence: 70%.

### DROP
- **cwd-changed.sh** (23 LOC, log-only, no decision, zero consumers of the log). Observability bloat. Confidence: 85%.
- **teammate-idle.sh** (23 LOC, log-only to `team-tasks.log` that nothing consumes). Same pattern. Confidence: 80%.
- **task-completed.sh** (26 LOC, log-only, never exits non-zero). Promised "block completion on test fail" is a comment, not code. Dead weight. Confidence: 80%.
- **permission-denied.sh** — redundant once `PermissionRequest` lands (its audit log duplicates what PermissionRequest captures with more context). Confidence: 70%.

### KEEP-BUT-UPGRADE
- **pre-destructive-blocker.sh** — add `rm -rf ~`, `git push --mirror`, `kubectl delete ns`, `docker system prune -af`, `bun install --force` to the regex set. Evidence: common in `parry` / `Dippy` patterns, 2026-04-18. Confidence: 82%.
- **stop-research-check.sh** — lib regex hardcoded; move to `$HOME/.claude/research-libs.txt` so users extend without forking. Confidence: 75%.
- **pre-pr-gate.sh** — `.bash_history` probe is fragile (zsh extended-history only, Bun users use neither). Replace with `~/.claude/session-logs/<today>.log` scan for `bun test` / `pytest` invocations, already written by `session-start.sh`. Confidence: 78%.
- **session-start.sh** — fire-and-forget `npx autoskills` has no lockfile; parallel sessions race. Add `flock`. Confidence: 72%.

### SURPRISE
- Upstream added **`ElicitationResult`, `InstructionsLoaded`, `SubagentStart`, `WorktreeCreate/Remove`** in v2.1.50–2.1.89 — our `hooks.json` was written before these landed. Five genuine event gaps.
- `PreToolUse` now supports **`"ask"` + `updatedInput`** (not just allow/deny/defer) → unlocks suggest-fix UX `post-lint-gate` can't do today.

### UNVERIFIED
- Whether gitleaks has an officially-blessed Claude Code hook wrapper vs. rolling our own `gitleaks protect --staged` call. `awesome-claude-code` lists `parry` as dominant but doesn't confirm a gitleaks binding.

---

## 5 — CLI tools (16 CLIs)

### SWAP
- **jq → jaq or gojq**. jq 1.8.1 (2025-07-01, glacial pace); jaq is a faster Rust drop-in, gojq ships better errors. Evidence: `gh release view jqlang/jq 1.8.1`, 2025-07-01. Confidence: 70%.
- **container-use → upstream Dagger container runtime**. container-use v0.4.2 has had no release since 2025-08-19 (>6mo stale) despite Dagger owning it. Evidence: `gh release view dagger/container-use v0.4.2`. Confidence: 75%.

### ADD
- **ripgrep (rg)** — Grep tool is built on rg; users expect the binary for direct shell use. v14.1 stable. Confidence: 95%.
- **fd** (sharkdp/fd v10.4.2, 2026-03-10) — modern find replacement, pairs with rg. Confidence: 90%.
- **fzf** (junegunn/fzf 0.71.0, 2026-04-04) — interactive fuzzy selection; required by lazygit, atuin, git-bisect workflows. Confidence: 90%.
- **zoxide** (v0.9.9, 2026-01-31) — cd replacement; integrates with starship prompt. Confidence: 80%.
- **lazygit** (v0.55+, monthly cadence, 2026-04-16) — TUI git covers gaps gh CLI doesn't (interactive rebase, partial-hunk staging). Confidence: 80%.
- **bat** (v0.26.1, 2025-12-02) — syntax-highlighted cat; file-preview pipes. Confidence: 70%.
- **delta** (0.19.2, 2026-03-28) — side-by-side git diff; pairs with review workflows. Confidence: 70%.
- **uv** (astral-sh/uv 0.11.7, 2026-04-15) — Python standard 2026; CLAUDE.md already lists `uv` as preferred but installer doesn't provision it. Confidence: 95%.
- **bun** runtime (v1.3.12, 2026-04-10) — installer uses bun internally; shell also benefits. Confidence: 85%.

### DROP
- **ghostty** — still pre-1.0, no stable tagged releases (only `tip` nightly). Fits poorly as "the terminal we picked". Evidence: `gh release list ghostty-org/ghostty`, 2026-04-18. Confidence: 70%.

### KEEP-BUT-UPGRADE
- (none) — installer pulls latest at install time, no version pins.

### SURPRISE
- **mise is calver now** (v2026.4.16, 2026-04-17) — prior semver (2024.x) abandoned; date-pinning audits may misread staleness.
- **Snyk ships daily** (v1.1304.0 on 2026-04-09) — highest release cadence of the 16.
- **age stalled at v1.2.1 since 2024-07** — ecosystem moved to `rage` (Rust port) for CLI parity + speed. Candidate future SWAP, insufficient evidence to assert dominance today.

### UNVERIFIED
- jaq/gojq dominance over jq — staleness confirmed, but adoption numbers not verified; 70% recommends "evaluate", not "adopt".
- age → rage migration not verified upstream.

---

## 6 — LSPs (4 LSPs)

### SWAP
- (none)

### ADD
- **oxc_language_server** (optional, TS/JS co-install). Lint + format + type-aware lint in one fast Rust binary; complements tsserver. Evidence: oxc crates v0.126.0 (2026-04-16), oxlint v1.60.0 (2026-04-13). Confidence: 75%.

### DROP
- (none) — all four current LSPs actively maintained, releases within 6 months.

### KEEP-BUT-UPGRADE
All four install via `@latest` / `rustup component add` / `go install @latest` — provisioning is version-floating, upgrade is automatic on reinstall. No code change needed.
- **typescript-language-server v5.1.3** (2025-11-19). Confidence: 95%.
- **pyright 1.1.409** (2026-04-16). Confidence: 95%.
- **rust-analyzer 2026-04-13** (weekly stable). Confidence: 90%.
- **gopls v0.21.1**. Confidence: 90%.

### SURPRISE
- **tsgo (TypeScript Native Preview) LSP is NOT production-ready** — repo v0.0.0, extension labeled "preview", emit/watch/API incomplete, not at tsserver parity. Do NOT swap typescript-language-server yet. Evidence: deepwiki `microsoft/typescript-go`, 2026-04-18.
- **astral-sh/ty is Beta (v0.0.31)**, self-recommends for production since v0.0.2 (2025-12-16), ships working LSP (`ty server`) w/ completions / inlay hints / auto-import / goto. Viable pyright alt for early-adopter profile but pre-1.0 → hold.
- **biome-lsp CANNOT replace typescript-language-server** — Biome v2.4.12 (2026-04-14) does type-aware *linting* only, not full type diagnostics.
- **oxc LSP binary removed from `oxlint` npm pkg in v1.37.0** (2026-01-05) — distribution shifted to Rust crate + VS Code extension; CLI install path changed.

### UNVERIFIED
- Whether Kotlin/Zig/Swift/C++/Ruby LSPs are "load-bearing for AI-dev in 2026" — subjective usage-trend claim, no authoritative source.

---

## 7 — Shell rc additions (6 entries)

### SWAP
- **`eval "$(mise activate <shell>)"`** → keep for interactive but ADD shimmed PATH for subshells spawned by hooks. `mise activate` only fires on prompt redraw; CC hook subprocesses bypass it and miss tool versions. Evidence: deepwiki jdx/mise — interactive=`activate`, non-interactive/CI/hooks=`--shims` or `mise exec`, 2026-04-18. Confidence: 75%.
- **Sourcing plaintext `~/.config/yka-code/secrets.env`** → **`sops exec-env`** (age backend, already installed) wrapping CC launch, OR chezmoi-managed age file + on-demand decrypt. A plaintext env file with `GITHUB_PAT` / `COMPOSIO_API_KEY` / `DOCFORK_API_KEY` is the weakest link — chmod 600 doesn't protect from any user-owned process. Evidence: deepwiki getsops/sops "sops exec-env decrypts in memory, not persisted", 2026-04-18. Confidence: 80%.

### ADD
- **`export CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1`** — strips Anthropic + cloud creds from Bash/hooks/MCP subprocesses; Linux isolated PID namespace. The repo's own `core-install-health.sh` already flags absence as drift. Evidence: `code.claude.com/docs/en/env-vars`, added v2.1.83. Confidence: 95%.
- **`export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80`** — controls auto-compact trigger %; default ~95% fires too late at 1M context and thrashes. Evidence: CC docs, added v2.1.101. Confidence: 80%.
- **`export CLAUDE_CODE_AUTO_COMPACT_WINDOW=<tokens>`** — optional pair for 1M users who want compact tied to smaller effective window. Confidence: 72%.

### DROP
- (none)

### KEEP-BUT-UPGRADE
- **CLAUDE_CODE_ENABLE_TELEMETRY=1** — still documented opt-in gate for OTel export as of 2026-04-18. Confidence: 92%.
- **CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1** — KEEP, still experimental, name unchanged. Confidence: 92%.
- **starship init** — no faster alternative shipped. Confidence: 88%.
- **CAVEMAN_DEFAULT_MODE=full** — internal, no upstream drift. Confidence: 90%.

### SURPRISE
- **1M context is default-on for Max/Team/Enterprise** since CC v2.1.75 — the env var, if any, is `CLAUDE_CODE_DISABLE_1M_CONTEXT` (opt-out), not opt-in.
- **No env var exists for the Chrome / computer-use tool** — enabled per-session, not via rc.

### UNVERIFIED
- Agent-teams handoff persistence across `/exit` — no dedicated env var surfaced; not yet configurable.

---

## Cross-bucket priority roll-up (non-binding — based on confidence × impact)

**Do first** (breaking / confirmed drift):
1. Bump **serena to v1.1.2** — breaking tool rename, installer must update (95%).
2. Bump **claude-mem to v12.2.0** — strict-observer contract is breaking (90%).
3. Pin **github-mcp-server v1.0.0** — 1.0 GA landed (95%).
4. Add **`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1`** env var — closes a live cred-leak hole (95%).
5. Migrate **composio off `deprecated.mcp`** namespace before removal (88%).

**Do next** (close the visible gap):
6. Add **uv, ripgrep, fd, fzf, zoxide, bun** CLIs — current AI-dev baseline (85–95%).
7. Add **`UserPromptSubmit` hook** injecting `date -I` + branch — kills training-cutoff bugs (90%).
8. Add **`evals-first`** + **`skill-authoring`** custom skills — the 2026 skill-dev gap (85-90%).
9. Swap **code-simplifier (standalone) → pr-review-toolkit bundled agent** — remove duplicate (90%).
10. Migrate **secrets.env → `sops exec-env`** — close plaintext-secrets risk (80%).

**Evaluate** (worth a head-to-head):
- Composio → arcade-mcp (72%)
- docfork ↔ Context7 (53k stars, free tier — surprise finding)
- jq → jaq / gojq (70%)
- container-use → Dagger upstream (75%)

---

*Methodology: 7 parallel Agent() calls, each with karpathy-guidelines + research-first + audit-rigor loaded at their own Phase 0; MCPs-before-WebSearch; inline citations with ISO dates; ≥70% confidence threshold; word budget per bucket (400-600). Main chat context preserved for synthesis.*

---

## Decision matrix (ultrathink, 2026-04-18)

Every finding evaluated on: evidence quality, real cost/benefit, second-order effects, installer-complexity tax, redundancy.

### TIER 1 — do now
1. serena → v1.1.2 (breaking tool rename, 95%)
2. claude-mem → v12.2.0 (breaking observer contract, 90%)
3. composio auth migration (`x-api-key`, off `deprecated.mcp`) before removal (88%)
4. github-mcp-server → v1.0.0 (95%)
5. Add `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` (95%)
6. Add `UserPromptSubmit` hook injecting `date -I` + branch (90%)
7. Add uv, bun, ripgrep, fd, fzf CLIs (85–95%)
8. Drop `code-simplifier` standalone plugin — duplicate of pr-review-toolkit bundled agent (90%)
9. Add `skill-authoring` custom skill (90%)
10. Add `evals-first` custom skill (85%)

### TIER 2 — do soon
11. secrets.env → `sops exec-env` (age backend already installed) (80%)
12. `mise activate --shims` for hook subprocesses (75%)
13. post-lint-gate → PreToolUse `"ask"` mode, gated on CC ≥ 2.1.76 (75%)
14. SubagentStart hook verifying research-first preamble (78%)
15. gitleaks AUGMENT pre-secrets-guard (not replace); pre-secrets is pre-filter, gitleaks runs on stop-check (85%)
16. pre-destructive-blocker regex expansion (82%)
17. stop-research-check lib list → `~/.claude/research-libs.txt` (75%)
18. pre-pr-gate: replace `.bash_history` probe with session-log scan (78%)
19. session-start: `flock` on autoskills call (72%)
20. worktree-task nested-detection (80%)
21. Drop `cwd-changed` hook (log-only, zero consumers) (85%)
22. Add `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80` (80%)
23. Register obra/superpowers marketplace; cherry-pick `writing-skills`, `when-stuck` (75%)
24. Bump claude-hud v0.0.12, session-report tip, plugin-dev tip (80–85%)
25. context-mode → v1.0.89 (80%)

### TIER 3 — opt-in or conditional
- zoxide, lazygit — opt-in flag (personal preference)
- bat, delta — defer (nice-to-have, not baseline)
- oxc_language_server — defer (LSP-process bloat unless explicitly wanted)
- task-completed hook: implement real block-on-test-fail OR drop
- teammate-idle hook: verify consumers first; drop only if truly dead
- Update `do` routing table for evals-first + skill-authoring (once they exist)

### TIER 4 — REJECTED (with reasoning)
- **composio → arcade-mcp SWAP** — 72%, breaks live OAuth. Upgrade composio instead.
- **CodeGraphContext ADD** — serena covers semantic impact.
- **jq → jaq/gojq** — 70% + universal muscle memory = churn tax.
- **container-use → Dagger direct** — stale ≠ broken; watch only.
- **Context7 swap** — docfork works; star count ≠ switch justification.
- **playground plugin DROP** — 70% + unverified value + zero keep-cost.
- **ghostty DROP** — installed, works, install flow just fixed.
- **setup skill DROP** — pointer skills have discoverability value.
- **release-cut skill DROP** — orchestration is the value.
- **knowledge-base restructure** — refactor without clear win.
- **pre-review-checklist skill** — either redundant with ship-feature or should be a pre-commit hook.
- **PermissionRequest hook** — fewer-permission-prompts skill covers this.
- **ElicitationResult hook** — no use case articulated.
- **InstructionsLoaded hook** — SessionStart covers stale-rule audits.
- **VoltAgent subagents mass-install** — document as Tier-3 target instead.
- **permission-denied hook DROP** — was conditional on PermissionRequest adoption (rejected).
- **age → rage** — unverified.

### Cross-cutting decisions
- **Version-floating vs pinning**: pin MCP *servers* (breaking-change-prone) via lock file; float boring CLIs. Installer's blanket `@latest` is why breaking drifts surfaced in this audit.
- **Additive > replacement** everywhere: keep composio + docfork + pre-secrets-guard, augment rather than swap. Swapping breaks live user state.
- **Moats to protect**: `do`, `audit-rigor`, `coding-style`, `ci-hygiene`, `loop-patterns`, `research-first`, `doc-hygiene` have no ecosystem counterparts. Invest, don't replace.

Tier-1 items cluster into three PR-sized batches:
- **Batch A: MCP bumps + auth migration** (items 1–4)
- **Batch B: Env hardening + new hook + CLI baseline** (items 5–7)
- **Batch C: Skills + plugin cleanup** (items 8–10)

Tier-2 items mostly fit under `fix-bug` / `refactor-safely` tickets against the installer components (`security.ts`, `workflow.ts`, `workstation.ts`).
