# FINAL SYSTEM v11 — April 13, 2026
# 39 components. Functionality-verified from primary sources + real user experiences.
# 3 cuts, 3 swaps from v10. Every remaining tool confirmed by people who ACTUALLY USE IT.

## Components

| # | Category | Tool | What it does | Verified by |
|---|---|---|---|---|
| | **KERNEL** | | | |
| 1 | Core | **Claude Code 2.1.104** | Kernel. Fast Mode, Advisor Tool, Computer Use, Channels, defer, Monitor, Agent Teams, --bare, Adaptive Thinking, Security Scanner, Session Memory, /cost, WebSearch | All sources |
| 2 | Config | **CLAUDE.md** <100 lines + symlink AGENTS.md + GEMINI.md | Advisory rules. Hooks enforce, CLAUDE.md advises. | 10/10 architects |
| 3 | Settings | **settings.json** (40+ deny rules) | First gate. Permissions, hooks, pinned model + effortLevel, telemetry | 10/10 architects |
| | **ENFORCEMENT** | | | |
| 4 | Hooks | **Unified hooks** (6 scripts) | destructive blocker, secrets guard, lint gate, session-start, session-end, stop summary | 9/10 architects |
| 5 | Security scanning | **Claude Code Security** (native) + **Snyk MCP** | Native = reasoning-based vuln finding. Snyk = SAST + SCA + IaC + container scanning. First-party. Free tier. | func-4: "no real competitor at this integration level" |
| | **CODE INTELLIGENCE** | | | |
| 6 | Semantic code | **Serena v1.1.0** | LSP — type resolution, cross-module references. ManoMano benchmark: 45min all-tests-pass vs native LSP's 1hr with 9 failures. | func-1: HIGH confidence, HN users confirm "much better results" |
| 7 | Structural search | **ast-grep CLI/skill** (NOT MCP) | AST pattern matching via CLI. Same engine, no flaky MCP process. Use via Bash or agent-skill. | func-1: "engine excellent, MCP wrapper experimental and flaky" |
| | **BROWSER** | | | |
| 8 | Automation | **Playwright CLI** (NOT MCP) | 4× fewer tokens (27K vs 114K). Same engine. Officially recommended by Playwright team for coding agents with shell access. | func-1: HIGH confidence, Microsoft recommendation |
| | **WEB** | | | |
| 9 | Scraping | **Crawl4AI** (library, NOT MCP) | Clean LLM-ready markdown from websites. Use as Python library or Docker — no official MCP server (community wrappers are fragmented). Pin v0.8.6+ (supply chain issue in v0.8.5). | func-1: "core engine excellent" |
| | **DOCS** | | | |
| 10 | Library docs | **Docfork** | 10K+ libraries, 1 API call (2× faster than Context7), Cabinets for stack isolation, ~200ms. Authenticated free tier: 1K/mo. | func-2: "strict upgrade over Context7" |
| 11 | Repo Q&A | **DeepWiki** | Any public GitHub repo, free, remote HTTP. Karpathy validated it. | func-2: "unique niche, nothing else does this" |
| | **MEMORY** | | | |
| 12 | Persistent memory | **Native** (CLAUDE.md + auto-memory + /memory + tasks/lessons.md) | Zero overhead. Covers 90% of use cases. | func-2: claude-mem CUT for 60-90s per-tool overhead |
| | **CONTEXT** | | | |
| 13 | Output reduction | **context-mode** | ~98% context reduction (315KB → 5.4KB). Sessions last 6× longer (30min → 3hrs). SQLite + FTS5 indexing with BM25 retrieval. | func-2: "verified by multiple users" |
| | **SANDBOX** | | | |
| 14 | Layer 1 | **Native PID-ns + seccomp** | Default, zero overhead | 10/10 architects |
| 15 | Layer 2 | **container-use** (cu stdio) | Docker-level isolation. Per-agent git branches. Beta but functional. | func-2: "real value, keep if you need container isolation" |
| | **GITHUB** | | | |
| 16 | CLI ops | **gh CLI** | Zero context overhead | Practitioner consensus |
| 17 | MCP ops | **github-mcp-server** (remote HTTP) | 93 tools, batch ops | 10/10 architects |
| 18 | CI | **claude-code-action@v1** + --bare | Automated PR review, separate API key | 7/10 architects |
| | **CODE REVIEW** | | | |
| 19 | Native review | **Claude Code Review** | Built-in multi-agent PR review | Confirmed |
| 20 | Cross-vendor | **CodeRabbit** | Highest F1 (51.2%). Different AI arch + 40 static analyzers. Free tier covers private + public. Autonomous write-review-fix loop. | func-3: HIGH confidence |
| | **NOTIFICATIONS** | | | |
| 21 | Bidirectional | **Channels** (--channels plugin:telegram) | Message Claude FROM phone. Official Anthropic feature. | func-3: "works as advertised" |
| 22 | Defer approval | **claude-ntfy-hook** | Smart filtering + context-aware + interactive Allow/Deny buttons. | func-3: "right tool for the job" (notifications-go has NO buttons) |
| | **OBSERVABILITY** | | | |
| 23 | Native | **Native /cost + telemetry** | Per-model cost + OpenTelemetry | All sources |
| 24 | Terminal dashboard | **ccflare** | API proxy + monitoring TUI. Token spend, per-tool breakdown. | func verified |
| | **ORCHESTRATION** | | | |
| 25 | Native parallel | **Agent Teams** (experimental) | ≤5 parallel agents, shared task list | 10/10 architects |
| 26 | Issue-based | **Multica** (10.2k) | Agent issue board. Persistent, multi-model, skill compounding. | func-3: "real platform, fills gap Agent Teams doesn't" |
| | **AUTONOMY** | | | |
| 27 | ML research | **autoresearch** (71.3k, MIT) | Karpathy: 700 experiments, 11% speedup. Shopify CEO: 53% faster Liquid, 61% fewer memory allocs from 93 automated commits. | func-4: "slam dunk, very high confidence" |
| | **WORKFLOW** | | | |
| 28 | Automation | **n8n** (184k) | Visual builder, 525+ nodes, MCP integration. Tested on 55-node production pipeline. | func-3: "mature MCP, Claude gets live read/write" |
| | **DATABASE** | | | |
| 29 | DB ops | **PostgreSQL MCP Pro** (crystaldba, 2.5k, MIT) | Hybrid classical+LLM. Correct JOINs + index tuning + health analysis. 8 tools. | func-4: "actively maintained, real users get correct results" |
| | **DESIGN** | | | |
| 30 | Generation | **Google Stitch** | DESIGN.md export, MCP + 7 skills. Real users report full apps in ~30min. | func-4: HIGH confidence |
| 31 | Templates | **awesome-design-md** (47.2k) | 66 brand DESIGN.md files. Vendor-neutral format. | func-4: confirmed |
| | **KNOWLEDGE** | | | |
| 32 | Wiki | **Obsidian + claude-obsidian** | Karpathy LLM Wiki. "Scales beautifully" per user running 6 agents + 50 sub-agents. | func-4: HIGH confidence |
| | **BUILD** | | | |
| 33 | Tool versions | **mise** (26.6k) | Replaces nvm+pyenv+asdf+direnv+make | 10/10 architects |
| 34 | Task runner | **just** (32.8k) | Claude-readable justfile. just-mcp reduces context waste. | func-4: confirmed |
| | **INTEGRATIONS** | | | |
| 35 | 500+ apps | **Composio MCP** | Single endpoint. SOC2. Popular integrations solid, long-tail may be brittle. 20K free calls/mo. | func-4: MEDIUM confidence |
| | **WORKSTATION** | | | |
| 36 | Terminal | **Ghostty** (50.6k) | GPU-accelerated (OpenGL/Metal). CC docs treat as first-class. | func-4: confirmed |
| 37 | Multiplexer | **tmux** | Parallel sessions, detach/reattach | Confirmed |
| 38 | Parallel FS | **Git worktrees** | Per-agent branch + directory | Confirmed |
| 39 | Dotfiles | **chezmoi + age** | Encrypted portable dotfiles. age confirmed in README. | func-4: confirmed |

## MCP Servers (6 total — down from 10)
Serena, Docfork, github-mcp, context-mode, Composio, PostgreSQL MCP Pro
(+ Snyk MCP for security = 7)

## Non-MCP tools integrated via CLI/skill/library
ast-grep (CLI), Playwright (CLI), Crawl4AI (library), claude-ntfy-hook (hook)

## What was CUT in v11 and why (functionality-based, not security/license)
- **claude-mem** → 60-90 second overhead per tool invocation. Native memory covers 90%.
- **GitNexus** → overlaps with Serena. Zero independent benchmarks. Serena proven (ManoMano test).
- **OpenHands** → redundant. CC + Agent Teams + Multica does walk-away better without Docker overhead.

## What was SWAPPED in v11 and why
- **ast-grep MCP → CLI/skill** — engine excellent, MCP wrapper experimental and flaky
- **claude-notifications-go → claude-ntfy-hook** — notifications-go has NO Allow/Deny buttons
- **Crawl4AI MCP → library** — no official MCP server, community wrappers fragmented

## Principles (12, unchanged)
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
- 10 independent architect teammates (Opus, identical mandate)
- 9 unbiased category researchers (pure web, no biased files)
- 5 adversarial reviewers (red team, alternatives, cost, security, practitioner)
- 3 clean-slate independent agents
- deep-research ultradeep audit (8-phase pipeline)
- 4 primary-source verifiers (security/license — caught 6 critical, 9 significant errors)
- 4 functionality verifiers (real user experiences — caught 3 cuts, 3 swaps)
