# Functional Verification Report: MCP Tool Stack

**Date:** 2026-04-13  
**Scope:** Does each tool ACTUALLY work and is it THE BEST at its job?

---

## 1. Serena (github.com/oraios/serena)

**What it does:** MCP toolkit providing AI coding agents with IDE-like capabilities — symbol-level code retrieval, safe refactoring (rename, move, inline), symbolic editing, pattern search, and a memory system. Supports 40+ languages via LSP backends or JetBrains plugin.

**Does it do the job WELL?**

YES — with strong evidence.

- **ManoMano benchmark (36K-line Java project, 1,017 tests):** Claude + Serena finished a major refactoring in 45 min with all tests passing. Claude Code with native LSP ran for 1 hour and gave up with 9 failing tests. Vanilla Claude took 1 hour, failed to build entirely. ([Medium/ManoMano Tech](https://medium.com/manomano-tech/project-aegis-benchmarking-ai-agents-and-why-serena-is-our-new-must-have-311673db35dd))
- **HN user:** "Claude uses it pretty much exclusively to search the codebase... results have been much better with this. A one-line install and no work to maintain." ([HN](https://news.ycombinator.com/item?id=44880798))
- **Claude Code native LSP issue #858:** Claude Code's built-in LSP acknowledged as "not as mature or powerful as Serena's semantic approach" — hallucinating methods and missing test classes entirely. ([GitHub issue](https://github.com/oraios/serena/issues/858))
- **Token savings:** Serena read 69M tokens while keeping API cost contained via symbol-level retrieval instead of reading full files.

**Is there something BETTER?**

- `codescan` (HN mention) claims to exceed Serena in some ways with zero-install, no MCP — but no benchmarks, no adoption data.
- `Codanna MCP` does similar work — mentioned once on HN, no comparative data.
- Claude Code's native LSP is catching up but currently inferior per the ManoMano benchmark.

**Verdict: KEEP**

Serena provides measurable, benchmarked improvements over native LSP for deep refactoring tasks. The ManoMano benchmark is the strongest evidence: same task, same codebase, Serena wins on time, cost, and correctness. One-line install, zero maintenance. Monitor Claude Code's native LSP improvements — if they reach parity, Serena becomes redundant, but that hasn't happened yet.

---

## 2. ast-grep MCP (github.com/ast-grep/ast-grep-mcp)

**What it does:** Experimental MCP server exposing ast-grep's AST-based structural code search. Four tools: `dump_syntax_tree`, `test_match_code_rule`, `find_code`, `find_code_by_rule`. Supports JS, Python, Rust, Go, Java, C/C++ and more.

**Does it do the job WELL?**

MIXED — ast-grep itself is excellent, but the MCP wrapper is experimental and has adoption concerns.

- **ast-grep (the CLI)** is well-regarded on HN: "hit a sweet spot: syntax-aware search in a single binary." Multiple positive threads over 2+ years. ([HN](https://news.ycombinator.com/item?id=38590984))
- **The MCP server** is self-described as "experimental." Claude Code "cannot automatically detect when to use ast-grep for all appropriate use cases" as of late 2025.
- **HN skepticism about MCP pattern:** "every MCP server I've used has been a flaky process that needs babysitting... with CLIs you can pipe output through jq and grep it." ([HN](https://news.ycombinator.com/item?id=47210295))
- **ast-grep now has a Claude Code agent skill** (github.com/ast-grep/agent-skill) which may be a better integration path than the MCP server.

**Is there something BETTER?**

- **ast-grep CLI directly via Bash tool** — same engine, no MCP flakiness, Claude can call it directly. The agent-skill integration makes this even smoother.
- **Serena's pattern search** already covers structural search for many use cases.
- **XRAY MCP** — another ast-grep MCP wrapper, similar limitations.

**Verdict: SWAP to ast-grep agent skill or direct CLI**

The underlying ast-grep engine is excellent. But wrapping it in an MCP server adds fragility for marginal benefit when Claude Code can just call `sg` (ast-grep CLI) via Bash. The official [agent-skill](https://github.com/ast-grep/agent-skill) is a lighter-weight integration. Drop the MCP server, keep ast-grep via CLI or agent skill.

---

## 3. GitNexus (github.com/abhigyanpatwari/GitNexus)

**What it does:** Client-side knowledge graph that indexes codebases into a queryable graph — dependencies, call chains, clusters, execution flows. 16 MCP tools including hybrid search, impact analysis, 360-degree symbol context, git-diff impact, and Cypher queries. Claude Code gets deepest integration with pre/post hooks.

**Does it do the job WELL?**

PROMISING but YOUNG — impressive claims, limited independent validation.

- **7K+ GitHub stars**, hit #1 on GitHub trending. ([Pebblous](https://blog.pebblous.ai/blog/gitnexus-code-knowledge-graph-2026/en/))
- **Claims:** Pre-computed intelligence means single queries return complete context instead of chains of follow-ups. "Smaller AI models can operate with architectural clarity normally requiring larger language models."
- **Claude Code integration:** MCP tools + agent skills + PreToolUse hooks that auto-enrich grep/glob/bash calls with graph context. PostToolUse hooks auto-reindex after git commit/merge.
- **HN comparison (competing tool):** A Go-based alternative claimed 120x token reduction (412K tokens via grep vs 3,400 via graph). GitNexus was acknowledged as good for "visual exploration" but dinged for requiring Node.js and supporting fewer languages (8-11 vs 35). ([HN](https://news.ycombinator.com/item?id=47234516))
- **Concern:** HN users flag that "knowledge graph tools don't solve the fundamental problem of constructing the knowledge graph itself" — indexing overhead and staleness are real issues.
- **No independent benchmarks** like Serena's ManoMano study. Most positive coverage is blog posts, not user experience reports.

**Is there something BETTER?**

- **Serena** already provides symbol-level navigation and reference tracking — overlapping use case.
- **CodeSeeker** (HN Show HN) — knowledge graph code intelligence, alternative approach.
- **GitLab's code graph** — Rust-based, 50K+ files in <100ms, 5 languages, but tightly coupled to GitLab.
- For the specific problem of "Claude breaks call chains" — Serena's `find_referencing_symbols` may suffice without the graph overhead.

**Verdict: CUT (for now)**

GitNexus is architecturally interesting but adds significant complexity (indexing pipeline, Node.js dependency, hook system) without independent evidence it outperforms Serena's symbol-level approach for our use case. The overlap with Serena is substantial — both solve "give Claude structural awareness." Serena has benchmarks proving it works; GitNexus has blog posts. Re-evaluate when independent benchmarks exist or when working on very large monorepos (10K+ files) where pre-computed graphs may justify the overhead.

---

## 4. Playwright CLI (github.com/microsoft/playwright-cli)

**What it does:** Command-line browser automation tool from Microsoft. Runs Playwright via discrete shell commands (`playwright-cli click`, `playwright-cli snapshot`, `playwright-cli screenshot`). Saves snapshots/screenshots to files instead of returning inline data.

**Does it do the job WELL?**

YES — with clear, measured advantages for coding agents.

- **4x token reduction:** "A typical browser automation task consumed ~114,000 tokens with MCP versus ~27,000 tokens with CLI." ([TestCollab](https://testcollab.com/blog/playwright-cli))
- **Mechanism:** File-based snapshots (YAML) and offline screenshots (PNG to disk) instead of inline accessibility trees and binary image data. Agent reads only what it needs.
- **Official Playwright team recommendation:** "Use CLI when your agent has access to the filesystem and shell" — which is exactly Claude Code's environment. ([Shipyard](https://shipyard.build/blog/playwright-mcp-vs-cli/))
- **Same engine:** Both CLI and MCP use the same Playwright engine, so no capability loss.
- **Active maintenance:** 66 commits, recent activity, npm package `@playwright/cli@latest`.

**Is there something BETTER?**

- **Playwright MCP** — same engine, 4x more tokens. Only better for sandboxed environments without shell access.
- **Claude-in-Chrome** — we already have this, and it's useful for different scenarios (existing browser sessions, user's actual tabs). Playwright CLI is better for automated testing and headless workflows.
- **Browserbase, BrowserStack MCP** — cloud-hosted alternatives, more complex, not clearly better for local dev.

**Verdict: KEEP**

Clear winner for coding agents with shell access. 4x token savings is massive over long sessions. Same Playwright engine as MCP, officially recommended by the Playwright team for this exact use case. Complements (not replaces) Claude-in-Chrome — use Playwright CLI for automated/headless testing, Claude-in-Chrome for interactive browser work.

---

## 5. Crawl4AI (github.com/unclecode/crawl4ai)

**What it does:** Open-source web crawler that converts web pages into clean, LLM-ready Markdown. Features: async browser pooling, BM25 content filtering, shadow DOM flattening, dynamic content rendering, adaptive crawling that learns site patterns. Runs locally, Docker, or cloud.

**Does it do the job WELL?**

YES for the core library, BUT the MCP integration is fragmented and unreliable.

- **Core library strengths:** Adaptive intelligence auto-learns selectors (40% crawl time reduction on structured sites). BM25 and heuristic content filtering. Full lazy-load support. No API keys needed. Apache 2.0 licensed. ([BrightData comparison](https://brightdata.com/blog/ai/crawl4ai-vs-firecrawl))
- **MCP server problems:** There is no single official MCP server — there are 5+ community implementations (coleam00, sadiuysal, walksoda, BjornMelin, vivmagarwal). The most popular one (coleam00/mcp-crawl4ai-rag) is self-described as a "testbed" with unaddressed issues. MCP SSE failures documented in [issue #1316](https://github.com/unclecode/crawl4ai/issues/1316).
- **HN presence:** Show HN post received attention but limited detailed user experience reports.

**Crawl4AI vs Firecrawl:**

| Dimension | Crawl4AI | Firecrawl |
|-----------|----------|-----------|
| Cost | Free (self-hosted, ~$50-300/mo compute) | $83/mo for 100K credits |
| Output quality | Good with configuration effort | LLM-ready markdown out of the box |
| Adaptive crawling | Yes (auto-learns selectors) | Yes (FIRE-1 agent navigation) |
| Setup complexity | High (Playwright browsers, proxy, LLM keys) | Low (API key, done) |
| MCP integration | Fragmented, community-maintained | Official, maintained |
| Compliance | None | SOC 2 Type II, GDPR |

**Is there something BETTER?**

- **Firecrawl** — better out-of-box quality, official MCP server, but costs money.
- **WebFetch (built-in)** — already available, no setup, handles most documentation/README fetching needs.
- **Context7/chub** — for library documentation specifically, these are better purpose-built tools.

**Verdict: KEEP with caveats**

Crawl4AI's core engine is excellent for deep web scraping needs (multi-page crawls, adaptive learning, structured extraction). But don't use a community MCP server — use Crawl4AI as a Python library called via Bash, or use the official Docker deployment. For simple single-page fetches, WebFetch (built-in) is sufficient. Consider Firecrawl if you need zero-config reliability and don't mind the cost.

---

## Summary Table

| Tool | Use Case | Verdict | Confidence | Action |
|------|----------|---------|------------|--------|
| **Serena** | LSP code intelligence | **KEEP** | HIGH | Benchmarked proof it outperforms native LSP |
| **ast-grep MCP** | Structural code search | **SWAP** | HIGH | Drop MCP server, use ast-grep CLI or agent-skill |
| **GitNexus** | Code knowledge graph | **CUT** | MEDIUM | Overlaps with Serena, no independent benchmarks |
| **Playwright CLI** | Browser automation | **KEEP** | HIGH | 4x token savings, officially recommended for coding agents |
| **Crawl4AI** | Web scraping to markdown | **KEEP** | MEDIUM | Use as library/Docker, avoid community MCP servers |

---

## Sources

- [ManoMano Benchmark: Serena vs Claude Code](https://medium.com/manomano-tech/project-aegis-benchmarking-ai-agents-and-why-serena-is-our-new-must-have-311673db35dd)
- [Serena GitHub](https://github.com/oraios/serena)
- [Claude Code native LSP vs Serena (issue #858)](https://github.com/oraios/serena/issues/858)
- [HN: Serena for context reduction](https://news.ycombinator.com/item?id=44880798)
- [ast-grep MCP GitHub](https://github.com/ast-grep/ast-grep-mcp)
- [ast-grep Agent Skill](https://github.com/ast-grep/agent-skill)
- [HN: ast-grep discussion](https://news.ycombinator.com/item?id=38590984)
- [HN: MCP skepticism](https://news.ycombinator.com/item?id=47210295)
- [GitNexus GitHub](https://github.com/abhigyanpatwari/GitNexus)
- [GitNexus hits #1 on GitHub](https://blog.pebblous.ai/blog/gitnexus-code-knowledge-graph-2026/en/)
- [HN: Knowledge graph vs grep (competing tool)](https://news.ycombinator.com/item?id=47234516)
- [Playwright CLI Token Efficiency](https://testcollab.com/blog/playwright-cli)
- [Playwright CLI vs MCP (Shipyard)](https://shipyard.build/blog/playwright-mcp-vs-cli/)
- [Crawl4AI GitHub](https://github.com/unclecode/crawl4ai)
- [Crawl4AI vs Firecrawl (BrightData)](https://brightdata.com/blog/ai/crawl4ai-vs-firecrawl)
- [Crawl4AI MCP SSE issue #1316](https://github.com/unclecode/crawl4ai/issues/1316)
