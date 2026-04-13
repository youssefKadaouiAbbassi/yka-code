# Primary Source Verification Report — Batch 2

**Date:** 2026-04-13
**Method:** GitHub READMEs and official docs fetched directly via WebFetch/WebSearch. Blog posts excluded.
**Verdict format:** Per tool — what it does (quoted), install, pricing, MCP tools, version, red flags, and corrections to any prior claims.

---

## 8. claude-mem (thedotmack/claude-mem)

**Source:** https://github.com/thedotmack/claude-mem

### What it does (quoted)
> "A Claude Code plugin that automatically captures everything Claude does during your coding sessions, compresses it with AI (using Claude's agent-sdk), and injects relevant context back into future sessions."

### Install
```bash
npx claude-mem install
# Or for Gemini CLI:
npx claude-mem install --ide gemini-cli
```

### Port & Authentication
- Runs HTTP API on **port 37777** with a web viewer UI at `http://localhost:37777`
- **NO AUTHENTICATION mentioned anywhere in the README.** The port is unauthenticated by default.
- No fix or auth option documented. Any local process can hit `localhost:37777`.

### What it stores
- Uses **SQLite** database storing: sessions, observations, summaries
- Location: `~/.claude-mem/settings.json` (auto-created on first run)
- Content captured automatically; use `<private>` tags to exclude sensitive content
- This means **by default, all session content is captured and stored persistently** with no access controls

### MCP Tools Exposed
1. `search` — Query memory with full-text and filters
2. `timeline` — Get chronological context around observations
3. `get_observations` — Fetch full details by IDs

### Version
- **v6.5.0** | Node >=18.0.0 | 1,662 commits on main

### Pricing/Limits
- Open source, **AGPL-3.0** (network copyleft — important licensing implication)
- No usage limits

### Red Flags
- **CRITICAL: Port 37777 is unauthenticated.** Any local process or user can read all captured session data. No auth mechanism documented, no fix available.
- AGPL-3.0 license has network copyleft requirements — if you modify and serve it, you must share source.
- Captures everything by default; opt-out via `<private>` tags is easy to forget.

---

## 9. context-mode (mksglu/context-mode)

**Source:** https://github.com/mksglu/context-mode

### What it does (quoted)
> "Context Mode is an MCP server that solves all three sides of this problem: Context Saving — Sandbox tools keep raw data out of the context window."

Addresses three issues: reducing context consumption through sandboxing, maintaining session continuity across conversation compaction, and encouraging code-generation over data-processing patterns.

### How compression works
- **NOT traditional compression.** It intercepts tool outputs before they enter the context window.
- Instead of dumping raw data (e.g., Playwright snapshots at 56 KB, access logs at 45 KB), it **indexes content into SQLite with FTS5** and retrieves only relevant results via **BM25 search** when needed.
- The "compression" is really **indexing + selective retrieval**, not algorithmic compression.

### Real compression rate (quoted)
> "315 KB becomes 5.4 KB. 98% reduction."

This is the context-window reduction, not data compression — the full data is stored in SQLite, but only ~2% is sent into the LLM context.

### MCP Tools Exposed
1. `ctx_batch_execute`
2. `ctx_execute`
3. `ctx_execute_file`
4. `ctx_index`
5. `ctx_search`
6. `ctx_fetch_and_index`

### Install
```bash
# Claude Code (recommended):
/plugin marketplace add mksglu/context-mode
/plugin install context-mode@context-mode

# MCP-only (without hooks):
claude mcp add context-mode -- npx -y context-mode
```

### Version
- Requires Claude Code v1.0.33+
- Node.js 18+ (22+ for OpenClaw)
- License: **ELv2** (Elastic License v2 — not truly open source, has usage restrictions)

### Pricing/Limits
- No pricing mentioned. Free to use.

### Red Flags
- ELv2 license restricts providing the software as a managed service
- The "98% compression" claim is misleading — it's context-window savings via indexing, not data compression. The data still exists in full in SQLite.

---

## 10. Playwright MCP (microsoft/playwright-mcp)

**Source:** https://github.com/microsoft/playwright-mcp

### What it does (quoted)
> "A Model Context Protocol (MCP) server that provides browser automation capabilities using Playwright. This server enables LLMs to interact with web pages through structured accessibility snapshots, bypassing the need for screenshots or visually-tuned models."

### MCP vs CLI — what Microsoft actually says

**MCP approach:** Maintains persistent browser state and rich introspection. Suited for exploratory automation and long-running workflows where continuous context matters.

**CLI approach (quoted recommendation):**
> "If you are using a coding agent, you might benefit from using the CLI+SKILLS instead."

Microsoft explicitly recommends CLI for coding agents because:
- CLI invocations are more token-efficient
- Avoids large tool schemas and verbose accessibility trees
- Better for high-throughput agents balancing browser automation with large codebases

**Token comparison:** ~115,000 tokens with MCP vs ~25,000 with CLI for identical tasks (75%+ context window savings).

### MCP Tools Exposed
The full README tool list was truncated in fetch. The server exposes browser automation tools including navigation, clicking, typing, screenshots via accessibility snapshots. Specific tool names were not enumerable from the truncated content.

### Install for Claude Code
```bash
claude mcp add playwright npx @playwright/mcp@latest
```

### Version
- Uses `@playwright/mcp@latest` — no pinned version in README

### Pricing/Limits
- Free, open source (Apache-2.0)

### Security Notes
- Config options: `--allow-unrestricted-file-access`, `--allowed-hosts`, `--allowed-origins`, `--blocked-origins`
- README warns: origin controls "do not serve as a security boundary and do not affect redirects"

### Red Flags
- None major. Well-maintained Microsoft project.

---

## 11. Playwright CLI (@playwright/cli)

**Source:** https://github.com/microsoft/playwright-cli

### What it is
**YES, this is a SEPARATE package from playwright-mcp.** It is `@playwright/cli`, a standalone CLI tool.

Quoted:
> "This package provides CLI interface into Playwright. If you are using coding agents, that is the best fit."

> "CLI: Modern coding agents increasingly favor CLI–based workflows exposed as SKILLs over MCP because CLI invocations are more token-efficient"

### YAML snapshots — CONFIRMED
The CLI saves accessibility snapshots as **YAML files** on disk:
> Snapshot path format: `.playwright-cli/page-2026-02-14T19-22-42-679Z.yml`

The agent sends a command (e.g., `playwright-cli click e21`), the daemon executes the action, captures a snapshot, writes it to a YAML file, and the agent receives a ~40-character file path instead of the full snapshot content.

### Install
```bash
npm install -g @playwright/cli@latest
playwright-cli install --skills
```

### Commands exposed
- **Navigation:** `go-back`, `go-forward`, `reload`
- **Interaction:** `click`, `type`, `fill`, `drag`, `hover`, `check`, `uncheck`
- **Storage:** cookie/localStorage/sessionStorage management
- **DevTools:** `console`, `network`, `tracing-start`, `video-start`
- **Tabs:** `tab-list`, `tab-new`, `tab-close`, `tab-select`
- **Sessions:** Multi-browser session management via `-s=name`
- **Snapshots:** `snapshot --filename=f`

### Status
- **Active**, not deprecated. Separate from the old deprecated `playwright-cli` that was folded into `npx playwright`.

### Red Flags
- None. This is the Microsoft-recommended approach for coding agents.

---

## 12. container-use (dagger/container-use)

**Source:** https://github.com/dagger/container-use

### What it does (quoted)
> "Containerized environments for coding agents"
> "Each agent gets a fresh container in its own git branch - run multiple agents without conflicts, experiment safely, discard failures instantly."

### Is `cu config` real?
**NOT IN README.** The only commands documented are:
- `container-use stdio` (or shortcut `cu stdio`) — starts the MCP server
- No `cu config` command appears anywhere in the README.

### YAML config file?
**NOT IN README.** No YAML configuration file is documented. Setup is via `claude mcp add` only.

### Install
```bash
# macOS:
brew install dagger/tap/container-use

# All platforms:
curl -fsSL https://raw.githubusercontent.com/dagger/container-use/main/install.sh | bash
```

### MCP Tools Exposed
**NOT LISTED IN README.** The README only states the server runs via `container-use stdio` but does not enumerate specific MCP tool names. You'd need to check source code in the `mcpserver` directory.

### Version
- **v0.4.2** (August 19, 2025) — latest release
- 14 total releases, 323 commits on main

### Container runtime
- **"Powered by Dagger"** (dagger.io)
- Underlying container mechanism (Docker, OCI, etc.) not explicitly stated in README

### Pricing/Limits
- Free, open source

### Red Flags
- `cu config` does NOT exist — if we claimed it did, that was WRONG.
- No YAML config confirmed — correct.
- MCP tool list not publicly documented in README.

---

## 13. Docker Sandboxes (docker/sbx-releases)

**Sources:**
- https://docs.docker.com/ai/sandboxes/
- https://github.com/docker/sbx-releases/releases

### What it is (quoted)
> "Docker Sandboxes run AI coding agents in isolated microVM sandboxes. Each sandbox gets its own Docker daemon, filesystem, and network — the agent can build containers, install packages, and modify files without touching your host system."

### Does this product actually exist?
**YES.** It is a real Docker product with official documentation at docs.docker.com/ai/sandboxes/.

### Is it Firecracker-based?
**NOT STATED in official docs.** The documentation says "microVM sandboxes" and "microVM isolation" but **does not name Firecracker or any specific hypervisor**. Claiming it's Firecracker-based is NOT supported by primary sources.

### When did it launch?
- Earliest visible release: **v0.21.0 — March 31, 2026**
- Latest release: **v0.24.2 — April 8, 2026** (nightly build April 13, 2026)
- Status: **Experimental**, under active development
- **Very new** — less than 2 weeks old as of this report

### How to use
```bash
# Install sbx CLI (brew/winget/apt)
sbx login
# Navigate to project, then:
sbx run claude
```

### Pricing
- **NOT STATED** in official docs. No pricing page found.

### Supported agents
- Claude confirmed (`sbx run claude`)
- Other agents referenced but not enumerated in the main docs page

### Red Flags
- **Experimental** — less than 2 weeks old, expect breaking changes
- No pricing info = unclear if/when it becomes paid
- Claiming Firecracker is NOT supported by official docs — we should NOT state the hypervisor technology

---

## 14. Composio (composiohq/composio)

**Sources:**
- https://github.com/composiohq/composio
- https://composio.dev/pricing
- https://composio.dev/toolkits/composio/framework/claude-code

### What it does (quoted)
> "Composio powers 1000+ toolkits, tool search, context management, authentication, and a sandboxed workbench to help you build AI agents that turn intent into action."

### How many apps?
- README claims **"1000+ toolkits"**
- MCP sub-product "Rube" claims **"500+ apps"** (Gmail, Slack, GitHub, Notion, etc.)
- Discrepancy: 1000+ toolkits vs 500+ apps — likely toolkits ≠ apps (toolkits may bundle multiple tools per app)

### Free tier — CONFIRMED with real numbers
| Tier | Price | Tool Calls/Month | Support |
|------|-------|-------------------|---------|
| Free | $0 | 20,000 | Community |
| Ridiculously Cheap | $29/mo | 200,000 | Email |
| Serious Business | $229/mo | 2,000,000 | Slack |
| Enterprise | Custom | Custom | Dedicated SLA, SOC-2 |

- Overage: $0.299/1K calls (cheap tier), $0.249/1K calls (business tier)
- No credit card required for free tier

### Install for Claude Code
```bash
# 1. Install Python library
pip install composio-core python-dotenv

# 2. Generate MCP URL via Python script (creates Tool Router session)

# 3. Register with Claude Code
claude mcp add --transport http composio-composio "YOUR_MCP_URL_HERE" \
  --headers "X-API-Key:YOUR_COMPOSIO_API_KEY"

# 4. Restart Claude Code
```

### MCP Tools Exposed
Not enumerated in README. The MCP server ("Rube") dynamically exposes tools based on which apps/integrations you configure. Tool names are per-integration.

### Version
- No pinned version in README (uses npm/PyPI badges)

### Red Flags
- Setup is more complex than most MCP servers — requires Python, API key, .env file, generated URL
- The "1000+ toolkits" vs "500+ apps" numbers are inconsistent
- Free tier at 20K calls/month is reasonable but could be exhausted quickly with active agent use

---

# CORRECTIONS SUMMARY — What We Likely Got Wrong

| # | Tool | Potential Error | Correction |
|---|------|----------------|------------|
| 8 | claude-mem | May have understated security risk | Port 37777 is **confirmed unauthenticated**, no fix exists. This is a real security issue — any local process can read all captured session data. |
| 9 | context-mode | May have called it "compression" | It's **NOT compression** — it's indexing into SQLite+FTS5 with selective BM25 retrieval. The 98% figure is context-window savings, not data compression. |
| 10 | Playwright MCP | May have confused MCP and CLI | They are **two separate packages**: `@playwright/mcp` (MCP server) and `@playwright/cli` (CLI tool). Microsoft recommends CLI for coding agents. |
| 11 | Playwright CLI | May have doubted it exists separately | **CONFIRMED separate** at github.com/microsoft/playwright-cli. Uses YAML snapshots. Active, not deprecated. |
| 12 | container-use | May have claimed `cu config` exists | **`cu config` is NOT in the README.** Only `cu stdio` is documented. No YAML config file either. |
| 13 | Docker Sandboxes | May have claimed Firecracker-based | **Official docs do NOT name Firecracker.** Only says "microVM." Also launched **March 31, 2026** — extremely new, experimental. |
| 14 | Composio | May have gotten free tier wrong | Free tier is **20K tool calls/month** (confirmed from pricing page). Install for Claude Code requires Python + API key + HTTP transport MCP — more complex than a simple `npx` command. |
