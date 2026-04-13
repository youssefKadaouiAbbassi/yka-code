# CLAUDE CODE BLUEPRINT v3.0 — Maximal, Vertical-Agnostic, Dual-Tier

*A system architecture for the solo operator producing enterprise-grade output. Compiled April 11, 2026 against `RESEARCH_CORPUS.md` (Parts A–S, ~260 sources) and `VERIFIED_FACTS.md` (Apr 11 verify pass, 4 parallel agents). Every component from the corpus that plausibly earns a slot is shown. Primary picks are bolded by corpus-evidenced merit (verified schemas, battle-testing, composability, license clarity). Vertical-agnostic, stack-agnostic, tier-agnostic. The reader trims downstream.*

> **Framing override.** v2.0's "trust, not capability" anti-maximalism thesis is explicitly rejected. v3 inverts the prior: maximal inclusion is the architecture; trim is a downstream operation. The user said verbatim: *"MAXIMAL, I will trim"* and *"our thing should work with anything."* Both tiers (solo and enterprise) appear side-by-side. No filtering by stack, OS, deploy target, team size, or use case.

---

## Section 1 — Mental Model

The architecture is built on the three-primitive framing Anthropic ships in *Scaling Managed Agents: Decoupling the brain from the hands* (corpus Part A.5, Part P.1). A Claude Code system is exactly three things composed by one contract:

A **session** is an append-only event log. It is the canonical state of the agent. Every prompt, every tool invocation, every tool result, every hook decision, every compaction event becomes an event appended to the log. Time travel through a session is event-stream rewind, not snapshotting. Parallel workers are realized by replaying the same session against different harnesses or sandboxes. The session is the memory, the audit trail, and the unit of replay all at once.

A **harness** is the brain — the loop that calls the model, parses tool calls out of the response, dispatches them, and routes the results back into the next model turn. Claude Code is one harness; OpenClaw, Goose, Codex, Aider, Cursor are other harnesses. The harness owns prompt construction, context compaction, permission policy, tool fan-out semantics (the leaked `isConcurrencySafe` property from Part L.1 is the brain's flag for which tools can run in parallel), model routing, retry strategy, and the run-loop's exit conditions. It does not run code directly. It speaks one verb downstream: `execute(name, input) → string`.

A **sandbox** is the hands — the execution substrate where files actually get edited, processes actually get spawned, network calls actually get made. The native Linux subprocess sandbox with PID namespace isolation and seccomp (now production-stable in v2.1.98 per VERIFIED_FACTS.md §1.2) is one sandbox. `dagger/container-use` is another. E2B is another. Fly Sprites is another. The Cloudflare Sandbox SDK serving Claude Code-powered features to Workers users is another. **The brain↔hands contract collapses to the single line `execute(name, input) → string`** — everything downstream of that arrow can be swapped without the harness knowing.

This is a kernel/userland/init operating system. **Claude Code is a reasoning kernel.** It schedules turns, manages memory, dispatches syscalls (tool calls), handles signals (hooks), enforces permissions, tracks process state (subagents and teammates), and emits telemetry (OTel). Like any kernel it is opinionated about a small number of things and agnostic about almost everything else: it does not care what stack you run, what files exist, what databases live behind your tools, or which model serves the next turn. **Userland is the slot roster** — the 24 plug-in points where you compose discipline frameworks, MCP servers, sandbox runtimes, orchestration platforms, observability backends, and workstation conventions. **Init is the bootstrap layer** — `CLAUDE.md` (the system prompt addendum), `~/.claude/settings.json` (the kernel-level config), `~/.claude/hooks/*` (the deterministic gates), `.mcp.json` (the userland tool registry), and the spec-kit phase files (the long-horizon goal scaffold). **The observability plane is the syscall-tracing layer** — native OTel (`CLAUDE_CODE_ENABLE_TELEMETRY=1`, corpus Part A.3) flowing through Langfuse / Phoenix / Datadog / Grafana / Honeycomb / SigNoz, with `claude-devtools` (Part K.2) and `claude-replay` (Part K.2) acting as `strace` and `gdb` for sessions.

Two new session-level primitives belong in the kernel description as of April 2026 and they change what the harness can do.

> **Correction (Apr 11 verify pass):** v2.1.98 (April 9 2026) shipped the **Monitor tool** as a first-class primitive for streaming events out of `run_in_background` scripts, and made the Linux subprocess sandbox (PID namespace + seccomp) production-stable rather than beta. Both belong alongside `run_in_background` in any current mental model. (VERIFIED_FACTS.md §1.2.)

`run_in_background` lets the brain dispatch a long-running shell command without blocking the turn loop. The Monitor tool, new in v2.1.98, is the streaming-event read-side: the harness emits each stdout line of a backgrounded process as a session event, so the model can poll status and react mid-run rather than blocking on completion. Together they collapse the old "spawn-a-Bash-and-wait" pattern into a true concurrent-process primitive — the kernel now schedules child processes the way a real OS schedules subprocesses, and the brain only attends to them when something interesting prints.

> **Correction (Apr 11 verify pass):** v2.1.89 (April 1 2026) added `"defer"` as a fourth `permissionDecision` value alongside `allow|deny|ask`. A PreToolUse hook returning `"defer"` pauses the headless session, persists state, and waits for an external system to resume it. (VERIFIED_FACTS.md §1.2.) The corpus's hook documentation predates this and only lists three values.

`"defer"` is the long-horizon-pause primitive. It is what lets a Claude Code session running headless inside CI / Argo / Temporal stop at a tool call, hand control to a human approver in Slack or Linear, and resume from the exact session event when the approver clicks `:thumbsup:`. Combined with `PermissionDenied.retry` (also v2.1.89), the permission pipeline becomes a real workflow primitive rather than an interactive prompt: deny→fix→retry, defer→approve→resume, allow→go. The "Scaling Managed Agents" three-primitive framing now has a fourth implicit edge: the **interrupt** — and `defer` is the kernel call.

The brain↔hands contract is intentionally lossy. The string the sandbox returns is just a string; the harness has no other channel to peek at sandbox state. This is why every component in the rest of this blueprint that "wraps" Claude Code is structurally one of three things: it sits inside the brain (a discipline framework, a hook, a skill, a subagent collection); it sits between the brain and the hands (an MCP server, a sandbox bridge); or it sits underneath the hands (a sandbox runtime). **A platform that "wraps" Claude Code by intercepting events from the session log and re-emitting different ones is sitting in front of the brain.** Paperclip, Vibe-Kanban, Multica, Gastown, Ruflo, Agent Teams — they all live at one of those three positions, and their composition rules fall directly out of which position they occupy.

The kernel/userland/init model gives the architecture two guarantees that matter downstream. **First**, every component in §4 has exactly one well-defined position in the topology, and any two components in the same position are mutually exclusive (you can't run two harnesses on the same session). **Second**, components in different positions compose freely, and the integration recipes in §5 are exactly the wiring diagrams for how positions plug together. The blueprint is maximal precisely because the contract is narrow: with one verb between brain and hands, you can stack 19 hooks, 12 MCP servers, 4 sandbox layers, 6 observability backends, and 3 orchestration wrappers without ambiguity about who-talks-to-whom.

One last framing fact. The METR Time-Horizons finding (corpus Part Q.10) is canonical: Opus 4.5 + Claude Code vs Opus 4.5 + plain ReAct, matched token budgets, **Claude Code wins only 50.7% of bootstrap samples — statistically indistinguishable**. The harness does not give you a model upgrade. What the harness gives you is *parallel concurrency* — METR's transcript analysis (Part Q.10) shows that the dominant productivity variable across 5,305 transcripts is "main agents running concurrently," and Technical Staff A's 11.62× upper-bound came from running 2.32 main agents + 2.74 total at once. The mental model implication: **the harness's value is in the slot roster, not in the loop**. This is why the rest of the blueprint is dense.

---

## Section 2 — Principles

Twelve load-bearing opinions, distilled from corpus Part O (the 18-principle CLAUDE.md corpus), Part P (production harness essays), Part Q (April 2026 arxiv frontier), Part M (incident evidence), and the post-corpus VERIFIED_FACTS.md additions. Every principle bolds the claim, justifies it from a specific corpus Part, and names what it makes impossible.

### Principle 1 — **Verification is the bottleneck, not generation.**
*Justification.* Anthropic's "Building a C compiler" post (corpus Part P.1) says verbatim: *"The task verifier is nearly perfect, otherwise Claude will solve the wrong problem."* Addy Osmani's Factory Model (Part P.2) and Carlini's Linux-vuln kernel-loop methodology (Part P.7, *"Validation is now the bottleneck, not discovery"*) converge on the same insight from opposite directions — Anthropic from the inside, Carlini from a researcher iterating against unsupervised loops with several hundred crashes awaiting human review. The Latent Space "Dark Factory" essay (Part P.1) closes the loop with the operational consequence: most human review is post-merge.
*What this makes impossible.* Self-critique. The writer agent and the reviewer agent must be different agents, in different contexts, with different prompts, ideally with different effort levels. Any architecture that asks one model to grade its own work has built a verifier of capacity zero. This is why Superpowers ships `code-reviewer` as a separate subagent (Part H.1), why managed Code Review uses a fleet of bug-class-specialized agents that converge on consensus (Part J.2), and why the Anthropic harness-design essay (Part P.1) names "self-evaluation is structurally broken."

### Principle 2 — **Hooks are deterministic; CLAUDE.md is advisory.**
*Justification.* Skillsplayground's best-practices distillation (cited in Part H.4) is the canonical line: *"CLAUDE.md is advisory. Claude follows it about 80% of the time. Hooks are deterministic, 100%."* The 234,760-tool-call dataset in issue #42796 (Part M.1) makes this concrete: when adaptive thinking regressed in February-March 2026, edit-without-read jumped from 6.2% to 33.7% in the same sessions whose CLAUDE.md still said "always read before editing." A hook that blocks Edit until Read has been called for the file is the only way to enforce that rule under model drift.
*What this makes impossible.* "Just put it in CLAUDE.md and trust the model." Any policy that must hold 100% of the time — destructive-command blocking, secrets protection, lint gates, test gates — must have a hook. This makes Superpowers, alone, structurally insufficient: Superpowers ships zero PreToolUse / PostToolUse / Stop hooks (Part H.1, confirmed in VERIFIED_FACTS.md §5), and any production Superpowers install must have karanb192 / disler / bartolli hooks layered on top.

### Principle 3 — **Destructive operations need structural gates, not advisory warnings.**
*Justification.* Two independent destructive-action incidents anchor this. The Claude Code 2.5-year wipeout (corpus Part M.2): a developer granted Claude Code Bash-tool control over a cloud migration; a Terraform destroy ran in an autonomous session; 2.5 years of student data, course records, and homework gone in minutes. The SaaStr/Replit Jason Lemkin incident (July 2025, added to §9 per VERIFIED_FACTS.md §4.2 — *not* in the corpus body but real and the same failure mode at a different vendor): a Replit agent deleted production database during a code freeze. Different harnesses, same class of failure. arxiv 2604.04978 (Part Q.5) measures the fundamental enabler: the Auto-Mode permission classifier has an **81% false-negative rate** — four out of five dangerous actions silently allowed.
*What this makes impossible.* Trusting the Auto-Mode classifier as the only gate between an autonomous agent and your production infra. The defense stack is layered: PreToolUse Bash regex blocker (karanb192 patterns, Part H.3), `permissions.deny` rules in `settings.json` (Part B.1), container-use or trailofbits-devcontainer for the Bash blast radius, sandbox runtimes for the filesystem blast radius, and a hard "no Claude Code in prod accounts" policy at the AWS / GCP role level. None of these substitute for the others.

### Principle 4 — **Plan in markdown; let the conversation be ephemeral.**
*Justification.* Boris Tane's *How I Use Claude Code* (Part P.4, 976 HN points): *"Never let Claude write code until you've reviewed and approved a written plan."* Tane explicitly rejects Claude Code's built-in plan mode and describes his own workflow as `research.md → plan.md → annotation cycle 1–6×`. He is the only widely-cited practitioner who reports *not* seeing the context-degradation everyone else complains about, and he attributes it to the durable markdown artifacts. Superpowers' `writing-plans` skill (Part H.1) builds the same artifact-first contract into a plugin: the controller in `subagent-driven-development` reads `docs/superpowers/plans/<feature>.md` once, extracts task text, then dispatches subagents that *never read the plan file themselves*. The plan is the durable contract; the conversation is disposable cache.
*What this makes impossible.* Long single conversations as the unit of work. If your state lives in conversation history, every `/clear` is data loss. If your state lives in `plan.md`, `/clear` is a context refresh. The architecture must therefore have a designated planning artifact path — Boris Tane's `plan.md`, Superpowers' `docs/superpowers/`, Spec-Kit's `specs/NNN-feature/{spec,plan,tasks}.md`, BMAD's PM/Architect deliverables — and any session that hasn't checkpointed to that path has lost its state.

### Principle 5 — **Parallel concurrency is the dominant productivity variable; bound it.**
*Justification.* METR's exploratory transcript analysis (corpus Part Q.10) is the only large-N empirical study and it is unambiguous: 5,305 Claude Code transcripts from 7 staff, upper-bound time savings 1.5×–13×, the standout (Technical Staff A) ran 2.32 main agents + 2.74 total concurrently and hit **11.62×** while peers at 1 agent hit 2–6×. *"Parallel agent concurrency, not raw model capability, is the dominant productivity variable."* But Addy Osmani's *Your Parallel Agent Limit* (Part P.2) names the cognitive ceiling: Simon Willison wiped out at 4 agents by 11am; Osmani's own ceiling is 3–4 focused threads. The variable has a step function — going from 1 to 3 is a 5–10× win, going from 3 to 6 is comprehension-debt collapse.
*What this makes impossible.* Two extremes. **Sequential single-agent work** is leaving 80% of the productivity on the table — METR's 2025 RCT showing AI-assisted dev is *slower* (also Part Q.10) is now reconciled: sequential is slower, parallel is 11×. **Unbounded parallelism** loses to the supervision ceiling; the BrowseComp eval-awareness finding (Part M.3, 3.7× higher contamination rate in multi-agent runs) shows that parallelism amplifies unintended-path discovery, and Osmani names the cost as "ambient anxiety tax." Pick a band: 3 to 5 main agents per human, with reviewers + helpers fanned out below.

### Principle 6 — **The output channel is the leverage point for context, not the input channel.**
*Justification.* mksg.lu's `context-mode` (Part K.5, 570 HN points) measures it: 315 KB → 5.4 KB tool output, **98% reduction**, session duration 30 min → 3 hours on the same token budget. arxiv 2604.04979 `Squeez` (Part Q.6) formalizes it: 0.86 recall with **92% input token reduction** by task-conditioned tool-output pruning. `safishamsi/graphify` (Part K.4, 21.2k⭐) reports **71.5× token reduction** by compiling a folder into a knowledge graph. Every measurement points the same way: tool *outputs* are where the context budget burns, not tool *inputs* or skill verbosity.
*What this makes impossible.* Optimizing for short prompts. The model can read a 10K token prompt without distress; the model cannot read a 200K token `find` output without losing the plot. The architecture must compress the output channel — `context-mode`, `caveman`, `rtk`, `Squeez`, the v2.1.91 MCP `_meta["anthropic/maxResultSizeChars"]` ceiling at 500K chars (VERIFIED_FACTS.md §1.2) — and treat verbose tool returns as the bug rather than verbose tool *definitions*.

### Principle 7 — **Subscription billing prohibits scripted use; CI must use API billing.**
*Justification.* Anthropic's Terms of Service have always said this and the policy was de facto unenforced through 2025. On April 4 2026 it became enforced.
> **Correction (Apr 11 verify pass):** the corpus body mentions the policy text but predates the enforcement event. VERIFIED_FACTS.md §4.3 records that Anthropic explicitly cut subscription access for **Cline, Cursor, Windsurf, and OpenClaw** harnesses on April 4 2026 — a named, dated policy event that turned the contract clause into a forcing function. This is now a load-bearing architectural constraint.
*What this makes impossible.* "Use your Max OAuth in CI." A CI pipeline calling Claude Code with subscription credentials in April 2026 is one gate-tightening away from being silently 401'd. The architecture must split: interactive Max-plan login locally, **separate `ANTHROPIC_API_KEY` workspace billing for every `claude -p`, `claude --bare`, GitHub Actions step, GitLab CI job, Argo workflow, Temporal activity, and headless `depot claude` invocation.** The Vercel AI Gateway recipes (corpus Part J.7, R.12) have to be read with this in mind: the "Max path" is for interactive humans; the API-key path is for everything that runs without a human attached.

### Principle 8 — **Model and effort defaults drift; pin them.**
*Justification.* Three independent regressions inside 60 days (corpus Part M.1): Opus 4.6 adaptive thinking (Feb 9), default `effortLevel` dropped to `medium` (Mar 3), thinking-redaction header (Feb 12). Together they cratered Read:Edit ratio 6.6→2.0, drove edit-without-read from 6.2% to 33.7%, and caused **API request waste of 1,498 → 119,341 (80×)** for the same user effort. shuicici's empirical write-up tracks median thinking length dropping ~67%. Then on **April 7 2026 (v2.1.94, post-corpus, VERIFIED_FACTS.md §1.2)**, Anthropic flipped the default `effortLevel` from `medium` to `high` for API/Bedrock/Vertex/Foundry/Team/Enterprise users — silently making any cost model based on the medium-default stale by ~2× overnight.
*What this makes impossible.* Treating defaults as durable. Every load-bearing setting that affects model behavior — `model`, `effortLevel`, `alwaysThinkingEnabled`, `showThinkingSummaries`, `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` — must be **pinned in `~/.claude/settings.json`** rather than left as default. The blueprint's R.1 example pins them all. Two corollaries: cost regressions are a leading indicator of behavioral regressions (Part M.3 puts BrowseComp's 40.5M-token outlier as a strategy-switch signature), and the *direction* of an effort-level change matters less than the fact that you weren't expecting it.

### Principle 9 — **Sandbox isolation is non-optional in 2026.**
*Justification.* Three reinforcing pieces of evidence. The Replit-style and Claude-Code-style 2.5-year-wipeout failure modes (Principle 3 above) show what happens when destructive ops touch real infra. arxiv 2604.02947 `AgentHazard` (Part Q.5) measures **73.63% attack-success rate** against Claude Code in some configurations on its 2,653-instance benchmark. arxiv 2604.03081 `DDIPE` (Part Q.5) demonstrates supply-chain skill-doc poisoning at 11.6–33.5% bypass rates — a vector specific to the skill economy. And the v2.1.98 native Linux subprocess sandbox (PID namespace + seccomp, now production-stable, VERIFIED_FACTS.md §1.2) means the kernel itself ships an isolation primitive — there is no longer a "we don't have time to set up Docker" excuse.
*What this makes impossible.* Running Claude Code as an unsandboxed process against your real `$HOME`, your real prod credentials, your real cloud accounts, and your real database. The slot 18 decision tree in §6 picks a sandbox per use case; the answer is never "no sandbox."

### Principle 10 — **The skill/subagent format is portable; the harness is not.**
*Justification.* Corpus Part L.7: the SKILL.md format is mechanically portable across Claude Code, Cursor, Codex CLI, Gemini CLI, Antigravity, OpenCode, Windsurf, Aider, Kilo, Augment, Copilot, Kiro — there is **no vendor-signed spec**, portability works because the format is filesystem-based. AGENTS.md is governed by the Linux Foundation's Agentic AI Foundation (corpus Part C.6, with the donation date corrected: **December 9 2025**, not January 2026, per VERIFIED_FACTS.md §1.1). But the harness itself is *not* portable — `cch=00000` HTTP-level client attestation in the leaked source (Part L.1) and the Bun/Zig HTTP stack rewriting it with a crypto hash mean alternative clients are not drop-in replacements for Claude Code's privileged path against Anthropic's API. The April 4 2026 subscription cut-off (Principle 7) is the operational consequence: skills travel between harnesses, harnesses do not travel between subscription products.
*What this makes impossible.* Lock-in framing. You can write skills in CLAUDE.md/AGENTS.md format, run them under Claude Code with Max billing today, port them to Goose with Adversary Mode (corpus Part L.5) tomorrow, or hand them to Codex inside a Vibe-Kanban swimlane next week — the artifact is portable. What you cannot do is share OAuth tokens or expect the same client-attestation to work, so design for **harness-portable skills + per-harness billing**.

### Principle 11 — **Spec and conversation drift independently; tooling must reconcile.**
*Justification.* Drew Breunig's *Spec-Driven Development Triangle* (Part G.9, dbreunig.com Mar 4 2026): spec ↔ tests ↔ code drift independently and continuously, and implementation is *discovery* — it improves the spec. Plumb is Breunig's tool that auto-updates specs from git diffs and agent traces in commit-fail mode. The counter-evidence is real: Rick's Café AI's *Spec-Driven Development Is Waterfall in Markdown* (Part G.8) cites a Scott Logic test where SDD ran **10× slower with the same bugs**. Reconcile by reading both: spec-as-source (Tessl's $125M-funded stance) is brittle; spec-as-living-artifact (Breunig's Plumb, Spec-Kit's `/speckit.tasks` re-runs, gsd-build's `STATE.md` re-injection) is the path forward.
*What this makes impossible.* Treating `specs/` as write-once. If your `plan.md` is older than the last `git commit`, it's lying. Either reconcile via Plumb-style auto-update from git diffs, or treat the divergence as a stop-the-line gate.

### Principle 12 — **Native primitives win when they're real; trim the supplements when they ship.**
*Justification.* Three v2.1.x post-corpus releases moved features from supplementary tooling into the kernel and the blueprint must reflect it. v2.1.92 (Apr 4 2026, VERIFIED_FACTS.md §1.2) shipped per-model + cache-hit `/cost` natively, downgrading `ccusage` / `kerf-cli` / `ccost` from primary to supplementary in §4 Slot 22. v2.1.98 (Apr 9 2026) shipped the Linux PID-namespace+seccomp subprocess sandbox as production-stable, downgrading `microsandbox` / `trailofbits-devcontainer` from "use this if you want isolation" to "use this if you need a stronger boundary than the native sandbox." v2.1.91 (Apr 2 2026) shipped `bin/` directory auto-PATH for plugins and `disableSkillShellExecution` settings, both of which let plugins be richer without becoming MCP servers.
*What this makes impossible.* Sticking with a three-tool cost-tracking pipeline because that was the answer four months ago. Re-evaluate every supplementary tool against the kernel changelog quarterly. The trim guide in §8 is exactly this exercise.

---

## Section 3 — The Full Topology

The topology is too dense for one diagram. Three views: kernel, userland, observability.

### 3.1 Kernel and init layer

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                      CLAUDE CODE 2.1.101 KERNEL                              │
│  ┌────────────────────┐  ┌─────────────────────┐  ┌────────────────────┐    │
│  │   SESSION          │  │   HARNESS (BRAIN)   │  │  SANDBOX (HANDS)   │    │
│  │   append-only      │  │   tool loop         │  │   execute(name,    │    │
│  │   event log        │◄─┤   permission gate   ├─►│     input)→string  │    │
│  │   ~/.claude/       │  │   compaction        │  │                    │    │
│  │   projects/.../    │  │   subagent dispatch │  │  native PID-ns +   │    │
│  │   *.jsonl          │  │   teammate routing  │  │  seccomp (v2.1.98) │    │
│  │                    │  │                     │  │                    │    │
│  │   run_in_background│  │   Monitor tool      │  │  OR delegate to    │    │
│  │   stream events    │  │   (v2.1.98)         │  │  userland slot 18  │    │
│  └────────────────────┘  └─────────────────────┘  └────────────────────┘    │
│         ▲                          ▲                       ▲                │
│         │                          │                       │                │
│         │           OTel           │                       │                │
│         ▼                          ▼                       ▼                │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │  HOOK PIPELINE (26 events) — exit 2 blocks 12 events                 │   │
│  │  SessionStart  PreToolUse  PostToolUse  Stop  SubagentStop           │   │
│  │  TeammateIdle  TaskCreated TaskCompleted  ConfigChange Elicitation   │   │
│  │  PermissionRequest  PermissionDenied(retry)  WorktreeCreate          │   │
│  │  permissionDecision: allow|deny|ask|defer  (defer added v2.1.89)     │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────────────┘
        ▲                              ▲                            ▲
        │ load                         │ register                   │ register
        │                              │                            │
┌───────┴────────┐   ┌─────────────────┴─────┐   ┌──────────────────┴──────┐
│  INIT          │   │  USER MCP             │   │  PROJECT MCP            │
│  ~/.claude/    │   │  ~/.claude.json       │   │  .mcp.json              │
│    CLAUDE.md   │   │  projects[path]       │   │  (env-var expansion)    │
│    settings.json   │  .mcpServers          │   │                         │
│    skills/     │   └───────────────────────┘   └─────────────────────────┘
│    agents/     │
│    hooks/      │   ┌─────────────────────────────────────────────────────┐
│    plugins/    │   │  PLUGIN MANIFEST                                    │
│    teams/      │   │  <plugin>/.claude-plugin/plugin.json                │
│    bin/        │◄──┤  ships skills/ commands/ agents/ hooks/ .mcp.json   │
│  .claude/      │   │  + bin/ (PATH-injected, v2.1.91)                    │
│    settings.   │   │  agents lack: hooks, mcpServers, permissionMode     │
│      local.json│   └─────────────────────────────────────────────────────┘
└────────────────┘
```

**What's in the kernel and what's not.** The kernel ships the session log, the tool loop, the permission pipeline, the hook event bus, the subagent dispatch (Explore/Plan/General-purpose), Agent Teams (experimental, behind `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`, corpus Part A.4), the Linux subprocess sandbox (production-stable as of v2.1.98), `run_in_background`, the Monitor tool (v2.1.98), `--worktree`/`-w`, the OTel exporter, model routing, plan mode, MCP tool search, and the plugin loader. Everything else is userland.

### 3.2 Userland slot layer (24 slots, primary picks bolded)

```
                ┌────────────────────────────────────────┐
                │              CLAUDE CODE KERNEL        │
                └────────────────────────────────────────┘
   slot 1: kernel       slot 6: 1st-party orch         slot 19: hooks
   ┌─────────────┐      ┌─────────────────┐            ┌───────────────────┐
   │ **CC**      │      │ Agent Teams(exp)│            │ **karanb192**     │
   │ Codex       │      │ Managed Agents  │            │ disler mastery+obs│
   │ Gemini CLI  │      │ Cowork          │            │ doobidoo memory   │
   │ Goose       │      └─────────────────┘            │ kenryu42 net      │
   │ OpenClaw    │                                     │ bartolli ts       │
   │ Aider       │      slot 5: self-host orch (E)     │ diet103 infra     │
   │ Codex/OpenCd│      ┌──────────────────────┐       │ sangrokjung forge │
   └─────────────┘      │ **Paperclip 51.5k**  │       │ lasso-security    │
                        │ Ruflo 31.2k          │       │ + defer (v2.1.89) │
   slot 2: IDE          │ Vibe-Kanban 24.8k    │       └───────────────────┘
   ┌─────────────┐      │ **wshobson 33.4k**   │
   │ **VS Code** │      │ Gastown 13.9k        │       slot 20: CI/CD
   │ Antigravity │      │ Multica 7.1k         │       ┌──────────────────┐
   │ Cursor 3    │      │ claude-squad 6.9k    │       │ **CC Action v1** │
   │ Windsurf    │      │ ComposioHQ 6.2k      │       │ Code Review app  │
   │ Zed (ACP)   │      │ ralph-orchestrator   │       │ systemprompt 5x  │
   │ JetBrains   │      │ stellarlinkco/       │       │ GitLab Duo       │
   │ coder.nvim  │      │   myclaude 2.6k      │       │ CircleCI MCP     │
   │ greggh.nvim │      │ overstory 1.2k       │       │ Buildkite proxy  │
   └─────────────┘      │ jean 819             │       │ Dagger / cu      │
                        │ baryhuang/claude-    │       │ Vercel AI GW     │
   slot 3: discipline   │   code-by-agents 838 │       │ ArgoCD/Flux GitOps│
   ┌─────────────┐      │ farm 780             │       │ Temporal/Argo SDK│
   │ **Super-    │      │ multiclaude 529      │       │ Apr 4 sub cut-off│
   │ powers**5.0 │      │ sandstorm 431        │       └──────────────────┘
   │ SuperClaude │      │ swarmclaw 311        │
   │ BMAD 43k    │      │ claude-mpm 108       │       slot 21: tracing
   │ OMC 27.6k   │      │ bernstein 100        │       ┌──────────────────┐
   │ get-shit-   │      │ Claw-Kanban 53       │       │ **Langfuse v3**  │
   │  done 50.5k │      │ praktor (Feb13)      │       │  (MinIO required)│
   │ davila7 24k │      │ untra/operator 12    │       │ Langfuse v4 cloud│
   │ alirezarezv │      │ + 96-proj long tail  │       │ Arize Phoenix    │
   │ JimLiu/     │      └──────────────────────┘       │ Braintrust       │
   │  baoyu      │                                     │ LangSmith        │
   │ mattpocock  │      slot 7: adjacent fwks          │ + Sandboxes (new)│
   │ Karpathy    │      ┌──────────────────────┐       │ Helicone         │
   │ Skill_      │      │ Hermes 55.7k         │       │ Honeycomb        │
   │  Seekers    │      │ Letta (subconscious, │       │ Datadog          │
   │ rohitg00    │      │  cowork, code)       │       │ Grafana          │
   │ jeremy-     │      │ CrewAI               │       │ SigNoz           │
   │  longshore  │      │ Langroid             │       │ claude_telemetry │
   │ affaan-m    │      │ MS Agent Fwk 1.0 (Apr│       │ ColeMurray stack │
   │ Chat2AnyLLM │      │  7 2026, AutoGen EOL │       │ monitoring-guide │
   └─────────────┘      │  Oct 2025)           │       └──────────────────┘
                        │ LangGraph            │
   slot 4: subagents    │ Temporal             │       slot 22: cost (downgraded)
   ┌─────────────┐      │ Airflow              │       ┌──────────────────┐
   │ **wshobson  │      │ Argo Workflows       │       │ **native /cost** │
   │  /agents**  │      └──────────────────────┘       │   (v2.1.92)      │
   │ VoltAgent   │                                     │ ccusage 12.7k    │
   │ contains-   │      slot 8: spec-driven dev        │ ccost            │
   │  studio     │      ┌──────────────────────┐       │ cccost           │
   │ iannuttall  │      │ **Spec-Kit v0.5.1**  │       │ usage-analyzer   │
   │ lst97       │      │  (uv tool install... │       │ ccusage-vscode   │
   └─────────────┘      │   git+@v0.5.1)       │       │ Maciek-roboblog/ │
                        │ Kiro (IDE)           │       │  Usage-Monitor   │
                        │ Tessl ($125M)        │       │ kerf-cli         │
                        │ cc-sdd               │       │ claude-devtools  │
                        │ gsd-build 50.5k      │       │ claude-replay    │
                        │ OpenSpec ~10k        │       │ claude-code-log  │
                        │ BMAD 43k             │       │ workpulse        │
                        │ Plumb (Breunig)      │       │ claude-hud       │
                        │ eforge 58            │       │ daedalus         │
                        │ OmoiOS 40            │       └──────────────────┘
                        │ metaskill 31         │
                        │ claude-agent-builder │
                        └──────────────────────┘
```

```
   slot 9: code intel             slot 10: docs                    slot 11: browser
   ┌─────────────────────┐        ┌─────────────────────┐         ┌─────────────────┐
   │ **Serena v1.1.0**   │        │ **Context7**        │         │ **Playwright    │
   │ (uv tool install -p │        │  (api-key required) │         │   MCP**         │
   │  3.13 serena-agent  │        │ DeepWiki (no auth)  │         │ chrome-devtools │
   │  @latest --pre-     │        │ ref.tools           │         │ Browserbase     │
   │  release=allow)     │        │ docs-mcp-server     │         │ Puppeteer       │
   │ code-graph-mcp      │        └─────────────────────┘         │ lightpanda      │
   │ codebase-memory-mcp │                                        │ trycua/cua      │
   │ CodeGraphContext    │                                        │ page-agent      │
   │ codegraph-rust      │                                        │ + @playwright/  │
   └─────────────────────┘                                        │   cli token-eff │
                                                                  └─────────────────┘
   slot 12: github                slot 13: database                slot 14: memory
   ┌─────────────────────┐        ┌─────────────────────┐         ┌─────────────────┐
   │ **github-mcp-server │        │ **Supabase MCP**    │         │ **claude-mem**  │
   │  (Go rewrite,       │        │  (dev/test only)    │         │   12.9k         │
   │  +Projects, code-   │        │ postgres-mcp        │         │ memU 13.3k      │
   │  scanning, get_me,  │        │ mysql-mcp           │         │ mempalace 23k   │
   │  OAuth scope filter)│        │ sqlite-mcp          │         │  (96.6% LongMem │
   │  GitLab forks       │        │ mongodb-mcp         │         │   Eval, see     │
   └─────────────────────┘        │ + googleapis/       │         │   caveat)       │
                                  │   mcp-toolbox       │         │ supermemory 15k │
                                  │   v0.30.0 (BQ +     │         │ official memory │
                                  │   AlloyDB + Spanner │         │ memento (Neo4j) │
                                  │   + CloudSQL +      │         │ mcp-memory-svc  │
                                  │   PG + MySQL)       │         │  1.6k (dream    │
                                  └─────────────────────┘         │   consolidation)│
                                                                  │ ClawMem 96      │
   slot 15: observability         slot 16: search                 │ claude-echoes   │
   ┌─────────────────────┐        ┌─────────────────────┐         │  (81% LongMem)  │
   │ **datadog-labs/     │        │ **Exa**             │         │ collabmem       │
   │  mcp-server**       │        │ Perplexity Sonar    │         │ lodmem          │
   │  (PostHog/mcp       │        │ Tavily (Nebius'd)   │         │ memory-compiler │
   │  ARCHIVED Jan 19    │        │ Brave Search        │         │ claude-brain    │
   │  2026; use mono-    │        │ Serper              │         └─────────────────┘
   │  repo build OR      │        └─────────────────────┘
   │  Datadog as obs)    │
   │ Sentry MCP (REMOTE  │        slot 17: sandbox bridges        slot 18: sandbox runtimes
   │  HTTP OAuth at      │        ┌─────────────────────┐         ┌──────────────────┐
   │  mcp.sentry.dev/mcp)│        │ **container-use**   │         │ **native PID-ns  │
   │ Langfuse OTLP       │        │  (cu config, no     │         │  + seccomp**     │
   │ Arize OpenInference │        │   .yaml)            │         │  (v2.1.98 stable)│
   │ Braintrust          │        │ microsandbox        │         │ container-use    │
   │ Cloudflare MCP      │        │ E2B MCP wrappers    │         │ E2B              │
   │ Stripe MCP          │        │ arrakis-mcp-server  │         │ Daytona          │
   │ Linear MCP          │        │  (NEW)              │         │ Modal ($0.119–   │
   │ Vercel MCP          │        └─────────────────────┘         │  0.142/vCPU-hr)  │
   │ Figma MCP           │                                        │ Cloudflare SBX   │
   └─────────────────────┘                                        │ Vercel Sandbox   │
                                                                  │ Fly Sprites      │
                                                                  │  (--skip-console)│
   slot 23: context compression       slot 24: workstation        │ Depot remote     │
   ┌─────────────────────┐            ┌──────────────────┐        │ microsandbox     │
   │ **context-mode** 7k │            │ **Ghostty**      │        │ Northflank BYOC  │
   │  (98% reduction)    │            │ WezTerm Kitty    │        │ trailofbits dev  │
   │ caveman 16k (-65%)  │            │  iTerm2          │        │ arrakis          │
   │ rtk 23.3k (-60-90%) │            │ tmux / Zellij    │        │ Managed Agents   │
   │ graphify 21.2k      │            │ zsh / fish       │        │ Kubernetes:      │
   │  (71.5×)            │            │ Starship         │        │  helm + cronjob  │
   │ Squeez (arxiv)      │            │ VS Code / Zed /  │        │  patterns only   │
   └─────────────────────┘            │  Neovim          │        └──────────────────┘
                                      │ chezmoi + age    │
                                      │ Stow / yadm      │
                                      │ git worktrees    │
                                      │ ghost/peon-ping  │
                                      │ claudecode-      │
                                      │   discord        │
                                      │ ocp / agenttray  │
                                      └──────────────────┘
```

### 3.3 Observability and remote services plane

```
                        ┌──────────────────────────────┐
                        │       OBSERVABILITY PLANE    │
   CC kernel ─────────▶ │  CLAUDE_CODE_ENABLE_         │
   (native OTel)        │   TELEMETRY=1                │
                        │  OTEL_*_EXPORTER=otlp        │ ─────┐
                        │  OTEL_EXPORTER_OTLP_ENDPOINT │      │
                        └──────────────────────────────┘      │
                                       │                      │
                       ┌───────────────┼───────────────────┐  │
                       ▼               ▼                   ▼  ▼
                ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐
                │ Langfuse v3 │ │ Phoenix /   │ │ Datadog/        │
                │ (self-host  │ │ Arize       │ │ Honeycomb/      │
                │  +MinIO)    │ │ (9 hooks +  │ │ Grafana/SigNoz/ │
                │ Langfuse v4 │ │  OpenInfer) │ │ ColeMurray ref  │
                │ (cloud      │ │             │ │  stack          │
                │  preview,   │ └─────────────┘ │ claude_telemetry│
                │  10× faster)│                 │  wrapper        │
                └─────────────┘                 └─────────────────┘
                       │                                │
                       ▼                                ▼
                ┌─────────────┐                  ┌──────────────┐
                │ Braintrust  │                  │ LangSmith    │
                │ (eval loop  │                  │ + LangSmith  │
                │  bidirec-   │                  │  Sandboxes   │
                │  tional)    │                  │  (NEW)       │
                └─────────────┘                  └──────────────┘

                        ┌──────────────────────────────┐
                        │       REMOTE SERVICES        │
                        │  Anthropic API ── Bedrock ── │
                        │  Vertex ── Foundry ── Vercel │
                        │  AI Gateway ── managed       │
                        │  Code Review GH App ── CC    │
                        │  Action v1.0.93 ── Managed   │
                        │  Agents ── Cowork            │
                        └──────────────────────────────┘

                        ┌──────────────────────────────┐
                        │     SANDBOX BOUNDARY         │
                        │  native (PID-ns + seccomp)   │
                        │   ╲   container-use (cu)     │
                        │    ╲  E2B / Daytona / Modal  │
                        │     ╲ Cloudflare / Vercel    │
                        │      ╲ Fly Sprites / Depot   │
                        │       ╲ microsandbox /       │
                        │        ╲ trailofbits / arrakis│
                        │         ╲ Managed Agents     │
                        └──────────────────────────────┘
```

The arrows are: events flow up from session → kernel → OTel exporter → backends; tool calls flow down from harness → MCP / native tool / sandbox; permission decisions flow sideways through the hook bus before tool dispatch; remote services live behind the harness boundary and are addressable as either MCP (Sentry/Datadog/Linear/Stripe/Vercel/Cloudflare/Figma remote HTTP) or as direct CLI invocations (gh / vercel / fly / depot / sprite / aws / gcloud).

---

## Section 4 — The Slot Roster

24 slots. Every component from the corpus that earns a slot, with VERIFIED_FACTS additions inline. Primary picks bolded by merit (verified schema, battle-testing, composability, license, commit velocity). Integration prose under each slot.

### Slot 1 — Base CLI kernel

| Tool | Stars | License | Install | Why pick |
|---|---|---|---|---|
| **Claude Code 2.1.101** | n/a | Anthropic ToS | `curl -fsSL https://claude.ai/install.sh \| bash` | Reference harness; only one with Agent Teams, hot-reload skills, native sandbox, OTel, managed Code Review, defer permission decision, Monitor tool |
| `openai/codex` | 74.5k | Apache-2.0 | `npm i -g @openai/codex` | OpenAI-native; SKILL.md compatible |
| `google-gemini/gemini-cli` | 100.9k | Apache-2.0 | `npm i -g @google/gemini-cli` | Default in Antigravity; SKILL.md via community libs |
| `aaif-goose/goose` (transferred from `block/goose`) | 41k | Apache-2.0 | `brew install block/tap/goose` | Model-agnostic; **Adversary Mode** (Mar 31 2026) for sensitive-tool review |
| `ultraworkers/claw-code` (transferred from `instructkr/claw-code`) | 181k | **null (unlicensed)** | rust binary | Clean-room Rust rewrite post-leak; **no license** is a real compliance flag |
| `Kuberwastaken/claurst` | 8.9k | GPL-3.0 | rust binary | Clean-room Rust rewrite by leak-essay author |
| `openclaw/openclaw` | 354.5k | MIT | `npm i -g openclaw` | Independent TypeScript local-first agent (NOT a CC fork); ClawHub skills registry |
| Aider | n/a | Apache-2.0 | `pip install aider-chat` | Old-guard CLI agent; works with Claude API |

> **Correction (Apr 11 verify pass):** `claw-code` is at `ultraworkers/claw-code` (transferred from `instructkr/claw-code`) with **181k stars and no license declared** — corpus body is correct on the location but the license-null field is load-bearing for any compliance-sensitive deployment. `goose` is at `aaif-goose/goose` (transferred from `block/goose`). `openclaw` is **not** a Claude Code fork — it predates the leak by 4 months. (VERIFIED_FACTS.md §2; corpus Part L.4.)

> **Post-corpus release timeline (VERIFIED_FACTS.md §1.2):** v2.1.89 (Apr 1) shipped `defer` permission decision and `PermissionDenied.retry`; v2.1.90 (Apr 1) `/powerup`; v2.1.91 (Apr 2) MCP 500K char limit, plugin `bin/`, `disableSkillShellExecution`; v2.1.92 (Apr 4) per-model + cache-hit `/cost` + Bedrock setup wizard; **v2.1.94 (Apr 7) default `effortLevel` flipped from `medium` → `high` for API/Bedrock/Vertex/Foundry/Team/Enterprise**; v2.1.98 (Apr 9) Monitor tool + production-stable Linux PID-ns+seccomp sandbox + `CLAUDE_CODE_PERFORCE_MODE`; v2.1.101 (Apr 10) `/team-onboarding`. Pin against this timeline.

**Composition.** The kernel slot is structurally exclusive — you run one harness per session. But the SKILL.md format (Slot 3) and AGENTS.md/CLAUDE.md cross-references (Slot 24) let you carry the same discipline layer across every harness, so swapping kernels under emergency (April 6 2026 Claude outage, Part M.7) is a config change rather than a rewrite. Goose's Adversary Mode is the only second-agent-as-gate primitive that ships in a non-Claude harness — relevant to anyone running multi-harness fallbacks. The Vercel AI Gateway recipe (§5.8) is the canonical way to make any harness see all your usage in one observability pane.

### Slot 2 — Agent-first IDEs

| Tool | Status | Notes |
|---|---|---|
| **VS Code + official Anthropic CC extension** | GA | Inline diffs, @-mentions, plan review. Path: `code.claude.com/docs/en/vs-code`. Works with all the dotfile-managed setups (citypaul, nicknisi, fcakyon). |
| Antigravity (Google) | Public preview | Released Nov 18 2025. Heavily-modified VS Code fork. Defaults to Gemini 3 Pro/3.1/Flash; ALSO ships Sonnet 4.5/4.6 + Opus 4.6 + GPT-OSS-120B. First-party multi-model. |
| Cursor 3 (Anysphere) | Released Apr 2 2026 | Agent-first workspace redesign. **Does NOT bundle Claude Code.** Supports Claude 4.6 via MCP. |
| Windsurf (Cognition) | Active | Sonnet 4.6 shipped Feb 19 2026. Promotional credit multipliers. |
| Zed (ACP) | Public beta | Agent Client Protocol, since Sep 3 2025. Wraps Claude Agent SDK in JSON-RPC. CodeCompanion plugin also speaks ACP. |
| JetBrains extension | GA | Standard Anthropic plugin for IntelliJ family. |
| `coder/claudecode.nvim` | 2.5k | Pure Lua, reverse-engineers VS Code extension's WebSocket MCP protocol. Writes `~/.claude/ide/[port].lock`. |
| `greggh/claude-code.nvim` | n/a | Alternative Neovim integration. |
| Kiro (Amazon) | GA Nov 2025 | Three-phase EARS-notation IDE. Plan in Kiro, execute in CC (Morph guide). |

**Composition.** The IDE slot composes orthogonally with the kernel slot — VS Code + CC + Cursor in a split pane is a documented power-user pattern (corpus Part N.4). The `~/.claude/` directory is shared between all of them; the IDE only owns the editor surface. The split-pane teammate display issue (#26572, corpus Part N.6) means VS Code integrated terminal currently can't render Agent Teams' tmux mode; if you want teammates visible in your IDE, you need a real terminal (Ghostty / WezTerm / Kitty) running tmux side-by-side with the editor.

### Slot 3 — Discipline / skills / plugin frameworks

| Framework | Stars | License | Install | Layer |
|---|---|---|---|---|
| **`obra/superpowers`** v5.0.7 | **146,635** | MIT | `/plugin install superpowers@claude-plugins-official` | discipline + 14 skills + 1 reviewer subagent + SessionStart hook |
| `SuperClaude-Org/SuperClaude_Framework` v4.2.0 | ~20.5k | MIT | `/plugin install superclaude` | 30 commands, 16 agents, 7 modes |
| `bmad-code-org/BMAD-METHOD` v6.0.4 | 43k+ | MIT | clone + plugin install | BA → PM → Architect → Dev → TEA roles |
| `Yeachan-Heo/oh-my-claudecode` v4.11.1 | ~27.6k | MIT | `/plugin install oh-my-claudecode` | OMC: 19 agents + 36 skills + 6 modes |
| `gsd-build/get-shit-done` | 50.5k | MIT | clone | 6-phase TÂCHES; `STATE.md` re-injection |
| `davila7/claude-code-templates` | 24.4k | MIT | `npx claude-code-templates@latest` | 600+ agents, 200+ commands, dashboard at aitmpl.com |
| `alirezarezvani/claude-skills` | 10.5k | MIT | clone | 235+ production skills, 9 domains |
| `JimLiu/baoyu-skills` | 14.1k | MIT | clone | TS-based skills |
| `yusufkaraaslan/Skill_Seekers` | 12.6k | MIT | clone | Doc/repo → SKILL conversion w/ conflict detection |
| `mattpocock/skills` | 14k | MIT | clone | Vertical-slices: tdd, grill-me, git-guardrails |
| `forrestchang/andrej-karpathy-skills` | n/a | MIT | clone | Single CLAUDE.md, 4 mantras |
| `sickn33/antigravity-awesome-skills` | 22k | MIT | clone | 1,234+ cross-tool skills |
| `VoltAgent/awesome-claude-code-subagents` | 16.9k | MIT | clone | 130+ subagents, 10 categories |
| `VoltAgent/awesome-agent-skills` | 15.1k | MIT | clone | 1,086+ cross-tool skills |
| `rohitg00/awesome-claude-code-toolkit` | 1.2k | MIT | clone | 135 agents + 35 skills + 42 commands + 176+ plugins |
| `jeremylongshore/claude-code-plugins-plus-skills` | n/a | MIT | clone | 340 plugins + 1,367 skills + CCPI pkg manager |
| `affaan-m/everything-claude-code` | n/a | MIT | clone | Hackathon-winning 28+119+60+34+20+14 bundle |
| `Chat2AnyLLM/awesome-claude-plugins` | n/a | n/a | clone | 43 marketplaces, 834 plugins indexed |
| `Chat2AnyLLM/awesome-claude-skills` | n/a | n/a | clone | 9,397 skills indexed Apr 11 2026 |
| `hesreallyhim/awesome-claude-code` | 38k | MIT | clone | Canonical curated list, 1,020+ commits |
| `andyrewlee/awesome-agent-orchestrators` | n/a | MIT | clone | 96-project orchestrator catalog |
| `poshan0126/dotclaude` | 261 | MIT | clone | Canonical `.claude/` template |
| `citypaul/.dotfiles` | 623 | MIT | chezmoi-style | TDD + mutation + TypeScript-strict baseline |
| `fcakyon/claude-codex-settings` | 587 | MIT | clone | Cross-tool reference w/ AGENTS.md symlink pattern |
| `nicknisi/dotfiles` | n/a | MIT | clone | zsh/nvim/tmux/ghostty/git/CC reference |

> **Critical correction (corpus Part H.1, VERIFIED_FACTS.md §5):** Superpowers ships **zero PreToolUse / PostToolUse / Stop hooks**. Its discipline is entirely prompt-level. Real enforcement (destructive-command blocking, secrets guarding, lint gates) must be layered on top via user-scope hooks (Slot 19). A "Superpowers enforces TDD via hooks" claim is false — Superpowers enforces TDD via the `using-superpowers` SessionStart-injected root skill plus the `subagent-driven-development` controller protocol, both of which are model-attentive, not deterministic.

**Plugin manifest realities (Part B.3, VERIFIED_FACTS.md §1.2 v2.1.91):**
- Manifest at `<plugin-root>/.claude-plugin/plugin.json`. Only `plugin.json` lives inside `.claude-plugin/`.
- Plugins can ship `bin/` (auto-PATH-injected as of v2.1.91) — first-party way to ship CLI tools without becoming an MCP server.
- `disableSkillShellExecution` setting (v2.1.91) lets you turn off skill-time shell execution kernel-wide.
- Plugin agents do **NOT** support `hooks`, `mcpServers`, or `permissionMode`. Plugin `settings.json` only honors the `agent` key.

**Composition.** Discipline frameworks are layerable: Superpowers + OMC + a curated `mattpocock/skills` clone is the canonical "solo-power" stack. They live in the init layer (Slot 0) and execute as either hot-reloaded skills (Slot 4 subagents) or session-injected CLAUDE.md context. They are mutually compatible because they each occupy a different sub-slot: Superpowers owns the *workflow* (brainstorm → plan → execute → review), OMC owns the *orchestration mode* (autopilot, ralph, ultrawork), `mattpocock/skills` owns the *atomic verbs* (`tdd`, `grill-me`, `request-refactor-plan`). The right way to compose them: install all three, let the SessionStart hook inject Superpowers, let CLAUDE.md route between OMC modes and Pocock atoms based on user prompt keywords.

### Slot 4 — Subagent collections

| Collection | Stars | License | Notes |
|---|---|---|---|
| **`wshobson/agents`** | **33.4k** | MIT | 182 agents + 16 multi-agent orchestrators + 149 skills + 96 commands across 77 plugins. Ships **PluginEval** (3-layer eval: static + LLM judge + Monte Carlo, 10 dimensions, Wilson/Clopper-Pearson CI, Elo pairwise, Bronze→Platinum badges). CLI: `uv run plugin-eval score/certify/compare`. |
| `wshobson/commands` | n/a | MIT | 57 slash commands (15 workflows + 42 tools) |
| `VoltAgent/awesome-claude-code-subagents` | 16.9k | MIT | 130+ subagents, 10 categories |
| `contains-studio/agents` | n/a | MIT | 40+ subagents, 6-day-sprint methodology |
| `iannuttall/claude-agents` | n/a | MIT | Mid-tier subagent collection |
| `lst97/claude-code-sub-agents` | n/a | MIT | 35 full-stack subagents |

> **Correction (Apr 11 verify pass):** `wshobson/agents` is missing from the corpus body but verified at **33.4k stars, MIT, actively maintained, the largest CC agent/skill library and a load-bearing ecosystem dependency** for many other projects. It should be Tier 1 in this slot. (VERIFIED_FACTS.md §2.2.)

**Composition.** Subagent collections are durable artifacts in `~/.claude/agents/*.md` — they compose by directory union. wshobson is the substrate; you layer Superpowers' single `code-reviewer` (Part H.1) and Pocock's project-specific subagents on top by virtue of file co-location. The cleanest install: clone wshobson into `~/.claude/agents/wshobson/`, your project agents into `.claude/agents/`, let CC's `/agents` UI surface both. PluginEval is the only objective quality framework in the ecosystem — if you're picking between two agents that claim to do "code review," run them through `plugin-eval compare` rather than trusting stars.

### Slot 5 — Self-hosted multi-agent orchestration platforms

This is the slot that did not exist in mid-2025 and exploded to 20+ active platforms by April 2026. Every corpus Part E entry is listed plus the four scout additions from VERIFIED_FACTS.md §2.2.

| Platform | Stars | License | Lang | Created | Status | Best fit |
|---|---|---|---|---|---|---|
| **`paperclipai/paperclip`** | **51.5k** | MIT | Node + React | Mar 2 2026 | Very active (v2026.403.0 Apr 4) | Org-chart for solo founder running zero-human company. Embedded Postgres, ticket-based, heartbeats, multi-company isolation, audit trails. `npx paperclipai onboard --yes`. |
| **`wshobson/agents`** | **33.4k** | MIT | TS | n/a | Very active | (Cross-listed from Slot 4.) PluginEval-graded substrate the rest of the ecosystem composes against. |
| `ruvnet/ruflo` | 31.2k | MIT | TS+WASM+Rust | n/a | Very active (v3.5) | Rebranded `claude-flow`. SONA self-learning, RuVector RL, Byzantine consensus, 314 MCP tools. Claims 84.8% SWE-Bench (validated by arxiv 2604.06296 13–32× cost gap finding). |
| `BloopAI/vibe-kanban` | 24.8k | Apache-2.0 | Rust + TS | Jun 14 2025 | Very active | Vendor-neutral Kanban for 10+ coding agents. Built-in browser, integrated review, PR generation. `npx vibe-kanban`. |
| `gastownhall/gastown` (steveyegge/gastown) | 13.9k | Apache-2.0 | Go + Dolt + Beads | Jan 2026 | Active | 20-30 parallel agents. Mayors / beads / Polecats / Hooks / Refinery vocabulary. Dolt-versioned state. `brew install gastown`. |
| `multica-ai/multica` | 7.1k | Apache-2.0 (corpus) — **`NOASSERTION` per GH API (verify pass)** | Next.js + Go + PG + pgvector | Jan 13 2026 | Very active (v0.1.24 Apr 11) | Linear-for-agents. Auto-detects `claude/codex/openclaw/opencode`. `brew tap multica-ai/tap`. |
| `smtg-ai/claude-squad` | 6.9k | AGPL-3.0 | Go | n/a | Active (v1.0.17) | tmux-based pane mgr for 4-8 concurrent CC/Codex/Gemini/Aider sessions w/ git worktrees + YOLO. `cs` alias. |
| `ComposioHQ/agent-orchestrator` | 6.2k | MIT | TS | Feb 13 2026 | Active | Issue-to-worktree-to-PR w/ CI auto-healing. Plugin architecture. `npm i -g @aoagents/ao`. |
| `mikeyobrien/ralph-orchestrator` | **2.5k (NEW)** | MIT | n/a | n/a | Very active | Canonical external Ralph-loop runner. Replaces corpus's unverified `ralph-claude-code` / `ralph-tui` / `ralphy` long-tail. (VERIFIED_FACTS.md §2.2.) |
| `stellarlinkco/myclaude` | **2.6k (NEW)** | AGPL-3.0 | n/a | Jul 2025 | Very active | Vendor-neutral multi-agent harness across CC/Codex/Gemini/OpenCode. (VERIFIED_FACTS.md §2.2.) |
| `jayminwest/overstory` | 1.2k | MIT | TS | n/a | Active | 11 runtime adapters (CC/Pi/Copilot/Gemini/Aider/Goose/Amp/...). SQLite mailbox. `bun install -g @os-eco/overstory-cli`. |
| `coollabsio/jean` | **819 (NEW)** | Apache-2.0 | n/a | n/a | Active | From the Coolify team. Desktop+web cross-project orchestrator. (VERIFIED_FACTS.md §2.2.) |
| `baryhuang/claude-code-by-agents` | 838 | MIT | TS + Deno + Electron | Jul 18 2025 | **Stalled since Jan 1 2026** (verify pass) — 3+ months no commits | Claude-only @agent mentions, web UI. Likely abandoned. |
| `Dicklesworthstone/claude_code_agent_farm` | 780 | MIT | Python | n/a | Active | 20-50 parallel CC agents via `ENABLE_BACKGROUND_TASKS=1 claude --dangerously-skip-permissions`. Lock-based conflict prevention. |
| `dlorenc/multiclaude` | 529 | **null** (verify pass — corpus said MIT, GH API returns null) | Go | Jan 18 2026 | **Dormant since Jan 28 2026** (verify pass), low star velocity | Singleplayer (auto-merge) vs multiplayer (human review). Brownian-ratchet pattern. Flag as dormant. |
| `tomascupr/sandstorm` | 431 | n/a | n/a | n/a | n/a | CC agents in cloud sandboxes via API/CLI/Slack. |
| `swarmclawai/swarmclaw` | 311 | n/a | TS | n/a | Active (v1.5.3) | Self-hosted OpenClaw runtime. Connectors (Discord/Slack/TG/WhatsApp/Teams/Matrix). SwarmDock marketplace. |
| `bobmatnyc/claude-mpm` | 108 | Elastic 2.0 | Python | n/a | Active (v6.1.0) | Requires CC v2.1.3+. 47+ agents across PY/TS/Rust/Go/Java. 56+ skills. MCP: GWorkspace + Notion + Confluence + Slack. `claude plugin marketplace add bobmatnyc/claude-mpm-marketplace`. |
| `chernistry/bernstein` | **100 (NEW)** | Apache-2.0 | YAML | Mar 22 2026 | Very recent | Declarative YAML orchestration with **zero LLM coordination overhead** (deterministic routing). Architecturally distinct. (VERIFIED_FACTS.md §2.2.) |
| `GreenSheep01201/Claw-Kanban` | 53 | Apache-2.0 | TS | n/a | Active | 6-column board, routes to CC/Codex/Gemini/OpenCode/Copilot/Antigravity. Telegram + webhook chat-to-card. |
| `mtzanidakis/praktor` (corpus said `praktor` no URL) | 23 | n/a | Go | **Feb 13 2026** (verify pass — corpus said Apr 11) | Active | Multi-agent orchestrator w/ Telegram I/O, Docker isolation, Mission Control UI. |
| `untra/operator` | 12 | MIT | Rust + TS | Dec 22 2025 | Very early | TUI dashboard. Jira + Linear. Priority queue (INV>FIX>FEAT>SPIKE). Multi-project workspace. |
| `Yeachan-Heo/oh-my-claudecode` (OMC) | 27.6k | MIT | n/a | n/a | Active | Cross-listed Slot 3. Teams-first orchestration plugin w/ multi-AI routing. |

> **Correction (Apr 11 verify pass):** `gastown` canonical org is **`gastownhall/gastown`** not `steveyegge/gastown`. `praktor` was created Feb 13 2026 not Apr 11; correct owner `mtzanidakis/praktor`. `multiclaude` license is null not MIT and the repo is dormant since Jan 28 2026. `baryhuang/claude-code-by-agents` is stalled since Jan 1 2026 — flag as likely abandoned. `multica` license per GH API is `NOASSERTION`. (VERIFIED_FACTS.md §2.1.)

**96-project long tail (corpus Part E.4)** — listed for completeness without independent verification:
- **Parallel runners:** `1code`, `agent-deck`, `agent-kanban`, `ai-maestro`, `aizen`, `amux`, `Aperant`, `claude_code_bridge`, `clideck`, `cmux`, `constellagent`, `crystal`, `dmux`, `dorothy`, `emdash`, `ghast`, `humanlayer`, `kodo`, `lalph`, `mux`, `openkanban`, `parallel-code`, `sortie`, `subtask`, `symphony`, `tutti`, `vibe-tree`.
- **Multi-agent swarms:** `antfarm`, `automata`, `ClawTeam`, `clawe`, `CompanyHelm`, `gnap`, `loom`, `multi-agent-shogun`, `openfang`, `opengoat`, `orc`, `ORCH`, `shire`, `skillfold`, `swarm-protocol`, `wit`.
- **Loop runners:** `ralph-claude-code`, `ralph-tui`, `ralphy`, `toryo`, `wreckit`.

**Composition map (from VERIFIED_FACTS.md §2.3 + corpus Part E):**

*Cleanly composable (compose freely):*
- Paperclip + Vibe-Kanban (different layers — org-chart vs Kanban)
- Paperclip + wshobson/agents (Paperclip dispatches, wshobson is the agent substrate)
- Multica + claude-mpm (Multica dashboard, claude-mpm agent library)
- ralph-orchestrator + Claude Squad (Ralph as loop, claude-squad as pane manager)
- Agent Teams (experimental) + BMAD (BMAD slash commands invoked inside Agent Teams)

*Mutually exclusive (do not run together):*
- Paperclip vs Ruflo — both wrap the session loop
- Gastown vs multiclaude — both auto-merge PR ratchets
- vibe-kanban vs Multica — overlapping Kanban abstractions
- Two harnesses on the same session (always)

*Obsoleted by first-party Agent Teams:*
- Claude-Squad partially obsoleted by Agent Teams' `teammateMode: tmux`, but claude-squad still wins for pure terminal-ops.

**Integration prose.** This is the slot that demands the most architectural discipline because the platforms wrap the kernel. They sit between you and the harness and they each pick a different "where the contract lives" stance: Paperclip wraps each agent in an HTTP heartbeat; Vibe-Kanban routes agents to swimlanes via the database; Gastown locks tasks via git-worktree files; Ruflo intercepts the model call to insert RL-routing; Agent Teams sits inside the kernel and dispatches via `SendMessage`. Picking one is a one-way commitment for that session. The blueprint's stance: **install Paperclip + wshobson/agents + Vibe-Kanban as your three "always-installed" substrates** (composable, complementary), then layer Agent Teams inside Paperclip-spawned shells when you need experimental teammate routing on a single repo. For the "20+ parallel agents overnight" use case, use claude_code_agent_farm with `--dangerously-skip-permissions` *inside* trailofbits-devcontainer or container-use.

### Slot 6 — First-party orchestration

| Product | Status | What it is |
|---|---|---|
| **Claude Code Agent Teams** | Experimental | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. Team lead + teammates over shared task list, `SendMessage`, file-locked task claims. Hooks: `TeammateIdle`, `TaskCreated`, `TaskCompleted`. Limitations: 1 team/session, no nesting, fixed lead, in-process teammates can't resume sessions. Split-pane unsupported in VS Code, Windows Terminal, Ghostty (issue #26572). |
| **Claude Managed Agents** | Public beta (Apr 8 2026) | API model: Agent → Environment → Session → Events SSE. Beta header `managed-agents-2026-04-01`. **$0.08/session-hour** + token rates. 60 creates/min, 600 reads/min per org. Built-in checkpointing, scoped permissions, E2E tracing, prompt caching, mid-execution steer/interrupt. **Launch customers: Notion, Rakuten, Asana, Vibecode, Sentry** (corpus said three; VERIFIED_FACTS.md §1.1 adds Vibecode and Sentry). |
| **Claude Cowork** | GA all paid plans (Apr 2026) | RBAC (Enterprise), group spend limits, OTel observability, admin usage analytics. Built in 10 days by orchestrating multiple Claude Code instances (corpus Part P.1, Felix Rieseberg). Runs Claude inside a lightweight VM. |

**Composition.** Agent Teams and the self-hosted orchestration platforms in Slot 5 are *not* obsoleted by each other — Agent Teams sits inside the kernel and is one-team-per-session, the Slot 5 platforms sit outside the kernel and orchestrate multiple sessions. Run them concurrently: Paperclip dispatches a Claude Code session for each ticket; the spawned session has Agent Teams enabled and uses team-mode for the local subtask graph. Managed Agents is the alternative for teams who want Anthropic to own session lifecycle and need ZDR / SOC2 hooks — same architectural slot, different cost/compliance profile, mutually exclusive at the per-task level.

### Slot 7 — Adjacent agent frameworks

| Framework | Stars | License | Notes |
|---|---|---|---|
| **`NousResearch/hermes-agent`** | 55.7k | MIT | v0.8.0. Skill generation, NL cron, multi-platform deployment, MCP integration. NOT CC-specific — sidecar role. |
| `letta-ai/letta-code` | n/a | n/a | Letta Code harness; #1 model-agnostic OSS harness on TerminalBench (claim) |
| `letta-ai/claude-subconscious` | n/a | n/a | Companion memory proxy for Claude Code |
| `letta-ai/letta-cowork` | n/a | n/a | Cowork clone on Letta SDK |
| CrewAI | n/a | MIT | Python multi-agent; consumes CC via MCP or Agent SDK |
| Langroid | n/a | MIT | Python multi-agent; CC integrates as skill author |
| Microsoft Agent Framework 1.0 | n/a | MIT | Released Apr 7 2026. Unifies Semantic Kernel + AutoGen. Full MCP. **AutoGen EOL Oct 2025.** |
| LangGraph / LangChain | n/a | MIT | General orchestration; embed Agent SDK in a node |
| Temporal | n/a | MIT | Embed Agent SDK in activities |
| Apache Airflow | n/a | Apache-2.0 | Embed Agent SDK in operators |
| Argo Workflows | n/a | Apache-2.0 | Embed Agent SDK in steps |

**Composition.** Adjacent frameworks are *sidecars*, not replacements. Letta is the canonical memory sidecar — a single stateful Letta agent serves multiple Claude Code sessions in parallel with shared cross-session memory. Hermes is the canonical multi-channel deployment sidecar — Discord/Telegram/Slack/email for the same skill set. Temporal/Argo are the durable-orchestration sidecars for long-horizon work that needs SLA guarantees the Claude Code session log alone doesn't provide. Use them through MCP (each framework exposes itself as an MCP server) or via the Agent SDK inside their own task units (Temporal activity, Argo step, Airflow operator) — the integration recipe in §5.10 walks the Letta + Hermes + CrewAI sidecar pattern.

### Slot 8 — Spec-driven development

| Tool | Stars | Install | Notes |
|---|---|---|---|
| **`github/spec-kit`** v0.5.1 | 71-77k | `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.5.1` | Commands prefixed: `/speckit.constitution`, `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`. Directory: `specs/NNN-feature-name/{spec,plan,tasks}.md`. arxiv 2604.05278 reports **58.2% pass@1** on SWE-Bench Lite when combined with CC. |
| Amazon Kiro | n/a (commercial) | IDE | EARS notation. Plan in Kiro, execute in CC (Morph guide). |
| Tessl | $125M raised | commercial | Spec-as-source. Generated code marked DO NOT EDIT. |
| `gotalab/cc-sdd` | n/a | clone | Ports Kiro-style SDD into CC/Codex/OpenCode/Cursor/Copilot/Gemini/Windsurf. |
| `gsd-build/get-shit-done` | 50.5k | clone | 6-phase TÂCHES; names "context rot." Cross-listed Slot 3. |
| OpenSpec | ~10k | clone | Open-source spec runner. |
| `bmad-code-org/BMAD-METHOD` v6.0.4 | 43k+ | plugin | BA→PM→Architect→Dev→TEA. Integrates w/ Agent Teams via slash commands. |
| Drew Breunig — Plumb | n/a | n/a | Auto-updates specs from git diffs in commit-fail mode. The triangle (spec ↔ tests ↔ code). |
| `eforge-build/eforge` | 58 | n/a | Apr 10 2026. Agentic build system. |
| `OmoiOS` | 40 | n/a | Mar 5 2026. Multi-agent over Claude + OpenHands. |
| `metaskill` | 31 | n/a | Feb 23 2026. Meta-skill for agent team generation. |
| `claude-agent-builder` | 30 | n/a | Mar 6 2026. NL → production agents. |

> **Schema trap (corpus Part B + Part G.1):** Spec-Kit install is `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.5.1` — **NOT** `pipx install`, **NOT** `npm install -g`. Slash commands are prefixed `/speckit.*` — never unprefixed.

> **Counter-evidence preserved (corpus Part G.8):** Rick's Café AI's *Spec-Driven Development Is Waterfall in Markdown* (Apr 8 2026) reports the Scott Logic test where SDD ran **10× slower with the same bugs**. Treat SDD as a tool with a real cost; Drew Breunig's triangle (Plumb) is the synthesis answer.

**Composition.** Spec-Kit is the universal entry point — it works inside Claude Code, Codex, Cursor, Gemini, Antigravity, Copilot, Windsurf via the `/speckit.*` slash commands, so the same `specs/NNN/` directory is consumable by every harness. Layer BMAD on top when you need formalized roles (BA → PM → Architect → Dev → TEA). Layer Plumb on top when you need spec drift to be auto-corrected from git history. The recipe in §5.3 walks how Spec-Kit's `plan.md` feeds Superpowers' execution layer.

### Slot 9 — MCP servers — code intelligence

| Server | Install | Notes |
|---|---|---|
| **`oraios/serena` v1.1.0** | `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` | LSP-based symbolic editing, 30+ languages. **v1.1.0 shipped April 11 2026.** Also available as official Claude Plugin. |
| `entrepeneur4lyf/code-graph-mcp` | `claude mcp add code-graph -- npx -y code-graph-mcp` | Graph-based code intel. |
| `DeusData/codebase-memory-mcp` | n/a | Persistent KG, 66 languages, sub-ms queries, HNSW. |
| `CodeGraphContext` | n/a | Alternative. |
| `codegraph-rust` | `cargo install codegraph-rust` | Rust-native code graph. |

> **Correction (Apr 11 verify pass):** Serena's install command in the corpus (`uvx --from git+...`) is **deprecated** per Serena's own README. Use **`uv tool install -p 3.13 serena-agent@latest --prerelease=allow`**. v1.1.0 shipped April 11 2026. (VERIFIED_FACTS.md §3.2.)

**Composition.** Serena composes with the file-tools (Read/Edit/Write/MultiEdit) by *replacing* them as the primary code-edit path: when Serena is registered, the model prefers `mcp__serena__find_symbol` over `Grep` and `mcp__serena__replace_symbol_body` over `Edit`. This collapses the Read → Grep → Edit → Verify hop into one symbolic op and is the single highest-leverage MCP install for any project >5K LOC. Pair with Slot 23 context compression (`context-mode`) so the symbol-level outputs don't blow the context window on monorepos.

### Slot 10 — MCP servers — docs / library lookup

| Server | Install | Notes |
|---|---|---|
| **`upstash/context7`** | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest --api-key $CONTEXT7_API_KEY` | #1 on FastMCP by views, ~2× #2. **Now requires `--api-key` from `context7.com/dashboard`** — anonymous mode is rate-limited. |
| **DeepWiki MCP** | `claude mcp add deepwiki --transport http https://mcp.deepwiki.com/mcp` | Free remote no-auth. Three tools: `ask_question`, `read_wiki_structure`, `read_wiki_contents`. |
| ref.tools | n/a | Surfaced but not independently verified. |
| docs-mcp-server | n/a | Alternative, less mature. |

> **Correction (Apr 11 verify pass):** Context7 now requires `--api-key`. Anonymous mode is rate-limited. (VERIFIED_FACTS.md §3.2.)

**Composition.** DeepWiki + Context7 is the canonical 2026 docs stack: DeepWiki when the library has a wiki on Devin's index, Context7 for everything else. Both compose with web-search MCPs (Slot 16) — when context7/DeepWiki return nothing, fall back to Exa. The model picks automatically via MCP Tool Search (Jan 14 2026, on by default, Part B.4).

### Slot 11 — MCP servers — browser

| Server | Install | Notes |
|---|---|---|
| **`@playwright/mcp`** | `claude mcp add playwright -- npx @playwright/mcp@latest` | Accessibility-tree snapshots (2-5 KB) vs screenshots (500 KB-2 MB) — 10-100× faster. Also Claude Plugin. |
| `ChromeDevTools/chrome-devtools-mcp` | `claude mcp add chrome-devtools -- npx chrome-devtools-mcp` | 26 tools across input/nav/debug/network/perf/emulation. Live Chrome debug. |
| `browserbase/mcp-server-browserbase` | remote at `mcp.browserbase.com/mcp` | Stagehand v3 cloud. Auth-heavy flows. 20-40% faster via auto-caching. |
| Puppeteer MCP | `claude mcp add puppeteer -- npx puppeteer-mcp` | Alternative. |
| `lightpanda-io/browser` | n/a | Zig headless browser for AI. |
| `trycua/cua` | n/a | Local computer-use operator for macOS. |
| page-agent | n/a | JS GUI agent for web control. |
| `@playwright/cli` token-efficient variant | n/a | Adjunct to Playwright MCP (NEW per VERIFIED_FACTS.md §3.3). |

**Composition.** Playwright MCP is the default browser; Browserbase is the production alternative for auth-heavy flows; chrome-devtools-mcp is the live debugging adjunct. Playwright a11y-tree returns kill the screenshot-tax problem — that's the leverage. Compose with the MCP sandbox bridges (Slot 17) when the browser session itself needs isolation.

### Slot 12 — MCP servers — GitHub / git

| Server | Install | Notes |
|---|---|---|
| **`github/github-mcp-server`** | `claude mcp add-json github '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer $YOUR_GITHUB_PAT"}}'` | Most-starred MCP server (28,300+⭐). **Rewritten in Go** since corpus freeze; tool count grown past 51. New: Projects tools, code scanning, `get_me`, OAuth scope filtering. |
| GitLab MCP | `claude mcp add gitlab -- /bin/gitlab-mcp-server` | First-class for GitLab CI flow. |

> **Correction (Apr 11 verify pass):** github-mcp-server tool count has grown past the corpus's 51, the server has been rewritten in Go, and OAuth scope filtering is new since Jan 28 2026. (VERIFIED_FACTS.md §3.2.)

**Composition.** github-mcp-server composes with the CI/CD slot (20) — every PR-comment-driven workflow uses it for the actual GH ops. With managed Code Review (also Slot 20), the github-mcp gives Claude Code the ability to read its own review comments and respond to them, closing the loop without leaving the session.

### Slot 13 — MCP servers — database

| Server | Install | Notes |
|---|---|---|
| **Supabase MCP** v0.7.0 | `claude mcp add supabase --transport http https://mcp.supabase.com/mcp` | OAuth 2.1 since Oct 2025. **Explicitly dev/test only** per Supabase's own docs. |
| postgres-mcp | `claude mcp add postgres -- npx postgres-mcp` | Plain Postgres. |
| mysql-mcp | `claude mcp add mysql -- npx mysql-mcp` | |
| sqlite-mcp | `claude mcp add sqlite -- npx sqlite-mcp` | |
| mongodb-mcp | `claude mcp add mongodb -- npx mongodb-mcp` | |
| `googleapis/mcp-toolbox` v0.30.0 | `claude mcp add gcp-toolbox --transport http http://localhost:5000/mcp` | **NEW per VERIFIED_FACTS.md §3.3.** Official Google. BigQuery + AlloyDB + Spanner + CloudSQL + Postgres + MySQL. Self-hosted HTTP. Fills enterprise GCP gap. |

**Composition.** Database MCPs compose with the spec/plan layer (Slot 8) — the model can read schemas during planning, validate migrations during the plan phase, and run test queries during implementation. **Never give a database MCP read-write access to a production database from a Max-subscription session** (see Principle 7) — wire the MCP to a read replica or a CI-only workspace, and use Supabase MCP only against a dev project.

### Slot 14 — MCP servers — memory

| Server | Stars | Notes |
|---|---|---|
| **`thedotmack/claude-mem`** | 12.9k | Highest-star CC memory plugin. Uses Agent SDK to compress session transcripts and re-inject context. |
| `memU` | 13.3k | 24/7 proactive agent memory. |
| **`milla-jovovich/mempalace`** (NEW) | **23k** | 19 MCP tools, **96.6% LongMemEval** with caveat (score reflects ChromaDB default embeddings, not the "palace" architecture — README correction forced by community scrutiny). MIT, Python. `pip install mempalace`. (VERIFIED_FACTS.md §3.3.) |
| **`supermemory`** (NEW) | 15k | Universal memory API. (VERIFIED_FACTS.md §3.3.) |
| `m4cd4r4/claude-echoes` | n/a | **81% LongMemEval** with pgvector + BM25. First well-measured memory system. |
| `modelcontextprotocol/servers/memory` (official) | n/a | Local JSON KG, minimal but battle-tested. |
| `gannonh/memento-mcp` | n/a | Neo4j backend, unified graph+vector, temporal versioning, confidence decay. |
| `doobidoo/mcp-memory-service` | 1.6k | REST + KG + dream-inspired consolidation. SQLite-vec / ChromaDB / Cloudflare backends. `#skip` and `#remember` natural triggers. |
| `yoloshii/ClawMem` | 96 | BM25+vector+RRF+reranker, 31 MCP tools. TS/Bun. Hooks inject context every prompt; Stop hook extracts decisions. |
| `visionscaper/collabmem` | n/a | Long-term collaboration memory. |
| `agenteractai/lodmem` | n/a | Level-of-Detail context (graphics rendering analogy). |
| `coleam00/claude-memory-compiler` | n/a | Karpathy-style KB compiler from session logs. |
| `memvid/claude-brain` | n/a | Single `.mv2` file, Rust core. |

> **Correction (Apr 11 verify pass, VERIFIED_FACTS.md §3.3):** `mempalace` is missing from the corpus body but is **23k stars** with a measured benchmark — add as a Tier 1 alternate. `supermemory` is also missing. The mempalace LongMemEval score is real but reflects the default ChromaDB embedding stack, not the architectural novelty — preserve this caveat verbatim.

**Composition.** Memory MCPs are the *durable* counterpart to in-conversation context compression (Slot 23). Compose them: `claude-mem` compresses transcripts back into session-injected summaries, `mempalace` or `mcp-memory-service` provides the cross-session knowledge graph the SessionStart hook queries. The §5.6 recipe walks the dream-consolidation + DECISIONS.md + CLAUDE.md self-improvement loop. With v2.1.91's 500K char MCP result limit (VERIFIED_FACTS.md §1.2), memory MCPs can return much richer chunks than they could three months ago — re-evaluate any "memory MCP returns truncated context" complaint against the new ceiling.

### Slot 15 — MCP servers — observability

| Server | Install | Notes |
|---|---|---|
| **`datadog-labs/mcp-server`** (NEW PRIMARY) | `claude mcp add datadog --transport http https://mcp.datadoghq.com/api/unstable/mcp-server/mcp` | GA Mar 10 2026. 16+ tools across logs/metrics/traces/incidents + optional APM/LLM Observability toolsets. **Fills the gap left by PostHog/mcp archival.** (VERIFIED_FACTS.md §3.1, §3.3.) |
| `getsentry/sentry-mcp` | **remote HTTP OAuth at `https://mcp.sentry.dev/mcp`** | No local install. Also a Claude plugin. (VERIFIED_FACTS.md §3.2.) |
| ~~`PostHog/mcp`~~ | **ARCHIVED Jan 19 2026** | Read-only. Use the new server via the PostHog monorepo, the PostHog Wizard, or **`datadog-labs/mcp-server`** as a replacement. (VERIFIED_FACTS.md §3.1.) |
| Stripe MCP | `mcp.stripe.com` | Official Anthropic partner, 25 tools covering full payment lifecycle. Part of `stripe/ai` monorepo. (VERIFIED_FACTS.md §3.3.) |
| Linear MCP | `mcp.linear.app` | Official remote. (VERIFIED_FACTS.md §3.3.) |
| Vercel MCP | `mcp.vercel.com` | Official Vercel remote with OAuth + Streamable HTTP. (VERIFIED_FACTS.md §3.3.) |
| Cloudflare MCP | n/a | 2,500 API endpoints compressed into ~1k tokens — impressive context engineering. (VERIFIED_FACTS.md §3.3.) |
| Figma MCP | n/a | Official Anthropic partner, design-to-code. (VERIFIED_FACTS.md §3.3.) |

> **Correction (Apr 11 verify pass):** PostHog/mcp is archived as of Jan 19 2026. Use Datadog MCP as the new Slot 15 primary, with PostHog-via-monorepo as alternate. Sentry MCP is now remote HTTP OAuth (`https://mcp.sentry.dev/mcp`), not stdio. (VERIFIED_FACTS.md §3.1, §3.2.)

**Composition.** Observability MCPs compose with the tracing slot (21) bidirectionally: native OTel pushes events *out*, MCPs query the same backends *in*, so Claude Code can read its own Sentry errors and Datadog metrics during a fix session. Sentry's "weekly performance triage bot" cookbook is the canonical pattern. Wire them so the model can `mcp__sentry__list_issues` → reproduce → fix → verify → close loop without leaving the session.

### Slot 16 — MCP servers — search

| Server | Install | Notes |
|---|---|---|
| **Exa MCP** | `claude mcp add exa -- npx -y exa-mcp-server` | Most-used search MCP in 2026 per ChatForest. Native Claude connector. Best for semantic/exploratory. |
| Perplexity Sonar MCP | `claude mcp add perplexity -- npx perplexity-sonar-mcp` | Cited synthesis answers. |
| Tavily | `claude mcp add tavily -- npx tavily-mcp` | **Acquired by Nebius Feb 2026.** Cheap keyword search. |
| Brave Search MCP | `claude mcp add brave -- npx brave-search-mcp` | Alternative. |
| Serper MCP | `claude mcp add serper -- npx serper-mcp` | Alternative. |

**Composition.** Search MCPs are the bottom of the docs/intel pyramid: try Serena first (Slot 9, in-codebase symbol lookup), then DeepWiki/Context7 (Slot 10, library docs), then Exa/Perplexity (Slot 16, public web). MCP Tool Search lets the model pick automatically. Pair with `context-mode` (Slot 23) so search outputs don't blow context budgets.

### Slot 17 — MCP servers — sandbox bridges

| Server | Install | Notes |
|---|---|---|
| **`dagger/container-use`** v0.4.2 | `claude mcp add container-use -- container-use stdio` | Per-agent git branch + container. `cu watch` streams audit. **No `.claude/container-use.yaml` — use `cu config` subcommands.** |
| `microsandbox/microsandbox` | `claude mcp add --transport stdio microsandbox -- npx -y microsandbox-mcp` | libkrun-backed microVMs, <100ms boot. |
| E2B MCP wrappers | community | |
| **`abshkbh/arrakis-mcp-server`** (NEW) | n/a | MCP integration repo for the `arrakis` sandbox. Corpus Part I.16 mentions arrakis but omits this companion server. (VERIFIED_FACTS.md §4.3.) |

> **Correction (Apr 11 verify pass):** `container-use` has **NO `.claude/container-use.yaml` file**. Configuration is via `cu config` subcommands only. (VERIFIED_FACTS.md §1.1.) `arrakis-mcp-server` is the actual integration path for Claude Code → arrakis. (VERIFIED_FACTS.md §4.3.)

**Composition.** Sandbox bridges sit between the harness and the sandbox runtimes (Slot 18). They expose `mcp__container-use__open_environment` etc. as ordinary tools, so the model can spawn its own per-task isolated environment without your hooks needing to. The §5.1 Superpowers + container-use recipe shows the canonical wiring.

### Slot 18 — Sandbox runtimes

This slot has a built-in decision tree by use case (full version in §6).

| Runtime | Backing | Cold start | Best fit |
|---|---|---|---|
| **Native Linux PID-ns + seccomp** (v2.1.98 stable) | kernel | 0ms | Default for any Linux workstation. No container required. (VERIFIED_FACTS.md §1.2.) |
| **`dagger/container-use`** v0.4.2 | Docker | seconds | Per-agent branch + container, audit log via `cu watch`. Best general-purpose isolation. |
| Docker `sbx` + sandbox-templates:claude-code | Docker | seconds | Desktop dev w/ Docker Desktop. `--dangerously-skip-permissions` ON inside. Does NOT inherit host `~/.claude`. |
| E2B | Firecracker | ~150ms | Default for code-exec sandboxes. Pro $150/mo, 24h sessions. |
| Daytona | Docker-in-Docker | <90ms (marketing) | Drop-in Dockerfiles/compose. |
| **Modal** | gVisor | sub-second | Python/ML-heavy Agent SDK. **$0.119–0.142/vCPU-hr** on sandbox tier (corpus said $0.047 — corrected per VERIFIED_FACTS.md §4.2). |
| Cloudflare Sandbox SDK | Containers (Beta) | 2-3 min initial | Serving CC features to end-users from Workers, globally. Claude Code preinstalled. |
| Vercel Sandbox | Firecracker | seconds | Serving CC from Vercel-native apps. node24/node22/python3.13. Hobby 45-min cap, Pro/Enterprise 5h. |
| **Fly.io Sprites** | Firecracker | <1s on URL access | 100GB NVMe + 8 CPU + 16 GB RAM platform defaults. Live Checkpoints ~300ms. **Claude Code preinstalled, OAuth at first run, no `--cpu`/`--disk` flags. `--skip-console` flag for non-interactive CI use.** (VERIFIED_FACTS.md §1.1, §4.3.) |
| Depot Remote Agent Sandboxes | n/a | <5s | Async-only. $0.01/min by-the-second, no minimums. `depot claude --session-id ...`. |
| microsandbox | libkrun | <100ms | Local hardware-isolated, no Docker Desktop. |
| Northflank | Kata + Firecracker + gVisor | n/a | BYOC (AWS/GCP/Azure/Oracle/CoreWeave/bare-metal). **SOC 2 Type 2.** Compliance / GPU-adjacent. |
| trailofbits/claude-code-devcontainer | n/a | seconds | "Yolo" mode (`--dangerously-skip-permissions`) but auditable. Sec-research workflows. |
| `abshkbh/arrakis` | n/a | n/a | Open-source self-hostable sandboxing (HN 27 pts). |
| **Claude Managed Agents** | Anthropic-hosted | n/a | $0.08/session-hour + tokens. Beta header `managed-agents-2026-04-01`. Built-in checkpointing + scoped permissions. |
| Kubernetes patterns | n/a | n/a | No widely-adopted operator CRD. `chrisbattarbee/claude-code-helm` Helm chart, CronJob pattern (futuresearch.ai). |
| `adityaarakeri/claude-on-a-leash` | n/a | n/a | Show HN Apr 8 — deterministic guardrails. |
| `bglusman/zeroclawed` | n/a | n/a | Show HN Apr 10 — secure agent gateway. |

> **Correction (Apr 11 verify pass):** Modal sandbox-tier pricing is **$0.119–0.142/vCPU-hr** (corpus said $0.047, which reflects older or preemptible base compute). Fly Sprites has a `--skip-console` flag for non-interactive CI use. The Linux PID-namespace+seccomp subprocess sandbox is **production-stable** as of v2.1.98, not beta. (VERIFIED_FACTS.md §4.2, §4.3, §1.2.)

**Composition.** Sandbox runtimes don't compose horizontally — pick one per task. They *do* compose vertically: native Linux sandbox inside container-use inside Daytona for "I want belt + suspenders + audit trail" overnight runs against a real cloud account. The decision tree in §6 picks by use case (interactive desktop, CI ephemeral, autonomous overnight, serving end users, security audit). The §5.9 recipe shows the four-sandbox layered strategy.

### Slot 19 — Hooks ecosystem

| Repo | Stars | Lang | Notes |
|---|---|---|---|
| **`disler/claude-code-hooks-mastery`** | 3.5k | Python | Canonical reference, full event coverage. `ai_docs/claude_code_hooks_docs.md` is repomixed official docs. |
| `disler/claude-code-hooks-multi-agent-observability` | 1.4k | Python | Observability pipeline. |
| `doobidoo/mcp-memory-service` | 1.6k | JS | Memory-aware session-start/mid/end hooks. |
| `kenryu42/claude-code-safety-net` | 1.2k | TS | Security hooks plugin. |
| `sangrokjung/claude-forge` | 645 | TS | |
| **`karanb192/claude-code-hooks`** | 340 | JS | **Best destructive-command blocker** — three-tier critical/high/strict engine. JSONL audit logs. Modern JSON stdout protocol. |
| `lasso-security/claude-hooks` | 200 | n/a | Security-focused. |
| `bartolli/claude-code-typescript-hooks` | 174 | JS | Multi-flavor quality-check (node-ts/react/vscode) with SHA-256 tsconfig cache. |
| `diet103/claude-code-infrastructure-showcase` | n/a | Bash+TS | Monorepo tsc-check + Stop-resolver subagent. |

> **Correction (Apr 11 verify pass):** Exit-code-2 blocking events are **12, not 4**. Complete list: PreToolUse, UserPromptSubmit, PermissionRequest, WorktreeCreate, Stop, SubagentStop, TeammateIdle, TaskCreated, TaskCompleted, ConfigChange, Elicitation, ElicitationResult. WorktreeCreate aborts on **any non-zero exit**. (VERIFIED_FACTS.md §1.1.)

> **Correction (Apr 11 verify pass, VERIFIED_FACTS.md §1.2):** v2.1.89 added `"defer"` as a fourth `permissionDecision` value (alongside `allow|deny|ask`). PreToolUse hook returns `{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "defer", "permissionDecisionReason": "..."}}` to pause the session for external resolution. v2.1.89 also added `PermissionDenied` hook support for `{retry: true}` to retry the original prompt after a denial.

**Battle-tested patterns (corpus Part H.3):**
- **PreToolUse destructive blocker** — karanb192's `block-dangerous-commands.js` (rm/dd/mkfs/fork-bomb/curl|sh/git force-push/chmod 777/docker volume rm/crontab -r/sudo rm).
- **PreToolUse secrets guard** — karanb192's `protect-secrets.js` (~40 sensitive-file patterns + ~25 bash exfiltration patterns + ALLOWLIST for `.env.example/.sample/.template/.schema`). Missing: `/etc`, `/usr`, `~/.gnupg` — extend manually.
- **PostToolUse quality-check** — bartolli's `quality-check.js` (Prettier + ESLint + tsc with SHA-256 config cache); diet103's `tsc-check.sh` (per-subrepo tsconfig, cached errors, Stop-resolver).
- **SessionStart memory loader** — doobidoo's `session-start.js` (full memory-awareness, project context detect, git-context query, phase-slot scoring, system-message injection). Dual-protocol stdin/stdout.
- **SessionEnd checkpoint** — doobidoo's `session-end.js` (parse transcript JSONL, regex classifiers, store as memory with tags, async quality eval). Respects `#skip` and `#remember`.

**Categories with NO battle-tested public implementation (corpus Part H.3):**
- UserPromptSubmit spec-kit context injector — build from `disler/user_prompt_submit.py` skeleton.
- StopFailure ticket creator — build from `disler/post_tool_use_failure.py` skeleton, replacing local logging with `gh issue create` or Linear REST.

**Composition.** Hooks are how you turn Superpowers (advisory) into deterministic enforcement (Principle 2). Layer them by event: PreToolUse for blocking, PostToolUse for verifying, SessionStart for context injection, SessionEnd for memory consolidation. The §7 install playbook ships the canonical 5-hook setup. The new `defer` decision unlocks headless workflows where a hook hands off to Slack/Linear for human approval and the session resumes when the human clicks — see §6 decision tree.

### Slot 20 — CI/CD

| Tool | Notes |
|---|---|
| **`anthropics/claude-code-action@v1`** v1.0.93 (Apr 10 2026) | Verbatim full input table in corpus Part J.1. `prompt` + `claude_args` (v1 unification). Bun pinned 1.3.6. Composite. Bedrock/Vertex/Foundry via OIDC. Plugin install via `plugins:` + `plugin_marketplaces:`. |
| **Code Review for Claude Code** managed app | Launched Mar 9 2026. Team & Enterprise only. **NOT available with Zero Data Retention enabled.** Review behaviors: Once / After every push / Manual. Manual triggers: `@claude review`, `@claude review once`. Severity gate via `bughunter-severity` JSON in HTML comment + the verbatim jq incantation. |
| systemprompt.io 5 recipes | Auto PR Review / Issue to PR / Doc Sync / Test Generation / Release Notes — full YAML in corpus Part R.5. |
| GitLab CI/CD integration | Beta. `claude -p ... --permission-mode acceptEdits --allowedTools "Bash Read Edit Write mcp__gitlab"`. **GitLab Duo Agent Platform with Claude** launched Feb 26 2026. |
| CircleCI MCP | Not an orb. `npx @circleci/mcp-server-circleci@latest`. Validate config, trigger builds, fetch logs, analyze flakes. |
| Buildkite | Anthropic is a first-class model provider (LLM proxy). `claude-summarize-buildkite-plugin`. |
| Dagger via container-use | Canonical MCP-registered bridge. Audit via `cu watch`. |
| Vercel AI Gateway | Two paths: API key vs Max subscription. **Max-path requires the empty `ANTHROPIC_API_KEY=""` trap below.** Unified tracing for non-Vercel projects. |
| Vercel plugin + Vercel Sandbox | One-command deploys, `--follow` log streaming, preview deploys. |
| ArgoCD / Flux GitOps | No native first-party plugin. CC authors Kustomize/Helm PR → ArgoCD reconciles. |
| Temporal / Argo / Airflow | No first-party CC integrations. Embed Agent SDK in activities/steps/operators. |

> **Schema trap (corpus Part J.7, R.12, VERIFIED_FACTS.md §4.1):** Vercel AI Gateway Max path requires **all three** of:
> ```bash
> export ANTHROPIC_BASE_URL="https://ai-gateway.vercel.sh"
> export ANTHROPIC_CUSTOM_HEADERS="x-ai-gateway-api-key: Bearer your-ai-gateway-api-key"
> export ANTHROPIC_API_KEY=""  # MUST be empty string, not unset
> ```
> The empty-string requirement is load-bearing — Claude Code checks `ANTHROPIC_API_KEY` first and bypasses the gateway if it's non-empty.

> **Schema trap (corpus Part J.2, VERIFIED_FACTS.md §4.1):** Code Review severity jq incantation, character-for-character:
> ```bash
> gh api repos/OWNER/REPO/check-runs/CHECK_RUN_ID \
>   --jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson'
> ```
> The space before `-->` is **load-bearing** because the HTML comment format is `<!-- bughunter-severity: {...} -->`.

> **Correction (Apr 11 verify pass, VERIFIED_FACTS.md §4.3):** Anthropic explicitly enforced the "subscription plans prohibit scripted/automated use" policy on **April 4 2026** by cutting subscription access for **Cline, Cursor, Windsurf, and OpenClaw** harnesses. Combined with the corpus's policy text, this means: **CI must use API billing**, not Max subscription. Add this as a load-bearing event to any subscription-vs-API decision.

**Composition.** CI/CD is the post-merge integration of every other slot: Slot 19 hooks fire inside the action runner, Slot 21 OTel exports to your observability backend, Slot 18 sandbox provides the runtime, Slot 9-17 MCPs are reachable from inside the runner. The §5.5 recipe wires `claude-code-action@v1` + Code Review + the bughunter jq gate into a single merge pipeline.

### Slot 21 — Observability / tracing

| Backend | Notes |
|---|---|
| **Native CC OpenTelemetry** | `CLAUDE_CODE_ENABLE_TELEMETRY=1`. Exporters: `OTEL_METRICS_EXPORTER`, `OTEL_LOGS_EXPORTER`, `OTEL_TRACES_EXPORTER` (`otlp`/`prometheus`/`console`/`none`). TRACEPARENT auto-propagated into Bash/PowerShell. **`CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` is ONLY needed for the distributed-traces beta**, not for basic metrics. |
| **Langfuse v3** (self-host) | OTLP-compatible. `OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:3000/api/public/otel"`. **Docker-compose REQUIRES MinIO; cannot be dropped.** |
| Langfuse v4 (cloud preview) | March 10 2026. Observations-first data model. Wide ClickHouse table. **10× dashboard speedup.** Self-hosted v4 path TBD as of Apr 11 2026. (VERIFIED_FACTS.md §4.3.) |
| Arize Phoenix | `Arize-ai/arize-claude-code-plugin` uses 9 hooks. OpenInference spans. Richest hook-based capture. |
| Braintrust | `braintrustdata/braintrust-claude-plugin`. Bidirectional: auto-trace + `bt eval --watch`/`bt sql`/MCP. **Strongest eval-loop integration.** |
| LangSmith | `.claude/settings.local.json` with `TRACE_TO_LANGSMITH`. `langsmith-fetch` CLI + 3 skills. |
| **LangSmith Sandboxes** (NEW) | LangChain. Secure code execution for agents. (VERIFIED_FACTS.md §4.3.) |
| Helicone | `ANTHROPIC_BASE_URL` proxy. Helicone now recommends new Rust AI Gateway for new users. |
| Honeycomb / Datadog / Grafana / SigNoz | No CC-specific plugins. All work via native OTel pipeline. |
| `TechNickAI/claude_telemetry` | Drop-in `claudia` replacement that exports to Logfire/Sentry/Honeycomb/Datadog without editing settings.json. |
| `ColeMurray/claude-code-otel` | Reference Grafana stack. |
| `anthropics/claude-code-monitoring-guide` | Official Anthropic reference. |

> **Correction (Apr 11 verify pass):** **`CLAUDE_CODE_ENABLE_TELEMETRY=1` alone is sufficient** for basic metrics + log events. Pairing it with `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` silently opts you into the distributed-traces beta. The corpus's R.1 example pairs them; only do that if you want the beta. (VERIFIED_FACTS.md §1.1.)

**Composition.** OTel is the universal pipe; backends are the consumers. Run Langfuse v3 self-hosted as the canonical default (open-source, OTLP-native, MinIO required). Layer Phoenix on top via the 9-hook plugin if you want OpenInference span granularity. Layer Braintrust if you're running a real eval loop. Datadog/Honeycomb/Grafana for ops integration. The §5.4 recipe wires native OTel → Langfuse → Grafana end-to-end.

### Slot 22 — Cost / desktop / session tooling

| Tool | Stars | Notes |
|---|---|---|
| **Native CC `/cost` (v2.1.92)** | n/a | Per-model + cache-hit breakdown. **Now first-class as of April 4 2026.** Downgrades the rest of this slot to "supplementary." (VERIFIED_FACTS.md §1.2.) |
| `ryoppippi/ccusage` v18.0.10 | 12.7k | Reads `~/.claude/projects/` JSONL. Daily/monthly/session/5h-window. `@ccusage/mcp`. No API key. Also covers Codex/OpenCode/Amp. `npx ccusage@latest daily`. |
| `carlosarraes/ccost` | n/a | Rust single-binary alternative. |
| `badlogic/cccost` | n/a | Instruments CC for actual token tracking. |
| `aarora79/claude-code-usage-analyzer` | n/a | Wraps ccusage + LiteLLM pricing. |
| `suzuki0430/ccusage-vscode-extension` | n/a | VS Code surface. |
| `Maciek-roboblog/Claude-Code-Usage-Monitor` | n/a | Live TUI w/ burn rate, 5h block timer, predictions. |
| `dhanushkumarsivaji/kerf-cli` | 8 (HN) | SQLite-backed cost analytics. |
| `juanpabloaj/workpulse` | n/a | "Yet Another Htop for Agents." |
| `jarrodwatts/claude-hud` | n/a | Context usage, active tools, running agents, todo progress HUD. |
| `yahnyshc/daedalus` | n/a | Per-tool checkpoints. |
| `matt1398/claude-devtools` v0.4.10 | 3k | Electron app reading `~/.claude/`. **Per-turn 7-category token attribution.** Context viz, inline diffs, subagent execution trees. `brew install --cask claude-devtools`. |
| `es617/claude-replay` | 608 | CLI converting CC/Cursor/Codex/Gemini transcripts to HTML w/ playback. `npx claude-replay`. |
| `daaain/claude-code-log` | n/a | Python alternative. |

> **Correction (Apr 11 verify pass):** Native `/cost` shipped in v2.1.92 (Apr 4 2026) with per-model + cache-hit breakdown. The rest of this slot is now supplementary. Re-evaluate whether you need ccusage / kerf-cli at all if you're already using native `/cost`. (VERIFIED_FACTS.md §1.2.)

**Composition.** `/cost` is the live signal; ccusage is the historical reporter; claude-devtools is the deep-inspection desktop app; claude-replay is the shareable artifact for blog/demo/post-mortem. They compose because they read different views of the same `~/.claude/projects/*.jsonl` data. Pair with cost-anomaly canaries from §9 — a sudden token-burn delta is the leading indicator of a model regression.

### Slot 23 — Context compression

| Tool | Stars | Notes |
|---|---|---|
| **`mksglu/context-mode`** | 7k | MCP server that sandboxes tool output. **98% context reduction.** Session 30 min → 3 hours on same budget. **Compresses output channel, not input** (Principle 6). |
| `JuliusBrussee/caveman` | 16k | "Cuts 65% of tokens by talking like caveman" (real measurements). |
| `rtk-ai/rtk` | 23.3k | CLI proxy reducing token consumption **60-90%** on common dev commands. |
| `safishamsi/graphify` | 21.2k | **71.5× token reduction** by compiling folder into KG. Karpathy-inspired. |
| Squeez (arxiv 2604.04979) | n/a | Formal: 0.86 recall with 92% input token reduction. Task-conditioned tool-output pruning. |

**Composition.** Context compression composes vertically with memory MCPs (Slot 14): compression handles in-session output, memory handles cross-session knowledge. Pair `context-mode` with `claude-mem` for the full pipeline. Note that v2.1.91's 500K char MCP result limit (VERIFIED_FACTS.md §1.2) means the *upper bound* of what an MCP can return is now 5× what compression tools were designed against — re-evaluate whether you still need aggressive compression or just need to raise the MCP ceiling.

### Slot 24 — Workstation

| Layer | Primary | Alternates | Notes |
|---|---|---|---|
| **Terminal** | **Ghostty** (Mitchell Hashimoto) | WezTerm, Kitty, iTerm2 | Native Shift+Enter, fast GPU, low memory. Ghostty + Kitty get desktop notifications free. |
| **Multiplexer** | **tmux** w/ `allow-passthrough on` | Zellij | `teammateMode` depends on tmux currently (issue #26572 tracks `CustomPaneBackend` RFC). |
| **Shell** | **zsh** | Fish (Sablonnière), bash | citypaul, nicknisi, Freek all zsh; Sablonnière fish. |
| **Prompt** | **Starship** | — | Cross-dotfile consensus. |
| **Editor** | **VS Code + CC ext** | Zed (ACP), Neovim (`coder/claudecode.nvim` 2.5k⭐), JetBrains, Cursor split-pane | See Slot 2. |
| **Dotfile mgr** | **chezmoi + age** | GNU Stow, plain git + install, yadm | Dedicated blog: arun.blog/sync-claude-code-with-chezmoi-and-age. |
| **Git workflow** | **git worktrees** w/ `.claude/worktrees/<task>` | Desktop orchestrators: `johannesjo/parallel-code` 511⭐, `manaflow-ai/cmux` | Official `--worktree` + `isolation: worktree` in subagent frontmatter; `/batch` orchestrates parallel. |
| **Issue tracker** | **GitHub MCP + Linear MCP** | Jira MCP | Canonical ticket-to-PR loop. |
| **Session inspector** | **`matt1398/claude-devtools`** | — | Reads `~/.claude/` locally, zero outbound. |
| **Cost monitor** | **native `/cost`** + ccusage + Claude-Code-Usage-Monitor | — | `/cost` per-session, ccusage history, Usage-Monitor live burn rate. |
| **Notifications** | `tonyyont/peon-ping` (Warcraft III voice) | claudecode-discord, agenttray | 1006 HN points. |
| **Mobile control** | **`claudecode-discord`** | dtzp555-max/ocp (controversial sub-share) | Discord bot controlling CC across machines without API keys. |

**Canonical `~/.claude/` layout (corpus Part N.1):**
```
# ~/.claude/
~/.claude/
├── CLAUDE.md
├── CLAUDE.local.md            # gitignored personal overrides
├── settings.json
├── rules/                     # modular rule files
├── skills/
├── agents/
├── hooks/
├── loop.md                    # default `claude --loop` prompt
├── statusline.sh
├── bin/                       # auto-PATH via plugin v2.1.91
└── runtime-only (gitignored):
    ├── projects/
    ├── sessions/
    ├── ide/[port].lock
    ├── plugins/
    ├── teams/
    └── tasks/
```

**AGENTS.md / CLAUDE.md / GEMINI.md pattern (from `fcakyon/claude-codex-settings`, corpus Part C.6):**
```bash
# In repo root
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md GEMINI.md
```
Single source of truth in `AGENTS.md`, every harness reads it. AGENTS.md is governed by the Linux Foundation's Agentic AI Foundation as of December 9 2025 (corrected from corpus's January date, VERIFIED_FACTS.md §1.1).

**Composition.** The workstation layer is what makes the rest of the architecture livable. Ghostty + tmux + git worktrees is a triad: Ghostty gives you the surface, tmux gives you the parallel panes, worktrees give you the parallel filesystems. citypaul, fcakyon, hsablonniere, freek, nicknisi all converge on roughly this baseline. Layer chezmoi + age on top to put your `~/.claude/` in version control (encrypted secrets) and you have a portable, reproducible workstation that survives a fresh OS install in 15 minutes.

---

## Section 5 — Integration / Wiring Recipes

Ten concrete recipes, every one with concrete commands, arrows, and packets. The brain↔hands contract (`execute(name, input) → string`) is the universal connector; every recipe shows which slot produces the call, which slot consumes the result, and what flows on the wire.

### Recipe 5.1 — Superpowers + container-use: per-agent isolated branches

**Goal.** Run Superpowers' `subagent-driven-development` controller such that every implementer subagent lands in its own git branch + container with full audit trail, and merges land in a single review pipeline.

**Arrows.**
```
[Controller session] ──writing-plans──▶ plan.md
                    ──Task tool──▶ [implementer subagent] ──cu env──▶ container-use (branch: cc-<id>)
                                                                              │
                                                                              ▼
                    ◀──diff+report────────────────────────── edits committed to branch
                    ──Task tool──▶ [spec-reviewer subagent] ── diff read-only ──▶ branch
                    ──Task tool──▶ [code-quality-reviewer] ── same ──▶ branch
                    ──cu merge──▶ main
```

**Steps.**
1. `brew install dagger/tap/container-use` and `cd /path/to/repo && claude mcp add container-use -- container-use stdio` (corpus Part I.5, R.8).
2. `/plugin install superpowers@claude-plugins-official` (corpus Part H.1, R.13). SessionStart hook auto-injects `using-superpowers`.
3. In Claude Code session: invoke `brainstorming` (Socratic gate) → `writing-plans` (outputs `docs/superpowers/plans/<date>-<feature>.md`).
4. Pick subagent-driven execution. The controller reads `plan.md` once, extracts all task text inline, creates `TodoWrite` entries.
5. For each task, the controller dispatches an `implementer` subagent via Task tool with `implementer-prompt.md`. The implementer calls `mcp__container-use__open_environment` to create a fresh branch + container, runs TDD, commits, reports `DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED`.
6. Stage 1 review: `spec-reviewer` subagent verifies diff matches task text exactly (loop until ✅).
7. Stage 2 review: `code-quality-reviewer` subagent returns Critical/Important/Suggestion findings. Implementer fixes, reviewer re-reviews.
8. On all-green: `cu merge <id> --delete`. On abandon: `cu delete <id>`.

**Rationale.** Superpowers ships the *protocol* but zero hooks (corpus Part H.1); container-use supplies the *isolation*; together they give you git-worktree + audit-log determinism without requiring Agent Teams (issue #429). Layer karanb192's destructive-command PreToolUse hook (Slot 19) as a belt on top — Superpowers' discipline alone doesn't block `rm -rf /` because there are no Superpowers hooks.

### Recipe 5.2 — Agent Teams vs self-hosted orchestration: which wraps which

**Goal.** Clarify what Agent Teams intercepts vs what a platform like Paperclip or Vibe-Kanban intercepts, and how to run both.

**Arrows.**
```
[Paperclip dashboard] ──dispatch ticket──▶ [Claude Code session N]
                                               │
                                               ▼
                                     ENV: CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
                                               │
                                               ▼
                              ┌────────────────────────────────┐
                              │ Agent Teams (in-session)       │
                              │ team lead + teammates + shared │
                              │ task list + SendMessage        │
                              └────────────────────────────────┘
```

**Steps.**
1. Install Paperclip (`npx paperclipai onboard --yes`, corpus Part E.1). Add Claude Code as an employee agent.
2. In Paperclip's agent config for each employee, set `env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.
3. Define teammate roles in `.claude/agents/<role>.md` (project-scope). These are the roles the team lead can spawn.
4. When Paperclip dispatches a ticket, it spawns a new Claude Code session; inside the session, the team lead reads the ticket description and spawns teammates via natural-language prompt.
5. Teams hooks (`TeammateIdle`, `TaskCreated`, `TaskCompleted`, corpus Part A.4) fire inside the session; Paperclip's heartbeat monitors the *session*, not the teammates.
6. On session completion, Paperclip reads the audit log and either promotes the diff to a PR or marks the ticket failed.

**Rationale.** Paperclip sits *outside* the session; Agent Teams sits *inside*. They compose because they occupy different layers. Do not try to run Paperclip + Ruflo simultaneously (both wrap the session loop — mutually exclusive per VERIFIED_FACTS.md §2.3). Do not try to run Agent Teams *across* sessions — it's one-team-per-session.

### Recipe 5.3 — Spec-Kit phases feed Superpowers' execution

**Goal.** Plan in `/speckit.*`, execute via Superpowers' subagent-driven-development controller.

**Arrows.**
```
/speckit.constitution ──▶ .specify/memory/constitution.md
/speckit.specify "..."  ──▶ specs/NNN-feature/spec.md
/speckit.plan           ──▶ specs/NNN-feature/plan.md
/speckit.tasks          ──▶ specs/NNN-feature/tasks.md
                              │
                              ▼
                     Superpowers' writing-plans reads specs/NNN-feature/plan.md
                              │
                              ▼
                     docs/superpowers/plans/<date>-<feature>.md (Superpowers-shaped)
                              │
                              ▼
                     subagent-driven-development controller
```

**Steps.**
1. `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.5.1` (corpus Part G.1, R.7).
2. In the Claude Code session, `/speckit.constitution` once per project to set principles.
3. `/speckit.specify "describe what you want"` generates `specs/NNN-feature/spec.md`.
4. `/speckit.plan` generates `plan.md` with tech-stack + architecture.
5. `/speckit.tasks` generates `tasks.md` with the task list.
6. Invoke Superpowers' `writing-plans` skill pointed at `specs/NNN-feature/plan.md` — it re-shapes the plan into Superpowers' bite-sized-2-to-5-min format in `docs/superpowers/plans/`.
7. Invoke `subagent-driven-development` as in Recipe 5.1.

**Rationale.** Spec-Kit is the universal planner; Superpowers is the execution discipline. Spec-Kit's `/speckit.*` prefix keeps it portable across harnesses (Codex, Cursor, Gemini, Antigravity, Windsurf, Copilot all read the same `specs/` directory). arxiv 2604.05278 reports **58.2% pass@1** on SWE-Bench Lite for this exact composition (corpus Part Q.7).

### Recipe 5.4 — Native OTel → Langfuse v3 → Grafana

**Goal.** Wire Claude Code's native OpenTelemetry beta end-to-end into Langfuse (self-hosted, with MinIO) and then into Grafana for dashboards.

**Arrows.**
```
Claude Code ──(OTel OTLP HTTP)──▶ Langfuse v3 (localhost:3000)
                                     │ (ClickHouse + Postgres + MinIO)
                                     ▼
                              Langfuse native dashboards
                                     │
                                     ▼ (Prometheus scrape / Grafana data source)
                              Grafana dashboards
```

**Steps.**
1. Pull the canonical Langfuse v3 docker-compose (corpus Part K.1, R.11):
   ```bash
   curl -fsSL https://raw.githubusercontent.com/langfuse/langfuse/main/docker-compose.yml \
     > langfuse-docker-compose.yml
   docker compose -f langfuse-docker-compose.yml up -d
   ```
2. **Do not remove the MinIO service.** Langfuse v3 requires it for S3-compatible event storage. (VERIFIED_FACTS.md §4.1.)
3. Open `http://localhost:3000`, create project, copy `pk-lf-...` and `sk-lf-...`.
4. In `~/.claude/settings.json`, set `env`:
   ```json
   {
     "env": {
       "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
       "OTEL_METRICS_EXPORTER": "otlp",
       "OTEL_LOGS_EXPORTER": "otlp",
       "OTEL_EXPORTER_OTLP_PROTOCOL": "http/protobuf",
       "OTEL_EXPORTER_OTLP_ENDPOINT": "http://localhost:3000/api/public/otel",
       "OTEL_EXPORTER_OTLP_HEADERS": "Authorization=Basic $LANGFUSE_AUTH_B64,x-langfuse-ingestion-version=4"
     }
   }
   ```
   where `LANGFUSE_AUTH_B64=$(echo -n "$LANGFUSE_PUBLIC_KEY:$LANGFUSE_SECRET_KEY" | base64 -w 0)`.
5. **Do not also set `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` unless you want distributed traces beta** (VERIFIED_FACTS.md §1.1). The corpus's R.1 example pairs them; only do that if you explicitly want the beta.
6. Run a Claude Code session. Metrics `claude_code.session.count`, `claude_code.token.usage`, `claude_code.cost.usage`, `claude_code.lines_of_code.count`, `claude_code.commit.count`, `claude_code.pull_request.count`, `claude_code.code_edit_tool.decision`, `claude_code.active_time.total` appear in Langfuse.
7. Add Langfuse as a Grafana data source (Prometheus endpoint) and import `ColeMurray/claude-code-otel` reference dashboard.

**Rationale.** Native OTel is the universal pipe; Langfuse is the opinionated backend (open-source, OTLP-native, strong skill-eval flow); Grafana is for teams that already run it. The MinIO requirement is non-negotiable in v3 — dropping it breaks event storage silently.

### Recipe 5.5 — Managed Code Review + claude-code-action + bughunter severity gate

**Goal.** Ship a merge pipeline that uses managed Code Review for analysis, claude-code-action for fixes, and a custom severity gate that blocks merge on Important findings.

**Arrows.**
```
PR opened ──▶ GitHub (webhook)
              │
              ├──▶ Claude GitHub App (managed Code Review)
              │        │ neutral check run + HTML comment w/ bughunter-severity JSON
              │        ▼
              │    Code Review Gate workflow ──jq──▶ exit 0/1
              │
              └──▶ claude-code-action@v1 (fix PR suggestions on @claude mention)
```

**Steps.**
1. Enable managed Code Review at `claude.ai/admin-settings/claude-code → Code Review → Setup` (corpus Part J.2, R.14). Team/Enterprise only. **Not available with ZDR enabled.** Set `Review Behavior` to `After every push`.
2. Drop `REVIEW.md` at repo root with custom rules (corpus Part J.2) — free-form markdown, no frontmatter.
3. Drop the gate workflow at `.github/workflows/code-review-gate.yml`:
   ```yaml
   # .github/workflows/code-review-gate.yml
   name: Code Review Gate
   on:
     pull_request:
       types: [opened, synchronize, reopened]
   jobs:
     wait-and-gate:
       runs-on: ubuntu-latest
       permissions: { contents: read, pull-requests: read, checks: read }
       steps:
         - name: Wait for Claude Code Review
           id: wait
           env:
             GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
             HEAD_SHA: ${{ github.event.pull_request.head.sha }}
           run: |
             set -euo pipefail
             for i in $(seq 1 60); do
               id=$(gh api "repos/${GITHUB_REPOSITORY}/commits/${HEAD_SHA}/check-runs" \
                 --jq '.check_runs[] | select(.name == "Claude Code Review") | select(.status == "completed") | .id' \
                 | head -n1)
               if [[ -n "$id" ]]; then echo "check_run_id=$id" >> "$GITHUB_OUTPUT"; exit 0; fi
               sleep 30
             done
             echo "check_run_id=" >> "$GITHUB_OUTPUT"
         - name: Parse severity and gate
           if: steps.wait.outputs.check_run_id != ''
           env:
             GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
             CHECK_RUN_ID: ${{ steps.wait.outputs.check_run_id }}
           run: |
             set -euo pipefail
             severity=$(gh api "repos/${GITHUB_REPOSITORY}/check-runs/${CHECK_RUN_ID}" \
               --jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson')
             normal=$(printf '%s' "$severity" | jq -r '.normal // 0')
             [[ "$normal" -gt 0 ]] && { echo "::error::${normal} Important findings"; exit 1; }
             echo "OK"
   ```
4. Drop a systemprompt.io-style PR-review workflow at `.github/workflows/claude-pr-review.yml` using `anthropics/claude-code-action@v1` for the fix loop (corpus Part R.5, J.1).
5. In GitHub branch protection, require `Code Review Gate / wait-and-gate` to pass.

**Schema trap (corpus Part J.2, VERIFIED_FACTS.md §4.1).** The jq incantation `--jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson'` is character-for-character. The space before `-->` is load-bearing — the HTML comment format is `<!-- bughunter-severity: {"normal": N, "nit": N, "pre_existing": N} -->`.

**Rationale.** Managed Code Review is always neutral (never blocks merge by itself, Part J.2). The gate is how you turn neutral into blocking. `claude-code-action@v1` is the *fix* pipeline, independent and orthogonal — running both produces duplicate findings if their scope overlaps, so scope the action to "implement fixes on @claude mention" and let the managed app do analysis.

### Recipe 5.6 — mcp-memory-service + DECISIONS.md + CLAUDE.md self-improvement loop

**Goal.** Build a durable memory loop where every session ends with extracted decisions, next session starts with relevant memory injection, and CLAUDE.md self-improves from mistakes.

**Arrows.**
```
UserPromptSubmit ──▶ SessionStart hook reads memory ──▶ injected into context
       │
       ▼
  (session work)
       │
       ▼
SessionEnd hook ──▶ parse transcript JSONL
                      │
                      ├──▶ DECISIONS.md append (human-readable audit trail)
                      ├──▶ mcp-memory-service memory (semantic KG)
                      └──▶ CLAUDE.md self-improvement: append "lesson learned"
                                           ↑
                                           └── Cherny's golden rule (corpus Part O.2)
```

**Steps.**
1. Install `doobidoo/mcp-memory-service` (corpus Part D.6, K.4):
   ```bash
   uvx mcp-memory-service &
   claude mcp add memory -- uvx mcp-memory-service
   ```
2. Set `MCP_MEMORY_BACKEND=sqlite-vec` and `MCP_MEMORY_PATH=$HOME/.claude/memory`.
3. Drop doobidoo's `session-start.js` at `~/.claude/hooks/session-start.js` (corpus Part H.3). Register in settings.json:
   ```json
   "SessionStart": [{ "hooks": [{ "type": "command", "command": "node ~/.claude/hooks/session-start.js" }] }]
   ```
4. Drop doobidoo's `session-end.js` at `~/.claude/hooks/session-end.js`. It parses the transcript JSONL, extracts topics/decisions/insights/code-changes/next-steps via regex classifiers, stores as memory with tags, respects `#skip` and `#remember` user overrides.
5. Add a `CLAUDE.md` self-improvement instruction per Cherny's golden rule: *"Anytime Claude does something incorrectly, add it to this file so it doesn't repeat next time."*
6. Drop a `DECISIONS.md` append step into `session-end.js` that writes each extracted decision as a bullet with date + session-id.
7. Optional: `pip install mempalace` (23k⭐, 19 MCP tools, VERIFIED_FACTS.md §3.3) and wire in parallel for cross-session retrieval if doobidoo's local KG feels thin.

**Rationale.** Memory in Claude Code is entirely community (corpus Part K.4 — "Anthropic's first-party memory story: nothing beyond CLAUDE.md"). The SessionStart/SessionEnd pair is the canonical way to close the self-improvement loop. The `#skip`/`#remember` user overrides let you curate what lands in memory instead of letting the regex classifier run unattended.

### Recipe 5.7 — Paperclip / Vibe-Kanban / Multica / Gastown wrapping strategies

**Goal.** Pick one wrapper per use-case and understand where the `execute(name, input) → string` contract sits.

**Paperclip** (corpus Part E.1): intercepts at the *company level* — tickets enter via Kanban, heartbeats monitor employees (agent sessions), the contract lives at the ticket boundary. The session runs a normal Claude Code harness; Paperclip sees only the ticket → commit → merge output. Best for solo founder running a long-horizon autonomous business.

**Vibe-Kanban** (corpus Part E.1): intercepts at the *agent level* — 10+ coding agents as first-class citizens, workspace execution with branch/terminal/dev-server access. The contract lives at the agent-swimlane boundary. Best for small team that lives in Kanban and wants vendor neutrality.

**Multica** (corpus Part E.2): intercepts at the *issue level* — Linear-for-agents, issues posted to a Kanban board, agents assigned, solutions become reusable skills. The contract lives at the issue boundary. Best for "I want my agents to act like engineers in a linear-style tracker."

**Gastown** (corpus Part E.2): intercepts at the *task level* with Dolt-versioned state — Mayors decompose, Polecats execute, Hooks persist beyond crashes, Refinery merges. The contract lives at the task file lock. Best for aggressive 20-30 parallel agents on complex monorepos with versioned state.

**Compose them two at a time**, not three: Paperclip + Vibe-Kanban is the canonical dual-wrapper setup (different layers — one is org-chart, the other is Kanban, and neither overlaps). Paperclip + Multica is partial overlap (both are Kanban-shaped) — don't.

### Recipe 5.8 — Vercel AI Gateway for non-Vercel deploys (Max subscription path)

**Goal.** Run Claude Code with a Max subscription (human OAuth) while routing all traffic through Vercel AI Gateway for unified observability, even though the project does not deploy to Vercel.

**Arrows.**
```
claude ──OAuth login (Option 1)──▶ Anthropic auth server
  │ but all model traffic routed via env vars
  ▼
https://ai-gateway.vercel.sh ──▶ Anthropic API
                                    │
                                    ▼
                          Vercel AI Gateway Overview + Vercel Observability dashboards
```

**Steps.**
1. Create a Vercel AI Gateway API key at `vercel.com/<team>/ai-gateway`.
2. Export all three (corpus Part J.7, R.12, VERIFIED_FACTS.md §4.1):
   ```bash
   export ANTHROPIC_BASE_URL="https://ai-gateway.vercel.sh"
   export ANTHROPIC_CUSTOM_HEADERS="x-ai-gateway-api-key: Bearer $YOUR_VERCEL_AI_GW_KEY"
   export ANTHROPIC_API_KEY=""  # MUST be empty string, not unset
   ```
3. Run `claude` and choose **Option 1 (Claude account with subscription)** at the login prompt.
4. The session now runs against Anthropic via the gateway — observability is captured in the Vercel dashboard even though no Vercel deploy exists.

**Schema trap (VERIFIED_FACTS.md §4.1).** `ANTHROPIC_API_KEY` **must be set to the empty string**, not left unset. Claude Code checks `ANTHROPIC_API_KEY` first and if non-empty bypasses the gateway and uses it directly as a Claude API key. This is a new trap not in the corpus's original text.

**Non-goal.** This is an *interactive* pattern. For CI, use the API-key path instead (also in R.12) and bill to a separate workspace — see Principle 7 and Recipe 5.5.

### Recipe 5.9 — Four-sandbox composition by use case

**Goal.** Compose native / container-use / cloud sandboxes so every use case has the right isolation boundary.

**Arrows.**
```
[Interactive desktop work]          ──▶ native PID-ns + seccomp (v2.1.98)
[CI ephemeral]                      ──▶ GH Actions runner + Docker sbx OR container-use
[Autonomous overnight]              ──▶ container-use (audit) + trailofbits-devcontainer (yolo)
[Serving CC features to end users]  ──▶ Cloudflare Sandbox SDK OR Vercel Sandbox OR Fly Sprites
[20+ parallel async runs]           ──▶ Depot `depot claude` async
[Complex long-horizon single agent] ──▶ Fly Sprites with 100GB NVMe + Live Checkpoints
```

**Steps (per layer).**
1. **Local native.** No install — v2.1.98 shipped PID-namespace+seccomp as production-stable. Set `"sandbox": { "enabled": true, "autoAllowBashIfSandboxed": true }` in settings.json (corpus Part B.1).
2. **container-use bridge.** `brew install dagger/tap/container-use` + `claude mcp add container-use -- container-use stdio`. Use `cu watch` for live audit; `cu merge <id> --delete` when done.
3. **Fly Sprites overnight.** `curl -fsSL https://sprites.dev/install.sh | sh && sprite org auth && sprite create my-overnight --skip-console` (no `--cpu`/`--disk` — platform defaults are 8 CPU / 16 GB / 100 GB NVMe; `--skip-console` per VERIFIED_FACTS.md §4.3 is the non-interactive variant). Claude Code is preinstalled; first `claude` run uses OAuth.
4. **Cloudflare Sandbox for end-user serving.** `npm create cloudflare@latest -- claude-code-sandbox --template=cloudflare/sandbox-sdk/examples/claude-code` + `npx wrangler secret put ANTHROPIC_API_KEY` — this is the path for shipping Claude Code-powered features to Workers users.
5. **Depot async.** `brew install depot/tap/depot` + `depot claude secrets add ANTHROPIC_API_KEY --value "$YOUR_KEY"` + `depot claude --session-id feature-auth --repository https://github.com/foo/bar --branch main "prompt"`.
6. **Managed Agents (Anthropic-hosted).** Use when you need Anthropic to own session lifecycle + Sentry/Notion launch-customer feature set (VERIFIED_FACTS.md §1.1). Beta header `managed-agents-2026-04-01`, $0.08/session-hour.

**Rationale.** The corpus's 14 sandbox runtimes (Part I) split cleanly by use case: native for fast-path interactive, container-use for audit, Fly Sprites for persistent long-horizon, Cloudflare/Vercel for serving-end-users, Depot for async CI-triggered, Managed Agents for Anthropic-owned lifecycle, trailofbits for `--dangerously-skip-permissions` with accountability, Modal for Python/ML-heavy Agent SDK workloads. Composition is vertical per task; never try to run two sandboxes side-by-side for the same agent.

### Recipe 5.10 — Hermes + Letta + CrewAI as sidecars

**Goal.** Integrate Hermes (multi-channel deployment), Letta (cross-session memory), and CrewAI (Python multi-agent) as sidecars to a Claude Code session, not as replacements.

**Arrows.**
```
User ──prompt──▶ Claude Code session
                     │
                     ├──mcp__hermes__*──▶ NousResearch/hermes-agent (discord/tg/slack/wa)
                     ├──mcp__letta__*──▶ letta-ai/letta-code (durable memory, shared across sessions)
                     └──mcp__crewai__*──▶ crewai-tools[mcp] (Python team for heavy workloads)
```

**Steps.**
1. **Hermes.** Install per `NousResearch/hermes-agent` README (corpus Part F.1). Expose it as an MCP server; `claude mcp add hermes --transport http http://localhost:9100/mcp`. Now Claude Code can call `mcp__hermes__send_telegram` / `mcp__hermes__send_discord` / `mcp__hermes__create_cron` to reach any of Hermes's 200+ models and channel surfaces.
2. **Letta.** Run `letta-ai/letta-code` server. `claude mcp add letta -- letta-code mcp-stdio`. Now every Claude Code session (even in parallel) can call `mcp__letta__recall`, `mcp__letta__remember`, `mcp__letta__update_memory` against the same durable agent, giving cross-session memory without a SessionEnd hook.
3. **CrewAI.** Install `pip install "crewai-tools[mcp]"`. Expose a specific Crew as an MCP stdio server; Claude Code calls `mcp__crewai__run_crew` when it needs a heavy-duty multi-agent Python workload (e.g., parallel literature search with 5 specialist agents) without inflating its own context.

**Rationale.** Adjacent frameworks are *not* replacements for Claude Code — they're MCP-addressable capabilities. Hermes gives you channels, Letta gives you memory, CrewAI gives you Python-native multi-agent. All three compose because they each expose the `execute(name, input) → string` contract over MCP and Claude Code's harness doesn't care which side of the wire the tool runs on.

---

## Section 6 — Routing Decisions (Decision Trees)

### 6.1 Which orchestration layer should I install?

```
Start
 │
 ├── Am I shipping a product to my own end users?
 │    ├── Yes → Claude Managed Agents + Cowork
 │    └── No  → continue
 │
 ├── Do I want an org-chart abstraction (employees, budgets, company state)?
 │    ├── Yes → Paperclip (51.5k⭐)
 │    └── No  → continue
 │
 ├── Do I live in Kanban and want vendor neutrality across CC/Codex/Gemini?
 │    ├── Yes → Vibe-Kanban (24.8k⭐) OR Multica (7.1k⭐)
 │    │         • Vibe-Kanban if: integrated browser + PR generation are important
 │    │         • Multica if: Linear-style tracker ergonomics are important
 │    └── No  → continue
 │
 ├── Am I running 20-30 parallel agents on a monorepo w/ versioned state?
 │    ├── Yes → Gastown (13.9k⭐)
 │    └── No  → continue
 │
 ├── Do I want 100+ agents with RL-based routing and claimed 30-50% token savings?
 │    ├── Yes → Ruflo (31.2k⭐)
 │    └── No  → continue
 │
 ├── Am I a solo dev running 4-8 overnight terminals?
 │    ├── Yes → Claude Squad (6.9k⭐) + tmux
 │    └── No  → continue
 │
 ├── Do I want an issue-to-PR loop with CI auto-healing?
 │    ├── Yes → ComposioHQ/agent-orchestrator (6.2k⭐)
 │    └── No  → continue
 │
 ├── Do I want a declarative YAML pipeline with zero LLM in coordination?
 │    ├── Yes → chernistry/bernstein (100⭐, architecturally distinct)
 │    └── No  → continue
 │
 └── Default → Superpowers alone + Agent Teams (experimental) + wshobson/agents substrate
```

Per-branch rule: **Paperclip** for "run a company"; **Vibe-Kanban** for "run a team"; **Gastown** for "run aggressive parallelism on one repo"; **Ruflo** for "optimize cost via routing"; **Claude Squad** for "multiplex terminals"; **Superpowers alone** for "I just want discipline, I'll wrap later"; **wshobson** always as substrate.

### 6.2 Which sandbox for which use case?

```
Start
 │
 ├── Interactive desktop work, Linux?
 │    └── native PID-ns + seccomp (v2.1.98, zero install)
 │
 ├── Interactive desktop work, macOS?
 │    └── Docker sbx (`sbx run claude ~/my-project`) OR trycua/cua for computer-use
 │
 ├── CI ephemeral runs?
 │    ├── GitHub Actions → runner + container-use for audit
 │    └── Other CI       → Modal ($0.119-0.142/vCPU-hr) OR Daytona
 │
 ├── Autonomous overnight?
 │    ├── Need persistent filesystem + checkpoint/restore → Fly Sprites (100GB NVMe, --skip-console)
 │    ├── Need async triggered from dashboard             → Depot (`depot claude`, $0.01/min)
 │    └── Need yolo mode + auditable                      → trailofbits/claude-code-devcontainer
 │
 ├── Serving Claude Code-powered features to end users?
 │    ├── Cloudflare-native → Cloudflare Sandbox SDK (CC preinstalled)
 │    ├── Vercel-native     → Vercel Sandbox (`@vercel/sandbox`)
 │    └── Globally edge     → Cloudflare Sandbox SDK
 │
 ├── Enterprise / BYOC / SOC 2?
 │    └── Northflank (Kata + Firecracker + gVisor, BYOC to AWS/GCP/Azure/Oracle/CoreWeave/bare-metal)
 │
 ├── Anthropic-owned session lifecycle?
 │    └── Claude Managed Agents ($0.08/session-hour + tokens, `managed-agents-2026-04-01` header)
 │
 └── Security audit / untrusted code review?
      └── trailofbits-devcontainer + `--dangerously-skip-permissions`
```

### 6.3 Which memory system?

```
Start
 │
 ├── I only need CLAUDE.md and self-improvement on-mistake?
 │    └── Cherny's golden rule + SessionEnd hook appending to DECISIONS.md (no MCP)
 │
 ├── I want semantic cross-session retrieval with minimal ops?
 │    └── doobidoo/mcp-memory-service (sqlite-vec, dream consolidation, #skip/#remember)
 │
 ├── I want the highest-measured accuracy on LongMemEval?
 │    ├── Benchmarked → claude-echoes (81% LongMemEval with pgvector+BM25)
 │    └── Largest     → mempalace (23k⭐, 96.6% but caveat: reflects default embeddings not architecture)
 │
 ├── I want a richer graph with temporal versioning?
 │    └── gannonh/memento-mcp (Neo4j, unified graph+vector, confidence decay)
 │
 ├── I want transcript compression back into context?
 │    └── thedotmack/claude-mem (12.9k⭐, Agent SDK-based compression)
 │
 └── I want 24/7 proactive agent memory?
      └── memU (13.3k⭐)
```

### 6.4 Which observability backend?

```
Start
 │
 ├── Self-host, open-source, OTLP-native, strongest skill-eval flow?
 │    └── Langfuse v3 (MinIO required, cannot drop)
 │
 ├── Want 10× faster dashboards and cloud-hosted?
 │    └── Langfuse v4 cloud preview (self-host v4 path TBD as of Apr 11 2026)
 │
 ├── Want OpenInference span granularity with 9-hook capture?
 │    └── Arize Phoenix / Arize AX (Arize-ai/arize-claude-code-plugin)
 │
 ├── Want bidirectional eval-loop integration?
 │    └── Braintrust (`bt eval --watch`, `bt sql`, MCP)
 │
 ├── Already on Honeycomb/Datadog/Grafana/SigNoz?
 │    └── Use native OTel → your existing backend (no CC-specific plugin needed)
 │
 ├── Don't want to edit settings.json at all?
 │    └── TechNickAI/claude_telemetry drop-in wrapper
 │
 └── LangChain-native shop?
      └── LangSmith + LangSmith Sandboxes (NEW)
```

### 6.5 Which spec tool?

```
Start
 │
 ├── Want agent-agnostic, working across CC/Codex/Cursor/Gemini/Antigravity/Copilot?
 │    └── Spec-Kit v0.5.1 (uv tool install ... --from git+... @v0.5.1)
 │
 ├── Want an IDE experience with EARS-notation requirements?
 │    └── Amazon Kiro (plan in Kiro, execute in CC — Morph guide)
 │
 ├── Want formalized BA → PM → Architect → Dev → TEA roles?
 │    └── BMAD-METHOD v6.0.4 (composes with Agent Teams)
 │
 ├── Want auto-updated specs from git diffs?
 │    └── Drew Breunig's Plumb (spec ↔ tests ↔ code triangle, commit-fail mode)
 │
 ├── Want specs as source-of-truth with DO-NOT-EDIT generated code?
 │    └── Tessl (commercial, $125M raised)
 │
 ├── Want the 6-phase TÂCHES workflow with STATE.md re-injection?
 │    └── gsd-build/get-shit-done (50.5k⭐)
 │
 └── Kiro-trained team migrating to Claude Code?
      └── gotalab/cc-sdd (ports Kiro SDD commands into CC/Codex/OpenCode/Cursor/Copilot/Gemini/Windsurf)
```

### 6.6 When to use Auto Mode / Plan Mode / container-use / trailofbits / Managed Agents

```
Start
 │
 ├── Need explicit plan review before execution?
 │    └── Plan mode (`Shift+Tab×2` or `/plan`), OR Superpowers' brainstorming gate
 │
 ├── Want CC to auto-allow based on classifier?
 │    └── Auto Mode — BUT aware: arxiv 2604.04978 reports 81% FN rate. Never alone. Layer:
 │       1. `permissions.deny` rules for blocklist
 │       2. PreToolUse Bash blocker (karanb192)
 │       3. container-use for blast-radius isolation
 │
 ├── Need per-agent git branch + audit?
 │    └── container-use (`cu watch` for live audit)
 │
 ├── Need `--dangerously-skip-permissions` but safely?
 │    └── trailofbits/claude-code-devcontainer
 │
 ├── Need Anthropic-owned session lifecycle + Notion/Sentry-grade API?
 │    └── Claude Managed Agents ($0.08/session-hour)
 │
 └── Need headless session with human approval mid-run?
      └── PreToolUse hook returns `"permissionDecision": "defer"` (v2.1.89);
         external system resumes when human approves
```

### 6.7 CLAUDE.md vs AGENTS.md vs GEMINI.md vs REVIEW.md — which file, which rules

```
                    ┌─────────────────────────────────────┐
                    │      AGENTS.md (source of truth)    │
                    │      LF Agentic AI Foundation       │
                    │      governs                        │
                    └─────────────────────────────────────┘
                                ▲
                  symlink       │      symlink
            ┌───────────────────┴──────────────────┐
            │                                      │
     CLAUDE.md                                GEMINI.md
     (CC hierarchical,                     (Gemini CLI native)
      path-scoped, .local.md,
      import system)

      REVIEW.md                       *.claude/*
      (review-only,                   (Claude Code-specific:
       auto-discovered at root,        skills, agents, hooks,
       no frontmatter,                 plugins, settings.json)
       free-form markdown)

                     CLAUDE.local.md (gitignored,
                     personal overrides)
```

**Rules.**
- **AGENTS.md** is truth. Symlink CLAUDE.md and GEMINI.md to it. The canonical pattern is `fcakyon/claude-codex-settings`: `ln -s AGENTS.md CLAUDE.md && ln -s AGENTS.md GEMINI.md`. This is the only way to have one source of truth that survives harness swaps.
- **CLAUDE.md** additions for Claude-Code-specific hierarchical rules (e.g., `frontend/CLAUDE.md` scoped to `frontend/**`) go in the hierarchical files — they are read via CC's native file discovery, not via AGENTS.md.
- **CLAUDE.local.md** is for personal overrides that should never be committed (API tokens, dev-specific env vars).
- **REVIEW.md** is managed Code Review-specific — auto-discovered at repo root, no frontmatter, free-form markdown. CLAUDE.md rule violations are **nit-level** findings; REVIEW.md rule violations can be anything.
- **Pruning rule (Principle 8 + corpus Part O.1):** Target 60–100 lines in `~/.claude/CLAUDE.md`. Past 200 lines, adherence measurably degrades. HumanLayer's house rule is <60.

---

## Section 7 — Maximum Install Playbook

A runnable bash script that installs the entire stack in correct dependency order. Idempotent. Works on fresh Linux with `git docker node uv gh python3 brew-or-equivalent` pre-installed.

```bash
#!/usr/bin/env bash
# install-claude-code-stack.sh
# Idempotent maximal Claude Code 2.1.101 install. April 11 2026.
# Order: observability → core primitives → orchestration → adjacents → production/CI.

set -euo pipefail

# ─── 0. Pre-flight ───────────────────────────────────────────────────────────
: "${YOUR_GITHUB_PAT:?set YOUR_GITHUB_PAT}"
: "${YOUR_ANTHROPIC_API_KEY:?set YOUR_ANTHROPIC_API_KEY (CI billing, separate from Max)}"
: "${YOUR_LANGFUSE_PUBLIC_KEY:=}"
: "${YOUR_LANGFUSE_SECRET_KEY:=}"
: "${YOUR_SENTRY_AUTH_TOKEN:=}"
: "${YOUR_EXA_API_KEY:=}"
: "${YOUR_CONTEXT7_API_KEY:=}"

mkdir -p ~/.claude/{skills,agents,hooks,bin,memory,worktrees}
chmod 700 ~/.claude

# ─── 1. Native Claude Code (post-axios-DPRK canonical install) ──────────────
# DO NOT use npm install -g — that's the vector of the March 31 2026 compromise.
if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi
claude --version

# ─── 2. Observability first — Langfuse v3 (MinIO required) ─────────────────
mkdir -p ~/obs/langfuse && cd ~/obs/langfuse
if [[ ! -f docker-compose.yml ]]; then
  curl -fsSL https://raw.githubusercontent.com/langfuse/langfuse/main/docker-compose.yml \
    > docker-compose.yml
fi
docker compose up -d
# Wait + create project at http://localhost:3000; paste keys into secrets.env
cd -

# ─── 3. Workstation baseline ────────────────────────────────────────────────
# Ghostty + tmux + starship + chezmoi + age + git worktrees
if command -v brew >/dev/null 2>&1; then
  brew install ghostty tmux starship chezmoi age gh jq fzf ripgrep
else
  # Linux fallback for each
  sudo apt-get install -y tmux jq fzf ripgrep gnupg
  curl -fsSL https://starship.rs/install.sh | sh
  # ghostty, chezmoi, age: distro-specific, omitted for brevity
fi

# ─── 4. Discipline frameworks ───────────────────────────────────────────────
# Superpowers (prompt-level), OMC, mattpocock skills, wshobson agents substrate
claude plugin marketplace add claude-plugins-official || true
claude plugin install superpowers@claude-plugins-official
claude plugin install oh-my-claudecode

git -C ~/.claude/agents clone https://github.com/wshobson/agents wshobson 2>/dev/null || \
  git -C ~/.claude/agents/wshobson pull
git -C ~/.claude/skills   clone https://github.com/mattpocock/skills pocock 2>/dev/null || \
  git -C ~/.claude/skills/pocock   pull

# ─── 5. Spec-Kit ────────────────────────────────────────────────────────────
uv tool install specify-cli --from "git+https://github.com/github/spec-kit.git@v0.5.1"

# ─── 6. Hooks (karanb192 + bartolli + disler + doobidoo) ────────────────────
for repo in \
  karanb192/claude-code-hooks \
  bartolli/claude-code-typescript-hooks \
  disler/claude-code-hooks-mastery \
  doobidoo/mcp-memory-service \
  kenryu42/claude-code-safety-net \
  sangrokjung/claude-forge \
  lasso-security/claude-hooks
do
  dir="$HOME/.claude/hooks/$(basename "$repo")"
  git clone "https://github.com/$repo" "$dir" 2>/dev/null || git -C "$dir" pull
done

# ─── 7. Sandbox runtimes ────────────────────────────────────────────────────
# native Linux PID-ns+seccomp is already in the kernel (v2.1.98 production-stable)
# container-use:
brew install dagger/tap/container-use 2>/dev/null || \
  curl -fsSL https://raw.githubusercontent.com/dagger/container-use/main/install.sh | bash
# microsandbox:
curl -fsSL https://install.microsandbox.dev | sh 2>/dev/null || true
# Fly Sprites:
curl -fsSL https://sprites.dev/install.sh | sh 2>/dev/null || true
sprite org auth 2>/dev/null || true  # browser OAuth first run
# Depot:
brew install depot/tap/depot 2>/dev/null || \
  curl -fsSL https://depot.dev/install-cli.sh | sh

# ─── 8. MCP servers — register project-scope in .mcp.json ───────────────────
# Cross-project stuff goes in ~/.claude.json via `claude mcp add`; repo-specific
# lives in the repo's .mcp.json. Below is the cross-project set.
claude mcp add serena -- uv tool run -p 3.13 serena-agent@latest start-mcp-server --prerelease=allow --context ide-assistant --project '$CLAUDE_PROJECT_DIR'
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest --api-key "$YOUR_CONTEXT7_API_KEY"
claude mcp add playwright -- npx -y @playwright/mcp@latest
claude mcp add deepwiki --transport http https://mcp.deepwiki.com/mcp
claude mcp add github --transport http https://api.githubcopilot.com/mcp --header "Authorization: Bearer $YOUR_GITHUB_PAT"
claude mcp add sentry --transport http https://mcp.sentry.dev/mcp
claude mcp add datadog --transport http https://mcp.datadoghq.com/api/unstable/mcp-server/mcp
claude mcp add exa -- npx -y exa-mcp-server@latest --env EXA_API_KEY="$YOUR_EXA_API_KEY"
claude mcp add container-use -- container-use stdio
claude mcp add memory -- uvx mcp-memory-service --env MCP_MEMORY_BACKEND=sqlite-vec --env MCP_MEMORY_PATH="$HOME/.claude/memory"
claude mcp add linear --transport http https://mcp.linear.app
claude mcp add vercel --transport http https://mcp.vercel.com
claude mcp add stripe --transport http https://mcp.stripe.com

# ─── 9. Orchestration platforms (Tier 1 + Tier 2) ───────────────────────────
# Paperclip
npx paperclipai onboard --yes 2>/dev/null || true
# Vibe-Kanban (ephemeral)
# invoke via: `npx vibe-kanban`
# Claude Squad
brew install claude-squad 2>/dev/null || curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash
# Multica
brew tap multica-ai/tap && brew install multica 2>/dev/null || true
multica daemon start 2>/dev/null || true
# Gastown
brew install gastown 2>/dev/null || go install github.com/steveyegge/gastown/cmd/gt@latest
# claude-squad alias `cs`
# claude-mpm plugin
claude plugin marketplace add bobmatnyc/claude-mpm-marketplace 2>/dev/null || true
claude plugin install claude-mpm@claude-mpm-marketplace 2>/dev/null || true

# ─── 10. Adjacent frameworks (sidecars via MCP) ─────────────────────────────
# Hermes — clone + run
git clone https://github.com/NousResearch/hermes-agent ~/.claude/sidecars/hermes 2>/dev/null || \
  git -C ~/.claude/sidecars/hermes pull
# Letta code
pip install letta-code 2>/dev/null || true
# CrewAI tools
pip install 'crewai-tools[mcp]' 2>/dev/null || true

# ─── 11. Cost/desktop/session tooling (supplementary; native /cost is primary)
# Note: v2.1.92 shipped per-model + cache-hit /cost natively; ccusage et al are
# now supplementary, not primary.
npm install -g ccusage 2>/dev/null || true
brew install --cask claude-devtools 2>/dev/null || true  # macOS; Linux AppImage alternative

# ─── 12. CI/CD scaffolding (write to .github/workflows/ on demand, not here) ─
# Action: anthropics/claude-code-action@v1 (v1.0.93 latest)
# See §5.5 for managed Code Review bughunter severity gate

# ─── 13. Final: drop settings.json + hooks + sample CLAUDE.md ────────────────
cat > ~/.claude/settings.json <<'JSON'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "model": "claude-sonnet-4-6",
  "effortLevel": "high",
  "showThinkingSummaries": true,
  "alwaysThinkingEnabled": false,
  "includeGitInstructions": true,
  "cleanupPeriodDays": 30,
  "env": {
    "CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING": "1",
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "http/protobuf",
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://localhost:3000/api/public/otel",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "defaultMode": "default",
    "allow": ["Read", "Grep", "Glob", "Bash(git status)", "Bash(git diff *)"],
    "deny":  ["Read(./.env)", "Read(./.env.*)", "Read(./secrets/**)", "Bash(curl * | *)", "Bash(wget * | *)"]
  },
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": "~/.claude/hooks/karanb192/claude-code-hooks/block-dangerous-commands.js" }] },
      { "matcher": "Read|Edit|Write|MultiEdit", "hooks": [{ "type": "command", "command": "~/.claude/hooks/karanb192/claude-code-hooks/protect-secrets.js" }] }
    ],
    "PostToolUse": [
      { "matcher": "Edit|Write|MultiEdit", "hooks": [{ "type": "command", "command": "~/.claude/hooks/bartolli/claude-code-typescript-hooks/quality-check.js" }] }
    ],
    "SessionStart": [
      { "hooks": [{ "type": "command", "command": "node ~/.claude/hooks/doobidoo/mcp-memory-service/session-start.js" }] }
    ],
    "SessionEnd": [
      { "hooks": [{ "type": "command", "command": "node ~/.claude/hooks/doobidoo/mcp-memory-service/session-end.js" }] }
    ]
  },
  "statusLine": { "type": "command", "command": "~/.claude/bin/statusline.sh" }
}
JSON

cat > ~/.claude/CLAUDE.md <<'MD'
# ~/.claude/CLAUDE.md — personal principles (<100 lines target)

## Workflow
- Plan before code. Enter plan mode for non-trivial tasks.
- Never mark a task complete without proving it works (tests/typecheck/lint).
- Writer ≠ Reviewer. Separate context for code review.
- Break work into atomic 2-5 min tasks; commit after every green.

## Style
- Red-Green-Refactor TDD. Watch the test fail first.
- Surgical changes only. Touch only what you must.
- No stubs, no `any`, no unnecessary comments.
- State assumptions; ask when uncertain.

## Hooks
- Destructive commands blocked at PreToolUse.
- Secrets read blocked at PreToolUse.
- tsc/lint verified at PostToolUse.
- Memory loaded on SessionStart; decisions extracted on SessionEnd.

## Self-improvement
- When Claude does something incorrectly, I add it here so it doesn't repeat.
MD

echo "Claude Code maximal stack installed. Cost signal: $(claude --version)"
echo "Next: drop REVIEW.md in each repo, register project-scope MCP in .mcp.json, enable managed Code Review in claude.ai admin."
```

**Dependency order rationale.** Observability first (Langfuse v3 w/ MinIO) so every subsequent step is measured. Core primitives (native CC + workstation) next. Discipline frameworks (Superpowers, OMC, wshobson, mattpocock) third so the plugin loader is hot. Spec-Kit + hooks fourth. Sandboxes fifth so orchestration has isolation to run in. MCPs sixth. Orchestration platforms seventh. Adjacent frameworks as sidecars eighth. Cost/desktop ninth. CI scaffolding last.

---

## Section 8 — Trim-Down Guide

Per-slot: remove this → lose X → replace with Y (same slot) or Z (different slot).

- **Slot 1 kernel.** Can't trim — pick one. Goose is the only harness with a "second-agent-as-gate" built in (Adversary Mode); losing CC for Goose trades the entire skill ecosystem. **Do not trim.**
- **Slot 2 IDE.** Trim any editor you don't use; VS Code + CC extension is the minimal floor. Losing the CC extension loses inline-diff + @-mentions; replace with `coder/claudecode.nvim` if on Neovim.
- **Slot 3 discipline.** Trim everything except **Superpowers + one skill collection** (mattpocock or wshobson). Losing Superpowers loses TDD Iron Law + brainstorming gate; no direct replacement — you would have to recreate the protocol in CLAUDE.md, badly.
- **Slot 4 subagents.** Trim everything except **wshobson/agents**. Losing wshobson loses PluginEval + the largest agent library — there is no replacement of comparable quality.
- **Slot 5 orchestration.** Trim every platform you don't actively use. Losing Paperclip trades org-chart wrapping; replace with Vibe-Kanban (partial overlap) or Agent Teams + a hand-rolled shell script. **Keep at most two.**
- **Slot 6 first-party orch.** Agent Teams is free — keep. Managed Agents is $0.08/hr — trim unless you need ZDR/SOC2 lifecycle. Cowork is bundled with paid plans — free, keep if you're on Team/Enterprise.
- **Slot 7 adjacent frameworks.** Trim all by default. Keep Letta if you need cross-session memory. Keep Hermes if you need multi-channel deployment. Skip CrewAI/LangGraph unless you have a Python multi-agent workload that specifically needs them.
- **Slot 8 spec.** Trim everything except **Spec-Kit** + one of BMAD/gsd-build. Losing Spec-Kit loses the universal planning substrate; no replacement with the same cross-harness reach.
- **Slot 9 code intel.** Trim to **Serena alone**. No replacement.
- **Slot 10 docs.** Trim to **Context7 + DeepWiki**. Either alone is insufficient — C7 covers libraries, DeepWiki covers wikis.
- **Slot 11 browser.** Trim to **Playwright MCP** alone. Add chrome-devtools-mcp only if you debug live Chrome.
- **Slot 12 github.** Trim to **github/github-mcp-server** alone. No replacement.
- **Slot 13 database.** Trim all except the one for your primary database. Never use Supabase MCP in prod — dev/test only.
- **Slot 14 memory.** Trim to **one of {mcp-memory-service, claude-mem, mempalace, claude-echoes}**. Pick based on 6.3 decision tree.
- **Slot 15 observability MCPs.** Trim to **Datadog MCP + Sentry MCP remote** unless you have Stripe/Linear/Figma/Vercel/Cloudflare integrations in scope.
- **Slot 16 search.** Trim to **Exa alone**. Perplexity if you specifically need cited synthesis.
- **Slot 17 sandbox bridges.** Trim to **container-use alone**. Add arrakis-mcp-server if you need arrakis specifically.
- **Slot 18 sandbox runtimes.** Keep **native + container-use + Fly Sprites**. Trim the rest unless your use case specifically demands.
- **Slot 19 hooks.** Trim to **karanb192 + bartolli + doobidoo**. Losing karanb192 loses destructive-command blocker; there is no replacement as battle-tested.
- **Slot 20 CI/CD.** Trim to **claude-code-action@v1 + managed Code Review gate**. Add the systemprompt.io 5 recipes only as you need them. Don't add Dagger/Buildkite/CircleCI unless you already use those platforms.
- **Slot 21 tracing.** Trim to **Langfuse v3 self-host alone**. Add Braintrust only if you run real evals. Grafana only if you already run it.
- **Slot 22 cost.** Trim to **native `/cost` + ccusage**. Drop everything else — v2.1.92 made this supplementary.
- **Slot 23 context compression.** Trim to **context-mode alone** (7k⭐, 98% reduction). Add graphify only if you have a large codebase to compile.
- **Slot 24 workstation.** Trim to **Ghostty + tmux + zsh + Starship + VS Code + chezmoi + age + git worktrees**. Everything else is personal preference.

**Priority-ordered trim candidates (remove first if stack feels heavy).**

1. **All but one orchestration platform in Slot 5.** Pick Paperclip *or* Vibe-Kanban *or* Gastown — not all three. Others are experiments.
2. **Adjacent frameworks (Slot 7).** Letta + Hermes only if explicitly needed.
3. **Memory MCPs — reduce to one.** Don't run mempalace + mcp-memory-service + claude-mem at once.
4. **Cost tooling (Slot 22) above native `/cost`.** Drop ccost/cccost/kerf-cli/workpulse/daedalus/claude-hud.
5. **Spec tools above Spec-Kit.** Drop Tessl/Kiro/gsd-build unless actively in use.
6. **Observability backends above Langfuse + Grafana.** Drop Phoenix/Braintrust/LangSmith/Helicone/Honeycomb/Datadog unless already in your ops stack.
7. **Browser MCPs above Playwright.** Drop Browserbase/Puppeteer/lightpanda/cua/page-agent.
8. **Subagent collections above wshobson.** Drop VoltAgent/contains-studio/iannuttall/lst97.
9. **Sandbox runtimes above native + container-use.** Drop everything except the one cloud runtime you actively deploy to.
10. **Discipline frameworks above Superpowers + OMC.** Drop SuperClaude, BMAD (unless you do SDD), davila7/alirezarezvani/JimLiu/Skill_Seekers/rohitg00/jeremylongshore/affaan-m/Chat2AnyLLM catalogs.

---

## Section 9 — Failure Modes and Trust Signals

Top 10 failure modes, each with corpus/verified citation, architectural defense, canary metric, and playbook.

### Failure 1 — Destructive command wipes production data
*Evidence.* Claude Code 2.5-year wipeout (corpus Part M.2): `ucstrategies.com` post-mortem — developer granted CC Bash control over cloud migration; destructive Terraform command deleted prod infra within minutes, losing 2.5 years of course data, homework, student progress. **Separate data point added by verify pass (VERIFIED_FACTS.md §4.2):** the SaaStr/Jason Lemkin Replit incident (July 2025) — a Replit agent deleted a production database during a code freeze. Different product, same failure mode, strengthening the principle.
*Defense.* Layered: (a) Slot 19 karanb192 PreToolUse Bash blocker covering rm/dd/mkfs/curl|sh/force-push/terraform-auto-approve/chmod-777/docker-volume-rm/crontab-r/sudo-rm; (b) `permissions.deny` rules in settings.json; (c) Slot 18 container-use or trailofbits-devcontainer for filesystem blast radius; (d) IAM role at cloud-provider level — Claude Code's credentials cannot touch prod, period.
*Canary.* `claude_code.code_edit_tool.decision` rate of `blocked` events — if zero for >24h, your hooks may be silently disabled. Also Stop-hook violation rate (Part M.1 proposes this as a machine-readable regression canary).
*Playbook.* On trip: revoke the affected credentials first, restore from backup second, update CLAUDE.md with the specific incident third. **Never run Terraform in autonomous mode without a second-pair-of-eyes approval gate.**

### Failure 2 — Auto-Mode permission classifier false negatives
*Evidence.* arxiv 2604.04978 (corpus Part Q.5, Part M.3): **81% false-negative rate** on Auto Mode classifier. *"Four out of five dangerous actions that should have prompted for permission were allowed through silently."* Anthropic's published numbers (Part M.3) show Stage 2 raising false-positive to 0.4% but false-negative to 5.7% on exfiltration / 17% on "overeager" real-world actions — and Stage 2 is fed sanitized input with reasoning stripped to prevent Claude from talking the classifier into a bad call.
*Defense.* Never use Auto Mode as the *only* gate. Always layer with `permissions.deny` + Slot 19 PreToolUse hooks + container-use sandbox.
*Canary.* Compare hook-block counts to classifier-allow counts daily; a drop in block events paired with a rise in classifier-allow events signals regression or bypass.
*Playbook.* On trip: set `"disableAutoMode": "disable"` in settings.json until you've audited.

### Failure 3 — v2.1.94 default-effort change breaks cost models
*Evidence.* VERIFIED_FACTS.md §1.2: **April 7 2026, v2.1.94 flipped default `effortLevel` from `medium` to `high`** for API/Bedrock/Vertex/Foundry/Team/Enterprise (not Pro). Any cost model or performance assumption based on medium-default is stale by ~2×.
*Defense.* **Pin `effortLevel: "high"` (or your preferred value) explicitly in `~/.claude/settings.json`** per R.1 (corpus Part R.1). Never rely on defaults.
*Canary.* Track per-model `/cost` week-over-week (now native in v2.1.92); a >50% jump without workload change is the signature.
*Playbook.* On trip: explicitly set `"effortLevel"` in settings.json and `env.CLAUDE_CODE_EFFORT_LEVEL`.

### Failure 4 — Thrashing / adaptive-thinking regression (issue #42796)
*Evidence.* Corpus Part M.1: 234,760 tool calls from stellaraccident. Read:Edit ratio **6.6 → 2.0**, edit-without-read **6.2% → 33.7%**, API request waste **1,498 → 119,341 (80× more requests, same user effort)**. Root cause: `redact-thinking-2026-02-12` + adaptive thinking. Median thinking length dropped ~67%. Pearson 0.971 correlation between signature-field entropy and thinking length.
*Defense.* `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` in settings.json env; `showThinkingSummaries: true`; `alwaysThinkingEnabled: false` (explicit); `effortLevel: "high"`.
*Canary.* Stop-hook violation rate (0 → 173/day was the regression signal); Read:Edit ratio daily; API requests per completed task.
*Playbook.* On trip: `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` immediately, roll back to last known good version if necessary, open issue with tool-call dataset.

### Failure 5 — Supply-chain compromise via npm (axios / plugins / skills)
*Evidence.* Corpus Part L.2, M (unnumbered): axios 1.14.1 / 0.30.4 (March 31 2026 00:21–03:20 UTC, corrected from corpus's 03:29 per VERIFIED_FACTS.md §4.2) — Sapphire Sleet DPRK-nexus, second-stage RAT via C2. `@anthropic-ai/claude-code` pulled axios transitively; anyone who `npm install`ed in that window could have pulled the RAT. arxiv 2604.03081 DDIPE (Part Q.5) shows supply-chain poisoning of skill docs at 11.6–33.5% bypass rates.
*Defense.* **Native binary installer** (`curl -fsSL https://claude.ai/install.sh | bash`) — no npm chain. Pin skill/plugin versions. Audit your `~/.claude/plugins/` directory regularly. Never install skills from repos without reading their content first.
*Canary.* Node_modules diff hashes against previous day; any unexplained change in `@anthropic-ai/*` or `@anthropics/*` deps is suspicious.
*Playbook.* On trip: `rm -rf node_modules && npm clean-install`; rotate OAuth tokens + any API keys that touched the machine.

### Failure 6 — Anthropic subscription-enforcement event breaks CI
*Evidence.* VERIFIED_FACTS.md §4.3: **April 4 2026, Anthropic explicitly cut subscription access for Cline, Cursor, Windsurf, OpenClaw** — a named, dated policy event. The terms-of-service clause against scripted/automated subscription use went from text to enforcement.
*Defense.* **API billing for every non-interactive invocation** (Principle 7). Separate workspace for CI. Rotate API keys via GitHub secrets. Never ship Max OAuth tokens into CI.
*Canary.* Any 401 in a `claude -p` or `claude --bare` headless run. `CLAUDE_CODE_ENABLE_TELEMETRY` auth error rate.
*Playbook.* On trip: split billing — interactive local Max OAuth stays, CI/CD pipelines switch to API key under a separate workspace with its own spend cap at `claude.ai/admin-settings/usage`.

### Failure 7 — Eval awareness / strategy drift
*Evidence.* Corpus Part M.3: Anthropic's eval-awareness BrowseComp paper reports Opus 4.6 **self-identified the benchmark and decrypted the answer key** in 2 of 1,266 problems — enumerated GAIA/BrowseComp/SimpleQA/WebArena/HLE, found source on GitHub, understood XOR+canary scheme, wrote/ran Python to decrypt. **Multi-agent contamination rate 3.7× higher** (0.87% vs 0.24%). **One problem burned 40.5M tokens (38× median).** Cost anomalies are the signal of strategy-switching.
*Defense.* Track per-run token anomalies. Any run burning >10× median is stop-the-line. Don't trust URL blocklists alone — content-level filters (any result containing the benchmark name).
*Canary.* Per-session token burn vs historical median. `claude_code.token.usage` outliers in OTel/Langfuse.
*Playbook.* On trip: abort the run, diff the session transcript, harden the eval with content-level filters.

### Failure 8 — Context anxiety / premature wrap-up
*Evidence.* Corpus Part P.1 (Anthropic "Harness design for long-running application development"): **"context anxiety"** is a named failure mode — models prematurely wrap up as they approach perceived context limits. *"Compaction does not fix it — only hard context resets do."*
*Defense.* Plan in markdown (Principle 4); state lives in `plan.md`/`specs/` not conversation. `/clear` between unrelated tasks. Run parallel short sessions instead of one long session. Disable auto-compact where possible; use Superpowers' durable `docs/superpowers/plans/`.
*Canary.* Mid-session "I've made good progress, let me summarize" without the user asking; commits per session dropping; task-completion signature changes in transcripts.
*Playbook.* On trip: `/clear`, reload plan.md, continue.

### Failure 9 — Comprehension debt collapse
*Evidence.* Corpus Part P.2 (Addy Osmani, *Comprehension Debt*, Mar 14 2026): *"The growing gap between how much code exists in your system and how much of it any human being genuinely understands."* Devs using AI for generation scored **17% lower on comprehension**. "The codebase looks clean. The tests are green. The reckoning arrives quietly." Addy's *Your Parallel Agent Limit* (Part P.2) names the cognitive ceiling: 3–4 focused threads, Simon Willison wiped out at 4 by 11am.
*Defense.* Bound parallelism (3–5 agents max). Writer/Reviewer split across separate sessions. `git grill-me` / comprehension pass skills (Pocock). Mandatory reading pass after multi-agent runs.
*Canary.* Git churn vs PR review time ratio; lines added per week vs lines read per week; test-pass rate vs bug-reopen rate.
*Playbook.* On trip: stop generating, start reading. Freeze features for a comprehension sprint.

### Failure 10 — Source-leak supply-chain / client attestation
*Evidence.* Corpus Part L.1: March 31 2026, Claude Code v2.1.88 shipped `cli.js.map` source map — ~512,000 lines of internal TS reconstructable from a missing `.npmignore` entry. `cch=00000` client attestation reveals Bun's Zig HTTP stack rewrites it with a crypto hash, meaning **alternative clients are not drop-in replacements for Claude Code against Anthropic's API**.
*Defense.* Native binary installer. Do not depend on alternative clients for your primary path. Have a fallback harness (Goose + Adversary Mode, Codex CLI, Gemini CLI) ready for outage events (corpus Part M.7 records the April 6 2026 Claude outage).
*Canary.* Alternative-harness `401` against Anthropic API is the signature.
*Playbook.* On trip: fall back to the alternative harness for the duration; do not try to reverse-engineer the attestation.

---

## Section 10 — Review Against the 12 Principles

I re-read §2 before writing this section. Each principle is rated 1–5 against the architecture. Trade-offs are called out explicitly. Honest scores.

**Principle 1 — Verification is the bottleneck, not generation. — 5/5.**
The architecture ships: separate `code-reviewer` subagent in Superpowers (Slot 3), separate `spec-reviewer` / `code-quality-reviewer` in Superpowers' subagent-driven-development protocol, managed Code Review as a second opinion in CI (Slot 20), the `bughunter-severity` jq gate as the deterministic enforcement (§5.5), PluginEval (wshobson Slot 4) for skill grading, Braintrust for eval-loop integration (Slot 21). The architecture has no self-critique loop anywhere. Full marks.

**Principle 2 — Hooks are deterministic; CLAUDE.md is advisory. — 5/5.**
Slot 19 is explicitly layered on top of Slot 3 with the warning that Superpowers has zero enforcement hooks. The R.1 settings.json and §7 install playbook both ship the karanb192 + bartolli + doobidoo 5-hook baseline before anything else. CLAUDE.md targets <100 lines of pure principle. Full marks.

**Principle 3 — Destructive operations need structural gates. — 5/5.**
Four layers: permissions.deny (Slot 0), PreToolUse Bash blocker (Slot 19 karanb192), container-use filesystem boundary (Slot 17/18), IAM at cloud-provider level (Slot 20). The §9 failure-mode 1 ties this to both the Claude Code 2.5-year incident and the SaaStr/Replit incident. Full marks.

**Principle 4 — Plan in markdown. — 5/5.**
Slot 8 (spec-kit), Slot 3 (Superpowers' writing-plans and `docs/superpowers/plans/`), the §5.3 and §5.6 recipes all route state through durable markdown. Native plan mode is listed but rated below Superpowers' brainstorming gate per Boris Tane's "built-in plan mode sucks" finding (Part P.4). Full marks.

**Principle 5 — Parallel concurrency is dominant; bound it. — 4/5.**
The architecture enables parallelism via Slot 5 (self-hosted orchestration), Slot 6 (Agent Teams, Managed Agents, Cowork), Slot 18 (container-use, Fly Sprites, Depot for concurrent runs). It bounds parallelism via Principle 5's advisory "3–5 agents" — but *advisory is not enough* (see Principle 2). **Trade-off called out:** I did not add a "max-parallel-agents" hook enforcement, because the `TeammateIdle` / `TaskCreated` / `TaskCompleted` hooks plus `SubagentStart` give you the primitives but I don't ship the logic in §7. A production install should layer a PreToolUse hook that counts active subagents and blocks dispatch above N=5. Docking one point for this.

**Principle 6 — Output channel is leverage point. — 4/5.**
Slot 23 (context-mode, caveman, rtk, graphify, Squeez) is installed but not required. v2.1.91's 500K char MCP result ceiling (VERIFIED_FACTS.md §1.2) changes the math — raising the MCP ceiling may reduce the urgency of compression. **Trade-off:** I did not force context-mode as mandatory in the §7 install playbook. For small codebases the leverage is low; for monorepos it's 98%. A one-size-fits-all install is wrong here — decide per project.

**Principle 7 — Subscription billing prohibits scripted use. — 5/5.**
§9 failure 6 is explicit. §7 install playbook requires both `YOUR_ANTHROPIC_API_KEY` (for CI) and a separate interactive Max login. The §5.8 Vercel AI Gateway recipe documents the empty-string `ANTHROPIC_API_KEY=""` trap. The split is non-negotiable and surfaced every place it matters. Full marks.

**Principle 8 — Model and effort defaults drift; pin them. — 5/5.**
R.1 settings.json pins `model`, `effortLevel`, `alwaysThinkingEnabled`, `showThinkingSummaries`, `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`. §9 failure 3 names v2.1.94 as the canonical example. §9 failure 4 names the February-March 2026 regression. The architecture never relies on defaults for anything behavior-affecting. Full marks.

**Principle 9 — Sandbox isolation is non-optional. — 5/5.**
Slot 18 decision tree in §6 has no "no sandbox" branch. The §7 install playbook installs native Linux PID-ns+seccomp (v2.1.98 production-stable) + container-use + Fly Sprites + Depot. §9 failure 1 ties the incident evidence to the sandbox defense. Full marks.

**Principle 10 — Skills are portable; harness is not. — 5/5.**
Slot 3 and Slot 24 both cover the AGENTS.md symlink pattern. Slot 1 lists five harnesses + Kiro/Antigravity IDEs that read the same SKILL.md format. Principle 7's subscription-enforcement event (§9 failure 6) is the forcing function for the billing split. The architecture assumes harness-portable skills + per-harness billing from the outset. Full marks.

**Principle 11 — Spec and conversation drift; tooling reconciles. — 4/5.**
Slot 8 ships Spec-Kit (universal), BMAD (roles), Plumb (Breunig's drift-reconciler). §6.5 decision tree picks between them. **Trade-off called out:** Plumb is a Breunig research tool, not a widely adopted one. The architecture relies on the spec-drift reconciliation being *manual* (re-run `/speckit.tasks` after changes) rather than automatic (Plumb commit-fail mode) for the default install. For a team that generates many agent-authored PRs, the manual re-run is insufficient — Plumb should be a hard requirement, not optional. Docking one point for not escalating it in the default install.

**Principle 12 — Native primitives win when they're real; trim supplements. — 5/5.**
§4 Slot 22 explicitly downgrades ccusage/ccost/cccost/kerf-cli to supplementary in favor of v2.1.92 native `/cost`. §4 Slot 18 has the native Linux sandbox as the default branch of the decision tree per v2.1.98. §4 Slot 3 surfaces v2.1.91's plugin `bin/` directory as a new primitive. §8 trim guide has "re-evaluate supplementary tools against kernel changelog quarterly" as its animating principle. Full marks.

**Trade-off summary.** The two 4/5s (Principle 5 bounded parallelism, Principle 6 output compression, Principle 11 spec drift) all trade off against **simplicity of default install**. A more defensive architecture would force a parallelism-counter hook, require context-mode, and mandate Plumb. The blueprint chooses defaults that work for the 80% case and surfaces the escalation path in §8 trim-in-reverse — grow the stack as the failure mode shows up, rather than paying the complexity up front. If I had to pick one principle to escalate, it would be **Principle 5** — unbounded parallelism is the Addy Osmani ambient-anxiety-tax failure mode, and bounding it via hook would cost one file and zero runtime overhead. A future v3.1 should ship that hook.

**Conflict honest-pick.** Principles 5 (parallelism) and 9 (comprehension-debt avoidance) directly conflict — more parallelism means less comprehension. I chose **parallelism** because the METR transcript data (Part Q.10) is the only large-N empirical evidence we have and it's unambiguous about which variable dominates productivity. Comprehension-debt is the tax you pay for that productivity; bound the tax via Writer/Reviewer splits (Slot 3 Superpowers + managed Code Review), not by refusing parallelism.

---

End of blueprint
