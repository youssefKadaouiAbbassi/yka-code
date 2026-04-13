# Deep Research: Unbounded GitHub Ecosystem Search
**Date**: 2026-04-12  
**Scope**: 20 search angles, no predefined category filter  
**Goal**: Find everything with significant traction NOT in v4 blueprint  

---

## METHODOLOGY

Ran 20 parallel search angles across star-sorted queries, org-level sweeps, and topic-level searches. Each result was evaluated against known v4 components (claude-code CLI, oh-my-claudecode, mcp-servers list, anthropic SDK, sandbox runtimes, observability tools, skill frameworks). Projects already in v4 are marked [V4]. Novel finds are marked [NEW] with a category assignment.

---

## SECTION 1: RAW FINDINGS BY SEARCH ANGLE

### Search 1: `github.com "claude code" stars:>1000`

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| anthropics/claude-code | 81,000+ | [V4] | Core product |
| instructkr/claw-code | 100,000+ | [NEW] | Clean-room Rust rewrite of Claude Code architecture |
| affaan-m/everything-claude-code | 149,400 | [NEW] | Agent harness optimization system, 149k stars, #44 globally |
| rohitg00/awesome-claude-code-toolkit | trending #1 Feb 2026 | [NEW] | Comprehensive toolkit: 135 agents, 35 skills, 176+ plugins |
| hesreallyhim/awesome-claude-code | significant | [NEW] | Curated skills/hooks/slash-commands/orchestrators list |
| obra/superpowers | 146,300 | [NEW] | Agentic skills framework, TDD-enforcing, #47 globally |
| SuperClaude-Org/SuperClaude_Framework | 22,236 | [NEW] | Configuration framework with personas/methodologies |
| alirezarezvani/claude-skills | 5,200 | [NEW] | 232+ cross-harness skills (Claude/Codex/Gemini/Cursor) |

### Search 2: `github.com "mcp server" stars:>500 2026`

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| modelcontextprotocol/servers | very high | [V4] | Official reference servers |
| github/github-mcp-server | high | [V4] | GitHub official MCP |
| microsoft/playwright-mcp | 30,400 | [NEW] | Microsoft's Playwright MCP server |
| microsoft/mcp | significant | [NEW] | Catalog of official Microsoft MCP servers |
| modelcontextprotocol/registry | active | [NEW] | Community MCP registry service |
| modelcontextprotocol/go-sdk | active | [NEW] | Official Go SDK for MCP (maintained w/ Google) |
| tolkonepiu/best-of-mcp-servers | significant | [NEW] | Weekly-ranked MCP server list |

### Search 3: `github.com "CLAUDE.md" stars:>500 agent framework`

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| wshobson/agents | notable | [NEW] | Multi-agent orchestration for Claude Code |
| VoltAgent/awesome-agent-skills | 15,200 | [V4] | 1000+ cross-harness skills |
| caramaschiHG/awesome-ai-agents-2026 | active | [NEW] | 300+ agent resources, 20+ categories, updated monthly |
| affaan-m/everything-claude-code | 149,400 | [NEW] | (see above) |
| FlorianBruniaux/claude-code-ultimate-guide | notable | [NEW] | Comprehensive Claude Code guide with templates |

### Search 4: Firecrawl / mendableai Ecosystem

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| mendableai/firecrawl | 108,000+ | [NEW] | Web Data API for AI — LLM-ready markdown from any URL |
| mendableai/firecrawl-mcp-server | high | [NEW] | Official Firecrawl MCP Server |
| mendableai/fireplexity | notable | [NEW] | Open-source Perplexity-like search engine powered by Firecrawl |
| mendableai/firecrawl-observer | notable | [NEW] | Website change monitoring tool |
| mendableai/firegeo | notable | [NEW] | GEO-powered SaaS starter for brand monitoring |

### Search 5: Karpathy 2026 Active Repos

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| karpathy/autoresearch | 53,500 | [NEW] | AI agents auto-running nanochat training experiments overnight |
| karpathy/microgpt (gist) | 9,132 | [NEW] | 200-line pure Python GPT training/inference |

### Search 6: HKUDS Organization

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| HKUDS/LightRAG | 33,000 | [NEW] | EMNLP2025 — fast, simple RAG with knowledge graphs |
| HKUDS/RAG-Anything | 15,600 | [NEW] | All-in-one multimodal RAG (text/images/tables/equations) |

### Search 7: VoltAgent Organization

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| VoltAgent/voltagent | significant | [NEW] | TypeScript AI Agent Engineering Platform |
| VoltAgent/voltagent-python | active | [NEW] | Python SDK with console tracing |
| VoltAgent/awesome-design-md | 43,200 | [NEW] | DESIGN.md collection — drop-in design system for AI agents |
| VoltAgent/awesome-agent-skills | 15,200 | [V4] | Already known |
| VoltAgent/awesome-claude-code-subagents | 16,900 | [V4] | Already known |
| VoltAgent/awesome-codex-subagents | significant | [NEW] | 130+ specialized Codex subagents |
| VoltAgent/awesome-openclaw-skills | notable | [NEW] | 5,400+ skills from OpenClaw Skills Registry |
| VoltAgent/awesome-ai-agent-papers | active | [NEW] | Curated 2026 AI agent research papers |

### Search 8: Anthropic Org (Beyond claude-code)

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| anthropics/skills | 115,000 | [NEW] | Official public Agent Skills repository — 115k stars |
| anthropics/claude-agent-sdk-python | 4,000 | [NEW] | Official Python SDK for Claude Agent (bundles Claude Code CLI) |
| anthropics/claude-agent-sdk-typescript | significant | [NEW] | Official TypeScript Agent SDK |
| anthropics/claude-agent-sdk-demos | active | [NEW] | Demo apps for Claude Agent SDK |

### Search 9: Google Workspace CLI

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| googleworkspace/cli | 20,800 | [NEW] | Official Google Workspace CLI with 40+ AI agent skills |

### Search 10: DESIGN.md / Google Stitch

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| VoltAgent/awesome-design-md | 43,200 | [NEW] | (see above) |
| google-labs-code/stitch-skills | active | [NEW] | Official Google Stitch agent skills including design-md skill |

### Search 11: Agent Skill Frameworks (Cross-Harness)

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| obra/superpowers | 146,300 | [NEW] | (see above) |
| sickn33/antigravity-awesome-skills | 32,000 | [NEW] | 1,370+ skills, installer CLI, bundles for 6+ coding agents |
| gmh5225/awesome-skills | notable | [NEW] | Curated list for Claude/Codex/Gemini/Copilot |
| Orchestra-Research/AI-Research-SKILLs | notable | [NEW] | 83 AI research skills, Prompt Guard, v0.15.0 Feb 2026 |
| FrancyJGLisboa/agent-skill-creator | notable | [NEW] | Turn any workflow into SKILL.md for 14+ tools |
| heilcheng/awesome-agent-skills | notable | [NEW] | Tutorials, guides, skills directories |

### Search 12: NotebookLM Integrations

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| teng-lin/notebooklm-py | 10,000 | [NEW] | Unofficial Python API + agentic skill for NotebookLM |
| PleasePrompto/notebooklm-mcp | active | [NEW] | MCP server for NotebookLM (Claude/Codex grounded answers) |
| PleasePrompto/notebooklm-skill | active | [NEW] | Agent skill for NotebookLM with browser automation |
| proyecto26/notebooklm-ai-plugin | active | [NEW] | AI plugin for NotebookLM (slides, audio, mind maps, etc.) |
| lfnovo/open-notebook | notable | [NEW] | Open-source NotebookLM implementation |

### Search 13: Web Scraping / Browser Automation

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| browser-use/browser-use | 78,000 | [NEW] | Make websites accessible for AI agents |
| unclecode/crawl4ai | 62,300 | [NEW] | LLM-friendly web crawler/scraper, 62k stars |
| steel-dev/steel-browser | 6,804 | [NEW] | Browser API sandbox for AI agents (batteries-included) |
| steel-dev/awesome-web-agents | notable | [NEW] | Curated tools for building AI web agents |
| microsoft/playwright-mcp | 30,400 | [NEW] | (see above) |

### Search 14: RAG Frameworks (>5k stars)

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| langchain-ai/langchain | 126,000 | [NEW] | LLM application framework, chains/agents/retrieval |
| langgenius/dify | 134,000 | [NEW] | LLMOps platform, visual workflow builder, 134k stars |
| infiniflow/ragflow | 70,000 | [NEW] | RAG engine with agentic capabilities, 70k stars |
| HKUDS/LightRAG | 33,000 | [NEW] | (see above) |
| FlowiseAI/Flowise | 39,000 | [NEW] | Drag-and-drop AI agents built on LangChain |
| langflow-ai/langflow | high | [NEW] | Low-code AI builder for agentic and RAG apps |
| n8n-io/n8n | 177,000 | [NEW] | Workflow automation with native AI, 177k stars |
| langfuse/langfuse | 21,000 | [NEW] | Open-source LLM engineering platform (observability/evals) |
| yichuan-w/LEANN | notable | [NEW] | MLSys2026 — RAG with 97% storage savings on personal device |

### Search 15: Local LLM + Claude Code Integrations

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| anomalyco/opencode | 126,000 | [NEW] | Open-source provider-agnostic coding agent, 126k stars |
| opencode-ai/opencode | mirror/fork | [NEW] | Alternative opencode org |
| awesome-opencode/awesome-opencode | 5,007 | [NEW] | Curated plugins/themes/agents for opencode.ai |
| Gitlawb/openclaude | notable | [NEW] | Open-source Claude Code CLI for 200+ models via OpenAI-compat |
| HaisamAbbas/OpenCode | notable | [NEW] | Fully local coding agent using Mistral/Qwen/DeepSeek |

### Search 16: Productivity CLI / Workflow Orchestration

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| googleworkspace/cli | 20,800 | [NEW] | (see above) |
| devxoul/vibe-notion | notable | [NEW] | Notion automation CLI for AI agents |
| netresearch/jira-skill | active | [NEW] | Claude Code plugin for Jira (Server/DC + Cloud) |
| super-productivity/super-productivity | 16,000+ | [NEW] | Dev productivity app with Jira/GitHub/GitLab integrations |

### Search 17: Cross-Harness / Cursor Rules Ecosystem

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| sickn33/antigravity-awesome-skills | 32,000 | [NEW] | (see above) |
| alirezarezvani/claude-skills | 5,200 | [NEW] | (see above) |

### Search 18: Awesome Lists

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| rohitg00/awesome-claude-code-toolkit | high | [NEW] | (see above) |
| hesreallyhim/awesome-claude-code | notable | [NEW] | (see above) |
| caramaschiHG/awesome-ai-agents-2026 | active | [NEW] | (see above) |
| InftyAI/Awesome-LLMOps | notable | [NEW] | Curated LLMOps tools list |
| restyler/awesome-sandbox | notable | [NEW] | Code sandboxing for AI agents |
| quemsah/awesome-claude-plugins | active | [NEW] | Automated Claude Code plugin adoption metrics via n8n |

### Search 19: Build Loop / Agent OS

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| rivet-dev/agent-os | active | [NEW] | Portable open-source OS for agents: 6ms coldstarts, WebAssembly/V8 isolates |
| rivet-dev/rivet | active | [NEW] | Rivet Actors — stateful workloads primitive for AI agents |
| rivet-dev/sandbox-agent | active | [NEW] | HTTP-controlled coding agent sandboxes (Claude Code/Codex/OpenCode/Amp) |
| agent-sandbox/agent-sandbox | notable | [NEW] | E2B-compatible enterprise Kubernetes agent sandbox |

### Search 20: Gemini CLI + Google Agent Skills

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| google-gemini/gemini-cli | high | [NEW] | Official open-source Gemini CLI agent |
| google-gemini/gemini-skills | active | [NEW] | Official Gemini agent skills repository |
| google-labs-code/stitch-skills | active | [NEW] | (see above) |

### Search 21: LLM Observability

| Repo | Stars | Status | Notes |
|------|-------|--------|-------|
| langfuse/langfuse | 21,000 | [NEW] | (see above) |
| traceloop/openllmetry | 6,900 | [NEW] | OpenTelemetry-based LLM observability, 40+ providers |
| openlit/openlit | notable | [NEW] | OpenTelemetry-native LLM platform: obs/GPU/evals/prompts |

---

## SECTION 2: COMPLETE NEW FINDS CATALOG

### TIER 1 — Critical Misses (>20k stars, clearly not in v4)

| # | Repo | Stars | License | One-Line Description | v4 Slot | Why It Matters |
|---|------|-------|---------|----------------------|---------|----------------|
| 1 | affaan-m/everything-claude-code | 149,400 | MIT | Agent harness optimization: skills, instincts, memory, security for 4 coding agents | NEW: Harness Meta-Framework | #44 globally; 149k stars; the largest Claude Code ecosystem project not in v4 |
| 2 | obra/superpowers | 146,300 | MIT | Agentic skills framework enforcing TDD + structured planning across all coding agents | NEW: Methodology Framework | #47 globally; 146k stars; Jesse Vincent's framework accepted into official Anthropic plugin marketplace |
| 3 | anomalyco/opencode | 126,000 | MIT | Provider-agnostic Go-based terminal coding agent (75+ providers, TUI, offline) | NEW: Alt Coding Agent | 126k stars; #1 HN; competes directly with Claude Code but is model-agnostic |
| 4 | n8n-io/n8n | 177,000 | Sustainable Use | Workflow automation with native AI/agent capabilities, 400+ integrations | NEW: Workflow Automation | 177k stars; feeds agent pipelines; critical upstream for agentic workflows |
| 5 | langgenius/dify | 134,000 | Apache 2.0 | LLMOps platform with visual workflow builder, RAG, and agent runtime | NEW: LLMOps Platform | 134k stars; used to deploy agents; massive adoption in enterprise |
| 6 | mendableai/firecrawl | 108,000+ | AGPL 3.0 | Web Data API for AI — turn any website into LLM-ready markdown | NEW: Web Data Pipeline | 108k stars; primary web ingestion layer for agents; MCP server available |
| 7 | instructkr/claw-code | 100,000+ | MIT | Fastest repo ever to 100k stars — Rust rewrite of Claude Code architecture | NEW: Alt Coding Agent | 100k stars in one day; significant ecosystem signal even if controversial |
| 8 | browser-use/browser-use | 78,000 | MIT | Make websites accessible for AI agents — browser automation library | NEW: Browser Agent Runtime | 78k stars; the standard Python library for agent web browsing |
| 9 | infiniflow/ragflow | 70,000 | Apache 2.0 | RAG engine with agentic workflow orchestration and citation tracking | NEW: RAG Platform | 70k stars; enterprise RAG with graph-based orchestration |
| 10 | unclecode/crawl4ai | 62,300 | Apache 2.0 | LLM-friendly open-source web crawler and scraper | NEW: Web Crawler | 62k stars; most popular open-source crawler; built-in MCP server since v0.8 |
| 11 | karpathy/autoresearch | 53,500 | MIT | AI agents auto-running overnight ML training experiments | NEW: Research Automation | 53k stars; Karpathy's 2026 project; defines "agentic research loop" pattern |
| 12 | FlowiseAI/Flowise | 39,000 | Apache 2.0 | Drag-and-drop AI agents and RAG pipeline builder | NEW: Visual Agent Builder | 39k stars; widely used no-code agent builder |
| 13 | HKUDS/LightRAG | 33,000 | MIT | Simple and fast RAG with knowledge graph indexing (EMNLP 2025) | NEW: RAG Library | 33k stars; the knowledge-graph RAG reference implementation |
| 14 | sickn33/antigravity-awesome-skills | 32,000 | MIT | 1,370+ installable skills for Claude Code/Cursor/Codex/Gemini/Antigravity | NEW: Cross-Harness Skill Registry | 32k stars; installer CLI, bundles; broader than v4's skill entries |
| 15 | microsoft/playwright-mcp | 30,400 | Apache 2.0 | Microsoft's official Playwright MCP server for browser automation | NEW: MCP Server (Browser) | 30k stars; first-party Microsoft MCP; missing from v4 MCP list |
| 16 | anthropics/skills | 115,000 | MIT | Official Anthropic public Agent Skills repository | NEW: Official Skill Registry | 115k stars; THE canonical skills source, directly from Anthropic |
| 17 | VoltAgent/awesome-design-md | 43,200 | MIT | DESIGN.md collection — drop design system files into projects for consistent AI-generated UI | NEW: Design System Layer | 43k stars; defines the DESIGN.md protocol; new ecosystem category |
| 18 | googleworkspace/cli | 20,800 | Apache 2.0 | Official Google Workspace CLI for Drive/Gmail/Calendar/Sheets with 40+ AI agent skills | NEW: Productivity CLI | 20.8k stars; official Google product; agent-native from day one |
| 19 | google-gemini/gemini-cli | very high | Apache 2.0 | Official open-source Gemini terminal agent (Agent Skills preview in v0.23+) | NEW: Alt Coding Agent (Google) | Official Google coding agent; peer of Claude Code and Codex CLI |
| 20 | SuperClaude-Org/SuperClaude_Framework | 22,236 | MIT | Configuration framework enhancing Claude Code with specialized commands, personas, methodologies | NEW: Claude Config Framework | 22k stars; distinct from skills — focuses on behavioral injection |

### TIER 2 — Significant Finds (5k-20k stars or strategic importance)

| # | Repo | Stars | License | One-Line Description | Category |
|---|------|-------|---------|----------------------|----------|
| 21 | langchain-ai/langchain | 126,000 | MIT | LLM framework for chains, agents, retrieval | NEW: Agent Orchestration Framework |
| 22 | langfuse/langfuse | 21,000 | MIT | Open-source LLM engineering platform: tracing, evals, prompt mgmt | NEW: LLM Observability |
| 23 | langflow-ai/langflow | high | MIT | Low-code AI builder for agents and RAG | NEW: Visual Agent Builder |
| 24 | HKUDS/RAG-Anything | 15,600 | Apache 2.0 | All-in-one multimodal RAG (text/images/tables/equations) | NEW: Multimodal RAG |
| 25 | steel-dev/steel-browser | 6,804 | Apache 2.0 | Open-source browser API sandbox for AI agents | NEW: Browser Sandbox |
| 26 | traceloop/openllmetry | 6,900 | Apache 2.0 | OpenTelemetry-based observability for 40+ LLM providers | NEW: LLM Observability |
| 27 | teng-lin/notebooklm-py | 10,000 | MIT | Unofficial Python API + agentic skill for Google NotebookLM | NEW: Knowledge Tool Integration |
| 28 | VoltAgent/voltagent | significant | Apache 2.0 | TypeScript AI Agent Engineering Platform | NEW: Agent Platform |
| 29 | alirezarezvani/claude-skills | 5,200 | MIT | 232+ skills for Claude/Codex/Gemini/Cursor and 8 more agents | NEW: Cross-Harness Skill Registry |
| 30 | google-labs-code/stitch-skills | active | Apache 2.0 | Official Google Stitch skills including DESIGN.md generator | NEW: Design AI Skills |
| 31 | karpathy/microgpt (gist) | 9,132 | MIT | 200-line pure Python GPT — canonical minimal LLM implementation | NEW: Educational Reference |
| 32 | rivet-dev/agent-os | active | Apache 2.0 | Portable OS for agents: 6ms coldstarts, WebAssembly + V8 isolates | NEW: Agent OS Runtime |
| 33 | rivet-dev/sandbox-agent | active | Apache 2.0 | HTTP-controlled sandbox for Claude Code/Codex/OpenCode/Amp agents | NEW: Agent Sandbox |
| 34 | google-gemini/gemini-skills | active | Apache 2.0 | Official Google repository for Gemini agent skills | NEW: Official Skill Registry |
| 35 | openlit/openlit | notable | Apache 2.0 | OpenTelemetry-native: LLM obs, GPU monitoring, guardrails, evals | NEW: LLM Platform |
| 36 | awesome-opencode/awesome-opencode | 5,007 | MIT | Curated plugins/themes/agents for opencode.ai ecosystem | NEW: Ecosystem Directory |
| 37 | rohitg00/awesome-claude-code-toolkit | trending #1 Feb 2026 | MIT | 135 agents, 35 skills, 176+ plugins, 14 MCP configs, toolkit | NEW: Ecosystem Toolkit |
| 38 | mendableai/firecrawl-mcp-server | high | MIT | Official Firecrawl MCP server for web scraping in Claude/Cursor | NEW: MCP Server (Web) |
| 39 | Orchestra-Research/AI-Research-SKILLs | active | MIT | 83 AI research skills with Prompt Guard for any agent | NEW: Research Skills |
| 40 | super-productivity/super-productivity | 16,000+ | MIT | Developer productivity app with Jira/GitHub/GitLab integrations | NEW: Productivity Tool |

### TIER 3 — Notable Finds (strategic or category-defining)

| Repo | Stars | Description | Category |
|------|-------|-------------|----------|
| anthropics/claude-agent-sdk-python | 4,000 | Official Python SDK wrapping Claude Agent + Code CLI | Official SDK |
| anthropics/claude-agent-sdk-typescript | notable | Official TypeScript Agent SDK | Official SDK |
| modelcontextprotocol/registry | active | Community-driven MCP server registry | MCP Infrastructure |
| modelcontextprotocol/go-sdk | active | Official Go MCP SDK (maintained with Google) | MCP SDK |
| microsoft/mcp | notable | Catalog of official Microsoft MCP servers | MCP (Enterprise) |
| PleasePrompto/notebooklm-mcp | active | MCP server for NotebookLM | MCP Server (Knowledge) |
| devxoul/vibe-notion | notable | Notion automation CLI for AI agents | Productivity CLI |
| netresearch/jira-skill | active | Claude Code plugin for Jira Server/DC/Cloud | Productivity Skill |
| caramaschiHG/awesome-ai-agents-2026 | active | 300+ resources across 20 categories, updated monthly | Ecosystem Directory |
| InftyAI/Awesome-LLMOps | notable | Curated LLMOps tools | LLMOps |
| VoltAgent/awesome-codex-subagents | notable | 130+ specialized Codex subagents | Subagent Collection |
| FrancyJGLisboa/agent-skill-creator | notable | One SKILL.md → 14+ coding agent tools | Skill Authoring Tool |
| wshobson/agents | active | Multi-agent orchestration for Claude Code | Orchestration |
| hesreallyhim/awesome-claude-code | notable | Curated Claude Code skills/hooks/commands | Ecosystem Directory |
| quemsah/awesome-claude-plugins | active | Automated n8n-based plugin adoption metrics | Plugin Analytics |
| mendableai/fireplexity | notable | Open-source Perplexity alternative powered by Firecrawl | Search Engine |

---

## SECTION 3: NEW CATEGORIES IMPLIED

The following category slots do NOT exist in v4 but are implied by findings:

### NC-1: Harness Meta-Frameworks
Frameworks that sit above a single coding agent (Claude Code, Codex, Gemini CLI, OpenCode) and optimize the agent's behavioral patterns, skills, memory, and security across multiple harnesses simultaneously.
- **Example repos**: affaan-m/everything-claude-code (149k), obra/superpowers (146k), SuperClaude-Org/SuperClaude_Framework (22k)

### NC-2: Alternative Coding Agents
Open-source coding agents that compete with or extend Claude Code, often provider-agnostic or local-LLM friendly.
- **Example repos**: anomalyco/opencode (126k), instructkr/claw-code (100k), google-gemini/gemini-cli (official), HaisamAbbas/OpenCode (local)

### NC-3: Web Data Pipeline / Crawler Layer
Tools that transform the live web into LLM-consumable data — the "input layer" for agents that need real-time information.
- **Example repos**: mendableai/firecrawl (108k), unclecode/crawl4ai (62k), browser-use/browser-use (78k), steel-dev/steel-browser (6.8k)

### NC-4: LLMOps / Workflow Platforms
Visual and programmatic platforms for building, deploying, and monitoring multi-step LLM agent workflows.
- **Example repos**: langgenius/dify (134k), n8n-io/n8n (177k), FlowiseAI/Flowise (39k), langflow-ai/langflow

### NC-5: RAG Libraries and Platforms
Retrieval-Augmented Generation frameworks that feed agent memory systems.
- **Example repos**: infiniflow/ragflow (70k), HKUDS/LightRAG (33k), HKUDS/RAG-Anything (15.6k), yichuan-w/LEANN

### NC-6: LLM Observability / Eval Platforms
OpenTelemetry-native tracing, evaluation, and monitoring for LLM and agent applications.
- **Example repos**: langfuse/langfuse (21k), traceloop/openllmetry (6.9k), openlit/openlit

### NC-7: Design System Protocol Layer (DESIGN.md)
A new protocol where DESIGN.md files give AI coding agents complete brand/design context for UI generation.
- **Example repos**: VoltAgent/awesome-design-md (43k), google-labs-code/stitch-skills

### NC-8: Agent OS / Micro-Runtime
Ultra-lightweight isolated runtimes optimized for sub-10ms agent task execution using WebAssembly/V8.
- **Example repos**: rivet-dev/agent-os (6ms coldstarts), rivet-dev/sandbox-agent

### NC-9: Research Automation Agents
Agents designed for automated scientific experiment loops — running training, benchmarking, and iterating without human checkpoints.
- **Example repos**: karpathy/autoresearch (53.5k)

### NC-10: Productivity CLI Integration Layer
Agent-native CLIs for SaaS productivity tools (Google Workspace, Notion, Jira, Linear) — the "agent interface to enterprise SaaS".
- **Example repos**: googleworkspace/cli (20.8k), devxoul/vibe-notion, netresearch/jira-skill

### NC-11: Cross-Harness Official Skill Registries
Official, organization-maintained skill registries covering multiple coding agent harnesses simultaneously.
- **Example repos**: anthropics/skills (115k), google-gemini/gemini-skills, VoltAgent/awesome-agent-skills (15.2k)

### NC-12: Knowledge Tool Integrations (NotebookLM)
Agent skills and MCP servers bridging AI coding agents to personal knowledge bases (NotebookLM, etc.).
- **Example repos**: teng-lin/notebooklm-py (10k), PleasePrompto/notebooklm-mcp

---

## SECTION 4: STAR COUNT REFERENCE TABLE (sorted descending)

| Repo | Stars (Apr 2026) | Category |
|------|-----------------|----------|
| n8n-io/n8n | 177,000 | Workflow Automation |
| affaan-m/everything-claude-code | 149,400 | Harness Meta-Framework |
| obra/superpowers | 146,300 | Methodology Framework |
| langgenius/dify | 134,000 | LLMOps Platform |
| anthropics/skills | 115,000 | Official Skill Registry |
| mendableai/firecrawl | 108,000+ | Web Data API |
| instructkr/claw-code | 100,000+ | Alt Coding Agent |
| browser-use/browser-use | 78,000 | Browser Agent Runtime |
| infiniflow/ragflow | 70,000 | RAG Platform |
| unclecode/crawl4ai | 62,300 | Web Crawler |
| karpathy/autoresearch | 53,500 | Research Automation |
| VoltAgent/awesome-design-md | 43,200 | Design Protocol |
| FlowiseAI/Flowise | 39,000 | Visual Agent Builder |
| HKUDS/LightRAG | 33,000 | RAG Library |
| sickn33/antigravity-awesome-skills | 32,000 | Cross-Harness Skills |
| microsoft/playwright-mcp | 30,400 | MCP Server (Browser) |
| SuperClaude-Org/SuperClaude_Framework | 22,236 | Claude Config Framework |
| langfuse/langfuse | 21,000 | LLM Observability |
| googleworkspace/cli | 20,800 | Productivity CLI |
| super-productivity/super-productivity | 16,000+ | Productivity Tool |
| HKUDS/RAG-Anything | 15,600 | Multimodal RAG |
| teng-lin/notebooklm-py | 10,000 | Knowledge Tool |
| karpathy/microgpt (gist) | 9,132 | Educational Reference |
| traceloop/openllmetry | 6,900 | LLM Observability |
| steel-dev/steel-browser | 6,804 | Browser Sandbox |
| awesome-opencode/awesome-opencode | 5,007 | Ecosystem Directory |
| alirezarezvani/claude-skills | 5,200 | Cross-Harness Skills |
| anthropics/claude-agent-sdk-python | 4,000 | Official SDK |

---

## SECTION 5: ALREADY-IN-V4 CONFIRMED

The following were confirmed as already present or clearly implied in v4:
- anthropics/claude-code (core)
- VoltAgent/awesome-agent-skills
- VoltAgent/awesome-claude-code-subagents
- modelcontextprotocol/servers
- github/github-mcp-server
- oh-my-claudecode ecosystem (the research framework itself)
- E2B sandbox runtime
- Daytona development environments
- LangChain (langchain-ai/langchain) — likely referenced but undersized in v4

---

## SOURCES

All findings sourced from live web searches conducted 2026-04-12:
- https://github.com/affaan-m/everything-claude-code
- https://github.com/obra/superpowers
- https://github.com/anomalyco/opencode
- https://github.com/n8n-io/n8n
- https://github.com/langgenius/dify
- https://github.com/mendableai/firecrawl
- https://github.com/instructkr/claw-code
- https://github.com/browser-use/browser-use
- https://github.com/infiniflow/ragflow
- https://github.com/unclecode/crawl4ai
- https://github.com/karpathy/autoresearch
- https://github.com/VoltAgent/awesome-design-md
- https://github.com/FlowiseAI/Flowise
- https://github.com/HKUDS/LightRAG
- https://github.com/HKUDS/RAG-Anything
- https://github.com/sickn33/antigravity-awesome-skills
- https://github.com/microsoft/playwright-mcp
- https://github.com/anthropics/skills
- https://github.com/SuperClaude-Org/SuperClaude_Framework
- https://github.com/langfuse/langfuse
- https://github.com/googleworkspace/cli
- https://github.com/google-gemini/gemini-cli
- https://github.com/google-gemini/gemini-skills
- https://github.com/google-labs-code/stitch-skills
- https://github.com/steel-dev/steel-browser
- https://github.com/traceloop/openllmetry
- https://github.com/openlit/openlit
- https://github.com/teng-lin/notebooklm-py
- https://github.com/PleasePrompto/notebooklm-mcp
- https://github.com/rivet-dev/agent-os
- https://github.com/rivet-dev/sandbox-agent
- https://github.com/VoltAgent/voltagent
- https://github.com/anthropics/claude-agent-sdk-python
- https://github.com/anthropics/claude-agent-sdk-typescript
- https://github.com/modelcontextprotocol/registry
- https://github.com/modelcontextprotocol/go-sdk
- https://github.com/microsoft/mcp
- https://github.com/awesome-opencode/awesome-opencode
- https://github.com/super-productivity/super-productivity
- https://github.com/rohitg00/awesome-claude-code-toolkit
- https://github.com/alirezarezvani/claude-skills
- https://github.com/Orchestra-Research/AI-Research-SKILLs
- https://github.com/langflow-ai/langflow
- https://github.com/FrancyJGLisboa/agent-skill-creator
