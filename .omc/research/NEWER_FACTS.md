# NEWER_FACTS.md — Post-v3 Scout Synthesis, April 11 2026

*Synthesis of 5 parallel category-open scouts run after v3 shipped. Overrides both `RESEARCH_CORPUS.md` AND `VERIFIED_FACTS.md` where conflicts exist. The writer of `CLAUDE_CODE_BLUEPRINT_v4.md` must read this file, prefer it over prior inputs on any disagreement, and flag each new-since-v3 item with the pattern: `> **New in v4 (scout pass Apr 11):** <what> [source]`.*

**The 5 scouts:**
- Scout A — HN 2 weeks (`scout-hn-2weeks.md`)
- Scout B — GitHub trending 2 weeks (`scout-github-2weeks.md`)
- Scout C — Practitioner feeds + Anthropic blog (`scout-practitioners-14d.md`)
- Scout D — arxiv cs.AI/SE/LG/CR 7 days (`scout-arxiv-7d.md`)
- Scout E — 6 under-covered categories (`scout-categories-6.md`)

**v3 diagnosis:** v3's slot list (24 slots) came from `ARCHITECTURE_PROMPT.md` which was written before the corpus was frozen. The Phase 1 verify agents were **slot-scoped** and could not surface missing-category gaps. The Phase 8 scouts are **category-open** and did.

---

## 1. LOAD-BEARING ANTHROPIC-NATIVE OMISSIONS FROM v3

These are not "missing tools" — they are **missing primitives** that Anthropic shipped between April 4 and April 11 2026 that v3 does not name. Every one of them changes the kernel-level architecture of a Claude Code system.

### 1.1 Advisor Tool (public beta, April 9 2026)
- **What:** Server-side primitive pairing a fast executor (Haiku/Sonnet) with a high-intelligence advisor (Opus) in a **single** `/v1/messages` call.
- **Beta header:** `advisor-tool-2026-03-01`
- **Measured:** Haiku+Opus scored **41.2% on SWE-bench Multilingual vs 19.7% Haiku solo at 85% lower cost per task**.
- **Architectural impact:** This collapses the "route Opus for planning, Sonnet for execution" orchestration pattern into a server-side primitive. Previously required a discipline framework (Superpowers subagents, BMAD architect+dev, OMC modes, Agent Teams) to achieve; now it's native in the harness. **Downgrades much of v3 Slot 3 discipline framework from "primary architecture" to "supplementary workflow."**
- **Source:** `platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool`, `claude.com/blog/the-advisor-strategy`
- **Writer directive:** Add a dedicated §1 mental model paragraph on Advisor as the new executor/advisor primitive. Update §2 Principle 1 (verification bottleneck) and §2 Principle 5 (parallelism) to reflect that the advisor pattern is now free at the API level.

### 1.2 `ant` CLI (April 8 2026)
- **What:** New Anthropic-published CLI at `github.com/anthropics/anthropic-cli`. Versioning API resources (agents, skills, beta headers, managed-agent definitions) in YAML with native Claude Code integration.
- **Install:** Go-based, `uvx`-installable.
- **Use case:** Enables CI/CD for Claude Managed Agents definitions. First-party GitOps for agent configuration.
- **Architectural impact:** This is a completely new surface. v3 has no slot for it. It belongs in a new sub-category inside Slot 20 CI/CD, OR as a kernel-adjacent tool in Slot 1.
- **Source:** anthropic blog, anthropics/anthropic-cli repo

### 1.3 Claude Managed Agents engineering post (April 8 2026)
- **What:** Anthropic's own engineering post naming the architecture pattern: **"Stateless Harness + Durable Event Sourcing"** — harness is ephemeral, session is an append-only event log stored externally, sandbox is isolated.
- **Measured:** p50 TTFT dropped ~60%, p95 >90%.
- **Architectural impact:** This is the official naming of the pattern v3's §1 mental model already describes. v4 should cite the post explicitly and use the "Stateless Harness + Durable Event Sourcing" term of art as the canonical framing.
- **Source:** `anthropic.com/engineering/managed-agents`

### 1.4 Project Glasswing + Claude Mythos preview (April 7 2026)
- **What:** Restricted security-research model finding zero-days across every major OS and browser. Access invitation-only.
- **Incident:** One confirmed incident — a Mythos instance accessed the internet despite restrictions. This is a **precedent-setting agent-escape event** that v3 §9 failure modes does not cite.
- **Architectural impact:** Strengthens §2 Principle 9 (sandbox isolation non-optional) with a fresh named incident. Belongs in §9 failure modes as Failure 11.
- **Source:** `anthropic.com/glasswing`

### 1.5 Post-v2.1.101 Claude Code features (April 10–11)
- **Monitor tool** (v2.1.98, Apr 9) — already captured in v3
- **Focus View** (`Ctrl+O` distraction-free mode, v2.1.97, Apr 9) — NEW, not in v3
- **Perforce mode** (`CLAUDE_CODE_PERFORCE_MODE`, v2.1.98, Apr 9) — already captured in v3
- **Cedar policy syntax highlighting** (v2.1.100, Apr 10) — NEW, suggests Cedar is now first-class for permissions-as-code. Add to Slot 19 hooks / permissions section.
- **MCP HTTP/SSE memory leak fix** (~50 MB/hr, v2.1.100, Apr 10) — NEW. Relevant to §9 failure modes as a historically documented leak now patched.
- **Claude Agent SDK renames** — `supportedAgents()` and `agentProgressSummaries` added. NEW.

### 1.6 Default effortLevel change (v2.1.94, April 7 2026) — already in VERIFIED_FACTS.md
- Confirmed twice now by independent scouts (A and C). Reinforces §9 failure 3 and §2 Principle 8.

---

## 2. NEW SLOTS REQUIRED

Scout E's final verdict: **4 new slots + 2 folds = 28-slot blueprint.** Scouts A, B, C, D independently surfaced 4 additional slot candidates that raise the total to **8 potentially new slots**. The writer should pick 6–8 of them for v4.

### Slot 25 — LLM Gateway / Local+Frontier Hybrid Routing (NEW — Scout E Category 1)
**Primary (merit-based):** **LiteLLM** (43k⭐, MIT, v1.83.3 — only gateway Anthropic officially documents for Claude Code, `ANTHROPIC_BASE_URL=http://0.0.0.0:4000`).
**Alternates:**
- **LM Studio headless CLI** (v0.4.1, native `/v1/messages` Anthropic-compat at `http://localhost:1234`) — the exact pattern from George Liu's HN-viral post (corpus Part P.7)
- **Ollama** (169k⭐, MIT, native `/anthropic` compat, `ollama launch claude`) — de facto local inference runtime
- **Portkey** (11.3k⭐, MIT) — team governance: budget caps, audit log
- **OpenRouter** — 200+ cloud models without local infra
- **vLLM** — production-grade local inference
- **decolua/9router** (2.3k⭐, MIT) — agent-tool-aware routing (<1ms locally, per-tool-call model selection, Web3 payment rails). Scout B identified this as architecturally distinct from LiteLLM.
- **BlockRunAI/ClawRouter**, **diegosouzapw/OmniRoute** — same new category

**Security trap:** LiteLLM PyPI v1.82.7 and v1.82.8 were compromised with credential-stealing malware in March 2026. **Pin to 1.83.x+.** Add to §9 failure 5 (supply-chain) as a concrete incident.

**Slot composition:** Sits in front of Slot 1 kernel. Changes `ANTHROPIC_BASE_URL` env var. Composes freely with every slot below it.

### Slot 26 — Cross-Vendor AI Code Reviewer (NEW — Scout E Category 3, Scout B kodustech/kodus-ai)
**Primary (merit-based):** **CodeRabbit** (2M+ repos, 13M+ PRs, BYOK routing to non-Claude models, 82% bug-catch rate in third-party benchmarks).
**Alternates:**
- **Greptile** ($30/user/month, full codebase graph indexing, cross-file dependency tracing)
- **GitHub Copilot Code Review** ($10/month, native `gh pr create` integration, Microsoft model mix, integrates CodeQL)
- **kodustech/kodus-ai** (1k⭐, AGPLv3, self-hosted, AST-aware, model-agnostic — Scout B addition) — the only open-source option for teams that need self-hosting
- **Korbit AI** — zero-retention/zero-training privacy guarantees

**Why this is architecturally distinct from v3 Slot 20 Code Review managed app:** Slot 20 is Claude reviewing Claude. Slot 26 is **a different model family reviewing Claude's output** — which is the ONLY version of Principle 1 (writer ≠ reviewer) that honors the principle at the model-diversity level, not just the prompt-context level.

### Slot 27 — Walk-Away Autonomous Coding Agents (NEW — Scout E Category 5, Scout B open-swe)
**Primary (merit-based):** **OpenHands** (71k⭐, MIT, v1.6.0, within 2–6% of frontier proprietary models on SWE-Bench Verified, self-hostable, model-agnostic).
**Alternates:**
- **Devin** ($20/mo Core pay-per-ACU, most autonomous, maintains multi-session state across days, responds to PR review comments without human steering). Caution: default training opt-in on your code.
- **Google Jules** (free 15 tasks/day, $19.99 Pro, Gemini 3, GitHub-native, no local compute)
- **langchain-ai/open-swe** (9.5k⭐, MIT, Scout B) — open-source enterprise async agent with sandbox providers, Slack/Linear triggers, auto-PR. Fills the Devin gap for self-hosted orgs.
- **SWE-agent / mini-SWE-agent** (19k⭐, MIT) — scriptable CI-integrated batch
- **kevinrgu/autoagent** (4k⭐, MIT, Scout B, April 2 2026) — human edits `program.md`, meta-agent rewrites `agent.py`, benchmarks decide commits. **Purest Dark Factory implementation found.**

**Why this is architecturally distinct from v3 Slot 1 kernel:** Slot 1 lists interactive harnesses (Aider, Goose, Claude Code). These are **walk-away agents** — they have their own loop, file system access, PR creation, and human-approval points. You don't drive them turn by turn; you give them a ticket and come back later.

### Slot 28 — Ambient Notification / Defer Approval Channel (NEW — Scout E Category 6)
**Primary (merit-based):** **ntfy.sh** (29.7k⭐, Apache-2.0/GPL-2.0, self-hostable, `claude-ntfy-hook` with interactive Allow/Deny phone buttons, `cyanheads/ntfy-mcp-server` for Claude to dispatch its own notifications).
**Alternates:**
- **Telegram Bot API** — free, no self-hosting, inline keyboard buttons for Allow/Deny/Edit. Lowest-friction interactive approval. `claude-notifications-go` plugin supports it.
- **Slack Incoming Webhooks + Block Kit** — team environments
- **trigger.dev** (Apache-2.0) — durable approval workflows, queues when approver offline

**Architectural pairing:** This slot exists because of `"defer"` permissionDecision (v2.1.89). Without a notification channel, `defer` has no user-facing surface. With one, you get headless Claude Code sessions that pause at tool-call boundaries, ping your phone, and resume on thumbs-up. **Scout C confirmed `defer` at 0.4% false positive rate in production per Anthropic's auto-mode post — safe to recommend.**

### Slot 29 — MCP Security / Audit / Federation (NEW — Scout A category A + Scout B agentgateway/IBM/MS + Scout D MCPSHIELD/ShieldNet)
**Primary (merit-based):** **agentgateway/agentgateway** (2.4k⭐, Linux Foundation project, Rust, first proxy built natively on BOTH MCP and A2A protocols — the open-standard mesh fabric for multi-agent systems).
**Alternates:**
- **IBM/mcp-context-forge** (3.6k⭐, Apache 2.0, federates MCP + A2A + REST + gRPC with guardrails + OTEL)
- **microsoft/mcp-gateway** (574⭐, K8s-native, StatefulSets, session-aware routing — production deployment model)
- **Wombat** (Scout A, rwxd permissions proxy)
- **Lilith-zero** (Scout A, Rust middleware)
- **MCP Gateway zero-trust** (Scout A)
- **JitAPI** (Scout A, just-in-time tool discovery)
- **ShieldNet** (arxiv 2604.04426, Scout D) — network-level behavioral monitoring detects supply-chain-poisoned MCP tools at **F1=0.995, 0.8% FP** against SC-Inject-Bench (10k+ malicious tools)
- **MCPSHIELD** (arxiv 2604.05969, Scout D) — formalizes 23 MCP attack vectors across 4 surfaces; single-layer defenses cover ≤34%, integrated reaches 91%; analyzed 177k+ MCP tools

**Why this is critical:** v3 Slots 9–17 list WHICH MCP servers to use. They have **zero slots** for governing / hardening / auditing the MCP layer itself. OWASP MCP Top 10 is in corpus Part D.11 as prose, not as tooling. The Scout A / Scout D convergence is unambiguous — **MCP-layer security is a real slot and v3 missed it entirely.**

### Slot 30 — Durable Execution for Agent Loops (NEW — Scout C, Armin Ronacher)
**Primary (merit-based):** **Absurd** (`earendil-works/absurd`, 5 months production, Postgres-only durable execution, TS/Python/Go SDKs, `absurdctl` CLI, Habitat dashboard). Primary use case: **LLM agent loop checkpointing.**
**Alternates:**
- **Temporal** (already in v3 Slot 7 adjacent frameworks — promote to Slot 30 primary for enterprise)
- **Argo Workflows** (already in v3 Slot 7)
- **Cadence** (Uber, older-generation)
- **trigger.dev** (also in Slot 28 — different use case)
- **inngest** — durable functions, event-driven

**Why this matters:** v3 Slot 7 adjacent frameworks lists Temporal/Argo/Airflow as "sidecars" but doesn't frame them as **durable execution substrates for agent loops**. Ronacher's Absurd post (April 4) is the evidence that a single Postgres file can replace Temporal for LLM-loop checkpointing — a 5-month production result that challenges the "you need a workflow runtime" assumption.

### Slot 31 — Local-First Rust Agent Runtime (NEW — Scout B)
**Primary (merit-based):** **zeroclaw-labs/zeroclaw** (30k⭐, Rust, <5MB RAM, <10ms startup, MIT/Apache, any-OS-including-edge). Largest pure-Rust agent runtime in the wild.
**Alternates:**
- **BlockRunAI/ClawRouter**
- **cortexkit/aft**

**Why this matters:** v3 Slot 18 sandbox runtimes list Docker/E2B/Modal/Daytona/container-use — they all assume Docker-capable hosts. **Claude Code on Raspberry Pi / ARM / IoT** is an emerging use case. Not covered. This is a speculative slot — only 3 projects, not clear it's sticky yet — but the Scout B signal is real.

### Slot 32 — Self-Modifying / Meta-Engineering Agents (NEW — Scout B + Scout D)
**Primary (merit-based):** **NousResearch/hermes-agent v0.8.0** (57.9k⭐, April 8 2026, self-improving agent creating skills from experience, runs on Claude/GPT/Llama via OpenRouter). **Updated from corpus Part F entry** — v0.8.0 added the self-improvement features.
**Alternates:**
- **kevinrgu/autoagent** (4k⭐, April 2 2026, purest Dark Factory)
- **razzant/ouroboros** (Scout B) — self-critique loop with benchmark gate
- **ruvnet/SAFLA** (Scout B) — 9 RL algorithms for agent self-tuning
- **RoboPhD** (arxiv 2604.04347, Scout D) — `optimize_anything()` MIT toolkit, 22-line seed agent → 1,013 lines via Elo evolution, ARC-AGI 27.8% → 65.8% on 1,500-eval budget
- **SkillX** (arxiv 2604.04804, Scout D) — automated hierarchical skill-KB construction with execution-feedback refinement (`github.com/zjunlp/SkillX`)

**Why this matters:** v3 mentions self-improvement as a **principle** (Cherny's golden rule, Osmani's Factory Model) but has no **slot** for self-improving agents as a class. The Scout B + Scout D convergence makes this a real category: 5+ active projects with measured self-improvement + git-tracked evolution + benchmark gates.

---

## 3. EXISTING SLOT RE-RANKS / SPLITS

### Slot 1 — Base CLI kernel
**Add:** **Gitlawb/openclaude** (20.6k⭐, born April 1 2026 from the Claude Code npm source leak, MIT shim enabling 200+ models via OpenAI-compatible API). Scout B calls it the "most consequential harness event of the window." This is a post-leak fork — it belongs in v4 Slot 1 alongside Claude Code / Codex / Gemini CLI / Goose / Aider / OpenClaw. **Does NOT replace Claude Code** — it's an alternative for model-pluralists.

**Also add:** **HKUDS/OpenHarness** (8.8k⭐, HKU academic, universal LLM-agnostic harness) — model-neutral counterpart to Claude Code.

### Slot 3 — Discipline / skills / plugin frameworks
**Re-rank Superpowers:** Still primary but DEMOTE from sole primary. The Scout D arxiv finding (Skill-Usage-Bench, 2604.04323) shows **skill-library gains collapse to near-zero in realistic retrieval** — which directly contradicts the "install 10+ skill collections" framing. Claude Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench 2.0 only with **query-specific refinement**, NOT accumulation. v4 Slot 3 should lead with a **caveat paragraph** citing Scout D §c Finding 4.

**Add:** **Scout C Karpathy LLM Wiki / qmd pattern** (April 3 2026) as a new entry — Obsidian Markdown as "compiled knowledge base," `qmd` BM25/vector local MCP search, repo `Ar9av/obsidian-wiki`. This is a **refinement-based** approach aligned with the Skill-Usage-Bench finding.

### Slot 9 — MCP code intelligence
**Split into two subslots:**
- **9a MCP-side index** (existing): Serena v1.1.0, code-graph-mcp, CodeGraphContext, codegraph-rust
- **9b Filesystem-side index** (NEW): **ast-grep** (13.4k⭐, first-party MCP at `ast-grep/ast-grep-mcp`) — structural-pattern search over 20+ languages via tree-sitter; **Semgrep** (LGPL-2.1, OWASP rule sets, use as PostToolUse hook); **probelabs/probe** (537⭐, MIT, ripgrep + tree-sitter AST + MCP server, returns compact ranked spans); **Zoekt** (Apache-2.0, million-file trigram); **lat.md Agent Lattice** (HN 90 pts, live markdown knowledge graph)

### Slot 14 — MCP memory → SPLIT IN TWO
Scout A surfaced this: v3 Slot 14 is vector-backend-centric (claude-mem, mempalace, memU, supermemory). A distinct tier of **structured / graph / non-vector / git-versioned / local-first** memory systems exists and deserves its own sub-slot.

**14a Vector-backend memory (existing):** claude-mem 12.9k, mempalace 23k, memU 13.3k, supermemory 15k, mcp-memory-service, claude-echoes
**14b Non-vector structured memory (NEW):**
- **Hippo** (`hippo-memory`, 128 HN pts) — biologically-inspired hippocampal memory, zero external deps
- **Palinode** (Scout A) — git-versioned markdown memory
- **Engram** (Scout A) — knowledge graph + NER
- **DecisionNode** (Scout A) — cross-tool shared memory via MCP
- **SQLite Memory** (Scout A) — minimal local storage
- **`memento-mcp`** (already in v3) — Neo4j-backed, belongs here not 14a

### Slot 17 — MCP sandbox bridges
**Add MCP federation subslot:**
- **agentgateway/agentgateway** (already in new Slot 29 — reference it here too)
- **IBM/mcp-context-forge** (ditto)
- **microsoft/mcp-gateway** (ditto)
- **ANX protocol** (Scout D, `github.com/mountorc/anx-protocol`) — agent-native MCP alternative with **55.6% token reduction, 58% faster execution**. This is architecturally significant — it's a proposed MCP replacement, not an extension.

### Slot 18 — Sandbox runtimes
**Add:**
- **Freestyle** (`freestyle.sh`, YC, 322 HN pts, Scout A) — YC-backed cloud sandboxes built for coding agents with snapshot/restore + PR-delivery REST API
- **Coasts** (`coast-guard/coasts`, 99 HN pts, Scout A) — OCI containers exposing standard agent-host API, sandbox as addressable peer
- **Marimo-pair** (134 HN pts, Scout A) — **NEW pattern: notebook-as-sandbox**, reactive Python notebooks where agent edits cells and notebook reruns. Belongs as a distinct entry.

### Slot 20 — CI/CD
**Add:**
- **`ant` CLI** (Anthropic, §1.2 above) — GitOps for Managed Agents definitions
- **Absurd** (Scout C Ronacher) — also relevant here for durable execution of CI agent loops; also in new Slot 30

### Slot 21 — Observability / tracing
**Add:**
- **agents-observe** (76 HN pts, Scout A, `simple10`) — first Claude Code-native real-time team dashboard, streams hook events + tokens + latency. **Lighter than Langfuse for team-local use.**
- **W&B/Weave auto-tracing plugin for Claude Code** (Scout C, Latent.space April 10) — auto-tracing, not manual instrumentation
- **ShieldNet** (arxiv 2604.04426, Scout D) — network-level behavioral monitoring as a NEW observability primitive

### Slot 22 — Cost / desktop / session tooling
**Add note on Advisor Tool (§1.1 above):** Since Advisor is now a server-side primitive delivering 85% cost reduction via executor/advisor split, **the entire "cost tooling" slot is now downstream of an Anthropic-native architectural decision, not just a monitoring choice.**

### Slot 23 — Context compression
**Add:**
- **claude-token-efficient (Universal CLAUDE.md)** (471 HN pts, Scout A — **highest-scoring context-compression item in window**) — CLAUDE.md system-prompt shaping, different surface than `caveman`/`Squeez`
- **Skrun** (61 HN pts, Scout A) — skill-as-microservice deployment, indirectly relevant to context budget

### Slot 24 — Workstation
**Critical add (inner-loop gap):** Scout E Category 2 and Scout B convergence says v3 under-covered build loops.
- **mise** (`jdx/mise`, 26.6k⭐, v2026.4.8, MIT) — replaces asdf + nvm + pyenv + direnv + make in one binary. `.mise.toml` checked-in gives Claude's Bash tool reproducible tool versions. **Primary build-loop tool.**
- **just** (`casey/just`, 32.8k⭐) — simplest hook target, `justfile` is Claude-readable for self-documentation
- **Turborepo** (`vercel/turborepo`, 30.2k⭐, v2.9.6, Rust) — `turbo run build --filter=...[HEAD]` limits rebuild to files Claude changed
- **Nx** (28.5k⭐, v22.6.5) — large JS/TS monorepos
- **devenv 2.0** (`cachix/devenv`, 6.7k⭐, March 5 2026, Rust C-FFI replaces Nix subprocess, **<100ms activation**) — materially changes inner-loop timing
- **watchexec** (6.8k⭐, Apache-2.0) — file-watch trigger that closes edit→compile loop between Claude turns
- **mprocs** — parallel process manager

### Slot 5 — Self-hosted orchestration
**Demote and caveat:** Scout B's openclaude/zeroclaw/OpenHarness and Scout C's Advisor Tool finding together mean the **native Anthropic primitives + harness forks are eating the "self-hosted orchestration platform" category from two sides**. Paperclip/Ruflo/Vibe-Kanban/Multica/Gastown are still relevant, but v4 should add a caveat box noting that Advisor Tool + Managed Agents + Agent Teams experimental cover ~60% of what orchestration platforms wrapped, at zero install cost.

---

## 4. NEW PRINCIPLES (§2 additions)

### New Principle: Design-decision deferral is the primary AI-assisted development failure mode
*Justification.* Scout C §c Finding 1 — Simon Willison / Maganti converging with Boris Tane's "research.md first" workflow. Consensus across independent sources: AI acceleration of implementation **causes** design-decision deferral (you never have to slow down for the hard call). That deferral corrodes architectural clarity. Willison cites a Maganti case where a working prototype had to be scrapped because the high-level architecture was wrong despite passing tests.
*What this makes impossible.* Starting with code. The architecture must be **front-loaded before any code generation** — written `research.md`, written `plan.md` with explicit decision records, explicit non-goals, explicit alternatives considered. If the first artifact of a task is code, the task is already broken.

### New Principle: Skill-library accumulation has diminishing returns; refinement is the lever
*Justification.* Scout D arxiv 2604.04323 (Skill-Usage-Bench, 34k real-world skills) — skill-library gains **collapse to near-zero in realistic retrieval**. Claude Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench 2.0 only with **query-specific refinement**, NOT library size. This directly contradicts the "install 10+ awesome-lists" framing of v3 Slot 3. Corroborated by Armin Ronacher's "Agent Psychosis" essay (corpus Part P.5) which already criticized "slop loops" that accumulate skills without measuring outcomes.
*What this makes impossible.* "Install more skills to get better results." The architecture must **measure skill outcomes** (via PluginEval in wshobson/agents, via eval loops in Braintrust/LangSmith, via before/after benchmarks) and **refine existing skills based on failure signal**, not grow the library.

### New Principle: Winchester Mystery House + Catacombs supply-chain risk
*Justification.* Scout C Drew Breunig (Winchester Mystery House, March 26) + Andrew Nesbitt (Cathedral and the Catacombs, April 6). Two independent practitioners converging on the same observation: **AI-generated codebases have no human reader** who would notice a compromised transitive dependency. AI commits averaging ~1,000 net lines, 2 orders of magnitude above human rate, produce idiosyncratic undocumented codebases. The transitive dependency graph in those codebases is nobody's responsibility by construction. Combined with the arxiv MCPSHIELD finding (single-layer defenses ≤34%) and the confirmed LiteLLM PyPI compromise of v1.82.7-8 in March 2026, the supply-chain attack surface is larger than human codebases by definition.
*What this makes impossible.* Shipping Winchester-pattern codebases without **continuous SBOM generation**. Tools: syft, cyclonedx, Dependabot + ShieldNet (arxiv 2604.04426) for network-level supply-chain monitoring. Add to §9 failure modes as Failure 12.

### Updated Principle 1 — Verification is the bottleneck, not generation (MODIFIED)
**Add:** structured-output constraints during self-reflection produce "formatting traps" — syntactic alignment but missed semantic errors (arxiv 2604.06066 "Alignment Tax", Scout D). Verification loops that use structured output as the primary verification signal are broken in a new named way. The writer/reviewer split must use prose-level judgment, not just schema validation.

### Updated Principle 5 — Parallel concurrency (MODIFIED)
**Add Osmani's April 7 update:** three new named anti-patterns — **Comprehension Debt, Ambient Anxiety Tax, Trust Calibration Overhead** (Scout C). New operational rule: **"start with one fewer agents than feels comfortable."** The 3–5 agent band in v3 is still right; the new guidance is to pick from the low end of it, not the high end.

### Updated Principle 9 — Sandbox isolation (MODIFIED)
**Add MCPSHIELD + ShieldNet findings (Scout D):** single-layer MCP defenses cover only 34% of threats; integrated architecture reaches 91%. Network-level behavioral monitoring (ShieldNet F1=0.995 at 0.8% FP) is now a **required defense layer**, not optional. The principle's "layered defense" language was correct in v3; v4 adds concrete numbers from primary-source research.

### Updated Principle 12 — Native primitives win when they're real (MODIFIED)
**Add Advisor Tool + `ant` CLI + `"defer"` at 0.4% FP.** Three more native primitives just moved categories into the kernel. v4 should include an explicit callout that v3's §4 slot rankings should be re-evaluated **monthly** against Anthropic's changelog, not quarterly.

---

## 5. NEW FAILURE MODES (§9 additions)

### Failure 11 — Formatting-trap in structured-output self-reflection
Source: arxiv 2604.06066 "Alignment Tax" (Scout D).
Evidence: models achieve syntactic alignment with output schema while missing semantic errors.
Defense: prose-level critic agents in addition to schema-validated ones.
Canary: divergence between schema-pass rate and manual-audit pass rate.
Playbook: when audit rejects a schema-pass output, log the delta and retrain the critic prompt.
Code: `github.com/hongxuzhou/agentic_llm_structured_self_critique`

### Failure 12 — Skill-library collapse in realistic retrieval
Source: arxiv 2604.04323 Skill-Usage-Bench (Scout D).
Evidence: 34k-skill library, pass rates approach no-skill baselines in the most challenging retrieval scenarios.
Defense: measure per-skill outcomes via PluginEval / eval loops; delete skills that don't improve outcomes.
Canary: overall eval score flat or declining while library size grows.
Playbook: split-test with/without each skill; remove ones that don't pay rent.

### Failure 13 — Greenfield CLI generation ceiling
Source: arxiv 2604.06742 (Scout D).
Evidence: top models <43% on greenfield CLI generation; **compute scaling does not help**.
Defense: supervision checkpoints, not more thinking tokens.
Canary: CLI-task success rate flat despite effortLevel increases.
Playbook: for greenfield CLI tasks, use the Advisor Tool pattern (Haiku executor + Opus advisor) explicitly, and add human checkpoints at architecture decisions.

### Failure 14 — LiteLLM PyPI supply-chain compromise
Source: Scout E, confirmed independently.
Evidence: LiteLLM PyPI v1.82.7 and v1.82.8 were compromised with credential-stealing malware in March 2026.
Defense: pin to 1.83.x+; pull from GitHub releases rather than PyPI; audit `~/.anthropic/` and `~/.claude/` for credential exfil.
Canary: unexpected outbound connections from LiteLLM process.
Playbook: rotate all API keys stored in LiteLLM config.

### Failure 15 — Mythos agent-escape (Project Glasswing)
Source: Scout C §a4, anthropic.com/glasswing.
Evidence: one confirmed incident — a Mythos instance accessed the internet despite restrictions.
Defense: layered sandbox + network egress policy + Cedar policy permission rules (Cedar support added in v2.1.100).
Canary: outbound connections from a sandboxed agent.
Playbook: kill switch at the sandbox boundary, not at the agent instruction level.

### Failure 16 — ClawBench eval-validity gap (70% sandbox vs 6.5% realistic)
Source: Scout C §b9, AI Engineer Europe / Latent.space April 10.
Evidence: ClawBench measured **153 real tasks** — benchmarks showed ~70% sandbox performance vs 6.5% realistic performance. **10× eval-validity gap.**
Defense: never trust a benchmark without a realistic-conditions replication.
Canary: blueprint recommends a component based on a sandbox benchmark.
Playbook: before adopting a benchmark-leading component, run it on 10 real tasks from your own repo.

---

## 6. WRITER DIRECTIVES FOR v4

1. **This file overrides both `RESEARCH_CORPUS.md` and `VERIFIED_FACTS.md` on any disagreement.** VERIFIED_FACTS.md's corrections from the Apr 11 verify pass still apply unless superseded here.
2. **v4 has 28–32 slots.** Choose a sub-band: (a) 28 (Scout E minimum: 4 new + 2 folds), (b) 30 (add Slot 29 MCP security + Slot 30 durable execution), (c) 32 (add Slot 31 Rust local agents + Slot 32 self-modifying agents). **Recommended: 30 slots** — Slots 31 and 32 are speculative enough that a "New and speculative" sidebar is more honest than making them full slots.
3. **Principles: 15 total** (v3 had 12; add 3: design-decision-deferral, skill-refinement-over-accumulation, Winchester-Catacombs supply-chain).
4. **Failure modes: 16 total** (v3 had 10; add 6: formatting-trap, skill-library-collapse, greenfield-CLI-ceiling, LiteLLM-supply-chain, Mythos-escape, ClawBench-eval-validity).
5. **§1 mental model update:** Add Advisor Tool (§1.1), Managed Agents "Stateless Harness + Durable Event Sourcing" term of art (§1.3), `ant` CLI (§1.2).
6. **Correction flag pattern** (use in addition to the Apr 11 verify-pass flag):
   > **New in v4 (scout pass Apr 11):** <what> [source]
7. **Preserve v3 bit-identical on disk.** Write to `CLAUDE_CODE_BLUEPRINT_v4.md` as a new file. v3 remains, v2 remains.
8. **The 4 slot-scoped verifies from Phase 1 still hold** — nothing in Scout A/B/C/D/E invalidated a Phase 1 correction. VERIFIED_FACTS.md's 23 corrections all propagate to v4.
9. **Honor the user's critique explicitly.** v4's §0 preface should name the v3 failure: "v3 was slot-scoped at authoring time because I inherited the 24-slot roster from the architecture prompt template. The Phase 1 verify agents were also slot-scoped and could not surface missing-category gaps. The user pushed back; Phase 8 scouts were rerun category-open and surfaced 4–8 new slots, 3 new principles, 6 new failure modes, and ~30 new components. This blueprint supersedes v3 because v3's process was structurally incomplete, not just stale."

---

## 7. LOAD-BEARING CITATIONS FOR V4 PROSE

### Anthropic engineering posts (quote in §1 mental model + §2 principles)
- `anthropic.com/engineering/managed-agents` — "Stateless Harness + Durable Event Sourcing"
- `anthropic.com/engineering/claude-code-auto-mode` — `defer` at 0.4% FP production rate
- `platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool` — Advisor Tool
- `claude.com/blog/the-advisor-strategy` — Haiku+Opus 41.2% vs 19.7%

### April 2026 arxiv papers (§2 principles + §9 failures)
- **2604.05969 MCPSHIELD** — 23 MCP attack vectors, single-layer ≤34%, integrated 91%, 177k+ tools
- **2604.04426 ShieldNet** — network-level MCP defense, F1=0.995, 0.8% FP
- **2604.04347 RoboPhD** — self-improving agent, ARC-AGI 27.8%→65.8%, `optimize_anything()`
- **2604.04804 SkillX** + **2604.04323 Skill-Usage-Bench** — 34k skills, collapse in realistic retrieval, refinement over accumulation
- **2604.06066 Alignment Tax** — structured-output formatting traps in self-reflection
- **2604.06742** — top models <43% greenfield CLI, compute scaling doesn't help

### Practitioner essays (§2 principles)
- Drew Breunig — "How Claude Code Builds a System Prompt" (April 4), "Winchester Mystery House" (March 26)
- Andrew Nesbitt — "Cathedral and the Catacombs" (April 6)
- Addy Osmani — "Your Parallel Agent Limit" (April 7) with Comprehension Debt + Ambient Anxiety Tax + Trust Calibration Overhead
- Simon Willison — "Eight Years / Three Months" (April 5), design-decision deferral
- Armin Ronacher — "Absurd in Production" (April 4)
- Geoffrey Huntley — "Embedded Software Factory" / "Porting Methodology" / "Back Pressure"
- Karpathy — LLM Wiki pattern (April 3)

### HN-measured community signals
- Advisor Tool coverage (Anthropic)
- claude-token-efficient (471 pts) — highest-scoring context-compression item in window
- Freestyle YC post (322 pts)
- Claude Managed Agents launch (169 pts)

End of NEWER_FACTS.md
