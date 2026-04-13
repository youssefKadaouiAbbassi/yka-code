# FINAL SYSTEM v12 — April 13, 2026
# 40 components. Functionality-verified + primary-source-verified + code-verified.
# Multica skills system verified from actual source code (database schema + Go backend + CLI + UI + WebSocket).
# claude-mem restored (startup overhead only, not per-tool-call).

## Components

| # | Category | Tool | What it does |
|---|---|---|---|
| | **KERNEL** | | |
| 1 | Core | Claude Code 2.1.104 | Kernel. Fast Mode, Advisor Tool, Computer Use, Channels, defer, Monitor, Agent Teams, --bare, Adaptive Thinking, Security Scanner, Session Memory, /cost, WebSearch |
| 2 | Config | CLAUDE.md <100 lines + symlink AGENTS.md + GEMINI.md | Advisory rules. Hooks enforce, CLAUDE.md advises. |
| 3 | Settings | settings.json (40+ deny rules) | First gate. Permissions, hooks, pinned model + effortLevel, telemetry |
| | **ENFORCEMENT** | | |
| 4 | Hooks | Unified hooks (6 scripts) | destructive blocker, secrets guard, lint gate, session-start, session-end, stop summary |
| 5 | Security scanning | Claude Code Security (native) + Snyk MCP | Native = reasoning-based vuln finding. Snyk = SAST + SCA + IaC + container. |
| | **CODE INTELLIGENCE** | | |
| 6 | Semantic code | Serena v1.1.0 | LSP — type resolution, cross-module refs. Benchmark: 45min all-tests-pass vs native LSP 1hr with 9 failures. |
| 7 | Structural search | ast-grep CLI/skill (NOT MCP) | AST pattern matching via CLI. Engine excellent, MCP wrapper flaky. |
| | **BROWSER** | | |
| 8 | Automation | Playwright CLI (NOT MCP) | 4× fewer tokens (27K vs 114K). Microsoft recommends CLI for coding agents. |
| | **WEB** | | |
| 9 | Scraping | Crawl4AI (library, NOT MCP) | Clean markdown from websites. No official MCP. Pin v0.8.6+. |
| | **DOCS** | | |
| 10 | Library docs | Docfork | 10K+ libraries, 1 API call (2× faster), Cabinets for stack isolation. Auth free: 1K/mo. |
| 11 | Repo Q&A | DeepWiki | Public GitHub repos, free, remote HTTP. Karpathy validated. |
| | **MEMORY** | | |
| 12 | Persistent memory | claude-mem (bind 127.0.0.1) | Auto capture + compress + 3-layer semantic retrieval (10× token savings). 1-2 min startup, then zero overhead. v6.5.0. |
| | **CONTEXT** | | |
| 13 | Output reduction | context-mode | ~98% context reduction via SQLite + FTS5 + BM25. Sessions 6× longer. |
| | **SANDBOX** | | |
| 14 | Layer 1 | Native PID-ns + seccomp | Default, zero overhead |
| 15 | Layer 2 | container-use (cu stdio) | Docker-level isolation. Per-agent git branches. |
| | **GITHUB** | | |
| 16 | CLI ops | gh CLI | Zero context overhead |
| 17 | MCP ops | github-mcp-server (remote HTTP) | 93 tools, batch ops |
| 18 | CI | claude-code-action@v1 + --bare | Automated PR review, separate API key |
| | **CODE REVIEW** | | |
| 19 | Native review | Claude Code Review | Built-in multi-agent PR review |
| 20 | Cross-vendor | CodeRabbit | Highest F1 (51.2%). Multi-model pipeline + 40 static analyzers. Free private + public. |
| | **NOTIFICATIONS** | | |
| 21 | Bidirectional | Channels (--channels plugin:telegram) | Message Claude FROM phone. Official Anthropic. |
| 22 | Defer approval | claude-ntfy-hook | Smart filtering + context-aware + interactive Allow/Deny buttons. |
| | **OBSERVABILITY** | | |
| 23 | Native | Native /cost + telemetry | Per-model cost + OpenTelemetry |
| 24 | Terminal dashboard | ccflare | API proxy + monitoring TUI. Token spend, per-tool breakdown. |
| | **ORCHESTRATION** | | |
| 25 | Native parallel | Agent Teams (experimental) | ≤5 parallel agents, shared task list |
| 26 | Issue-based | Multica (10.2k) | Agent issue board. Skills compound over time (verified from source code: DB schema + Go backend + CLI + UI + WebSocket + skills-lock.json). 4 runtimes. |
| | **AUTONOMY** | | |
| 27 | ML research | autoresearch (71.3k, MIT) | Karpathy. 700 experiments, 11% speedup. Shopify CEO: 53% faster Liquid, 61% fewer allocs. |
| | **WORKFLOW** | | |
| 28 | Automation | n8n (184k) | Visual builder, 525+ nodes, MCP integration. Tested on 55-node production pipeline. |
| | **DATABASE** | | |
| 29 | DB ops | PostgreSQL MCP Pro (crystaldba, 2.5k, MIT) | Hybrid classical+LLM. Correct JOINs + index tuning + health analysis. 8 tools. |
| | **DESIGN** | | |
| 30 | Generation | Google Stitch | DESIGN.md export, MCP + 7 skills. Full apps in ~30min. |
| 31 | Templates | awesome-design-md (47.2k) | 66 brand DESIGN.md files. |
| | **KNOWLEDGE** | | |
| 32 | Wiki | Obsidian + claude-obsidian | Karpathy LLM Wiki. Scales to 6 agents + 50 sub-agents per user report. |
| | **BUILD** | | |
| 33 | Tool versions | mise (26.6k) | Replaces nvm+pyenv+asdf+direnv+make |
| 34 | Task runner | just (32.8k) | Claude-readable justfile |
| | **INTEGRATIONS** | | |
| 35 | 500+ apps | Composio MCP | Single endpoint. SOC2. 20K free calls/mo. |
| | **WORKSTATION** | | |
| 36 | Terminal | Ghostty (50.6k) | GPU-accelerated. CC docs treat as first-class. |
| 37 | Multiplexer | tmux | Parallel sessions, detach/reattach |
| 38 | Parallel FS | Git worktrees | Per-agent branch + directory |
| 39 | Dotfiles | chezmoi + age | Encrypted portable dotfiles |
| 40 | Self-improvement | tasks/lessons.md | Correction log that compounds |

## MCP Servers (7)
Serena, Docfork, github-mcp, context-mode, Composio, PostgreSQL MCP Pro, Snyk MCP

## Non-MCP integrations (CLI/skill/library/plugin/hook)
ast-grep (CLI), Playwright (CLI), Crawl4AI (library), claude-mem (plugin), claude-ntfy-hook (hook), ccflare (proxy+TUI)

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
11. CLAUDE.md under 100 lines — delete rules Claude follows without being told
12. Monthly metabolic audit — shed tools that don't earn their keep

## Validation trail
- 10 architect teammates (Opus, identical mandate)
- 9 unbiased category researchers (pure web)
- 5 adversarial reviewers (red team, alternatives, cost, security, practitioner)
- 3 clean-slate independent agents
- deep-research ultradeep audit (8-phase)
- 4 primary-source verifiers (READMEs + docs)
- 4 functionality verifiers (real user experiences)
- Multica skills system verified from actual source code (gh search code)
- claude-mem overhead verified: 1-2 min startup (GitHub issue #923), NOT per-tool-call
