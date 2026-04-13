# Primary Source Verification Report — Batch 3 (Tools 15–21)

**Date:** 2026-04-13
**Method:** Direct fetches from official websites, GitHub repos, and documentation pages.

---

## 15. CodeRabbit

### What It Does
> "CodeRabbit is an AI-powered code review and planning platform. Review pull requests with context-aware AI, plan implementations from issues with deep codebase understanding, and get real-time feedback in your IDE or CLI."
— [docs.coderabbit.ai](https://docs.coderabbit.ai)

### AI Model
**Multi-model approach.** CodeRabbit does NOT use a single model. Per [OpenAI case study](https://openai.com/index/coderabbit/) and [CodeRabbit blog](https://www.coderabbit.ai/blog/behind-the-curtain-what-it-really-takes-to-bring-a-new-model-online-at-coderabbit):
- **NVIDIA Nemotron** for context gathering and summarization stage
- **OpenAI o3/o4-mini** for reasoning-heavy review
- **OpenAI GPT-5.2-Codex** and **Anthropic Claude Opus/Sonnet 4.5** for deep review work
- Different parts of the review pipeline route to different model families

### Pricing (from [coderabbit.ai/pricing](https://coderabbit.ai/pricing))
| Plan | Price | Key Features |
|------|-------|--------------|
| **Free** | $0/month | Unlimited public AND private repos, PR summarization, reviews in IDE. 14-day Pro trial included. Rate limit: 200 files/hr, 4 PR reviews/hr |
| **Pro** | $24/mo (annual) / $30/mo | Unlimited PR reviews, Jira/Linear integrations, linters, SAST, analytics dashboards, docstring generation, higher IDE rate limits |
| **Enterprise** | Custom | Self-hosting, multi-org, SLA, dedicated CSM |

### Free Tier Reality
- **YES, truly free for public repos forever:** "Sign up for CodeRabbit using GitHub or GitLab, install CodeRabbit on a public repository, and receive free reviews forever for public repositories."
- **YES, free for private repos too** — unlimited repos and team members, but rate-limited (200 files/hr, 4 reviews/hr)
- No cap on number of PRs reviewed or repos connected on any plan

### Install
Install as GitHub App or GitLab integration from coderabbit.ai.

### Red Flags
- Free tier rate limits (4 reviews/hr) may be tight for active teams
- 14-day Pro trial auto-included — watch for surprise billing if payment method added

---

## 16. Snyk MCP

### Does It Exist?
**YES — official Snyk MCP server exists.** Not assumed. Confirmed at [snyk.io/snyk-for-claude-code](https://snyk.io/snyk-for-claude-code/) and [Snyk docs](https://docs.snyk.io/integrations/snyk-studio-agentic-integrations/quickstart-guides-for-snyk-studio/claude-code-guide).

### What It Does
> "This is the official implementation from Snyk, designed to integrate their comprehensive security scanning capabilities into MCP-enabled environments."
— [snyk.io](https://snyk.io/articles/claude-desktop-and-snyk-mcp/)

Embodies "Secure at Inception" — security testing occurs automatically when code is generated.

### Install
```bash
npx -y snyk@latest mcp configure --tool=claude-cli
```
Requires Snyk CLI v1.1298.0+. Authentication flow follows.

### MCP Tools (11 tools)
1. `snyk_aibom` — AI Bill of Materials for Python projects
2. `snyk_auth` — Authenticate with Snyk
3. `snyk_auth_status` — Check auth status
4. `snyk_code_scan` — SAST (Static Application Security Testing)
5. `snyk_container_scan` — Container image vulnerability scanning
6. `snyk_iac_scan` — Infrastructure as Code security analysis
7. `snyk_logout` — Logout
8. `snyk_sbom_scan` — SBOM vulnerability analysis
9. `snyk_sca_scan` — Open-source vulnerability and license analysis
10. `snyk_trust` — Trust folders for scanning
11. `snyk_version` — CLI version info

### Pricing / Limits
Free plan has monthly test limits:
- 400 tests for Open Source scanning
- 100 tests for Code analysis
- 300 tests for Infrastructure as Code
- 100 tests for Container scanning

### Red Flags
- Free tier test limits can be consumed quickly on large projects
- There is also a community/unofficial MCP at [github.com/sammcj/mcp-snyk](https://github.com/sammcj/mcp-snyk) — don't confuse with the official one

---

## 17. PostgreSQL MCP

### Which One Is Best?
There are multiple PostgreSQL MCP servers. The main options:

#### A) Official MCP Reference Server (`@modelcontextprotocol/server-postgres`)
- Part of the official [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) repo
- Install: `claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres $DATABASE_URL`
- Basic: runs SQL queries, inspects schemas, read-only by default
- Minimal feature set — good for simple use cases

#### B) Postgres MCP Pro (`postgres-mcp` by CrystalDBA) — **RECOMMENDED**
- **Stars:** 2.5k — [github.com/crystaldba/postgres-mcp](https://github.com/crystaldba/postgres-mcp)
- **License:** MIT
- **Description:** "configurable read/write access and performance analysis for you and your AI agents"
- **8 MCP tools:**
  - `list_schemas` / `list_objects` / `get_object_details` (schema inspection)
  - `execute_sql` (query execution with access restrictions)
  - `explain_query` (execution plans with hypothetical indexes)
  - `get_top_queries` (workload analysis via pg_stat_statements)
  - `analyze_workload_indexes` (automatic index recommendations)
  - `analyze_query_indexes` (query-specific tuning)
  - `analyze_db_health` (comprehensive health checks — index health, connection utilization, buffer cache, vacuum health, sequence limits, replication lag)
- Supports both stdio and SSE transports
- Configurable: Unrestricted Mode (read/write for dev) and Restricted Mode (read-only for prod)
- Install: `pip install postgres-mcp` or via PyPI

#### C) pg-aiguide (by Timescale)
- [github.com/timescale/pg-aiguide](https://github.com/timescale/pg-aiguide)
- Semantic search over PostgreSQL, TimescaleDB, and PostGIS manuals
- Best for PostgreSQL knowledge/docs, not for direct DB interaction

### Red Flags
- Official MCP server is very basic — most teams will want Postgres MCP Pro
- Be careful with read/write mode in production

---

## 18. Supabase Plugin / MCP

### What It Is
> "Connect Supabase to your AI assistants"
— [github.com/supabase-community/supabase-mcp](https://github.com/supabase-community/supabase-mcp)

Supabase is an **official Claude connector** as of February 2026 ([supabase.com/blog](https://supabase.com/blog/supabase-is-now-an-official-claude-connector)).

### Is It Supabase-Only or General Postgres?
**Supabase-only.** It manages Supabase projects specifically — not a general Postgres client. Per the docs: tools interact with "your Supabase projects," including project management, edge functions, branching, storage, etc.

### Stars: 2.6k
### License: Apache 2.0
### Version: Pre-1.0 (breaking changes expected)

### Tools (40+ tools, organized by feature group)
- **Account:** project/organization management, cost confirmation
- **Knowledge Base:** Supabase documentation search
- **Database:** table/extension/migration management, SQL execution
- **Debugging:** logs and advisory notices
- **Development:** API URLs, TypeScript type generation
- **Edge Functions:** deployment and retrieval
- **Branching:** branch creation, merging, rebasing (paid plans only)
- **Storage:** bucket and configuration management (disabled by default)

### Install
Authentication is automatic — MCP client redirects to Supabase login. No PAT required anymore.

### Pricing
The MCP itself is free. Branching features require a paid Supabase plan.

### Red Flags
- Pre-1.0 — expect breaking changes between versions
- Supabase-specific — if you need general Postgres, use Postgres MCP Pro instead
- Branching tools only work on paid Supabase plans

---

## 19. Multica

### What It Does
> "The open-source managed agents platform. Turn coding agents into real teammates — assign tasks, track progress, compound skills."
> "Assign issues to an agent like you'd assign to a colleague — they'll pick up the work, write code, report blockers, and update statuses autonomously."
— [github.com/multica-ai/multica](https://github.com/multica-ai/multica)

### Stars: 10.2k
### Latest Version: v0.1.27 (April 12, 2026)
### License: Modified Apache 2.0
- Commercial use allowed internally
- **Cannot** offer Multica as a hosted/SaaS service or embed it in commercial products sold to third parties without a commercial license

### Features (from README)
1. **Agents as Teammates** — assign issues to agents
2. **Autonomous Execution** — agents work independently
3. **Reusable Skills** — "every solution becomes a reusable skill for the whole team"
4. **Unified Runtimes** — supports multiple agent runtimes
5. **Multi-Workspace** — manage multiple projects

### Does "Skills Auto-Capture" Work?
**No explicit "skills auto-capture" mentioned in the README.** The feature is described as "Reusable Skills" — "every solution becomes a reusable skill for the whole team." This implies some form of skill extraction but the README does not describe automatic capture mechanics.

### Red Flags
- Still v0.1.x — very early stage despite 10k+ stars
- Modified Apache license restricts SaaS/hosted use
- "Skills" feature description is vague — no clear documentation of how skill capture actually works

---

## 20. OpenHands

### What It Does
> "🙌 OpenHands: AI-Driven Development"
— [github.com/All-Hands-AI/OpenHands](https://github.com/All-Hands-AI/OpenHands)

A platform for building AI agents that autonomously handle development tasks.

### Stars: 71.1k
### Latest Version: 1.6.0 (March 30, 2026)
### License: MIT (except `enterprise/` directory)
### SWE-Bench Score: **77.6**

### Key Features
1. **Software Agent SDK** — "a composable Python library that contains all of our agentic tech"
2. **CLI Tool** — similar to Claude Code or Codex, supports multiple LLMs
3. **Local GUI** — REST API + React SPA for laptop-based execution
4. **Cloud Deployment** — free tier via GitHub/GitLab sign-in (uses Minimax model)
5. **Enterprise** — self-hosted in customer VPCs, Slack/Jira/Linear integrations, RBAC

### Tech Stack
Python 74.8%, TypeScript 23.4%, 6,478 commits

### Red Flags
- Enterprise directory has a separate (non-MIT) license
- Cloud free tier uses Minimax model (not a frontier model)
- SWE-bench 77.6 is high but not the absolute top

---

## 21. n8n

### What It Does
> "Workflow automation platform that gives technical teams the flexibility of code with the speed of no-code."
— [github.com/n8n-io/n8n](https://github.com/n8n-io/n8n)

### Stars: 184k
### Latest Version: "stable" release dated April 10, 2026 (575 total releases)

### License: **Sustainable Use License v1.0** (NOT MIT, NOT Apache)
Key restrictions quoted directly:
> "You may use or modify the software only for your own internal business purposes or for non-commercial or personal use."
> Free distribution allowed but "free of charge for non-commercial purposes" only.
- Files with `.ee.` in filename require separate n8n Enterprise License

### Integrations: 400+
### MCP Support: **Yes** — GitHub topics include MCP, and the repo references "MCP Registry"
### Templates: 900+ ready-to-use workflow templates
### Tech Stack: TypeScript 91.4%, Vue 7.3%

### Red Flags
- **License is NOT open source** — Sustainable Use License restricts commercial redistribution and hosted use
- Enterprise features (`.ee.` files) require separate license
- "400+ integrations" — real but some are community-maintained with varying quality
- Self-hosting is allowed for internal use but NOT for offering as a service

---

# CORRECTIONS SUMMARY — What We Likely Got Wrong

| # | Tool | What Was Likely Claimed | What's Actually True |
|---|------|------------------------|---------------------|
| 15 | CodeRabbit | "Uses GPT-4" or single model | **Multi-model**: Nemotron + OpenAI o3/o4-mini + GPT-5.2-Codex + Claude Opus/Sonnet 4.5 routed per task |
| 15 | CodeRabbit | Free tier may be limited for private repos | **Free tier covers unlimited private AND public repos** — just rate-limited (4 reviews/hr) |
| 16 | Snyk MCP | May not exist / assumed | **Confirmed: official Snyk MCP exists** with 11 tools, install via `npx -y snyk@latest mcp configure --tool=claude-cli` |
| 17 | PostgreSQL MCP | Single "PostgreSQL MCP" | **Multiple options** — official reference server is basic; Postgres MCP Pro (2.5k stars, MIT) is the real recommendation |
| 18 | Supabase | General Postgres plugin | **Supabase-only** — not a general Postgres client. 40+ tools but all Supabase-specific |
| 19 | Multica | "Skills auto-capture" feature | **Not confirmed in README** — described as "Reusable Skills" but no auto-capture mechanism documented |
| 19 | Multica | Open source (Apache/MIT) | **Modified Apache 2.0** — restricts SaaS/hosted commercial use |
| 20 | OpenHands | License is MIT | **Partially correct** — MIT except `enterprise/` directory which has a separate license |
| 21 | n8n | May have been called "open source" | **NOT open source** — Sustainable Use License restricts commercial use. Fair-code, not FOSS |
| 21 | n8n | "500+ integrations" or similar | **400+ integrations** (verified from README) |
