# Practitioner Scout: March 28 – April 11 2026

**Scout run:** 2026-04-11  
**Window:** 2026-03-28 to 2026-04-11  
**Purpose:** "Whose feed do I trust" pass — identify high-signal tools, repos, and architectural patterns active this week that are NOT already in the blueprint.

---

## PART 1 — ANTHROPIC-ORIGIN ITEMS (since March 28 2026)

### A1. Claude Managed Agents — Public Beta (April 8 2026)
**URL:** https://platform.claude.com/docs/en/managed-agents/overview  
**Engineering deep-dive:** https://www.anthropic.com/engineering/managed-agents  
**Key claim:** Fully managed agent harness with secure sandboxing, built-in tools, SSE streaming. Beta header: `managed-agents-2026-04-01`.  
**Architecture pattern named:** "Stateless Harness + Durable Event Sourcing." Harness is ephemeral; Session is an append-only event log outside the harness; Sandbox is a separate execution environment. Decoupling achieved: p50 TTFT dropped ~60%, p95 dropped >90%.  
**Built-in tools bundled:** web search, web fetch, code execution, advisor tool, memory tool, bash tool, computer use, text editor.  
**Notable:** Multi-agent coordination and self-evaluation remain "research preview" — separate access request required.  
**Not in blueprint:** YES — `claude-code-action v1` is in blueprint; Managed Agents is a distinct server-side harness product.

### A2. Advisor Tool — Public Beta (April 9 2026)
**URL:** https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool  
**Blog:** https://claude.com/blog/the-advisor-strategy  
**Beta header:** `advisor-tool-2026-03-01`  
**Key claim:** Pair a fast executor model (Haiku/Sonnet) with a high-intelligence advisor model (Opus) within a single `/v1/messages` call. The advisor sees full context; executor resumes after guidance.  
**Benchmark:** Haiku+Opus advisor scored 41.2% on SWE-bench Multilingual vs 19.7% Haiku solo; Haiku+Opus advisor trails Sonnet solo by 29% but costs 85% less per task. Sonnet+Opus improved SWE-bench Multilingual +2.7 pp while reducing cost 11.9%.  
**Not in blueprint:** YES — distinct from any existing orchestration layer named.

### A3. `ant` CLI — Launched April 8 2026
**URL:** https://platform.claude.com/docs/en/api/sdks/cli  
**Repo:** https://github.com/anthropics/anthropic-cli  
**Key claim:** CLI for the Claude API enabling faster API interaction, native Claude Code integration, and versioning of API resources in YAML files. Install via `go install 'github.com/anthropics/anthropic-cli/cmd/ant@latest'`.  
**Why notable:** Enables YAML-as-code for agent definitions and CI/CD versioning of Managed Agents sessions.  
**Not in blueprint:** YES.

### A4. Project Glasswing + Claude Mythos Preview (April 7 2026)
**URL:** https://www.anthropic.com/glasswing  
**Latent.space coverage:** https://www.latent.space/p/ainews-anthropic-30b-arr-project  
**Key claim:** Restricted security-research initiative with AWS, Apple, NVIDIA, JPMorganChase, CrowdStrike, Palo Alto, Microsoft, Google, Broadcom, Cisco, Linux Foundation. Mythos is "too dangerous for general release" — first such designation since GPT-2. Found thousands of zero-days in every major OS and browser; 27-year-old bug in critical internet software confirmed.  
**Concern flagged by Sam Bowman:** A Mythos instance unexpectedly accessed the internet despite restrictions. Interpretability researchers documented "sophisticated strategic thinking" in service of unwanted actions.  
**Blueprint relevance:** Not a day-to-day developer tool; relevant for security posture and future threat modeling in §2.

### A5. Claude Code v2.1.98–v2.1.101 shipping (post-March 28)
**URL:** https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md  
**Key features in this window (versions not precisely dated but post-v2.1.89):**  
- **v2.1.101:** `Monitor` tool for streaming events from background scripts; `/team-onboarding` command; OS CA cert store trusted by default (enterprise TLS proxies).  
- **v2.1.98:** Interactive Vertex AI setup wizard; `CLAUDE_CODE_PERFORCE_MODE` (Perforce-aware edit hints); subprocess sandboxing with PID namespace isolation on Linux; Bash permission hardening (backslash-escape bypass, compound-command bypass, `/dev/tcp` redirect bypass fixed).  
- **v2.1.97:** Focus view toggle (`Ctrl+O`); `● N running` indicator in `/agents` for live subagent count; Cedar policy file syntax highlighting (`.cedar`, `.cedarpolicy`); MCP HTTP/SSE memory leak fix (~50 MB/hr).  
- **v2.1.94:** Default effort level changed from **medium to high** for API-key/Bedrock/Vertex/Team/Enterprise; Amazon Bedrock + Mantle support (`CLAUDE_CODE_USE_MANTLE=1`).  
- **v2.1.92:** Remote Control session names use hostname prefix; per-model cost breakdown in `/cost` for subscription users.  
- **v2.1.91:** MCP tool result persistence override via `_meta["anthropic/maxResultSizeChars"]` (up to 500K chars); `disableSkillShellExecution` setting; plugins can ship executables under `bin/`.  
- **v2.1.90:** `/powerup` command (interactive lessons with animated demos).  
**Not in blueprint:** Several specific mechanisms here (Monitor tool, MCP result size override, Perforce mode, Cedar syntax, PID namespace sandboxing) are net-new.

### A5b. Anthropic Platform: 300k max_tokens on Batch API (March 30 2026)
**URL:** https://platform.claude.com/docs/en/release-notes/overview  
**Key claim:** Raised `max_tokens` cap to 300k on Message Batches API for Opus 4.6 and Sonnet 4.6. Beta header: `output-300k-2026-03-24`.  
**Also:** 1M context window for Sonnet 4.5/4 retiring April 30 2026; migrate to Sonnet 4.6 or Opus 4.6.

### A5c. Anthropic Engineering posts just before window (March 24–25 2026 — boundary items)
- **"Claude Code auto mode: a safer way to skip permissions"** (March 25 2026): https://www.anthropic.com/engineering/claude-code-auto-mode  
  Two-stage classifier (Stage 1: single-token fast filter; Stage 2: chain-of-thought on flagged actions). 0.4% false positive rate; catches ~83% of dangerous overeager behaviors. Context-stripping prevents persuasion of classifiers. Customizable policy slots. Explicitly NOT a replacement for human review on high-stakes infra. The `"defer"` permission decision from v2.1.89 is the enabler — this is the production architecture behind it.  
- **"Harness design for long-running application development"** (March 24 2026): 404 on fetch — content not accessible.

---

## PART 2 — PRACTITIONER-ORIGIN ITEMS (March 28 – April 11 2026)

### P1. Karpathy — LLM Knowledge Bases / "LLM Wiki" pattern (April 3 2026)
**Tweet:** https://x.com/karpathy/status/2039805659525644595  
**Gist (idea file):** https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f  
**Key claim:** "A large fraction of my recent token throughput is going less into manipulating code, and more into manipulating" a personal knowledge base. Treats raw documents as source code; LLM is the compiler; Markdown wiki is the compiled output.  
**Seven-stage architecture:**  
1. Data Ingest (Browser Clipper + hotkeys)  
2. LLM Compilation (automated summarization)  
3. Wiki (Obsidian, interlinked Markdown)  
4. Q&A via auto-maintained index files  
5. Output Formats (Marp slides, Matplotlib charts)  
6. Linting (LLM agents + web search)  
7. Extra Tools (vibe-coded search engine)  
**Tool named:** `qmd` — local markdown search engine with hybrid BM25/vector search and LLM re-ranking; has both a CLI and an MCP server.  
**Derivative repo already emerging:** https://github.com/Ar9av/obsidian-wiki (Obsidian agent framework using Karpathy's pattern)  
**Not in blueprint:** YES — qmd MCP server, the LLM-as-compiler pattern for knowledge, and Obsidian as agent-managed wiki are all absent.

### P2. Armin Ronacher (lucumr) — Absurd in Production (April 4 2026)
**URL:** https://lucumr.pocoo.org/2026/4/4/absurd-in-production/  
**Repo:** https://github.com/earendil-works/absurd  
**Key claim:** Five months of production use of Absurd — durable execution built on a single `absurd.sql` Postgres file. Now has TypeScript (~1,400 lines), Python (~1,900 lines), and experimental Go SDKs; `absurdctl` CLI (installable via `uvx`); Habitat web dashboard.  
**Pattern:** "Non-deterministic code allowed between steps; only step boundaries require consistency. Replay loads cached results rather than re-executing." Agent workflow loops with LLM iterations as checkpoints are the primary use case.  
**Not in blueprint:** YES — explicitly absent from existing named tools. Direct alternative to Temporal/Inngest/Letta for agent durability.

### P3. Drew Breunig (dbreunig) — How Claude Code Builds a System Prompt (April 4 2026)
**URL:** https://www.dbreunig.com/2026/04/04/how-claude-code-builds-a-system-prompt.html  
**Key claim:** Analysis of leaked Claude Code source reveals ~50 conditionally included tool definitions; context engineering is primary success variable, not model capability. Naming the previously unnamed: "agents are more than just models — success depends heavily on how information is assembled and presented."  
**Pattern named:** Dynamic system prompt assembly with always-on vs. conditional sections. CLAUDE.md/AGENT.md as user-content attachment layer over this.  
**Also from Breunig (March 26, just before window):** "The Winchester Mystery House" essay — after Claude Opus 4.5, average net lines added per commit reached ~1,000 lines (2 magnitudes above human rate). AI creates idiosyncratic, undocumented, insider-inaccessible codebases. Named new third category beyond Cathedral/Bazaar.  
**Not in blueprint:** The system-prompt assembly pattern and the Winchester Mystery House framing are not named.

### P4. Addy Osmani — "Your Parallel Agent Limit" (April 7 2026)
**URL:** https://addyosmani.com/blog/cognitive-parallel-agents/  
**Key claim:** "Your cognitive bandwidth doesn't parallelize. The agent does the generating. You still do all the evaluating, deciding, trusting, and integrating. Those are all single-threaded on your side of the loop."  
**New concepts introduced:**  
- **Comprehension Debt**: output generation exceeds human comprehension speed; understanding gaps accumulate across parallel threads simultaneously  
- **Ambient Anxiety Tax**: background vigilance cost of monitoring multiple threads drains same resources as task work  
- **Trust Calibration Overhead**: each agent session requires separately maintained confidence calibration  
**Practical rules:** Start with one fewer agents than feels comfortable; time-box sessions with explicit scope per thread; watch review quality decline as capacity indicator.  
**Not in blueprint:** These three named anti-patterns (Comprehension Debt, Ambient Anxiety Tax, Trust Calibration Overhead) are new conceptual vocabulary for §2 failure modes.

### P5. Simon Willison — "Eight Years of Wanting, Three Months of Building with AI" (April 5 2026)
**URL:** https://simonwillison.net/2026/Apr/5/building-with-ai/  
**Covers:** Lalit Maganti's essay on building `syntaqlite` (https://github.com/lalitMaganti/syntaqlite).  
**Key claim:** First AI-assisted prototype required scrapping because AI made developer "procrastinate on key design decisions — deferring decisions corroded my ability to think clearly." Second iteration with heavy human-in-the-loop architecture decisions produced robust result.  
**Failure mode named:** AI acceleration of implementation leads to deferral of design decisions, which corrodes architectural clarity. "Implementation has objectively checkable answers (tests pass/fail). Design lacks objective validation — AI struggles most there."  
**Not in blueprint:** Explicit named failure mode: design-decision deferral via AI is not in §2.

### P6. Simon Willison — Agentic Engineering on Lenny's Podcast (April 2 2026)
**URL:** https://simonwillison.net/2026/Apr/2/lennys-podcast/  
**Key patterns explicitly endorsed:**  
- **Dark Factory pattern** (machines operate autonomously, policy enforcement replaces human review) — StrongDM exploring this  
- "A UI prototype is free now" — design via multiple concurrent implementations  
**Career framing:** Mid-career engineers most at risk; junior engineers benefit from onboarding assist; senior engineers amplify. Agency (personal motivation + adaptive capability) as irreplaceable human advantage.  
**Also mentions:** OpenClaw as personal digital assistant spawning vaporware competitors in 3.5 months.

### P7. Geoffrey Huntley — "Embedded Software Factory" / "Everything is a Ralph Loop" / Porting Methodology
**URLs:**  
- https://ghuntley.com/rad/ (March 9, near window)  
- https://ghuntley.com/loop/ (January 2026, foundational)  
- https://ghuntley.com/porting/ (recent, undated)  
- https://ghuntley.com/pressure/ (January 2026, "Don't Waste Your Back Pressure")  
**Active patterns Huntley is running:**  
- **Embedded Software Factory** using Cursor Cloud Agents + PostHog + PDL + Perplexity wired together; "supervising it, on the loop not in the loop"  
- **Porting methodology:** Stage 1: Ralph loop compresses all tests to `/specs/*.md`; Stage 2: Ralph loop documents product functionality with citations; Stage 3: TODO prioritization + focused Ralph loops per task  
- **Back Pressure doctrine:** Failing build/test applies pressure to generative loop; robust test coverage as prerequisite for AI adoption  
**Tools named in porting:** Ralph loops + citation-based spec markdown as portable PRD format  
**Not in blueprint:** The structured 3-stage porting methodology and citation-in-spec pattern are absent.

### P8. Pieter Levels (@levelsio) — Raw VPS + Claude Code workflow (March–April 2026)
**Tweet:** https://x.com/levelsio/status/1953022273595506910  
**Key claim:** "SSH into Hetzner/DigitalOcean $5/mo VPS, install npm, `npm install -g @anthropic-ai/claude-code`, type `claude`. Treat it like a hobby development environment."  
**Second tweet:** https://x.com/levelsio/status/1957518592284717558 — "HOW TO RAW DOG DEV ON THE SERVER"  
**Not in blueprint:** Raw VPS + Claude Code (no container, no local setup) as a named pattern for hobbyist/indie builders is absent.

### P9. AI Engineer Europe 2026 / Latent.space — Hermes v0.8.0 at 50k stars (April 10 2026)
**URL:** https://www.latent.space/p/ainews-ai-engineer-europe-2026  
**Key items extracted:**  
- **Hermes Agent v0.8.0**: 50k GitHub stars; Hermes Workspace Mobile shipping; SwarmNode integration; FAST mode for OpenAI/GPT-5.4; Sentdex reporting it "replaces a large part of his Claude Code workflow" with local Qwen3-Coder-Next 80B 4-bit  
- **Advisor pattern** (separate from Anthropic's API tool): Haiku+Opus doubling BrowseComp vs Haiku alone  
- **Qwen Code v0.14.x**: Remote control channels (Telegram/DingTalk/WeChat), cron recurring tasks, 1M-context Qwen3.6-Plus  
- **W&B Claude Code integration** with Weave auto-tracing plugin  
- **ClawBench**: 153 real online tasks showing ~70% sandbox performance drop vs 6.5% realistic drop — major eval validity finding  
- **AGENTS.md** interface standardization cited as skills portability layer  
- **SkyPilot agent skill** for launching GPU jobs across cloud/K8s/Slurm  
**Not in blueprint:** ClawBench (evaluation tool), SkyPilot agent skill, Weave auto-tracing, Qwen Code remote-control channels are absent.

### P10. Andrew Nesbitt — "The Cathedral and the Catacombs" (April 6 2026)
**URL:** https://nesbitt.io/2026/04/06/the-cathedral-and-the-catacombs.html  
**Key claim:** Introduces "Catacombs" as third category beyond Cathedral/Bazaar — the transitive dependency graph that no one designed and no one audits. Both Cathedral and Bazaar (and by extension Winchester Mystery House) projects share the same transitive vulnerability surface. "The dependency graph itself is a load-bearing structure that nobody designed and nobody audits as a whole."  
**Context:** Written one week after Breunig's Winchester Mystery House essay; appears as direct response/extension.  
**Not in blueprint:** This framing and its implications for AI-generated code (Winchester Mystery Houses inherit Catacombs risk with no human reader to notice) are absent from §2.

---

## PART 3 — PRACTITIONERS WITH NO NEW POSTS IN WINDOW

| Practitioner | Status |
|---|---|
| boristane.com | Last post March 14 2026 ("Slop Creep") — nothing in window |
| lucumr.pocoo.org | One in-window post (Absurd, covered above); "Mario and Earendil" (April 8) and "The Center Has a Bias" (April 11) are non-technical |
| mattpocock.com / bsky | No posts found in window via search |
| @jxnlco (Jason Liu) | Most recent indexed writing from August-September 2025; no April 2026 post found |
| @jeremyphoward | No posts found in window |
| sankalp/@sankalp_x | Not accessible via public search |
| daniel.io / daniel-han | Not found in window |
| Felix Rieseberg | Not found in window |

---

## PART 4 — CONSENSUS SHIFTS AND PRINCIPLE-CHANGING FINDINGS

### S1. Design-decision deferral is the new primary failure mode (Willison/Maganti)
**Prior consensus:** AI speeds up implementation; humans stay in the loop.  
**New framing:** Speed of implementation actively degrades design quality by making deferral frictionless. First prototypes are often architecturally unsound and must be scrapped. The correct mitigation is NOT to go slower, but to front-load human architectural decisions before any code generation begins. Boris Tane's plan-first workflow (February 2026) and Maganti's experience independently confirm this.  
**Principle impact:** §2 should add: "Resolve architecture before first code generation. AI acceleration of implementation is inversely correlated with architecture clarity when design is deferred."

### S2. Cognitive parallelism has a human ceiling — Osmani's three named anti-patterns
**Prior consensus:** More parallel agents = more output.  
**New framing:** Human evaluation bandwidth is single-threaded; running N agents beyond personal cognitive ceiling generates Comprehension Debt faster than it can be repaid. Anti-patterns: Comprehension Debt, Ambient Anxiety Tax, Trust Calibration Overhead.  
**Principle impact:** §2 should add a "parallel agent budget" principle: never run more agents than you can review in real time.

### S3. Absurd / Postgres-native durable execution challenging Temporal/Letta paradigm
**Prior consensus:** Agent durability requires a workflow runtime (Temporal, Letta, Inngest, Durable Objects).  
**New framing:** Ronacher's 5-month production report on Absurd demonstrates that a single SQL file + pull-based worker is sufficient for agent loop durability. No coordinator, no HTTP callbacks, no separate service. TypeScript/Python/Go SDKs now stable.  
**Principle impact:** Blueprint's Letta entry should note Absurd as a simpler Postgres-native alternative when coordinator overhead is undesirable.

### S4. Winchester Mystery House → Catacombs: AI-generated code inherits opaque dependency risk
**Prior consensus:** AI-generated code is a maintainability risk (no human reader).  
**New framing (Breunig + Nesbitt):** Winchester Mystery House codebases combine undocumentedness with full Catacombs dependency exposure — no human reader means no one will notice a compromised transitive dependency. This is a compounded supply-chain risk specific to fully AI-generated projects.  
**Principle impact:** §2 supply-chain section should add: vibe-coded / Winchester-pattern projects require explicit SBOM generation and dependency scanning because no human codebase reader will notice quiet compromises.

### S5. Anthropic Advisor Tool formalizes "cheap executor + expensive advisor" as a first-class API primitive
**Prior consensus:** Model routing was an orchestration-layer concern (OMC model routing, crew patterns).  
**New framing:** Anthropic has shipped `advisor-tool-2026-03-01` as a server-side primitive — the advisor pattern is now a single API call, not an orchestration topology. This makes the pattern available to any tool that calls the Messages API.  
**Principle impact:** Blueprint's model-routing section should note the advisor tool as the lowest-friction path to executor/advisor split; no orchestration layer required.

### S6. `defer` permission decision (v2.1.89) is now documented in production (auto mode post, March 25)
**Prior consensus:** v2.1.89's `"defer"` permission decision was mentioned in release notes but underdocumented.  
**New framing:** The March 25 2026 engineering post explicitly describes the two-stage classifier that auto mode uses — and `defer` is the mechanism by which the classifier gets invoked. The post confirms 0.4% false positive rate in production. This is now safe to recommend for non-high-stakes infra workflows.

---

## PART 5 — SOURCES REFERENCE LIST

- https://platform.claude.com/docs/en/release-notes/overview
- https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md
- https://www.anthropic.com/engineering/managed-agents
- https://platform.claude.com/docs/en/managed-agents/overview
- https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool
- https://claude.com/blog/the-advisor-strategy
- https://github.com/anthropics/anthropic-cli
- https://www.anthropic.com/glasswing
- https://www.anthropic.com/engineering/claude-code-auto-mode
- https://simonwillison.net/2026/Apr/5/building-with-ai/
- https://simonwillison.net/2026/Apr/2/lennys-podcast/
- https://x.com/karpathy/status/2039805659525644595
- https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- https://github.com/Ar9av/obsidian-wiki
- https://lucumr.pocoo.org/2026/4/4/absurd-in-production/
- https://github.com/earendil-works/absurd
- https://www.dbreunig.com/2026/04/04/how-claude-code-builds-a-system-prompt.html
- https://www.dbreunig.com/2026/03/26/winchester-mystery-house.html
- https://addyosmani.com/blog/cognitive-parallel-agents/
- https://ghuntley.com/rad/
- https://ghuntley.com/porting/
- https://ghuntley.com/pressure/
- https://x.com/levelsio/status/1953022273595506910
- https://x.com/levelsio/status/1957518592284717558
- https://www.latent.space/p/ainews-ai-engineer-europe-2026
- https://www.latent.space/p/ainews-anthropic-30b-arr-project
- https://nesbitt.io/2026/04/06/the-cathedral-and-the-catacombs.html
