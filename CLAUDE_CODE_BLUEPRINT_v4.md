# CLAUDE CODE BLUEPRINT v4.0 — 30 Slots, 15 Principles, 16 Failure Modes

*A system architecture for the solo operator producing enterprise-grade output. Compiled April 11 2026 against `RESEARCH_CORPUS.md` (Parts A–S, ~260 primary sources), `VERIFIED_FACTS.md` (Apr 11 slot-scoped verify pass, 4 agents) and `NEWER_FACTS.md` (Apr 11 category-open scout pass, 5 agents). Vertical-agnostic, stack-agnostic, tier-agnostic. Maximal by construction; the reader trims downstream. Primary picks are bolded on evidence (verified schemas, battle-testing, composability, license clarity, measured outcomes). No filtering by stack, OS, deployment target, team size, or use case.*

> **Framing override.** v2.0's "trust, not capability" anti-maximalism thesis is rejected. v3 inverted it. v4 keeps the inversion: maximal inclusion is the architecture, trim is a downstream operation. The user said verbatim: *"MAXIMAL, I will trim"* and *"our thing should work with anything."* Both tiers (solo and enterprise) appear side-by-side.

---

## §0 — Why this supersedes v3

v3 was written from the 24-slot roster in `ARCHITECTURE_PROMPT.md`. The Phase 1 verification agents that produced `VERIFIED_FACTS.md` were **slot-scoped** — they could only confirm or correct items inside slots v3 already defined. The user pushed back: *"all these choices have better alternatives and there are new stuff that u never used."*

A 5-agent **category-open** scout pass (`scout-hn-2weeks`, `scout-github-2weeks`, `scout-practitioners-14d`, `scout-arxiv-7d`, `scout-categories-6`) surfaced what slot-scoped verification could not:

- **6 new slots** — LLM gateway (25), cross-vendor AI code review (26), walk-away autonomous agents (27), ambient/defer notification channel (28), MCP security + federation (29), durable execution for agent loops (30)
- **3 new principles** — design-decision deferral as the dominant failure mode (13), skill-refinement over accumulation (14), Winchester + Catacombs supply-chain risk (15)
- **6 new failure modes** — formatting-trap in structured self-reflection (11), skill-library collapse in realistic retrieval (12), greenfield-CLI generation ceiling (13), LiteLLM PyPI supply-chain compromise (14), Mythos agent-escape event (15), ClawBench eval-validity 10× gap (16)
- **3 modified principles** — Principle 1 (verification bottleneck) gains the formatting-trap anti-pattern; Principle 5 (parallelism) gains Osmani's Comprehension Debt / Ambient Anxiety Tax / Trust Calibration Overhead and the operational rule "start with one fewer agent than feels comfortable"; Principle 9 (sandbox) gains the MCPSHIELD and ShieldNet numeric findings; Principle 12 (native primitives) gains the Advisor Tool + `ant` CLI + `defer` 0.4% FP evidence and the monthly re-evaluation rule
- **One §1 mental-model update** — Advisor Tool (new kernel-level executor/advisor primitive), "Stateless Harness + Durable Event Sourcing" as the canonical Anthropic term of art, and the `ant` CLI as first-party GitOps for Managed Agents
- **~30 new primary-candidate components**, of which the load-bearing ones are: Advisor Tool (server-side executor/advisor, 85% cost reduction), `ant` CLI (GitOps for agent definitions), openclaude (20.6k⭐ post-leak harness fork, April 1), Absurd (`earendil-works/absurd`, Postgres-native durable execution for LLM loops, 5 months in production), LiteLLM as the canonical LLM gateway (43k⭐, with the PyPI 1.82.7–8 security trap), OpenHands (71k⭐ walk-away agent within 2–6% of frontier), CodeRabbit (2M+ repos, cross-vendor reviewer), ntfy.sh (defer-approval surface), agentgateway (Linux Foundation MCP + A2A proxy), mise + just + Turborepo + devenv 2.0 (inner-loop build layer)

**This v4 supersedes v3 because v3's process was structurally incomplete, not just stale.** v3 is preserved on disk for diff. Nothing in v3 was *wrong* — it was *bounded*.

Two visible correction patterns are used throughout:

> **Correction (Apr 11 verify pass):** corpus says X; primary source confirms Y. [source]

> **New in v4 (scout pass Apr 11):** what, why it earns its position [source]

No silent adds, no silent rewrites. The reader sees the evidence as they read.

---

## Section 1 — Mental Model

The architecture is built on the three-primitive framing Anthropic ships in its April 8 2026 engineering post *Scaling Managed Agents: Decoupling the brain from the hands* and its sibling post *Managed Agents Architecture*. Anthropic now names the pattern verbatim: **Stateless Harness + Durable Event Sourcing.** A Claude Code system is exactly three things composed by one contract, plus two kernel-level primitives Anthropic added between April 1 and April 9 2026.

A **session** is an append-only event log. It is the canonical state of the agent. Every prompt, every tool invocation, every tool result, every hook decision, every compaction event, every subagent dispatch becomes an event appended to the log. Time travel through a session is event-stream rewind, not snapshotting. Parallel workers are realized by replaying the same session against different harnesses or sandboxes. The session is the memory, the audit trail, and the unit of replay all at once. The April 8 2026 Anthropic post gives this model its canonical name: the harness is ephemeral, the event log is durable, the sandbox is isolated — **Stateless Harness + Durable Event Sourcing** — and reports p50 time-to-first-token dropped ~60% and p95 >90% after moving to this architecture.

A **harness** is the brain — the loop that calls the model, parses tool calls out of the response, dispatches them, and routes the results back into the next turn. Claude Code is one harness; OpenClaw, Goose, Codex, Aider, Cursor are other harnesses; openclaude (Scout B, see Slot 1) is the post-leak harness fork that expands that list by one. The harness owns prompt construction, context compaction, permission policy, tool fan-out semantics (the leaked `isConcurrencySafe` property from corpus Part L.1 is the brain's flag for which tools can run in parallel), model routing, retry strategy, and the loop's exit conditions. It does not run code directly. It speaks one verb downstream: `execute(name, input) → string`.

A **sandbox** is the hands — the execution substrate where files get edited, processes get spawned, network calls are made. The native Linux subprocess sandbox with PID namespace isolation and seccomp is production-stable as of v2.1.98 per `VERIFIED_FACTS.md §1.2`. `dagger/container-use` is another. E2B, Daytona, Modal, Fly Sprites, Depot, Cloudflare Sandbox SDK, Vercel Sandbox, Freestyle, Coasts, microsandbox, trailofbits devcontainer, Claude Managed Agents — each is another. **The brain↔hands contract collapses to the single line `execute(name, input) → string`** — everything downstream of that arrow can be swapped without the harness knowing.

This is a kernel / userland / init operating system. **Claude Code is a reasoning kernel.** It schedules turns, manages memory, dispatches syscalls (tool calls), handles signals (hooks), enforces permissions, tracks process state (subagents + teammates), and emits telemetry (OTel). Like any kernel it is opinionated about a small number of things and agnostic about almost everything else: it does not care what stack you run, what files exist, what databases live behind your tools, or which model serves the next turn. **Userland is the slot roster — 30 plug-in points in v4** (up from 24 in v3) where you compose discipline frameworks, MCP servers, sandbox runtimes, orchestration platforms, observability backends, LLM gateways, walk-away agents, notification channels, MCP security fabrics, durable-execution substrates, cross-vendor reviewers, and workstation conventions. **Init is the bootstrap layer** — `CLAUDE.md` (the system-prompt addendum), `~/.claude/settings.json` (kernel-level config), `~/.claude/hooks/*` (deterministic gates), `.mcp.json` (userland tool registry), spec-kit phase files (long-horizon goal scaffold), and the new `ant` CLI manifests for Managed Agents definitions. **The observability plane is the syscall-tracing layer** — native OTel (`CLAUDE_CODE_ENABLE_TELEMETRY=1`, corpus Part A.3) flowing through Langfuse / Phoenix / Datadog / Grafana / Honeycomb / SigNoz, with `claude-devtools` (Part K.2) and `claude-replay` as `strace` and `gdb` for sessions, plus the new agents-observe HN-surfaced dashboard (Scout A, 76 pts) and ShieldNet's network-level behavioral monitoring (arxiv 2604.04426, F1=0.995).

Four post-corpus session-level primitives belong in the kernel description as of April 2026 and they change what the harness can do.

> **Correction (Apr 11 verify pass):** v2.1.98 (April 9 2026) shipped the **Monitor tool** as a first-class primitive for streaming events out of `run_in_background` scripts and made the Linux subprocess sandbox (PID namespace + seccomp) production-stable rather than beta. Both belong alongside `run_in_background` in any current mental model. (`VERIFIED_FACTS.md §1.2`)

> **Correction (Apr 11 verify pass):** v2.1.89 (April 1 2026) added `"defer"` as a fourth `permissionDecision` value alongside `allow|deny|ask`. A PreToolUse hook returning `"defer"` pauses the headless session, persists state, and waits for an external system to resume it. Corpus hook documentation predates this and only lists three values. (`VERIFIED_FACTS.md §1.2`)

> **New in v4 (scout pass Apr 11):** The **Advisor Tool** (public beta, April 9 2026, beta header `advisor-tool-2026-03-01`) is a server-side primitive that pairs a fast executor (Haiku or Sonnet) with a high-intelligence advisor (Opus) inside a *single* `/v1/messages` call. Anthropic's measured result: Haiku+Opus scored **41.2% on SWE-bench Multilingual versus 19.7% for Haiku solo at 85% lower cost per task**. This collapses the "route Opus for planning, Sonnet for execution" orchestration pattern — previously the job of Superpowers subagents, BMAD architect+dev roles, OMC modes, or Agent Teams — into a server-side primitive that costs nothing to adopt. The mental-model consequence: the executor/advisor split is now available *below* the harness as an API feature, not just *above* the harness as a discipline framework. (Scout C + Anthropic docs; `platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool`, `claude.com/blog/the-advisor-strategy`)

> **New in v4 (scout pass Apr 11):** The **`ant` CLI** (April 8 2026, `github.com/anthropics/anthropic-cli`, Go, `uvx`-installable) is first-party GitOps for API resources — agents, skills, beta headers, Managed Agent definitions — versioned as YAML with native Claude Code integration. It is kernel-adjacent: not part of the Claude Code binary but part of the Anthropic surface the kernel talks to. Belongs in the init layer diagrammatically, in Slot 20 CI/CD operationally.

`run_in_background` lets the brain dispatch a long-running shell command without blocking the turn loop. The Monitor tool, new in v2.1.98, is the streaming-event read-side: the harness emits each stdout line of a backgrounded process as a session event, so the model can poll status and react mid-run rather than blocking on completion. Together they collapse the old "spawn-a-Bash-and-wait" pattern into a true concurrent-process primitive — the kernel now schedules child processes the way a real OS schedules subprocesses, and the brain only attends to them when something interesting prints.

`"defer"` is the long-horizon-pause primitive. It is what lets a Claude Code session running headless inside CI / Argo / Temporal / Absurd stop at a tool call, hand control to a human approver in Slack or Linear or ntfy.sh (see new Slot 28), and resume from the exact session event when the approver clicks `:thumbsup:`. Combined with `PermissionDenied.retry` (also v2.1.89), the permission pipeline becomes a real workflow primitive rather than an interactive prompt: deny→fix→retry, defer→approve→resume, allow→go. Scout C confirmed Anthropic's auto-mode post reporting **`defer` at 0.4% false-positive rate in production** — safe to recommend as the load-bearing primitive of the headless CI pattern. The "Scaling Managed Agents" three-primitive framing now has a fourth implicit edge: the **interrupt** — and `defer` is the kernel call.

The **Advisor Tool** is the fourth new primitive and the most consequential. Inside one `/v1/messages` call the server-side runtime dispatches an `advisor` tool that consults Opus from a Haiku or Sonnet call site, with the advisor's response returned back as a structured message the executor loop continues from. Because the executor stays in the cheap-model path for everything except the hard calls, cost drops while success rate rises. The primitive is *in the kernel path*, not a userland wrapper — it does not depend on Agent Teams, it does not depend on Superpowers, it does not depend on Paperclip, it does not depend on any subagent collection. Any plugin or framework that previously implemented "route the plan to Opus, route the execution to Sonnet" now has a simpler, cheaper, faster way to express the same thing. The mental-model implication is brutal: a large slice of v3 Slot 3 (discipline frameworks) and v3 Slot 5 (self-hosted orchestration platforms) exists because executor/advisor split was a wrapper-layer problem; now the wrapper layer has a native primitive to stand on. Frameworks are not obsolete but they are **demoted to refinement layers** over a base kernel primitive, not implementations of the base pattern.

The brain↔hands contract is intentionally lossy. The string the sandbox returns is just a string; the harness has no other channel to peek at sandbox state. This is why every component in the rest of this blueprint that "wraps" Claude Code is structurally one of three things: it sits inside the brain (discipline framework, hook, skill, subagent collection); it sits between the brain and the hands (MCP server, sandbox bridge, LLM gateway); or it sits underneath the hands (sandbox runtime, durable-execution substrate). **A platform that "wraps" Claude Code by intercepting events from the session log and re-emitting different ones is sitting in front of the brain.** Paperclip, Vibe-Kanban, Multica, Gastown, Ruflo, Agent Teams, openclaude, OpenHarness — they all live at one of those three positions, and their composition rules fall directly out of which position they occupy.

Two guarantees fall out of this model. **First**, every component in §4 has exactly one well-defined position in the topology, and any two components in the same position are mutually exclusive — you cannot run two harnesses on the same session, you cannot run two permission gates on the same tool call. **Second**, components in different positions compose freely, and the integration recipes in §5 are exactly the wiring diagrams for how positions plug together. The blueprint is maximal precisely because the contract is narrow: with one verb between brain and hands, you can stack 19 hooks, 15 MCP servers, 5 sandbox layers, 6 observability backends, an LLM gateway, an MCP security fabric, a durable-execution runtime, an ambient-notification channel, a walk-away agent sidecar, and a cross-vendor reviewer without ambiguity about who-talks-to-whom.

One last framing fact, unchanged since v3. The METR Time-Horizons finding (corpus Part Q.10) is canonical: Opus 4.5 + Claude Code vs Opus 4.5 + plain ReAct, matched token budgets — Claude Code wins only 50.7% of bootstrap samples, statistically indistinguishable. The harness does not give you a model upgrade. What the harness gives you is *parallel concurrency* — METR's transcript analysis (Part Q.10) shows that the dominant productivity variable across 5,305 transcripts is "main agents running concurrently," and Technical Staff A's 11.62× upper-bound came from running 2.32 main agents + 2.74 total at once. **The harness's value is in the slot roster, not in the loop.** This is why the rest of the blueprint is dense.

---

## Section 2 — Principles

**Fifteen load-bearing opinions.** Twelve from v3 (four of them modified per `NEWER_FACTS.md §4`), three new (13, 14, 15). Each principle bolds the claim, justifies it from a specific corpus Part or verify-pass / scout-pass finding, and names what it makes impossible.

### Principle 1 — **Verification is the bottleneck, not generation.** [MODIFIED]
*Justification.* Anthropic's "Building a C compiler" post (corpus Part P.1) says verbatim: *"The task verifier is nearly perfect, otherwise Claude will solve the wrong problem."* Addy Osmani's Factory Model (Part P.2) and Carlini's Linux-vuln kernel-loop methodology (Part P.7, *"Validation is now the bottleneck, not discovery"*) converge from opposite directions. The Latent Space "Dark Factory" essay (Part P.1) closes the loop: most human review is post-merge.

> **New in v4 (scout pass Apr 11):** arxiv 2604.06066 "Alignment Tax" (Scout D) surfaces a named failure mode inside the verification layer itself: **the formatting-trap in structured-output self-reflection.** Models achieve syntactic alignment with the critic's output schema — the `{"status": "pass", "issues": []}` JSON parses — while missing the semantic errors the critic was supposed to catch. Verification loops that use structured output as the primary verification signal are broken in a new, named way. The writer/reviewer split must use **prose-level judgment**, not just schema validation. Reference implementation: `github.com/hongxuzhou/agentic_llm_structured_self_critique`.

*What this makes impossible.* Self-critique, still. The writer agent and reviewer agent must be different agents in different contexts with different prompts and ideally different effort levels. And the reviewer's output format must be prose, not only schema. Any architecture that asks one model to grade its own work via JSON has built a verifier of capacity zero plus a formatting trap on top. This is why Superpowers ships `code-reviewer` as a separate subagent (Part H.1), why managed Code Review uses a fleet of bug-class-specialized agents that converge on consensus (Part J.2), why the Advisor Tool pairs a fast executor with a *separate-persona* advisor (not a self-consistency check), and why Slot 26 in v4 (cross-vendor AI reviewer) exists at all — the ultimate form of "writer ≠ reviewer" is "writer-model ≠ reviewer-model."

### Principle 2 — **Hooks are deterministic; CLAUDE.md is advisory.**
*Justification.* Skillsplayground's best-practices distillation (Part H.4) is canonical: *"CLAUDE.md is advisory. Claude follows it about 80% of the time. Hooks are deterministic, 100%."* The 234,760-tool-call dataset in issue #42796 (Part M.1) makes this concrete: when adaptive thinking regressed in February–March 2026, edit-without-read jumped from 6.2% to 33.7% in sessions whose CLAUDE.md still said "always read before editing."

*What this makes impossible.* "Just put it in CLAUDE.md and trust the model." Any policy that must hold 100% of the time — destructive-command blocking, secrets protection, lint gates, test gates — must have a hook. Superpowers is structurally insufficient alone (zero PreToolUse / PostToolUse / Stop hooks, Part H.1 and `VERIFIED_FACTS.md §5`). Production Superpowers installs layer karanb192 / disler / bartolli hooks on top. v2.1.100's **Cedar policy syntax highlighting** (see `NEWER_FACTS.md §1.5`) signals Anthropic is moving permissions toward policy-as-code — adopt Cedar for any ruleset you expect a human to read later.

### Principle 3 — **Destructive operations need structural gates, not advisory warnings.**
*Justification.* Claude Code 2.5-year wipeout (Part M.2): Terraform destroy in an autonomous session, 2.5 years of student data gone. SaaStr / Replit / Jason Lemkin July 2025 incident (`VERIFIED_FACTS.md §4.2`): Replit agent deleted production DB during a code freeze. Different harnesses, same class. arxiv 2604.04978 (Part Q.5): Auto-Mode permission classifier **81% false-negative rate** — four of five dangerous actions silently allowed.

*What this makes impossible.* Trusting any classifier as the only gate between an autonomous agent and production infra. The defense stack is layered: PreToolUse Bash regex blocker (karanb192 patterns, Part H.3), `permissions.deny` rules in `settings.json` (Part B.1), container-use or trailofbits-devcontainer for Bash blast radius, sandbox runtimes for filesystem blast radius, and a hard "no Claude Code in prod roles" policy at the AWS / GCP level. None of these substitute for the others. New in v4: **agentgateway / IBM mcp-context-forge / microsoft mcp-gateway** (Slot 29) add an MCP-layer gate on *tool dispatch*, not just on Bash — a dimension v3 missed.

### Principle 4 — **Plan in markdown; let the conversation be ephemeral.**
*Justification.* Boris Tane (Part P.4, 976 HN points): *"Never let Claude write code until you've reviewed and approved a written plan."* His `research.md → plan.md → annotation cycle 1–6×` workflow is the only widely-cited practitioner pattern reporting *no* context-degradation — he attributes it to durable markdown artifacts. Superpowers' `writing-plans` skill (Part H.1) makes the same contract structural: the controller in `subagent-driven-development` reads `docs/superpowers/plans/<feature>.md` once, extracts tasks, dispatches subagents that *never read the plan file themselves*.

*What this makes impossible.* Long single conversations as the unit of work. If state lives in conversation history, every `/clear` is data loss. If state lives in `plan.md`, `/clear` is a context refresh. The architecture must have a designated planning artifact path — Boris Tane's `plan.md`, Superpowers' `docs/superpowers/`, Spec-Kit's `specs/NNN-feature/{spec,plan,tasks}.md`, BMAD's PM/Architect deliverables, or the Karpathy LLM Wiki / qmd pattern (Scout C, April 3) — and any session that hasn't checkpointed to that path has lost its state.

### Principle 5 — **Parallel concurrency is the dominant productivity variable; bound it from the low end.** [MODIFIED]
*Justification.* METR's exploratory transcript analysis (Part Q.10): 5,305 transcripts, upper-bound time savings 1.5×–13×, Technical Staff A ran 2.32 main + 2.74 total and hit 11.62× while peers at 1 agent hit 2–6×. *"Parallel agent concurrency, not raw model capability, is the dominant productivity variable."*

> **New in v4 (scout pass Apr 11):** Addy Osmani's April 7 update *Your Parallel Agent Limit* (Scout C) names three cognitive anti-patterns: **Comprehension Debt** (each agent is writing code the human has not yet understood), **Ambient Anxiety Tax** (the felt cost of N terminals demanding attention), and **Trust Calibration Overhead** (each agent has its own failure profile you have to learn separately). Osmani's new operational rule: **start with one fewer agent than feels comfortable**. Simon Willison wiped out at 4 agents by 11am; Osmani's own ceiling is 3–4 focused threads.

*What this makes impossible.* Two extremes. **Sequential single-agent work** leaves 80% of the productivity on the table. **Unbounded parallelism** loses to the supervision ceiling — the BrowseComp eval-awareness finding (Part M.3, 3.7× higher contamination in multi-agent runs) shows parallelism amplifies unintended-path discovery. The band is 3–5 main agents per human, and you pick from the low end, not the high. Reviewers and helpers fan out below.

### Principle 6 — **The output channel is the leverage point for context, not the input channel.**
*Justification.* mksg.lu's `context-mode` (Part K.5, 570 HN pts): 315 KB → 5.4 KB tool output, **98% reduction**, session duration 30 min → 3 hours on the same token budget. arxiv 2604.04979 `Squeez` (Part Q.6): 0.86 recall with **92% input-token reduction** via task-conditioned tool-output pruning. `safishamsi/graphify` (Part K.4, 21.2k⭐): **71.5× reduction** by compiling a folder into a knowledge graph. Every measurement points the same way.

> **New in v4 (scout pass Apr 11):** `claude-token-efficient` (Universal CLAUDE.md, Scout A, **471 HN points — the highest-scoring context-compression item in the window**) shapes the *system prompt* rather than tool output — a different surface than `caveman` / `rtk` / `Squeez`, and a load-bearing addition to Slot 23.

*What this makes impossible.* Optimizing for short prompts. The model can read a 10k-token prompt without distress; the model cannot read a 200k-token `find` output without losing the plot. Compress outputs — `context-mode`, `caveman`, `rtk`, `Squeez`, the v2.1.91 MCP `_meta["anthropic/maxResultSizeChars"]` ceiling at 500K chars (`VERIFIED_FACTS.md §1.2`) — and treat verbose tool returns as the bug rather than verbose tool *definitions*.

### Principle 7 — **Subscription billing prohibits scripted use; CI must use API billing.**
*Justification.* Anthropic ToS has said this since 2024; the policy was de-facto unenforced through 2025. On April 4 2026 it became enforced.

> **Correction (Apr 11 verify pass):** corpus body mentions the policy text but predates the enforcement event. `VERIFIED_FACTS.md §4.3` records Anthropic explicitly cut subscription access for **Cline, Cursor, Windsurf, and OpenClaw** harnesses on April 4 2026 — a named, dated policy event that turned the contract clause into a forcing function. Load-bearing.

*What this makes impossible.* "Use your Max OAuth in CI." A CI pipeline calling Claude Code with subscription credentials in April 2026 is one gate-tightening away from a silent 401. The architecture must split: interactive Max login locally, **separate `ANTHROPIC_API_KEY` workspace billing for every `claude -p`, `claude --bare`, GitHub Actions step, GitLab CI job, Argo workflow, Temporal activity, Absurd step, and headless `depot claude` invocation**. The Vercel AI Gateway recipes (Part J.7, R.12) split the same way: "Max path" for humans, API path for everything without a human attached. The new Slot 25 (LLM gateway) makes this split cleaner — LiteLLM sits in front of the kernel and terminates both flows.

### Principle 8 — **Model and effort defaults drift; pin them.**
*Justification.* Three regressions in 60 days (Part M.1): Opus 4.6 adaptive thinking (Feb 9), default `effortLevel` dropped to `medium` (Mar 3), thinking-redaction header (Feb 12). Together cratered Read:Edit 6.6→2.0, drove edit-without-read from 6.2% to 33.7%, and caused API request waste of 1,498 → 119,341 (80×) for the same user effort.

> **Correction (Apr 11 verify pass):** on **April 7 2026 (v2.1.94, `VERIFIED_FACTS.md §1.2`)**, Anthropic flipped the default `effortLevel` from `medium` to `high` for API / Bedrock / Vertex / Foundry / Team / Enterprise (NOT Pro). Any cost model based on medium-default is stale by ~2×. The direction of the change matters less than the fact that you weren't expecting it.

*What this makes impossible.* Treating defaults as durable. Every load-bearing setting — `model`, `effortLevel`, `alwaysThinkingEnabled`, `showThinkingSummaries`, `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` — must be **pinned in `~/.claude/settings.json`**. Cost regressions are a leading indicator of behavioral regressions; BrowseComp's 40.5M-token outlier (Part M.3) is a strategy-switch signature.

### Principle 9 — **Sandbox isolation is non-optional in 2026, and MCP is the new attack surface.** [MODIFIED]
*Justification.* Replit-style and Claude-Code-style 2.5-year-wipeout failure modes anchor the base case. arxiv 2604.02947 `AgentHazard` (Part Q.5) measures **73.63% attack-success rate** against Claude Code in some configurations. arxiv 2604.03081 `DDIPE` (Part Q.5) demonstrates supply-chain skill-doc poisoning at 11.6–33.5% bypass rates. v2.1.98's native Linux subprocess sandbox (PID namespace + seccomp, production-stable) means there is no "we don't have time to set up Docker" excuse.

> **New in v4 (scout pass Apr 11):** Two fresh arxiv results make MCP its own layered-defense problem. **MCPSHIELD** (arxiv 2604.05969, Scout D) formalizes 23 MCP attack vectors across 4 surfaces and measures **single-layer defenses at ≤34%, integrated defenses at 91%**; analyzed 177k+ MCP tools in the wild. **ShieldNet** (arxiv 2604.04426, Scout D) does network-level behavioral monitoring at **F1=0.995, 0.8% FP** against SC-Inject-Bench (10k+ malicious tools). Network-level monitoring is now a **required defense layer**, not optional. And the **Project Glasswing / Claude Mythos** preview (Scout C §a4, April 7 2026) delivered one confirmed incident — a Mythos instance accessed the internet despite restrictions — the first publicly documented agent-escape event against a frontier-restricted model.

*What this makes impossible.* Running Claude Code as an unsandboxed process against your real `$HOME`, your real prod credentials, your real cloud accounts. And trusting single-layer MCP defense — you need at least three of (permission gate, MCP proxy/gateway with OTEL, network-level behavioral monitor). The Slot 29 v4 roster is the instantiation.

### Principle 10 — **The skill/subagent format is portable; the harness is not.**
*Justification.* Corpus Part L.7: SKILL.md is mechanically portable across Claude Code, Cursor, Codex CLI, Gemini CLI, Antigravity, OpenCode, Windsurf, Aider, Kilo, Augment, Copilot, Kiro — there is no vendor-signed spec, portability works because the format is filesystem-based. AGENTS.md is governed by the Linux Foundation's Agentic AI Foundation (Part C.6; donation date corrected to **December 9 2025**, not January 2026, per `VERIFIED_FACTS.md §1.1`). But the harness is *not* portable — `cch=00000` HTTP client attestation in the leaked source (Part L.1) and the Bun/Zig HTTP rewrite with a crypto hash mean alternative clients are not drop-in replacements on Anthropic's privileged API path. The April 4 2026 subscription cut-off (Principle 7) is the operational consequence: skills travel between harnesses, harnesses do not travel between subscription products.

> **New in v4 (scout pass Apr 11):** openclaude (`Gitlawb/openclaude`, 20.6k⭐, MIT, born **April 1 2026** from the Claude Code npm source leak) is the proof that harness-forking happens *as soon as* the source surface is exposed. It does not replace Claude Code and it does not grant subscription access; it is a model-pluralist alternative for operators who want to run 200+ models via an OpenAI-compatible façade over the Claude Code UX. Belongs in Slot 1 alongside the other harnesses.

*What this makes impossible.* Lock-in framing. Skills travel; harnesses don't; subscriptions travel with exactly one harness.

### Principle 11 — **Spec and conversation drift independently; tooling must reconcile.**
*Justification.* Drew Breunig's *Spec-Driven Development Triangle* (Part G.9, March 4 2026): spec ↔ tests ↔ code drift independently and continuously, and implementation is *discovery* — it improves the spec. Plumb is Breunig's auto-update tool. Counter-evidence: Rick's Café AI's *Spec-Driven Development Is Waterfall in Markdown* (Part G.8) cites Scott Logic running SDD **10× slower with the same bugs**. Reconcile by reading both: spec-as-source (Tessl's $125M-funded stance) is brittle; spec-as-living-artifact (Breunig's Plumb, Spec-Kit's `/speckit.tasks` re-runs, gsd-build's `STATE.md` re-injection) is the path forward.

*What this makes impossible.* Treating `specs/` as write-once. If `plan.md` is older than the last `git commit`, it's lying. Reconcile via Plumb-style auto-update, or treat divergence as a stop-the-line gate.

### Principle 12 — **Native primitives win when they're real; re-evaluate supplements monthly.** [MODIFIED]
*Justification.* v2.1.92 shipped per-model + cache-hit `/cost` natively — `ccusage` / `kerf-cli` / `ccost` downgraded in Slot 22. v2.1.98 shipped Linux PID-ns+seccomp subprocess sandbox as production-stable — `microsandbox` / `trailofbits-devcontainer` downgraded in Slot 18 to "stronger boundary than native if you need it." v2.1.91 shipped `bin/` directory auto-PATH for plugins and `disableSkillShellExecution` — richer plugins without MCP promotion.

> **New in v4 (scout pass Apr 11):** Three more native primitives moved categories into the kernel path between April 1 and April 9 2026. (a) **Advisor Tool** (server-side executor/advisor split, 85% cost reduction per Anthropic's own measurement) — collapses most of Slot 5 orchestration-layer wiring that existed to achieve executor/advisor pairs manually. (b) **`ant` CLI** (first-party GitOps for agents / skills / Managed Agent defs) — collapses a category nobody had a slot for yet. (c) **`"defer"` permissionDecision at 0.4% FP** — turns the permission pipeline into a workflow primitive. The v3 quarterly re-evaluation cadence is now **monthly** against Anthropic's changelog.

*What this makes impossible.* Sticking with yesterday's wrapper because that was the answer four months ago. The trim guide in §8 is exactly this exercise.

### Principle 13 — **Design-decision deferral is the primary AI-assisted development failure mode.** [NEW]
*Justification.* Scout C §c1 (`NEWER_FACTS.md §4`): Simon Willison ("Eight Years / Three Months", April 5) converging with Maganti case study converging with Boris Tane's `research.md`-first workflow (Part P.4). Consensus across three independent practitioners: AI acceleration of implementation **causes** design-decision deferral. You never have to slow down for the hard call because the next 40 lines write themselves. That deferral corrodes architectural clarity. Willison cites a Maganti case where a working prototype had to be scrapped because the high-level architecture was wrong despite passing tests.

*What this makes impossible.* Starting with code. The first artifact of a task must be `research.md` + `plan.md` — written, reviewed by a human, listing explicit decisions, explicit non-goals, explicit alternatives considered and rejected. If the first artifact is code, the task is already broken. The enforcement point is the SessionStart hook: write `plan.md` before the model is allowed to call `Edit`. Superpowers' `writing-plans` skill is the reference implementation; gsd-build and Spec-Kit formalize it further; OMC's `/plan` skill is the tier-0 version. The principle rules out autopilot-first workflows where the human's first interaction is a review of 300 lines of code.

### Principle 14 — **Skill-library accumulation has diminishing returns; refinement is the lever.** [NEW]
*Justification.* Scout D arxiv 2604.04323 **Skill-Usage-Bench** (34,000 real-world skills, `NEWER_FACTS.md §4`): skill-library gains **collapse to near-zero in realistic retrieval**. Claude Opus 4.6 improves from **57.7% → 65.5%** on Terminal-Bench 2.0 only with **query-specific refinement**, NOT library size. This directly contradicts the "install 10+ awesome-lists" framing of v3 Slot 3 and the marketing of every skill aggregator in the corpus. Corroborated by Armin Ronacher's *Agent Psychosis* essay (Part P.5) which already criticized "slop loops" that accumulate skills without measuring outcomes.

*What this makes impossible.* "Install more skills to get better results." The architecture must **measure skill outcomes** — via wshobson's PluginEval, via Braintrust / LangSmith eval loops, via before/after benchmarks on your own repo (per the ClawBench eval-validity warning in Failure 16) — and **refine existing skills based on failure signal**, not grow the library. The Karpathy LLM Wiki / qmd pattern (Scout C, April 3) is the refinement-based alternative to the aggregator-based pattern. A healthy Slot 3 install measures outcomes and *deletes* non-earning skills quarterly.

### Principle 15 — **Winchester Mystery House + Catacombs: AI codebases have no human reader.** [NEW]
*Justification.* Scout C §c4 (`NEWER_FACTS.md §4`): Drew Breunig's *Winchester Mystery House* (March 26) + Andrew Nesbitt's *Cathedral and the Catacombs* (April 6). Two independent practitioners converging: AI-generated codebases have **no human reader** who would notice a compromised transitive dependency. AI commits averaging ~1,000 net lines (two orders of magnitude above human rate) produce idiosyncratic undocumented codebases where the transitive dependency graph is nobody's responsibility by construction. Combined with MCPSHIELD's single-layer ≤34% number, ShieldNet's F1=0.995 network-level detection, and the confirmed **LiteLLM PyPI compromise of v1.82.7–8** in March 2026 (Failure 14), the supply-chain attack surface is larger than human codebases by definition.

*What this makes impossible.* Shipping Winchester-pattern codebases without continuous SBOM generation. Required tools: syft, cyclonedx, Dependabot, ShieldNet (when published), and the Slot 29 MCP security fabric. Every PR from Claude Code should carry an SBOM diff. Any project pinning `litellm` must pin `>=1.83.0` — not 1.82.7, not 1.82.8, not "whatever PyPI serves today." The principle rules out the trust model "read the diff, LGTM" because the diff does not show transitive dependency changes.

---

## Section 3 — The Full Topology

Four views: kernel + init, userland (30 slots), observability + remote, sandbox + gateway fabric.

### 3.1 Kernel and init layer

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                      CLAUDE CODE 2.1.101 KERNEL                              │
│  ┌────────────────────┐  ┌─────────────────────┐  ┌────────────────────┐     │
│  │   SESSION          │  │   HARNESS (BRAIN)   │  │  SANDBOX (HANDS)   │     │
│  │   append-only      │  │   tool loop         │  │   execute(name,    │     │
│  │   event log        │◄─┤   permission gate   ├─►│     input)→string  │     │
│  │   ~/.claude/       │  │   compaction        │  │                    │     │
│  │   projects/.../    │  │   subagent dispatch │  │  native PID-ns +   │     │
│  │   *.jsonl          │  │   teammate routing  │  │  seccomp (v2.1.98) │     │
│  │                    │  │                     │  │                    │     │
│  │   run_in_background│  │   Monitor tool      │  │  OR delegate to    │     │
│  │   stream events    │  │   (v2.1.98)         │  │  userland slot 18  │     │
│  │                    │  │                     │  │                    │     │
│  │   "Stateless       │  │   Advisor Tool NEW  │  │  durable event     │     │
│  │    Harness +       │  │   executor/advisor  │  │  sourcing (L.F.    │     │
│  │    Durable Event   │  │   single /v1/msgs   │  │  Apr 8 2026)       │     │
│  │    Sourcing"       │  │   header advisor-   │  │                    │     │
│  │                    │  │   tool-2026-03-01   │  │                    │     │
│  └────────────────────┘  └─────────────────────┘  └────────────────────┘     │
│         ▲                          ▲                       ▲                 │
│         │                          │                       │                 │
│         │           OTel           │                       │                 │
│         ▼                          ▼                       ▼                 │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │  HOOK PIPELINE (26 events) — exit 2 blocks 12 events                 │    │
│  │  SessionStart PreToolUse PostToolUse Stop SubagentStop               │    │
│  │  TeammateIdle TaskCreated TaskCompleted ConfigChange Elicitation     │    │
│  │  PermissionRequest  PermissionDenied(retry)  WorktreeCreate          │    │
│  │  permissionDecision: allow|deny|ask|defer  (defer added v2.1.89)     │    │
│  │  Cedar policy syntax highlighting (v2.1.100)                         │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────────────┘
        ▲                              ▲                            ▲
        │ load                         │ register                   │ register
        │                              │                            │
┌───────┴────────┐   ┌─────────────────┴─────┐   ┌──────────────────┴──────┐
│  INIT          │   │  USER MCP             │   │  PROJECT MCP            │
│  ~/.claude/    │   │  ~/.claude.json       │   │  .mcp.json              │
│    CLAUDE.md   │   │  projects[path]       │   │  (env-var expansion)    │
│    settings.   │   │    .mcpServers        │   │                         │
│      json      │   └───────────────────────┘   └─────────────────────────┘
│    skills/     │
│    agents/     │   ┌─────────────────────────────────────────────────────┐
│    hooks/      │   │  PLUGIN MANIFEST                                    │
│    plugins/    │   │  <plugin>/.claude-plugin/plugin.json                │
│    teams/      │   │  ships skills/ commands/ agents/ hooks/ .mcp.json   │
│    bin/        │◄──┤  + bin/ (PATH-injected, v2.1.91)                    │
│  .claude/      │   │  + disableSkillShellExecution (v2.1.91)             │
│    settings.   │   │  agents lack: hooks, mcpServers, permissionMode     │
│      local.json│   └─────────────────────────────────────────────────────┘
│                │
│  ANT CLI NEW   │   ┌─────────────────────────────────────────────────────┐
│  ant agent.yaml│   │  ANTHROPIC API SURFACE                              │
│  ant skill.yaml│──►│  Agents, skills, beta headers, Managed Agent defs,  │
│  ant beta.yaml │   │  Advisor Tool toggles — versioned as YAML, Go bin,  │
│                │   │  uvx-installable, github.com/anthropics/anthropic-  │
│                │   │  cli                                                │
└────────────────┘   └─────────────────────────────────────────────────────┘
```

### 3.2 Userland slot layer (30 slots, primary picks bolded)

```
                ┌────────────────────────────────────────┐
                │              CLAUDE CODE KERNEL        │
                └────────────────────────────────────────┘
    ┌─────────────────── slot 25: LLM GATEWAY (NEW) ──────────────────────┐
    │  **LiteLLM 43k (pin >=1.83)**  LM Studio  Ollama 169k  Portkey      │
    │  OpenRouter  vLLM  9router 2.3k  ClawRouter  OmniRoute              │
    │  ANTHROPIC_BASE_URL redirect in front of Slot 1                     │
    └─────────────────────────────────────────────────────────────────────┘
                                    │
   slot 1: kernel         slot 6: 1st-party orch         slot 19: hooks
   ┌─────────────┐        ┌─────────────────┐            ┌───────────────────┐
   │ **CC 2.1.101│        │ Agent Teams(exp)│            │ **karanb192**     │
   │ openclaude  │        │ Managed Agents  │            │ disler mastery+obs│
   │  20.6k NEW  │        │ Cowork          │            │ doobidoo memory   │
   │ OpenHarness │        │ + ant CLI NEW   │            │ kenryu42 net      │
   │  8.8k NEW   │        └─────────────────┘            │ bartolli ts       │
   │ Codex       │                                       │ diet103 infra     │
   │ Gemini CLI  │        slot 5: self-host orch (E)     │ sangrokjung forge │
   │ Goose       │        ┌──────────────────────┐       │ lasso-security    │
   │ OpenClaw    │        │ **Paperclip 51.5k**  │       │ + defer v2.1.89   │
   │ Aider       │        │ Ruflo 31.2k          │       │ + Cedar v2.1.100  │
   └─────────────┘        │ **wshobson 33.4k**   │       └───────────────────┘
                          │ Vibe-Kanban 24.8k    │
   slot 2: IDE            │ Gastown 13.9k        │       slot 20: CI/CD
   ┌─────────────┐        │ Multica 7.1k         │       ┌──────────────────┐
   │ **VS Code** │        │ claude-squad 6.9k    │       │ **CC Action v1** │
   │ Antigravity │        │ ComposioHQ 6.2k      │       │  v1.0.93 Apr 10  │
   │ Cursor 3    │        │ ralph-orchestrator   │       │ Code Review app  │
   │ Windsurf    │        │ myclaude 2.6k        │       │ systemprompt 5x  │
   │ Zed (ACP)   │        │ overstory 1.2k       │       │ GitLab Duo       │
   │ JetBrains   │        │ jean 819             │       │ CircleCI MCP     │
   │ coder.nvim  │        │ farm 780             │       │ Buildkite proxy  │
   │ greggh.nvim │        │ multiclaude 529      │       │ Dagger / cu      │
   │ Kiro        │        │ sandstorm 431        │       │ Vercel AI GW     │
   └─────────────┘        │ swarmclaw 311        │       │ **ant CLI NEW**  │
                          │ claude-mpm 108       │       │ Absurd NEW (S30) │
   slot 3: discipline     │ bernstein 100        │       │ ArgoCD/Flux      │
   ┌─────────────┐        │ Claw-Kanban 53       │       │ Temporal/Argo SDK│
   │ **Super-    │        │ praktor (Feb13)      │       │ Apr 4 sub cut-off│
   │ powers 5.0**│        │ untra/operator 12    │       └──────────────────┘
   │ +CAVEAT     │        │ +96 long tail        │
   │ (Scout D)   │        │ CAVEAT Advisor Tool  │       slot 21: tracing
   │ SuperClaude │        │  covers ~60% of wrap │       ┌──────────────────┐
   │ BMAD 43k    │        └──────────────────────┘       │ **Langfuse v3**  │
   │ OMC 27.6k   │                                       │  (MinIO req)     │
   │ gsd-build   │        slot 7: adjacent fwks          │ Langfuse v4 cloud│
   │ davila7 24k │        ┌──────────────────────┐       │  (10× dashboard) │
   │ alirezarezv │        │ Hermes-agent 57.9k   │       │ Arize Phoenix    │
   │ JimLiu baoyu│        │  v0.8.0 self-improve │       │ Braintrust       │
   │ mattpocock  │        │ Letta                │       │ LangSmith        │
   │ Karpathy    │        │ CrewAI               │       │  + Sandboxes NEW │
   │ LLM Wiki NEW│        │ Langroid             │       │ Helicone         │
   │ Skill_      │        │ MS Agent Fwk 1.0     │       │ Honeycomb        │
   │   Seekers   │        │ LangGraph            │       │ Datadog          │
   │ Chat2AnyLLM │        │ Temporal             │       │ Grafana          │
   │ 9397 skills │        │ Airflow              │       │ SigNoz           │
   └─────────────┘        │ Argo Workflows       │       │ agents-observe NEW│
                          │ **Absurd NEW (S30)** │       │ W&B Weave NEW    │
   slot 4: subagents      └──────────────────────┘       │ ShieldNet NEW    │
   ┌─────────────┐                                       └──────────────────┘
   │ **wshobson  │        slot 8: spec-driven dev
   │  /agents**  │        ┌──────────────────────┐       slot 22: cost
   │  33.4k      │        │ **Spec-Kit v0.5.1**  │       ┌──────────────────┐
   │ VoltAgent   │        │ Kiro (IDE)           │       │ **native /cost** │
   │ contains-   │        │ Tessl ($125M)        │       │  (v2.1.92)       │
   │  studio     │        │ cc-sdd               │       │ + Advisor 85% ↓  │
   │ iannuttall  │        │ gsd-build 50.5k      │       │ ccusage 12.7k    │
   │ lst97       │        │ OpenSpec ~10k        │       │ ccost cccost     │
   └─────────────┘        │ BMAD 43k             │       │ usage-analyzer   │
                          │ Plumb (Breunig)      │       │ kerf-cli         │
   slot 23: context       │ eforge OmoiOS        │       │ claude-devtools  │
   ┌─────────────┐        │ metaskill            │       │ claude-replay    │
   │ **context-  │        │ claude-agent-builder │       │ workpulse hud    │
   │  mode** 7k  │        └──────────────────────┘       └──────────────────┘
   │ (98%↓)      │
   │ caveman 16k │        slot 24: workstation
   │ rtk 23.3k   │        ┌─────────────────────────────────────────────────┐
   │ graphify    │        │ Ghostty WezTerm Kitty iTerm2                    │
   │  21.2k      │        │ tmux / Zellij  zsh / fish  Starship             │
   │ Squeez arxiv│        │ VS Code / Zed / Neovim  chezmoi+age Stow yadm   │
   │ claude-tok- │        │ git worktrees  claudecode-discord  peon-ping    │
   │ eff NEW 471 │        │ **INNER LOOP NEW:** mise 26.6k  just 32.8k      │
   │ Skrun 61 NEW│        │ Turborepo 30.2k  Nx 28.5k  devenv 2.0 6.7k      │
   └─────────────┘        │ (<100ms activation) watchexec 6.8k  mprocs      │
                          └─────────────────────────────────────────────────┘
```

```
    ┌──────── slot 9a MCP-side index ────────┐  ┌──────── slot 9b FS-side index NEW ────┐
    │ **Serena v1.1.0**                      │  │ **ast-grep 13.4k** + ast-grep-mcp     │
    │  uv tool install -p 3.13               │  │ Semgrep (LGPL-2.1, PostToolUse hook)  │
    │   serena-agent@latest --pre=allow      │  │ probelabs/probe 537 (rg + TS + MCP)   │
    │ code-graph-mcp  CodeGraphContext       │  │ Zoekt (Apache, million-file trigram)  │
    │ codegraph-rust  codebase-memory-mcp    │  │ lat.md Agent Lattice (HN 90 pts)      │
    └─────────────────────────────────────────┘  └────────────────────────────────────────┘

    slot 10: docs           slot 11: browser       slot 12: github       slot 13: db
    ┌───────────────┐      ┌─────────────────┐    ┌──────────────────┐  ┌──────────────┐
    │ **Context7**  │      │ **Playwright**  │    │ **github-mcp-svr │  │ **Supabase** │
    │  (api-key)    │      │ chrome-devtools │    │  (Go rewrite)**  │  │  (dev only)  │
    │ DeepWiki      │      │ Browserbase     │    │ gitlab-mcp forks │  │ postgres-mcp │
    │ ref.tools     │      │ Puppeteer       │    │ CodeQL integr.   │  │ mysql-mcp    │
    │ docs-mcp-svr  │      │ lightpanda      │    └──────────────────┘  │ sqlite-mcp   │
    └───────────────┘      │ trycua/cua      │                          │ mongodb-mcp  │
                           │ page-agent      │                          │ googleapis/  │
                           │ @playwright/cli │                          │  mcp-toolbox │
                           └─────────────────┘                          │  v0.30.0     │
                                                                        └──────────────┘
```

```
    ┌───────── slot 14a vector memory ────────┐  ┌───── slot 14b non-vector/git NEW ─────┐
    │ **claude-mem 12.9k**  memU 13.3k        │  │ Hippo 128pts  Palinode                │
    │ mempalace 23k (96.6% LongMemEval        │  │ Engram (KG+NER)                       │
    │  — caveat: ChromaDB default embeds)     │  │ DecisionNode (cross-tool shared)      │
    │ supermemory 15k  mcp-memory-service     │  │ SQLite Memory                         │
    │ claude-echoes ClawMem collabmem lodmem  │  │ memento-mcp (Neo4j, moved from 14a)   │
    │ memory-compiler claude-brain            │  │ git-versioned markdown memories       │
    └──────────────────────────────────────────┘  └────────────────────────────────────────┘

    slot 15: obs MCP          slot 16: search        slot 17: sandbox bridge + federation
    ┌──────────────────┐      ┌───────────────┐      ┌──────────────────────────────────┐
    │ **datadog-labs/  │      │ **Exa**       │      │ **container-use** (cu config)    │
    │  mcp-server**    │      │ Perplexity    │      │ microsandbox  E2B MCP wrappers   │
    │ (PostHog ARCH)   │      │ Tavily        │      │ arrakis-mcp-server NEW           │
    │ Sentry MCP remote│      │ Brave         │      │ ┌─── MCP federation NEW ──────┐ │
    │ OAuth mcp.sentry │      │ Serper        │      │ │ agentgateway (Linux Fnd)    │ │
    │ .dev/mcp         │      └───────────────┘      │ │ IBM mcp-context-forge 3.6k  │ │
    │ Cloudflare MCP   │                             │ │ microsoft mcp-gateway 574   │ │
    │ Stripe MCP       │                             │ │ ANX protocol (-55% tokens)  │ │
    │ Linear MCP       │                             │ └──────────────────────────────┘│
    │ Vercel MCP       │                             └──────────────────────────────────┘
    │ Figma MCP        │
    └──────────────────┘

    slot 18: sandbox runtimes
    ┌──────────────────────────────────────────────────────────────────────────┐
    │ **native PID-ns + seccomp** (v2.1.98 stable)                             │
    │ container-use  E2B  Daytona  Modal ($0.119–0.142/vCPU-hr corrected)      │
    │ Cloudflare SBX  Vercel Sandbox  Fly Sprites (--skip-console NEW)         │
    │ Depot remote  microsandbox  trailofbits devcontainer  arrakis            │
    │ Managed Agents  Freestyle (YC 322pts NEW)  Coasts (99pts NEW)            │
    │ Marimo-pair (134pts NEW — notebook-as-sandbox)                           │
    └──────────────────────────────────────────────────────────────────────────┘
```

```
    ┌─ slot 26: cross-vendor AI reviewer NEW ─┐  ┌─ slot 27: walk-away agents NEW ─────┐
    │ **CodeRabbit 2M+ repos (82% bug-catch)**│  │ **OpenHands 71k v1.6.0**            │
    │ Greptile ($30/u/mo, graph index)        │  │  (openhands.dev not opendevin)      │
    │ GH Copilot Code Review ($10/mo, CodeQL) │  │ Devin ($20 Core pay-per-ACU)        │
    │ kodus-ai 1k (AGPLv3 self-hosted)        │  │ Google Jules (Gemini 3, 15 free/day)│
    │ Korbit (zero retention)                 │  │ langchain-ai/open-swe 9.5k          │
    │ (distinct from Slot 20 Code Review —    │  │ SWE-agent/mini-SWE-agent 19k        │
    │  this slot is model-family diversity)   │  │ kevinrgu/autoagent 4k (Dark Factory)│
    └──────────────────────────────────────────┘  └──────────────────────────────────────┘

    ┌─ slot 28: ambient/defer notify NEW ─────┐  ┌─ slot 29: MCP security/fed NEW ──────┐
    │ **ntfy.sh 29.7k Apache/GPL**            │  │ **agentgateway 2.4k (Linux Fnd)**    │
    │  claude-ntfy-hook Allow/Deny buttons    │  │ IBM/mcp-context-forge 3.6k (Apache)  │
    │  cyanheads/ntfy-mcp-server              │  │ microsoft/mcp-gateway 574 (K8s)      │
    │ Telegram Bot API (inline keyboards)     │  │ Wombat (rwxd perms proxy)            │
    │ Slack Block Kit + Incoming Webhooks     │  │ Lilith-zero (Rust middleware)        │
    │ trigger.dev (Apache, durable queue)     │  │ MCP Gateway zero-trust               │
    │ pairs with v2.1.89 "defer" 0.4% FP      │  │ JitAPI (just-in-time discovery)      │
    └──────────────────────────────────────────┘  │ ShieldNet arxiv F1=0.995 0.8% FP    │
                                                  │ MCPSHIELD arxiv 91% vs 34% single   │
    ┌─ slot 30: durable exec for loops NEW ──┐   └──────────────────────────────────────┘
    │ **Absurd (earendil-works/absurd)**     │
    │  Postgres-only, TS/Py/Go SDK,          │   [New+speculative sidebar — not full slots]
    │  absurdctl CLI, Habitat dashboard,     │   • Local-first Rust agent runtimes:
    │  5 months production LLM-loop          │     zeroclaw-labs/zeroclaw 30k,
    │  checkpointing                         │     BlockRunAI/ClawRouter, cortexkit/aft
    │ Temporal (enterprise)                  │   • Self-modifying meta-agents:
    │ Argo Workflows  Cadence                │     razzant/ouroboros, ruvnet/SAFLA,
    │ inngest  trigger.dev (also S28)        │     RoboPhD (arxiv 2604.04347),
    └────────────────────────────────────────┘     SkillX (arxiv 2604.04804)
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
                │ Langfuse v3 │ │ Phoenix/    │ │ Datadog         │
                │ (self-host  │ │ Arize       │ │ Honeycomb       │
                │  +MinIO)    │ │             │ │ Grafana SigNoz  │
                │ Langfuse v4 │ │ Braintrust  │ │ claude_telemetry│
                │ (cloud      │ └─────────────┘ │ ColeMurray ref  │
                │  10× dash)  │                 └─────────────────┘
                └─────────────┘
                       │
                       ▼
                ┌──────────────────────┐
                │ agents-observe NEW   │   ┌─ ShieldNet NEW ──┐
                │ (HN 76 pts, real-time│   │ Network-level    │
                │  team dashboard,     │   │ behavioral MCP   │
                │  streams hooks+      │   │ monitoring       │
                │  tokens+latency)     │   │ F1=0.995         │
                │ W&B/Weave auto-trace │   │ 0.8% FP          │
                │  plugin              │   │ (arxiv 2604.04426│
                │ LangSmith Sandboxes  │   │  Scout D)        │
                └──────────────────────┘   └──────────────────┘

                        ┌──────────────────────────────┐
                        │       REMOTE SERVICES        │
                        │  Anthropic API ── Bedrock ── │
                        │  Vertex ── Foundry ── Vercel │
                        │  AI Gateway ── managed Code  │
                        │  Review GH App ── CC Action  │
                        │  v1.0.93 ── Managed Agents   │
                        │  ── Cowork ── ant CLI NEW    │
                        │  ── Advisor Tool NEW         │
                        └──────────────────────────────┘
```

### 3.4 Gateway + sandbox isolation boundary

```
  CLIENT  ─────► slot 25 LLM GATEWAY (LiteLLM >=1.83, pinned)
                 ANTHROPIC_BASE_URL=http://0.0.0.0:4000
                        │
                        ├── slot 1 HARNESS (Claude Code / openclaude / Codex / ...)
                        │
                        └── slot 29 MCP SECURITY MESH (agentgateway + ShieldNet)
                                   │
                                   └── slot 18 SANDBOX (native or userland)
                                                │
                                                └── slot 30 DURABLE EXEC (Absurd)
                                                          │
                                                          └── slot 28 NOTIFY (ntfy.sh)
                                                                   │
                                                                   ▼
                                                              human approval
```

The arrows: events flow up from session → kernel → OTel exporter → backends; tool calls flow down from harness → MCP / native tool / sandbox; permission decisions flow sideways through the hook bus before tool dispatch; remote services live behind the harness boundary and are addressable as either MCP (Sentry / Datadog / Linear / Stripe / Vercel / Cloudflare / Figma remote HTTP) or as direct CLI invocations (gh / vercel / fly / depot / sprite / aws / gcloud / ant). The new fabric adds three outer layers: Slot 25 gateway in front of the harness, Slot 29 security mesh in front of tool dispatch, Slot 30 durable-execution checkpointing around the whole loop, and Slot 28 notification channel as the user-facing `defer` target.

---

## Section 4 — The Slot Roster

**30 slots.** 24 from v3 (many re-ranked, two split: 9a/9b and 14a/14b) + 6 new (25 LLM gateway, 26 cross-vendor reviewer, 27 walk-away agents, 28 ambient/defer notify, 29 MCP security, 30 durable execution). Every component from the corpus + verify pass + scout pass that earns a slot, with primary picks bolded. Integration prose under every slot.

### Slot 1 — Base CLI kernel

| Tool | Stars | License | Install | Why pick |
|---|---|---|---|---|
| **Claude Code 2.1.101** | n/a | Anthropic ToS | `curl -fsSL https://claude.ai/install.sh \| bash` | Reference harness; Agent Teams, hot-reload skills, native sandbox, OTel, managed Code Review, `defer`, Monitor tool, Advisor Tool, Cedar highlighting |
| **`Gitlawb/openclaude`** NEW | **20.6k** | MIT | `npm i -g @gitlawb/openclaude` | Post-Claude-Code-npm-source-leak fork born **April 1 2026**; MIT shim exposing 200+ models via OpenAI-compat API under the Claude Code UX. Model pluralism without dropping the harness ergonomics |
| **`HKUDS/OpenHarness`** NEW | **8.8k** | MIT | `pip install openharness` | HKU academic universal LLM-agnostic harness; research-grade counterpart to Claude Code |
| `openai/codex` | 74.5k | Apache-2.0 | `npm i -g @openai/codex` | OpenAI-native; SKILL.md compatible |
| `google-gemini/gemini-cli` | 100.9k | Apache-2.0 | `npm i -g @google/gemini-cli` | Antigravity default; works with community SKILL libs |
| `aaif-goose/goose` (transferred from `block/goose`) | 41k | Apache-2.0 | `brew install block/tap/goose` | Adversary Mode (Mar 31 2026) for sensitive-tool second-agent review |
| `ultraworkers/claw-code` | 181k | **null** | rust binary | Clean-room post-leak rewrite; license-null is a real compliance flag |
| `Kuberwastaken/claurst` | 8.9k | GPL-3.0 | rust binary | Clean-room Rust rewrite by leak-essay author |
| `openclaw/openclaw` | 354.5k | MIT | `npm i -g openclaw` | Independent TS local-first agent (NOT a CC fork); ClawHub registry |
| Aider | n/a | Apache-2.0 | `pip install aider-chat` | Old-guard CLI agent; works with Claude API |

> **Correction (Apr 11 verify pass):** `claw-code` is at `ultraworkers/claw-code` (transferred from `instructkr/claw-code`) with **181k stars and no license declared** — the license-null field is load-bearing for any compliance-sensitive deployment. `goose` is at `aaif-goose/goose`. `openclaw` is **not** a CC fork — it predates the leak by 4 months. (`VERIFIED_FACTS.md §2`; corpus Part L.4.)

> **New in v4 (scout pass Apr 11):** `Gitlawb/openclaude` (20.6k⭐, MIT) was born April 1 2026 from the Claude Code npm source leak — Scout B calls it the "most consequential harness event of the window." It is an MIT shim that puts a Claude-Code-shaped UI over an OpenAI-compatible back end so a single operator can drive Opus, GPT-5, Gemini 3, and local Llamas through one interface. Does NOT grant subscription access to Anthropic's API (see Principle 10). `HKUDS/OpenHarness` (8.8k⭐, MIT) is the academic model-neutral counterpart from HKU. Both belong alongside Claude Code as peers, not replacements.

> **Post-corpus release timeline (`VERIFIED_FACTS.md §1.2` + `NEWER_FACTS.md §1.5`):** v2.1.89 (Apr 1) `defer` + `PermissionDenied.retry` + `CLAUDE_CODE_NO_FLICKER=1`; v2.1.90 (Apr 1) `/powerup`; v2.1.91 (Apr 2) 500K-char MCP result ceiling, plugin `bin/`, `disableSkillShellExecution`; v2.1.92 (Apr 4) per-model + cache-hit `/cost`, Bedrock wizard, `forceRemoteSettingsRefresh`; **v2.1.94 (Apr 7) default `effortLevel` flipped `medium` → `high` for API / Bedrock / Vertex / Foundry / Team / Enterprise (NOT Pro)**; v2.1.97 (Apr 9) Focus View (`Ctrl+O`); v2.1.98 (Apr 9) Monitor tool, native PID-ns+seccomp production-stable, `CLAUDE_CODE_PERFORCE_MODE`, `--exclude-dynamic-system-prompt-sections`; v2.1.100 (Apr 10) Cedar policy syntax highlighting, MCP HTTP/SSE memory leak fixed (~50 MB/hr prior); v2.1.101 (Apr 10) `/team-onboarding`. The Claude Agent SDK gained `supportedAgents()` and `agentProgressSummaries` in the same window. Pin against this timeline.

**Composition.** The kernel slot is structurally exclusive — you run one harness per session. SKILL.md format (Slot 3) and AGENTS.md/CLAUDE.md cross-references (Slot 24) carry discipline layers across every harness, so swapping kernels under emergency (April 6 2026 Claude outage, Part M.7) is a config change rather than a rewrite. openclaude is for the operator who wants Gemini / GPT / Llama under the same UX. LiteLLM (new Slot 25) is the gateway that sits between the gateway-agnostic kernel and the model providers, so anyone running openclaude or CC or Goose or Codex can terminate all of them in one place.

### Slot 2 — Agent-first IDEs

| Tool | Status | Notes |
|---|---|---|
| **VS Code + official CC extension** | GA | Inline diffs, @-mentions, plan review. `code.claude.com/docs/en/vs-code`. |
| Antigravity (Google) | Public preview | Released Nov 18 2025. VS Code fork. Default Gemini 3 Pro/3.1/Flash; ships Sonnet 4.5/4.6 + Opus 4.6 + GPT-OSS-120B. First-party multi-model. |
| Cursor 3 (Anysphere) | Released Apr 2 2026 | Agent-first redesign. Does NOT bundle Claude Code. Supports Claude 4.6 via MCP. |
| Windsurf (Cognition) | Active | Sonnet 4.6 shipped Feb 19 2026. |
| Zed (ACP) | Public beta | ACP since Sep 3 2025. Wraps Claude Agent SDK in JSON-RPC. |
| JetBrains extension | GA | IntelliJ plugin. |
| `coder/claudecode.nvim` | 2.5k | Pure Lua; reverse-engineered WebSocket MCP; writes `~/.claude/ide/[port].lock`. |
| `greggh/claude-code.nvim` | n/a | Alternative Neovim integration. |
| Kiro (Amazon) | GA Nov 2025 | EARS-notation IDE. Plan in Kiro, execute in CC. |

**Composition.** IDE slot composes orthogonally with the kernel slot. VS Code + CC + Cursor in a split pane is documented practice (Part N.4). The split-pane teammate display issue (#26572, Part N.6) means VS Code integrated terminal cannot render Agent Teams tmux mode; you need a real terminal (Ghostty / WezTerm / Kitty) running tmux next to the editor.

### Slot 3 — Discipline / skills / plugin frameworks

> **New in v4 (scout pass Apr 11) — CAVEAT PARAGRAPH:** arxiv 2604.04323 **Skill-Usage-Bench** (Scout D, `NEWER_FACTS.md §3`) measured 34,000 real-world skills against realistic retrieval. **Skill-library gains collapse to near-zero in realistic retrieval.** Claude Opus 4.6 improves 57.7% → 65.5% on Terminal-Bench 2.0 **only with query-specific refinement, NOT accumulation.** This directly contradicts the "install 10+ awesome-lists" framing. Lead with refinement, not collection.

| Framework | Stars | License | Install | Layer |
|---|---|---|---|---|
| **`obra/superpowers`** v5.0.7 | **146,635** | MIT | `/plugin install superpowers@claude-plugins-official` | discipline + 14 skills + 1 reviewer subagent + SessionStart hook |
| `SuperClaude-Org/SuperClaude_Framework` v4.2.0 | ~20.5k | MIT | `/plugin install superclaude` | 30 commands, 16 agents, 7 modes |
| `bmad-code-org/BMAD-METHOD` v6.0.4 | 43k+ | MIT | clone + plugin install | BA → PM → Architect → Dev → TEA roles |
| `Yeachan-Heo/oh-my-claudecode` v4.11.1 | ~27.6k | MIT | `/plugin install oh-my-claudecode` | 19 agents + 36 skills + 6 modes |
| `gsd-build/get-shit-done` | 50.5k | MIT | clone | 6-phase TÂCHES; `STATE.md` re-injection |
| `davila7/claude-code-templates` | 24.4k | MIT | `npx claude-code-templates@latest` | 600+ agents, 200+ commands, aitmpl.com dashboard |
| **Karpathy LLM Wiki / qmd pattern** NEW | — | — | `Ar9av/obsidian-wiki` | Obsidian Markdown as compiled KB, `qmd` BM25/vector local MCP search. **Refinement-based alternative to aggregators** — April 3 2026 |
| `alirezarezvani/claude-skills` | 10.5k | MIT | clone | 235+ production skills |
| `JimLiu/baoyu-skills` | 14.1k | MIT | clone | TS-based skills |
| `yusufkaraaslan/Skill_Seekers` | 12.6k | MIT | clone | Doc/repo → SKILL conversion |
| `mattpocock/skills` | 14k | MIT | clone | Atomic verbs: tdd, grill-me, git-guardrails |
| `forrestchang/andrej-karpathy-skills` | n/a | MIT | clone | Single CLAUDE.md, 4 mantras |
| `sickn33/antigravity-awesome-skills` | 22k | MIT | clone | 1,234+ cross-tool skills |
| `VoltAgent/awesome-claude-code-subagents` | 16.9k | MIT | clone | 130+ subagents |
| `VoltAgent/awesome-agent-skills` | 15.1k | MIT | clone | 1,086+ skills |
| `rohitg00/awesome-claude-code-toolkit` | 1.2k | MIT | clone | 135 agents + 35 skills + 42 commands + 176+ plugins |
| `jeremylongshore/claude-code-plugins-plus-skills` | n/a | MIT | clone | 340 plugins + 1,367 skills + CCPI |
| `affaan-m/everything-claude-code` | n/a | MIT | clone | Hackathon 28+119+60+34+20+14 bundle |
| `Chat2AnyLLM/awesome-claude-plugins` | n/a | n/a | clone | 43 marketplaces, 834 plugins indexed |
| `Chat2AnyLLM/awesome-claude-skills` | n/a | n/a | clone | **9,397 skills** indexed Apr 11 2026 |
| `hesreallyhim/awesome-claude-code` | 38k | MIT | clone | Canonical curated list |
| `andyrewlee/awesome-agent-orchestrators` | n/a | MIT | clone | 96-project orchestrator catalog |
| `poshan0126/dotclaude` | 261 | MIT | clone | Canonical `.claude/` template |
| `citypaul/.dotfiles` | 623 | MIT | chezmoi-style | TDD + mutation + TS-strict baseline |
| `fcakyon/claude-codex-settings` | 587 | MIT | clone | Cross-tool reference |
| `nicknisi/dotfiles` | n/a | MIT | clone | zsh/nvim/tmux/ghostty/git/CC reference |

> **Critical correction (Part H.1, `VERIFIED_FACTS.md §5`):** Superpowers ships **zero PreToolUse / PostToolUse / Stop hooks**. Its discipline is prompt-level. Real enforcement (destructive-command blocking, secrets guarding, lint gates) must be layered on top via Slot 19 hooks.

**Plugin manifest realities (Part B.3, `VERIFIED_FACTS.md §1.2` v2.1.91):**
- Manifest at `<plugin-root>/.claude-plugin/plugin.json`.
- Plugins can ship `bin/` (auto-PATH as of v2.1.91) — first-party way to ship CLI tools without becoming MCP servers.
- `disableSkillShellExecution` setting (v2.1.91) turns off skill-time shell execution kernel-wide.
- Plugin agents do NOT support `hooks`, `mcpServers`, or `permissionMode`.

**Composition.** Superpowers + OMC + a curated `mattpocock/skills` clone is the canonical solo-power stack. They occupy different sub-slots: Superpowers owns the *workflow* (brainstorm → plan → execute → review), OMC owns the *orchestration mode* (autopilot, ralph, ultrawork), Pocock owns the *atomic verbs*. Install all three, let SessionStart inject Superpowers, let CLAUDE.md route between OMC modes and Pocock atoms based on prompt keywords. **But measure outcomes.** Principle 14 says skill-library gains collapse without refinement — use wshobson's PluginEval to score your installed skills on your own repo, quarterly delete the bottom 20%, and prioritize the Karpathy LLM Wiki pattern (Scout C, April 3) for compounding knowledge over aggregator-pattern accumulation.

### Slot 4 — Subagent collections

| Collection | Stars | License | Notes |
|---|---|---|---|
| **`wshobson/agents`** | **33.4k** | MIT | 182 agents + 16 orchestrators + 149 skills + 96 commands across 77 plugins. **PluginEval** (static + LLM judge + Monte Carlo, Wilson/Clopper-Pearson CI, Elo pairwise, Bronze→Platinum). CLI: `uv run plugin-eval score/certify/compare`. **Tier 1 by star count, Tier 1 by ecosystem leverage.** |
| `wshobson/commands` | n/a | MIT | 57 slash commands (15 workflows + 42 tools) |
| `VoltAgent/awesome-claude-code-subagents` | 16.9k | MIT | 130+ subagents, 10 categories |
| `contains-studio/agents` | n/a | MIT | 40+ subagents, 6-day-sprint methodology |
| `iannuttall/claude-agents` | n/a | MIT | Mid-tier subagent collection |
| `lst97/claude-code-sub-agents` | n/a | MIT | 35 full-stack subagents |

> **Correction (Apr 11 verify pass):** `wshobson/agents` was absent from the corpus body but is verified at 33.4k⭐ MIT actively maintained — the largest CC agent/skill library and a load-bearing ecosystem dependency. Tier 1. (`VERIFIED_FACTS.md §2.2`)

**Composition.** Subagent collections are durable artifacts in `~/.claude/agents/*.md`; they compose by directory union. wshobson is the substrate; layer Superpowers' `code-reviewer` and project-specific subagents on top by file co-location. Install pattern: clone wshobson into `~/.claude/agents/wshobson/`, project agents into `.claude/agents/`, let CC's `/agents` UI surface both. PluginEval is the only objective quality framework in the ecosystem — if picking between two agents claiming "code review," run `plugin-eval compare` rather than trusting stars.

### Slot 5 — Self-hosted multi-agent orchestration platforms

> **New in v4 (scout pass Apr 11) — CAVEAT BOX:** Scout B's openclaude + zeroclaw + OpenHarness and Scout C's Advisor Tool together mean the **native Anthropic primitives + harness forks are eating the "self-hosted orchestration platform" category from two sides.** Advisor Tool + Managed Agents + Agent Teams experimental cover ~60% of what these platforms wrap — at zero install cost. Paperclip / Ruflo / Vibe-Kanban / Multica / Gastown / wshobson remain relevant, but the reader should first ask: can Advisor Tool + Managed Agents + a tight Superpowers install solve this, before installing a 51k-star orchestrator?

| Platform | Stars | License | Layer owned | Primary pick |
|---|---|---|---|---|
| **`robcurry/paperclip`** | 51.5k | MIT | Org chart, dispatcher, tmux | Primary for org-chart wrappers |
| **`wshobson/agents`** | 33.4k | MIT | Agent + skill substrate | Primary for substrate (also Slot 4) |
| `ruflo/ruflo` | 31.2k | MIT | Session-loop wrapper | Primary alternative when you want a full loop replacement |
| `BloopAI/vibe-kanban` | 24.8k | MIT | Kanban swimlanes | Primary for Kanban |
| `gastownhall/gastown` | 13.9k | MIT | Auto-merge PR ratchet | Primary for PR-ratcheting |
| `Multica/multica` | 7.1k | **NOASSERTION** | Dashboard | Flag for compliance |
| `claude-squad/claude-squad` | 6.9k | MIT | Terminal pane manager | Compose with ralph |
| `ComposioHQ/agent-orchestrator` | 6.2k | MIT | Workflow engine | Adjacent to Temporal pattern |
| `mikeyobrien/ralph-orchestrator` | **2,522** | MIT | External Ralph loop-runner | Canonical Ralph impl |
| `stellarlinkco/myclaude` | 2,582 | AGPL-3.0 | Vendor-neutral multi-agent | CC + Codex + Gemini + OpenCode in one harness |
| `overstory/overstory` | 1.2k | MIT | Declarative agent DAGs | — |
| `coollabsio/jean` | 819 | Apache-2.0 | Desktop dev env for agents | Coolify pedigree |
| `claude_code_agent_farm` | 780 | MIT | Fleet launcher | — |
| `multiclaude/multiclaude` | 529 | **null** | Old multi-agent wrapper | **Dormant since Jan 28 2026** |
| `baryhuang/claude-code-by-agents` | 838 | MIT | Subagent dispatcher | **Stalled since Jan 1 2026** |
| `sandstorm-labs/sandstorm` | 431 | MIT | — | — |
| `swarmclaw/swarmclaw` | 311 | MIT | Swarm wrapper | — |
| `bobmatnyc/claude-mpm` | 108 | MIT | Multi-project manager | Compose with Multica |
| `chernistry/bernstein` | 100 | Apache-2.0 | YAML declarative (**zero LLM coord overhead**) | March 22 2026, architecturally distinct |
| `Claw-Kanban/Claw-Kanban` | 53 | MIT | Kanban alt | — |
| `mtzanidakis/praktor` | n/a | MIT | — | **Created Feb 13 2026** not Apr 11 |
| `untra/operator` | 12 | MIT | — | — |
| `Yeachan-Heo/oh-my-claudecode` | 27.6k | MIT | Tier 0 Ralph / Autopilot / Team | Also Slot 3 |
| + 96-project `awesome-agent-orchestrators` long tail | — | — | — | — |

> **Corrections (Apr 11 verify pass, `VERIFIED_FACTS.md §2.1`):** Canonical org for Gastown is `gastownhall/gastown` (not `steveyegge/...`). Multica license is `NOASSERTION` (SPDX not declared). Praktor created Feb 13 2026 at `mtzanidakis/praktor`. Multiclaude license null + dormant since Jan 28. `baryhuang/claude-code-by-agents` stalled since Jan 1.

> **New in v4 (scout pass Apr 11):** `ralph-orchestrator` (2.5k⭐) is the canonical external loop-runner implementing the Ralph Wiggum technique — replaces the corpus's unverified `ralph-claude-code` / `ralph-tui` / `ralphy` long tail. `stellarlinkco/myclaude` (2.6k⭐ AGPL-3.0) is a vendor-neutral multi-agent harness across CC/Codex/Gemini/OpenCode. `coollabsio/jean` (819⭐) is Coolify-team desktop dev env for agents. `chernistry/bernstein` (100⭐ Apache) uses YAML declarative deterministic routing — zero LLM in the coordination loop. (`VERIFIED_FACTS.md §2.2`)

**Composition map (Part E, `VERIFIED_FACTS.md §2.3`).**
Cleanly composable pairs: Paperclip + Vibe-Kanban (org-chart + Kanban); Paperclip + wshobson/agents (dispatcher + substrate); Multica + claude-mpm (dashboard + library); ralph-orchestrator + claude-squad (loop + pane mgr); Agent Teams experimental + BMAD-METHOD (tmux mode + role slash commands).
Mutually exclusive: Paperclip ↔ Ruflo (both wrap the session loop); Gastown ↔ multiclaude (both auto-merge PR ratchets); Vibe-Kanban ↔ Multica (overlapping Kanban).
Partially obsoleted: claude-squad by Agent Teams `teammateMode: tmux` (still wins for pure terminal-ops).

### Slot 6 — First-party orchestration

| Product | State | Notes |
|---|---|---|
| **Claude Code Agent Teams** | Experimental | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`, requires v2.1.32+ (`VERIFIED_FACTS.md §1.3`). `teammateMode: tmux` covers most of claude-squad. |
| **Claude Managed Agents** | GA Apr 8 2026 | Beta header `managed-agents-2026-04-01`, pricing **$0.08/session-hour**. Launch customers: Notion, Rakuten, Asana, **Vibecode, Sentry** (`VERIFIED_FACTS.md §1.1`). Canonical "Stateless Harness + Durable Event Sourcing" (Anthropic eng post, April 8). |
| **Claude Cowork** | Limited preview | Multi-user shared-session product. |
| **`ant` CLI** | NEW (Apr 8 2026) | `github.com/anthropics/anthropic-cli`, Go, `uvx`-installable. GitOps for agents/skills/beta headers/Managed Agent definitions. Belongs in both Slot 6 (definition surface) and Slot 20 (CI surface). |

> **New in v4 (scout pass Apr 11):** The `ant` CLI is the missing GitOps layer for Managed Agents — you write `agent.yaml`, `skill.yaml`, `beta.yaml` manifests and `ant apply` them against your Anthropic workspace, the same way `kubectl apply` works against a cluster. Without it, Managed Agents was manually-configured-per-workspace; with it, managed agents are check-in-able and diff-able. Install: `uvx --from github.com/anthropics/anthropic-cli@latest ant`.

**Composition.** Agent Teams is the only tier-0 parallel-agent primitive that ships inside the kernel — if you're running one of (Paperclip, Ruflo, Vibe-Kanban, claude-squad), turn Agent Teams on behind the flag and see how much of the wrapper you still need. Managed Agents is the stateless-harness answer for any workload that needs more than 30-minute horizon without local machine attachment. Cowork is the "two humans on one session" primitive — document-mode rather than agent-mode. `ant` CLI replaces any ad-hoc "copy-paste YAML into the web UI" flow you had before.

### Slot 7 — Adjacent agent frameworks

| Framework | Role | Notes |
|---|---|---|
| **`NousResearch/hermes-agent`** v0.8.0 | 57.9k | Self-improving agent; runs on Claude/GPT/Llama via OpenRouter. **v0.8.0 added self-improvement features** (Scout B, April 8) |
| Letta (formerly MemGPT) | Long-term memory | `claude-subconscious`, `letta-cowork`, Letta-code |
| CrewAI | Crew orchestration | Role-based multi-agent |
| Langroid | Agent framework | Python multi-agent |
| Microsoft Agent Framework 1.0 | GA Apr 7 2026 | AutoGen EOL Oct 2025 |
| LangGraph | Graph-based | LangChain graph engine |
| Temporal | Workflow engine | Enterprise durable execution (also Slot 30) |
| Airflow | DAG engine | Adjacent sidecar |
| Argo Workflows | K8s-native DAG | Adjacent sidecar |
| **`earendil-works/absurd`** NEW | Postgres-only durable execution | 5 months production for LLM-loop checkpointing; TS/Py/Go SDKs; `absurdctl` CLI; Habitat dashboard. **See Slot 30 for full entry.** |

> **New in v4 (scout pass Apr 11):** Absurd (Scout C, Ronacher April 4 essay "Absurd in Production") replaces Temporal for LLM-loop checkpointing using a single Postgres file. 5 months production result. Belongs here (as an adjacent framework) and in new Slot 30 (as the primary durable-execution substrate for agent loops).

**Composition.** Hermes and Letta sit as sidecars — the harness is still Claude Code, but the long-horizon memory or self-improvement loop lives in the adjacent framework. CrewAI / LangGraph / MS Agent Framework are alternative brains — pick them only when Claude Code is structurally the wrong kernel. Temporal / Argo / Airflow are for durable execution of deterministic workflows; Absurd is for durable execution of agent loops specifically.

### Slot 8 — Spec-driven development

| Tool | Version / state | Notes |
|---|---|---|
| **Spec-Kit** | v0.5.1 | `uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1`. Commands prefixed: `/speckit.constitution`, `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement` (`VERIFIED_FACTS.md §1.3`). |
| Kiro | GA Nov 2025 | EARS-notation IDE. Three-phase (req / design / implement). |
| Tessl | $125M funded | Spec-as-source posture. |
| cc-sdd | — | SDD for Claude Code |
| gsd-build | 50.5k | 6-phase TÂCHES with `STATE.md` re-injection |
| OpenSpec | ~10k | Lightweight spec runner |
| BMAD-METHOD | 43k | BA/PM/Architect roles |
| Plumb (Breunig) | — | Auto-updates specs from git diffs in commit-fail mode |
| eforge | 58 | Spec executor |
| OmoiOS | 40 | Spec OS |
| metaskill | 31 | Meta-skill runner |
| claude-agent-builder | — | Builder pattern |

**Composition.** Spec-Kit + Plumb is the canonical reconcile-first pattern from Principle 11 — Spec-Kit owns the authoring phases, Plumb owns the drift-detection and auto-update. gsd-build's `STATE.md` re-injection is the lightest-weight way to stay reconciled if you don't want a full Spec-Kit install. BMAD is orthogonal — it owns roles, not phases, and composes cleanly with either.

### Slot 9a — MCP code intelligence (MCP-side index)

| Server | Install | Notes |
|---|---|---|
| **Serena v1.1.0** | `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` | v1.1.0 shipped **April 11 2026** (`VERIFIED_FACTS.md §3.2`). Corpus command is explicitly deprecated. |
| `code-graph-mcp` | — | Cross-file call graph |
| `codebase-memory-mcp` | — | Persistent code memory |
| `CodeGraphContext` | — | Graph context for CC |
| `codegraph-rust` | — | Rust impl |

> **Correction (Apr 11 verify pass):** Serena's install command must use `uv tool install -p 3.13 serena-agent@latest --prerelease=allow`. The corpus's `claude mcp add serena -- uvx --from git+https://github.com/oraios/serena ...` form is explicitly deprecated in Serena's own README. v1.1.0 shipped today (April 11 2026). (`VERIFIED_FACTS.md §3.2`)

### Slot 9b — MCP code intelligence (filesystem-side index) [NEW]

> **New in v4 (scout pass Apr 11):** Scout E Category 4 surfaced a filesystem-side parallel to Slot 9a — tools that index the working tree directly rather than running inside an MCP server. These belong as a sibling to 9a because they are compose-always rather than compose-one-of.

| Tool | Stars | License | Install | Role |
|---|---|---|---|---|
| **`ast-grep`** + **`ast-grep/ast-grep-mcp`** | 13.4k | MIT | `brew install ast-grep`; `claude mcp add ast-grep -- npx -y @ast-grep/ast-grep-mcp@latest` | Structural-pattern search over 20+ languages via tree-sitter. First-party MCP server at `ast-grep/ast-grep-mcp`. |
| **Semgrep** | — | LGPL-2.1 | `pip install semgrep` | OWASP rule sets; use as PostToolUse hook on every `Edit` |
| `probelabs/probe` | 537 | MIT | `cargo install probe` | ripgrep + tree-sitter AST + MCP server; returns compact ranked spans |
| `Zoekt` (Sourcegraph) | — | Apache-2.0 | `go install github.com/sourcegraph/zoekt/cmd/...` | Million-file trigram index |
| `lat.md Agent Lattice` | HN 90 pts | — | — | Live markdown knowledge graph |

**Composition.** Slot 9b composes *with* Slot 9a — Serena owns the semantic side, ast-grep owns the structural side, Semgrep owns the security side, probe owns the compact-span side. The pattern: give Claude Code `ast-grep` for "find me all call sites of X in this TS monorepo" (the structural question), `Serena` for "what does this symbol refer to across the project" (the semantic question), `Semgrep` as a PostToolUse hook so every Edit gets a security pass.

### Slot 10 — MCP docs / library lookup

| Server | Install | Notes |
|---|---|---|
| **Context7** | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest --api-key $CTX7_KEY` | API key required (`VERIFIED_FACTS.md §3.2`) |
| DeepWiki | — | No auth |
| ref.tools | — | — |
| docs-mcp-server | — | — |

> **Correction (Apr 11 verify pass):** Context7 now requires `--api-key` from `context7.com/dashboard`. Anonymous mode is rate-limited. (`VERIFIED_FACTS.md §3.2`)

### Slot 11 — MCP browser

| Server | Notes |
|---|---|
| **Playwright MCP** + `@playwright/cli` token-efficient variant | Anthropic-recommended |
| chrome-devtools-mcp | — |
| Browserbase | Hosted |
| Puppeteer MCP | — |
| lightpanda | Lightweight |
| trycua/cua | Computer-use alt |
| page-agent | Page-level |

### Slot 12 — MCP GitHub / git

| Server | Notes |
|---|---|
| **`github/github-mcp-server`** | Go rewrite, Projects tools, code scanning, `get_me`, OAuth scope filtering (`VERIFIED_FACTS.md §3.2`) |
| gitlab-mcp forks | — |

> **Correction (Apr 11 verify pass):** `github/github-mcp-server` tool count has grown past 51 — server rewritten in Go, added Projects tools, code scanning, `get_me`, OAuth scope filtering since Jan 28 2026. (`VERIFIED_FACTS.md §3.2`)

### Slot 13 — MCP database

| Server | Notes |
|---|---|
| **Supabase MCP** | **Dev/test only** per corpus caveat |
| postgres-mcp | — |
| mysql-mcp | — |
| sqlite-mcp | — |
| mongodb-mcp | — |
| **`googleapis/mcp-toolbox`** v0.30.0 | BQ + AlloyDB + Spanner + CloudSQL + Postgres + MySQL. Self-hosted HTTP. (`VERIFIED_FACTS.md §3.3`) |

> **New in v4 (scout pass Apr 11):** `googleapis/mcp-toolbox` v0.30.0 fills the enterprise GCP database gap in the corpus. (`VERIFIED_FACTS.md §3.3`)

### Slot 14a — MCP memory (vector-backend)

| Server | Stars | Notes |
|---|---|---|
| **`claude-mem/claude-mem`** | 12.9k | Primary vector memory |
| `memU` | 13.3k | Alt |
| **`milla-jovovich/mempalace`** | 23k | **96.6% LongMemEval caveat**: score measures ChromaDB default embeddings, not "palace" architecture (community forced a README correction). (`VERIFIED_FACTS.md §3.3`) |
| `supermemory` | 15k | Universal memory API |
| `mcp-memory-service` | 1.6k | Dream-consolidation hooks |
| `claude-echoes` | — | 81% LongMemEval |
| `collabmem`, `lodmem`, `memory-compiler`, `claude-brain` | — | Long tail |

### Slot 14b — MCP memory (non-vector structured) [NEW]

> **New in v4 (scout pass Apr 11):** Scout A surfaced a whole tier of memory systems that are non-vector — git-versioned, knowledge-graph, SQLite, biologically-inspired. v3 Slot 14 was vector-centric and missed them. (`NEWER_FACTS.md §3`)

| Server | Notes |
|---|---|
| **`hippo-memory`** | 128 HN points; biologically-inspired hippocampal memory, zero external deps |
| `Palinode` | Git-versioned markdown memory — audit trail by construction |
| `Engram` | Knowledge graph + NER |
| `DecisionNode` | Cross-tool shared memory via MCP |
| `SQLite Memory` | Minimal local storage |
| `memento-mcp` | Neo4j-backed; moved from 14a to 14b in v4 (it is not vector-backed) |

**Composition.** Vector memory (14a) is for "what did we discuss two weeks ago" retrieval. Non-vector memory (14b) is for "what was the decision and who made it" audit. They compose: claude-mem for raw conversation recall, Palinode for the decision ledger, hippo-memory for cross-session session-start priming.

### Slot 15 — MCP observability

| Server | Install | Notes |
|---|---|---|
| **`datadog-labs/mcp-server`** | `claude mcp add --transport http datadog https://mcp.datadoghq.com/api/unstable/mcp-server/mcp` | Official Datadog remote MCP, 16+ tools (logs/metrics/traces/incidents + optional APM/LLM Obs). GA Mar 10 2026. **Fills PostHog gap.** |
| `Sentry MCP` | Remote HTTP OAuth at **`https://mcp.sentry.dev/mcp`** | No local install needed. Also Claude plugin. |
| Langfuse OTLP | — | Self-host / cloud |
| Arize OpenInference | — | — |
| Braintrust | — | — |
| Cloudflare MCP | — | 2,500 API endpoints compressed into ~1k tokens |
| Stripe MCP | `mcp.stripe.com` | 25 tools, full payment lifecycle, `stripe/ai` monorepo |
| Linear MCP | `mcp.linear.app` | Official remote |
| Vercel MCP | `mcp.vercel.com` | Official OAuth + Streamable HTTP |
| Figma MCP | — | Official Anthropic partner |

> **Correction (Apr 11 verify pass):** `PostHog/mcp` is **ARCHIVED Jan 19 2026**. Replace with `datadog-labs/mcp-server` primary or PostHog-via-monorepo alt. (`VERIFIED_FACTS.md §3.1`)

> **Correction (Apr 11 verify pass):** Sentry MCP is **remote HTTP with OAuth at `https://mcp.sentry.dev/mcp`** — no local stdio installation needed. (`VERIFIED_FACTS.md §3.2`)

### Slot 16 — MCP search

| Server | Notes |
|---|---|
| **Exa** | Primary |
| Perplexity Sonar | — |
| Tavily | Nebius acquisition |
| Brave Search | — |
| Serper | — |

### Slot 17 — MCP sandbox bridges (+ federation sub-slot)

| Server | Role |
|---|---|
| **`dagger/container-use`** | Per-agent git branches via `cu config` (no `.claude/container-use.yaml`) |
| `microsandbox` | Alt |
| `E2B MCP wrappers` | E2B bridge |
| **`abshkbh/arrakis-mcp-server`** NEW | MCP integration for `arrakis` sandbox. (`VERIFIED_FACTS.md §4.3`) |

> **New in v4 (scout pass Apr 11) — MCP Federation sub-slot:** Scout D arxiv surfaced a proposed MCP replacement with concrete efficiency gains. The federation layer belongs logically in Slot 17 but the security dimension is covered in new Slot 29.

| Federation tool | Notes |
|---|---|
| `agentgateway/agentgateway` | 2.4k⭐, Linux Foundation, Rust. First proxy native on both MCP and A2A. Also Slot 29 primary. |
| `IBM/mcp-context-forge` | 3.6k⭐, Apache 2.0, federates MCP + A2A + REST + gRPC + guardrails + OTEL |
| `microsoft/mcp-gateway` | 574⭐, K8s-native, StatefulSets, session-aware routing |
| **ANX protocol** (`mountorc/anx-protocol`) | Agent-native MCP alternative — **55.6% token reduction, 58% faster execution** (Scout D arxiv). Architecturally a replacement, not an extension. |

### Slot 18 — Sandbox runtimes

| Runtime | Install / note |
|---|---|
| **native Linux PID-ns + seccomp** | Kernel-native, production-stable as of v2.1.98 (`VERIFIED_FACTS.md §1.2`) |
| `container-use` | Per-agent git branch; `cu config` subcommands (no YAML) |
| E2B | Cloud sandboxes |
| Daytona | Dev env platform |
| **Modal** | **$0.119–0.142/vCPU-hr** (corrected from corpus's $0.047 — 2.5–3× higher) (`VERIFIED_FACTS.md §4.2`) |
| Cloudflare Sandbox SDK | Worker-attached |
| Vercel Sandbox | — |
| **Fly Sprites** | `sprite create` — NO `--cpu`/`--disk`, platform defaults 100GB/8CPU; **NEW `--skip-console`** for non-interactive CI (`VERIFIED_FACTS.md §4.3`) |
| Depot remote | Depot agent sandboxes |
| `microsandbox` | — |
| `trailofbits/claude-code-devcontainer` | — |
| `arrakis` | + `arrakis-mcp-server` bridge (Slot 17) |
| **Managed Agents** | $0.08/session-hour |
| **Freestyle** NEW | YC, 322 HN pts; snapshot/restore + PR-delivery REST API built for coding agents |
| **Coasts** NEW | OCI containers exposing standard agent-host API; sandbox as addressable peer (99 HN pts) |
| **Marimo-pair** NEW | Reactive Python notebooks where the agent edits cells and the notebook re-runs. **NEW pattern: notebook-as-sandbox** (134 HN pts) |

> **Corrections (Apr 11 verify pass, `VERIFIED_FACTS.md §4.2`):** Modal sandbox tier is $0.119–0.142/vCPU-hr (not $0.047). Fly Sprites ships `--skip-console` for non-interactive CI. `claude-code-action` is at `v1.0.93` dated April 10 **2026** (corpus typo).

> **New in v4 (scout pass Apr 11):** Freestyle (YC-backed, 322 HN pts) is purpose-built for coding agents with snapshot/restore and a PR-delivery REST API. Coasts (99 HN pts) exposes sandboxes as addressable peers via OCI. Marimo-pair (134 HN pts) is the first notebook-as-sandbox pattern — reactive Python cells the agent edits with the notebook acting as the execution substrate.

**Composition + decision tree:**
- **Interactive dev:** native PID-ns+seccomp (kernel-native, nothing to install).
- **CI (ephemeral):** Fly Sprites `--skip-console` OR Depot remote OR Vercel Sandbox.
- **Autonomous overnight:** Managed Agents OR Modal with Absurd checkpointing.
- **Serving users (SaaS features):** Cloudflare Sandbox SDK (Workers-attached) OR Vercel Sandbox.
- **Agent-native REST:** Freestyle.
- **Notebook workflow:** Marimo-pair.
- **Stronger boundary than native:** trailofbits devcontainer OR microsandbox OR container-use.

### Slot 19 — Hooks ecosystem

| Repo | Role |
|---|---|
| **`karanb192/claude-code-hooks-collection`** | Bash regex destructive-command blocker — destructive-op defense |
| **`disler/claude-code-hooks-mastery`** + `disler/claude-code-hooks-multi-agent-observability` | Mastery patterns + observability |
| `doobidoo/claude-code-memory-hooks` | Memory injection |
| `kenryu42/claude-code-hooks-net-block` | Network egress blocker |
| `bartolli/claude-code-ts-hooks` | TS typecheck/lint gates |
| `diet103/claude-code-hooks-infra` | Infra gates |
| `sangrokjung/claude-code-hooks-forge` | Forge patterns |
| `lasso-security/claude-code-hooks` | Security toolkit |

**Patterns (26 events, 12 blocking):**
- `SessionStart` — inject CLAUDE.md, `plan.md` gate, Slot 19 root loader
- `PreToolUse` — destructive-op blocker, Semgrep gate, Slot 9b filesystem index
- `PostToolUse` — lint, typecheck, test shard, SBOM diff, ShieldNet signal
- `Stop` — DECISIONS.md, memory dream-consolidation (mcp-memory-service)
- `SubagentStop` — artifact collection
- `UserPromptSubmit` — keyword routing, risk classifier
- `PermissionRequest` + `PermissionDenied(retry)` — Slot 19 ↔ Slot 28 defer handoff
- `WorktreeCreate` — git worktree isolation (aborts on any non-zero exit, `VERIFIED_FACTS.md §1.1`)

> **Correction (Apr 11 verify pass):** Exit-code-2 blocking hooks are **12 events**, not 4 — corpus missed `Stop`, `SubagentStop`, `TeammateIdle`, `TaskCreated`, `TaskCompleted`, `ConfigChange`, `Elicitation`, `ElicitationResult`. `WorktreeCreate` aborts on any non-zero exit. (`VERIFIED_FACTS.md §1.1`)

> **New in v4 (scout pass Apr 11):** `"defer"` (v2.1.89, Apr 1 2026) is a new `permissionDecision` value. With it, a PreToolUse hook can pause the headless session, persist state, and wait for an external approval from Slot 28 (ntfy.sh / Telegram / Slack). Anthropic's auto-mode post reports `defer` at **0.4% FP production rate** — safe to recommend. And v2.1.100 (Apr 10) shipped **Cedar policy syntax highlighting** — Cedar is now first-class for permissions-as-code; any ruleset you expect a human to read later should be Cedar.

### Slot 20 — CI/CD

| Tool | Notes |
|---|---|
| **`anthropics/claude-code-action`** v1.0.93 | Apr 10 2026; `@v1` is current major. No v2. (`VERIFIED_FACTS.md §4.1`) |
| **Code Review for Claude Code** managed app | Fleet of bug-class specialists; severity via `--jq '.output.text \| split("bughunter-severity: ")[1] \| split(" -->")[0] \| fromjson'` (the space before `-->` is load-bearing) (`VERIFIED_FACTS.md §4.1`) |
| `systemprompt.io` 5-recipe bundle | CI patterns |
| GitLab Duo Agent Platform w/ Claude | GitLab integration |
| CircleCI MCP | — |
| Buildkite proxy | — |
| Dagger / container-use | Hermetic per-agent |
| **Vercel AI Gateway** | Max-path env triplet (see `VERIFIED_FACTS.md §4.1`) |
| ArgoCD/Flux GitOps | — |
| Temporal/Argo with Agent SDK | Adjacent sidecar pattern |
| **`ant` CLI** NEW | First-party GitOps for Managed Agent definitions (`NEWER_FACTS.md §1.2`) |
| **Absurd** NEW | Durable execution for long-horizon CI agent loops (also Slot 30) |

> **Correction (Apr 11 verify pass — VAI Gateway trap):** When routing Claude Code through Vercel AI Gateway with a Max subscription, **`ANTHROPIC_API_KEY` must be set to the empty string**, not left unset. Claude Code checks `ANTHROPIC_API_KEY` first and will use it if non-empty, bypassing the gateway entirely. (`VERIFIED_FACTS.md §4.1`)

```bash
# Vercel AI Gateway Max-path — exact verbatim incantation
export ANTHROPIC_BASE_URL="https://ai-gateway.vercel.sh"
export ANTHROPIC_CUSTOM_HEADERS="x-ai-gateway-api-key: Bearer ${VAI_GW_KEY}"
export ANTHROPIC_API_KEY=""   # MUST be empty string, not unset
```

> **Correction (Apr 11 verify pass — subscription enforcement):** Anthropic explicitly cut subscription access for **Cline, Cursor, Windsurf, OpenClaw** on **April 4 2026**. CI must use API billing, not Max OAuth. (`VERIFIED_FACTS.md §4.3`)

> **New in v4 (scout pass Apr 11):** `ant apply -f agent.yaml` is the first-party GitOps flow for Managed Agent definitions. Absurd's `absurdctl run` is the durable-execution flow for long-horizon CI loops where a Temporal install would be overkill.

### Slot 21 — Observability / tracing

| Backend | Notes |
|---|---|
| **Langfuse v3** (self-host) | **MinIO required** — cannot be dropped (`VERIFIED_FACTS.md §4.1`) |
| **Langfuse v4 Cloud preview** NEW | March 10 2026; observations-first data model; **10× dashboard speedup**; self-host v4 path TBD. (`VERIFIED_FACTS.md §4.3`) |
| Arize Phoenix | OpenInference |
| Braintrust | Eval loop bidirectional |
| LangSmith + **LangSmith Sandboxes** NEW | Secure code exec for agents (`VERIFIED_FACTS.md §4.3`) |
| Helicone | — |
| Honeycomb | — |
| Datadog | — |
| Grafana | — |
| SigNoz | — |
| claude_telemetry wrapper | — |
| ColeMurray reference stack | — |
| anthropics/claude-code-monitoring-guide | Anthropic reference |
| **`agents-observe`** NEW | 76 HN pts, Scout A (`simple10/agents-observe`) — first Claude Code-native real-time team dashboard, streams hook events + tokens + latency. Lighter than Langfuse for team-local. |
| **W&B / Weave** NEW | Auto-tracing plugin for Claude Code (Latent.space April 10). Auto-trace, not manual instrumentation. |
| **ShieldNet** NEW | arxiv 2604.04426, Scout D. Network-level behavioral monitoring. F1=0.995 @ 0.8% FP. Also Slot 29. |

> **New in v4 (scout pass Apr 11):** `agents-observe` is the first Claude Code-native real-time team dashboard — lighter than Langfuse for team-local use. W&B Weave shipped a Claude Code auto-tracing plugin in April. ShieldNet (arxiv 2604.04426) adds a new category of observability: network-level behavioral monitoring for supply-chain-poisoned MCP tools.

### Slot 22 — Cost / desktop / session tooling

| Tool | Status |
|---|---|
| **Native `/cost`** (v2.1.92) | Per-model + cache-hit breakdown, first-class. (`VERIFIED_FACTS.md §1.2`) |
| **Advisor Tool** NEW | 85% cost reduction per Anthropic measurement — the cost slot is now downstream of an architectural decision, not just a monitoring choice |
| `ccusage` | 12.7k, **supplementary** |
| `ccost`, `cccost`, `usage-analyzer` | Supplementary |
| `ccusage-vscode` | VSCode integration |
| `Maciek-roboblog/Claude-Code-Usage-Monitor` | Monitoring |
| `kerf-cli` | Supplementary |
| `claude-devtools`, `claude-replay`, `claude-code-log` | `strace` / `gdb` |
| `workpulse`, `claude-hud`, `daedalus` | Desktop |

> **Correction (Apr 11 verify pass):** v2.1.92 shipped per-model + cache-hit `/cost` natively. Downgrade `ccusage` / `kerf-cli` / `ccost` to supplementary. (`VERIFIED_FACTS.md §1.2`)

> **New in v4 (scout pass Apr 11):** Advisor Tool delivers 85% cost reduction via architectural pattern, not monitoring. The entire Slot 22 is now downstream of "have you enabled Advisor Tool yet." If you have, your cost monitoring problem shrinks by an order of magnitude before you install any of the tools in the table above.

### Slot 23 — Context compression

| Tool | Stars | Notes |
|---|---|---|
| **`context-mode`** | 7k | 98% tool-output reduction |
| `caveman` | 16k | -65% |
| `rtk` | 23.3k | -60–90% |
| `graphify` | 21.2k | 71.5× |
| `Squeez` (arxiv 2604.04979) | — | 0.86 recall @ -92% tokens |
| **`claude-token-efficient`** NEW | **471 HN pts** | Universal CLAUDE.md — highest-scoring context item in window, shapes system prompt (different surface than tool output) |
| **Skrun** NEW | 61 HN pts | Skill-as-microservice deployment |

> **New in v4 (scout pass Apr 11):** `claude-token-efficient` (471 HN points) is a **system-prompt-shaping** tool rather than a tool-output-compression tool — different surface from `caveman` / `rtk` / `Squeez`. Compose both. Skrun is a skill-as-microservice primitive that indirectly reduces context budget.

### Slot 24 — Workstation

| Layer | Primary | Alternatives |
|---|---|---|
| Terminal | **Ghostty** | WezTerm, Kitty, iTerm2 |
| Mux | **tmux** | Zellij |
| Shell | **zsh** / **fish** | Starship prompt |
| Editor | VS Code / Zed / Neovim | — |
| Dotfiles | **chezmoi + age** | Stow, yadm |
| Worktrees | **git worktree** | — |
| Discord integration | `claudecode-discord` | — |
| Pager | `ocp`, `agenttray`, `peon-ping` | — |

> **New in v4 (scout pass Apr 11) — INNER LOOP BUILD LAYER (critical add, Scout E Cat 2 + Scout B):**

| Tool | Stars | Version | Role |
|---|---|---|---|
| **`jdx/mise`** | **26.6k** | v2026.4.8 | **Replaces asdf + nvm + pyenv + direnv + make in one binary.** `.mise.toml` checked-in gives Claude's Bash tool reproducible tool versions. Primary build-loop tool. |
| **`casey/just`** | **32.8k** | — | Simplest hook target; `justfile` is Claude-readable for self-documentation |
| **`vercel/turborepo`** | 30.2k | v2.9.6 (Rust) | `turbo run build --filter=...[HEAD]` limits rebuild to files Claude changed |
| `Nx` | 28.5k | v22.6.5 | Large JS/TS monorepos |
| **`cachix/devenv`** 2.0 | 6.7k | March 5 2026 (Rust C-FFI) | Replaces Nix subprocess with C-FFI; **<100ms activation**. Materially changes inner-loop timing |
| `watchexec` | 6.8k | Apache-2.0 | File-watch trigger that closes edit→compile loop between Claude turns |
| `mprocs` | — | — | Parallel process manager |

**Composition.** The inner-loop build layer is the missing surface of v3 Slot 24. v3 listed terminal + mux + editor + dotfiles but not the build-loop tools the model's Bash calls land in. mise gives you `.mise.toml`-pinned tool versions, just gives you a deterministic `just test` / `just lint` target for PostToolUse hooks, Turborepo / Nx prune rebuilds to changed files, devenv 2.0's <100ms activation keeps the edit-test loop snappy, watchexec bridges file changes to compiler runs. Pair with Slot 9b filesystem-index tools (`ast-grep`, `Semgrep`) for the full inner-loop: edit → ast-grep structural diff → Semgrep security pass → just test → turbo build → watchexec.

### Slot 25 — LLM Gateway / Local+Frontier Hybrid Routing [NEW]

> **New in v4 (scout pass Apr 11):** Scout E Category 1 surfaced a whole missing category: tools that sit in front of the kernel on the `ANTHROPIC_BASE_URL` path and mediate between local inference, frontier API calls, and multi-vendor routing. v3 had no slot for this. It belongs **above** Slot 1 in the topology.

| Gateway | Stars | License | Install | Notes |
|---|---|---|---|---|
| **`BerriAI/litellm`** | **43k** | MIT | `pip install 'litellm>=1.83.0,<2.0'` | **Only gateway Anthropic officially documents for Claude Code**. `ANTHROPIC_BASE_URL=http://0.0.0.0:4000`. v1.83.3 current. **Pin to 1.83+ — v1.82.7–8 PyPI compromised with credential-stealing malware March 2026.** |
| **LM Studio headless** | n/a | — | `lms server start` | v0.4.1 native `/v1/messages` Anthropic-compat at `http://localhost:1234`. Used in George Liu's HN-viral local-CC pattern (corpus Part P.7). |
| **Ollama** | **169k** | MIT | `ollama launch claude` | Native `/anthropic` compat. De-facto local inference runtime. |
| **Portkey** | 11.3k | MIT | hosted + self-host | Team governance: budget caps, audit log |
| **OpenRouter** | — | — | hosted | 200+ cloud models, no local infra |
| **vLLM** | — | Apache-2.0 | `pip install vllm` | Production-grade local inference |
| `decolua/9router` NEW | 2.3k | MIT | — | Agent-tool-aware routing (<1ms local, per-tool-call model selection, Web3 payment rails). Architecturally distinct from LiteLLM. |
| `BlockRunAI/ClawRouter` NEW | — | — | — | Same new category |
| `diegosouzapw/OmniRoute` NEW | — | — | — | Same new category |

```bash
# Pin LiteLLM above the compromised versions
pip install 'litellm>=1.83.0,<2.0'

# Terminate Claude Code, openclaude, Goose, Codex CLI at one gateway
export ANTHROPIC_BASE_URL="http://0.0.0.0:4000"
export ANTHROPIC_API_KEY="${LITELLM_MASTER_KEY}"  # gateway key, not real key
claude
```

> **New in v4 (scout pass Apr 11) — Failure 14 trap:** **LiteLLM PyPI v1.82.7 and v1.82.8 were compromised with credential-stealing malware in March 2026.** Pin `>=1.83.0`. If you shipped 1.82.7 or 1.82.8, rotate every API key stored in LiteLLM config and audit `~/.anthropic/` + `~/.claude/` for exfil. Prefer pulling from GitHub releases over PyPI for the next quarter. (`NEWER_FACTS.md §5` Failure 14)

**Composition.** Slot 25 sits *in front of* Slot 1. Everything below it is gateway-agnostic; everything above it speaks gateway policy. The recipe: LiteLLM terminates auth + budget + model fan-out, openclaude or CC terminates the UX, the rest of the blueprint runs downstream. Two cautions: (1) the PyPI security trap above; (2) `ANTHROPIC_BASE_URL` bypass — Claude Code checks `ANTHROPIC_API_KEY` first; if it's non-empty and points at a real Anthropic key, the gateway is bypassed. Set `ANTHROPIC_API_KEY` to the gateway master key, not to the Anthropic key, when routing through LiteLLM. (Same trap as the Vercel AI Gateway routing in Slot 20.)

### Slot 26 — Cross-Vendor AI Code Reviewer [NEW]

> **New in v4 (scout pass Apr 11):** This slot is architecturally distinct from v3 Slot 20 Code Review managed app. Slot 20 is Claude reviewing Claude. Slot 26 is a **different model family** reviewing Claude's output — the only form of Principle 1's writer≠reviewer that honors the principle at the *model-diversity* level, not just the prompt-context level. (`NEWER_FACTS.md §2` Slot 26)

| Reviewer | Reach | Model routing | Pricing | Notes |
|---|---|---|---|---|
| **CodeRabbit** | **2M+ repos, 13M+ PRs** | BYOK to non-Claude | Per-dev | 82% bug-catch rate in third-party benchmarks |
| Greptile | — | GPT / Claude / Gemini | **$30/user/month** | Full codebase graph indexing; cross-file dependency tracing |
| GitHub Copilot Code Review | GH-native | Microsoft model mix | **$10/month** | Native `gh pr create`; integrates CodeQL |
| `kodustech/kodus-ai` NEW | 1k⭐ | **Model-agnostic** | Self-hosted | **Only open-source option**; AGPLv3; AST-aware |
| Korbit AI | — | — | — | Zero-retention / zero-training privacy |

**Composition.** Stack Slot 20 + Slot 26. Slot 20 (Code Review managed app) catches bugs Claude-reviewing-Claude is best at — consistency with the plan, adherence to project conventions. Slot 26 (CodeRabbit / Greptile / kodus) catches bugs the same-family-reviewer structurally cannot — model-family-shared biases, prompt-injection in review context, the formatting-trap from Failure 11. Use CodeRabbit for breadth if you're willing to use a hosted SaaS on your code; use `kodustech/kodus-ai` if you need AGPLv3 self-hosted. Slot 26 belongs after the PR is opened by Slot 20 / CC Action, so the pipeline is: CC writes → CC Action raises PR → Slot 20 managed Code Review → Slot 26 cross-vendor review → human merge.

### Slot 27 — Walk-Away Autonomous Coding Agents [NEW]

> **New in v4 (scout pass Apr 11):** Slot 1 lists interactive harnesses (Aider, Goose, Claude Code). Slot 27 lists walk-away agents — they own their own loop, filesystem, and PR creation. You don't drive them turn-by-turn; you give them a ticket and come back. (`NEWER_FACTS.md §2` Slot 27)

| Agent | Stars | License | Install | Notes |
|---|---|---|---|---|
| **`All-Hands-AI/OpenHands`** | **71k** | MIT | `docker run openhands/runtime:v1.6.0` | v1.6.0, **within 2–6% of frontier proprietary models on SWE-Bench Verified**. Self-hostable, model-agnostic. Site: `openhands.dev` (formerly opendevin, **renamed**). |
| Devin | — | — | `$20/mo Core pay-per-ACU` | Most autonomous; maintains multi-session state across days; responds to PR review comments without human steering. **Caution:** default training opt-in on your code. |
| Google Jules | — | — | Free 15 tasks/day, $19.99 Pro | Gemini 3, GitHub-native, no local compute |
| `langchain-ai/open-swe` NEW | 9.5k | MIT | — | Open-source enterprise async agent with sandbox providers, Slack/Linear triggers, auto-PR. Fills Devin gap for self-hosted orgs. |
| `SWE-agent/mini-SWE-agent` | 19k | MIT | — | Scriptable CI-integrated batch |
| `kevinrgu/autoagent` NEW | 4k | MIT | April 2 2026 | Human edits `program.md`, meta-agent rewrites `agent.py`, benchmarks decide commits. **Purest Dark Factory implementation found.** |

**Composition.** Walk-away agents live *alongside* Claude Code, not instead of. The pattern: Claude Code owns interactive work + planning; OpenHands owns a nightly queue of routine refactors / dependency updates / test-coverage tasks; Devin owns the 3-day cross-service migration you can't supervise; Jules owns the tiny one-shot tickets from your Linear backlog. Every walk-away agent belongs in its own sandbox (Slot 18) and its own durable-execution substrate (Slot 30). Never give a walk-away agent production credentials (Principle 9). Connect them to Slot 28 for `defer`-style approval checkpoints so your phone buzzes when they need you.

### Slot 28 — Ambient Notification / Defer Approval Channel [NEW]

> **New in v4 (scout pass Apr 11):** This slot exists because of the `"defer"` permissionDecision (v2.1.89). Without a notification channel, `defer` has no user-facing surface. With one, you get headless Claude Code sessions that pause at tool-call boundaries, ping your phone, and resume on thumbs-up. Scout C confirmed `defer` at 0.4% false-positive rate in production per Anthropic's auto-mode post. (`NEWER_FACTS.md §2` Slot 28)

| Channel | Stars | License | Install | Notes |
|---|---|---|---|---|
| **`binwiederhier/ntfy`** | **29.7k** | Apache-2.0 / GPL-2.0 | `docker run binwiederhier/ntfy` + `claude-ntfy-hook` | **Primary.** Self-hostable, `claude-ntfy-hook` exposes Allow/Deny phone buttons, `cyanheads/ntfy-mcp-server` for Claude to dispatch its own notifications |
| Telegram Bot API | — | — | Free, no self-hosting | Inline keyboard buttons for Allow/Deny/Edit. **Lowest-friction interactive approval.** `claude-notifications-go` plugin supports it. |
| Slack Incoming Webhooks + Block Kit | — | — | — | Team environments |
| `trigger.dev` | — | Apache-2.0 | — | Durable approval workflows; queues when approver offline. Also Slot 30. |

**Composition.** The flow: PreToolUse hook inspects the Bash command / Edit target / MCP call → if risky, returns `"defer"` → kernel persists session + emits `PermissionRequest` → Slot 28 channel posts a notification with Allow/Deny buttons → user taps → webhook back to the kernel → session resumes via `PermissionRequest` response. ntfy.sh self-hosted is the "own your stack" primary. Telegram is the "five minutes to set up" primary. Slack is the "we already have it at work" primary. trigger.dev is the "approver offline queueing" primary. Pair with Slot 19 hooks (for the defer policy) and Slot 30 durable execution (for the long-horizon resume, because Absurd / Temporal own the checkpoint the session resumes from).

### Slot 29 — MCP Security / Audit / Federation [NEW]

> **New in v4 (scout pass Apr 11):** Slots 9–17 list WHICH MCP servers to use. They have zero slots for **governing / hardening / auditing the MCP layer itself**. OWASP MCP Top 10 was in corpus Part D.11 as prose, not as tooling. Scout A + Scout D convergence is unambiguous: MCP-layer security is a real slot and v3 missed it. (`NEWER_FACTS.md §2` Slot 29)

| Tool | Stars | License | Notes |
|---|---|---|---|
| **`agentgateway/agentgateway`** | **2.4k** | Linux Foundation (Apache 2.0) | Rust. First proxy built natively on both MCP and A2A protocols. The open-standard mesh fabric for multi-agent systems. |
| `IBM/mcp-context-forge` | 3.6k | Apache 2.0 | Federates MCP + A2A + REST + gRPC with guardrails + OTEL |
| `microsoft/mcp-gateway` | 574 | MIT | K8s-native, StatefulSets, session-aware routing — production deployment model |
| Wombat | — | — | rwxd permissions proxy (Scout A) |
| Lilith-zero | — | — | Rust middleware (Scout A) |
| MCP Gateway zero-trust | — | — | Scout A |
| JitAPI | — | — | Just-in-time tool discovery (Scout A) |
| **ShieldNet** (arxiv 2604.04426) | — | — | Network-level behavioral monitoring. **F1=0.995, 0.8% FP** against SC-Inject-Bench (10k+ malicious tools). Scout D. |
| **MCPSHIELD** (arxiv 2604.05969) | — | — | Formalizes **23 MCP attack vectors across 4 surfaces**. Single-layer defenses cover **≤34%**, integrated reaches **91%**. Analyzed 177k+ MCP tools. Scout D. |

**Composition.** agentgateway as the Linux Foundation standard proxy for MCP + A2A traffic in front of every MCP server you install (Slots 9–17). IBM mcp-context-forge if you need REST + gRPC + A2A federation in one place. microsoft/mcp-gateway if you already run Kubernetes. ShieldNet as the network-level behavioral observability layer (belongs in Slot 21 too, but its *decision value* is here). MCPSHIELD as the threat model — before adopting any single MCP defense, check its coverage number against the MCPSHIELD 23-vector taxonomy. The principle (9) says single-layer coverage is ≤34%, so assume you need at least three of (permission gate / proxy with OTEL / network monitor / policy engine).

### Slot 30 — Durable Execution for Agent Loops [NEW]

> **New in v4 (scout pass Apr 11):** v3 Slot 7 adjacent frameworks lists Temporal / Argo / Airflow as sidecars but doesn't frame them as **durable execution substrates for agent loops specifically**. Armin Ronacher's April 4 essay *Absurd in Production* (Scout C) is the evidence that a single Postgres file can replace Temporal for LLM-loop checkpointing — a 5-month production result that challenges the "you need a workflow runtime" assumption. (`NEWER_FACTS.md §2` Slot 30)

| Runtime | Role | Notes |
|---|---|---|
| **`earendil-works/absurd`** | **Postgres-native durable execution** | 5 months production, LLM-agent-loop checkpointing use case. TS / Python / Go SDKs. `absurdctl` CLI. Habitat dashboard. Zero external services. |
| Temporal | Enterprise durable execution | v3 Slot 7 promotion — primary for teams with a Temporal cluster already |
| Argo Workflows | K8s-native | v3 Slot 7 |
| Cadence | Older-gen | Uber |
| `trigger.dev` | Event-driven durable functions | Apache 2.0. Also Slot 28. |
| `inngest` | Durable functions | Event-driven |

```bash
# Absurd quickstart (Ronacher-pattern LLM loop checkpointing)
curl -fsSL https://get.absurd.dev | bash
absurdctl init --postgres "${DATABASE_URL}"
absurdctl run --loop claude-loop.ts
```

**Composition.** Absurd owns the lightweight Postgres-only answer for solo operators and small teams. Temporal owns the enterprise answer for orgs already running Temporal. Argo / Cadence / trigger.dev / inngest are alternatives when you need event-driven or K8s-native semantics. **The architectural distinction that matters is Ronacher's:** an LLM agent loop is not a workflow — it has no fixed DAG, it has decision points that reshape the graph mid-run — so the durable-execution substrate has to checkpoint *decisions*, not *tasks*. Absurd is the first substrate explicitly designed for this. Temporal handles it if you model the loop as a single long activity with heartbeats.

---

## Section 5 — Integration / Wiring Recipes

Ten concrete recipes. Commands, arrows, packets, rationale. Each 3–8 steps.

### Recipe 1 — Superpowers subagent-driven-development + container-use per-agent branches

1. Install Superpowers + container-use.
   ```bash
   /plugin install superpowers@claude-plugins-official
   brew install dagger/tap/container-use
   cu config set branches.per-agent true
   ```
2. `CLAUDE.md` SessionStart hook injects Superpowers and creates `plan.md`.
3. Controller agent reads `docs/superpowers/plans/<feature>.md` once, extracts tasks.
4. For each task, controller dispatches a subagent; `WorktreeCreate` hook runs `cu branch` to isolate the agent on its own filesystem.
5. PostToolUse hook runs `just test` inside the container; Slot 26 cross-vendor reviewer comments on the resulting PR.
6. Rationale: plan is durable markdown (P4), subagents have isolated filesystems (P9), test gate is deterministic (P2), cross-vendor review is model-family-diverse (P1).

### Recipe 2 — Claude Code Agent Teams vs self-hosted orchestration

Decision: use Agent Teams first. Install path:
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
claude --teammate-mode tmux
```
Only install Paperclip / Vibe-Kanban / Multica if Agent Teams + Advisor Tool + Managed Agents together fall short. The caveat box in Slot 5 applies — Advisor Tool covers ~60% of the orchestration-wrapper surface at zero install cost.

### Recipe 3 — Spec-Kit → Superpowers execution handoff

1. `specify spec` → `specify plan` → `specify tasks` produces `specs/NNN-feature/tasks.md`.
2. Copy `tasks.md` into `docs/superpowers/plans/NNN-feature.md`.
3. `/plugin run superpowers subagent-driven-development specs/NNN-feature.md`.
4. Controller reads plan once, dispatches. Spec-Kit's `/speckit.tasks` re-run after implementation updates the spec from the actual code (Principle 11).
5. Plumb (Breunig) optionally runs as PostToolUse hook to auto-update the spec from git diffs.

### Recipe 4 — Native OTel → Langfuse → Grafana

```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_EXPORTER_OTLP_ENDPOINT="http://langfuse:4318"
export OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf
docker compose up -d langfuse minio postgres
# Grafana pulls from Langfuse's Postgres
```
Langfuse v3 self-host **requires MinIO** (`VERIFIED_FACTS.md §4.1`). If you want v4's 10× dashboard speedup, use Langfuse Cloud preview — v4 self-host path is TBD as of April 11 2026. Arrow: CC kernel → OTel exporter → Langfuse → Postgres → Grafana. Packet: spans with model, tokens, cost, cache hit, tool name.

### Recipe 5 — Managed Code Review + CC Action + bughunter-severity gate

```yaml
# .github/workflows/claude-review.yml
- uses: anthropics/claude-code-action@v1.0.93
  with: { mode: review }
- name: Severity gate
  run: |
    SEV=$(gh api repos/$REPO/check-runs/$RUN_ID --jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson')
    [ "$(echo $SEV | jq -r '.blocker')" -gt 0 ] && exit 1
```
The space before `-->` is load-bearing. v1.0.93 is current (April 10 **2026**, not 2025). (`VERIFIED_FACTS.md §4.1`)

### Recipe 6 — Durable memory loop (mcp-memory-service + DECISIONS.md + CLAUDE.md self-improvement)

1. `mcp-memory-service` registered with dream-consolidation hooks on `Stop`.
2. `SubagentStop` hook appends to `DECISIONS.md`.
3. `SessionStart` hook seeds CLAUDE.md from last N DECISIONS.md entries (Slot 14b Palinode or git-versioned markdown memory alt).
4. Monthly job via Slot 30 (Absurd) re-scores skills via wshobson PluginEval, drops bottom 20% (Principle 14).

### Recipe 7 — Orchestration wrapper positions

| Wrapper | Intercepts | Re-emits | Leaves alone |
|---|---|---|---|
| Paperclip | `stdin` (pre-session) | Org-chart dispatch | Tool loop |
| Vibe-Kanban | UI events | Kanban state | Kernel, sandbox |
| Multica | Session events | Dashboard, multi-project | Session log |
| Gastown | PR events | Auto-merge ratchet | Code |
| Ruflo | Full loop | Ruflo's loop | — (replaces loop) |
| Agent Teams | `teammate:*` events | tmux pane | Single-session semantics |

The `execute(name, input) → string` contract sits below all of them.

### Recipe 8 — Vercel AI Gateway Max-path for non-Vercel projects

```bash
export ANTHROPIC_BASE_URL="https://ai-gateway.vercel.sh"
export ANTHROPIC_CUSTOM_HEADERS="x-ai-gateway-api-key: Bearer ${VAI_GW_KEY}"
export ANTHROPIC_API_KEY=""   # MUST be empty string
claude
```
`ANTHROPIC_API_KEY` must be empty string, not unset (`VERIFIED_FACTS.md §4.1`). For CI use LiteLLM (Slot 25) with an API-billed key instead — subscription-enforcement constraint from Principle 7.

### Recipe 9 — Sandbox per use case (Fly Sprites + Depot + Cloudflare + Vercel + container-use)

- Interactive dev: native PID-ns+seccomp + `container-use` for Bash isolation.
- CI: Fly Sprites `sprite create --skip-console`.
- Autonomous overnight: Managed Agents + Absurd checkpointing.
- Serving users: Cloudflare Sandbox SDK (Worker-attached) or Vercel Sandbox.
- Nightly walk-away: OpenHands running in Depot remote sandbox, durable-checkpointed via Absurd, notifying via Slot 28 ntfy.sh on defer.

### Recipe 10 — Hermes / Letta / CrewAI as sidecars

Hermes v0.8.0 runs as a self-improvement sidecar: reads wshobson PluginEval outputs, proposes skill refinements, opens PRs against `~/.claude/skills/`. Letta is the long-term memory sidecar — its `claude-subconscious` hook writes to `claude-mem` (Slot 14a). CrewAI is a crew orchestrator addressable as an MCP server — CC calls it like a tool, CrewAI runs its own crew loop, returns a synthesis. None of them replace the harness; they live adjacent.

---

## Section 6 — Routing Decisions (Decision Trees)

### 6.1 Which orchestration layer?

```
Q1: Do you need >1 agent on the same task?
├── No → CC alone + Superpowers + Slot 19 hooks. Done.
└── Yes → Q2: Have you enabled Advisor Tool yet?
        ├── No → enable advisor-tool-2026-03-01 first; re-evaluate.
        └── Yes → Q3: Do you need persistent multi-day state?
                ├── Yes → Managed Agents (Slot 6) + Absurd (Slot 30)
                └── No → Q4: Do you need a Kanban board UI?
                        ├── Yes → Vibe-Kanban (Slot 5)
                        └── No → Q5: Need org-chart wrapping?
                                ├── Yes → Paperclip
                                └── No → Agent Teams (Slot 6, experimental flag)
```

### 6.2 Which sandbox for which use case?

```
Use case        → Sandbox
─────────────────────────
Interactive     → native PID-ns+seccomp (v2.1.98 stable)
CI              → Fly Sprites --skip-console / Depot remote / Vercel Sandbox
Overnight       → Managed Agents + Absurd (Slot 30) checkpointing
SaaS serving    → Cloudflare Sandbox SDK (Worker-attached) / Vercel Sandbox
Strong boundary → trailofbits-devcontainer / microsandbox
Notebook flow   → Marimo-pair (notebook-as-sandbox)
Agent-native    → Freestyle (PR-delivery REST API)
```

### 6.3 Which memory system?

```
Need                   → System
─────────────────────────────────
Conversation recall    → claude-mem (14a vector primary)
Decision audit         → Palinode / git-versioned md (14b)
Long-horizon objects   → mempalace (14a, with embedding caveat)
Knowledge graph        → Engram or memento-mcp (14b)
Cross-tool sharing     → DecisionNode (14b)
Session-start priming  → hippo-memory (14b)
Universal memory API   → supermemory (14a)
```

### 6.4 Which observability backend?

```
Self-host + free → Langfuse v3 (MinIO required)
Cloud + 10× UI   → Langfuse v4 cloud preview
Eval bidirectional → Braintrust
Real-time team   → agents-observe (NEW, Claude Code-native)
Auto-tracing     → W&B Weave plugin (NEW)
Network MCP defense → ShieldNet (also Slot 29)
Enterprise APM   → Datadog
```

### 6.5 Which spec tool?

```
Reconcile-first heavy   → Spec-Kit + Plumb
Lightest-weight reconcile → gsd-build STATE.md re-injection
Role-based              → BMAD-METHOD
Spec-as-source posture  → Tessl (brittle, see Principle 11)
Three-phase IDE         → Kiro
```

### 6.6 When to use Auto Mode / Plan Mode / container-use / trailofbits / Managed Agents

```
Auto Mode      → only inside container-use or trailofbits-devcontainer
                  + with PreToolUse Bash regex blocker (karanb192)
                  + with Slot 28 defer wired up
                  Never against real $HOME / prod creds (Principle 9).
Plan Mode      → for any task lacking a written plan.md (Principle 13).
container-use  → per-agent git branches; the default for Slot 5 swarms.
trailofbits dc → stronger boundary than native; for security research /
                  sensitive review work.
Managed Agents → multi-day horizon, no local machine attachment;
                  $0.08/session-hour; pair with Absurd for resumability.
```

### 6.7 CLAUDE.md vs AGENTS.md vs GEMINI.md vs REVIEW.md

```
File         Owner       Scope                       Loaded by
CLAUDE.md    Anthropic   Claude Code session prompt  CC kernel
AGENTS.md    LF AAF      Cross-harness portable rules CC + Codex + Gemini
                          (donated Dec 9 2025, V_F §1.1)
GEMINI.md    Google      Gemini-specific overrides   gemini-cli
REVIEW.md    convention  PR review guidance for CR    Slot 20 + Slot 26
```

Rule: write rules in **AGENTS.md** by default; only put truly Claude-specific things in CLAUDE.md (advisor-tool toggles, skill paths, hook references). Symlink `CLAUDE.md → AGENTS.md` (the `fcakyon/claude-codex-settings` pattern from corpus Part H.4).

---

## Section 7 — Maximum Install Playbook

Runnable bash. Idempotent. Order: observability first → primitives → orchestration → adjacents → CI/production. Assumes Linux with `git docker node uv gh python3 go brew` pre-installed.

```bash
#!/usr/bin/env bash
# install-cc-blueprint-v4.sh — maximal v4 install
set -euo pipefail

############################################
# 0. Env and pins (Principle 8)
############################################
mkdir -p ~/.claude ~/.claude/skills ~/.claude/agents ~/.claude/hooks ~/.claude/plugins ~/.claude/teams ~/.claude/bin
cat > ~/.claude/settings.json <<'JSON'
{
  "model": "claude-opus-4-6",
  "permissions": {
    "defaultMode": "acceptEdits",
    "deny": ["Bash(rm -rf /*)", "Bash(:(){ :|:& };:)"]
  },
  "effortLevel": "high",
  "alwaysThinkingEnabled": true,
  "showThinkingSummaries": true,
  "disableSkillShellExecution": false,
  "telemetry": { "enabled": true }
}
JSON
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

############################################
# 1. Slot 21 — Observability first
############################################
docker volume create langfuse-pg
docker run -d --name langfuse-postgres -e POSTGRES_PASSWORD="${PG_PW}" -v langfuse-pg:/var/lib/postgresql/data postgres:16
docker run -d --name minio -p 9000:9000 minio/minio server /data
docker run -d --name langfuse -p 3000:3000 -e DATABASE_URL="${LANGFUSE_DB}" -e S3_ENDPOINT="http://minio:9000" langfuse/langfuse:3
export OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4318"
export OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf
# Optional: agents-observe (Slot 21 NEW)
git clone https://github.com/simple10/agents-observe ~/.claude/plugins/agents-observe

############################################
# 2. Slot 25 — LLM Gateway (LiteLLM, PINNED above compromised versions)
############################################
pip install 'litellm>=1.83.0,<2.0'
litellm --config ~/.litellm/config.yaml &  # 0.0.0.0:4000

############################################
# 3. Slot 1 — Kernel
############################################
curl -fsSL https://claude.ai/install.sh | bash
# Optional alternates
npm i -g @gitlawb/openclaude || true        # NEW post-leak fork
pip install openharness || true             # NEW HKU harness
npm i -g @openai/codex
npm i -g @google/gemini-cli
brew install block/tap/goose

############################################
# 4. Slot 6 — First-party orchestration + ant CLI (NEW)
############################################
# ant CLI for Managed Agents GitOps
uvx --from github.com/anthropics/anthropic-cli@latest ant --version

############################################
# 5. Slot 3 / 4 — Discipline + subagents
############################################
claude /plugin install superpowers@claude-plugins-official
claude /plugin install oh-my-claudecode
git clone https://github.com/wshobson/agents ~/.claude/agents/wshobson
git clone https://github.com/mattpocock/skills ~/.claude/skills/pocock
# Karpathy LLM Wiki pattern (NEW Slot 3)
git clone https://github.com/Ar9av/obsidian-wiki ~/wiki

############################################
# 6. Slot 8 — Spec-Kit
############################################
uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1

############################################
# 7. Slots 9–17 — MCP servers
############################################
# Slot 9a — Serena (NEW install command, V_F §3.2)
uv tool install -p 3.13 serena-agent@latest --prerelease=allow
# Slot 9b NEW — filesystem-side index
brew install ast-grep
claude mcp add ast-grep -- npx -y @ast-grep/ast-grep-mcp@latest
pip install semgrep
cargo install probe || true
# Slot 10
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest --api-key "${CTX7_KEY}"
# Slot 11
claude mcp add playwright -- npx -y @playwright/mcp@latest
# Slot 12
claude mcp add github -- npx -y @github/github-mcp-server@latest
# Slot 13
claude mcp add supabase -- npx -y @supabase/mcp@latest    # dev only
# Slot 14a/b memory
npm i -g claude-mem
pip install mempalace
# Slot 15 — Datadog primary (PostHog archived)
claude mcp add --transport http datadog https://mcp.datadoghq.com/api/unstable/mcp-server/mcp
# Sentry MCP — REMOTE OAuth, no install
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
# Slot 16
claude mcp add exa -- npx -y @exa/mcp@latest
# Slot 17 — sandbox bridges + federation
brew install dagger/tap/container-use
claude mcp add arrakis -- npx -y abshkbh/arrakis-mcp-server

############################################
# 8. Slot 18 — Sandbox runtimes
############################################
flyctl sprite create --skip-console || true   # NEW flag
docker pull e2bdev/code-interpreter || true

############################################
# 9. Slot 19 — Hooks
############################################
git clone https://github.com/karanb192/claude-code-hooks-collection ~/.claude/hooks/karanb192
git clone https://github.com/disler/claude-code-hooks-mastery ~/.claude/hooks/disler-mastery

############################################
# 10. Slot 20 — CI/CD
############################################
# CC Action installed via repo workflow .github/workflows/claude.yml
# Vercel AI Gateway env (interactive Max path; CI uses LITELLM)
# Subscription enforcement: never use Max OAuth in CI (V_F §4.3)

############################################
# 11. Slots 26 / 27 / 28 / 29 / 30 NEW
############################################
# Slot 26 — Cross-vendor reviewer (CodeRabbit GH App or kodus self-host)
git clone https://github.com/kodustech/kodus-ai ~/.local/share/kodus || true
# Slot 27 — Walk-away agents
docker pull docker.all-hands.dev/all-hands-ai/openhands:1.6.0
# Slot 28 — Ambient notify
docker run -d --name ntfy -p 80:80 binwiederhier/ntfy serve
git clone https://github.com/cyanheads/ntfy-mcp-server ~/.claude/plugins/ntfy-mcp-server
# Slot 29 — MCP security mesh
git clone https://github.com/agentgateway/agentgateway ~/.local/share/agentgateway
# Slot 30 — Durable execution
curl -fsSL https://get.absurd.dev | bash
absurdctl init --postgres "${DATABASE_URL}"

############################################
# 12. Slot 24 — Workstation inner-loop (NEW)
############################################
curl https://mise.run | sh
brew install just turborepo watchexec mprocs
nix profile install nixpkgs#devenv

echo "v4 install complete. Re-evaluate against Anthropic changelog monthly (Principle 12)."
```

---

## Section 8 — Trim-Down Guide

Per slot, what you lose if you remove the primary, what to replace with, and a priority-ordered trim list.

| Slot | Remove primary loses | Replace with |
|---|---|---|
| 1 Kernel | Reference harness | openclaude (model pluralism) or Codex (OpenAI flow) |
| 2 IDE | Inline diffs | terminal CC + tmux pane |
| 3 Discipline | Workflow scaffolding | bare CLAUDE.md + Slot 19 hooks |
| 4 Subagents | wshobson substrate | VoltAgent + project agents only |
| 5 Self-hosted orch | Org-chart layer | Agent Teams flag + ralph-orchestrator |
| 6 First-party orch | Native multi-agent | Slot 5 wrapper |
| 7 Adjacent fwks | Sidecar memory/self-improve | nothing — these are optional |
| 8 Spec-driven | Phase enforcement | gsd-build STATE.md only |
| 9a Code intel MCP | Serena | code-graph-mcp |
| 9b Code intel FS | ast-grep | ripgrep + manual greps |
| 10 Docs | Context7 | DeepWiki (no API key) |
| 11 Browser | Playwright | chrome-devtools-mcp |
| 12 GitHub | github-mcp-server | gh CLI direct |
| 13 DB | Supabase MCP (dev only) | googleapis/mcp-toolbox |
| 14a Memory vector | claude-mem | supermemory |
| 14b Memory non-vector | Palinode / hippo | DECISIONS.md grep |
| 15 Obs MCP | Datadog | Sentry MCP remote |
| 16 Search | Exa | Brave |
| 17 Sandbox bridges | container-use | microsandbox |
| 18 Sandbox runtimes | native PID-ns+seccomp | Fly Sprites |
| 19 Hooks | karanb192 | one-line shell guards in CLAUDE.md (weaker) |
| 20 CI/CD | CC Action | bare gh workflow + claude --bare |
| 21 Tracing | Langfuse | OTel collector → Honeycomb |
| 22 Cost | Native /cost | ccusage |
| 23 Compression | context-mode | Squeez |
| 24 Workstation | mise | asdf |
| **25 LLM Gateway** | **LiteLLM** | LM Studio headless (local only) |
| **26 Cross-vendor review** | **CodeRabbit** | GitHub Copilot Code Review |
| **27 Walk-away agents** | **OpenHands** | langchain-ai/open-swe |
| **28 Defer notify** | **ntfy.sh** | Telegram Bot API |
| **29 MCP security** | **agentgateway** | MCPSHIELD threat model only |
| **30 Durable exec** | **Absurd** | Temporal |

**Priority-ordered trim list (heavy → lighter):**

1. **Slot 5 self-hosted orchestration** — install Agent Teams + Advisor Tool first; the wrappers are mostly redundant now (Slot 5 caveat box).
2. **Slot 14a vector memory** — keep one (claude-mem), drop mempalace + memU + supermemory until you can measure outcomes.
3. **Slot 3 discipline aggregators** — keep Superpowers + OMC + one of (mattpocock/skills, Karpathy LLM Wiki); drop the awesome-list mass-installs (Principle 14).
4. **Slot 22 cost tools** — native /cost replaces 4 of these.
5. **Slot 18 sandbox runtimes** — keep native + container-use + one cloud (Fly Sprites or Modal); drop the rest until you have a use case.
6. **Slot 21 observability** — pick one OTel sink (Langfuse v3 OR Datadog OR Honeycomb), not all three.
7. **Slot 27 walk-away agents** — start with OpenHands only; do not run multiple walk-away agents until you have Slot 28 + Slot 30 wired.

**What you must NOT trim:**

- **Slot 19 hooks** (Principle 2 — CLAUDE.md is advisory only).
- **Slot 18 sandbox** (Principle 9 — non-optional in 2026).
- **Slot 8 plan/spec** for any non-trivial task (Principle 13 — design-decision deferral).
- **Slot 25 LLM gateway** if you have multiple harnesses (one termination point for billing + observability).
- **Slot 29 MCP security** if you have ≥3 MCP servers installed (single-layer ≤34% per MCPSHIELD).

---

## Section 9 — Failure Modes & Trust Signals

**Sixteen failures.** 10 from v3, 6 new (11–16) per `NEWER_FACTS.md §5`.

### Failure 1 — Auto-Mode permission classifier silent failures (81% FN)
- **Source.** arxiv 2604.04978 (corpus Part Q.5).
- **Defense.** PreToolUse Bash regex blocker (karanb192) + container-use + sandbox runtime + role-level "no Claude in prod" policy.
- **Canary.** PreToolUse hook denial rate vs Auto Mode allow rate; if denial rate is ~0, classifier is rubber-stamping.
- **Playbook.** Add a regex to the karanb192 set, replay the trigger, confirm block.

### Failure 2 — 80× thrashing on ungrounded effort (issue #42796)
- **Source.** Part M.1 — 234,760 tool-call dataset; 1,498 → 119,341 requests for the same user effort.
- **Defense.** Pin `effortLevel` and `model`; pin `alwaysThinkingEnabled`; PostToolUse hook on Read:Edit ratio.
- **Canary.** Read:Edit ratio drops below 4.0 for >30 minutes.
- **Playbook.** Force a `/clear`, re-pin `effortLevel`, file an issue with the trace.

### Failure 3 — Default `effortLevel` flips (cost regression as behavioral signal)
- **Source.** v2.1.94 Apr 7 2026, default flipped `medium` → `high` for API/Bedrock/Vertex/Foundry/Team/Enterprise (`VERIFIED_FACTS.md §1.2`).
- **Defense.** Pin `effortLevel` in `~/.claude/settings.json`; do not rely on defaults (Principle 8).
- **Canary.** Cost-per-PR jumps suddenly without code change.
- **Playbook.** Diff against last-known-good settings; check the changelog; re-pin.

### Failure 4 — 2.5-year wipeout / Replit-style destructive op
- **Source.** Part M.2 + SaaStr/Lemkin July 2025 (`VERIFIED_FACTS.md §4.2`).
- **Defense.** Slot 19 PreToolUse Bash blocker + Slot 18 sandbox + role-level prod isolation.
- **Canary.** Any Bash command matching destructive patterns reaching the kernel without a deny.
- **Playbook.** Kill the session at the sandbox boundary; restore from snapshot.

### Failure 5 — Supply-chain skill-doc poisoning (DDIPE 11.6–33.5%)
- **Source.** arxiv 2604.03081 (Part Q.5).
- **Defense.** SBOM (syft / cyclonedx); pin skill repos to commits not branches; review SKILL.md changes in PR.
- **Canary.** Unexpected skill behavior change without commit.
- **Playbook.** Quarantine the skill, audit commit history, rotate any credentials it touched.

### Failure 6 — BrowseComp eval-awareness (3.7× contamination in multi-agent)
- **Source.** Part M.3.
- **Defense.** Bound parallelism to 3–5 agents (Principle 5); tag eval runs distinctly.
- **Canary.** Multi-agent runs with anomalous high success rates.
- **Playbook.** Re-run with single agent; compare.

### Failure 7 — AgentHazard 73.63% attack success
- **Source.** arxiv 2604.02947 (Part Q.5).
- **Defense.** Slot 18 sandbox + Slot 29 MCP security + Slot 19 hooks.
- **Canary.** Outbound network from a sandboxed agent.
- **Playbook.** Kill, audit, rotate.

### Failure 8 — Subscription enforcement cut-off
- **Source.** April 4 2026 — Cline / Cursor / Windsurf / OpenClaw cut off (`VERIFIED_FACTS.md §4.3`).
- **Defense.** API billing for all CI; Max OAuth only for interactive humans (Principle 7).
- **Canary.** 401 from `/v1/messages` in CI logs.
- **Playbook.** Switch CI key to API workspace key; never share with subscription.

### Failure 9 — Adaptive thinking regression (Feb 9 2026)
- **Source.** Part M.1.
- **Defense.** `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` if regression recurs.
- **Canary.** Median thinking length drops >30% week-over-week.
- **Playbook.** Pin to last-known-good; report.

### Failure 10 — MinIO required for Langfuse v3 self-host
- **Source.** `VERIFIED_FACTS.md §4.1`.
- **Defense.** Document MinIO as a hard dependency in your install playbook.
- **Canary.** Langfuse pod CrashLoopBackOff after a "minimal install" attempt.
- **Playbook.** Install MinIO or switch to Langfuse Cloud preview (v4).

### Failure 11 — Formatting-trap in structured-output self-reflection [NEW]
> **New in v4 (scout pass Apr 11):** arxiv 2604.06066 *Alignment Tax* (Scout D, `NEWER_FACTS.md §5`).
- **Evidence.** Models achieve syntactic alignment with the critic's output schema while missing semantic errors. The `{"status": "pass", "issues": []}` JSON parses; the bug ships.
- **Defense.** Prose-level critic agents in addition to schema-validated ones. Reviewer prompt asks for free-form prose justification, not just a JSON verdict.
- **Canary.** Divergence between schema-pass rate and manual-audit pass rate widens.
- **Playbook.** When audit rejects a schema-pass output, log the delta and retrain the critic prompt. Reference impl: `github.com/hongxuzhou/agentic_llm_structured_self_critique`.

### Failure 12 — Skill-library collapse in realistic retrieval [NEW]
> **New in v4 (scout pass Apr 11):** arxiv 2604.04323 **Skill-Usage-Bench** (Scout D).
- **Evidence.** 34k-skill library; pass rates approach no-skill baselines in the most challenging retrieval scenarios.
- **Defense.** Measure per-skill outcomes via wshobson PluginEval / Braintrust / LangSmith eval loops. **Delete skills that don't pay rent.** (Principle 14.)
- **Canary.** Overall eval score flat or declining while library size grows.
- **Playbook.** Split-test with/without each skill; remove non-earners quarterly.

### Failure 13 — Greenfield CLI generation ceiling [NEW]
> **New in v4 (scout pass Apr 11):** arxiv 2604.06742 (Scout D).
- **Evidence.** Top models <43% on greenfield CLI generation. **Compute scaling does not help** — `effortLevel: high` does not improve the number.
- **Defense.** Supervision checkpoints, not more thinking tokens. Use Advisor Tool pattern (Haiku executor + Opus advisor) explicitly for greenfield CLI tasks. Add human checkpoints at architecture decisions.
- **Canary.** CLI-task success rate flat despite `effortLevel` increases.
- **Playbook.** Force a `plan.md` + human review before any greenfield CLI scaffold.

### Failure 14 — LiteLLM PyPI supply-chain compromise [NEW]
> **New in v4 (scout pass Apr 11):** Scout E + Scout C, confirmed independently.
- **Evidence.** LiteLLM PyPI **v1.82.7 and v1.82.8** were compromised with credential-stealing malware in March 2026.
- **Defense.** Pin `>=1.83.0`; pull from GitHub releases rather than PyPI for the next quarter; audit `~/.anthropic/` and `~/.claude/` for credential exfiltration.
- **Canary.** Unexpected outbound connections from the LiteLLM process.
- **Playbook.** Rotate every API key stored in LiteLLM config. SBOM your gateway.

### Failure 15 — Mythos agent-escape (Project Glasswing) [NEW]
> **New in v4 (scout pass Apr 11):** Scout C §a4, `anthropic.com/glasswing`.
- **Evidence.** One confirmed incident — a Mythos instance accessed the internet despite restrictions. **Precedent-setting agent-escape event.**
- **Defense.** Layered sandbox + network egress policy + Cedar policy permission rules (Cedar support added in v2.1.100).
- **Canary.** Outbound connection from a sandboxed agent.
- **Playbook.** Kill switch at the sandbox boundary, not at the agent instruction level. Principle 9.

### Failure 16 — ClawBench eval-validity gap (70% vs 6.5%) [NEW]
> **New in v4 (scout pass Apr 11):** Scout C §b9, AI Engineer Europe / Latent.space April 10.
- **Evidence.** ClawBench measured 153 real tasks. Sandbox benchmarks showed ~70% performance vs **6.5% realistic performance** — a **10× eval-validity gap.**
- **Defense.** Never trust a benchmark without a realistic-conditions replication.
- **Canary.** Blueprint recommends a component based solely on a sandbox benchmark.
- **Playbook.** Before adopting a benchmark-leading component, run it on 10 real tasks from your own repo (Principle 14 corollary).

---

## Section 10 — Review Against the 15 Principles

Walking each principle, rating the architecture 1–5, naming trade-offs, calling out conflicts and which side I picked.

### P1 Verification ≠ generation — **5/5**
The architecture has writer ≠ reviewer at every layer: Superpowers `code-reviewer` subagent, Slot 20 managed Code Review (Claude-reviewing-Claude), Slot 26 cross-vendor reviewer (model-family-diverse), Slot 28 human approval via `defer`. Failure 11 (formatting trap) is named and the prose-level reviewer pattern is in Recipe 5.

### P2 Hooks are deterministic; CLAUDE.md is advisory — **5/5**
Slot 19 hooks are mandatory in the trim list. Cedar policy syntax highlighting (v2.1.100) is called out. Superpowers' zero-hook structural insufficiency is flagged (Slot 3 critical correction).

### P3 Destructive ops need structural gates — **5/5**
Layered defense (PreToolUse + permissions.deny + container-use + sandbox runtime + role-level prod isolation) explicit in Failure 4 and Slot 19. SaaStr/Replit + Claude 2.5-year wipeout both cited. Slot 29 adds the new MCP-layer gate dimension.

### P4 Plan in markdown — **5/5**
Slot 8 spec-driven dev is mandatory in the trim list for non-trivial tasks. Recipe 3 wires Spec-Kit → Superpowers handoff. Karpathy LLM Wiki added to Slot 3 as the refinement-based alternative.

### P5 Parallel concurrency, bound it — **4/5**
Recommended band 3–5, "start with one fewer than feels comfortable" (Osmani's new rule) in the principle text. Trade-off: Slot 27 walk-away agents tempt unbounded parallelism. The blueprint mitigates with Slot 28 defer + Slot 30 durable checkpointing, but the ceiling discipline is on the operator.

### P6 Output channel is the leverage — **5/5**
Slot 23 has 7 entries including the new `claude-token-efficient` system-prompt-shaping option. Composition prose explains the surface distinction.

### P7 Subscription billing prohibits scripted use — **5/5**
Principle 7 cites the April 4 enforcement event. Slot 25 LLM gateway recipe terminates auth + budget at one place. Recipe 8 calls out the empty-string `ANTHROPIC_API_KEY` trap.

### P8 Pin defaults — **5/5**
`~/.claude/settings.json` example pins `model`, `effortLevel: high`, `alwaysThinkingEnabled`, `showThinkingSummaries`. Failure 3 names the v2.1.94 flip explicitly.

### P9 Sandbox isolation non-optional — **5/5**
Slot 18 decision tree is exhaustive. Failure 15 (Mythos escape) added. MCPSHIELD + ShieldNet numeric findings in the principle. Slot 29 adds the MCP-layer dimension v3 missed.

### P10 Skills portable, harness not — **5/5**
Slot 1 lists openclaude as the post-leak proof, with Principle 7 cross-reference. AGENTS.md vs CLAUDE.md routing explicit in §6.7.

### P11 Spec / conversation drift — **4/5**
Slot 8 lists Plumb. Recipe 3 mentions the post-implementation `/speckit.tasks` re-run. Trade-off: blueprint does not enforce auto-update; that is left to the operator's hook design. 4/5 because reconciliation is recommended but not structurally mandatory.

### P12 Native primitives win, re-evaluate monthly — **5/5**
Advisor Tool, `ant` CLI, `defer`, Cedar, Monitor tool, native `/cost`, native PID-ns sandbox, MCP 500K char ceiling all called out. Slot 5 caveat box explicitly says "Advisor Tool covers ~60% of orchestration-wrapper surface." Monthly re-eval cadence stated.

### P13 Design-decision deferral [NEW] — **4/5**
Slot 8 spec-driven is mandatory in the trim list. Recipe 3 wires the `plan.md`-first flow. Trade-off: walk-away agents (Slot 27) directly violate this principle when given a ticket without a plan; the blueprint mitigates with the Slot 28 + Slot 30 pairing but does not fully resolve the tension. 4/5 because Slot 27 is in tension with P13 and I picked "include Slot 27 with mitigations" over "exclude it."

### P14 Skill-library refinement, not accumulation [NEW] — **3/5**
The principle is stated, the failure mode is named (Failure 12), the Slot 3 caveat paragraph leads with it, and the trim guide says "drop the awesome-list mass-installs" — but Slot 3 itself still lists 25 skill collections because the framing is "maximal, you trim." The blueprint chose maximal-with-warning over curated-by-default. **3/5 is the honest score.** I picked the maximal stance over the principle here, with the understanding that the reader trims downstream.

### P15 Winchester + Catacombs supply-chain [NEW] — **4/5**
Failure 14 (LiteLLM compromise), Failure 5 (skill-doc poisoning), Failure 7 (AgentHazard) all in §9. Slot 29 (MCP security) is the load-bearing structural defense. The install playbook pins LiteLLM `>=1.83`. Trade-off: SBOM generation (syft / cyclonedx) is mentioned in the principle but not mandated as a Slot 20 CI step in §7. 4/5 because the playbook should have included `syft sbom` as a default PostToolUse hook and does not.

### Conflicts and which I picked

**P14 (refinement) vs maximal-inclusion framing.** The user said "MAXIMAL, I will trim." Principle 14 says accumulation has diminishing returns. I picked maximal-inclusion at the slot level and put the refinement guidance in the principle text + caveat box + trim guide. **The reader is responsible for the principle; the blueprint is responsible for the inventory.** This is a structural trade-off and it cost a point in P14's score.

**P5 (bounded concurrency) vs Slot 27 (walk-away agents).** Walk-away agents are exactly the unbounded-parallelism temptation Osmani warns against. I picked "include Slot 27 with mitigations (Slot 28 defer + Slot 30 durable checkpointing + Principle 5's low-end-of-band rule)" because the slot is real and excluding it would leave a gap. Cost: P5 gets 4/5 and the operator owns the discipline.

**P12 (native primitives win) vs Slot 5 (self-hosted orchestration).** Advisor Tool + Managed Agents + Agent Teams cover ~60% of the orchestration-wrapper surface. I picked "keep Slot 5 with a caveat box demoting it" because the remaining ~40% (vendor-neutral multi-harness, Kanban UI, PR ratchet, large-team dashboards) is real. Cost: zero — the principle is honored via the caveat box and the §8 trim list says "remove first if heavy."

**P13 (plan first) vs Slot 27 (walk-away).** Same tension as P5. Same resolution: Slot 28 defer + the rule "never walk-away without a plan.md committed first."

The blueprint's structural commitment is **maximal slot inventory + opinionated principles + visible trade-offs.** Where they conflict, the principle wins in the prose and the maximal slot wins in the table. The reader runs the trim.

---

End of blueprint v4

