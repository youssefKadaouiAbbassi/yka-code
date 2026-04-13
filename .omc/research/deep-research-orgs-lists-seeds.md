# Deep Research: Org-Graph Crawl · Awesome-List Diff · Seed Expansion

**Generated:** 2026-04-12  
**Scope:** 15 org crawls · 6 awesome-list diffs · 10 seed expansions  
**Purpose:** Find gaps in the v4 blueprint (~200 components / 30 slots)

---

## PART A — ORG-GRAPH CRAWLING

### 1. `anthropics` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| skills | 115,480 | Official Agent Skills registry | KNOWN |
| claude-code | 112,792 | Agentic terminal tool | KNOWN |
| knowledge-work-plugins | 11,107 | Plugins for knowledge workers / CoWork | KNOWN |
| claude-agent-sdk-python | 6,269 | Python SDK for Claude agents | KNOWN |
| courses | 20,493 | Educational coursework from Anthropic | **NEW — v4 candidate** |
| claude-cookbooks | 37,986 | Notebooks/recipes for Claude usage | **NEW — v4 candidate** |
| prompt-eng-interactive-tutorial | 34,588 | Interactive prompt engineering tutorial | **NEW — v4 candidate** |
| claude-plugins-official | 16,716 | Official Anthropic-managed plugin directory | KNOWN |
| anthropic-cli | 276 | CLI for the Claude API (separate from claude-code) | **NEW — minor, low stars** |
| claude-agent-sdk-demos | 2,151 | SDK demo projects | KNOWN |
| claude-quickstarts | 16,036 | Rapid deployment guides | KNOWN |
| claude-code-security-review | 4,217 | Security analysis GitHub Action | **NEW — v4 candidate** |
| financial-services-plugins | 7,415 | Finance-specific plugin collection | **NEW — v4 candidate** |
| claude-code-action | 7,012 | GitHub Actions integration | KNOWN |
| claude-code-base-action | 786 | Base GitHub Action mirror | KNOWN |
| anthropic-tokenizer-typescript | 99 | TypeScript tokenizer | minor |

**Key discoveries NOT in v4:**
- `anthropics/courses` (20.5k⭐) — free educational track, Apache 2.0
- `anthropics/claude-cookbooks` (38k⭐) — recipe library, widely cited
- `anthropics/prompt-eng-interactive-tutorial` (34.6k⭐) — canonical prompt engineering reference
- `anthropics/claude-code-security-review` (4.2k⭐) — AI security CI action
- `anthropics/financial-services-plugins` (7.4k⭐) — vertical domain plugins
- **No `model-spec` or standalone `evals` repo found** — evals content is inside `courses` and `claude-cookbooks`

---

### 2. `karpathy` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| autoresearch | 70,714 | AI agents running ML experiments autonomously | KNOWN |
| nanoGPT | 56,527 | Simplest GPT training repo | Out of scope |
| nanochat | 51,642 | The best ChatGPT $100 can buy | **NEW — v4 candidate** |
| LLM101n | 36,747 | LLM101n: Let's build a Storyteller | **NEW** |
| llm.c | 29,530 | LLM training in pure C/CUDA | Out of scope |
| minGPT | 24,125 | Minimal PyTorch GPT | Out of scope |
| nn-zero-to-hero | 21,376 | Neural Networks: Zero to Hero | Out of scope |
| llm-council | 16,941 | LLM Council multi-model Q&A | **NEW — adjacent** |
| llama2.c | 19,381 | Llama 2 in C | Out of scope |
| micrograd | 15,430 | Tiny autograd engine | Out of scope |
| minbpe | 10,416 | Minimal BPE tokenization | Out of scope |
| reader3 | 3,496 | Read books with LLMs | **NEW — adjacent to NotebookLM** |
| rendergit | 2,183 | Render git repo as HTML for LLMs | **NEW — v4 candidate (context tool)** |
| arxiv-sanity-lite | 1,546 | arxiv recommendation via SVMs | Out of scope |
| build-nanogpt | 4,913 | Video+code nanoGPT build | Out of scope |

**Key discoveries NOT in v4:**
- `karpathy/nanochat` (51.6k⭐) — ultra-cheap personal ChatGPT, distinct product
- `karpathy/rendergit` (2.2k⭐) — repo-to-HTML for LLM context; practical for agents
- `karpathy/llm-council` (16.9k⭐) — multi-model consensus; adjacent to agent orchestration
- **`alvinreal/awesome-autoresearch`** — discovered via search: curated list of autoresearch-style loops including ADAS (ShengranHu), HGM (metauto-ai), GEPA (gepa-ai, ICLR 2026 Oral)

---

### 3. `mendableai` (now `firecrawl`) — Full Public Repo Inventory

> Note: The GitHub org `mendableai` has transitioned to `firecrawl` org. The `mendableai` org API returns empty — all repos migrated.

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| firecrawl | ~108k (est. 40k at time of API query) | Web Data API for AI agents | KNOWN |
| firecrawl-mcp-server | — | Official Firecrawl MCP Server for Cursor/Claude | **NEW — v4 candidate** |
| firecrawl-py | — | Python SDK for Firecrawl | **NEW** |
| firecrawl-app-examples | — | Full application examples | **NEW** |
| firecrawl-docs | — | Documentation repo | **NEW** |
| pdf-inspector | — | Fast Rust PDF inspection library | **NEW** |

**Key discoveries NOT in v4:**
- `firecrawl/firecrawl-mcp-server` — official MCP server for the most popular web scraping API; high integration value
- Organization rename from `mendableai` → `firecrawl` is itself a v4 data point

---

### 4. `HKUDS` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| CLI-Anything | 30,225 | Making ALL Software Agent-Native | **NEW — v4 candidate** |
| nanobot | 39,131 | Ultra-Lightweight Personal AI Agent | **NEW — v4 candidate** |
| LightRAG | 32,990 | Simple/Fast Graph-based RAG | **NEW — v4 candidate** |
| DeepTutor | 17,041 | Agent-Native Personalized Learning | **NEW** |
| AI-Trader | 13,189 | 100% Automated Agent-Native Trading | **NEW** |
| DeepCode | 15,167 | Open Agentic Coding (Paper2Code, Text2Web) | **NEW — v4 candidate** |
| RAG-Anything | 15,582 | All-in-One RAG Framework | KNOWN |
| AutoAgent | 9,108 | Fully-Automated Zero-Code LLM Agent | **NEW — v4 candidate** |
| ClawWork | 7,933 | OpenClaw as AI Coworker | **NEW** |
| OpenHarness | 8,875 | Open Agent Harness with Built-in Personal Agent | KNOWN |
| ClawTeam | 4,702 | Agent Swarm Intelligence | **NEW** |
| OpenSpace | 5,019 | Self-Evolving Agent Space | **NEW** |
| AI-Researcher | 5,108 | Autonomous Scientific Innovation | **NEW** |
| Paper2Slides | 3,283 | Paper-to-Presentation in One Click | **NEW** |
| VideoRAG | 2,857 | Chat with Videos | **NEW** |
| MiniRAG | 1,842 | RAG with Small Open Models | **NEW** |
| Auto-Deep-Research | 1,486 | Fully-Automated Research Assistant | **NEW** |

**Key discoveries NOT in v4 (top picks):**
- `HKUDS/CLI-Anything` (30.2k⭐) — agent-native CLI wrapper for any software
- `HKUDS/nanobot` (39.1k⭐) — ultra-lightweight personal agent; complement to OpenClaw
- `HKUDS/LightRAG` (33k⭐) — graph-based RAG; EMNLP 2025 paper; massive traction
- `HKUDS/DeepCode` (15.2k⭐) — agentic coding with Paper2Code and Text2Web
- `HKUDS/AutoAgent` (9.1k⭐) — zero-code LLM agent framework
- `HKUDS/AI-Researcher` (5.1k⭐) — autonomous scientific innovation

---

### 5. `VoltAgent` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| awesome-design-md | 44,603 | DESIGN.md files for brand design systems | KNOWN |
| awesome-agent-skills | 15,256 | 1000+ agent skills (multi-platform) | KNOWN |
| awesome-claude-code-subagents | 17,020 | 100+ specialized Claude Code subagents | KNOWN |
| awesome-codex-subagents | 3,842 | 130+ Codex subagents | **NEW — v4 candidate** |
| awesome-openclaw-skills | 45,664 | 5400+ OpenClaw skills filtered/categorized | **NEW — v4 candidate** |
| voltagent | 7,884 | TypeScript AI Agent Engineering Platform | **NEW — v4 candidate** |
| awesome-ai-agent-papers | 547 | Curated 2026 research papers on agents | **NEW** |
| awesome-nemoclaw | 59 | Nvidia NemoClaw presets/recipes | **NEW** |
| awesome-voltagent | 100 | VoltAgent resources list | **NEW** |

**Key discoveries NOT in v4:**
- `VoltAgent/awesome-openclaw-skills` (45.7k⭐) — largest skills collection (5,400+ items); highest priority v4 candidate
- `VoltAgent/awesome-codex-subagents` (3.8k⭐) — Codex counterpart to claude-code-subagents
- `VoltAgent/voltagent` (7.9k⭐) — TypeScript agent engineering platform, open source

---

### 6. `googleworkspace` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| cli | 24,447 | GWS CLI with AI agent skills (Drive, Gmail, Calendar...) | KNOWN |
| md2googleslides | 4,710 | Markdown to Google Slides | **NEW — v4 candidate** |
| apps-script-samples | 5,123 | Apps Script samples | **NEW** |

**Adjacent discovery:**
- `google-labs-code/stitch-skills` — 7 official Stitch skills for agent use (DESIGN.md, enhance-prompt, react:components, remotion); directly complements `awesome-design-md`

---

### 7. `modelcontextprotocol` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| servers | 83,539 | MCP Servers collection | KNOWN |
| python-sdk | 22,602 | Official Python SDK | KNOWN |
| typescript-sdk | 12,166 | Official TypeScript SDK | KNOWN |
| inspector | 9,404 | Visual testing tool for MCP servers | **NEW — v4 candidate** |
| registry | 6,667 | Community MCP server registry | **NEW — v4 candidate** |
| go-sdk | 4,345 | Official Go SDK | **NEW** |
| csharp-sdk | 4,188 | Official C# SDK (Microsoft collaboration) | **NEW** |
| rust-sdk | 3,290 | Official Rust SDK | **NEW** |
| java-sdk | 3,357 | Official Java SDK (Spring AI) | **NEW** |
| ext-apps | 2,042 | MCP Apps protocol spec | **NEW — v4 candidate** |
| modelcontextprotocol | 7,779 | Specification and documentation | KNOWN |
| kotlin-sdk | 1,333 | Official Kotlin SDK (JetBrains) | **NEW** |
| swift-sdk | 1,344 | Official Swift SDK | **NEW** |
| php-sdk | 1,441 | Official PHP SDK | **NEW** |
| ruby-sdk | — | Official Ruby SDK | **NEW** |
| quickstart-resources | 1,058 | Tutorial servers and clients | **NEW** |
| experimental-ext-triggers-events | 3 | MCP Triggers & Events working group | **NEW** |

**Key discoveries NOT in v4:**
- `modelcontextprotocol/inspector` (9.4k⭐) — visual MCP testing tool; high practical value
- `modelcontextprotocol/registry` (6.7k⭐) — community MCP registry; discovery layer
- `modelcontextprotocol/ext-apps` (2k⭐) — embedded AI chatbots / UIs for MCP servers; new protocol surface
- Language SDKs (Go, C#, Rust, Java, Kotlin, Swift, PHP, Ruby) — all post-v4, all official

---

### 8. `microsoft` — Agent-Relevant Repos

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| playwright | 86,195 | Web testing & automation | KNOWN |
| playwright-mcp | — | Official Playwright MCP server | **NEW — v4 candidate** |
| playwright-cli | — | CLI for coding agents (2026) | **NEW — v4 candidate** |
| markitdown | 103,286 | Files/docs to Markdown converter | **NEW — v4 candidate** |
| ai-agents-for-beginners | 56,484 | 12-lesson AI agents curriculum | **NEW** |
| mcp-for-beginners | 15,857 | MCP fundamentals curriculum | **NEW** |
| generative-ai-for-beginners | 109,228 | 21-lesson GenAI curriculum | **NEW** |
| BitNet | 38,136 | Official 1-bit LLM inference | **NEW** |
| vscode-copilot-chat | 9,792 | GitHub Copilot Chat VS Code extension | **NEW** |
| VibeVoice | 38,857 | Open-Source Frontier Voice AI | **NEW** |

**Key discoveries NOT in v4:**
- `microsoft/markitdown` (103.3k⭐) — converts any file format to Markdown; highly relevant for RAG and agent context prep
- `microsoft/playwright-mcp` — official MCP server for Playwright; direct v4 Slot 11 expansion
- `microsoft/playwright-cli` — purpose-built for AI coding agents (2026); token-efficient alternative to MCP

---

### 9. `langchain-ai` — Agent-Relevant Repos

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| langchain | 133,236 | The agent engineering platform | KNOWN |
| deepagents | 20,395 | Agent harness with planning + subagents | **NEW — v4 candidate** |
| langgraph | 29,012 | Build resilient language agents as graphs | KNOWN |
| open-swe | 9,482 | Open-Source Async Coding Agent | KNOWN |
| open_deep_research | 11,081 | Open research agent (LangGraph) | **NEW — v4 candidate** |
| local-deep-researcher | 9,023 | Fully local web research assistant | **NEW — v4 candidate** |
| langchain-skills | 559 | LangChain agent skills (Agent Skills spec) | **NEW — v4 candidate** |
| deepagentsjs | 1,063 | TypeScript Deep Agents | **NEW** |
| agent-chat-ui | 2,705 | Web UI for LangGraph agents | **NEW** |
| deep-agents-ui | — | Custom UI for Deep Agents | **NEW** |
| deep_research_from_scratch | — | Educational deep research implementation | **NEW** |

**Key discoveries NOT in v4:**
- `langchain-ai/deepagents` (20.4k⭐) — comprehensive agent harness with planning, subagents, filesystem; major system
- `langchain-ai/open_deep_research` (11.1k⭐) — LangGraph-based open research agent
- `langchain-ai/local-deep-researcher` (9k⭐) — fully local, Ollama-powered research assistant
- `langchain-ai/langchain-skills` (559⭐) — skills library compatible with Claude Code, Cursor, Windsurf

---

### 10. `BerriAI` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| litellm | 43,002 | Python SDK + proxy for 100+ LLM APIs | KNOWN |
| litellm-skills | 11 | Agent skills for managing live LiteLLM proxy | **NEW** |
| litellm-pgvector | 62 | Vector store + AI gateway | **NEW** |
| litellm-guardrails | 4 | Custom code guardrails registry | **NEW** |
| litellm-performance-benchmarks | 2 | Reproducible LiteLLM benchmarks | **NEW** |
| clerkie-cli | 97 | Terminal LLM debugging tool | **NEW** |

**Key discoveries NOT in v4:** Nothing major beyond the known LiteLLM. Skills and guardrail extensions are minor satellites.

---

### 11. `Piebald-AI` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| claude-code-system-prompts | 8,610 | Full Claude Code system prompts | KNOWN |
| tweakcc | 1,663 | Customize Claude Code system prompts/themes | KNOWN |
| claude-code-lsps | 398 | Claude Code Plugin Marketplace + LSP servers | **NEW — v4 candidate** |
| awesome-gemini-cli | 402 | Curated Gemini CLI tools/extensions | **NEW — v4 candidate** |
| gemini-cli-desktop | 392 | Desktop UI for Gemini CLI/Qwen Code | **NEW** |
| splitrail | 155 | Cross-platform token usage tracker + cost monitor | **NEW — v4 candidate** |
| claude-code-chats | 14 | Fast local viewer for Claude Code sessions | **NEW** |
| claude-code-themes | 7 | Community themes via tweakcc | **NEW** |
| agentskills | 9 | Agent Skills specification and documentation | **NEW** |
| piebald-issues | 7 | Issue tracker for Piebald (agentic AI control) | **NEW** |

**Key discoveries NOT in v4:**
- `Piebald-AI/claude-code-lsps` (398⭐) — LSP server marketplace; unique capability layer
- `Piebald-AI/awesome-gemini-cli` (402⭐) — Gemini CLI ecosystem resource; cross-platform agent tools
- `Piebald-AI/splitrail` (155⭐) — real-time cost monitoring across AI coding tools

---

### 12. `SafeRL-Lab` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| cheetahclaws | 512 | CheetahClaws (Nano Claude Code) — Python-native AI assistant | **NEW — v4 candidate** |
| agentic-web | 458 | Weaving the Next Web with AI Agents | **NEW** |
| AgenticPay | 22 | Multi-Agent LLM Negotiation System | **NEW** |
| Safe-MARL-in-Autonomous-Driving | 101 | Safe multi-agent RL for autonomous vehicles | Out of scope |
| Robust-Gymnasium | 95 | Unified benchmark for robust RL (ICLR 2025) | Out of scope |

**Key discoveries:**
- `SafeRL-Lab/cheetahclaws` (512⭐) — Python-native Claude Code alternative; v3.0 released Apr 2026 with multi-agent, memory, skills (~5000 LOC)
- The "nano-claude-code" repo is actually aliased to `cheetahclaws` per GitHub redirect

---

### 13. `obra` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| superpowers | 147,681 | Agentic skills framework & dev methodology | KNOWN |
| superpowers-skills | 610 | Community-editable skills for Superpowers | **NEW** |
| superpowers-marketplace | 824 | Curated Claude Code plugin marketplace | **NEW — v4 candidate** |
| superpowers-lab | 276 | Experimental Superpowers skills | **NEW** |
| superpowers-chrome | 242 | Chrome browser control via DevTools Protocol | **NEW** |
| superpowers-developing-for-claude-code | 116 | Dev guide for building Superpowers plugins | **NEW** |
| private-journal-mcp | 326 | MCP server for private AI journaling | **NEW** |
| episodic-memory | 341 | Episodic memory system | **NEW — v4 candidate** |
| streamlinear | 76 | Streamlined Linear integration for Claude Code | **NEW** |
| packnplay | 156 | Docker-sandboxed execution + worktree management | **NEW — v4 candidate** |
| knowledge-graph | 59 | Obsidian vault as knowledge graph | **NEW** |
| the-elements-of-style | 334 | Strunk's Elements of Style for AI agents (markdown) | **NEW** |
| amplifier-bundle-superpowers | 34 | TDD workflow system for Claude Code | **NEW** |
| mira-OSS | 9 | MIRA OS with discrete memories + auto-configuring tools | **NEW** |
| smallest-agent | 85 | Tiny agent | **NEW** |

**Key discoveries NOT in v4:**
- `obra/superpowers-marketplace` (824⭐) — curated plugin marketplace; catalog layer
- `obra/episodic-memory` (341⭐) — persistent episodic memory system
- `obra/packnplay` (156⭐) — Docker-sandboxed agent execution with worktrees
- `obra/superpowers-chrome` (242⭐) — DevTools Protocol browser control plugin

---

### 14. `paperclipai` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| paperclip | 51,968 | Open-source orchestration for zero-human companies | **NEW — v4 candidate** |
| companies | 360 | Companies directory | **NEW** |
| clipmart | 49 | AI-agent company marketplace | **NEW** |
| companies-tool | 14 | npx companies tool | **NEW** |
| pr-reviewer | 6 | PR triage UI | **NEW** |

**Key discoveries NOT in v4:**
- `paperclipai/paperclip` (52k⭐) — autonomous company orchestration; highest-value discovery from this org; zero-human company paradigm is emergent in 2026

---

### 15. `upstash` — Full Public Repo Inventory

| Repo | Stars | Description | v4 Status |
|------|-------|-------------|-----------|
| context7 | 52,405 | Up-to-date docs for LLMs and AI code editors | KNOWN |
| memo | 104 | Save/restore conversation across agents (MCP) | **NEW — v4 candidate** |
| box | 21 | TypeScript SDK + CLI for sandboxed AI coding agents | **NEW — v4 candidate** |
| botstreet | 83 | Three AI agents, $100k each, real market prices | **NEW** |
| jstack | 3,774 | Fast, lightweight, typesafe Next.js apps | **NEW** |
| ratelimit-js | 2,031 | Rate limiting for serverless runtimes | **NEW** |
| workflow-js | 147 | Durable, Reliable Serverless Functions | **NEW** |

**Key discoveries NOT in v4:**
- `upstash/memo` (104⭐) — cross-agent conversation memory via MCP; critical infrastructure
- `upstash/box` (21⭐) — sandboxed AI coding agent execution environment; emerging

---

## PART B — AWESOME-LIST SYSTEMATIC DIFF

### 1. `hesreallyhim/awesome-claude-code` (~38k⭐)

**Total entries extracted:** ~200+ named projects across 15+ categories

**Top projects NOT in v4 blueprint (by significance):**

| Project | URL | Category |
|---------|-----|----------|
| SuperClaude | github.com/SuperClaude-Org/SuperClaude_Framework | Configuration framework |
| Claude Task Master | github.com/eyaltoledano/claude-task-master | Orchestration |
| Claude Squad | github.com/smtg-ai/claude-squad | Orchestration |
| Claude Swarm | github.com/parruda/claude-swarm | Orchestration |
| Container Use (Dagger) | github.com/dagger/container-use | Dev environments |
| claudekit | github.com/carlrannaberg/claudekit | CLI toolkit with checkpointing |
| Crystal | github.com/stravu/crystal | Desktop orchestrator |
| Claude Hub | github.com/claude-did-this/claude-hub | GitHub webhook integration |
| Claude Code Flow | github.com/ruvnet/claude-code-flow | Code-first orchestration |
| Ruflo | github.com/ruvnet/ruflo | Multi-agent swarm platform |
| cc-tools (Go) | github.com/Veraticus/cc-tools | High-performance Go hooks |
| TDD Guard | github.com/nizos/tdd-guard | TDD enforcement hooks |
| VoiceMode MCP | github.com/mbailey/voicemode | Voice conversations for Claude Code |
| Simone | github.com/Helmi/claude-simone | Project management workflow |
| scopecraft/command | github.com/scopecraft/command | SDLC management commands |
| Trail of Bits Security Skills | github.com/trailofbits/skills | Professional security skills |
| Context Priming / just-prompt | github.com/disler/just-prompt | Systematic priming |
| ContextKit (FlineDev) | github.com/FlineDev/ContextKit | 4-phase planning framework |
| AB Method | github.com/ayoubben18/ab-method | Spec-driven workflow |
| Everything Claude Code | github.com/affaan-m/everything-claude-code | 152k⭐ — comprehensive harness |

**Ralph ecosystem (entirely distinct sub-category):**
- ralph-orchestrator, ralph-claude-code, The Ralph Playbook, ralph-wiggum-bdd, awesome-ralph

**Notable missing tooling:**
- `recall` (full-text search for CC sessions), `cclogviewer`, `cchistory`, `ccexp` (interactive config explorer)
- Emacs/Neovim IDE integrations: `claude-code.nvim`, `claude-code.el`, `claude-code-ide.el`
- Usage monitors: `ccusage`, `ccflare`, `better-ccflare`, `Vibe-Log`, `viberank`
- Status lines: `CCometixLine`, `ccstatusline`, `claude-powerline`, `claudia-statusline`
- Hooks SDK: `cchooks` (Python), `claude-hooks-sdk` (PHP Laravel), `claude-hooks` (TypeScript)
- Alt clients: `Claudable`, `Omnara`, `claude-esp` (Go TUI), `claude-tmux`

**Estimated entries NOT in v4:** ~140 of ~200 total

---

### 2. `rohitg00/awesome-claude-code-toolkit` (~1.2k⭐)

**Total entries:** 850+ files across 18 categories

**Top projects NOT in v4:**

| Project | URL | Notes |
|---------|-----|-------|
| oh-my-claudecode | github.com/Yeachan-Heo/oh-my-claudecode | 27.9k⭐ |
| vibe-kanban | github.com/BloopAI/vibe-kanban | Kanban for agents |
| ccswarm | github.com/nwiizo/ccswarm | Agent swarm |
| ORCH | github.com/oxgeneral/ORCH | Multi-agent CLI runtime |
| paco-framework | github.com/PenguinAlleyApps/paco-framework | Agent framework |
| fractal | github.com/rmolines/fractal | Workflow system |
| simmer | github.com/2389-research/simmer | Simulation harness |
| discoclaw | github.com/DiscoClaw/discoclaw | Discord integration |
| harness-evolver | github.com/raphaelchristi/harness-evolver | Evolving harness |
| claude-context | github.com/zilliztech/claude-context | Context management (Zilliz) |
| Bouncer | github.com/buildingopen/bouncer | Quality gate |
| AgentLint | github.com/0xmariowu/AgentLint | Agent linting |
| VibeGuard | github.com/majiayu000/vibeguard | Safety guard |
| review-squad | github.com/2389-research/review-squad | Review orchestration |
| ccmanager | github.com/kbwo/ccmanager | Session manager |

**Estimated entries NOT in v4:** ~600 of 850+

---

### 3. `davila7/claude-code-templates` (~24.4k⭐)

- Primarily a template/CLI platform (aitmpl.com) with 200+ agents, commands, settings, hooks, MCPs via interactive dashboard
- Notable addition: `K-Dense-AI/claude-scientific-skills` (139 scientific skills across biology, chemistry, medicine, finance)
- Most individual components overlap with other lists
- **Estimated new entries NOT in v4:** ~30–50 templates and configuration bundles

---

### 4. `Chat2AnyLLM/awesome-claude-skills`

- **Total skills indexed:** 55,527 (as of 2026-04-12)
- 13 categories: Backend, AI & LLM, Data & Analytics, Version Control, Frontend, DevOps, Tools, ML, Testing, Security, Documentation, Business
- Sister repos: `awesome-claude-agents`, `awesome-claude-plugins`, `code-assistant-manager`
- **Estimated entries NOT in v4:** The sheer volume (55k+) is the key finding; v4 blueprint cannot enumerate individual skills at this scale. The registry index itself (`Chat2AnyLLM` platform) is the v4 candidate, not individual skills.

---

### 5. `andyrewlee/awesome-agent-orchestrators` — 96 Projects

**All 96 projects catalogued** (see Appendix). Top entries NOT in v4 by category:

**Parallel Runners (45 projects — nearly all new):**
- `amux` (andyrewlee/amux) — TUI for parallel coding agents
- `crystal` (stravu/crystal) — multi-session parallel worktrees
- `jean` (coollabsio/jean) — desktop/web agent orchestrator
- `symphony` (openai/symphony) — OpenAI's autonomous implementation runner
- `vibe-kanban` (BloopAI) — kanban for agents
- `dorothy` — desktop app with Kanban + MCP + automations
- `mux` (coder/mux) — isolated parallel agentic development

**Personal Assistants (44 projects — mostly new):**
- `lettabot` (letta-ai) — persistent memory personal assistant
- `nanobot` (HKUDS) — already flagged
- `OpenClaw` ecosystem (openclaw, nanoclaw, ironclaw, NemoClaw, ClawWork, etc.)
- `hermes-agent` (NousResearch, 62.4k⭐) — "the agent that grows with you"
- `leon` (leon-ai/leon) — open-source voice+text personal assistant

**Multi-Agent Swarms (21 projects — all new):**
- `paperclip` (paperclipai) — zero-human company orchestration
- `ClawTeam` (HKUDS) — agent swarm intelligence
- `kodo` — orchestrates Claude Code, Codex, Gemini CLI agents
- `gnap` — Git-Native Agent Protocol (shared git repo as task board)
- `opengoat` — autonomous AI organizations

**Autonomous Loop Runners (6 projects):**
- ralph-orchestrator, ralph-claude-code, ralph-tui, ralphy, toryo, wreckit

**Estimated entries NOT in v4:** ~85 of 96

---

### 6. `chauncygu/collection-claude-code-source-code`

- Primary content: decompiled Claude Code v2.1.88 TypeScript source (163,318 lines) + Nano Claude Code Python rewrite (v3.0, ~5000 lines)
- Key project discovered: `SafeRL-Lab/nano-claude-code` (aliased to `cheetahclaws`) — v3.0 with multi-agent, memory, skill system
- Also surfaces `Claw Code` (instructkr/claw-code, 100k+⭐) — Rust+Python clean-room rewrite; fastest repo in GitHub history
- **Estimated entries NOT in v4:** 5–10 core infrastructure projects

---

## PART C — SEED EXPANSION

### Seed 1: Codex CLI (OpenAI)

| Adjacent Tool | URL | Relationship | v4 Candidate? |
|---------------|-----|--------------|---------------|
| openai/symphony | github.com/openai/symphony | OpenAI's multi-agent autonomous runner | YES |
| VoltAgent/awesome-codex-subagents | github.com/VoltAgent/awesome-codex-subagents | 130+ Codex subagents | YES |
| Piebald-AI/awesome-gemini-cli | github.com/Piebald-AI/awesome-gemini-cli | Cross-platform CLI ecosystem comparison | YES |
| FrancyJGLisboa/agent-skill-creator | github.com/FrancyJGLisboa/agent-skill-creator | Cross-platform skill factory (14+ tools) | YES |
| kodo (ikamensh/kodo) | github.com/ikamensh/kodo | Orchestrates Claude Code + Codex + Gemini | YES |

**Codex plugin ecosystem:** Slack, Figma, Notion, Gmail, Linear, Sentry connectors. Community "Awesome Codex CLI" has 150+ tools in 20 categories. Codex is at 9,000+ community plugins but far behind Claude Code's 55k+.

---

### Seed 2: Obsidian

| Adjacent Tool | URL | Relationship | v4 Candidate? |
|---------------|-----|--------------|---------------|
| iansinnott/obsidian-claude-code-mcp | github.com/iansinnott/obsidian-claude-code-mcp | Obsidian vault → MCP server for Claude Code | YES |
| jacksteamdev/obsidian-mcp-tools | github.com/jacksteamdev/obsidian-mcp-tools | Semantic search + Templater prompts for Obsidian | YES |
| MarkusPfundstein/mcp-obsidian | github.com/MarkusPfundstein/mcp-obsidian | REST API-based Obsidian MCP server | YES |
| obra/knowledge-graph | github.com/obra/knowledge-graph | Obsidian vault as knowledge graph (query/traverse) | YES |
| Obsidian Agent Client plugin | Obsidian community plugin | Brings Claude Code, Codex, Gemini CLI inside Obsidian | YES |

---

### Seed 3: karpathy/autoresearch

| Adjacent Tool | URL | Relationship | v4 Candidate? |
|---------------|-----|--------------|---------------|
| alvinreal/awesome-autoresearch | github.com/alvinreal/awesome-autoresearch | Curated list of autoresearch-style loops | YES |
| ShengranHu/ADAS | github.com/ShengranHu/ADAS | Automated Design of Agentic Systems (ICLR 2025) | YES |
| gepa-ai/gepa | github.com/gepa-ai/gepa | Genetic-Pareto reflective prompt evolution (ICLR 2026 Oral) | YES |
| langchain-ai/open_deep_research | github.com/langchain-ai/open_deep_research | LangGraph-based open research agent | YES |
| langchain-ai/local-deep-researcher | github.com/langchain-ai/local-deep-researcher | Fully local Ollama research assistant | YES |
| HKUDS/AI-Researcher | github.com/HKUDS/AI-Researcher | Autonomous scientific innovation (HKUDS) | YES |
| HKUDS/Auto-Deep-Research | github.com/HKUDS/Auto-Deep-Research | Fully automated research assistant | YES |

---

### Seed 4: awesome-design-md

| Adjacent Tool | URL | Relationship | v4 Candidate? |
|---------------|-----|--------------|---------------|
| google-labs-code/stitch-skills | github.com/google-labs-code/stitch-skills | Official Google Stitch skills (DESIGN.md, enhance-prompt, react:components) | YES |
| nut-tree-fork/nut.js / screenshot-to-code | github.com/abi/screenshot-to-code | Screenshot → code (Tailwind, React, etc.) | YES |
| vercel/v0 | v0.dev | Generative UI from text/images | YES (external) |
| MindStudio Stitch integration | mindstudio.ai | DESIGN.md workflow for Claude Code | reference |
| Remotion skill | via stitch-skills | Generate walkthrough videos from Stitch projects | YES |

---

### Seed 5: Firecrawl (Web Scraping)

| Adjacent Tool | URL | Stars | v4 Candidate? |
|---------------|-----|-------|---------------|
| Crawl4AI | github.com/unclecode/crawl4ai | 58k⭐ | YES — highest priority |
| Jina Reader | github.com/jina-ai/reader | — | YES |
| ScrapeGraphAI | github.com/ScrapeGraphAI/Scrapegraph-ai | — | YES |
| Spider.cloud | spider.cloud | — | YES (commercial) |
| Apify | github.com/apify/apify-sdk-js | — | YES (platform) |
| firecrawl/firecrawl-mcp-server | github.com/mendableai/firecrawl-mcp-server | — | YES |

**Summary:** Crawl4AI (58k⭐) is the highest-priority addition — largest open-source web crawler on GitHub, #1 trending at launch.

---

### Seed 6: Playwright (Extensions for Agents)

| Adjacent Tool | URL | Relationship | v4 Candidate? |
|---------------|-----|--------------|---------------|
| microsoft/playwright-mcp | github.com/microsoft/playwright-mcp | Official Playwright MCP server | YES |
| microsoft/playwright-cli | github.com/microsoft/playwright-cli | Token-efficient CLI for coding agents (2026) | YES |
| executeautomation/mcp-playwright | github.com/executeautomation/mcp-playwright | Community MCP for Claude Desktop, Cline, Cursor | YES |
| Stealth Browser MCP | playbooks.com/mcp/newbeb-stealth-browser | Anti-detection stealth browser MCP | YES |
| Playwright MCP Bridge | Chrome Web Store | Real browser state (cookies/auth) for agents | YES |

---

### Seed 7: NotebookLM-py

| Adjacent Tool | URL | Relationship | v4 Candidate? |
|---------------|-----|--------------|---------------|
| teng-lin/notebooklm-py | github.com/teng-lin/notebooklm-py | Unofficial Python API + skills for NotebookLM | KNOWN |
| PleasePrompto/notebooklm-skill | github.com/PleasePrompto/notebooklm-skill | NotebookLM skill with browser automation + auth | YES |
| jacob-bd/notebooklm-mcp-cli | github.com/jacob-bd/notebooklm-mcp-cli | NotebookLM MCP + CLI unified package (Jan 2026) | YES |
| google-labs-code/stitch-skills | github.com/google-labs-code/stitch-skills | Design-to-code Google AI integration | YES |

---

### Seed 8: Skill Creator (anthropics/skills)

| Adjacent Tool | URL | Relationship | v4 Candidate? |
|---------------|-----|--------------|---------------|
| FrancyJGLisboa/agent-skill-creator | github.com/FrancyJGLisboa/agent-skill-creator | Cross-platform skill factory (14+ tools) | YES |
| Skill Forge | skillforge.dev | 8-agent pipeline skill builder (5-10 min) | YES |
| google-labs-code/stitch-skills | github.com/google-labs-code/stitch-skills | Google's official skill set with skill-creator | YES |
| langchain-ai/langchain-skills | github.com/langchain-ai/langchain-skills | LangChain skills (Agent Skills spec) | YES |
| MiniMax Agent Skill Creator | agent.minimax.io/skill-creator | NL-driven skill builder | reference |
| skillcreatorai/ai-agent-skills | explainx.ai/skills/skillcreatorai | Community skill factory | YES |
| oh-my-claudecode:skillify | (OMC built-in) | In-session skill generation for OMC | KNOWN |

---

### Seed 9: RAG-Anything (HKUDS)

| Adjacent Tool | URL | Stars | v4 Candidate? |
|---------------|-----|-------|---------------|
| HKUDS/LightRAG | github.com/HKUDS/LightRAG | 33k⭐ | YES — highest priority |
| microsoft/graphrag | github.com/microsoft/graphrag | — | YES |
| nano-graphrag | github.com/gusye1234/nano-graphrag | — | YES |
| InfiniFlow/ragflow | github.com/infiniflow/ragflow | — | YES |
| weaviate/Verba | github.com/weaviate/Verba | — | YES |
| deepset-ai/haystack | github.com/deepset-ai/haystack | — | YES |
| run-llama/kotaemon | github.com/Cinnamon/kotaemon | — | YES |

**Priority ranking:** LightRAG (33k⭐, graph-based, EMNLP 2025) > RAGFlow (UI, DAG editor) > Haystack (production) > Verba (Weaviate) > kotaemon (customizable UI)

---

### Seed 10: Google Workspace CLI

| Adjacent Tool | URL | Relationship | v4 Candidate? |
|---------------|-----|--------------|---------------|
| obra/streamlinear | github.com/obra/streamlinear | Streamlined Linear for Claude Code | YES |
| krodak/clickup-cli | github.com/krodak/clickup-cli | ClickUp CLI with Claude Code skill | YES |
| notion-sdk-js (official) | github.com/makenotion/notion-sdk-js | Notion JS SDK (base for agent skills) | reference |
| composio agent skills | ComposioHQ | Jira, Linear, Notion, Todoist skills | YES (platform) |
| googleworkspace/md2googleslides | github.com/googleworkspace/md2googleslides | Markdown → Google Slides (4.7k⭐) | YES |
| PleasePrompto/notebooklm-skill | github.com/PleasePrompto/notebooklm-skill | Google NotebookLM via browser automation | YES |

**Key insight:** The Codex plugin system launched with native Slack, Figma, Notion, Gmail, Linear, Sentry connectors (March 2026) — these are now official cross-platform productivity agent skills.

---

## APPENDIX: OpenClaw Ecosystem (Major New Paradigm)

The OpenClaw ecosystem (November 2025 → April 2026) represents a major new paradigm not captured in v4:

| Project | Stars | Description |
|---------|-------|-------------|
| openclaw/openclaw | — | Personal AI assistant connected to messaging apps |
| HKUDS/nanobot | 39k⭐ | Ultra-lightweight OpenClaw-compatible assistant |
| VoltAgent/awesome-openclaw-skills | 45.7k⭐ | 5,400+ filtered/categorized OpenClaw skills |
| NVIDIA/NemoClaw | — | NVIDIA plugin for secure OpenClaw installation |
| instructkr/claw-code | 100k+⭐ | Rust+Python clean-room Claude Code rewrite |
| SafeRL-Lab/cheetahclaws | 512⭐ | Python-native OpenClaw-inspired agent |
| Various ClawXxx variants | — | nanoclaw, ironclaw, ClawWork, ClawTeam, ClawSec |

This entire ecosystem (~15+ repos) appears to be absent from v4.

---

## TOP-PRIORITY v4 CANDIDATES SUMMARY

### Tier 1 — Highest Impact (should definitely earn a slot)

| # | Repo | Stars | Reason |
|---|------|-------|--------|
| 1 | instructkr/claw-code | 100k+ | Fastest GitHub repo ever; Rust+Python CC rewrite; defines new ecosystem |
| 2 | paperclipai/paperclip | 52k | Zero-human company orchestration; new paradigm |
| 3 | HKUDS/nanobot | 39k | Ultra-lightweight personal agent; highest-starred HKUDS non-RAG |
| 4 | VoltAgent/awesome-openclaw-skills | 45.7k | Largest skills collection (5,400+) |
| 5 | unclecode/crawl4ai | 58k | #1 open-source web crawler; core agent infrastructure |
| 6 | HKUDS/LightRAG | 33k | Graph-based RAG; EMNLP 2025; complements RAG-Anything |
| 7 | anthropics/claude-cookbooks | 38k | Official Anthropic recipe library; highly cited |
| 8 | microsoft/markitdown | 103k | Files/docs to Markdown; essential agent context tool |
| 9 | HKUDS/CLI-Anything | 30k | Agent-native CLI wrapper for all software |
| 10 | langchain-ai/deepagents | 20.4k | Full agent harness with planning/subagents/filesystem |

### Tier 2 — Strong Additions

| # | Repo | Stars | Reason |
|---|------|-------|--------|
| 11 | anthropics/prompt-eng-interactive-tutorial | 34.6k | Canonical prompt engineering reference |
| 12 | modelcontextprotocol/inspector | 9.4k | Visual MCP testing; essential for MCP development |
| 13 | modelcontextprotocol/registry | 6.7k | Community MCP discovery registry |
| 14 | FrancyJGLisboa/agent-skill-creator | — | Cross-platform skill factory (14+ tools) |
| 15 | google-labs-code/stitch-skills | — | Official Google Stitch agent skills |
| 16 | langchain-ai/open_deep_research | 11k | Configurable LangGraph research agent |
| 17 | upstash/memo | 104 | Cross-agent conversation memory via MCP |
| 18 | iansinnott/obsidian-claude-code-mcp | — | Obsidian vault → MCP for Claude Code |
| 19 | microsoft/playwright-mcp | — | Official Playwright MCP server |
| 20 | Piebald-AI/claude-code-lsps | 398 | LSP server marketplace for Claude Code |

---

## SOURCES

- [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) — canonical CC awesome list
- [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) — comprehensive toolkit
- [davila7/claude-code-templates](https://github.com/davila7/claude-code-templates) — template platform
- [Chat2AnyLLM/awesome-claude-skills](https://github.com/Chat2AnyLLM/awesome-claude-skills) — 55,527 skills indexed
- [andyrewlee/awesome-agent-orchestrators](https://github.com/andyrewlee/awesome-agent-orchestrators) — 96 orchestrators
- [chauncygu/collection-claude-code-source-code](https://github.com/chauncygu/collection-claude-code-source-code) — CC source code collection
- [alvinreal/awesome-autoresearch](https://github.com/alvinreal/awesome-autoresearch) — autoresearch loops
- [VoltAgent/awesome-openclaw-skills](https://github.com/VoltAgent/awesome-openclaw-skills) — OpenClaw skills registry
- GitHub Topics: [claude-code](https://github.com/topics/claude-code) — top repos by stars
- [Claw Code](https://claw-code.codes/) — Rust+Python CC rewrite
- GitHub API endpoints for all 15 orgs (anthropics, karpathy, mendableai/firecrawl, HKUDS, VoltAgent, googleworkspace, modelcontextprotocol, microsoft, langchain-ai, BerriAI, Piebald-AI, SafeRL-Lab, obra, paperclipai, upstash)
