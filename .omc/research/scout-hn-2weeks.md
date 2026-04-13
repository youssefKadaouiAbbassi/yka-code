# HN Scout Report: March 28 – April 11 2026
**Generated:** 2026-04-11 | **Scope:** Claude Code / agent / LLM coding / MCP / sandbox / orchestration / skill
**Method:** Algolia HN Search API (`hn.algolia.com`) with Unix epoch range 1774652400–1775944799, supplemented by direct HN WebSearch queries across 12 topic clusters.

---

## NEWLY IMPLIED CATEGORIES (flag first)

Three topic clusters appear repeatedly across multiple HN posts in the window and have **no dedicated slot** in the v3 blueprint:

### Category A — MCP Security / Audit Infrastructure
Multiple posts: Wombat (rwxd permissions), Lilith-zero (Rust security middleware), MCP Gateway zero-trust, "We security-graded 20K MCP servers", "What 16 Security Engines Found in 2,900 MCP Servers", JitAPI (dynamic tool discovery / token reduction). The ecosystem has evolved past "which MCP servers to use" into "how to govern, audit, and harden the MCP layer itself." The blueprint covers MCP servers as tools but has no slot for MCP security policy/audit infrastructure.

### Category B — Agent-Native Memory (beyond RAG / vector)
Hippo (biologically-inspired), MemPalace (benchmark leader), OpenExp (Q-learning memory), DecisionNode (shared structured memory via MCP), SQLite Memory, Memdir, Memoir, Vektor, Palinode (git-versioned markdown), Continuity, Engram (knowledge graph + NER). The blueprint lists vector store options (memento-mcp, mcp-memory-service etc.) but the wave in this window is around **structured, non-vector, graph-based, or benchmark-verified** memory architectures — a distinct design space.

### Category C — Software Factory / Autonomous Delivery Platforms
Freestyle (YC sandboxes for coding agents, 322 pts), Twill.ai (YC S25, delegate → get back PRs, 75 pts), Druids ("build your own software factory", 61 pts), Fabro ("open-source dark software factory", 6 pts), Eve ("Managed OpenClaw for work", 64 pts). These are not orchestration frameworks or harnesses — they are **end-to-end delivery pipelines** that accept a task and return a merged PR, abstracting away the agent entirely. No v3 slot covers this "one-click autonomous delivery" layer.

---

## TOP 20 PICKS

| # | Name / Repo | Date | Pts | HN URL | Description | Blueprint Slot | Gap Reason |
|---|-------------|------|-----|--------|-------------|----------------|------------|
| 1 | **Freestyle** / freestyle.sh | 2026-04-06 | 322 | https://news.ycombinator.com/item?id=47663147 | YC-backed cloud sandboxes built specifically for coding agents; each sandbox is a container with a full dev env, snapshot/restore, and a REST API the agent calls directly | Sandbox (new sub-tier) | Blueprint covers E2B, Fly Sprites, Daytona, Depot but not Freestyle; it launched in-window as a YC company with the highest sandbox points in the period |
| 2 | **Hippo** / github.com/kitfunso/hippo-memory | 2026-04-06 | 128 | https://news.ycombinator.com/item?id=47667672 | Biologically-inspired memory for AI agents modelled on hippocampal consolidation (episodic → semantic); claims zero external deps, single-file integration | Memory (new architecture) | Blueprint memory slot lists RAG/vector backends; Hippo is a biologically-structured, non-vector alternative — different design principle |
| 3 | **agents-observe** / github.com/simple10/agents-observe | 2026-04-01 | 76 | https://news.ycombinator.com/item?id=47602986 | Real-time dashboard for Claude Code agent teams; streams hook events, renders per-agent token burn, latency, and error rate on a live web UI | Observability | Blueprint covers Langfuse/Phoenix/Datadog but not a Claude Code-native lightweight team dashboard; this is the first Claude Code-specific obs project in the window |
| 4 | **Twill.ai** (YC S25) / twill.ai | 2026-04-10 | 75 | https://news.ycombinator.com/item?id=47720418 | Cloud service: give it a GitHub issue, get back a reviewed PR; uses a fleet of sandboxed agents under the hood; no harness config needed | Software Factory (new category C) | No v3 slot for autonomous delivery platforms |
| 5 | **Scion** (Google) / via infoq.com | 2026-04-07 | 229 | https://news.ycombinator.com/item?id=47675213 | Google open-sources experimental agent orchestration testbed; focuses on reproducible multi-agent topology experiments and step-level fault injection | Adjacent frameworks | Google-sourced, in-window; adds a research-grade testbed angle absent from blueprint (blueprint covers Hermes, Letta, LangGraph etc. but not a dedicated fault-injection testbed) |
| 6 | **Wombat** / github.com/usewombat/gateway | 2026-03-19 (HN: ~4 wks ago) | ~20 | https://news.ycombinator.com/item?id=47418076 | Unix-style rwxd permissions for MCP tool calls; sits as a proxy between Claude Code and MCP servers, checks permissions.json, enforces deterministic allow/deny, full audit log | MCP Security (new category A) | No blueprint slot for MCP permission/audit gateway |
| 7 | **DecisionNode** / github.com/decisionnode/DecisionNode | 2026-04-10 | 23 | https://news.ycombinator.com/item?id=47723505 | Shared structured memory for all AI coding tools via MCP; stores decisions, rationale, and context in a graph that Cursor, Claude Code, and Codex all read from the same source | Memory (new architecture) | Blueprint memory tools are agent-local; DecisionNode is explicitly cross-tool shared memory — a different topology |
| 8 | **Coasts** / github.com/coast-guard/coasts | 2026-03-30 | 99 | https://news.ycombinator.com/item?id=47575417 | "Containerized Hosts for Agents" — OCI containers that expose a standard agent host API; each container is a named, addressable agent runtime you can spin up with docker run | Sandbox / Orchestration | Blueprint covers container-use and E2B but not a OCI-native addressable-agent-host standard; Coasts frames the sandbox as an agent peer, not just an exec env |
| 9 | **Marimo-pair** / github.com/marimo-team/marimo-pair | 2026-04-07 | 134 | https://news.ycombinator.com/item?id=47678844 | Reactive Python notebooks as live environments for AI agents; agent edits cells, notebook reruns reactively, agent sees output without a shell round-trip | Sandbox (notebook tier) | Blueprint has no notebook-as-agent-env entry; this is from the established marimo team, not a toy project |
| 10 | **claude-token-efficient** / github.com/drona23/claude-token-efficient | 2026-03-31 | 471 | https://news.ycombinator.com/item?id=47581701 | Universal Claude.md snippet that cuts output tokens ~40% by instructing concise structured responses; drop-in CLAUDE.md include | Context compression | Blueprint has context-mode, caveman, rtk, graphify, Squeez; this is a different surface (CLAUDE.md system-prompt shaping rather than a tool/plugin) and hit 471 pts — highest context-compression score in window |
| 11 | **Octopus** / octopus-review.ai | 2026-03-28 | ~30 | https://news.ycombinator.com/item?id=47554345 | Open-source self-hostable AI code reviewer for GitHub/Bitbucket; uses RAG + Qdrant to review full codebase not just the diff; Claude + OpenAI compatible | Second-opinion reviewers (new category) | Blueprint does not name any self-hosted AI PR reviewer; Octopus is the first open-source CodeRabbit alternative with a dedicated HN Show HN in-window |
| 12 | **lat.md** / github.com/1st1/lat.md | 2026-03-29 | 90 | https://news.ycombinator.com/item?id=47561496 | Agent Lattice — a live knowledge graph of your codebase served as markdown; agents query it instead of grepping files; incremental re-index on file change | Code search / indexing (new category) | Blueprint has no code-graph / semantic-index slot; lat.md treats the codebase as a queryable graph, which is architecturally distinct from grep/tree-sitter MCP servers |
| 13 | **Lilith-zero** / github.com/BadC-mpany/lilith-zero | 2026-04-06 | 9 | https://news.ycombinator.com/item?id=47659402 | Ultra-fast Rust-based security middleware for MCP; validates tool schemas, strips injection payloads, rate-limits per-tool, emits OTel spans | MCP Security (new category A) | Same new category as Wombat but security-middleware framing vs. permissions-gateway framing — different composition point |
| 14 | **jmux** / github.com/jarredkenny/jmux | 2026-04-05 | 10 | https://news.ycombinator.com/item?id=47650233 | tmux-based development environment manager designed for both humans and coding agents; defines named panes, persistent sessions, and agent handoff protocol in YAML | Workstation | Blueprint lists tmux, Zellij, Ghostty etc. but not a tmux wrapper with explicit coding-agent handoff semantics |
| 15 | **Skrun** / github.com/skrun-dev/skrun | 2026-04-08 | 61 | https://news.ycombinator.com/item?id=47689319 | Deploy any agent skill as a standalone API endpoint; wraps a skill definition in a FastAPI service with auth, rate limiting, and a /run endpoint | Skill / discipline | Blueprint covers skills frameworks (Superpowers, mattpocock/skills etc.) but not a skill-as-microservice deployment layer |
| 16 | **Druids** / github.com/fulcrumresearch/druids | 2026-04-08 | 61 | https://news.ycombinator.com/item?id=47695666 | "Build your own software factory" — configurable multi-agent pipeline with roles (planner, coder, reviewer, deployer), runs locally, outputs deployable artifacts | Software Factory (new category C) | Same new category as Twill; Druids is the self-hosted OSS version of the autonomous delivery concept |
| 17 | **Agent Orchestrator** / github.com/c9r-io/orchestrator | 2026-03-29 | 15 | https://news.ycombinator.com/item?id=47562440 | Local-first Harness Engineering control plane for agent orchestration; persistent state machine, named agents, inter-agent messaging, runs without cloud | Orchestration | Blueprint covers Claude-Squad, multiclaude, overstory etc. but not a local-first "control plane" framing with persistent state machine |
| 18 | **meta-agent** / github.com/canvas-org/meta-agent | 2026-04-06 | 13 | https://news.ycombinator.com/item?id=47665630 | Self-improving agent harness: records live traces, extracts patterns, rewrites its own tool-use strategy; open-source | Orchestration / self-improvement | Blueprint has no self-modifying harness entry; this is adjacent to oh-my-claudecode:self-improve but is a standalone repo with a different architecture (trace-driven rewrite) |
| 19 | **SQLite Memory** / github.com/sqliteai/sqlite-memory | 2026-04-07 | 9 | https://news.ycombinator.com/item?id=47676123 | Markdown-based AI agent memory with offline-first sync backed by SQLite; MCP-compatible, versioned with git-style diffs per memory entry | Memory (new architecture) | Blueprint memory tools are mostly vector-backed; SQLite Memory is a structured, offline-first, markdown-native alternative |
| 20 | **QVAC SDK** / qvac.tether.io | 2026-04-09 | 29 | https://news.ycombinator.com/item?id=47708697 | Universal JavaScript SDK for building local AI applications; wraps Ollama, LM Studio, and llama.cpp under one API surface; ships a local-first RAG helper | Local LLM routing (new category) | Blueprint has no local LLM routing layer slot; QVAC is the first unified local-model SDK with in-window traction |

---

## NOTABLE ITEMS NOT IN TOP 20 (worth watching)

| Name | Date | Pts | HN URL | One-line note |
|------|------|-----|--------|---------------|
| Baton / getbaton.dev | 2026-04-01 | 62 | https://news.ycombinator.com/item?id=47599771 | Desktop app for developing with AI agents; visual session manager |
| Castra / github.com/amangsingh/castra | 2026-04-01 | 8 | https://news.ycombinator.com/item?id=47601608 | "Strip orchestration rights from your LLMs" — permission scope limiter for LLM tool calls |
| JitAPI / github.com/nk3750/jitapi | 2026-04-06 | 5 | https://news.ycombinator.com/item?id=47663251 | MCP server for just-in-time dynamic tool discovery (34x fewer tokens than static registries) |
| Memoir / memoir.sh | 2026-03-30 | 2 | https://news.ycombinator.com/item?id=47578802 | Persistent memory for AI coding tools via MCP |
| OpenHarness / github.com/zhijiewong/openharness | 2026-04-01 | 7 | https://news.ycombinator.com/item?id=47600371 | Open-source terminal coding agent for any LLM (Claude Code alternative) |
| Bx / github.com/holtwick/bx-mac | 2026-04-07 | 7 | https://news.ycombinator.com/item?id=47674056 | macOS native sandbox for AI and coding tools |
| TUI-use / github.com/onesuper/tui-use | 2026-04-08 | 52 | https://news.ycombinator.com/item?id=47692661 | Let AI agents control interactive terminal programs (ncurses, vim, etc.) |
| IssMcpDead / ismcpdead.com | 2026-04-03 | 39 | https://news.ycombinator.com/item?id=47631030 | Live dashboard tracking MCP adoption and sentiment — meta-tool for the ecosystem |
| Render Workflows / render.com/workflows | 2026-04-09 | 6 | https://news.ycombinator.com/item?id=47705491 | Durable task orchestration without queues or workers — cloud-native Temporal alternative |
| SmolVM / github.com/CelestoAI/SmolVM | 2026-04-10 | 6 | https://news.ycombinator.com/item?id=47711887 | Open-source sandbox for coding and computer-use agents; microVM-based isolation |

---

## SIGNAL EVENTS IN WINDOW (not projects, but architecturally load-bearing)

| Event | Date | Pts | HN URL | Implication |
|-------|------|-----|--------|-------------|
| Claude Code source leak (npm .map file) | 2026-03-31 | 2093 | https://news.ycombinator.com/item?id=47584540 | Leaked internals confirm: fake tools, frustration regexes, undercover mode — blueprint's hook/permission section should reference these internals |
| Claude Code issue #42796 (regression: edit-without-read spike) | 2026-04-06 | 1351 | https://news.ycombinator.com/item?id=47660925 | Confirms Principle 2 in blueprint: CLAUDE.md is advisory; hook enforcement is the only reliable gate |
| Anthropic bans OpenClaw from Claude Code subscriptions | 2026-04-03 | 1098 | https://news.ycombinator.com/item?id=47633396 | Architecturally: the brain↔hands contract has a new constraint — the harness can now gate which sandbox layer is permitted at the subscription level |
| Claude Managed Agents launch | 2026-04-08 | 169 | https://news.ycombinator.com/item?id=47693047 | First-party orchestration layer from Anthropic; blueprint's orchestration slot needs a "Anthropic-native" row |
| "I still prefer MCP over skills" | 2026-04-10 | 441 | https://news.ycombinator.com/item?id=47712718 | Active community debate on MCP-vs-skills design tradeoff; blueprint's discipline/skill slot should address this explicitly |

---

## NEW CATEGORIES SUMMARY

| # | Category Name | Evidence (HN items) | Proposed Blueprint Slot Position |
|---|---------------|---------------------|----------------------------------|
| A | MCP Security / Audit Infrastructure | Wombat, Lilith-zero, MCP Gateway zero-trust, 20K server grading post, JitAPI | Between MCP servers slot and sandbox slot (permission enforcement layer) |
| B | Agent-Native Memory (non-vector architectures) | Hippo, MemPalace, DecisionNode, SQLite Memory, Memdir, Memoir, Palinode, Engram, Vektor, Continuity | Expand current memory slot into two tiers: vector-backed vs. structured/graph/local-first |
| C | Software Factory / Autonomous Delivery Platforms | Freestyle, Twill.ai, Druids, Eve, Fabro | New slot above the orchestration slot: "Delivery Platform" — accept task, return PR |
| D | Local LLM Routing / Model-Agnostic Harness Bridge | QVAC SDK, OpenHarness, "Reallocating $100/month Claude Code Spend to Zed + OpenRouter" (344 pts) | New slot in harness section: "Model router" (LiteLLM, OpenRouter, QVAC, Portkey) |
| E | Autonomous Coding Agent Alternatives (non-Claude harnesses) | OpenHarness, lmcli, "I built an AI coding agent 50% cheaper than Claude Code" | Existing harness section — needs an explicit "alternative harnesses" sub-row |

---

*Report generated by document-specialist agent. All HN items verified via Algolia HN Search API (hn.algolia.com) with epoch range 1774652400–1775944799. Points and dates are as of scrape time; HN scores drift over time.*
