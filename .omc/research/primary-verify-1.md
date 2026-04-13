# Primary Source Verification Report

**Date:** 2026-04-13
**Method:** WebFetch of official GitHub READMEs and documentation pages only. No blog posts, no third-party listings.

---

## 1. Serena

**Source:** https://github.com/oraios/serena

### What It Actually Does
> "Serena provides essential **semantic code retrieval, editing and refactoring tools** that are akin to an IDE's capabilities, operating at the symbol level and exploiting relational structure."

It integrates with LLMs via MCP to function as an IDE for coding agents.

### Install Command (FROM README)
```
uv tool install -p 3.13 serena-agent@latest --prerelease=allow
```
**VERDICT:** Install command matches what we had. CONFIRMED.

### Supported Languages
> "Support for over 40 programming languages, including AL, Ansible, Bash, C#, C/C++, Clojure, Crystal, Dart, Elixir, Elm, Erlang, Fortran, F#, GLSL, Go, Groovy, Haskell, Haxe, HLSL, Java, JavaScript, Julia, Kotlin, Lean 4, Lua, Luau, Markdown, MATLAB, mSL, Nix, OCaml, Perl, PHP, PowerShell, Python, R, Ruby, Rust, Scala, Solidity, Swift, TOML, TypeScript, WGSL, YAML, and Zig."

**Count: 40+ languages.** README says "over 40."

### MCP Tools Exposed
Core symbolic tools: `find_symbol`, `symbol_overview`, `find_references`, `rename`, `replace_symbol_body`, `insert_before_symbol`, `insert_after_symbol`, `safe_delete`. Basic utilities: `search_for_pattern`, `replace_content`, `list_dir`, `find_file`, `read_file`, `execute_shell_command`.

### Pricing/Limits
Open-source language server backend is free. Paid JetBrains Plugin available (free trial). No usage limits mentioned in README.

### Latest Version
v1.1.1 (released April 12, 2026)

### Red Flags
README warns against marketplace versions due to "outdated and suboptimal installation commands." Otherwise clean.

---

## 2. ast-grep MCP

**Source:** https://github.com/ast-grep/ast-grep-mcp

### What It Actually Does
> "An experimental Model Context Protocol (MCP) server that provides AI assistants with powerful structural code search capabilities using ast-grep."

### Install Command (FROM README)
```bash
git clone https://github.com/ast-grep/ast-grep-mcp.git
cd ast-grep-mcp
uv sync
```
Or via uvx: `uvx --from git+https://github.com/ast-grep/ast-grep-mcp ast-grep-server`

### MCP Tools Exposed
4 tools total:
1. `dump_syntax_tree` — Visualize Abstract Syntax Tree structures
2. `test_match_code_rule` — Test YAML rules against code snippets
3. `find_code` — Search using simple AST patterns
4. `find_code_by_rule` — Advanced search with complex YAML rules

### Supported Languages
JavaScript/TypeScript, Python, Rust, Go, Java, C/C++, C#, and "many more." Custom languages via `sgconfig.yaml`.

### Pricing/Limits
Open-source (MIT license). No pricing. Optional `max_results` and `output_format` parameters but no hard limits.

### Latest Version
No version number published. 57 commits on main. No GitHub releases.

### Red Flags
- **EXPERIMENTAL**: README explicitly states "This is an experimental project"
- Requires separate `ast-grep` binary in system PATH
- No release versions published

---

## 3. GitNexus

**Source:** https://github.com/abhigyanpatwari/GitNexus

### What It Actually Does
> "Indexes any codebase into a knowledge graph — every dependency, call chain, cluster, and execution flow."

CLI indexes your repository and runs an MCP server that gives AI agents deep codebase awareness.

### Does It ACTUALLY Have MCP Support?
**YES.** README confirms: "CLI indexes your repository and runs an MCP server that gives AI agents deep codebase awareness." Exposes 16 MCP tools (11 per-repo + 5 group-level).

### Does It Actually Ship Claude Code Skills?
**YES.** README states skills are "installed to `.claude/skills/` automatically" covering Exploring, Debugging, Impact Analysis, and Refactoring. Also generates repo-specific skills with `--skills` flag.

### Install Command (FROM README)
```bash
npx gitnexus analyze
```
No global install needed. Also: `npx gitnexus setup` for auto-detect editors.

For Claude Code MCP specifically:
```bash
claude mcp add gitnexus -- npx -y gitnexus@latest mcp
```

### Pricing
Free open-source (PolyForm Noncommercial license). Enterprise SaaS/self-hosted via akonlabs.com — no price listed.

### Red Flags
- **Crypto scam warning at top of README:** "GitNexus has NO official cryptocurrency, token, or coin." — Suggests impersonation/scam attempts exist.
- **License restriction:** Free version is explicitly **noncommercial only**.
- Web UI limited by browser memory (~5k files).

**VERDICT:** NOT README hype. MCP and Claude Code skills are real and documented. But the noncommercial license is a significant limitation.

---

## 4. Crawl4AI

**Source:** https://github.com/unclecode/crawl4ai + https://docs.crawl4ai.com/core/self-hosting/

### What It Actually Does
> "Crawl4AI turns the web into clean, LLM ready Markdown for RAG, agents, and data pipelines."

### Does It Have a BUILT-IN MCP Server?
**YES.** Official docs confirm MCP is built into the server (v0.8.x). NOT community-only.

MCP endpoints:
- SSE: `http://localhost:11235/mcp/sse`
- WebSocket: `ws://localhost:11235/mcp/ws`

Claude Code setup:
```bash
claude mcp add --transport sse c4ai-sse http://localhost:11235/mcp/sse
```

### MCP Tools Exposed
From official docs:
- `md` — Generate markdown from web content
- `html` — Extract preprocessed HTML
- `screenshot` — Capture webpage screenshots
- `pdf` — Generate PDF documents
- `execute_js` — Run JavaScript on web pages

### Install Command (FROM README)
```bash
pip install -U crawl4ai
crawl4ai-setup
crawl4ai-doctor
```

### Pricing/Limits
Open-source, no built-in rate limits. "Crawl4AI Cloud API" in closed beta — pricing TBD. Sponsorship tiers ($5-$2000/month) for enterprise support.

### Latest Version
**v0.8.6** — Security hotfix.

### Red Flags
- **CRITICAL: Supply chain compromise in v0.8.5.** README states: "Security hotfix — replaced litellm with unclecode-litellm due to a PyPI supply chain compromise." Users MUST be on v0.8.6+.
- Deprecated sync version being removed.
- Requires Playwright/Chromium browser installation.

**Since which version has MCP been available?** NOT IN README. Docs only say current v0.8.x supports it. Cannot pinpoint the exact version it was introduced.

---

## 5. Docfork

**Sources:** https://github.com/docfork/docfork + https://docs.docfork.com/rate-limits

### What It Actually Does
> "Lock your agent's context to your stack" — define a Cabinet with specific libraries; only docs from your approved tech stack appear in searches.

### Install Command (FROM README)
```bash
claude mcp add docfork -- npx -y docfork --api-key YOUR_API_KEY
```

### Free Tier (FROM README)
> "Free: 1,000 requests/month, 5 team seats"

### ACTUAL Rate Limits (FROM docs.docfork.com/rate-limits)

| Limit Type | Anonymous | Authenticated (API key) |
|---|---|---|
| Search (per min) | 20/min | 60/min |
| Regular (per min) | 120/min | 300/min |
| Monthly cap | 500/mo | 1,000/mo |

- "Search" = `/v1/search` and MCP `search_docs` calls
- "Regular" = Other API routes like `/v1/read` and MCP `fetch_doc`
- Monthly caps use "Rolling 30-day window"
- **Per-organization:** "all API keys in the same workspace share the same limits"
- Plan upgrades and higher limits are "coming soon"

### Library Count
> "10,000+ libraries" pre-chunked with "~200ms edge retrieval"

### Latest Version
v2.1.0 (released March 4, 2026)

### Red Flags
- Community-contributed catalog: "We review submissions but can't guarantee accuracy for every project."
- API key required for full limits (anonymous gets only 500/mo).

---

## 6. Context7

**Source:** https://github.com/upstash/context7

### What It Actually Does
> "Context7 pulls up-to-date, version-specific documentation and code examples straight from the source — and places them directly into your prompt."

### Current Install Command (FROM README)
```bash
npx ctx7 setup
```
This authenticates via OAuth, generates an API key, and installs the appropriate skill or MCP mode.

### Is API Key Required or Optional?
**Optional but recommended.** README states:
> "API Key Recommended: Get a free API key at context7.com/dashboard for higher rate limits."

You can use Context7 without a key, but rate limits improve with one.

### Free Tier Details
NOT IN README. Only mentions an API key grants "higher rate limits" — no quantification of baseline or premium thresholds.

### Rate Limits
NOT IN README. Only says API key gives "higher rate limits" vs unauthenticated baseline. No numbers provided.

### Latest Version
@upstash/context7-mcp@2.1.8 (released April 13, 2026)

### Red Flags
- Community-contributed docs: "we cannot guarantee the accuracy, completeness, or security of all library documentation"
- **Private backend:** "The supporting components — API backend, parsing engine, and crawling engine — are private and not part of this repository." Limits transparency.

---

## 7. DeepWiki

**Sources:** https://github.com/AsyncFuncAI/deepwiki-open + https://mcp.deepwiki.com/

### What It Actually Does
> "Automatically creates beautiful, interactive wikis for any GitHub, GitLab, or BitBucket repository"

### Is It Really Free With No Auth?
**PARTIALLY TRUE, BUT NUANCED.**

- The **hosted MCP endpoint** at `https://mcp.deepwiki.com/mcp` is free and requires no authentication for public repos.
- The **open-source self-hosted version** (deepwiki-open) requires your own LLM API keys (Google Gemini, OpenAI, OpenRouter, Azure OpenAI, or local Ollama). So it's free to run but you pay for the underlying LLM.
- For **private repos**, an authenticated endpoint exists at `https://mcp.devin.ai/mcp` with bearer token auth (requires Devin account).

### MCP Endpoint
**Public endpoint:** `https://mcp.deepwiki.com/mcp`

Claude Code setup:
```bash
claude mcp add -s user -t http deepwiki https://mcp.deepwiki.com/mcp
```

### MCP Tools
From search results: `ask_question`, `read_wiki_contents`, `read_wiki_structure`
NOT IN the mcp.deepwiki.com page directly — page didn't list tools explicitly.

### Install Command (Self-hosted)
```bash
git clone https://github.com/AsyncFuncAI/deepwiki-open.git
cd deepwiki-open
echo "GOOGLE_API_KEY=your_google_api_key" > .env
docker-compose up
```

### Red Flags
- **Maintenance shifting:** "Primary active development is moving to AsyncReview" — the open-source version may become stale.
- Self-hosted version incurs third-party API costs.
- The open-source repo has NO MCP endpoint — that's only the hosted service.
- No SLA on the free hosted endpoint.

---

## CORRECTION SUMMARY: What We Likely Got Wrong

### Confirmed Correct
1. **Serena** install command: CONFIRMED exactly as stated.
2. **Serena** 40+ languages: CONFIRMED.
3. **GitNexus** MCP + Claude Code skills: CONFIRMED real, not hype.
4. **Context7** API key optional: CONFIRMED.

### Corrections / Clarifications Needed

1. **Crawl4AI MCP**: If we previously said MCP was "community-only" — that is **WRONG**. MCP is built into the official Crawl4AI server (v0.8.x). However, the exact version that introduced it is NOT documented.

2. **Crawl4AI Security**: v0.8.5 had a **PyPI supply chain compromise**. This is a critical red flag that must be noted. v0.8.6 is the fix.

3. **DeepWiki**: If we said "free with no auth" as a blanket statement — that's **PARTIALLY WRONG**. The hosted MCP endpoint is free/no-auth for public repos. Self-hosted requires your own LLM API keys (costs money). Private repos require Devin auth. Also, the open-source repo does NOT have MCP — only the hosted service does.

4. **DeepWiki maintenance**: "Primary active development is moving to AsyncReview" — this is a significant concern for longevity.

5. **Docfork free tier**: If we said "1,000 requests/month free" — that's the **authenticated** limit. **Anonymous** users only get **500/month**. The real rate limits are more nuanced with per-minute caps too.

6. **Context7 rate limits**: NOT IN README. If we quoted specific numbers, those were fabricated. The README only says "higher rate limits" with API key — no numbers given.

7. **GitNexus license**: PolyForm **Noncommercial** — this is a major limitation that must be flagged. It's not a permissive open-source license.

8. **ast-grep MCP**: Explicitly **experimental** with no published releases. Should be flagged as unstable.
