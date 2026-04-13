# Architecture 06 — The Complete Claude Code Coding System (April 2026)

*Architect 6 of 10. Independent research. Budget constraint: Max subscription $200/mo + free tooling only.*

---

## 1. Master Tool Table

| # | Category | Tool | What it does | Why THIS one |
|---|----------|------|-------------|--------------|
| 1 | **Base CLI** | **Claude Code (Anthropic)** v2.1.101 | Agentic coding CLI: edit, bash, MCP, hooks, plugins, skills, teams, worktrees, monitor | The kernel. Everything else orbits it. Opus 4.6 engine, 1M context, native sandbox. No substitute. |
| 2 | Base CLI — Advisor | **Advisor Tool** (beta `advisor-tool-2026-03-01`) | Server-side fast-executor + high-intelligence-advisor in single API call | 85% cost reduction vs Opus-solo. Haiku+Opus = 41.2% SWE-bench ML vs 19.7% Haiku alone. Collapses the "route by model" pattern into a primitive. |
| 3 | Base CLI — `ant` CLI | **`anthropics/anthropic-cli`** | GitOps for Managed Agents, versioning API resources in YAML | First-party CLI for agent infra-as-code. No third-party alternative exists at this level. |
| 4 | **Managed Agents** | **Claude Managed Agents** (beta `managed-agents-2026-04-01`) | Fully managed harness: secure sandbox, durable event sourcing, SSE streaming, scoped permissions | $0.08/session-hour. Anthropic runs the infra. "Stateless Harness + Durable Event Sourcing" is the canonical architecture pattern per Anthropic's own engineering post. |
| 5 | **Agent Orchestration** | **Agent Teams** (native, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) | Built-in multi-agent with `teammateMode: tmux`, named agents, shared task list | Native > external. No install, no shim, no config drift. Requires v2.1.32+. |
| 6 | Agent Orchestration — External | **oh-my-claudecode** (4.5k stars) | Teams-first orchestration: autopilot, ralph, ultrawork, specialized agents, skills | Richest discipline framework. Fills gaps Teams doesn't cover yet: tiered agent catalog, commit protocol, skill registry, verification pipeline. |
| 7 | Agent Orchestration — Parallel | **Claude Squad** (8k stars) | TUI managing multiple CC sessions in isolated git worktrees | Best pure-terminal multi-agent UX. Composes with Agent Teams — Squad manages panes, Teams manages coordination. |
| 8 | **Skill Library** | **wshobson/agents** (33.4k stars, MIT) | 182 agents, 16 orchestrators, 149 skills, 96 commands, 77 plugins + PluginEval framework | Largest CC agent/skill ecosystem. PluginEval (static + LLM judge + Monte Carlo, Wilson/Clopper-Pearson CI, Elo ranking) is the ONLY skill quality measurement framework. Tier 1 by both star count and ecosystem leverage. |
| 9 | Skill Library — Security | **Trail of Bits skills** (800 stars) | 12+ security-focused skills for code auditing | Professional security pedigree. No other skill set has this domain authority for security. |
| 10 | Skill Library — Workflow | **Superpowers** (1k stars) | Core software engineering competencies bundle | Solid baseline. BUT: Skill-Usage-Bench (arxiv 2604.04323) shows library-accumulation gains collapse in realistic retrieval. Use as starter, then refine with PluginEval, don't hoard. |
| 11 | **Plugin Framework** | **Claude Plugins** (101 official marketplace) | Extend CC with bundled MCP servers, skills, hooks | First-party. Plugins can now ship executables under `bin/` (v2.1.91, auto-added to Bash PATH). |
| 12 | **MCP — Code Intelligence** | **Serena** v1.1.0 (Apr 11 2026) | LSP-powered semantic code navigation across 30+ languages | LSP > grep > RAG for code understanding. Zero subscription cost. Install: `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` (NOT the deprecated uvx command). |
| 13 | MCP — Code Intelligence | **ast-grep** (13.4k stars) + `ast-grep/ast-grep-mcp` | Structural-pattern search over 20+ languages via tree-sitter | Complements Serena: ast-grep finds patterns, Serena navigates symbols. Different search dimensions. |
| 14 | MCP — Code Intelligence | **probelabs/probe** (537 stars, MIT) | ripgrep + tree-sitter AST + MCP server, returns compact ranked spans | Lightest-weight code intelligence MCP. When Serena is too heavy, probe fills the gap. |
| 15 | **MCP — GitHub** | **github/github-mcp-server** (Go rewrite) | PRs, issues, repo management, code scanning, Projects, `get_me`, OAuth scope filtering | Official. 51+ tools. Rewritten in Go since Jan 28 2026. |
| 16 | **MCP — Browser** | **Playwright MCP** (`@playwright/mcp`) | 25+ browser control tools via accessibility snapshots, not screenshots | Accessibility-tree approach = token-efficient, reliable. Official Anthropic plugin. CLI variant uses YAML snapshots for 4x fewer tokens. |
| 17 | **MCP — Documentation** | **Context7** (`@upstash/context7-mcp`) | Live, version-accurate library documentation from source repos | Solves the #1 practical problem: Claude using outdated API signatures. Now requires `--api-key` from `context7.com/dashboard`. |
| 18 | **MCP — Database** | **Supabase MCP** | Full Supabase access: DB, auth, storage, edge functions | 20+ tools. Official plugin. If you're on Supabase, nothing else comes close. |
| 19 | MCP — Database (multi) | **googleapis/mcp-toolbox** v0.30.0 | BigQuery + AlloyDB + Spanner + CloudSQL + Postgres + MySQL | Official Google. Covers enterprise GCP database gap no other single server fills. |
| 20 | **MCP — Payments** | **Stripe MCP** (`mcp.stripe.com`) | 25 tools covering full payment lifecycle | Official Anthropic partner. Remote HTTP. No local install. |
| 21 | **MCP — Error Monitoring** | **Sentry MCP** (`mcp.sentry.dev/mcp`) | Error monitoring, stack traces, performance data | Remote HTTP with OAuth. NOT stdio anymore. Also available as Claude plugin. |
| 22 | **MCP — Observability** | **Datadog MCP** (`mcp.datadoghq.com`) | 16+ tools: logs, metrics, traces, incidents, optional APM/LLM Observability | GA Mar 10 2026. Fills gap left by archived PostHog/mcp. Official Datadog remote MCP. |
| 23 | **MCP — Design** | **Figma MCP** (official Anthropic partner) | Design-to-code, canvas manipulation, component inspection | Official partner integration. Design-to-code is a solved workflow with this. |
| 24 | **MCP — Deployment** | **Vercel MCP** (`mcp.vercel.com`) | Deployment logs, project metadata, management | Official remote with OAuth + Streamable HTTP. |
| 25 | **MCP — Memory (vector)** | **mempalace** (23k stars, MIT) | 19 MCP tools, 96.6% LongMemEval, hippocampal architecture, offline | Highest benchmark score among free tools. 170-token startup. Zero API calls. Offline-first. MIT. |
| 26 | MCP — Memory (plugin) | **claude-mem** (46.1k stars) | Auto-capture, compress, inject context across sessions | Purpose-built for CC plugin architecture. Hooks into session lifecycle natively. |
| 27 | **MCP — Security Gateway** | **agentgateway/agentgateway** (2.4k stars, Linux Foundation, Rust) | Proxy built natively on BOTH MCP and A2A protocols | Open-standard mesh fabric. Linux Foundation project. The canonical MCP security layer. |
| 28 | MCP — Security Scanning | **mcpshield/mcpshield** | Supply-chain scanner: typosquats, CVEs, credential leaks, dangerous permissions | 23 attack vectors, 4 surfaces, 177k+ tools analyzed. Single-layer defenses cover only 34%; integrated reaches 91%. |
| 29 | **MCP — Diagrams** | **Mermaid Chart** (official connector) | Diagram validation and rendering | Official. Mermaid is the lingua franca for agent-generated diagrams. |
| 30 | **MCP — IaC** | **Terraform MCP** (HashiCorp official) | Terraform Registry and Cloud APIs | Official HashiCorp. For IaC-heavy workflows. |
| 31 | **MCP — Cloud** | **Cloudflare MCP** | 2,500 API endpoints compressed into ~1k tokens | Impressive context engineering. Workers, Pages, DNS, KV. |
| 32 | **MCP — Project Mgmt** | **Linear MCP** (`mcp.linear.app`) | Issue tracking, project boards | Official remote. Best for modern eng teams already on Linear. |
| 33 | **Hooks — Notification** | **ntfy.sh** (29.7k stars, Apache/GPL, self-hostable) + `claude-ntfy-hook` | Push notifications with interactive Allow/Deny phone buttons | Pairs with `"defer"` permission (v2.1.89). Without notification channel, `defer` has no surface. With ntfy, headless CC pauses at boundaries, pings phone, resumes on approval. 0.4% false positive rate confirmed by Anthropic. |
| 34 | Hooks — Notification (alt) | **claude-notifications-go** | Cross-platform: sound, macOS alerts, voice, ntfy, Slack, Telegram webhooks | 6 notification types, click-to-focus, zero deps. Broader than ntfy alone. |
| 35 | **Cross-Vendor Code Review** | **CodeRabbit** (2M+ repos, 13M+ PRs) | AI code review: BYOK routing to non-Claude models | Different model family reviewing Claude's output = real writer/reviewer independence at the model-diversity level. Fast feedback, low false positives (2 per benchmark run). |
| 36 | Cross-Vendor Review (alt) | **Greptile** ($30/user/mo) | Full codebase graph indexing, cross-file dependency tracing | 82% bug catch rate (highest in benchmarks). More false positives than CodeRabbit. Choose for security-critical reviews. |
| 37 | **Autonomous Agent** | **OpenHands** (71k stars, MIT) v1.6.0 | Walk-away coding agent with own loop, sandbox, PR creation | 72-77% SWE-bench Verified. Self-hostable. Model-agnostic. For "give it a ticket, come back later" workflows. |
| 38 | **Observability** | **Langfuse** v3 (self-host) / v4 (cloud preview) | LLM observability: traces, token usage, latency, cost analysis | Open source. v3 self-host requires MinIO (cannot drop). v4 cloud is 10x faster dashboards. Claude Agent SDK has native Langfuse integration. |
| 39 | Observability — Lightweight | **claude-code-otel** + any OTEL backend | OpenTelemetry for CC usage/costs: metrics, events, traces | Native CC OTEL export (`CLAUDE_CODE_ENABLE_TELEMETRY=1`). Pipe to Grafana/Honeycomb/Datadog. No extra wrapper needed. |
| 40 | **LLM Gateway** | **LiteLLM** (43k stars, MIT) v1.83.x+ | Proxy routing across 140+ providers with budget caps, audit log | Only gateway Anthropic officially documents for CC (`ANTHROPIC_BASE_URL=http://0.0.0.0:4000`). **CRITICAL: pin to v1.83.x+. v1.82.7-8 were PyPI supply-chain compromised.** |
| 41 | **CI/CD** | **anthropics/claude-code-action** @v1 (v1.0.93) | GitHub Action: PR review, code fixes, triage, headless agent mode | Official. Full CC runtime inside GitHub Actions runner. Under $5/mo for 50 PRs. Sonnet reviews < $0.10 each. |
| 42 | CI/CD — Security | **anthropics/claude-code-security-review** | Security-focused GitHub Action | Official. Opus 4.6 engine, 500+ vulns found. Separate from general review for defense-in-depth. |
| 43 | **Sandbox — Native** | **Linux subprocess sandbox** (v2.1.98, stable) | PID namespace isolation + seccomp, production-ready | Native. Zero install. Production-stable since Apr 9 2026. First choice for local dev. |
| 44 | Sandbox — Docker | **Docker Sandboxes** (official) | MicroVM-based isolation via Docker | For when native sandbox isn't enough: untrusted code, destructive operations. |
| 45 | Sandbox — Cloud | **E2B** (open-source, Firecracker) | 150ms cold boot cloud sandboxes | For CI/headless: ephemeral sandboxes that spin up fast. 15M+ sessions/month ecosystem. |
| 46 | Sandbox — Cloud (persistent) | **Fly Sprites** (Firecracker) | 100GB NVMe, 8 CPU default, ~300ms checkpoint/restore | For persistent sessions. `--skip-console` flag for CI/scripted use. No `--cpu`/`--disk` flags — those are platform defaults. |
| 47 | **Build Loop** | **mise** (26.6k stars, MIT) v2026.4.8 | Replaces asdf + nvm + pyenv + direnv + make in one binary | `.mise.toml` checked in = reproducible tool versions for Claude's Bash. Task runner now at Turborepo/Nx feature parity. Language-agnostic. |
| 48 | Build Loop — Tasks | **just** (32.8k stars) | Simple command runner with `justfile` | Simplest hook target. Claude-readable for self-documentation. Composable with mise. |
| 49 | Build Loop — Monorepo | **Turborepo** (30.2k stars, Rust) v2.9.6 | `turbo run build --filter=...[HEAD]` limits rebuild to changed files | For JS/TS monorepos. `--filter=...[HEAD]` is the key: only rebuild what Claude changed. |
| 50 | Build Loop — File Watch | **watchexec** (6.8k stars, Apache-2.0) | File-watch trigger that closes edit-compile loop between Claude turns | Deterministic feedback: Claude edits, watchexec runs tests, Claude reads results. No polling. |
| 51 | **Cost Monitoring** | **Native `/cost`** (v2.1.92) | Per-model + cache-hit cost breakdown | First-class since Apr 4 2026. Native > external. `ccusage`/`ccflare` are now supplementary. |
| 52 | Cost — Dashboard | **ccflare** / **better-ccflare** | Web UI usage dashboard with Docker support | For historical analysis and team-wide views that `/cost` doesn't cover. |
| 53 | **Context Compression** | **claude-token-efficient** (Universal CLAUDE.md) | System-prompt shaping for output verbosity reduction | 471 HN points. Highest-scoring context-compression approach in the scout window. Different surface than runtime compressors. |
| 54 | Context — Runtime | Native `/compact` | Proactive context summarization at milestones | Built-in. Run after completing major milestones, not when context fills. Customize what survives via CLAUDE.md instructions. |
| 55 | **Session Recording** | **claude-replay** | Convert CC sessions to interactive HTML replays | Best for post-mortems and knowledge sharing. |
| 56 | **Config Linting** | **agnix** (agent-sh) | Comprehensive linter for CC agent files with IDE plugins | Catch config errors before they burn tokens. |
| 57 | **Skill Quality** | **PluginEval** (inside wshobson/agents) | Static + LLM judge + Monte Carlo skill evaluation | `uv run plugin-eval score/certify/compare`. The ONLY rigorous measurement framework for skills. Essential given Skill-Usage-Bench finding that accumulation doesn't help. |
| 58 | **Durable Execution** | **Absurd** (`earendil-works/absurd`) | Postgres-only durable execution, TS/Python/Go SDKs, Habitat dashboard | 5 months production. Postgres-only = no Temporal infrastructure. For LLM agent loop checkpointing. Ronacher-endorsed (April 4 post). |
| 59 | **Ralph Loop** | **ralph-orchestrator** (2.5k stars, MIT) | Canonical external loop-runner implementing Ralph Wiggum technique | The "keep going until done" autonomous loop. Composable with Claude Squad (Ralph as loop, Squad as pane manager). |
| 60 | **IDE** | **claude-code.nvim** (Neovim) / **VS Code Chat** / **claude-code.el** (Emacs) | IDE integration for preferred editor | Pick your editor. All work. The CLI is the brain; IDE is the window. |

---

## 2. settings.json

```jsonc
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",

  // Model — use `model` not `defaultModel`
  "model": "claude-opus-4-6",
  "effortLevel": "high",
  // NOTE: v2.1.94 changed default from medium -> high for API/Team/Enterprise users.
  // For Max subscription, manually set to high. For cost-sensitive work, drop to medium.

  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Edit(*)",
      "Write(~/.claude/**)",
      "Write(.omc/**)",
      "Write(.claude/**)",
      "Write(CLAUDE.md)",
      "Write(AGENTS.md)",
      "MultiEdit(*)",
      "Read(*)",
      "Glob(*)",
      "Grep(*)",
      "Bash(git *)",
      "Bash(npm *)",
      "Bash(npx *)",
      "Bash(pnpm *)",
      "Bash(bun *)",
      "Bash(uv *)",
      "Bash(mise *)",
      "Bash(just *)",
      "Bash(turbo *)",
      "Bash(cargo *)",
      "Bash(go *)",
      "Bash(python *)",
      "Bash(node *)",
      "Bash(deno *)",
      "Bash(gh *)",
      "Bash(jq *)",
      "Bash(curl *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(mkdir *)",
      "Bash(cp *)",
      "Bash(mv *)",
      "Bash(find *)",
      "Bash(rg *)",
      "Bash(watchexec *)",
      "Bash(docker *)",
      "WebFetch(*)",
      "WebSearch(*)",
      "mcp__github__*",
      "mcp__context7__*",
      "mcp__serena__*",
      "mcp__playwright__*",
      "mcp__mempalace__*"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(rm -rf ~)",
      "Bash(sudo *)",
      "Bash(chmod 777 *)",
      "Bash(curl * | bash)",
      "Bash(wget * | bash)",
      "Bash(kill -9 *)"
    ]
  },

  // Hooks
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"decision\": \"allow\"}'"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "mise run format 2>/dev/null || true"
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "claude-ntfy-hook notify \"$CLAUDE_NOTIFICATION_TITLE\" \"$CLAUDE_NOTIFICATION_BODY\""
          }
        ]
      }
    ]
  },

  // Telemetry
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1"
    // NOTE: ENHANCED_TELEMETRY_BETA gates distributed traces only.
    // Do NOT add unless you explicitly want the beta.
  }
}
```

**Key traps avoided:**
- `model` not `defaultModel`
- `permissions.defaultMode: "acceptEdits"` not `autoAccept`
- MCP servers go in `.mcp.json` or `~/.claude.json`, NEVER in `settings.json`
- `CLAUDE_CODE_ENABLE_TELEMETRY=1` alone is sufficient for basic metrics. `ENHANCED_TELEMETRY_BETA` is a separate beta opt-in.
- `effortLevel: "high"` is now the default for API/Team/Enterprise since v2.1.94 but NOT for Pro/Max subscription users — set it explicitly.

---

## 3. CLAUDE.md (< 100 lines)

```markdown
# Project Instructions

## Identity
You are working in a Claude Code-powered development environment.
Every token in this file costs context — keep instructions actionable, not descriptive.

## Code Style
- TypeScript: strict mode, no `any`, prefer `const`, named exports
- Use existing patterns in the codebase. Read before writing.
- No speculative abstractions. Three similar lines > premature helper.
- No trailing summaries. No emoji unless asked. Terse responses.

## Architecture
- Front-load design: write research.md + plan.md before code
- Writer != reviewer. Never self-approve. Use cross-model review.
- Verify outcomes before claiming completion. Evidence > assertion.

## Git
- Atomic commits. Conventional commits format.
- Never amend published commits. Never force-push main.
- Never skip hooks (--no-verify). Fix the hook, don't bypass it.
- Stage specific files, not `git add -A`.

## Testing
- Write tests for new functionality. Run tests before committing.
- Integration tests hit real backends, not mocks (unless unit-testing pure logic).
- If UI changed, visually verify in browser before reporting done.

## Safety
- Never commit .env, credentials, or secrets.
- No `rm -rf` without confirmation. No `sudo`.
- No `curl | bash` for untrusted sources. Pin dependency versions.
- Validate at system boundaries only. Trust internal code.

## MCP Servers Available
- GitHub: repo, PR, issue management
- Serena: LSP-based code navigation (30+ languages)
- Context7: live library documentation
- Playwright: browser automation via accessibility tree
- MemPalace: persistent cross-session memory
- Datadog: observability (logs, metrics, traces)

## Build & Task Commands
- `mise run build` — build the project
- `mise run test` — run test suite
- `mise run lint` — lint check
- `mise run format` — auto-format
- `just check` — pre-commit validation
- `turbo run build --filter=...[HEAD]` — rebuild only changed packages

## Compaction
When compacting, always preserve:
- Full list of modified files
- Test commands and their results
- Current task context and plan state
- Any error messages being investigated

## Cost Discipline
- Use /compact after completing milestones, not when context fills
- For exploratory tasks, start with effortLevel medium
- For implementation, use effortLevel high
- Check /cost periodically. Budget: aim for <$5/task on Sonnet, <$15 on Opus
```

**Design rationale:** 62 lines. Every line is an instruction Claude needs on every session. No architecture docs (those belong in code/docs), no tool descriptions (Claude already knows its tools), no personality directives (waste of tokens). The build commands section is the highest-ROI section — it eliminates the "how do I run tests?" discovery loop every session.

---

## 4. .mcp.json

```jsonc
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "serena": {
      "command": "serena",
      "args": ["start-mcp-server", "--context", "ide-assistant", "--project", "."]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    },
    "mempalace": {
      "command": "mempalace",
      "args": ["serve"],
      "env": {
        "MEMPALACE_STORAGE": "${HOME}/.mempalace"
      }
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    },
    "datadog": {
      "type": "http",
      "url": "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp"
    },
    "stripe": {
      "type": "http",
      "url": "https://mcp.stripe.com"
    },
    "linear": {
      "type": "http",
      "url": "https://mcp.linear.app"
    },
    "vercel": {
      "type": "http",
      "url": "https://mcp.vercel.com"
    }
  }
}
```

**Design decisions:**
- **5 local stdio servers** (GitHub, Serena, Context7, Playwright, MemPalace) — these are the daily drivers. Always loaded.
- **5 remote HTTP servers** (Sentry, Datadog, Stripe, Linear, Vercel) — zero local install, no subprocess overhead. Use Tool Search for lazy-loading (85-95% context reduction).
- **Secrets via env vars** (`${GITHUB_TOKEN}`, etc.) — never hardcoded. Use `.env` or shell profile.
- **Total: 10 servers.** Anthropic recommends 5-6 for responsiveness. Tool Search lazy-loading makes 10 viable because only needed tools load into context.
- **Serena uses the new install path** (`uv tool install -p 3.13 serena-agent@latest --prerelease=allow`), not the deprecated uvx command.
- **PostHog MCP is absent** — it was archived Jan 19 2026. Datadog fills the gap.
- **Sentry is remote HTTP** — not stdio. The old stdio approach is deprecated.

---

## 5. Top 10 Principles

### Principle 1: Verification is the bottleneck, not generation
Generation is free. Verification is expensive. Every task must end with evidence of correctness, not a claim. The writer and reviewer must be separated — not just by prompt context, but by model family (CodeRabbit/Greptile reviewing Claude's output). Structured-output self-reflection produces "formatting traps" — syntactic alignment masking semantic errors (arxiv 2604.06066). Use prose-level judgment, not schema validation, as the verification signal.

### Principle 2: Front-load design, defer nothing
AI acceleration of implementation CAUSES design-decision deferral — you never slow down for the hard call. That deferral corrodes architecture. If the first artifact of a task is code, the task is already broken. Write `research.md` first (what we know, what we don't, alternatives considered), then `plan.md` (decisions, non-goals, explicit tradeoffs), THEN code. Simon Willison, Boris Tane, and Maganti converge on this independently. A working prototype with wrong architecture costs more than no prototype.

### Principle 3: Native primitives win when they're real
Advisor Tool collapsed "route Opus for planning, Sonnet for execution" into a server-side primitive. `defer` collapsed "build an approval webhook" into a hook return value. Agent Teams collapsed "install an orchestrator" into a flag. Before installing any third-party tool, check if Anthropic shipped a native equivalent in the last 30 days. Re-evaluate monthly against the changelog, not quarterly.

### Principle 4: Skill accumulation has diminishing returns; refinement is the lever
Skill-Usage-Bench (arxiv 2604.04323, 34k real-world skills): skill-library gains collapse to near-zero in realistic retrieval. Opus 4.6 goes 57.7% -> 65.5% on Terminal-Bench 2.0 only with query-specific refinement, NOT library size. Don't "install 10+ awesome-lists." Measure per-skill outcomes with PluginEval. Delete skills that don't improve outcomes. Split-test with/without each skill.

### Principle 5: Parallelism is powerful but has an Anxiety Tax
Three named anti-patterns from Osmani (April 7 2026): Comprehension Debt (you can't understand what 5 agents did simultaneously), Ambient Anxiety Tax (uncertainty about what's happening in parallel), Trust Calibration Overhead (assessing each agent's output quality). Operational rule: start with one fewer agents than feels comfortable. The 3-5 agent band is right; pick from the low end.

### Principle 6: Sandbox isolation is non-optional, and single-layer is insufficient
MCPSHIELD: single-layer MCP defenses cover only 34% of threats; integrated reaches 91%. ShieldNet: F1=0.995 at 0.8% FP for supply-chain poisoning detection. Project Glasswing Mythos: one confirmed agent-escape incident despite restrictions. Use layered defense: native Linux sandbox (PID namespace + seccomp, production-stable v2.1.98) + MCP gateway (agentgateway) + supply-chain scanner (mcpshield) + network monitoring.

### Principle 7: Cost is a design constraint, not a monitoring metric
Default effortLevel changed from medium to high in v2.1.94 for API/Team/Enterprise users. Any cost model built on medium-default is stale. Use `/cost` (native since v2.1.92) as a feedback signal. Budget per task, not per month. Sonnet for exploration (<$5/task), Opus for implementation (<$15/task), Advisor Tool for the sweet spot (Haiku executor + Opus advisor = 85% cost reduction). The Max subscription ($200/mo) is the ceiling — CI must use API billing (Anthropic enforced this April 4 2026, cutting subscription access for Cline/Cursor/Windsurf/OpenClaw).

### Principle 8: The supply chain is your weakest link
Winchester Mystery House (Breunig, March 26) + Cathedral and the Catacombs (Nesbitt, April 6): AI-generated codebases have no human reader who would notice a compromised transitive dependency. AI commits averaging ~1,000 net lines, 2 orders of magnitude above human rate. The LiteLLM PyPI compromise (v1.82.7-8, March 2026) is the concrete proof. Pin versions. Generate SBOMs continuously (syft, cyclonedx). Never `curl | bash` from untrusted sources. Run mcpshield on your `.mcp.json`.

### Principle 9: Destructive operations need structural gates, not advisory warnings
Replit 2.5-year wipeout (Claude Code), SaaStr/Replit production DB deletion (July 2025, code freeze). Two independent events, same failure class: an agent with destructive capability in a context where "be careful" was the only guard. Use `deny` rules in settings.json, `PreToolUse` hooks that block `rm -rf` / `DROP TABLE` / `git push --force`, and sandbox isolation. Never rely on prompt instructions to prevent destructive actions.

### Principle 10: The inner loop is the multiplier
The edit-compile-test loop between Claude turns is where time compounds. If Claude edits a file and waits for you to run tests, that's a blocking human handoff. Close the loop: `mise` for reproducible tool versions, `just` for one-command test/lint/format, `watchexec` for file-watch triggers, `turbo --filter=...[HEAD]` for incremental builds. Every second shaved from the inner loop multiplies across hundreds of Claude turns per session.

---

## 6. What Most People Miss

### 1. The Advisor Tool changes everything and almost nobody knows yet
The Advisor Tool (beta since April 9 2026) is a server-side primitive that pairs a fast executor (Haiku/Sonnet) with a high-intelligence advisor (Opus) in a single API call. Haiku+Opus scored 41.2% on SWE-bench Multilingual vs 19.7% Haiku solo at 85% lower cost per task. This collapses the entire "route by model intelligence" orchestration pattern into a native primitive. Most practitioner setups are still manually doing what the Advisor Tool does natively. Check it: `advisor-tool-2026-03-01` beta header.

### 2. MCP security is a real gap, not a theoretical one
Everyone installs MCP servers. Almost nobody audits them. MCPSHIELD analyzed 177k+ MCP tools and found that no single defense mechanism covers more than 34% of the threat landscape. ShieldNet can detect supply-chain poisoned tools at F1=0.995. The LiteLLM PyPI compromise proved this isn't theoretical. Run `mcpshield` on your `.mcp.json`. Put `agentgateway` in front of your MCP connections. This is the category v3 of the blueprint missed entirely.

### 3. `defer` + ntfy = headless Claude Code that pings your phone
Most people run Claude Code interactively. The `defer` permission decision (v2.1.89) lets headless CC sessions pause at tool-call boundaries. Paired with ntfy.sh and `claude-ntfy-hook`, you get: Claude runs autonomously → hits a permission boundary → sends push notification to your phone → you tap Allow/Deny → Claude resumes. Anthropic confirmed 0.4% false positive rate. This is the "walk away and come back" pattern people want from Devin, built from free primitives.

### 4. Skill libraries don't scale — measurement does
The instinct is to install every awesome-list skill collection. Skill-Usage-Bench (34k skills, arxiv 2604.04323) proved that library size gains collapse in realistic retrieval. The lever is measurement: use PluginEval (`uv run plugin-eval score/certify/compare`) to evaluate each skill across 10 quality dimensions. Delete skills that don't pay rent. The Karpathy LLM Wiki pattern (Obsidian Markdown as compiled knowledge base with BM25/vector search) is a refinement-based alternative to skill accumulation.

### 5. The effort-level default changed and your cost model is stale
v2.1.94 (April 7 2026) changed the default `effortLevel` from `medium` to `high` for API-key, Bedrock, Vertex, Foundry, Team, and Enterprise users (NOT Pro/Max subscription). If you noticed your bill spike in the last week, this is why. Set it explicitly in settings.json. Use `medium` for exploration, `high` for implementation, and monitor with native `/cost`.

### 6. PostHog MCP is dead, Serena's install command changed, Sentry is remote now
Three stale commands that are copy-pasted across hundreds of guides:
- **PostHog/mcp** was archived January 19 2026. Use Datadog MCP instead.
- **Serena** deprecated the old `uvx --from git+...` command. New: `uv tool install -p 3.13 serena-agent@latest --prerelease=allow`. v1.1.0 shipped April 11 2026.
- **Sentry MCP** moved to remote HTTP OAuth at `https://mcp.sentry.dev/mcp`. No local install needed. The old stdio approach is gone.

### 7. The inner loop is invisible but load-bearing
Most Claude Code setups focus on what Claude can DO (skills, MCP servers, plugins). Almost nobody optimizes what happens BETWEEN Claude's turns. `mise` (replaces asdf+nvm+pyenv+direnv+make), `just` (simplest command runner), `watchexec` (file-watch trigger), `turbo --filter=...[HEAD]` (rebuild only what changed). These are boring tools that don't trend on GitHub, but they're where the 10x multiplier actually lives. If Claude has to ask "how do I run tests?" or wait for you to confirm a build, the system is broken.

### 8. ANTHROPIC_API_KEY must be empty string, not unset, for gateway proxies
Subtle trap: when using Vercel AI Gateway or LiteLLM as a proxy, you must set `ANTHROPIC_API_KEY=""` (empty string), NOT leave it unset. Claude Code checks `ANTHROPIC_API_KEY` first and will use it if non-empty, bypassing the gateway entirely. This is documented nowhere except the Vercel AI Gateway docs and is the #1 support issue for gateway users.

### 9. The subscription enforcement event (April 4 2026) is architecturally load-bearing
Anthropic explicitly cut subscription access for Cline, Cursor, Windsurf, and OpenClaw on April 4 2026. This isn't a policy tweak — it's enforcement. If your CI/CD pipeline uses the Max subscription rather than API billing, it WILL break. The split is structural: subscription for interactive use, API billing for automation. Plan for it.

### 10. Cedar policy syntax highlighting (v2.1.100) signals permissions-as-code is coming
v2.1.100 added Cedar policy syntax highlighting, which suggests Cedar is becoming a first-class permissions language for Claude Code. Cedar (from Amazon Verified Permissions) allows expressing authorization policies as code that can be version-controlled, tested, and composed. Watch this space — it may replace the current allow/deny array model in settings.json. Early adopters should start writing Cedar policies for their Claude Code permission boundaries now.
