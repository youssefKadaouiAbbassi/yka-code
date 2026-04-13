# GitHub Scout Report: March 28 – April 11, 2026

**Generated:** 2026-04-11  
**Scope:** New or significantly active repos outside the existing blueprint corpus  
**Window:** Created OR significantly active 2026-03-28 to 2026-04-11

---

## Full Discovery Table (30 picks)

| # | Repo URL | Stars | License | Created | Last Commit | Short Description | Slot | Why it matters |
|---|----------|-------|---------|---------|-------------|-------------------|------|----------------|
| 1 | [Gitlawb/openclaude](https://github.com/Gitlawb/openclaude) | 20.6k | MIT | 2026-04-01 | 2026-04-11 | Open-source Claude Code CLI shim enabling 200+ models via OpenAI-compatible API | Slot 1 (Agent Harness) | Direct Claude Code fork enabling model-agnostic harness — biggest architectural unlock of the window |
| 2 | [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) | 57.9k | MIT | 2025-07-22 | 2026-04-08 | Self-improving AI agent that creates skills from experience and runs anywhere via CLI/Telegram/Discord | Slot 9 (Self-Improving) | Native skill-creation loop rivals OMC ralph; cross-platform deployment model is reference architecture |
| 3 | [Yeachan-Heo/oh-my-codex](https://github.com/Yeachan-Heo/oh-my-codex) | 21k | MIT | 2026-02-02 | 2026-04-11 | Teams-first multi-agent orchestration layer for OpenAI Codex CLI (parallel, hooks, HUDs) | Slot 2 (Orchestration) | Direct Codex-side peer to oh-my-claudecode; confirms demand for agent harness on every CLI, not just Claude |
| 4 | [zeroclaw-labs/zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) | 30k | MIT/Apache 2.0 | 2026-02-13 | ~2026-04-10 | Full-Rust AI assistant infra: <5MB RAM, <10ms startup, any OS, multi-channel gateway | NEW CATEGORY: Local-First Rust Agent Runtime | Rust-native infra opens Claude Code workflows on IoT/edge; zero-overhead design benchmarks the whole category |
| 5 | [HKUDS/OpenHarness](https://github.com/HKUDS/OpenHarness) | 8.8k | MIT | ~2025 Q4 | 2026-04-10 | Universal lightweight agent harness: tool-use, skills, memory, multi-agent coordination | Slot 1 (Agent Harness) | Academic-grade harness from HKU; reference for LLM-agnostic multi-agent infrastructure |
| 6 | [langchain-ai/open-swe](https://github.com/langchain-ai/open-swe) | 9.5k | MIT | 2025-05-21 | 2026-04-11 | Open-source async coding agent: sandboxes, Slack/Linear triggers, subagent orchestration, auto-PR | Slot 8 (Autonomous Coding Agent) | Production-grade SWE-agent pattern with enterprise triggers; fills the gap between Devin and DIY |
| 7 | [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | 15.2k | (file present) | ~2026-Q1 | ~2026-04-10 | 1000+ curated agent skills for Claude Code, Codex, Gemini CLI, Cursor — official + community | Slot 13 (Skills Registry) | Cross-agent skill compatibility layer; implies skills are becoming portable across harnesses |
| 8 | [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | 17k | (file present) | 2026-02-08 | ~2026-04-10 | 130+ specialized Claude Code subagents across 10 task categories | Slot 13 (Skills/Subagent Registry) | Largest curated subagent collection; signals subagent specialization as a distinct layer |
| 9 | [IBM/mcp-context-forge](https://github.com/IBM/mcp-context-forge) | 3.6k | Apache 2.0 | ~2025 Q4 | ~2026-04-08 | AI Gateway federating MCP, A2A, REST/gRPC with unified endpoint, guardrails, observability | Slot 5 (MCP Gateway) | IBM-grade federation proxy; A2A support and gRPC translation are unique among MCP gateways |
| 10 | [microsoft/mcp-gateway](https://github.com/microsoft/mcp-gateway) | 574 | (file present) | ~2025 Q4 | ~2026-04-09 | K8s-native MCP reverse proxy: stateful session routing, lifecycle management of MCP servers | Slot 5 (MCP Gateway) | Production K8s deployment model for MCP — fills enterprise Kubernetes gap not covered by other gateways |
| 11 | [agentgateway/agentgateway](https://github.com/agentgateway/agentgateway) | 2.4k | Apache 2.0 | 2025-03-18 | 2026-04-08 | LF-project Rust proxy on MCP + A2A protocols: security, observability, governance at agent layer | Slot 5 (MCP Gateway) | Linux Foundation backing; Rust-native A2A+MCP mesh is the open-standard path for multi-agent comms |
| 12 | [agentic-community/mcp-gateway-registry](https://github.com/agentic-community/mcp-gateway-registry) | 485 | MIT | ~2025 Q4 | 2026-03-28+ | Enterprise MCP gateway + OAuth registry with Keycloak/Entra, OTLP export, encrypted credentials | Slot 5 (MCP Gateway) | Governance-first registry with real IdP integration; addresses auth gap in raw MCP setups |
| 13 | [decolua/9router](https://github.com/decolua/9router) | 2.3k | MIT | ~2026-Q1 | ~2026-04-09 | Unified local proxy connecting Claude Code, Cursor, Codex, Gemini, OpenCode to 40+ providers | Slot 6 (LLM Router/Proxy) | Agent-tool-aware routing layer — routes by tool not by chat, making it a genuine agent-native gateway |
| 14 | [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) | 2.4k | MIT | ~2025 Q4 | 2026-04-09 | OpenAI-compatible AI gateway: smart routing, load balancing, fallbacks, 60+ providers, MCP server | Slot 6 (LLM Router/Proxy) | Free/low-cost routing with MCP server built-in; integrates directly into Claude Code tool calls |
| 15 | [BlockRunAI/ClawRouter](https://github.com/BlockRunAI/ClawRouter) | 6.2k | MIT | 2026-02-03 | ~2026-04-09 | Agent-native LLM router: <1ms local routing, 41+ models, USDC x402 micropayments on Base/Solana | NEW CATEGORY: Web3-Native LLM Router | Crypto payment rails for inference opens composable pay-per-call agent patterns |
| 16 | [voidmind-io/voidllm](https://github.com/voidmind-io/voidllm) | 27 | BSL 1.1 → Apache 2.0 | 2026-03-17 | ~2026-04-08 | Zero-knowledge self-hosted LLM gateway: no prompt persistence, Go binary, <2ms overhead | Slot 6 (LLM Router/Proxy) | Privacy-by-architecture design pattern: only metadata logged, ideal for regulated Claude Code deployments |
| 17 | [kevinrgu/autoagent](https://github.com/kevinrgu/autoagent) | 4k | MIT | 2026-04-02 | ~2026-04-09 | Meta-agent that autonomously engineers its own harness via `program.md` → `agent.py` loop | Slot 9 (Self-Improving) | Pure meta-programming pattern: human edits spec, agent edits code — closest to Dark Factory concept |
| 18 | [razzant/ouroboros](https://github.com/razzant/ouroboros) | 487 | (file present) | 2026-02-16 | ~2026-04-08 | Self-modifying AI agent (git commits its own source), governed by BIBLE.md, multi-LLM review | Slot 9 (Self-Improving) | Constitutional self-modification with git as the evolution record; multi-LLM review gate prevents divergence |
| 19 | [ruvnet/SAFLA](https://github.com/ruvnet/SAFLA) | 145 | MIT | ~2025 Q4 | ~2026-04-08 | Self-Aware Feedback Loop Algorithm: hybrid memory, 172k ops/sec, MCP integration for Claude Code | Slot 9 (Self-Improving) | Quantified self-improvement metrics (ops/sec, compression ratio) plus native Claude Code MCP hook |
| 20 | [probelabs/probe](https://github.com/probelabs/probe) | 537 | (file present) | ~2025 Q4 | 2026-04-07 | AI-friendly semantic code search: ripgrep speed + tree-sitter AST parsing, MCP-compatible | Slot 15 (Code Search/Index) | Drop-in MCP server for code search; ripgrep+AST hybrid is fastest architecture in category |
| 21 | [cortexkit/aft](https://github.com/cortexkit/aft) | 31 | MIT | ~2026-Q1 | ~2026-04-08 | Tree-sitter code analysis toolkit for AI agents: semantic edit, call-graph nav, structural search (Rust) | Slot 15 (Code Search/Index) | Addresses code-by-symbol vs code-by-line gap; trigram background index for sub-ms search |
| 22 | [Helweg/opencode-codebase-index](https://github.com/Helweg/opencode-codebase-index) | 35 | MIT | ~2026-Q1 | ~2026-03-28 | Rust+tree-sitter semantic codebase index for OpenCode; vector+hybrid search as MCP server | Slot 15 (Code Search/Index) | Millisecond incremental re-index via Rust native module; first dedicated OpenCode semantic index |
| 23 | [kodustech/kodus-ai](https://github.com/kodustech/kodus-ai) | 1k | AGPLv3 | 2025-03-28 | 2026-04-02 | AI code review agent: model-agnostic, AST-aware, GitHub/GitLab/Bitbucket/Azure, self-hosted | Slot 17 (AI Code Review) | Self-hosted + model-choice code review with AST context; not locked to a SaaS; strong corpus gap |
| 24 | [awslabs/cli-agent-orchestrator](https://github.com/awslabs/cli-agent-orchestrator) | 451 | Apache 2.0 | ~2025 Q4 | ~2026-04-08 | Lightweight tmux-based multi-agent orchestrator for Claude Code, Codex, Kiro, Gemini, Copilot CLIs | Slot 2 (Orchestration) | AWS-backed CLI-neutral orchestrator; supervisor/worker pattern supports handoff+assign+message patterns |
| 25 | [OpenHands/software-agent-sdk](https://github.com/OpenHands/software-agent-sdk) | 213 | MIT | ~2025-11 | ~2026-04-10 | Modular OpenHands V1 SDK: optional isolation, event-sourced state, two-layer composability | Slot 8 (Autonomous Coding Agent) | Research-grade SDK with MLSys 2026 oral paper; composable packaging enables Claude Code-style sub-SDKs |
| 26 | [anthropics/claude-agent-sdk-typescript](https://github.com/anthropics/claude-agent-sdk-typescript) | 1.3k | Anthropic CToS | 2025-09-27 | 2026-04-10 | Official Anthropic TypeScript SDK for programmatic Claude Code agent building | Slot 1 (Agent Harness) | Native SDK replacing Claude Code SDK name; `supportedAgents()` + `agentProgressSummaries` added April 2026 |
| 27 | [cachix/devenv](https://github.com/cachix/devenv) | 6.7k | Apache 2.0 | 2022-10-22 | 2026-03-22 | Fast declarative Nix developer environments; v2.0 adds <100ms activation, Rust FFI backend | Slot 19 (Dev Environment) | v2.0 (March 5 2026) is a breaking upgrade: Rust C-FFI replaces Nix subprocess calls — materially changes inner-loop timing |
| 28 | [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | 37.9k | (file present) | 2025-04-19 | 2026-04-10 | Curated list of Claude Code skills, hooks, slash-commands, orchestrators, plugins — 1000+ entries | Slot 13 (Skills/Awesome List) | Primary community discovery hub; reached issue #1000 in March 2026; APRIL UPDATE issue active |
| 29 | [kodustech/cli](https://github.com/kodustech/cli) | ~200 | (file present) | ~2026 Q1 | ~2026-04-08 | Kodus AI code review from terminal — built for Claude Code, Cursor, and 20+ agents | Slot 17 (AI Code Review) | Terminal-first code review that integrates directly as a Claude Code tool/hook |
| 30 | [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | ~500 | (file present) | ~2026-02 | ~2026-04-08 | Agent harness performance optimization: skills, instincts, memory, security, research-first | Slot 13 (Skills/Harness) | Security-first harness patterns + research-first development workflow; Cerebral Valley hackathon origin |

---

## Claude Code Native Feature Additions (April 7–11, 2026)

These are not repos but first-party Claude Code changes shipping in the scout window:

| Feature | Version | Date | Description |
|---------|---------|------|-------------|
| Focus View | 2.1.97 | Apr 9 | `Ctrl+O` toggle: prompt + tool summary + response in distraction-free view |
| Monitor Tool | 2.1.98 | Apr 9 | New tool for streaming events from background scripts — enables background agent supervision |
| Subprocess Sandboxing | 2.1.98 | Apr 9 | PID namespace isolation on Linux with configurable script limits |
| Vertex AI Wizard | 2.1.98 | Apr 9 | Interactive Google Cloud auth setup |
| Team Onboarding Command | 2.1.101 | Apr 11 | `/team-onboarding` generates ramp-up guides from local session history |
| Remote Session Auto-Setup | 2.1.101 | Apr 11 | `/ultraplan` auto-creates cloud environments |
| MCP maxResultSizeChars | ~2.1.90 | Apr 2026 | Allows DB schemas up to 500K via `_meta["anthropic/maxResultSizeChars"]` annotation |
| Voice STT (20 languages) | ~2.1.90 | Apr 2026 | Russian, Polish, Turkish, Dutch, Ukrainian, Greek, Czech, Danish, Swedish, Norwegian added |
| Claude Agent SDK renamed | 0.2.101 | Apr 10 | Claude Code SDK renamed Claude Agent SDK; `supportedAgents()` + `agentProgressSummaries` added |

Source: https://releasebot.io/updates/anthropic/claude-code and https://github.com/anthropics/claude-agent-sdk-typescript/blob/main/CHANGELOG.md

---

## New Categories Implied by >= 2 Projects

### NEW CATEGORY A: Agent-Native LLM Router (Slot Gap)
**Current gap:** LiteLLM (proxy/SDK) and Portkey (SaaS) are in corpus but agent-aware local routers are not.  
**Projects:**  
- `decolua/9router` — routes by agent tool type, not by chat model preference  
- `BlockRunAI/ClawRouter` — <1ms local routing, 41+ models, agent-native design  
- `diegosouzapw/OmniRoute` — smart fallback gateway with MCP server built-in  

**Why this is a distinct category:** These are not API proxies — they understand agent tool calls, perform sub-ms local routing decisions, and some include payment rails. They sit between the harness and the LLM, invisible to the user but critical to cost and latency.

---

### NEW CATEGORY B: Local-First Rust Agent Runtime (Slot Gap)
**Current gap:** Corpus has E2B, Daytona, Modal (cloud sandboxes) and devcontainer (Docker). No bare-metal Rust-native category.  
**Projects:**  
- `zeroclaw-labs/zeroclaw` — full Rust, <5MB RAM, <10ms startup, multi-platform  
- `BlockRunAI/ClawRouter` — Rust router, <1ms, targets IoT/edge hardware  
- `cortexkit/aft` — Rust code analysis, background trigram index  

**Why distinct:** These aim for embedded/IoT/constrained environments where Docker cannot run. They are not sandbox runners — they ARE the agent runtime. Claude Code on Raspberry Pi is the target.

---

### NEW CATEGORY C: Semantic Code Indexing as MCP Server (Slot Gap)
**Current gap:** Corpus has Zoekt (text search) and ast-grep (structural). No embedded vector-index-as-MCP category.  
**Projects:**  
- `probelabs/probe` — ripgrep+tree-sitter+MCP, drops into any agent  
- `cortexkit/aft` — symbol-aware edit+search toolkit for AI agents (Rust, MCP)  
- `Helweg/opencode-codebase-index` — Rust+tree-sitter+usearch MCP server for OpenCode  

**Why distinct:** These are not CLI tools or standalone services — they expose code intelligence as MCP tools consumable by Claude Code, Cursor, Windsurf, etc. The MCP interface changes the integration story entirely.

---

### NEW CATEGORY D: Harness Skills Registry / Awesome Lists as Infrastructure (Slot Gap)
**Current gap:** Corpus has individual skill repos (mattpocock/skills, Skill_Seekers) but not the discovery/distribution layer.  
**Projects:**  
- `VoltAgent/awesome-agent-skills` — 1000+ cross-agent skills, 15.2k stars  
- `VoltAgent/awesome-claude-code-subagents` — 130+ subagents, 17k stars  
- `hesreallyhim/awesome-claude-code` — 37.9k stars, primary community hub, 1000+ entries  

**Why distinct:** These are not skill implementations — they are the skill discovery and distribution layer. As skills become inter-harness portable (Claude Code → Codex → Gemini CLI), the registry layer gains critical infrastructure status.

---

### NEW CATEGORY E: Self-Modifying / Meta-Engineering Agents (Partial overlap with Slot P)
**Current gap:** Corpus Part P references Ouroboros-style conceptually but has no concrete implementations.  
**Projects:**  
- `kevinrgu/autoagent` — human edits `program.md`, meta-agent rewrites `agent.py`, hill-climbs benchmarks  
- `razzant/ouroboros` — agent commits own source via git, multi-LLM review gate, BIBLE.md constitution  
- `ruvnet/SAFLA` — quantified self-improvement (172k ops/sec), hybrid memory, MCP-integrated  
- `NousResearch/hermes-agent` — creates skills from experience, modifies own behavior across sessions  

**Why distinct from Part P:** These are production systems (not research demos) with measurable loops, guard rails, and deployment footprints. The meta-engineering pattern (spec → code → benchmark → commit) is new.

---

## Source Notes & Data Freshness

- Star counts are as of April 11, 2026; expect rapid changes in this category
- Creation dates marked `~` are estimated from release notes or blog posts where GitHub metadata was not surfaced
- Repos with `(file present)` for license have LICENSE files whose type could not be confirmed via web fetch
- `kodustech/cli` and `affaan-m/everything-claude-code` have lower confidence on exact dates — treat as indicative
- `voidmind-io/voidllm` uses Business Source License 1.1 (not fully open source until 4 years post-release per version)
- `zeroclaw-labs/zeroclaw` created Feb 13 falls outside the strict March 28 window but had massive growth acceleration in the window (trending April 8 week, ~29k→30k stars)
- `NousResearch/hermes-agent` created July 2025 but v0.8.0 released April 8 and is among the top trending repos this window

---

## Sources

- [GitHub Trending Weekly 2026-04-08](https://www.shareuhack.com/en/posts/github-trending-weekly-2026-04-08)
- [Claude Code Release Notes April 2026](https://releasebot.io/updates/anthropic/claude-code)
- [LangChain Open SWE Blog](https://blog.langchain.com/open-swe-an-open-source-framework-for-internal-coding-agents/)
- [OpenHands V1 SDK Introduction](https://openhands.dev/blog/introducing-the-openhands-software-agent-sdk)
- [devenv 2.0 release announcement](https://devenv.sh/blog/2026/03/05/devenv-20-a-fresh-interface-to-nix/)
- [Hermes Agent by Nous Research](https://hermes-agent.nousresearch.com/)
- [agentgateway.dev](https://agentgateway.dev/)
- [IBM ContextForge docs](https://ibm.github.io/mcp-context-forge/)
