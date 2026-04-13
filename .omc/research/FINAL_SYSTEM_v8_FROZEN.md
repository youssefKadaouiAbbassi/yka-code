# FINAL SYSTEM v8 — FROZEN April 12, 2026
# 40 components, zero duplicates, all free except Max $200/mo
# Reviewed one-by-one with user, every overlap resolved
# Do NOT modify this file — compare future research against it

## Components

| # | Category | Tool | What it does |
|---|---|---|---|
| 1 | Core | Claude Code 2.1.101 | Kernel. Fast Mode, Advisor Tool, Computer Use, Channels, defer, Monitor, Agent Teams, --bare, Adaptive Thinking, Security Scanner, Session Memory, /cost, WebSearch |
| 2 | Config | CLAUDE.md <100 lines + symlink AGENTS.md + GEMINI.md | Advisory rules. Hooks enforce, CLAUDE.md advises. |
| 3 | Settings | settings.json (40+ deny rules) | First gate. Permissions, hooks, pinned model + effortLevel, telemetry |
| 4 | Enforcement | Unified hooks (6 scripts) | destructive blocker, secrets guard, lint gate, session-start, session-end, stop summary |
| 5 | Semantic code | Serena v1.1.0 | LSP symbols across 30+ languages |
| 6 | Structural search | ast-grep MCP | AST pattern matching, 20+ languages |
| 7 | Browser | Playwright MCP + CLI | a11y-tree snapshots. CLI = 4x fewer tokens. |
| 8 | Web scraping | Crawl4AI | Self-hosted, Apache-2.0, unlimited, MCP v0.8 |
| 9 | Library docs | Context7 (with API key) | Version-specific library docs |
| 10 | Repo Q&A | DeepWiki | Any GitHub repo, free, remote HTTP |
| 11 | Memory | claude-mem (bind 127.0.0.1) | Auto capture + compress + semantic retrieval |
| 12 | Context | context-mode | 98% tool output compression |
| 13 | Sandbox L1 | Native PID-ns + seccomp | Default, zero overhead |
| 14 | Sandbox L2 | container-use | Docker-level, per-agent git branches |
| 15 | GitHub CLI | gh CLI | Zero context overhead |
| 16 | GitHub MCP | github-mcp-server (remote HTTP) | 93 tools, batch ops |
| 17 | CI | claude-code-action@v1 + --bare | Automated PR review, separate API key |
| 18 | Native review | Claude Code Review | Built-in multi-agent PR review |
| 19 | Cross-vendor review | CodeRabbit | Different model reviews Claude's output. Free public repos. |
| 20 | Bidirectional comms | Channels (--channels plugin:telegram) | Message Claude FROM your phone |
| 21 | Push notifications | claude-notifications-go | ntfy + Telegram + Slack. Defer Allow/Deny. |
| 22 | Native observability | Native /cost + telemetry | Per-model cost + OpenTelemetry |
| 23 | Terminal dashboard | ccflare | Token spend, per-tool breakdown, trends |
| 24 | Native orchestration | Agent Teams (experimental) | ≤5 parallel agents, shared task list |
| 25 | Issue orchestration | Multica (9.1k) | Linear-style agent issue board. Skills auto-capture. |
| 26 | Walk-away coding | OpenHands (50k+, MIT) | Batch GitHub issues → PRs overnight |
| 27 | ML research | autoresearch (70.7k, MIT) | Autonomous experiments, one GPU |
| 28 | Workflow | n8n (183.7k) | Visual automation, 400+ connectors, MCP |
| 29 | RAG | Knowledge-RAG | MCP-native, local ONNX, 12 tools |
| 30 | Design gen | Google Stitch | AI → UI design → DESIGN.md export |
| 31 | Design templates | awesome-design-md (43.2k) | 55+ brand DESIGN.md files |
| 32 | Knowledge base | Obsidian + claude-obsidian | Karpathy LLM Wiki pattern |
| 33 | Tool versions | mise (26.6k) | Replaces nvm+pyenv+asdf+direnv+make |
| 34 | Task runner | just (32.8k) | Claude-readable justfile |
| 35 | 500+ integrations | Composio MCP | One endpoint → Slack, Notion, Stripe, 500+ apps |
| 36 | Terminal | Ghostty | GPU-accelerated, CC team uses it |
| 37 | Multiplexer | tmux | Parallel sessions, detach/reattach |
| 38 | Parallel FS | Git worktrees | Per-agent branch + directory |
| 39 | Dotfiles | chezmoi + age | Encrypted portable dotfiles |
| 40 | Self-improvement | tasks/lessons.md | Correction log that compounds |

## MCP Servers (9 total)
Serena, ast-grep, Crawl4AI, Context7, github-mcp, claude-mem, context-mode, Knowledge-RAG, Composio

## Principles (12)
1. Verification > generation (reviewer = different model via CodeRabbit)
2. Hooks enforce 100%, CLAUDE.md advises 80%
3. Front-load architecture — first artifact = research.md, never code
4. Skill accumulation has diminishing returns — measure, delete non-earners
5. Native primitives replace plugins when they ship — re-evaluate monthly
6. Sandbox non-optional — native + container-use layered
7. Writer ≠ reviewer at model-diversity level
8. 3-5 parallel agents, start with one fewer than comfortable
9. Subscription = interactive, API key = CI (enforced April 4)
10. Pin model + effortLevel defaults (they drift silently)
11. CLAUDE.md under 100 lines — if Claude does it correctly without the rule, delete the rule
12. Monthly metabolic audit — shed tools that don't earn their keep

## What was CUT and why
- Claude in Chrome → Playwright covers it
- Exa → native WebSearch enough
- mcp-memory-service → claude-mem covers it
- Firejail → container-use covers it
- PR-Agent → needs API keys that cost money
- standalone ntfy → claude-notifications-go bundles it
- Langfuse → native /cost + ccflare enough for solo
- Paperclip → Multica fits solo dev better
- Conductor → Multica has dashboard
- Dify + Langflow → n8n covers workflow
- RAGFlow + LightRAG → rarely needed for coding, Knowledge-RAG covers it
- Figma MCP + Anima → Figma-specific, Stitch + DESIGN.md is universal
- devenv 2.0 → mise + Docker covers it
- agentgateway → 4 security layers enough for solo
- Mermaid MCP → Claude writes Mermaid, Obsidian/GitHub render it
- 11 vertical MCPs → Composio covers 500+ apps in one endpoint
