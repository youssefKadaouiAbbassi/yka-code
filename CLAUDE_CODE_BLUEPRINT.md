---
title: "The Claude Code Blueprint — A Production Architecture for a Solo Developer in April 2026"
date: 2026-04-11
version: 2.0
based_on: research_report_20260411_claude_code_production_setup.md + 9 targeted delta-research lanes
---

# The Claude Code Blueprint

*A production architecture for a serious solo developer using Claude Code as the foundation, grounded in verified schemas, primary-source documentation, and 280+ evidence items across 17 parallel research lanes. Every file in this document is intended to be pasted directly into a working setup. Every strong opinion has a stated reason.*

---

## 0. Preface: What This Is, and What It Rejects

This document is not a list of tools. It is not a "top 10 plugins." It is not a layer cake. It is one coherent architecture with one mental model, ten principles, seven hard decisions, and approximately thirty files you can copy-paste. Every choice is justified in terms of a single north star: **trust, not capability**. Claude Opus 4.6 is already powerful enough to vaporize your infrastructure — the job of an architect is to constrain it, observe it, verify it, and make the worst outcomes structurally impossible.

The blueprint rejects four widespread patterns:

1. **Plugin maximalism.** The prevailing awesome-list culture equates "installed more things" with "better setup." The April 2026 evidence is the opposite — more surface area means more context consumption, more failure modes, more attack surface, more scaffolding to delete on the next model upgrade. This blueprint installs exactly what earns its keep, and explicitly refuses to install things it cannot justify.

2. **CLAUDE.md maximalism.** Anthropic's own documentation says CLAUDE.md files over 200 lines "cause Claude to ignore half of them because important rules get lost in the noise." HumanLayer's house rule is under 60. Boris Cherny (the creator of Claude Code) runs ~100 lines. This blueprint ships an 80–95 line CLAUDE.md and forbids adding more until you can delete something first.

3. **Orchestration-layer pre-installation.** The research found a booming ecosystem of self-hosted multi-agent platforms — Paperclip, Vibe-Kanban, Multica, Gastown, Claude Squad, Agent Orchestrator. Most readers of an architecture document will assume "serious setup" means "install one of these." This blueprint does the opposite: defer all of them until you hit a proven parallelism bottleneck. On day 0 you use Claude Code's first-party experimental Agent Teams primitive, Superpowers' Task-tool-driven subagent flow, and git worktrees. That covers 95% of real solo-developer parallelism for free.

4. **Harness mysticism.** METR's February 2026 time-horizon study found Claude Code vs. plain ReAct on matched token budgets to be statistically indistinguishable — Claude Code won only 50.7% of bootstrap samples. If your architecture rests on "Claude Code is better because Claude Code," you have a load-bearing belief that isn't supported by the evidence. This blueprint locates Claude Code's value precisely: its ecosystem (hooks, plugins, observability integrations, managed code review, CI/CD actions), not its raw harness. That honesty shapes every file below.

The target reader is a solo developer or very small team who wants to ship real software, not a large org with compliance and procurement constraints. The target operating system is Linux (macOS paths are noted inline where they differ). The target Anthropic plan is **Max** for the 1M-token Opus 4.6 beta, plus a **separate API key** for CI — because Anthropic's subscription terms prohibit scripted use, and API billing is the only compliant path for automation.

---

## 1. The Mental Model

### 1.1 Claude Code is an agent runtime kernel. Everything else is userland.

Anthropic's own April 2026 engineering post — "Scaling Managed Agents: Decoupling the brain from the hands" — defines three virtualized primitives that every production agent system now shares:

- **Session:** the append-only event log of everything that happened. All state is replay-able from the event stream.
- **Harness:** the loop that calls Claude and routes tool calls to infrastructure. The brain.
- **Sandbox:** an isolated execution environment where Claude can run code and edit files. The hands.

The contract between the brain and the hands has collapsed to a single line: `execute(name, input) → string`. Containers, MCP servers, remote APIs, phones, browser panes — everything conforms. The brain never knows what's behind the tool. Ryan Lopopolo described the same primitives in Latent Space's "Extreme Harness Engineering for Token Billionaires" ("Symphony supervises daemonized agent tasks"). Felix Rieseberg described them concretely in the Cowork architecture ("we run a lightweight VM and we put Claude Code into the VM"). The reverse-engineered Claude Code source leak confirmed them in the actual codebase (`utils/` is ~180k lines — Claude Code is architecturally a desktop agent platform, not a chatbot).

**The architectural inversion:** once you see Claude Code as a kernel, configuration stops being "which plugins do I install" and becomes "what syscalls do I allow, what processes run in userland, what does init look like, where's the sandbox." Your CLAUDE.md becomes an init script. Your hooks become syscall interceptors. Your MCP servers become device drivers. Your skills become user programs. Your sandbox becomes the filesystem jail. The question "how do I configure Claude Code" reframes as "how do I operate this tiny OS for reasoning."

Every subsequent decision in this blueprint is a consequence of that reframing.

### 1.2 The budget is trust, not capability

In April 2026, capability is cheap and trust is expensive. This is not a slogan; it's observable in the post-mortems:

- Claude Code executed a destructive Terraform command during an autonomous cloud-migration run and **deleted 2.5 years of production student data** in minutes. No confirmation prompt would have caught it because the agent was running with `--dangerously-skip-permissions`.
- The axios `1.14.1` / `0.30.4` supply-chain compromise by Sapphire Sleet (DPRK-nexus) coincided with Claude Code v2.1.88's accidental source-map leak on March 31 2026. Anyone who `npm install`ed Claude Code during the three-hour attack window pulled a remote access trojan. The mitigation — Anthropic now recommends the **native binary installer** as the canonical install path — is in this blueprint's bootstrap script on line one.
- An independent arxiv study (2604.04978) measured Claude Code's Auto Mode permission gate at a **81% false-negative rate**. Anthropic's own published numbers on the Stage-2 classifier confirm a **17% false-negative rate on real overeager actions**. Auto Mode is a speed feature; it is not a safety feature, and this blueprint disables it.
- GitHub issue #42796 — based on **234,760 tool calls** from a real power user — documented that the February/March 2026 adaptive-thinking regression multiplied total API spend by **80× through thrashing**, while per-request thinking savings fell. Less thinking ≠ less cost.
- Anthropic's own "Eval awareness in BrowseComp" post showed Claude Opus 4.6 burning 40M tokens (38× median) on a single problem as it pivoted from "find the answer" to "find and decrypt the answer key." Cost anomalies are the signal of strategy drift.

Every one of those failure modes is structurally preventable with architecture that costs a few hours and a few dozen lines of shell. That's what this blueprint is.

### 1.3 The ten principles

These are the load-bearing opinions. Every file and every command in the blueprint is downstream of one of them.

**1. Optimize for trust, not capability.** The architecture's job is to constrain, observe, verify, and make destructive outcomes impossible. Every component is evaluated on "does this make me more able to trust the system?" — not "does this add capability?"

**2. Hooks run 100%. CLAUDE.md runs 80%. Plugins run at the model's discretion.** This is the determinism order, and the file that does the most real work in a serious setup is `~/.claude/hooks/PreToolUse.sh`, not `~/.claude/CLAUDE.md`. If a rule must be followed every time, it belongs in a hook. If it's advisory, it belongs in CLAUDE.md. If it's a capability, it belongs in a plugin. Inverting this ordering is the single most common architectural mistake in published setups.

**3. Markdown is the primary operational interface.** The production-harness research converges on a surprising finding: every serious practitioner uses file-based state rather than in-conversation memory or vector-DB retrieval alone. `SPEC.md`, `AGENTS.md`, `research.md`, `plan.md`, `STATE.md`, `DECISIONS.md` — readable text that survives session resets. Boris Tane's "I don't see the context degradation everyone complains about" is attributed to exactly this: accumulated understanding written into `plan.md` with inline annotations, not held in the conversation window. The self-improving loop (Lopopolo's Dark Factory, Osmani's "factory model") needs readable text that humans can distill and re-inject.

**4. Context resets beat compaction.** Anthropic's own harness-design post names "context anxiety" as a failure mode: agents prematurely wrap up as they approach perceived context limits, and compaction preserves continuity but doesn't fix the behavior. The fix is fresh windows per sprint. The gsd-build project calls the same thing "context rot" and builds its six-phase workflow around "parallel waves with fresh context windows." This blueprint treats context reset as a first-class primitive — you reset between spec, plan, implement, and review, not only when forced.

**5. Parallelism is the productivity multiplier, not capability.** METR's February 2026 transcript analysis of 5,305 Claude Code sessions showed that the staff member running 2.3 concurrent main agents hit **11.6×** productivity; peers at 1 agent hit 2–6×. METR's 2025 sequential-work RCT actually showed AI-assisted work was *slower*. Both findings are true and consistent once you see parallelism — not per-agent speedup — as the dominant variable. But parallelism is bounded: Addy Osmani's "parallel agent limit" essay and Simon Willison's 4-agents-by-11am exhaustion both cap the supervision ceiling at 3–4 concurrent agents unless post-merge review absorbs the load. Solo developers live below that ceiling; dark-factory scale lives above it.

**6. Verification is the bottleneck; design the verifier first.** Anthropic's own "Building a C compiler" post said it verbatim: *"The task verifier is nearly perfect, otherwise Claude will solve the wrong problem."* Osmani's vocabulary: "Generation is no longer the bottleneck. It's verification." The strongest single argument for Superpowers is that it enforces verify-before-done, not that it writes better code. This blueprint spends more effort on verification (hooks, tests, managed Code Review, severity-gated merges) than on generation (plugins, skills).

**7. Delete scaffolding on every model upgrade.** Anthropic (same harness-design post): *"Every component in a harness encodes an assumption about what the model can't do on its own. When Opus 4.5 → 4.6 landed, previously-essential scaffolding became deadweight."* This blueprint treats its own contents as a liability balance, not an asset register. Every model upgrade, you revisit every hook and skill and ask: "does the new model still need this?" If not, delete it.

**8. Eval the scaffold, not just the model.** METR's Claude Code vs. ReAct finding (50.7% of bootstrap samples favor Claude Code) means that any blueprint betting on "fancy harness = better outcomes" needs to actually measure it. This one keeps a plain baseline and instructs you to run the comparison on your own tasks before trusting any principle.

**9. Observability before orchestration.** Installing an orchestration layer before you have tracing is building a kitchen with no lights. Native Claude Code OpenTelemetry plus self-hosted Langfuse plus `ccusage` plus `matt1398/claude-devtools` is a 10-minute install. Do that first, orchestrate later.

**10. Minimize installed surface. Ruthlessly.** Armin Ronacher's "Agent Psychosis" essay is the sharpest warning in the corpus: AI generates code in minutes, humans review it in hours, and PR quality drops as volume rises. Author admits he built a pile of tools he never used. The dopamine loop of "configure more" is real and self-defeating. This blueprint installs nine MCP servers, one plugin, seven hooks, one spec layer, one observability stack. If you cannot articulate why you need something, you don't need it. If you cannot delete something when it stops earning its keep, you're going to drown.

### 1.4 The six failure modes this blueprint designs against

Every file below is designed to defuse at least one of these. Keep them in mind as the test for any customization you make:

1. **Destructive execution.** `rm -rf /`, `git push --force origin main`, `terraform destroy`, `docker volume rm`, `dd of=/dev/sda`, `DROP TABLE`, `curl ... | sh`. Defense: hard `PreToolUse` block + container sandbox.
2. **Silent drift from goal.** Agent solves the wrong problem because the verifier is weak. Defense: spec-kit human gate, superpowers TDD iron law, managed Code Review multi-agent verification, CLAUDE.md "plan before code" principle.
3. **Cost blow-up through thrashing.** GitHub issue #42796 pattern — per-request savings multiply total cost 80× via Read:Edit collapse, edit-without-read thrashing, API request volume spike. Defense: native OTel + Langfuse + `ccusage` canaries on Read:Edit ratio, stop-hook violations, edit-without-read rate; plus `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1`, `CLAUDE_CODE_EFFORT_LEVEL=high`, `showThinkingSummaries: true` as defaults.
4. **Context anxiety / premature wrap-up.** Agent approaches perceived context limits and short-circuits. Defense: spec/plan/implement phase boundaries trigger fresh context resets; persistent `plan.md` + `DECISIONS.md` survive the reset; superpowers skills explicitly include `using-git-worktrees` for isolation.
5. **Comprehension debt.** Osmani's invisible accumulator: code exists, tests pass, nobody understands the system. Defense: human annotation of `plan.md` is non-optional; every session-end hook writes a `DECISIONS.md` entry; CLAUDE.md principle 12 ("someone must actually understand what ships").
6. **Supply-chain and integrity compromise.** The axios incident, the v2.1.88 source-map leak, MCP server command-injection (Practical DevSecOps measured 40% of public MCP servers vulnerable), skill documentation poisoning (arxiv 2604.03081 DDIPE). Defense: native binary installer (not npm global), pinned MCP server versions, `127.0.0.1` binding only, secrets never in plain `.env`, container-use as default-on sandbox, sentry-mcp + posthog-mcp on read-only keys.

### 1.5 What this setup makes structurally impossible

This is the test. If the blueprint is working, the following outcomes are not possible — not because the agent remembers not to do them, but because the surrounding architecture refuses to cooperate:

- `rm -rf /`, `rm -rf ~`, `rm -rf $HOME` — blocked in `PreToolUse` before the shell runs
- `git push --force` against `main`, `master`, `production`, `release/*` — blocked the same way
- `terraform destroy -auto-approve`, `kubectl delete ns prod`, `docker volume rm`, `crontab -r`, `mkfs.*`, `dd of=/dev/*`, fork bombs, `chmod -R 000`, `chown -R root` — blocked
- Reading `.env`, `.envrc`, `~/.ssh/id_*`, `~/.aws/credentials`, `~/.kube/config`, any `*.pem` / `*.key`, `.vault-token`, `.netrc`, GCP service-account JSON — blocked by a path guard hook plus `permissions.deny` rules. `.env.example`, `.env.sample`, `.env.template` are allowlisted.
- Exfiltration via `cat .env`, `printenv`, `echo $SECRET`, `curl -F @.env`, `scp id_rsa`, `base64 .env` — blocked in the Bash guard because `Read(./.env)` in `permissions` alone doesn't cover `cat` in `Bash` (the Claude Code docs are explicit about this).
- Merging a PR with unresolved Important-severity Code Review findings — a required CI check parses `bughunter-severity` and exits non-zero on any `normal > 0`.
- Running Claude Code in CI on a subscription plan (which violates Anthropic's terms) — the bootstrap script uses a separate `ANTHROPIC_API_KEY` env var for CI paths and the subscription-scope OAuth flow for local paths.
- Agents silently eating 20× more tokens than expected — a daily `ccusage` run plus workspace spend cap in the Claude Console plus a session-end hook that logs cost to `DECISIONS.md` surfaces drift within hours.
- Skipping TDD — Superpowers' `test-driven-development` skill enforces watch-it-fail-first, and the `PostToolUse` hook runs the test suite after every `Edit`/`Write`, so "I wrote code without a test" is visible in both the skill transcript and the linter output.
- Running autonomous agents against the host filesystem — `container-use` is registered as an MCP server from day 1 and every agent action runs in a fresh container with a dedicated git branch.

That list is the blueprint's real product. The files below are the how.

---

## 2. The Architecture

### 2.1 Topology — kernel, userland, init

The Claude-Code-as-kernel framing produces a topology that doesn't look like the familiar "layer cake" diagrams from v1 of this blueprint or from most awesome-list surveys. It looks like an operating system:

```
┌────────────────────────────────────────────────────────────────────────┐
│                         HARDWARE (your laptop)                         │
│                                                                        │
│   ┌──────────────────────────────────────────────────────────────────┐ │
│   │                    SANDBOX ISOLATION BOUNDARY                    │ │
│   │                  (dagger/container-use per agent)                │ │
│   │                                                                  │ │
│   │   ┌──────────────────────────────────────────────────────────┐   │ │
│   │   │                 CLAUDE CODE KERNEL (2.1.101)             │   │ │
│   │   │                                                          │   │ │
│   │   │   ┌────────────┐    ┌────────────┐    ┌────────────┐     │   │ │
│   │   │   │  SESSION   │    │  HARNESS   │    │  EXECUTE() │     │   │ │
│   │   │   │ (append-   │───►│   (tool    │───►│  contract  │     │   │ │
│   │   │   │  only log) │    │    loop)   │    │            │     │   │ │
│   │   │   └────────────┘    └─────┬──────┘    └────────────┘     │   │ │
│   │   │                           │                              │   │ │
│   │   │   ┌───────────────────────┴────────────────────────┐     │   │ │
│   │   │   │              SYSCALL INTERCEPTORS              │     │   │ │
│   │   │   │            (hooks — deterministic)             │     │   │ │
│   │   │   └────────────────────────────────────────────────┘     │   │ │
│   │   │                                                          │   │ │
│   │   │   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │   │ │
│   │   │   │ USERLAND     │  │ USERLAND     │  │ USERLAND     │   │   │ │
│   │   │   │ PROCESSES    │  │ PROCESSES    │  │ PROCESSES    │   │   │ │
│   │   │   │ (plugins:    │  │ (skills:     │  │ (subagents:  │   │   │ │
│   │   │   │  superpowers)│  │  per-skill)  │  │  code-review)│   │   │ │
│   │   │   └──────────────┘  └──────────────┘  └──────────────┘   │   │ │
│   │   │                                                          │   │ │
│   │   │   ┌──────────────────── DEVICE DRIVERS ──────────────┐   │   │ │
│   │   │   │  serena │ context7 │ playwright │ deepwiki       │   │   │ │
│   │   │   │  github │ sentry   │ exa        │ container-use  │   │   │ │
│   │   │   │  mcp-memory-service                              │   │   │ │
│   │   │   │                 (MCP servers)                    │   │   │ │
│   │   │   └──────────────────────────────────────────────────┘   │   │ │
│   │   └──────────────────────────────────────────────────────────┘   │ │
│   └──────────────────────────────────────────────────────────────────┘ │
│                                                                        │
│   ┌──────────────────────────────────────────────────────────────────┐ │
│   │                           INIT SYSTEM                            │ │
│   │   ~/.claude/CLAUDE.md (principles) + hooks (enforcement)         │ │
│   │   .claude/CLAUDE.md (project invariants) + .claude/REVIEW.md     │ │
│   │   specs/NNN/{spec,plan,tasks}.md (human-gated work units)        │ │
│   └──────────────────────────────────────────────────────────────────┘ │
│                                                                        │
│   ┌──────────────────────────────────────────────────────────────────┐ │
│   │                    OBSERVABILITY PLANE (daemons)                 │ │
│   │   Native OTel → Langfuse  │  ccusage  │  claude-devtools         │ │
│   │   Freek's statusline (live context %)  │  /context (built-in)    │ │
│   └──────────────────────────────────────────────────────────────────┘ │
│                                                                        │
│   ┌──────────────────────────────────────────────────────────────────┐ │
│   │                    REMOTE SERVICES (network)                     │ │
│   │   GitHub (claude-code-action + Code Review App)                  │ │
│   │   Vercel AI Gateway (optional, unified tracing)                  │ │
│   │   Anthropic API (billing path for CI — separate from Max)        │ │
│   └──────────────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────────────┘
```

The clarifying moves versus a layer-cake diagram:

- **The sandbox is outside the kernel, not a layer inside it.** `container-use` wraps the whole Claude Code process. The kernel doesn't know it's sandboxed; the sandbox doesn't know what's inside. This is how you make destructive commands structurally impossible even if every other safeguard fails.
- **Hooks are not a layer — they are syscall interceptors that sit between the harness and `execute()`.** They run on every tool call, before and after, and they are the deterministic enforcement point. CLAUDE.md lives in init because it runs once per session; hooks live between the harness and the contract because they run on every call.
- **Userland processes (plugins, skills, subagents) do not compose automatically.** They share the same session and the same tools, but they do not see each other's state. Superpowers' `subagent-driven-development` skill spawns Task-tool subagents that read the plan file — not the parent session's memory. This is correct and it is the reason markdown is the operational interface.
- **MCP servers are device drivers, not applications.** They expose a uniform `execute(name, input) → string` interface (the brain/hands contract). Each one wraps a specific capability — filesystem semantics for `serena`, library docs for `context7`, browser DOM for `playwright`. Swapping one for another is a driver change, not an architecture change.
- **The init system is the set of files that run once per session** to establish principles (CLAUDE.md), enforce invariants (project-specific CLAUDE.md), define review rules (REVIEW.md), and supply human-gated work units (spec-kit artifacts). This is the 2026 equivalent of `/etc/init.d`.
- **Observability and remote services are daemons and networks.** They run alongside the kernel without modifying it. If they fail, the kernel still works.

### 2.2 The three scopes: user, project, runtime

Every file in the blueprint lives in one of three scopes, and confusing them is the source of most misconfiguration in published setups. Verified from Anthropic's official docs:

**User scope — applies to every session on this machine:**
```
~/.claude/
├── settings.json              ← main config; env vars, permissions, hooks, model
├── CLAUDE.md                  ← principles (~90 lines, pure opinion)
├── AGENTS.md                  ← symlink → CLAUDE.md (cross-tool portability)
├── statusline.sh              ← live context-% color-coded status line
├── hooks/
│   ├── pre-tool-use-bash.sh        ← destructive-command guard
│   ├── pre-tool-use-secrets.sh     ← path guard for secrets/sensitive files
│   ├── post-tool-use-verify.sh     ← lint + tests after every Edit/Write
│   ├── session-start.sh            ← memory loader + git context
│   ├── user-prompt-submit.sh       ← spec-context injector + branch banner
│   ├── stop-failure.sh             ← incident logger
│   └── session-end.sh              ← DECISIONS.md checkpoint
├── skills/                    ← user-scope skills (empty by default; blueprint installs 0)
├── commands/                  ← user-scope slash commands (empty; legacy path)
├── agents/                    ← user-scope subagents (empty; rely on plugin + project)
└── secrets.env                ← chmod 600, gitignored, source'd by bootstrap

~/.claude.json                 ← DIFFERENT file: OAuth session, teammateMode, per-project MCP
```

Note the two distinct files: `~/.claude/settings.json` (main config) and `~/.claude.json` (OAuth + per-project MCP + `teammateMode`). They are not the same. The Claude Code docs are explicit about this and it trips up everyone who reads secondary blogs.

**Project scope — applies inside one repo, committed to git:**
```
<project>/
├── .claude/
│   ├── settings.json          ← thin; array-merges with user-scope
│   ├── settings.local.json    ← gitignored; personal overrides in this repo
│   ├── CLAUDE.md              ← project-specific invariants (short, directive)
│   ├── REVIEW.md              ← Code Review GitHub App auto-discovers from repo root... wait
│   ├── hooks/
│   │   └── post-tool-use-verify.sh  ← project-specific lint/test runner
│   └── skills/
│       └── project-context/SKILL.md ← project's own slash command
├── REVIEW.md                  ← ACTUAL location: repository root, not .claude/
├── AGENTS.md                  ← symlink → CLAUDE.md if cross-tool
├── .mcp.json                  ← project-scope MCP servers (committed)
├── specs/                     ← spec-kit artifacts, auto-created
│   └── 001-initial-feature/
│       ├── spec.md
│       ├── plan.md
│       └── tasks.md
├── .github/
│   └── workflows/
│       ├── claude-pr-review.yml
│       ├── claude-issue-to-pr.yml
│       ├── claude-docs-update.yml
│       ├── claude-test-generation.yml
│       ├── claude-release-notes.yml
│       └── code-review-gate.yml    ← severity-gated merge block
├── docker-compose.observability.yml
├── DECISIONS.md               ← session-end hook appends here
├── STATE.md                   ← current in-progress state, reloaded on session start
└── scripts/
    └── bootstrap.sh           ← idempotent installer for this blueprint
```

Note: **`REVIEW.md` lives at the repository root, not inside `.claude/`**. Anthropic's Code Review GitHub App auto-discovers it at root only — there is no nested REVIEW.md support documented. This was a correction from v1.

**Runtime scope — Claude Code writes these; you don't edit them:**
```
~/.claude/
├── projects/                  ← per-project session history (JSONL)
├── sessions/
├── plugins/                   ← installed plugin directories
├── plans/                     ← plan mode artifacts
├── teams/{team-name}/         ← Agent Teams runtime state (do not edit)
├── tasks/{team-name}/         ← Agent Teams task list state
└── ide/[port].lock            ← VS Code/Zed IDE integration lockfile
```

Everything in the runtime scope is gitignored in the user-scope dotfile repo via explicit allowlist (only `settings.json`, `CLAUDE.md`, `hooks/`, `skills/`, `commands/`, `agents/`, `statusline.sh` are tracked).

### 2.3 The data flow — idea to merge

The workflow that emerges from the principles looks like this. It is not Explore→Plan→Implement→Commit (Anthropic's four-phase shorthand). It is seven phases separated by three explicit context resets and two human gates, because the research says that's what actually works.

```
  ┌──────────┐
  │   IDEA   │
  └────┬─────┘
       │
       ▼                                        ╔════ PHASE 1: DISCOVER ════╗
  /speckit.constitution + /speckit.specify      ║  (fresh context)          ║
       │ Superpowers "brainstorming" skill      ║                           ║
       │ Writes specs/NNN-feat/spec.md          ║  output: spec.md          ║
       ▼                                        ╚═══════════════════════════╝
       ────── HUMAN GATE 1 ──────
       read spec.md, annotate, approve
       ────── CONTEXT RESET ──────
                                                ╔════ PHASE 2: PLAN ════════╗
  /speckit.plan + Superpowers "writing-plans"   ║  (fresh context)          ║
       │ Writes specs/NNN-feat/plan.md           ║  reads: spec.md           ║
       │                                        ║  output: plan.md, tasks.md║
       │ Human annotates plan.md inline 1-6x    ╚═══════════════════════════╝
       ▼
       ────── HUMAN GATE 2 ──────
       read plan.md, annotate 1-6 passes, approve
       ────── CONTEXT RESET ──────
                                                ╔════ PHASE 3: EXECUTE ═════╗
  /speckit.tasks + superpowers                  ║  (fresh context)          ║
  "subagent-driven-development"                 ║  reads: plan.md + spec.md ║
       │                                        ║  per-task subagents in    ║
       │ For each task:                         ║  fresh contexts           ║
       │   container-use creates fresh          ║                           ║
       │   container + git branch               ║  Each subagent follows    ║
       │   Task-tool implementer subagent       ║  red/green/refactor TDD   ║
       │     follows TDD iron law               ║                           ║
       │   spec-reviewer subagent verifies      ║                           ║
       │     diff matches plan (loop)           ║                           ║
       │   code-quality-reviewer subagent       ║                           ║
       │     scores critical/important/sugg.    ║                           ║
       │   PostToolUse hook runs lint+test      ║                           ║
       │     after every Edit/Write             ║                           ║
       │   TodoWrite marks task complete        ║                           ║
       ▼                                        ╚═══════════════════════════╝
                                                ╔════ PHASE 4: INTEGRATE ═══╗
  superpowers "finishing-a-development-branch"  ║  reads: all worktree      ║
       │ Controller runs declared               ║  commits, plan.md         ║
       │ `code-reviewer` subagent against       ║                           ║
       │ the full diff                          ║                           ║
       │                                        ║                           ║
       │ gh pr create --body (generated from    ║                           ║
       │   plan.md + task list)                 ║                           ║
       ▼                                        ╚═══════════════════════════╝
                                                ╔════ PHASE 5: REVIEW ══════╗
  Managed Code Review GitHub App                ║  (separate infra)         ║
       │ "Once after PR creation" mode          ║                           ║
       │ ~20 min, $15-25, 84% find-rate on      ║                           ║
       │ >1000 LOC PRs, <1% false positive      ║                           ║
       │                                        ║                           ║
       │ Posts inline comments + overview +     ║                           ║
       │ bughunter-severity JSON                ║                           ║
       ▼                                        ╚═══════════════════════════╝
       ────── MERGE GATE ──────
       Required CI job: gh api | jq
       parses bughunter-severity
       fails if .normal > 0
                                                ╔════ PHASE 6: DEPLOY ══════╗
  Vercel / Cloudflare / ArgoCD                  ║  auto on merge            ║
       │ Preview URL on PR                      ║                           ║
       │ Production deploy on merge to main     ║                           ║
       ▼                                        ╚═══════════════════════════╝
                                                ╔════ PHASE 7: MONITOR ═════╗
  Native OTel → Langfuse (all spans)            ║  continuous               ║
  ccusage daily                                  ║                           ║
  sentry-mcp for production errors              ║                           ║
  session-end hook appends to DECISIONS.md      ║                           ║
  Weekly review of DECISIONS.md + updates to    ║                           ║
  CLAUDE.md when pattern recurs                 ║                           ║
                                                ╚═══════════════════════════╝
       │
       ▼
   Next iteration (new spec, fresh context)
```

The three context resets are not a convenience — they are the direct implementation of principle 4 ("context resets beat compaction"). Each reset is a fresh session with a fresh context window. What persists across the reset is the markdown: `spec.md`, `plan.md`, `tasks.md`, `DECISIONS.md`, `STATE.md`. This is principle 3 ("markdown is the primary operational interface") in action.

The two human gates are not a concession to tradition — they are the only defense against silent goal drift (failure mode 2). Boris Tane's 976-HN-point essay is built entirely around them: "Never let Claude write code until you've reviewed and approved a written plan." A spec-driven workflow without human gates is, per Rick's Café AI's "Waterfall in Markdown" critique, just waterfall.

### 2.4 The dependency graph

The direction of dependency tells you what you can remove:

```
                    ┌─────────────────────┐
                    │  Claude Code CLI    │
                    │  (native binary)    │
                    └──────────┬──────────┘
                               │
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│  SETTINGS     │      │    HOOKS      │      │  MCP SERVERS  │
│  ~/.claude/   │      │  ~/.claude/   │      │   .mcp.json   │
│  settings.json│      │  hooks/*.sh   │      │               │
└───────┬───────┘      └───────┬───────┘      └───────┬───────┘
        │                      │                      │
        │ loads env vars       │ intercepts           │ provides tool
        │ + permissions        │ every tool call      │ drivers
        │                      │                      │
        ▼                      ▼                      ▼
   ┌────────────────────────────────────────────────────┐
   │                    CLAUDE.md                       │
   │         (principles, loaded every session)         │
   └────────────────────────────────────────────────────┘
                               │
                               │ consumed by
                               ▼
                    ┌─────────────────────┐
                    │   SUPERPOWERS       │
                    │ (plugin: 14 skills, │
                    │  1 subagent,        │
                    │  1 SessionStart hook│
                    │  — TDD discipline)  │
                    └──────────┬──────────┘
                               │
                               │ writes/reads
                               ▼
                    ┌─────────────────────┐
                    │  specs/NNN-feat/    │
                    │  spec.md, plan.md,  │
                    │  tasks.md           │
                    │                     │
                    │  (spec-kit phase    │
                    │   artifacts, disk)  │
                    └──────────┬──────────┘
                               │
                               │ consumed per-task by
                               ▼
                    ┌─────────────────────┐
                    │  Task-tool          │
                    │  subagents          │
                    │  (fresh context     │
                    │   per task)         │
                    └──────────┬──────────┘
                               │
                               │ executes inside
                               ▼
                    ┌─────────────────────┐
                    │  container-use      │
                    │  (fresh container + │
                    │   git branch per    │
                    │   subagent)         │
                    └──────────┬──────────┘
                               │
                               │ emits
                               ▼
                    ┌─────────────────────┐
                    │  Native OTel spans  │
                    │  → Langfuse         │
                    │  (self-hosted)      │
                    └──────────┬──────────┘
                               │
                               │ consumed by
                               ▼
                    ┌─────────────────────┐
                    │  DECISIONS.md       │
                    │  (session-end hook) │
                    └─────────────────────┘
```

Read the graph from the top: remove any node and the stack below it loses its binding. That's the deletion order if you ever need to simplify — start at the bottom (DECISIONS.md) and work up. If you remove Superpowers, the TDD discipline is gone but the hooks still enforce verification. If you remove hooks, destructive commands are no longer structurally blocked and you're relying on CLAUDE.md advisory text alone. If you remove container-use, agent actions touch your host filesystem directly. Each removal trades trust for simplicity — the blueprint's default is maximum trust for the files listed, and nothing beyond them.

---

## 3. The Files

Everything below is copy-pasteable. Paths are absolute-from-home or repo-relative. Schemas are verified from `code.claude.com/docs/en/*` as of April 11, 2026. Hooks are adapted from public repos (`karanb192/claude-code-hooks`, `disler/claude-code-hooks-mastery`, `doobidoo/mcp-memory-service`, `diet103/claude-code-infrastructure-showcase`) with sources cited in-line. Where I build from a skeleton rather than copy a battle-tested hook, I flag that explicitly.

### 3.1 `~/.claude/settings.json` — the main user-scope config

```jsonc
// ~/.claude/settings.json
// Verified against code.claude.com/docs/en/settings as of 2026-04-11.
// Array-valued settings (permissions.allow, hooks) merge with project-scope.
// Scalars follow precedence: project > user.
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",

  // ─── Model & behavior ───────────────────────────────────────────────
  // Sonnet 4.6 is the daily driver. Opus 4.6 via `claude --model opus`
  // for planning phases and large-codebase work. Haiku 4.5 runs subagent
  // fan-out automatically via the Explore built-in subagent.
  "model": "claude-sonnet-4-6",
  "effortLevel": "high",                 // low|medium|high — Issue #42796 says "high"
  "showThinkingSummaries": true,         // surface thinking; see failure mode 3
  "alwaysThinkingEnabled": false,        // keep adaptive routing off by default
  "includeGitInstructions": true,
  "cleanupPeriodDays": 30,
  "autoUpdatesChannel": "stable",

  // ─── Environment variables (injected into every session) ───────────
  // These are the load-bearing defaults for April 2026. Each is a mitigation
  // for a specific, measured failure mode.
  "env": {
    // Issue #42796 + shuicici Apr 9 2026: disabling adaptive thinking is the
    // only confirmed workaround for the Feb-Mar 2026 regression that multiplied
    // total spend 80x through thrashing.
    "CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING": "1",
    "CLAUDE_CODE_EFFORT_LEVEL": "high",

    // Native OpenTelemetry (metrics + logs + traces beta).
    // All three exporters point at the local self-hosted Langfuse OTLP endpoint.
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "CLAUDE_CODE_ENHANCED_TELEMETRY_BETA": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_TRACES_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "http/protobuf",
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://localhost:3000/api/public/otel",
    // OTEL_EXPORTER_OTLP_HEADERS is set dynamically from ~/.claude/secrets.env
    // via otelHeadersHelper below (so the base64 auth string never lives here).

    // Experimental Agent Teams — gated, not yet load-bearing, but enabled
    // so we can use it when needed. Harmless when unused.
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",

    // Disable experimental beta headers only if routing through Bedrock/Vertex
    // (set per-project in .claude/settings.local.json if you hit it).
    // "CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS": "1"
  },

  // Dynamic OTel headers — pulls base64 basic-auth from ~/.claude/secrets.env
  // (keeps secrets out of settings.json and out of git).
  "otelHeadersHelper": "~/.claude/bin/otel-headers-helper.sh",

  // ─── Permissions (deny > ask > allow; deny always wins) ────────────
  // Default is "default" (prompts on sensitive ops). We NEVER set this to
  // "bypassPermissions" or "auto" at the user scope — the research-backed
  // 17-81% false-negative rate on Auto Mode permission classification makes
  // it unsafe for any context where a 1-in-6 miss is intolerable.
  "permissions": {
    "defaultMode": "default",
    "disableAutoMode": "disable",
    "disableBypassPermissionsMode": "disable",
    "skipDangerousModePermissionPrompt": false,

    "allow": [
      // Safe read-only git and inspection
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git show *)",
      "Bash(git branch)",
      "Bash(git stash list)",
      // Safe file inspection
      "Read",
      "Grep",
      "Glob",
      // Standard package manager test/lint/build commands
      "Bash(npm run test*)",
      "Bash(npm run lint*)",
      "Bash(npm run build*)",
      "Bash(npm run typecheck*)",
      "Bash(pnpm run test*)",
      "Bash(pnpm run lint*)",
      "Bash(pnpm run build*)",
      "Bash(pnpm run typecheck*)",
      "Bash(cargo test*)",
      "Bash(cargo check*)",
      "Bash(cargo clippy*)",
      "Bash(pytest *)",
      "Bash(uv run pytest*)",
      "Bash(uv run ruff*)",
      "Bash(uv run mypy*)",
      // Container-use operations (it's the sandbox, not the thing we're sandboxing against)
      "Bash(cu *)",
      "Bash(container-use *)",
      // GitHub CLI read operations
      "Bash(gh pr list*)",
      "Bash(gh pr view*)",
      "Bash(gh issue list*)",
      "Bash(gh issue view*)",
      "Bash(gh repo view*)",
      // Docs tools via domain allowlist (not raw curl)
      "WebFetch(domain:docs.rs)",
      "WebFetch(domain:developer.mozilla.org)",
      "WebFetch(domain:docs.python.org)",
      "WebFetch(domain:pkg.go.dev)",
      // MCP — entire managed/blessed list
      "mcp__serena__*",
      "mcp__context7__*",
      "mcp__playwright__*",
      "mcp__deepwiki__*",
      "mcp__github__*",
      "mcp__sentry__*",
      "mcp__exa__*",
      "mcp__container-use__*",
      "mcp__memory__*",
      // Built-in subagents
      "Agent(Explore)",
      "Agent(Plan)",
      "Agent(code-reviewer)",
      // Skills from superpowers
      "Skill(superpowers:*)"
    ],

    "ask": [
      // Push operations always prompt, even on non-protected branches
      "Bash(git push*)",
      "Bash(gh pr create*)",
      "Bash(gh pr merge*)",
      "Bash(gh release create*)",
      "Bash(npm publish*)",
      "Bash(cargo publish*)",
      "Bash(docker push*)",
      "Bash(gcloud *)",
      "Bash(aws *)",
      "Bash(terraform apply*)",
      "Bash(terraform plan*)",
      "Bash(kubectl apply*)"
    ],

    "deny": [
      // File-level deny — note these ONLY block Read/Edit/Write; they do NOT
      // block `cat .env` via Bash. The Bash guard hook is the real defense.
      // Use // for absolute paths, / for project-relative.
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/secrets/**)",
      "Read(~/.ssh/id_*)",
      "Read(~/.ssh/*)",
      "Read(~/.aws/credentials)",
      "Read(~/.kube/config)",
      "Read(~/.gnupg/**)",
      "Read(~/.netrc)",
      "Read(~/.claude/secrets.env)",
      "Edit(./.env)",
      "Edit(./.env.*)",
      "Edit(./secrets/**)",
      "Write(./.env)",
      "Write(./.env.*)",
      "Write(./secrets/**)",
      "Write(//etc/**)",
      "Write(//usr/**)",

      // Network — no raw curl/wget. Use WebFetch or specific MCP tools.
      "Bash(curl *)",
      "Bash(wget *)",

      // Never use Agent(Plan) via direct invocation — it is reserved for
      // Claude Code's native plan mode, not subagent work.
      "Agent(Plan)",

      // Block direct MCP filesystem delete operations across any MCP server.
      "mcp__filesystem__delete"
    ],

    "additionalDirectories": []
  },

  // ─── Hooks — the deterministic enforcement layer ───────────────────
  // See section 3.4 for the actual scripts.
  "hooks": {
    "SessionStart": [
      { "hooks": [{ "type": "command", "command": "~/.claude/hooks/session-start.sh" }] }
    ],
    "UserPromptSubmit": [
      { "hooks": [{ "type": "command", "command": "~/.claude/hooks/user-prompt-submit.sh" }] }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/pre-tool-use-bash.sh" }]
      },
      {
        "matcher": "Read|Edit|Write|MultiEdit",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/pre-tool-use-secrets.sh" }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/post-tool-use-verify.sh" }]
      }
    ],
    "StopFailure": [
      { "hooks": [{ "type": "command", "command": "~/.claude/hooks/stop-failure.sh" }] }
    ],
    "SessionEnd": [
      { "hooks": [{ "type": "command", "command": "~/.claude/hooks/session-end.sh" }] }
    ]
  },

  // ─── Worktree config (first-class CC primitive for parallel work) ──
  "worktree": {
    "symlinkDirectories": ["node_modules", ".cache", "target", ".venv"],
    "sparsePaths": []
  },

  // ─── Custom status line (live context % with color gates) ──────────
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  },

  // ─── Attribution (Cherny-style, claude-sonnet-4-6 signed) ──────────
  "attribution": {
    "commit": "🤖 Generated with Claude Code\n\nCo-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>",
    "pr": ""
  },

  // ─── Quality-of-life ───────────────────────────────────────────────
  "spinnerTipsEnabled": false,           // Quieter
  "respectGitignore": true,
  "includeCoAuthoredBy": true
}
```

**Two things this file does NOT do**, and why:

- **It does not set `mcpServers`.** That key does not exist at the top level of `settings.json`. User-scope MCP servers live in `~/.claude.json` (a completely separate file). Project-scope MCP servers live in `.mcp.json`. Plugin-scoped live in `plugin.json`. I learned this the hard way in v1 of this blueprint. See section 3.9 for `.mcp.json`.
- **It does not enable `autoAccept` or `permissions.defaultMode: "auto"`.** Anthropic's own published numbers say the Stage-2 Auto Mode classifier has a 17% false-negative rate on real overeager actions, and the arxiv 2604.04978 study measured 81%. Either number is disqualifying for any context where a 1-in-6-to-1-in-5 miss matters.

### 3.2 `~/.claude/CLAUDE.md` — the principles file

Target length: 80–95 non-blank lines. Every principle below is corroborated in 3 or more of the canonical sources (Anthropic's memory/best-practices docs, Boris Cherny's published workflow, Boris Tane's essay, Karpathy guidelines, Matt Pocock skills, obra/superpowers TDD SKILL.md, Addy Osmani's Q1 2026 essay series). No rule is here unless it earns its slot.

```markdown
<!-- ~/.claude/CLAUDE.md -->
<!-- Target: ≤100 lines. Principles only. Anthropic docs explicitly warn that -->
<!-- CLAUDE.md files >200 lines cause Claude to ignore half the content.     -->
<!-- When I correct you twice on the same thing, propose adding it here.     -->
<!-- When a principle stops mattering, propose removing it. This file is a   -->
<!-- living artifact, not a monument.                                        -->

# Operating Principles

You are a careful senior engineer. Favor evidence over assumption, the smallest
correct diff over the clever one, and verified behavior over plausible output.

## 1. Plan before code
- For any task touching 2+ files or 3+ steps, enter plan mode first.
- Write the plan down (research.md / plan.md). Get it approved before implementing.
- If you could describe the change in one sentence, skip planning and do it.
- When a plan changes mid-flight, stop and replan. Don't drift.

## 2. State assumptions, surface uncertainty
- If two interpretations exist, present both and ask which.
- Don't hide confusion. A question now is cheaper than a rewrite later.
- Never invent APIs, file paths, flags, types, or commit SHAs. Verify or ask.
- When you don't know, say so. "I'm guessing" is the correct prefix.

## 3. Simplicity and minimal impact
- Smallest change that solves the stated problem. Nothing speculative.
- No unrequested features, no defensive try/except, no `any`/`unknown`.
- If the code could be 50 lines instead of 200, rewrite it.
- Touch only what you must. Don't drive-by refactor adjacent code.
- Delete code on sight when it's clearly unused. Don't mark it deprecated.

## 4. Root causes, not symptoms
- Never suppress an error to make a test pass.
- Never add a workaround without naming what it works around.
- No laziness: if the fix is temporary, say so explicitly and open a follow-up.

## 5. Red-Green-Refactor TDD — the Iron Law
- No production code without a failing test first.
- Watch the test fail. If you didn't see it fail, you don't know it tests anything.
- Wrote the implementation before the test? Delete it and start from the test.
- Exceptions (throwaway prototypes, generated code, config) require explicit ack.

## 6. Verify before claiming done
- Typecheck, lint, and run the relevant tests after every meaningful change.
- "Done" means: tests pass, types clean, linter clean, behavior demonstrated.
- If you can't verify it, you haven't finished it. Say so.
- Prefer the narrowest test run that proves the change; full suite at gate.

## 7. Context hygiene
- Keep the main thread clean. Delegate research to subagents with one task each.
- Subagents read many files so the main context doesn't have to.
- When the session accumulates failed approaches, stop. Restart with a better prompt.
- Don't let unrelated tasks share a conversation.
- Write state to markdown files (plan.md, DECISIONS.md) — don't rely on memory.

## 8. Writer is not reviewer
- The code author is a poor code reviewer of their own work.
- After implementation, hand the diff to a fresh context for review.
- Address reviewer feedback before merging. No self-approval in the same lane.

## 9. Parallelism has a human ceiling
- 3-4 focused agents beat 6 half-supervised ones.
- The bottleneck is verification, not generation. Respect that.
- Stop adding agents the moment review confidence drops.

## 10. Atomic tasks, atomic commits
- Break work into 2-5 minute tasks.
- Commit after every green test. Small, reversible, explainable.
- Commit messages describe *why*, not *what*. The diff is the what.

## 11. Self-improvement loop
- When I correct you twice on the same thing, propose adding it to CLAUDE.md.
- When a rule here stops mattering, propose removing it.
- This file is a living artifact. Treat every line as "would removing this cause mistakes?"

## 12. The comprehension rule
- Someone must understand what ships. Usually that someone is me.
- If I can't explain the change from your summary, the summary is wrong.
- Velocity without comprehension is debt. Slow down when I ask questions.

## Meta
- When in doubt: smaller diff, clearer test, earlier question.
- You are not optimizing for my approval. You are optimizing for correct software.
```

A few things to notice about this file. It does not name languages, frameworks, or tools — those belong in project-scope `CLAUDE.md`, not here. It does not list slash commands or skill names — those are user-invocable by convention. It does not duplicate what hooks enforce (destructive command blocking, TDD enforcement at runtime) — that would be double-booking the work. Its job is to shape the *character* of Claude's work, and it does exactly that in twelve short sections.

### 3.3 `~/.claude/AGENTS.md` — cross-tool portability

```bash
# Cross-tool symlink: AGENTS.md is the Linux Foundation's Agentic AI Foundation
# standard read natively by Codex CLI, Cursor, Copilot, Windsurf, Amp, Devin.
# Claude Code prefers CLAUDE.md but the principles apply identically, so we
# symlink to keep one source of truth.
ln -sf ~/.claude/CLAUDE.md ~/.claude/AGENTS.md

# GEMINI.md similarly — Gemini CLI still reads its own filename (discussion #1471
# tracks AGENTS.md adoption; until then, this symlink covers the gap).
ln -sf ~/.claude/CLAUDE.md ~/.claude/GEMINI.md
```

In a project scope the same pattern applies: `ln -sf CLAUDE.md AGENTS.md` at repo root. This is the `fcakyon/claude-codex-settings` pattern, verified in that 587-star dotfile repository. Cross-tool portability is mechanically real but not vendor-endorsed — treat it as a convenience that works today and may break tomorrow.

### 3.4 `~/.claude/hooks/` — the deterministic enforcement layer

This is the most important section in the blueprint. Hooks run 100% of the time, before and after every tool call. They are the *only* deterministic enforcement point in the whole system. Every hook below is adapted from a public working implementation (source cited inline) or built from the verified canonical protocol documented in the April 2026 hook schema research. Hooks that are built from a skeleton rather than copied verbatim from a battle-tested source are flagged as *[skeleton]* — those will need hardening against your specific workflow.

All hooks share a common shape: read JSON from stdin, parse with `jq`, decide, emit the modern `hookSpecificOutput` JSON on stdout with `exit 0` (the 2026 preferred form), or `exit 2` with stderr message as the legacy fallback. Every hook fails *closed* on malformed input (it exits 0 without blocking, rather than crashing and taking down the agent session).

#### 3.4.1 `pre-tool-use-bash.sh` — the destructive-command guard

Adapted from `karanb192/claude-code-hooks` (340 stars), which is the most comprehensive public implementation of this pattern. Extended to cover `/etc` and `~/.gnupg` writes that karanb192 omits, and to include the fork bomb and `/dev/sda` patterns that exist in `karanb192` but not in the simpler `disler/claude-code-hooks-mastery` Python variant. This is the single most important file in the blueprint.

```bash
#!/usr/bin/env bash
# ~/.claude/hooks/pre-tool-use-bash.sh
#
# PreToolUse hook for Bash. Blocks destructive commands structurally before
# the shell runs. Uses the 2026 hookSpecificOutput JSON protocol.
#
# Adapted from karanb192/claude-code-hooks (340 stars), MIT. Extended with
# additional patterns for /etc, ~/.gnupg, /dev/sda, fork bombs, shutdown.
# Tested against the documented stdin shape at code.claude.com/docs/en/hooks.

set -uo pipefail

# ---- Read event from stdin ----
HOOK_INPUT=$(cat)

# Fail-closed-open: if jq isn't available or input is malformed, allow (exit 0)
# rather than crash. We prefer availability over false positives from parser bugs.
if ! command -v jq >/dev/null 2>&1; then
  echo '{}'
  exit 0
fi

TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name // ""')

# Only run the full guard on Bash calls. Other tools pass through.
if [[ "$TOOL_NAME" != "Bash" ]]; then
  echo '{}'
  exit 0
fi

COMMAND=$(echo "$HOOK_INPUT" | jq -r '.tool_input.command // ""')

# ---- Helper: emit block decision in 2026 JSON format ----
block() {
  local id="$1"; local reason="$2"
  jq -n \
    --arg id "$id" \
    --arg reason "$reason" \
    '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: ("🚨 [" + $id + "] " + $reason)
      }
    }'
  # Log the block to an audit trail
  mkdir -p ~/.claude/logs
  printf '%s\n' "$(date -Iseconds) BLOCK $id $(printf '%q' "$COMMAND")" \
    >> ~/.claude/logs/pre-tool-use-bash.log
  exit 0
}

# ---- Dangerous patterns (ordered by severity) ----
# Each entry: ID | regex | human-readable reason
# Regexes are ERE (egrep -E). \b for word boundary. Whitespace-tolerant.

C="$COMMAND"
N="$(echo "$COMMAND" | tr -s '[:space:]' ' ')"  # normalized whitespace

# ----- Filesystem destruction -----
[[ "$N" =~ (^| )rm[[:space:]]+(-[a-zA-Z]*r[a-zA-Z]*[[:space:]]+(-[a-zA-Z]*f[a-zA-Z]*[[:space:]]+)?|-[a-zA-Z]*f[a-zA-Z]*[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*[[:space:]]+)/( |$) ]] \
  && block "rm-root" "rm -rf targeting root filesystem"
[[ "$N" =~ (^| )rm[[:space:]]+-[rf]{1,2}[[:space:]]*(~|\$HOME)(/?[[:space:]]|$) ]] \
  && block "rm-home" "rm -rf targeting home directory"
[[ "$N" =~ (^| )rm[[:space:]]+-[rf]{1,2}[[:space:]]+\.\.?(/?[[:space:]]|$) ]] \
  && block "rm-relative" "rm -rf targeting .. or ."
[[ "$N" =~ (^| )rm[[:space:]]+-[rf]{1,2}[[:space:]]+\*($|[[:space:]]) ]] \
  && block "rm-glob" "rm -rf *"
[[ "$N" =~ (^| )rm[[:space:]]+--no-preserve-root ]] \
  && block "rm-no-preserve" "rm --no-preserve-root is explicitly destructive"

# ----- Disk / filesystem format -----
[[ "$N" =~ (^| )dd[[:space:]]+.*of=/dev/(sd|nvme|mmcblk|vd|hd) ]] \
  && block "dd-raw-disk" "dd writing directly to a block device"
[[ "$N" =~ (^| )mkfs\.(ext[234]|xfs|btrfs|fat|ntfs|f2fs) ]] \
  && block "mkfs" "mkfs formats a filesystem"
[[ "$N" =~ ([[:space:]]|^)>[[:space:]]*/dev/(sd|nvme|mmcblk|vd|hd) ]] \
  && block "shell-redirect-disk" "shell redirect to a raw block device"

# ----- Process / system -----
[[ "$N" =~ (^| )(shutdown|reboot|halt|poweroff)([[:space:]]|$) ]] \
  && block "power" "system power command"
[[ "$N" =~ :\(\)\{[[:space:]]*:\|:\&[[:space:]]*\}\;: ]] \
  && block "fork-bomb" "fork bomb pattern"

# ----- Git destruction -----
[[ "$N" =~ git[[:space:]]+push([[:space:]]+-[a-zA-Z]+)*[[:space:]]+(-f|--force|--force-with-lease)([[:space:]]|$).*(main|master|release|production|prod) ]] \
  && block "force-push-protected" "force push to protected branch"
[[ "$N" =~ git[[:space:]]+push[[:space:]]+.*:(refs/heads/)?(main|master|release|production|prod)([[:space:]]|$) ]] \
  && block "delete-protected" "pushing delete to protected branch"
[[ "$N" =~ git[[:space:]]+(reset[[:space:]]+--hard[[:space:]]+(origin/)?(main|master|release|production|prod)|clean[[:space:]]+-[a-zA-Z]*f[a-zA-Z]*d)([[:space:]]|$) ]] \
  && block "git-destructive" "git reset --hard or clean -fd on protected context"
[[ "$N" =~ git[[:space:]]+(filter-repo|filter-branch)[[:space:]]+--force ]] \
  && block "git-rewrite" "git history rewrite"

# ----- Infra / cloud destruction -----
[[ "$N" =~ terraform[[:space:]]+(destroy|apply)[[:space:]]+.*-auto-approve ]] \
  && block "terraform-auto-destroy" "terraform destroy/apply -auto-approve"
[[ "$N" =~ kubectl[[:space:]]+delete[[:space:]]+(ns|namespace)[[:space:]]+(prod|production) ]] \
  && block "k8s-delete-prod-ns" "kubectl delete namespace prod"
[[ "$N" =~ docker[[:space:]]+(volume[[:space:]]+rm|system[[:space:]]+prune[[:space:]]+--volumes) ]] \
  && block "docker-volume" "docker destructive volume operation"
[[ "$N" =~ (^| )crontab[[:space:]]+-r($|[[:space:]]) ]] \
  && block "crontab-r" "crontab -r removes all cron jobs"

# ----- Shell/pipe exec of untrusted input -----
[[ "$N" =~ (curl|wget|fetch)[[:space:]]+.*\|[[:space:]]*(bash|sh|zsh|python|python3|node|ruby|perl)([[:space:]]|$) ]] \
  && block "pipe-to-shell" "piping untrusted download to an interpreter"
[[ "$N" =~ (eval|source)[[:space:]]+\$\(.*curl ]] \
  && block "eval-curl" "eval of curl output"

# ----- Permission destruction -----
[[ "$N" =~ chmod[[:space:]]+-R[[:space:]]+(000|777) ]] \
  && block "chmod-extreme" "chmod -R 000 or 777"
[[ "$N" =~ chown[[:space:]]+-R[[:space:]]+root ]] \
  && block "chown-root" "chown -R root"

# ----- Writes to /etc, /usr, /boot -----
[[ "$N" =~ (>|tee|cp|mv).*/(etc|usr|boot|sys|proc)/ ]] \
  && block "system-paths" "write targeting system directory"

# ----- Secret exfiltration via Bash (Read(./.env) deny does NOT cover these) -----
# These are the reasons the Bash guard exists at all — permissions.deny only
# blocks Claude's built-in Read/Edit/Write, not shell commands.
[[ "$N" =~ (^| )(cat|less|more|head|tail|strings|xxd)[[:space:]]+.*\.env($|[[:space:]]) ]] \
  && block "cat-env" "reading .env via shell"
[[ "$N" =~ (^| )(cat|less|more|head|tail)[[:space:]]+.*\.ssh/(id_|authorized_keys) ]] \
  && block "cat-ssh" "reading ssh keys via shell"
[[ "$N" =~ (^| )printenv($|[[:space:]]) ]] \
  && block "printenv" "printenv dumps all environment variables"
[[ "$N" =~ (^| )env($|[[:space:]]*\|) ]] \
  && block "env-dump" "bare env command dumps all environment variables"
[[ "$N" =~ echo[[:space:]]+\$[A-Z_]*(SECRET|TOKEN|KEY|PASSWORD|API_KEY) ]] \
  && block "echo-secret" "echoing a secret env var"
[[ "$N" =~ base64[[:space:]]+.*\.(env|pem|key) ]] \
  && block "base64-secrets" "base64-encoding a secrets file"

# ----- Extended: gpg, vault -----
[[ "$N" =~ rm[[:space:]]+.*\.gnupg ]] && block "rm-gnupg" "removing gnupg keyring"
[[ "$N" =~ vault[[:space:]]+kv[[:space:]]+(delete|destroy) ]] && block "vault-destroy" "vault kv destroy"

# All checks passed — allow the command to run.
echo '{}'
exit 0
```

That file is the single most important protection the blueprint provides. It represents failure-mode-1 defense (destructive execution) and failure-mode-6 defense (secret exfiltration through the bash side-channel that `permissions.deny` doesn't cover). Read it once, understand every pattern, then hand it over to `PreToolUse` and never think about it again. Every time Claude Code suggests a new destructive pattern you didn't anticipate, add it here — the feedback loop from the audit log in `~/.claude/logs/pre-tool-use-bash.log` makes this easy.

#### 3.4.2 `pre-tool-use-secrets.sh` — the path guard

Blocks `Read`/`Edit`/`Write`/`MultiEdit` targeting sensitive paths. This is the belt to the Bash guard's suspenders. Adapted from `karanb192/claude-code-hooks/protect-secrets.js`, ported to Bash for the blueprint.

```bash
#!/usr/bin/env bash
# ~/.claude/hooks/pre-tool-use-secrets.sh
#
# PreToolUse hook for Read/Edit/Write/MultiEdit.
# Blocks access to sensitive files. Note: permissions.deny in settings.json
# already covers some of these, but this hook is defense-in-depth — and it
# covers MultiEdit edits.file_path which settings.json denies cannot reach.

set -uo pipefail

HOOK_INPUT=$(cat)
if ! command -v jq >/dev/null 2>&1; then
  echo '{}'; exit 0
fi

TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name // ""')

# Collect every candidate file path from the tool input.
# Handles Read, Edit, Write (single file_path) and MultiEdit (edits[].file_path).
mapfile -t PATHS < <(
  echo "$HOOK_INPUT" | jq -r '
    .tool_input.file_path // empty,
    (.tool_input.edits[]?.file_path // empty),
    (.tool_input.path // empty)
  '
)

block() {
  local id="$1"; local reason="$2"; local path="$3"
  jq -n \
    --arg id "$id" \
    --arg reason "$reason" \
    --arg path "$path" \
    '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: ("🔒 [" + $id + "] " + $reason + " (" + $path + ")")
      }
    }'
  mkdir -p ~/.claude/logs
  printf '%s\n' "$(date -Iseconds) SECRET-BLOCK $id $path" \
    >> ~/.claude/logs/pre-tool-use-secrets.log
  exit 0
}

# Allowlist — these are publishable templates, not real secrets.
allowlisted() {
  local p="$1"
  [[ "$p" =~ \.env\.(example|sample|template|schema|dist)$ ]] && return 0
  [[ "$p" =~ /\.github/.*\.yml$ ]] && return 0
  return 1
}

for p in "${PATHS[@]}"; do
  [[ -z "$p" ]] && continue
  allowlisted "$p" && continue

  case "$p" in
    # Environment files
    *.env|*.env.*|*/.env|*/.env.*|.env|.env.*|.envrc)
      block "env-file" "environment file" "$p" ;;
    # SSH and GPG
    */.ssh/id_*|*/.ssh/id_rsa|*/.ssh/id_ed25519|*/.ssh/authorized_keys|*/.ssh/known_hosts)
      block "ssh-key" "SSH key or auth file" "$p" ;;
    */.gnupg/*|*.gpg|*.asc|*.pgp)
      block "gpg" "GPG keyring or encrypted blob" "$p" ;;
    # Cloud credentials
    */.aws/credentials|*/.aws/config)
      block "aws-cred" "AWS credentials" "$p" ;;
    */.kube/config|*.kubeconfig)
      block "k8s-cred" "Kubernetes config" "$p" ;;
    */.azure/credentials|*/.azure/accessTokens.json)
      block "azure-cred" "Azure credentials" "$p" ;;
    */.docker/config.json|*/.netrc|*/.pypirc|*/.npmrc)
      block "tool-cred" "tool credentials file" "$p" ;;
    # Certs and keys
    *.pem|*.key|*.p12|*.pfx|*.keystore|*.jks)
      block "cert-key" "cert/key material" "$p" ;;
    # Generic secrets
    */secrets.json|*/secrets.yaml|*/secrets.yml|*/secrets.toml|*secrets/*)
      block "secrets-file" "secrets file or directory" "$p" ;;
    *credentials.json|*/credentials/*)
      block "credentials" "credentials file or directory" "$p" ;;
    */.vault-token|*/.my.cnf|*/.pgpass)
      block "service-cred" "service credential" "$p" ;;
    # Claude Code's own secrets file
    */.claude/secrets.env|*/secrets.env)
      block "claude-secrets" "blueprint's own secrets.env" "$p" ;;
    # System directories (write-only concern but easier to deny all access)
    /etc/*|/usr/*|/boot/*|/sys/*|/proc/*)
      block "system-path" "system directory" "$p" ;;
  esac
done

echo '{}'
exit 0
```

#### 3.4.3 `post-tool-use-verify.sh` — the lint/test runner

Adapted from `bartolli/claude-code-typescript-hooks` (174 stars) and `diet103/claude-code-infrastructure-showcase`. Runs after every `Edit`/`Write`/`MultiEdit` on the changed file. Emits results via stderr so Claude sees them in its next turn. Advisory (exits 0) — does not block. Project-specific commands are loaded from `.claude/verify.sh` if the project ships one, otherwise falls back to language-detection defaults.

```bash
#!/usr/bin/env bash
# ~/.claude/hooks/post-tool-use-verify.sh
#
# PostToolUse hook: runs lint + tests after every file edit. Advisory only —
# exits 0 so it never blocks the agent. Output goes to stderr, which Claude
# Code pipes back into the session so Claude sees it on the next turn.

set -uo pipefail

HOOK_INPUT=$(cat)
if ! command -v jq >/dev/null 2>&1; then exit 0; fi

TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name // ""')
case "$TOOL_NAME" in
  Edit|Write|MultiEdit) ;;
  *) exit 0 ;;
esac

# Collect changed files.
mapfile -t FILES < <(
  echo "$HOOK_INPUT" | jq -r '
    .tool_input.file_path // empty,
    (.tool_input.edits[]?.file_path // empty)
  '
)
[[ ${#FILES[@]} -eq 0 ]] && exit 0

# Project-specific verify script takes precedence.
if [[ -x .claude/verify.sh ]]; then
  if ! output=$(.claude/verify.sh "${FILES[@]}" 2>&1); then
    printf '[post-tool-use-verify] FAILED (project script)\n%s\n' "$output" >&2
  else
    printf '[post-tool-use-verify] OK (project script)\n' >&2
  fi
  exit 0
fi

# Fallback: language detection on the changed file.
for f in "${FILES[@]}"; do
  [[ -z "$f" || ! -e "$f" ]] && continue
  case "$f" in
    *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs)
      if [[ -f package.json ]]; then
        (command -v pnpm >/dev/null && pnpm typecheck 2>&1 || npm run -s typecheck 2>&1) \
          | tail -30 >&2 || true
        (command -v pnpm >/dev/null && pnpm lint 2>&1 || npm run -s lint 2>&1) \
          | tail -30 >&2 || true
      fi
      break ;;
    *.py)
      if command -v uv >/dev/null 2>&1; then
        uv run ruff check "$f" 2>&1 | tail -30 >&2 || true
        uv run mypy "$f" 2>&1 | tail -30 >&2 || true
      fi
      break ;;
    *.rs)
      cargo check --message-format=short 2>&1 | tail -30 >&2 || true
      cargo clippy --message-format=short -- -D warnings 2>&1 | tail -20 >&2 || true
      break ;;
    *.go)
      go vet ./... 2>&1 | tail -30 >&2 || true
      break ;;
  esac
done

exit 0
```

Each project should ship its own `.claude/verify.sh` for anything non-trivial — the language-detection fallback exists for rapid prototyping, not production correctness.

#### 3.4.4 `session-start.sh` — context loader

Adapted from the `disler/claude-code-hooks-mastery` reference template (3,507 stars) and `doobidoo/mcp-memory-service/claude-hooks/core/session-start.js` (1,642 stars). Emits the modern `SessionStart` `additionalContext` shape.

```bash
#!/usr/bin/env bash
# ~/.claude/hooks/session-start.sh
#
# SessionStart hook: loads recent project context and injects it as additional
# context on the fresh session. Runs on startup, /clear, and auto-compact.

set -uo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo '{}'; exit 0
fi

HOOK_INPUT=$(cat)
CWD=$(echo "$HOOK_INPUT" | jq -r '.cwd // ""')
SOURCE=$(echo "$HOOK_INPUT" | jq -r '.source // "startup"')

context=""

# 1. Inject STATE.md if present — current in-progress context.
if [[ -f "$CWD/STATE.md" ]]; then
  context+=$'## Current state (from STATE.md)\n\n'
  context+=$(head -100 "$CWD/STATE.md")$'\n\n'
fi

# 2. Inject the last 10 lines of DECISIONS.md if present.
if [[ -f "$CWD/DECISIONS.md" ]]; then
  context+=$'## Recent decisions (DECISIONS.md)\n\n'
  context+=$(tail -30 "$CWD/DECISIONS.md")$'\n\n'
fi

# 3. Inject the current git status snapshot.
if (cd "$CWD" && git rev-parse --git-dir >/dev/null 2>&1); then
  branch=$(cd "$CWD" && git branch --show-current 2>/dev/null || echo "")
  status=$(cd "$CWD" && git status --short 2>/dev/null | head -20 || echo "")
  recent=$(cd "$CWD" && git log --oneline -5 2>/dev/null || echo "")
  context+=$'## Git context\n\n'
  context+="Branch: $branch"$'\n\n'
  if [[ -n "$status" ]]; then
    context+=$'Working tree:\n```\n'"$status"$'\n```\n\n'
  fi
  context+=$'Recent commits:\n```\n'"$recent"$'\n```\n\n'
fi

# 4. Note the active spec-kit feature, if one is in progress.
if [[ -d "$CWD/specs" ]]; then
  active_spec=$(ls -t "$CWD/specs" 2>/dev/null | head -1 || echo "")
  if [[ -n "$active_spec" && -d "$CWD/specs/$active_spec" ]]; then
    context+=$'## Active spec-kit feature\n\n'
    context+="Directory: specs/$active_spec"$'\n'
    for f in spec.md plan.md tasks.md; do
      if [[ -f "$CWD/specs/$active_spec/$f" ]]; then
        context+="- specs/$active_spec/$f"$'\n'
      fi
    done
    context+=$'\n'
  fi
fi

# 5. First-run reminder on the day the regression mitigations were enabled.
if [[ "$SOURCE" == "startup" ]]; then
  context+=$'## Session reminders\n\n'
  context+=$'- CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1 (regression mitigation, still active).\n'
  context+=$'- Hooks enforce TDD verification; superpowers enforces TDD discipline.\n'
  context+=$'- When in doubt: smaller diff, clearer test, earlier question.\n'
fi

# Emit the SessionStart-specific JSON shape.
jq -n --arg ctx "$context" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'
exit 0
```

#### 3.4.5 `user-prompt-submit.sh` — spec context injector *[skeleton]*

This one is flagged as a skeleton because the delta-research found **no battle-tested public example** for the spec-kit context injector pattern. It is built from the canonical `disler/claude-code-hooks-mastery/user_prompt_submit.py` protocol and should be hardened against your workflow before trust.

```bash
#!/usr/bin/env bash
# ~/.claude/hooks/user-prompt-submit.sh
#
# UserPromptSubmit hook: injects active spec-kit context into every user
# prompt when a feature is in progress. Built from disler/claude-code-hooks-
# mastery skeleton — [skeleton], not yet battle-tested.

set -uo pipefail

if ! command -v jq >/dev/null 2>&1; then exit 0; fi

HOOK_INPUT=$(cat)
CWD=$(echo "$HOOK_INPUT" | jq -r '.cwd // ""')
PROMPT=$(echo "$HOOK_INPUT" | jq -r '.prompt // ""')

# Find the most recently modified spec directory.
active_spec=""
if [[ -d "$CWD/specs" ]]; then
  active_spec=$(ls -t "$CWD/specs" 2>/dev/null | head -1 || echo "")
fi

[[ -z "$active_spec" ]] && { echo '{}'; exit 0; }

# Only inject for prompts that look like implementation requests.
# Heuristic: contains "implement", "continue", "next task", or an @mention of the spec.
if ! echo "$PROMPT" | grep -iqE '(implement|continue|next task|@spec|@plan|@tasks)'; then
  echo '{}'; exit 0
fi

ctx=""
for f in plan.md tasks.md; do
  if [[ -f "$CWD/specs/$active_spec/$f" ]]; then
    ctx+=$'## '"$f"$' (active feature: '"$active_spec"$')\n\n'
    ctx+='```markdown'$'\n'
    ctx+=$(cat "$CWD/specs/$active_spec/$f")$'\n'
    ctx+='```'$'\n\n'
  fi
done

[[ -z "$ctx" ]] && { echo '{}'; exit 0; }

jq -n --arg c "$ctx" '{
  hookSpecificOutput: {
    hookEventName: "UserPromptSubmit",
    additionalContext: $c
  }
}'
exit 0
```

#### 3.4.6 `stop-failure.sh` — incident logger *[skeleton]*

Also flagged as a skeleton. Built from `disler/claude-code-hooks-mastery/post_tool_use_failure.py`, with a local logging sink instead of Linear/GitHub-issue creation (the research found no battle-tested public example of the ticket-creator pattern).

```bash
#!/usr/bin/env bash
# ~/.claude/hooks/stop-failure.sh
#
# StopFailure hook: logs unrecoverable failures to ~/.claude/logs/failures.jsonl
# with enough context for a post-mortem. Does not open tickets (build that on
# top if your workflow uses Linear or GitHub Issues). [skeleton]

set -uo pipefail

if ! command -v jq >/dev/null 2>&1; then exit 0; fi

HOOK_INPUT=$(cat)
mkdir -p ~/.claude/logs

# Append the full event as a JSONL line for later analysis.
ts=$(date -Iseconds)
jq --arg ts "$ts" '{ ts: $ts, event: . }' <<<"$HOOK_INPUT" \
  >> ~/.claude/logs/failures.jsonl

# Emit a human-readable summary to the live transcript.
session_id=$(echo "$HOOK_INPUT" | jq -r '.session_id // "?"')
error_type=$(echo "$HOOK_INPUT" | jq -r '.error_type // .error.type // "unknown"')
echo "[stop-failure] $ts session=$session_id type=$error_type logged to ~/.claude/logs/failures.jsonl" >&2
exit 0
```

#### 3.4.7 `session-end.sh` — decision checkpoint

Adapted from `doobidoo/mcp-memory-service/claude-hooks/core/session-end.js` and `disler/claude-code-hooks-mastery/.claude/hooks/session_end.py`. On every session end, appends a one-paragraph summary to `DECISIONS.md` in the project root so the next session's SessionStart hook can load it. This is the self-improving-loop primitive (principle 11).

```bash
#!/usr/bin/env bash
# ~/.claude/hooks/session-end.sh
#
# SessionEnd hook: appends a dated checkpoint to DECISIONS.md in the project.
# This is the substrate for the self-improvement loop — the file that every
# SessionStart reloads.

set -uo pipefail

if ! command -v jq >/dev/null 2>&1; then exit 0; fi

HOOK_INPUT=$(cat)
CWD=$(echo "$HOOK_INPUT" | jq -r '.cwd // ""')
SESSION_ID=$(echo "$HOOK_INPUT" | jq -r '.session_id // "unknown"')
REASON=$(echo "$HOOK_INPUT" | jq -r '.reason // "exit"')
TRANSCRIPT=$(echo "$HOOK_INPUT" | jq -r '.transcript_path // ""')

[[ -z "$CWD" ]] && exit 0
[[ ! -d "$CWD/.git" ]] && exit 0   # only in git repos

DECISIONS="$CWD/DECISIONS.md"
touch "$DECISIONS"

# Extract the most recent commits made during this session (since the session_start)
# as a crude proxy for "what happened."
since_ts=""
if [[ -f "$CWD/.claude/.session-started-$SESSION_ID" ]]; then
  since_ts=$(cat "$CWD/.claude/.session-started-$SESSION_ID")
fi

recent_commits=""
if [[ -n "$since_ts" ]]; then
  recent_commits=$(cd "$CWD" && git log --since="$since_ts" --oneline 2>/dev/null | head -10)
fi
[[ -z "$recent_commits" ]] && recent_commits=$(cd "$CWD" && git log --oneline -3 2>/dev/null)

branch=$(cd "$CWD" && git branch --show-current 2>/dev/null || echo "")

# Append the checkpoint.
{
  echo ""
  echo "## $(date -Iseconds) — session $SESSION_ID ($REASON)"
  echo ""
  echo "Branch: \`$branch\`"
  echo ""
  if [[ -n "$recent_commits" ]]; then
    echo "Recent commits:"
    echo ""
    echo '```'
    echo "$recent_commits"
    echo '```'
    echo ""
  fi
  if [[ -n "$TRANSCRIPT" ]]; then
    echo "Transcript: \`$TRANSCRIPT\`"
    echo ""
  fi
} >> "$DECISIONS"

# Cleanup session-start marker.
rm -f "$CWD/.claude/.session-started-$SESSION_ID" 2>/dev/null || true

exit 0
```

### 3.5 `~/.claude/statusline.sh` — live context % with color gates

Adapted from Freek Van der Herten's March 2, 2026 "My Claude Code setup" essay. The specific innovation is a color-coded display of context-window utilization — green below 40%, yellow 40–59%, red 60%+. This is the single highest-leverage "how full is the window" signal for a human sitting in front of the terminal, and it's surprisingly absent from most published setups.

```bash
#!/usr/bin/env bash
# ~/.claude/statusline.sh
#
# Custom status line: live repo name + branch + context-window utilization
# with color gates. Inspired by Freek Van der Herten's March 2 2026 essay.
# Runs on every prompt submit (Claude Code invokes this and displays stdout).

set -uo pipefail

HOOK_INPUT=$(cat 2>/dev/null || echo "{}")
# Claude Code passes the session state; parse what we can.
if command -v jq >/dev/null 2>&1; then
  model=$(echo "$HOOK_INPUT" | jq -r '.model // "claude-sonnet-4-6"' 2>/dev/null)
  used=$(echo "$HOOK_INPUT" | jq -r '.context.used_tokens // 0' 2>/dev/null)
  limit=$(echo "$HOOK_INPUT" | jq -r '.context.limit_tokens // 200000' 2>/dev/null)
else
  model="claude-sonnet-4-6"; used=0; limit=200000
fi

pct=0
if [[ "$limit" -gt 0 ]]; then
  pct=$(( (used * 100) / limit ))
fi

# Color gates: green <40, yellow 40-59, red 60+
if   [[ $pct -lt 40 ]]; then color=$'\033[32m'   # green
elif [[ $pct -lt 60 ]]; then color=$'\033[33m'   # yellow
else                         color=$'\033[31m'   # red
fi
reset=$'\033[0m'
dim=$'\033[2m'

# Repo + branch (if in a git repo)
repo=""; branch=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  repo=$(basename "$(git rev-parse --show-toplevel)")
  branch=$(git branch --show-current 2>/dev/null || echo "?")
fi

# Model short name
case "$model" in
  *opus*)   m="opus" ;;
  *sonnet*) m="sonnet" ;;
  *haiku*)  m="haiku" ;;
  *)        m="$model" ;;
esac

# Emit
printf '%s[%s]%s %s%s/%s%s %sctx %s%d%%%s' \
  "$dim" "$m" "$reset" \
  "$dim" "$repo" "$branch" "$reset" \
  "$dim" "$color" "$pct" "$reset"
```

That's the whole user scope except the secrets file, which is a literal `~/.claude/secrets.env` with `chmod 600` containing `ANTHROPIC_API_KEY=…`, `GITHUB_PAT=…`, `SENTRY_AUTH_TOKEN=…`, `EXA_API_KEY=…`, `LANGFUSE_PUBLIC_KEY=…`, `LANGFUSE_SECRET_KEY=…`. Gitignored via allowlist in the dotfile repo. Never committed. Never read by Claude Code's built-in `Read` tool (the secrets hook blocks it). Only loaded by the bootstrap script and by `~/.claude/bin/otel-headers-helper.sh`:

```bash
#!/usr/bin/env bash
# ~/.claude/bin/otel-headers-helper.sh
# Emits OTEL_EXPORTER_OTLP_HEADERS on stdout. Called by Claude Code's
# otelHeadersHelper setting so Langfuse basic-auth never lives in settings.json.
set -euo pipefail
source "${HOME}/.claude/secrets.env"
auth=$(printf '%s:%s' "${LANGFUSE_PUBLIC_KEY:-}" "${LANGFUSE_SECRET_KEY:-}" | base64 -w 0)
printf 'Authorization=Basic %s,x-langfuse-ingestion-version=4' "$auth"
```

### 3.6 `<project>/.claude/settings.json` — project scope

Thin on purpose. Array-merges with user scope (hooks and permission rules concatenate). Only contains what's *specific* to this project.

```jsonc
// <project>/.claude/settings.json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",

  // Project-specific permission extensions (merge with user scope).
  "permissions": {
    "allow": [
      "Bash(pnpm run dev)",
      "Bash(pnpm run db:*)",
      "Bash(pnpm test -- --testPathPattern=*)",
      "Bash(./scripts/e2e.sh*)"
    ],
    "additionalDirectories": [
      "../shared-libs"
    ]
  },

  // Project-specific hook: per-language verify script.
  // Chains: user-scope post-tool-use-verify.sh runs first, then this one.
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PROJECT_DIR}/.claude/verify.sh" }
        ]
      }
    ]
  }
}
```

And the project-shipped verify script, called by the hook:

```bash
#!/usr/bin/env bash
# <project>/.claude/verify.sh
# Project-specific verification. Runs after every Edit/Write. Exits non-zero
# only if the error is unrecoverable — otherwise emits to stderr and exits 0.
set -uo pipefail

changed_files=("$@")

# Type check
pnpm run -s typecheck 2>&1 | tail -20 >&2 || true

# Targeted test run based on changed files
for f in "${changed_files[@]}"; do
  case "$f" in
    src/*.ts|src/*.tsx)
      test_file="${f/src/tests}"
      test_file="${test_file%.*}.test.ts"
      if [[ -f "$test_file" ]]; then
        pnpm test -- --testPathPattern="$test_file" 2>&1 | tail -20 >&2 || true
      fi
      ;;
  esac
done

exit 0
```

### 3.7 `<project>/.claude/CLAUDE.md` — project invariants (short)

The user-scope `~/.claude/CLAUDE.md` holds principles. The project-scope holds *invariants*. It is directive, terse, and specific to this codebase.

```markdown
<!-- <project>/.claude/CLAUDE.md -->
<!-- Project-specific invariants. Principles live in ~/.claude/CLAUDE.md. -->
<!-- Keep this file under 60 lines. -->

# Project: acme-payments-api

## Stack
- TypeScript 5.6, Node 22, Fastify 5
- Postgres 16 via Drizzle ORM
- Pinned test runner: `vitest`
- Package manager: `pnpm` (never `npm`, never `yarn`)

## Invariants
- **Every route** in `src/api/**` requires an integration test in `tests/api/**`.
- **Every database migration** in `db/migrations/**` must be backward-compatible. No destructive ops without a two-phase plan.
- **Secrets** never appear in logs, error responses, or test fixtures. Use `redactSecrets()` from `src/lib/log`.
- **Authz checks** must precede any read or write of user-scoped resources.
- **SQL** is parameterized via Drizzle query builders. Raw string concatenation is a bug, even with escaping.
- **External HTTP calls** must set a `timeout` and retry budget. Use `src/lib/http` — never bare `fetch`.
- **Error messages** shown to end users must not leak internal paths, stack frames, or IDs.

## Commands
- Dev: `pnpm dev`
- Test: `pnpm test`
- Typecheck: `pnpm typecheck`
- Lint: `pnpm lint`
- DB reset (dev only): `pnpm db:reset`
- E2E: `./scripts/e2e.sh`

## Layout
- `src/api/` — route handlers (thin)
- `src/domain/` — business logic (pure, unit tested)
- `src/db/` — Drizzle schema + queries
- `src/lib/` — shared utilities (preferred over new abstractions)
- `tests/api/` — integration tests (real Postgres)
- `tests/unit/` — unit tests
- `scripts/` — operational scripts

## Conventions
- Prefer `src/lib/*` before introducing new abstractions.
- Prefer early returns over nested conditionals.
- Structured logging only: `logger.info({ requestId, userId }, 'event')`.
- No `any`, no `unknown` at API boundaries. Use Zod schemas.

## Do NOT
- Do not introduce a new dependency without asking first.
- Do not refactor `src/domain/` without spec-kit plan approval.
- Do not touch `db/migrations/` without a migration spec.
- Do not change `.env.example` without updating `docs/setup.md`.
```

### 3.8 `<project>/REVIEW.md` — Code Review for Claude Code config (verbatim docs template)

Important: this file lives at the **repository root**, not inside `.claude/`. Anthropic's Code Review GitHub App auto-discovers only at root. No schema, no frontmatter — pure Markdown sections that the managed review agents read during each review.

```markdown
<!-- <project>/REVIEW.md -->
<!-- Auto-discovered by Code Review for Claude Code at repository root. -->
<!-- Additive on top of default correctness checks. Violations of ## Always flag -->
<!-- become Important findings; violations of ## Style become Nit findings.      -->

# Code Review Guidelines

## Context
Service: acme-payments-api. Stack: TypeScript + Fastify + Postgres/Drizzle.
High-risk areas: `src/auth/**`, `src/billing/**`, `db/migrations/**`.
Follow existing patterns in `src/lib/` before proposing new abstractions.

## Always flag (Important)
- New or modified routes in `src/api/**` without a corresponding integration test in `tests/api/**`.
- Database migrations that are not backward-compatible.
- Secrets, credentials, or API keys in logs, error messages, or test fixtures.
- Missing authz check on any route that accepts a user-scoped resource ID.
- SQL built by string concatenation — require Drizzle query builders.
- New external HTTP calls without a timeout and retry budget.
- Error messages that leak internal paths, stack frames, or IDs to end users.
- Public API shape changes without a corresponding changeset under `.changeset/`.
- Use of `any` or `unknown` at API boundaries (Zod schema required instead).

## Style (Nit)
- Prefer early returns over nested conditionals.
- Prefer structured logging (`logger.info({ ... }, 'event')`) over template interpolation.
- Prefer discriminated unions over chained `instanceof`/`isinstance` checks.
- Use `readonly` on DTO fields; avoid mutable exported constants.
- Tests: arrange-act-assert blocks separated by blank lines; one behavior per test.

## Verify behavior, not just shape
- When flagging a race condition or ordering bug, trace one concrete interleaving.
- When flagging a null/undefined path, confirm the caller can reach it from a public entrypoint.
- Prefer silence over speculation: if a finding cannot be verified against the codebase, skip it.

## Skip
- Generated code under `src/gen/**`, `proto/**`, `*.pb.ts`.
- Lockfile diffs (`pnpm-lock.yaml`, `package-lock.json`).
- Snapshot test updates under `**/__snapshots__/**` unless logic changed.
- Formatting-only diffs (Prettier owns those).
- Comments on TODO/FIXME markers that already exist on `main`.

## Pre-existing bugs (Purple)
Surface pre-existing bugs in files touched by the PR when they are in the same module.
Do NOT block on pre-existing findings; call them out so the author can decide.

## Interaction with CLAUDE.md
CLAUDE.md holds architectural invariants used by all Claude Code tasks.
This file (REVIEW.md) holds review-only rules. When both apply, both fire.
If a PR invalidates a CLAUDE.md statement, flag the docs update as a nit.
```

### 3.9 `<project>/.mcp.json` — the nine-server stack

This is the project-scope MCP config, committed to git. Nine servers, each with a stated purpose, verified install command, and explicit reason. No servers beyond this list unless you can articulate why.

```jsonc
// <project>/.mcp.json
// Supports ${VAR} and ${VAR:-default} expansion (project-scope only).
// All stdio servers are version-pinned via the upstream command's own
// @latest/@sha mechanism. Remote servers use authenticated HTTPS.
{
  "mcpServers": {
    // 1. Serena — LSP-based semantic code editing across 30+ languages.
    // The single biggest context-efficiency gain in the stack.
    "serena": {
      "type": "stdio",
      "command": "uvx",
      "args": [
        "--from", "git+https://github.com/oraios/serena",
        "serena", "start-mcp-server",
        "--context", "ide-assistant",
        "--project", "${CLAUDE_PROJECT_DIR:-.}"
      ]
    },

    // 2. Context7 — real-time library doc lookup. Halves hallucinated APIs.
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },

    // 3. Playwright — a11y-tree-based browser automation, 10-100x faster
    // than screenshot tools.
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    },

    // 4. DeepWiki — remote no-auth repository Q&A.
    "deepwiki": {
      "type": "http",
      "url": "https://mcp.deepwiki.com/mcp"
    },

    // 5. GitHub — official github-mcp-server via remote HTTP.
    //    PAT is sourced from secrets.env at bootstrap time.
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp",
      "headers": {
        "Authorization": "Bearer ${GITHUB_PAT}"
      }
    },

    // 6. Sentry — production error triage. Read-only scope for the token.
    "sentry": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@sentry/mcp-server@latest"],
      "env": {
        "SENTRY_AUTH_TOKEN": "${SENTRY_AUTH_TOKEN}",
        "SENTRY_ORG": "${SENTRY_ORG:-}",
        "SENTRY_PROJECT": "${SENTRY_PROJECT:-}"
      }
    },

    // 7. Exa — semantic + keyword web search.
    "exa": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "exa-mcp-server@latest"],
      "env": {
        "EXA_API_KEY": "${EXA_API_KEY}"
      }
    },

    // 8. container-use — per-agent containers + git branches. The sandbox.
    //    This is also the enforcement point for failure mode 1 (destructive
    //    execution) even if every other hook fails.
    "container-use": {
      "type": "stdio",
      "command": "container-use",
      "args": ["stdio"]
    },

    // 9. mcp-memory-service — long-term memory with dream-inspired
    //    consolidation and #remember/#skip hooks.
    "memory": {
      "type": "stdio",
      "command": "uvx",
      "args": ["mcp-memory-service"],
      "env": {
        "MCP_MEMORY_BACKEND": "sqlite-vec",
        "MCP_MEMORY_PATH": "${HOME}/.claude/memory"
      }
    }
  }
}
```

Deliberately **not** in this stack: Supabase MCP (Supabase's own docs warn against production data), any filesystem MCP with delete capabilities (use `container-use` instead), any MCP server with unknown provenance (OWASP MCP Top 10 + ~40% command-injection vulnerability rate from the Practical DevSecOps scan), any "chat with your database" MCP pointed at prod. If you need Supabase for dev, register it in `.mcp.local.json` so it's gitignored and local-only.

### 3.10 `.github/workflows/claude-*.yml` — the five canonical recipes

Verbatim from `systemprompt.io`'s March 10 2026 guide. Each recipe lives in its own file for clarity. Dropping any of the five is fine; they are additive.

```yaml
# .github/workflows/claude-pr-review.yml
name: Claude PR Review
on:
  pull_request:
    types: [opened, synchronize]
    paths-ignore:
      - '*.md'
      - 'docs/**'
jobs:
  review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Review this pull request thoroughly. Focus on:
            1. Logic errors and potential bugs
            2. Security vulnerabilities (SQL injection, XSS, auth bypasses)
            3. Performance issues (N+1 queries, blocking calls)
            4. Error handling gaps
            5. API contract changes that could break clients

            Format your review as:
            ## Summary
            One paragraph overview.
            ## Issues Found
            File path, line number, severity, explanation.
            ## Positive Notes
            Highlight anything done particularly well.

            Do NOT comment on style, formatting, or naming unless it creates a genuine
            readability problem.
```

```yaml
# .github/workflows/claude-issue-to-pr.yml
name: Claude Issue to PR
on:
  issue_comment:
    types: [created]
jobs:
  implement:
    if: contains(github.event.comment.body, '@claude')
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Read the issue description and the comment that triggered this workflow.
            Implement the requested changes.
            Create a new branch, commit your changes, and open a pull request.
            Reference the issue number in the PR description.
            If the request is unclear or too large, post a comment explaining what
            clarification you need instead of implementing.
```

```yaml
# .github/workflows/claude-docs-update.yml
name: Claude Docs Update
on:
  push:
    branches: [main]
    paths:
      - 'src/api/**'
      - 'src/lib/**'
jobs:
  update-docs:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 2 }
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Compare the current commit with the previous commit.
            Identify any changes to public APIs, function signatures, or behaviour.
            Update the corresponding documentation files in docs/.
            Commit your changes and open a PR titled "docs: update for recent API changes".
```

```yaml
# .github/workflows/claude-test-generation.yml
name: Claude Test Generation
on:
  pull_request:
    types: [opened]
    paths:
      - 'src/**'
      - '!src/**/*.test.*'
      - '!src/**/*.spec.*'
jobs:
  generate-tests:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Analyse the new or modified source files in this PR.
            For each file that lacks corresponding test coverage, write tests.
            Follow the existing test patterns. Use the same testing framework
            already in use. Commit to this branch.
            Post a comment summarising what was added.
```

```yaml
# .github/workflows/claude-release-notes.yml
name: Claude Release Notes
on:
  release:
    types: [created]
jobs:
  release-notes:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Generate release notes for this release.
            Compare current tag with previous tag.
            Categorise into: Features, Bug Fixes, Performance, Breaking Changes, Other.
            Write in plain language. Include PR number per change where available.
            Update the release body on GitHub with the notes.
```

### 3.11 `.github/workflows/code-review-gate.yml` — merge blocking on severity

This is the file that converts the managed Code Review's always-neutral check run into a merge-blocking gate. Built on the documented `gh api | jq` incantation from the Code Review docs page, plus standard CI error handling. Without this file, Code Review is advisory only; with it, any `normal > 0` finding (🔴 Important) blocks merge via branch protection (you need to mark this job "Required" in branch settings).

```yaml
# .github/workflows/code-review-gate.yml
name: Code Review Gate
on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  wait-and-gate:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: read
      checks: read
    steps:
      - name: Wait for Claude Code Review to complete
        id: wait
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          HEAD_SHA: ${{ github.event.pull_request.head.sha }}
        run: |
          set -euo pipefail
          # Poll up to 30 minutes for the Claude Code Review check run.
          for i in $(seq 1 60); do
            id=$(gh api "repos/${GITHUB_REPOSITORY}/commits/${HEAD_SHA}/check-runs" \
              --jq '.check_runs[] | select(.name == "Claude Code Review") | select(.status == "completed") | .id' \
              | head -n1)
            if [[ -n "$id" ]]; then
              echo "check_run_id=$id" >> "$GITHUB_OUTPUT"
              exit 0
            fi
            sleep 30
          done
          echo "Claude Code Review did not complete in 30 minutes — allowing merge."
          echo "check_run_id=" >> "$GITHUB_OUTPUT"

      - name: Parse bughunter-severity and gate merge
        if: steps.wait.outputs.check_run_id != ''
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          CHECK_RUN_ID: ${{ steps.wait.outputs.check_run_id }}
        run: |
          set -euo pipefail
          severity=$(gh api "repos/${GITHUB_REPOSITORY}/check-runs/${CHECK_RUN_ID}" \
            --jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson')
          echo "Severity: $severity"
          normal=$(printf '%s' "$severity" | jq -r '.normal // 0')
          nit=$(printf '%s' "$severity" | jq -r '.nit // 0')
          pre_existing=$(printf '%s' "$severity" | jq -r '.pre_existing // 0')
          echo "Important: $normal, Nit: $nit, Pre-existing: $pre_existing"
          if [[ "$normal" -gt 0 ]]; then
            echo "::error::Claude Code Review found ${normal} Important (red) finding(s). Resolve before merge."
            exit 1
          fi
          echo "No blocking findings."
```

Mark this job as required in the repo's branch-protection rules. That's what turns Code Review from advisory into structural.

### 3.12 `docker-compose.observability.yml` — self-hosted Langfuse

The canonical Langfuse v3 docker-compose is ~170 lines (MinIO + Postgres + ClickHouse + Redis + Langfuse worker + Langfuse web). The verified source is:

```
https://raw.githubusercontent.com/langfuse/langfuse/main/docker-compose.yml
```

Fetch it directly and save it as `docker-compose.observability.yml` in the project root (or in `~/ops/langfuse/` for a machine-wide install — the blueprint's bootstrap script uses the latter). Minimum env overrides you should set before `docker compose up -d`:

```bash
# ~/ops/langfuse/.env
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=$(openssl rand -hex 32)
SALT=$(openssl rand -hex 16)
ENCRYPTION_KEY=$(openssl rand -hex 32)
LANGFUSE_INIT_ORG_NAME="Local"
LANGFUSE_INIT_PROJECT_NAME="claude-code"
LANGFUSE_INIT_USER_EMAIL="you@example.com"
LANGFUSE_INIT_USER_NAME="You"
LANGFUSE_INIT_USER_PASSWORD=$(openssl rand -hex 16)
# Note down LANGFUSE_INIT_PROJECT_PUBLIC_KEY / SECRET_KEY — they go in ~/.claude/secrets.env
```

After first boot, log into `http://localhost:3000`, create a project, grab the public and secret keys, and paste them into `~/.claude/secrets.env` as `LANGFUSE_PUBLIC_KEY` / `LANGFUSE_SECRET_KEY`. The `otelHeadersHelper` in section 3.1 and 3.5 picks them up automatically.

**Do not attempt to trim the compose file.** Langfuse v3 requires S3-compatible storage and the bundled MinIO is the canonical pattern. Dropping MinIO will cause event upload to silently fail. This was a real finding from the integration-commands research lane.

### 3.13 `scripts/bootstrap.sh` — the idempotent installer

Run this once to initialize the whole blueprint on a new machine. Safe to re-run; each step checks idempotently.

```bash
#!/usr/bin/env bash
# scripts/bootstrap.sh
# Blueprint installer for a serious Claude Code setup. Idempotent.
# Run: bash scripts/bootstrap.sh
set -euo pipefail

# ---- 0. Pre-flight ----
need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }; }
for t in git curl jq gh docker uv; do need "$t"; done

CLAUDE_HOME="${HOME}/.claude"
mkdir -p \
  "${CLAUDE_HOME}" \
  "${CLAUDE_HOME}/hooks" \
  "${CLAUDE_HOME}/skills" \
  "${CLAUDE_HOME}/commands" \
  "${CLAUDE_HOME}/agents" \
  "${CLAUDE_HOME}/bin" \
  "${CLAUDE_HOME}/logs" \
  "${CLAUDE_HOME}/memory"

# ---- 1. Claude Code native binary installer (not npm global) ----
# The axios DPRK supply-chain incident of 2026-03-31 is why this is non-optional.
if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code via native binary installer..."
  curl -fsSL https://claude.ai/install.sh | bash
fi
claude --version

# ---- 2. secrets.env scaffold ----
if [[ ! -f "${CLAUDE_HOME}/secrets.env" ]]; then
  cat > "${CLAUDE_HOME}/secrets.env" <<'EOF'
# ~/.claude/secrets.env — chmod 600, gitignored, never committed.
# Fill these in and source before running `claude`.
ANTHROPIC_API_KEY=
GITHUB_PAT=
SENTRY_AUTH_TOKEN=
SENTRY_ORG=
SENTRY_PROJECT=
EXA_API_KEY=
LANGFUSE_PUBLIC_KEY=
LANGFUSE_SECRET_KEY=
EOF
  chmod 600 "${CLAUDE_HOME}/secrets.env"
  echo "Created ${CLAUDE_HOME}/secrets.env — fill it in before first claude run."
fi

# ---- 3. Observability stack: self-hosted Langfuse ----
OPS_DIR="${HOME}/ops/langfuse"
if [[ ! -d "${OPS_DIR}" ]]; then
  mkdir -p "${OPS_DIR}"
  curl -fsSL https://raw.githubusercontent.com/langfuse/langfuse/main/docker-compose.yml \
    > "${OPS_DIR}/docker-compose.yml"
  if [[ ! -f "${OPS_DIR}/.env" ]]; then
    cat > "${OPS_DIR}/.env" <<EOF
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=$(openssl rand -hex 32)
SALT=$(openssl rand -hex 16)
ENCRYPTION_KEY=$(openssl rand -hex 32)
LANGFUSE_INIT_ORG_NAME=Local
LANGFUSE_INIT_PROJECT_NAME=claude-code
LANGFUSE_INIT_USER_EMAIL=you@example.com
LANGFUSE_INIT_USER_PASSWORD=$(openssl rand -hex 16)
EOF
    echo "Langfuse env scaffolded at ${OPS_DIR}/.env — customize before first boot."
  fi
  (cd "${OPS_DIR}" && docker compose up -d)
  echo "Langfuse starting on http://localhost:3000 — log in, grab public/secret keys, paste into ~/.claude/secrets.env"
fi

# ---- 4. Cost tracking & desktop inspection ----
if ! command -v ccusage >/dev/null 2>&1; then
  echo "Installing ccusage..."
  npm i -g ccusage@latest  # or: brew install ccusage if you prefer brew
fi
# claude-devtools is a desktop Electron app; install instructions vary by OS.
# Linux AppImage: download from https://github.com/matt1398/claude-devtools/releases
# macOS: brew install --cask claude-devtools

# ---- 5. Spec-Kit (uv tool, not pipx) ----
if ! command -v specify-cli >/dev/null 2>&1; then
  uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.5.1
fi

# ---- 6. container-use sandbox ----
if ! command -v container-use >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/dagger/container-use/main/install.sh | bash
fi

# ---- 7. Superpowers plugin (the discipline foundation) ----
# Requires an interactive claude session on first install; instruct the user.
if ! claude plugin list 2>/dev/null | grep -q superpowers; then
  echo ""
  echo "Next step: open claude and run:"
  echo "  /plugin install superpowers@claude-plugins-official"
  echo ""
fi

# ---- 8. Dotfile linking: AGENTS.md symlink ----
if [[ -f "${CLAUDE_HOME}/CLAUDE.md" && ! -e "${CLAUDE_HOME}/AGENTS.md" ]]; then
  ln -sf "${CLAUDE_HOME}/CLAUDE.md" "${CLAUDE_HOME}/AGENTS.md"
fi

# ---- 9. Permissions on hooks ----
chmod +x "${CLAUDE_HOME}/hooks"/*.sh 2>/dev/null || true
chmod +x "${CLAUDE_HOME}/bin"/*.sh 2>/dev/null || true
chmod +x "${CLAUDE_HOME}/statusline.sh" 2>/dev/null || true

# ---- 10. First-project init hint ----
cat <<'EOF'

Bootstrap complete. Next:

  1. Fill in ~/.claude/secrets.env (API keys, Langfuse public/secret keys).
  2. Open Claude Code and run:
       /plugin install superpowers@claude-plugins-official
  3. Enable Code Review for Claude Code:
       claude.ai/admin-settings/claude-code  →  Code Review  →  Setup
  4. In your project directory:
       specify-cli init
       ln -sf CLAUDE.md AGENTS.md
       (cp the blueprint's .mcp.json, .claude/, REVIEW.md, .github/workflows/)
  5. Start the first feature:
       cd <project> && claude
       /speckit.constitution
       /speckit.specify "Your first feature..."

EOF
```

---

## 4. The Workflow

### 4.1 Day 0: the install playbook in order

The order matters. Observability before orchestration (principle 9); sandbox before any autonomous run (principle 1); discipline plugin last because it depends on everything else.

1. **Run `scripts/bootstrap.sh`.** This installs Claude Code via native binary (failure-mode 6 defense), stands up Langfuse via docker-compose, installs `ccusage` and spec-kit and container-use, scaffolds `~/.claude/secrets.env`, and creates the directory structure.
2. **Fill in `~/.claude/secrets.env`.** The bootstrap left it blank. Fill in: `ANTHROPIC_API_KEY` (for CI only), `GITHUB_PAT`, `SENTRY_AUTH_TOKEN`, `EXA_API_KEY`. Leave `LANGFUSE_*` empty for now.
3. **First-boot Langfuse.** Open `http://localhost:3000`, create the project, copy the generated public/secret keys into `~/.claude/secrets.env` as `LANGFUSE_PUBLIC_KEY`/`LANGFUSE_SECRET_KEY`. Verify tracing works by running `claude --print "echo hello"` and checking that a trace appears in the Langfuse UI within 30 seconds.
4. **Paste the user-scope files.** Sections 3.1–3.5. Set `chmod +x` on every shell script under `~/.claude/hooks/` and `~/.claude/bin/`. Symlink `~/.claude/AGENTS.md → CLAUDE.md`.
5. **Install Superpowers.** Open Claude Code, run `/plugin install superpowers@claude-plugins-official`. Verify with `/plugin list`. First session after install will inject the `using-superpowers` skill automatically via its SessionStart hook.
6. **Enable Code Review for Claude Code.** Navigate to `claude.ai/admin-settings/claude-code`. Scroll to the Code Review section. Click Setup. Install the Claude GitHub App to your org with Contents, Issues, and Pull requests read/write permissions. For each repo, set Review Behavior to `Once after PR creation`. Set a monthly spend cap at `claude.ai/admin-settings/usage` under the `Claude Code Review` service — $100–200/month is a reasonable starting budget.
7. **Install `claude-devtools`.** Desktop-only. Linux: AppImage from the releases page. macOS: `brew install --cask claude-devtools`. No config — it reads `~/.claude/` directly.
8. **Verify the hook enforcement works.** Open Claude Code and try to run `rm -rf ~/` through it. The `pre-tool-use-bash.sh` hook should block with `🚨 [rm-home] rm -rf targeting home directory`. If it doesn't block, check `~/.claude/logs/pre-tool-use-bash.log` and fix before proceeding.

That is the 45-minute install. If it takes longer than that the first time, the usual culprit is Langfuse's first-boot ClickHouse migrations — they can take 5–10 minutes. Wait them out.

### 4.2 Day 1: initializing a project

```bash
cd ~/code/my-project
git init

# 1. Copy the project-scope templates from the blueprint.
#    (In practice these live in a dotfiles repo you clone.)
cp -r ~/blueprint/project-scope/.claude ./.claude
cp ~/blueprint/project-scope/.mcp.json ./.mcp.json
cp ~/blueprint/project-scope/REVIEW.md ./REVIEW.md
cp -r ~/blueprint/project-scope/.github ./.github

# 2. Customize .claude/CLAUDE.md for the project (stack, commands, invariants).
$EDITOR .claude/CLAUDE.md
# Customize REVIEW.md for the team's review rules.
$EDITOR REVIEW.md

# 3. Symlink AGENTS.md for cross-tool portability.
ln -sf CLAUDE.md AGENTS.md

# 4. Initialize spec-kit.
specify-cli init

# 5. Create the gitignore for Claude Code runtime files.
cat >> .gitignore <<'EOF'
# Claude Code runtime state
.claude/settings.local.json
.claude/.session-started-*
EOF

# 6. First commit.
git add .claude .mcp.json REVIEW.md AGENTS.md .github .gitignore
git commit -m "Initialize Claude Code blueprint"

# 7. Open Claude Code in the project.
claude
```

On first launch inside the project, verify:
- The status line shows `[sonnet] my-project/main ctx 2%` (or whatever model you're on), in green.
- The `session-start.sh` hook injects your `STATE.md`/`DECISIONS.md` context (both are empty on day 1, that's fine).
- `/plugin list` shows `superpowers` installed and active.
- `/mcp list` shows all nine servers from `.mcp.json` connected.

### 4.3 The everyday loop — idea to merge

This is the loop that runs in your head and on your machine for every non-trivial feature. Seven phases, three context resets, two human gates (section 2.3). Here it is in execution steps:

```
# Phase 1: Discover — fresh context
claude
> /speckit.constitution    (first time only per project)
> /speckit.specify "Build a thing that ..."
# Superpowers' brainstorming skill runs. Socratic Q&A. Outputs:
#   specs/001-thing/spec.md
> /exit    (context reset 1)

# HUMAN GATE 1: read specs/001-thing/spec.md, annotate, decide to proceed.
$EDITOR specs/001-thing/spec.md
git add specs/001-thing/spec.md
git commit -m "spec(001-thing): initial"

# Phase 2: Plan — fresh context
claude
> /speckit.plan
# Superpowers' writing-plans skill runs. Outputs:
#   specs/001-thing/plan.md
#   specs/001-thing/tasks.md
> /exit    (context reset 2)

# HUMAN GATE 2: read plan.md, annotate inline 1-6 passes, decide to proceed.
# This is the Boris Tane pattern — markdown annotations are the contract
# between you and the agent. Do NOT skip this step for anything non-trivial.
$EDITOR specs/001-thing/plan.md
git add specs/001-thing/plan.md specs/001-thing/tasks.md
git commit -m "plan(001-thing): reviewed and approved"

# Phase 3: Execute — fresh context, subagent-driven execution
claude --worktree
> /speckit.implement
# Superpowers' subagent-driven-development skill runs.
# Each task gets a fresh container (via container-use MCP) and a dedicated
# git branch. Spec-reviewer and code-quality-reviewer subagents loop until ✅.
# PostToolUse hooks run lint + tests after every Edit/Write.
> /exit

# Phase 4: Integrate — still inside the worktree
# Superpowers' finishing-a-development-branch skill handles this:
claude
> Run the code-reviewer subagent against the full diff, then open a PR.
# Generates PR body from plan.md + task list. Opens the PR via gh CLI.
> /exit

# Phase 5: Review — automatic, no action needed
# Managed Code Review posts inline comments + overview + bughunter-severity
# JSON to the PR. claude-pr-review.yml from section 3.10 runs in parallel
# as a self-hosted review pass (for belt-and-suspenders on large PRs).
# Wait ~20 minutes for Code Review to complete.

# MERGE GATE: code-review-gate.yml job (section 3.11) parses the severity
# JSON. If .normal > 0, merge is blocked until findings are resolved.

# Phase 6: Deploy — on merge, Vercel / Cloudflare / your deploy automation
# Preview URL posted on PR from Phase 5.

# Phase 7: Monitor — passive
# Native OTel spans flow to Langfuse.
# session-end.sh hook appends to DECISIONS.md on every session close.
# ccusage daily cron run (see below) reports spend.
```

The two human gates are non-optional. Skipping HUMAN GATE 1 turns you into a spec-driven waterfall shop (Rick's Café AI's critique). Skipping HUMAN GATE 2 reintroduces failure mode 2 (silent drift from goal) — the agent plans and implements in one breath with no inspection point. The Boris Tane workflow gets 976 HN points for exactly this reason: the gates are the value.

### 4.4 The monitoring loop

**Daily (or whenever you start a session):**
- `ccusage daily` — one-line spend report for yesterday.
- Glance at `claude-devtools` for per-turn token attribution on any session that felt slow.
- Skim the top of `DECISIONS.md` for the last session's decisions.

**Weekly:**
- `ccusage monthly` — month-to-date spend vs. budget.
- Open Langfuse at `http://localhost:3000` and look for cost-per-session outliers (the arxiv eval-awareness post says cost anomalies are the signal of strategy drift).
- Review `~/.claude/logs/pre-tool-use-bash.log` and `pre-tool-use-secrets.log` — any blocks are signals of a pattern the agent tried that the hook caught. If the same pattern recurs, add it to `CLAUDE.md` (principle 11: self-improvement loop).
- Read the last week of `DECISIONS.md` entries. If a pattern emerges (same mistake, same workaround), promote it to `CLAUDE.md` or `.claude/CLAUDE.md`.

**On every model upgrade (principle 7):**
- Revisit every hook in `~/.claude/hooks/`. Does it still earn its slot? If the new model no longer makes the mistake the hook catches, delete the hook.
- Revisit every line of `CLAUDE.md`. Same question.
- Re-run a ReAct baseline on a representative task and compare token budget + outcome to your current harness. This is the METR-anchored principle 8. If the new model closes the ReAct gap, simplify the harness.

**On any session that hits the canary thresholds from issue #42796:**
- Read:Edit ratio below 3.0 on a sustained basis
- Stop-hook violations above 20 per day
- Edit-without-read rate above 20% of edits
- Cost per task 5× expected
  Stop and investigate. One or more of: adaptive thinking re-enabled itself, effort level dropped, or a regression slipped through a CC update. Revert to known-good settings and file a GitHub issue with the telemetry.

---

## 5. The Traps

Every architecture has failure modes it cannot eliminate, only manage. This section names them so you know what to watch for.

### 5.1 What this setup makes structurally impossible (restated)

Repeating the list from section 1.5 because it's the test:

- Destructive shell commands (`rm -rf /`, force-push to protected branch, `terraform destroy --auto-approve`, fork bombs, dd to block devices, `chmod -R 000`) — blocked by `pre-tool-use-bash.sh`.
- Reading or writing `.env`, SSH keys, cloud credentials, GPG keyrings, service secrets — blocked by `permissions.deny` + `pre-tool-use-secrets.sh`, with `.env.example`/`.sample`/`.template` allowlisted.
- Secret exfiltration via `cat .env`, `printenv`, `echo $SECRET`, `base64 .env` — blocked by the Bash guard (because `Read(./.env)` deny does NOT cover Bash `cat`, as Anthropic's docs explicitly note).
- Merging a PR with unresolved 🔴 Important findings — blocked by `code-review-gate.yml` via `bughunter-severity` parse.
- Running Claude Code in CI on a subscription plan (Anthropic terms violation) — the bootstrap keeps API key and OAuth credentials in separate paths.
- Agent actions touching the host filesystem outside the project — `container-use` runs every action in a fresh container.
- Skipping TDD — Superpowers' `test-driven-development` skill refuses to write implementation without a failing test, and the PostToolUse hook runs the test suite after every Edit/Write.

### 5.2 What this setup cannot prevent, and why

No architecture is complete. These are the failure modes the blueprint does not close:

**1. Well-formed bad code.** Claude can write code that passes types, lints, tests, and reviewer scrutiny while still being architecturally wrong or strategically misguided. The only defense is the human review gates in phases 1 and 2. If you skip them, the blueprint cannot save you.

**2. Prompt injection via untrusted input.** An MCP tool that fetches a web page can feed adversarial content into the context. Claude may then follow embedded instructions. Partial defenses: `sentry-mcp` is read-only; `exa` returns text, not tool-call instructions; `playwright` operates in a headless browser sandboxed by `container-use`. Full defense requires input sanitization at the MCP server level, which is the MCP ecosystem's unsolved problem. Huntley's cogsec essay argues no configuration-layer defense is sufficient — only sandbox isolation is. This blueprint treats `container-use` as the last line.

**3. Dependency supply-chain attacks.** The axios DPRK incident was a 3-hour window. The next one could be 30 minutes. Mitigation: the native binary installer (not npm global), pinned Lock files, `npm audit`/`pnpm audit`/`cargo audit` in CI, `gh` CLI's own supply-chain guarantees. This reduces the attack surface but does not eliminate it.

**4. Model-level drift.** Opus 4.6 fabricated SHAs for two months with zero chain-of-thought emitted before the community noticed. GitHub issue #42796 is the empirical record. The environment variables (`CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1`, `effortLevel: high`, `showThinkingSummaries: true`) mitigate the specific February 2026 regression but cannot prevent future ones. The canary metrics in section 4.4 are your early warning.

**5. The Ronacher trap — building tools you never use.** "Agent Psychosis" is a real failure mode: configure-more is a dopamine loop, and most hours spent tweaking the harness are hours not spent shipping software. This blueprint is at risk of being exactly the trap it warns against. Defense: if you do not use a file, a hook, or an MCP server for four weeks, delete it. Principle 10 is not optional.

**6. Lock-in risk from client attestation.** The alex000kim leak analysis found that Claude Code uses `cch=00000` placeholder client attestation overwritten by Bun's Zig HTTP stack with a crypto hash before transmission. This means third-party clients (claw-code, claurst) cannot transparently hit Anthropic's API — the HTTP transport layer rejects non-attested clients. If Anthropic decides to disable a subset of clients via this mechanism, there is no drop-in replacement. The blueprint treats alternative CLIs as complements, not fallbacks, and keeps AGENTS.md cross-tool portability to Codex CLI / Gemini CLI / Cursor (which use their own providers, not Anthropic's).

**7. Context rot despite the mitigations.** Boris Tane reports not seeing it; gsd-build names it as the central enemy; Anthropic's harness-design post names it "context anxiety." All three can be right: if you religiously use context resets between phases and write durable markdown (`plan.md`, `DECISIONS.md`, `STATE.md`), you live in Boris Tane's world. If you run long unbroken sessions, you live in gsd-build's world. The blueprint defaults to the first regime but cannot enforce it — that's on you.

### 5.3 Three ways this setup will fail you

**It will look like too much work on day 3.** You will be tempted to turn off hooks ("they're slowing me down"), skip the human gates ("this spec is obvious, just implement"), and drop the PostToolUse verify ("I'll run tests later"). These are the exact moves that convert the blueprint back into a plain Claude Code install. Don't. The moment you turn off the hooks is the moment you stop getting the value you installed them for.

**It will be outdated in three months.** Claude Code ships one to three releases per week. Half of what's in this blueprint will be obsolete, deprecated, or replaced by the time you read this. The principles will survive longer than the files. When you hit something that looks wrong, check Anthropic's docs (`code.claude.com/docs/en/*`) before defending the blueprint's version.

**It will not replace your judgment.** Every structural guarantee above is a guarantee about what the *system* won't do. It cannot make you ask the right questions, write the right spec, annotate the right parts of `plan.md`, or notice when Claude is confidently wrong. The blueprint is a scaffold; the judgment is yours. If you hand both over to the agent, this setup becomes theater.

### 5.4 When to deviate

- **If you are not a solo developer.** Enterprise compliance changes everything — ZDR excludes Code Review for Claude Code entirely, Bedrock/Vertex change the telemetry path, audit requirements demand managed marketplaces. The research report has enterprise-profile recommendations.
- **If your project is genuinely parallelism-bound.** If you've confirmed you need 5+ concurrent agents and the overhead of `container-use` worktrees is limiting you, install Vibe-Kanban (`npx vibe-kanban`) as the board UI. Do not install it preemptively — the METR supervision ceiling is 3–4.
- **If you run heavy browser automation.** The blueprint's `playwright` MCP server is adequate for on-demand use. If you're running production browser agents at scale, Browserbase + Stagehand v3 is the upgrade path.
- **If you're doing ML/Python-heavy work.** The blueprint's sandbox is `container-use` plus optional Fly.io Sprites. Modal Sandboxes (gVisor, sub-second cold starts, 20k concurrent containers) is a better fit for Python-heavy or GPU-heavy workloads.
- **If you're running untrusted multi-user agent work.** The blueprint assumes a single human operator. If you're offering Claude Code sessions to users (a SaaS), use Cloudflare Sandbox SDK (first-party template with Claude Code preinstalled) or Claude Managed Agents ($0.08/session-hour hosted).

---

## 6. Appendices

### Appendix A — Commands cheat sheet

```
# Claude Code core
claude                        # open in current dir
claude --worktree             # open with a fresh git worktree
claude --model opus           # override default model for this session
claude --print "prompt"       # one-shot non-interactive (NOT for CI)

# Spec-kit
specify-cli init              # initialize spec-kit in a project
/speckit.constitution         # set project principles (once)
/speckit.specify "..."        # create a feature spec
/speckit.plan                 # generate plan.md + tasks.md
/speckit.tasks                # refresh task list
/speckit.implement            # run implementation phase

# Superpowers (after /plugin install)
# Skills are auto-invoked by prompt — no explicit commands needed.
# The SessionStart hook re-injects the root skill on every /clear.

# container-use
cu list                       # list environments
cu watch                      # live stream of every agent command
cu log <id> --patch           # history for a specific env
cu checkout <id>              # check out the env's branch locally
cu merge <id> --delete        # merge + delete
cu terminal <id>              # interactive shell into the env

# Cost & observability
ccusage daily                 # today's spend
ccusage monthly               # month-to-date
/context                      # per-session context usage (built-in)
# Langfuse UI: http://localhost:3000
# claude-devtools (desktop): reads ~/.claude/ directly

# Code Review (after enabling)
@claude review                # manual review trigger (subscribes to pushes)
@claude review once           # single review, no subscription

# CI / GH
gh api "repos/$OWNER/$REPO/check-runs/$ID" \
  --jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson'
```

### Appendix B — Sources by section

Every substantive claim in this blueprint is traceable to a primary source via one of the nine targeted research lanes. The full research report is at `research_report_20260411_claude_code_production_setup.md` in this directory. The specific delta-research lanes that shaped each blueprint section:

- **Section 1 (mental model):** Anthropic "Scaling Managed Agents" engineering post, Latent Space "Extreme Harness Engineering" (Ryan Lopopolo), Latent Space Felix Rieseberg episode, Anthropic "Building a C compiler" post, Anthropic "Eval awareness in BrowseComp" post, Boris Tane "How I use Claude Code" (976 HN points), Addy Osmani's Q1 2026 essay series.
- **Section 2 (architecture):** All of the above plus the reverse-engineered Claude Code structure from the March 31 source leak, `poshan0126/dotclaude`, `citypaul/.dotfiles`, `fcakyon/claude-codex-settings`, `nicknisi/dotfiles`.
- **Section 3.1 (settings.json):** `code.claude.com/docs/en/settings` (every key documented in the official schema table).
- **Section 3.2 (CLAUDE.md):** Anthropic memory docs (<200 line target), Boris Cherny's published workflow (~100 lines), HumanLayer's house rule (<60), obra/superpowers TDD SKILL.md (Iron Law), Karpathy guidelines, Matt Pocock skills, Addy Osmani essays.
- **Section 3.4 (hooks):** `karanb192/claude-code-hooks` (340⭐), `disler/claude-code-hooks-mastery` (3,507⭐), `doobidoo/mcp-memory-service` (1,642⭐), `diet103/claude-code-infrastructure-showcase`, `bartolli/claude-code-typescript-hooks` (174⭐), plus the verified JSON stdin/stdout protocol from `code.claude.com/docs/en/hooks`.
- **Section 3.9 (.mcp.json):** `code.claude.com/docs/en/mcp`, `oraios/serena`, `upstash/context7`, `@playwright/mcp`, DeepWiki MCP docs, `github/github-mcp-server`, `getsentry/sentry-mcp`, `exa.ai/mcp`, `dagger/container-use`, `doobidoo/mcp-memory-service`.
- **Section 3.10 (GH Actions recipes):** `systemprompt.io`'s March 10, 2026 guide, verbatim.
- **Section 3.11 (merge gate):** `code.claude.com/docs/en/code-review`, verbatim `gh api | jq` incantation.
- **Section 3.12 (Langfuse):** `langfuse.com/self-hosting/docker-compose`, `langfuse.com/docs/opentelemetry/get-started`, verified canonical docker-compose.yml from the `main` branch.
- **Section 4 (workflow):** Boris Tane's essay, Superpowers' subagent-driven-development skill, Addy Osmani's Code Agent Orchestra essay.
- **Section 5 (traps):** arxiv 2604.04978 (permission gate 81% false-negative), GitHub issue #42796 (Feb-Mar regression telemetry), Huntley's cogsec essay, Ronacher's "Agent Psychosis" essay, Rick's Café AI's "Waterfall in Markdown" critique, alex000kim's source-leak analysis.

### Appendix C — The twenty architecture-updating ideas that shaped this blueprint

In rough order of how much they changed the design:

1. **METR Feb 13:** Claude Code vs. ReAct is 50.7% of bootstrap samples — indistinguishable. Value is in ecosystem, not harness.
2. **METR Feb 17:** Parallel agent concurrency (2.3 agents → 11.6× productivity; 1 agent → 2–6×) is the dominant productivity variable.
3. **Anthropic harness-design Mar 24:** "Context anxiety" is a named failure mode; compaction doesn't fix it, only hard resets do.
4. **GitHub issue #42796:** 234,760-tool-call dataset proving "less thinking → 80× more total cost" via thrashing.
5. **arxiv 2604.04978 + Anthropic Auto Mode post:** 81% / 17% false-negative rate on the permission gate. Disqualifies unconditional Auto Mode.
6. **Anthropic "Scaling Managed Agents":** session/harness/sandbox as the three virtualized primitives. `execute(name, input) → string` as the brain/hands contract.
7. **Boris Tane:** markdown as state outside the conversation; doesn't see context degradation because `plan.md` holds understanding.
8. **obra/superpowers' Iron Law:** "No production code without a failing test first. Watch it fail." Discipline is prompt-level, not hook-level — this is why the blueprint layers hooks on top.
9. **alex000kim source-leak analysis:** client attestation below JavaScript means third-party CLIs are not drop-in replacements. Lock-in vector.
10. **C-compiler post:** dumb coordinator + specialized agents + strong verifier beats smart orchestrator. 16 agents, file-locked tasks, no orchestration agent.
11. **Armin Ronacher "Agent Psychosis":** asymmetric labor (generate minutes, review hours); slop-loop warning; dopamine of configuration.
12. **Anthropic "Eval awareness in BrowseComp":** Opus 4.6 burned 40M tokens decrypting an answer key. Cost anomalies are the signal of strategy drift.
13. **mksg.lu context-mode:** 98% context savings come from compressing tool *output*, not input. MCP output channel is the leverage point.
14. **Rick's Café AI "Waterfall in Markdown":** Scott Logic test found SDD is 10× slower with the same bugs. Spec-kit is a gate, not documentation.
15. **Drew Breunig SDD triangle:** spec ↔ tests ↔ code drift independently; implementation is discovery.
16. **gsd-build "context rot"** + parallel waves with fresh context windows.
17. **Addy Osmani Factory Model / Parallel Agent Limit:** 3–4 agent supervision ceiling unless post-merge review absorbs load.
18. **Anthropic Code Review docs verbatim `gh api | jq` severity parse:** converts always-neutral check run into merge-blocking gate.
19. **HumanLayer "<60 lines is best":** CLAUDE.md length target with empirical backing (models follow ~150–200 instructions reliably).
20. **Freek Van der Herten's status line:** color-coded context utilization gate. Small, sharp, absent from most setups.

---

*Blueprint version 2.0 — April 11, 2026. Total files: ~30. Total lines of shell: ~600. Expected install time on a clean machine: 45 minutes. Expected survival time before the next model upgrade forces a revisit: 3 months. Expected failure mode when neglected: reversion to vanilla Claude Code. Expected success mode when used: software that ships, sandboxed agents, observable costs, verifiable correctness, and destructive mistakes that are impossible rather than merely unlikely.*

*When this blueprint stops earning its keep, delete it. That's principle 7 and it applies to itself.*
