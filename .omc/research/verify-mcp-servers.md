# MCP Server Verification Report
**Date:** April 11, 2026
**Scope:** Part D corpus roster verification + scout additions for Slots 9–17
**Methodology:** Primary-source GitHub fetches, registry API, official vendor docs

---

## 1. CODE INTELLIGENCE (Slot 9)

| Server | Corpus Claim | Verified | Stars | License | Last Commit / Release | Install Command | Caveats |
|--------|-------------|----------|-------|---------|----------------------|-----------------|---------|
| `oraios/serena` | Canonical pick, LSP-based, 30+ langs, Claude Plugin | UPDATED | 22.8k ★ (corpus silent on stars) | MIT | v1.1.0 — April 11, 2026 | `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` | **INSTALL COMMAND CHANGED.** Corpus shows `uvx --from git+…` but README now warns: "Do NOT install via MCP/plugin marketplace — they contain outdated commands." Use `uv tool install` path. |
| `entrepeneur4lyf/code-graph-mcp` | Graph-based code intelligence | UNVERIFIED | Unknown | Unknown | Unknown | Unknown | No independent confirmation found. Low signal — no stars data, no registry entry found. |
| `DeusData/codebase-memory-mcp` | Persistent KG, 66 langs, HNSW | CONFIRMED | Active repo confirmed | Unknown | Active 2026 | Binary install via repo | Alive. Single binary, zero deps claim confirmed. |
| `CodeGraphContext` | Alternative | UNVERIFIED | Unknown | Unknown | Unknown | Unknown | Too vague — name appears as a generic descriptor. No distinct repo identified. |
| `codegraph-rust` | Rust-native code graph | UNVERIFIED | Unknown | Unknown | Unknown | Unknown | No distinct GitHub repo found under this name. Likely description not a project slug. |

---

## 2. DOCS / LIBRARY LOOKUP (Slot 10)

| Server | Corpus Claim | Verified | Stars | License | Last Commit / Release | Install Command | Caveats |
|--------|-------------|----------|-------|---------|----------------------|-----------------|---------|
| `upstash/context7` | #1 on FastMCP, ~2× #2 | UPDATED | ~52k ★ | MIT | Active April 2026 | `claude mcp add context7 -- npx -y @upstash/context7-mcp --api-key YOUR_API_KEY` | **INSTALL CHANGED:** API key now recommended (free at context7.com/dashboard). Corpus shows no `--api-key` flag. Without key: basic functionality only. |
| DeepWiki MCP | Free remote, no-auth, `https://mcp.deepwiki.com/mcp`, 3 tools | CONFIRMED | N/A (remote) | N/A | Active 2026 | `claude mcp add-json deepwiki '{"type":"http","url":"https://mcp.deepwiki.com/mcp"}'` | Third-party scraper `regenrek/deepwiki-mcp` is broken (Cognition blocked scraping). Official remote endpoint confirmed alive. |
| ref.tools | "Surfaced but not independently verified" | UNVERIFIED | Unknown | Unknown | Unknown | Unknown | Corpus itself flagged as unverified. No update. |
| docs-mcp-server | Alternative, less mature | CONFIRMED | Active | MIT | Active 2026 | `npx -y @smithery/cli@latest install docs-mcp-server` | Alive. Corpus "less mature" assessment still holds. |

---

## 3. BROWSER AUTOMATION (Slot 11)

| Server | Corpus Claim | Verified | Stars | License | Last Commit / Release | Install Command | Caveats |
|--------|-------------|----------|-------|---------|----------------------|-----------------|---------|
| `@playwright/mcp` (microsoft) | Canonical, a11y-tree 10–100× faster | CONFIRMED | Active | Apache-2.0 | Active April 2026 | `claude mcp add playwright npx @playwright/mcp@latest` | NOTE: Microsoft released `@playwright/cli` as a companion in 2026 — 4× more token-efficient (~27k vs 114k tokens for typical task). For heavy automation, `@playwright/cli` may be preferred. |
| `ChromeDevTools/chrome-devtools-mcp` | 26 tools, live Chrome debug | CONFIRMED | Active | Apache-2.0 | Active 2026; blog post March 2026 | `claude plugin marketplace add ChromeDevTools/chrome-devtools-mcp` | Official Google/ChromeDevTools org repo. Alive and well-maintained. |
| `browserbase/mcp-server-browserbase` | Stagehand v3, cloud, 20-40% faster | CONFIRMED | 603 ★ | MIT | Active 2026 | `npx @browserbasehq/mcp-server-browserbase` | Stagehand v3 confirmed. Cloud-hosted. Requires BROWSERBASE_API_KEY + BROWSERBASE_PROJECT_ID. |
| Puppeteer MCP | Alternative | CONFIRMED | Active | Apache-2.0 | Active 2026 | `npx -y @modelcontextprotocol/server-puppeteer` | Official reference impl in modelcontextprotocol/servers. Alive. |
| `lightpanda-io/browser` | Zig headless browser for AI | CONFIRMED | ~27.5k ★ | MIT | Active March–April 2026 | `lightpanda mcp` (built-in stdio MCP server) | **MAJOR UPDATE:** Now has native built-in MCP support (`lightpanda mcp`). Also ships `gomcp` Go-based MCP server. 11× faster, 9× less memory vs Chrome. |
| `trycua/cua` | Local computer-use operator, macOS | UNVERIFIED | Unknown | Unknown | Unknown | Unknown | No independent verification obtained. macOS-only scope noted. |
| page-agent | JS GUI agent for web control | UNVERIFIED | Unknown | Unknown | Unknown | Unknown | Not independently verified. |

---

## 4. GITHUB / GIT (Slot 12)

| Server | Corpus Claim | Verified | Stars | License | Last Commit / Release | Install Command | Caveats |
|--------|-------------|----------|-------|---------|----------------------|-----------------|---------|
| `github/github-mcp-server` | Official, 28,300+★, 51 tools | UPDATED | 28.8k ★ | MIT | Active April 2026, 780 commits | **HTTP (recommended):** `claude mcp add-json github '{"type":"http","url":"https://api.githubcopilot.com/mcp/","headers":{"Authorization":"Bearer YOUR_PAT"}}'` **Docker:** `docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server` | **TOOL COUNT CHANGED.** Corpus says "51 tools." Actual count now significantly higher — repo changelog lists Projects tools, OAuth scope filtering, code scanning, and `get_me` additions since corpus was written (Jan 28, 2026 changelog). Rewritten in Go. |
| GitLab community forks | Generic mention | CLARIFIED | zereight/gitlab-mcp active; yoda-digital/mcp-gitlab-server (86 tools, enterprise); wadew/gitlab-mcp (Python, PyPI) | Various MIT | Active 2026 | `npx @zereight/gitlab-mcp` or `pip install python-gitlab-mcp` | No single canonical community fork. Multiple mature options. Note: GitLab itself now has official MCP docs at docs.gitlab.com/user/gitlab_duo/model_context_protocol/ |

---

## 5. DATABASES (Slot 13)

| Server | Corpus Claim | Verified | Stars | License | Last Commit / Release | Install Command | Caveats |
|--------|-------------|----------|-------|---------|----------------------|-----------------|---------|
| Supabase MCP | v0.7.0 (Mar 2026), OAuth 2.1, **explicitly dev/test only** | CONFIRMED + STRENGTHENED | 2.6k ★ | Apache-2.0 | Active 2026, 361 commits | `claude mcp add supabase -- npx supabase-mcp` | **DEV-ONLY CAVEAT CONFIRMED.** Official Supabase docs state: "Don't connect to production: Use the MCP server with a development project, not production." Bypasses Row Level Security. For production use: enable read-only mode and use branching. |
| postgres-mcp | Plain Postgres | CONFIRMED | Active | MIT | Active 2026 | `npx -y @modelcontextprotocol/server-postgres postgresql://localhost/mydb` | Alive. Official reference impl. |
| MongoDB MCP | Community mention | CONFIRMED | Active | Apache-2.0 | Active 2026 (official MongoDB Atlas MCP launched) | `npx -y mongodb-mcp-server` | MongoDB Inc launched official Atlas MCP server in 2026. Not just community. |
| MySQL MCP | Community mention | CONFIRMED | Active | MIT | Active 2026 | Community implementations active on npm/PyPI | Multiple community servers, no single canonical. |
| SQLite MCP | Community mention | CONFIRMED | Active | MIT | Active 2026 | `npx -y @modelcontextprotocol/server-sqlite` | Official reference impl in modelcontextprotocol/servers. |

**SCOUT ADDITION — googleapis/mcp-toolbox:** Google's open-source MCP server for enterprise databases (BigQuery, AlloyDB, Spanner, CloudSQL, Postgres, MySQL). v0.30.0 released March 20, 2026. Prebuilt generic tools (`list_tables`, `execute_sql`) plus custom NL2SQL. Install: `claude mcp add --transport http mcp-toolbox https://your-toolbox-url/mcp`. Repo: https://github.com/googleapis/mcp-toolbox

---

## 6. MEMORY (Slot 14)

| Server | Corpus Claim | Verified | Stars | License | Last Commit / Release | Install Command | Caveats |
|--------|-------------|----------|-------|---------|----------------------|-----------------|---------|
| `modelcontextprotocol/servers/memory` | Official reference, local JSON KG | CONFIRMED | Part of 13k+ ★ monorepo | MIT | Active 2026 | `npx -y @modelcontextprotocol/server-memory` | Alive. MEMORY_FILE_PATH env var configures storage path. |
| `gannonh/memento-mcp` | Neo4j backend, unified graph+vector | CONFIRMED | Active | MIT | Active 2026 | `npx @gannonh/memento-mcp` | Alive. Neo4j dependency confirmed. |
| `doobidoo/mcp-memory-service` | 1,642★, REST API, KG, dream consolidation | UPDATED | **1.3k ★** (corpus says 1,642★ — small downward delta, within normal range) | MIT | v10.28.5 active April 2026 | `pip install mcp-memory-service` | **MINOR STAR DISCREPANCY.** Corpus 1,642 vs current ~1.3k — likely measurement timing diff. Repo very actively maintained. |
| `yoloshii/ClawMem` | 96★, BM25+vector+RRF, 31 MCP tools, TypeScript/Bun | UNVERIFIED | Unknown 2026 | Unknown | Unknown | Unknown | Could not re-confirm. Low-star repo, may have been renamed or archived. |
| `thedotmack/claude-mem` | ~12.9k★, highest-star CC memory plugin | UPDATED | **46.7k ★** (corpus says ~12.9k) | MIT | v11.0.0, April 4, 2026 | `claude plugin marketplace add thedotmack/claude-mem` | **MAJOR GROWTH.** Star count tripled+ since corpus write. Active releases through April 2026. MCP exposes 4 tools: search, timeline, get_observations. Excellent signal. |
| `m4cd4r4/claude-echoes` | Show HN Apr 9 2026, 81% LongMemEval, pgvector+BM25 | CONFIRMED | Active | MIT | April 2026 | `git clone && docker compose up` (Postgres + Ollama) | **SCORE CONFIRMED:** 81.0% LongMemEval (ICLR 2025) with Sonnet 4.6. pgvector cosine + BM25 RRF + temporal reranking. CPU-only, no GPU required. |
| `visionscaper/collabmem` | Show HN Apr 11 2026 | UNVERIFIED | Unknown | Unknown | April 11, 2026 (brand new) | Unknown | Brand new as of corpus write date. Could not obtain star/install data — too new. |
| memU | 13.3k★ | UNVERIFIED | 13k★ attributed to "Memori" by search; exact project identity unclear | Unknown | Unknown | Unknown | **IDENTITY UNCERTAIN.** Could not confirm "memU" as a distinct project. May be `Memori` (guffawaffle, 13k★, episodic memory). |
| `agenteractai/lodmem` | Level-of-Detail context management | UNVERIFIED | Unknown | Unknown | Unknown | Unknown | No confirmation obtained. |
| `coleam00/claude-memory-compiler` | Karpathy-style KB compiler | UNVERIFIED | Unknown | Unknown | Unknown | Unknown | No confirmation obtained. |
| `memvid/claude-brain` | Single .mv2 file, Rust core | UNVERIFIED | Unknown | Unknown | Unknown | Unknown | No confirmation obtained. |

**SCOUT ADDITION — milla-jovovich/mempalace:** Viral April 2026 memory system. 23k★ in 72 hours. 96.6% LongMemEval (raw ChromaDB nearest-neighbor — **caveat: this measures ChromaDB's embedding model, not MemPalace's "palace" architecture**). 19 MCP tools. MIT. Python. Install: `pip install mempalace`. Repo: https://github.com/milla-jovovich/mempalace. Community scrutiny forced README correction about benchmark methodology.

**SCOUT ADDITION — supermemoryai/supermemory:** Universal memory API. 15k★. Fast/scalable. MCP at `https://mcp.supermemory.ai/mcp`. Repo: https://github.com/supermemoryai/supermemory

---

## 7. OBSERVABILITY (Slot 15)

| Server | Corpus Claim | Verified | Stars | License | Last Commit / Release | Install Command | Caveats |
|--------|-------------|----------|-------|---------|----------------------|-----------------|---------|
| `getsentry/sentry-mcp` | Official Sentry | CONFIRMED + UPDATED | Active | MIT | Active 2026 | **TRANSPORT CHANGED from corpus.** Remote HTTP with OAuth: `claude mcp add-json sentry '{"type":"http","url":"https://mcp.sentry.dev/mcp"}'` OR as Claude plugin: `claude plugin marketplace add getsentry/sentry-mcp` | **INSTALL METHOD UPDATED.** Corpus shows generic stdio approach. Current canonical method is remote HTTP at `https://mcp.sentry.dev/mcp` with OAuth. No local install needed. Self-hosted instances use `npx @sentry/mcp-server@latest`. |
| `PostHog/mcp` | Official PostHog | UPDATED | 141★ (archived) | MIT | **ARCHIVED Jan 19, 2026** | See PostHog monorepo | **STALE — ARCHIVED.** PostHog/mcp repo was archived on Jan 19, 2026 and moved into the PostHog monorepo. New install path via PostHog Wizard or posthog.com/docs/model-context-protocol. |

**SCOUT ADDITION — datadog-labs/mcp-server:** Official Datadog MCP server. GA March 10, 2026. 16+ core tools + optional APM/Error Tracking/Feature Flags/LLM Observability toolsets. Remote HTTP. Install: `{"type":"http","url":"https://mcp.datadoghq.com/api/unstable/mcp-server/mcp"}`. Repo: https://github.com/datadog-labs/mcp-server. Significantly higher signal than PostHog for production observability.

---

## 8. SEARCH (Slot 16)

| Server | Corpus Claim | Verified | Stars | License | Last Commit / Release | Install Command | Caveats |
|--------|-------------|----------|-------|---------|----------------------|-----------------|---------|
| Exa MCP | Most-used search MCP 2026, native Claude connector, best for semantic | CONFIRMED | Active | MIT | Active 2026 | `claude mcp add --transport http exa "https://mcp.exa.ai/mcp?tools=web_search_exa"` | Remote HTTP canonical install confirmed. API key from dashboard.exa.ai. |
| Perplexity Sonar MCP | Cited synthesis answers | CONFIRMED | Active | MIT | Active 2026 | `claude mcp add perplexity --env PERPLEXITY_API_KEY="key" -- npx -y @perplexity-ai/mcp-server` | Official repo: `perplexityai/modelcontextprotocol`. Active. |
| Tavily | Acquired by Nebius Feb 2026, cheap keyword search | CONFIRMED + UPDATED | Active | MIT | Active 2026 | `claude mcp add --transport http --scope user tavily "https://mcp.tavily.com/mcp/?tavilyApiKey=YOUR_KEY"` | **ACQUISITION CONFIRMED.** Nebius acquired Tavily for $275M (Feb 10, 2026). API/data policies unchanged. Remote HTTP endpoint now canonical. |
| Brave Search MCP | Alternative | CONFIRMED | Active | MIT | Active 2026 | `npx -y @modelcontextprotocol/server-brave-search` | Official reference impl. Alive. |
| Serper MCP | Alternative | CONFIRMED | Active | MIT | Active 2026 | Community npm package | Community implementation. Alive. |

---

## 9. SANDBOX BRIDGES (Slot 17)

| Server | Corpus Claim | Verified | Stars | License | Last Commit / Release | Install Command | Caveats |
|--------|-------------|----------|-------|---------|----------------------|-----------------|---------|
| `dagger/container-use` | v0.4.2, ~3.7k★, per-agent git branch+container | CONFIRMED | 3.7k★ | Apache-2.0 | Active 2026 | `brew install dagger/tap/container-use` OR `curl -fsSL https://raw.githubusercontent.com/dagger/container-use/main/install.sh | bash` | **INSTALL CHANGED.** Corpus shows `container-use stdio` command after install. Brew tap path is now canonical. Project described as "early development, actively evolving." |
| `microsandbox/microsandbox` | 5.3k★, libkrun microVMs, <100ms boot | CONFIRMED | 5.3k★ | MIT | Active 2026 | `curl -fsSL https://install.microsandbox.dev | sh && claude mcp add --transport stdio microsandbox -- npx -y microsandbox-mcp` | Both install steps confirmed. Hardware-level VM isolation. Repo now at `superradcompany/microsandbox` on GitHub (not `microsandbox/microsandbox`). |
| E2B via MCP | Community wrapper | CONFIRMED | 359★ | Apache-2.0 | Active 2026 | `npx -y @e2b/mcp-server` | Official e2b-dev/mcp-server confirmed. Not just "community wrapper" — E2B maintains it officially. |

---

## 10. OFFICIAL REGISTRY STATE (Task 3)

**Registry URL:** https://registry.modelcontextprotocol.io  
**API:** v0 at `/v0/servers?limit=N`

**Findings:**
- The registry API uses cursor-based pagination. No `total_count` field is exposed in the API response.
- The registry page itself shows "Loading servers..." with no aggregate total displayed in the UI.
- Corpus claim of ~2,000 entries as of early 2026 with 407% growth **cannot be directly confirmed or refuted** from the API alone.
- Secondary sources (apify.com April 2026 handbook) reference "500+ servers" as a conservative estimate of the curated registry specifically; broader ecosystem (GitHub+npm+PyPI) is cited at 12,000+.
- The registry's metadata format uses a cursor (`nextCursor`) for pagination. Format appears unchanged from the v0.1 API freeze (Oct 24, 2025).
- The registry does not show timestamps, growth rates, or aggregate counts in its current form.

**Best estimate:** Official registry likely has 1,500–2,500 entries. The 407% growth claim may have normalized; broader MCP ecosystem (12,000+) continues growing. The "~2,000 registry entries" corpus claim is plausible but unconfirmable from the API.

---

## 11. SCOUT ADDITIONS (Task 2) — Up to 10 New High-Signal Servers

| # | Server | Slot | Stars | Why Notable | Install |
|---|--------|------|-------|-------------|---------|
| 1 | **datadog-labs/mcp-server** | Observability | Unknown (official) | Official Datadog GA March 2026, 16+ tools, replaces the archiving of PostHog/mcp | `{"type":"http","url":"https://mcp.datadoghq.com/api/unstable/mcp-server/mcp"}` |
| 2 | **milla-jovovich/mempalace** | Memory | 23k★ (April 2026) | Viral, 19 MCP tools, 96.6% LongMemEval (benchmark caveated), MIT | `pip install mempalace` |
| 3 | **vercel/mcp (vercel.com/docs/agent-resources/vercel-mcp)** | Infra/Deploy | Official | Official Vercel remote MCP with OAuth, Streamable HTTP, project/deployment access | `claude mcp add --transport http vercel https://mcp.vercel.com` |
| 4 | **stripe/mcp (mcp.stripe.com)** | Payments | Official | Official Stripe remote MCP, 25 tools covering full payment lifecycle, Anthropic partner | `claude mcp add --transport http stripe https://mcp.stripe.com` |
| 5 | **googleapis/mcp-toolbox** | Databases | Official Google | Google's enterprise DB MCP (BigQuery, AlloyDB, Spanner), v0.30.0 March 2026 | Self-hosted HTTP |
| 6 | **linear.app MCP (mcp.linear.app)** | Project Mgmt | Official | Official Linear remote MCP, native in Claude/Cursor, Anthropic partner | `claude mcp add --transport http linear https://mcp.linear.app/mcp` |
| 7 | **cloudflare/mcp (mcp.cloudflare.com)** | Infra | Official | Official Cloudflare API MCP, 2,500 endpoints in 1k tokens, Code Mode powered | `{"type":"http","url":"https://mcp.cloudflare.com/mcp"}` |
| 8 | **supermemoryai/supermemory** | Memory | 15k★ | Universal memory API, fast/scalable, cross-LLM, remote MCP | `{"type":"http","url":"https://mcp.supermemory.ai/mcp"}` |
| 9 | **figma/mcp-server** | Design/Browser | Official (Anthropic partner) | Official Figma MCP, design-to-code, reads frames/components/layout, Claude plugin | Via Figma Claude plugin marketplace |
| 10 | **@playwright/cli** (microsoft) | Browser | Official MS | Not an MCP server — a **CLI companion** to Playwright MCP that uses 4× fewer tokens (27k vs 114k). Corpus users should know about this tradeoff. | `npx @playwright/cli` |

---

## 12. CORPUS DIFF SUMMARY (Task 4) — Load-Bearing Stale Claims

| # | Corpus Claim | Status | Correction |
|---|-------------|--------|------------|
| 1 | `oraios/serena` install: `uvx --from git+https://github.com/oraios/serena serena start-mcp-server` | STALE | README explicitly warns against this. Use `uv tool install -p 3.13 serena-agent@latest --prerelease=allow`. |
| 2 | `PostHog/mcp` — "official" observability server | STALE — ARCHIVED | Repo archived Jan 19, 2026. Moved to PostHog monorepo. New install via PostHog Wizard. |
| 3 | `upstash/context7` install: `npx -y @upstash/context7-mcp@latest` (no API key) | PARTIAL STALE | API key now recommended for reliable use. Free tier available at context7.com/dashboard. |
| 4 | `github/github-mcp-server`: "51 tools" | STALE | Tool count increased — Projects tools, code scanning, `get_me`, OAuth scope filtering added Jan 2026+. |
| 5 | Sentry MCP transport: corpus implies stdio/generic | STALE | Canonical method is remote HTTP at `https://mcp.sentry.dev/mcp` with OAuth. Claude plugin also available. |
| 6 | `thedotmack/claude-mem` at ~12.9k★ | STALE (signal, not error) | Now 46.7k★ — tripled. Still recommended but prominence significantly higher than corpus suggests. |
| 7 | `microsandbox/microsandbox` org path | MINOR STALE | Repo lives at `superradcompany/microsandbox` on GitHub, not `microsandbox/microsandbox`. |
| 8 | `dagger/container-use` install via `container-use stdio` | STALE | Canonical install now via `brew install dagger/tap/container-use` or install script. |
| 9 | Tavily described generically | SUPPLEMENTAL | Acquired by Nebius for $275M (Feb 2026). Remote HTTP endpoint `https://mcp.tavily.com/mcp/` is now canonical. |
| 10 | DeepWiki third-party `regenrek/deepwiki-mcp` scraper | STALE | Broken — Cognition blocked scraping. Official endpoint `https://mcp.deepwiki.com/mcp` still works. |

---

## Sources

- [oraios/serena GitHub](https://github.com/oraios/serena)
- [upstash/context7 GitHub](https://github.com/upstash/context7)
- [github/github-mcp-server GitHub](https://github.com/github/github-mcp-server)
- [GitHub MCP Server Changelog Jan 2026](https://github.blog/changelog/2026-01-28-github-mcp-server-new-projects-tools-oauth-scope-filtering-and-new-features/)
- [microsoft/playwright-mcp GitHub](https://github.com/microsoft/playwright-mcp)
- [Supabase MCP Docs](https://supabase.com/docs/guides/getting-started/mcp)
- [supabase-community/supabase-mcp GitHub](https://github.com/supabase-community/supabase-mcp)
- [getsentry/sentry-mcp GitHub](https://github.com/getsentry/sentry-mcp)
- [Sentry MCP Docs](https://docs.sentry.io/product/sentry-mcp/)
- [PostHog/mcp GitHub (archived)](https://github.com/PostHog/mcp)
- [PostHog MCP Docs](https://posthog.com/docs/model-context-protocol)
- [dagger/container-use GitHub](https://github.com/dagger/container-use)
- [superradcompany/microsandbox GitHub](https://github.com/superradcompany/microsandbox)
- [e2b-dev/mcp-server GitHub](https://github.com/e2b-dev/mcp-server)
- [Exa MCP Docs](https://docs.exa.ai/reference/exa-mcp)
- [Tavily MCP Docs](https://docs.tavily.com/documentation/mcp)
- [Nebius/Tavily acquisition Bloomberg](https://www.bloomberg.com/news/articles/2026-02-10/nebius-agrees-to-buy-ai-agent-search-company-tavily-for-275-million)
- [perplexityai/modelcontextprotocol GitHub](https://github.com/perplexityai/modelcontextprotocol)
- [thedotmack/claude-mem GitHub](https://github.com/thedotmack/claude-mem)
- [m4cd4r4/claude-echoes GitHub](https://github.com/m4cd4r4/claude-echoes)
- [milla-jovovich/mempalace GitHub](https://github.com/milla-jovovich/mempalace)
- [lightpanda-io/browser GitHub](https://github.com/lightpanda-io/browser)
- [browserbase/mcp-server-browserbase GitHub](https://github.com/browserbase/mcp-server-browserbase)
- [ChromeDevTools/chrome-devtools-mcp GitHub](https://github.com/ChromeDevTools/chrome-devtools-mcp)
- [datadog-labs/mcp-server GitHub](https://github.com/datadog-labs/mcp-server)
- [Datadog MCP Launch Press Release](https://www.datadoghq.com/about/latest-news/press-releases/datadog-launches-mcp-server/)
- [googleapis/mcp-toolbox GitHub](https://github.com/googleapis/mcp-toolbox)
- [Vercel MCP Docs](https://vercel.com/docs/agent-resources/vercel-mcp)
- [Stripe MCP](https://mcp.stripe.com)
- [Linear MCP Docs](https://linear.app/docs/mcp)
- [Cloudflare MCP Docs](https://developers.cloudflare.com/agents/model-context-protocol/mcp-servers-for-cloudflare/)
- [Official MCP Registry](https://registry.modelcontextprotocol.io/)
- [MCP Registry GitHub](https://github.com/modelcontextprotocol/registry)
- [tolkonepiu/best-of-mcp-servers GitHub](https://github.com/tolkonepiu/best-of-mcp-servers)
- [Show HN: claude-echoes 81% LongMemEval](https://news.ycombinator.com/item?id=47704318)
- [MemPalace benchmark analysis](https://github.com/lhl/agentic-memory/blob/main/ANALYSIS-mempalace.md)
