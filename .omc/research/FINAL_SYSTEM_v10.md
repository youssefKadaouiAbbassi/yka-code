# FINAL SYSTEM v10 — April 13, 2026
# 42 components, zero duplicates, all free except Max $200/mo
# v9 + ultradeep audit: 3 swaps, 2 additions, 1 rejection
# Validated by: 10 architects + 9 unbiased researchers + 5 adversarial reviewers + 3 independent agents + deep-research ultradeep audit

## Components

| # | Category | Tool | What it does |
|---|---|---|---|
| | **KERNEL** | | |
| 1 | Core | Claude Code 2.1.104 | Kernel. Fast Mode, Advisor Tool, Computer Use, Channels, defer, Monitor, Agent Teams, --bare, Adaptive Thinking, Security Scanner, Session Memory, /cost, WebSearch |
| 2 | Config | CLAUDE.md <100 lines + symlink AGENTS.md + GEMINI.md | Advisory rules. Hooks enforce, CLAUDE.md advises. No duplication. |
| 3 | Settings | settings.json (40+ deny rules) | First gate. Permissions, hooks, pinned model + effortLevel, telemetry |
| | **ENFORCEMENT** | | |
| 4 | Hooks | Unified hooks (6 scripts) | destructive blocker, secrets guard, lint gate, session-start, session-end, stop summary |
| 5 | Security scanning | Claude Code Security (native) + Snyk MCP | Native = reasoning-based vuln finding (found 500+ in OSS). Snyk = deterministic SAST + SCA dependency scanning + license compliance. **NEW in v10.** |
| | **CODE INTELLIGENCE** | | |
| 6 | Semantic code | Serena v1.1.0 | LSP — type resolution, cross-module references, inferred types |
| 7 | Structural search | ast-grep MCP | AST pattern matching — "find all X that look like Y" |
| 8 | Code knowledge graph | GitNexus (17.4k) | Call-graph + dependency graph + Graph RAG via MCP. "What calls this? Show everything 2 hops away." |
| | **BROWSER + WEB** | | |
| 9 | Browser | Playwright CLI (primary) + Playwright MCP (fallback) | CLI = 4× fewer tokens (saves compact YAML to disk). MCP for full interactive automation. **CLI promoted to primary in v10 per Microsoft recommendation.** |
| 10 | Web scraping | Crawl4AI | Self-hosted, Apache-2.0, unlimited, MCP v0.8 |
| | **DOCS** | | |
| 11 | Library docs | Docfork (MIT, 9k+ libraries) | Version-specific library docs. 2× faster than Context7, no aggressive free tier cuts. **Replaces Context7 in v10 — Context7 cut free tier to 1k/mo.** |
| 12 | Repo Q&A | DeepWiki | Any GitHub repo, free, remote HTTP |
| | **MEMORY** | | |
| 13 | Persistent memory | claude-mem (bind 127.0.0.1) | Auto capture + compress + semantic retrieval across sessions |
| | **CONTEXT** | | |
| 14 | Output compression | context-mode | 98% tool output compression. Sessions last 6× longer. |
| | **SANDBOX** | | |
| 15 | Layer 1 | Native PID-ns + seccomp | Default, zero overhead |
| 16 | Layer 2 | Docker Sandboxes (microVM) | Own Linux kernel per agent via Firecracker. Strictly stronger than shared-kernel containers. **Replaces container-use in v10.** Git branch isolation via worktrees (#39). |
| | **GITHUB** | | |
| 17 | CLI ops | gh CLI | Zero context overhead |
| 18 | MCP ops | github-mcp-server (remote HTTP) | 93 tools, batch ops |
| 19 | CI | claude-code-action@v1 + --bare | Automated PR review, separate API key |
| | **CODE REVIEW** | | |
| 20 | Native review | Claude Code Review | Built-in multi-agent PR review |
| 21 | Cross-vendor review | CodeRabbit | Different model reviews Claude's output. Free public repos. |
| | **NOTIFICATIONS** | | |
| 22 | Bidirectional comms | Channels (--channels plugin:telegram) | Message Claude FROM your phone |
| 23 | Push notifications | claude-notifications-go | ntfy + Telegram + Slack. Defer Allow/Deny. |
| | **OBSERVABILITY** | | |
| 24 | Native | Native /cost + telemetry | Per-model cost + OpenTelemetry |
| 25 | Terminal dashboard | ccflare | Token spend, per-tool breakdown, trends |
| | **ORCHESTRATION** | | |
| 26 | Native parallel | Agent Teams (experimental) | ≤5 parallel agents, shared task list |
| 27 | Issue orchestration | Multica (9.1k) | Linear-style agent issue board. Skills auto-capture. |
| | **WALK-AWAY AUTONOMY** | | |
| 28 | Batch coding | OpenHands (50k+, MIT) | Batch GitHub issues → PRs overnight |
| 29 | ML research | autoresearch (70.7k, MIT) | Autonomous experiments, one GPU |
| | **WORKFLOW** | | |
| 30 | Automation | n8n (183.7k) | Visual workflow builder. 400+ connectors. MCP integration. |
| | **DATABASE** | | |
| 31 | Database ops | PostgreSQL MCP | Natural language → SQL queries, schema inspection, migration management. **NEW in v10 — no DB tool in v9.** |
| | **DESIGN** | | |
| 32 | Design generation | Google Stitch | AI → UI design → DESIGN.md export |
| 33 | Design templates | awesome-design-md (43.2k) | 55+ brand DESIGN.md files |
| | **KNOWLEDGE** | | |
| 34 | Wiki | Obsidian + claude-obsidian | Karpathy LLM Wiki pattern |
| | **BUILD** | | |
| 35 | Tool versions | mise (26.6k) | Replaces nvm+pyenv+asdf+direnv+make |
| 36 | Task runner | just (32.8k) | Claude-readable justfile |
| | **INTEGRATIONS** | | |
| 37 | 500+ apps | Composio MCP | One endpoint → Slack, Notion, Stripe, 500+ apps |
| | **WORKSTATION** | | |
| 38 | Terminal | Ghostty | GPU-accelerated, CC team uses it |
| 39 | Multiplexer | tmux | Parallel sessions, detach/reattach |
| 40 | Parallel FS | Git worktrees | Per-agent branch + directory |
| 41 | Dotfiles | chezmoi + age | Encrypted portable dotfiles |
| 42 | Self-improvement | tasks/lessons.md | Correction log that compounds |

## MCP Servers (10 total)
Serena, ast-grep, GitNexus, Crawl4AI, Docfork, github-mcp, claude-mem, context-mode, Composio, PostgreSQL MCP
(+ Snyk MCP for security scanning = 11 if counted separately)

## Code Intelligence Stack (3 tools, zero overlap)
- Serena = SEMANTIC (LSP type resolution, cross-module refs)
- ast-grep = PATTERNS (structural AST matching)
- GitNexus = RELATIONSHIPS (call-graph, dependency graph, Graph RAG)

## Principles (12)
1. Verification > generation (reviewer = different model via CodeRabbit)
2. Hooks enforce 100%, CLAUDE.md advises 80%
3. Front-load architecture — first artifact = research.md, never code
4. Skill accumulation has diminishing returns — measure, delete non-earners
5. Native primitives replace plugins when they ship — re-evaluate monthly
6. Sandbox non-optional — native + Docker microVM layered
7. Writer ≠ reviewer at model-diversity level
8. 3-5 parallel agents, start with one fewer than comfortable
9. Subscription = interactive, API key = CI (enforced April 4)
10. Pin model + effortLevel defaults (they drift silently)
11. CLAUDE.md under 100 lines — if Claude does it correctly without the rule, delete the rule
12. Monthly metabolic audit — shed tools that don't earn their keep

## Changes from v9
- #5 ADDED: Security scanning (Claude Code Security native + Snyk MCP) — biggest gap in v9
- #8 GitNexus: inherited from v9 (was #7, renumbered)
- #9 Playwright CLI promoted to PRIMARY over MCP (4× fewer tokens, Microsoft 2026 recommendation)
- #11 Context7 → Docfork (Context7 free tier cut to 1k/mo, Docfork MIT + 9k+ libraries + 2× faster)
- #16 container-use → Docker Sandboxes microVM (own Linux kernel per agent, strictly stronger isolation)
- #31 ADDED: PostgreSQL MCP — no DB tool in v9
- REJECTED: Testing MCP — Claude generates tests natively, `just test` runs them, coverage via Bash

## Validation trail
- Original: RESEARCH_CORPUS.md (17 research lanes, 260 sources)
- v3: 4 verify agents + opus writer + verifier
- v4: 5 scout agents + opus writer + verifier
- v5-v7: 5 adversarial reviewers (red team, alternatives, cost, security, practitioner)
- v7 independent: 3 clean-slate agents with zero context
- v8: 10 architect teammates (all Opus, identical mandate, independent)
- v8 corrections: 9 unbiased category researchers (pure web, no biased files)
- v8→v9: GitNexus swap based on unbiased evaluation
- v9→v10: deep-research ultradeep skill audit (8-phase pipeline, full report at ~/Documents/)

## What was CUT across all versions and why
- Claude in Chrome → Playwright covers it
- Exa → native WebSearch enough
- mcp-memory-service → claude-mem covers it
- Firejail → Docker microVM covers it
- container-use → Docker Sandboxes microVM (strictly better)
- PR-Agent → needs API keys that cost money
- standalone ntfy → claude-notifications-go bundles it
- Langfuse → native /cost + ccflare enough for solo
- Paperclip → Multica fits solo dev better
- Conductor → Multica has dashboard
- Dify + Langflow → n8n covers workflow
- RAGFlow + LightRAG + Knowledge-RAG → GitNexus (Graph RAG via MCP, superior for code)
- Context7 → Docfork (free tier cut to 1k/mo)
- Figma MCP + Anima → Figma-specific, Stitch + DESIGN.md is universal
- devenv 2.0 → mise + Docker covers it
- agentgateway → hooks + sandbox + deny rules enough for solo
- Mermaid MCP → Claude writes Mermaid, Obsidian/GitHub render it
- 11 vertical MCPs → Composio covers 500+ apps in one endpoint
- Testing MCP → Claude generates tests natively, just test + coverage via Bash
