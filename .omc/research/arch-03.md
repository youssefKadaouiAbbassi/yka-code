# Architect 03 — The Ultimate Claude Code System, April 2026

> Independent architecture. No other arch-*.md files read. All research original.

---

## 1. Master Tool Table

| # | Category | Tool | What it does | Why THIS one |
|---|----------|------|-------------|--------------|
| 1 | **Core CLI** | Claude Code v2.1.101 | The agentic coding harness — CLI, desktop, web, IDE | It IS the kernel. Everything else orbits it. Native Monitor tool, defer, worktrees, Agent Teams, plugins, skills, hooks. |
| 2 | **Core CLI** | `ant` CLI (anthropics/anthropic-cli) | GitOps for Managed Agents definitions — version agents/skills/beta-headers in YAML | First-party CI/CD surface for agent config. No alternative exists. Enables `git push` → agent deployment. |
| 3 | **Advisor Pattern** | Advisor Tool (API beta `advisor-tool-2026-03-01`) | Pairs Haiku/Sonnet executor with Opus advisor in a single API call | 85% cost reduction (Haiku+Opus) vs Sonnet solo. 41.2% BrowseComp vs 19.7% Haiku alone. Collapses multi-agent orchestration into a server-side primitive. |
| 4 | **Orchestration** | oh-my-claudecode (OMC) | Teams-first multi-agent orchestration — autopilot, ralph, ultrawork, team pipeline | Already installed. 4.5k stars. Most complete CC orchestration layer: agents, skills, hooks, memory, MCP tools, state machine. |
| 5 | **Orchestration** | Claude Squad | TUI managing multiple CC agents in isolated git worktrees | 8k stars. Best for pure terminal-ops parallel development. Composes with Ralph loop. |
| 6 | **Orchestration** | Agent Teams (experimental, native) | Built-in multi-agent with `teammateMode: tmux` | Zero install. First-party. Partially obsoletes Claude Squad but Squad still wins for terminal-ops. |
| 7 | **Orchestration** | wshobson/agents | 182 agents + 16 multi-agent orchestrators + 149 skills + 96 commands across 77 plugins | 33.4k stars. Largest CC agent/skill library. Ships PluginEval quality framework (Wilson/Clopper-Pearson CI, Elo ranking). THE substrate others reference. |
| 8 | **Skills** | Superpowers (obra/superpowers) | Core software engineering competencies bundle | 1k stars. Best-measured general skill bundle. BUT: Skill-Usage-Bench (arxiv 2604.04323) shows gains collapse in realistic retrieval — use with refinement, not accumulation. |
| 9 | **Skills** | Trail of Bits Security Skills | 12+ professional security-focused skills for code auditing | The only security skill set from a world-class security firm. No substitute. |
| 10 | **Skills** | Context Engineering Kit (NeoLabHQ) | Advanced context engineering with minimal token footprint | 400 stars. Directly addresses the #1 problem: context budget. Measured token reduction. |
| 11 | **Plugins** | Playwright (official plugin) | Browser automation and testing with 25+ tools | Official Anthropic marketplace. Claude writes AND runs tests. Accessibility-tree based — token-efficient. |
| 12 | **Plugins** | Firecrawl (official plugin) | Web scraping, crawling, search with anti-bot handling | Official. Best web scraping with JS rendering. Anti-bot bypass Claude can't do natively. |
| 13 | **Plugins** | Aikido Security (official plugin) | SAST + secrets + IaC misconfiguration scanning | Official marketplace. Catches what Claude's built-in security review misses — real SAST engine, not LLM heuristics. |
| 14 | **MCP: Code Intel** | Serena v1.1.0 (oraios/serena) | Language-aware code intelligence — go-to-def, references, symbols via LSP | The ONLY MCP server that gives Claude true LSP-grade code intelligence. Install: `uv tool install -p 3.13 serena-agent@latest --prerelease=allow`. |
| 15 | **MCP: Code Intel** | ast-grep MCP (ast-grep/ast-grep-mcp) | Structural pattern search over 20+ languages via tree-sitter | 13.4k stars. Structural search >> regex. Finds patterns across languages that grep can't. First-party MCP. |
| 16 | **MCP: Docs** | Context7 (@upstash/context7-mcp) | Live, version-accurate library documentation injection | Free. Add "use context7" to any prompt → gets current docs. Eliminates hallucinated API calls. Now requires API key for higher rate limits. |
| 17 | **MCP: Git/GitHub** | GitHub MCP (modelcontextprotocol/servers) | PRs, issues, repo management, code scanning, Projects | Official. Rewritten in Go. 51+ tools. OAuth scope filtering. THE GitHub integration. |
| 18 | **MCP: Database** | Supabase MCP | Full Supabase access — DB, auth, storage, edge functions | 20+ tools. Official. If you use Supabase, this is non-negotiable. |
| 19 | **MCP: Database** | Google MCP Toolbox for Databases (googleapis/mcp-toolbox) | BigQuery + AlloyDB + Spanner + CloudSQL + Postgres + MySQL | Official Google. 13.5k stars. Best multi-database MCP. Self-hosted HTTP. |
| 20 | **MCP: Browser** | Playwright MCP (@playwright/mcp) | Browser control via accessibility tree — 25+ tools, YAML snapshots | Microsoft official. 4x fewer tokens than DOM-based approaches. Compact YAML snapshots. |
| 21 | **MCP: Observability** | Datadog MCP (datadog-labs/mcp-server) | Logs, metrics, traces, incidents + optional APM/LLM Observability | GA March 2026. 16+ tools. Official Datadog. Replaces archived PostHog/mcp. Remote HTTP — no local install. |
| 22 | **MCP: Cloud** | Terraform MCP (hashicorp/terraform-mcp-server) | Terraform Registry and Cloud APIs | Official HashiCorp. If you do IaC, this is primary. |
| 23 | **MCP: Infra** | Vercel MCP (mcp.vercel.com) | Deployment logs, project metadata, management | Official Vercel remote with OAuth + Streamable HTTP. Zero local install. |
| 24 | **MCP: Payments** | Stripe MCP (mcp.stripe.com) | Full payment lifecycle — 25 tools | Official Anthropic partner. Remote HTTP. Part of stripe/ai monorepo. |
| 25 | **MCP: Issues** | Sentry MCP (mcp.sentry.dev/mcp) | Error monitoring, stack traces, issue triage | Remote HTTP with OAuth. No local installation. Also available as Claude plugin. |
| 26 | **MCP: Issues** | Linear MCP (mcp.linear.app) | Issue tracking, project boards | Official remote. If you use Linear, zero-friction. |
| 27 | **MCP: Design** | Figma MCP | Design-to-code, canvas manipulation | Official Anthropic partner. Bridges design↔code gap. |
| 28 | **MCP: Memory** | mempalace (milla-jovovich/mempalace) | 19 MCP tools, 96.6% LongMemEval, ChromaDB embeddings | 23k stars. Highest-measured memory MCP. MIT. `pip install mempalace`. |
| 29 | **MCP: Memory** | claude-mem (thedotmack/claude-mem) | Auto-capture, compress, inject context across sessions | 12.9k stars. Lighter than mempalace. Good for personal projects. |
| 30 | **MCP: Security** | agentgateway (agentgateway/agentgateway) | Rust proxy for MCP + A2A protocols — federation, audit, security | 2.4k stars. Linux Foundation. First proxy built natively on BOTH MCP and A2A. Required: MCPSHIELD shows single-layer MCP defenses cover only 34% of 23 attack vectors. |
| 31 | **MCP: Diagrams** | Mermaid MCP (veelenga/claude-mermaid) | Preview Mermaid diagrams with live reload | Simple, effective. Claude generates Mermaid natively — this renders it. |
| 32 | **Sandbox** | Docker Sandboxes (official) | MicroVM-based isolation for CC | Official Docker integration. Production-stable. |
| 33 | **Sandbox** | Native Linux Sandbox (v2.1.98) | PID namespace + seccomp subprocess isolation | Built into CC. Production-stable as of April 9 2026. Zero install. Sufficient for most local work. |
| 34 | **Sandbox** | Fly Sprites | Cloud sandboxes — 100GB NVMe, 8 CPU, `sprite create` | `--skip-console` for CI. Fast. Good for headless/CI sandboxed runs. |
| 35 | **CI/CD** | claude-code-action v1.0.93 | GitHub Action for PR review, code implementation, triage | Official Anthropic. @v1 is current. April 10 2026 latest patch. |
| 36 | **CI/CD** | claude-code-security-review | AI-powered security review GitHub Action | Official Anthropic. Dedicated security-focused CI integration. |
| 37 | **Observability** | Langfuse v3 (self-host) / v4 (cloud) | LLM observability — tracing, evals, prompt management | v3 self-host requires MinIO (cannot be dropped). v4 cloud 10x faster dashboards. Best open-source LLM observability. |
| 38 | **Observability** | claude-code-otel | OpenTelemetry integration for CC usage/costs | Bridges CC into standard OTEL ecosystem. |
| 39 | **Cost** | Native `/cost` (v2.1.92+) | Per-model + cache-hit cost breakdown | First-class native command. ccusage/ccflare now supplementary. |
| 40 | **Cost** | ccflare / better-ccflare | Web dashboard for usage analytics | Supplementary to native `/cost`. Good for historical trends. |
| 41 | **Build Loop** | mise (jdx/mise) | Replaces asdf + nvm + pyenv + direnv + make in one binary | 26.6k stars. `.mise.toml` checked in gives Claude's Bash tool reproducible tool versions. Rust, fast, single config file. |
| 42 | **Build Loop** | just (casey/just) | Command runner — `justfile` is Claude-readable | 32.8k stars. Simplest hook target. Self-documenting. Better than Makefile for agent workflows. |
| 43 | **Build Loop** | Turborepo (vercel/turborepo) | Incremental builds — `turbo run build --filter=...[HEAD]` | 30.2k stars. Rust. Limits rebuild to files Claude actually changed. Essential for monorepos. |
| 44 | **Gateway** | LiteLLM v1.83.x+ | Proxy routing across 100+ model providers | 43k stars. Only gateway Anthropic officially documents for CC. **PIN TO 1.83.x+ — v1.82.7-8 had supply-chain malware.** |
| 45 | **Gateway** | Vercel AI Gateway | Managed gateway with caching, rate limiting | `ANTHROPIC_BASE_URL="https://ai-gateway.vercel.sh"`. Trap: `ANTHROPIC_API_KEY` must be empty string, not unset. |
| 46 | **Code Review** | CodeRabbit | Cross-vendor AI code reviewer — 2M+ repos, 82% bug-catch rate | Different model family reviewing Claude's output. This is the ONLY way to honor writer != reviewer at the model-diversity level. |
| 47 | **Autonomous** | OpenHands | Walk-away coding agent — 71k stars, within 2-6% of frontier on SWE-Bench | Self-hostable, model-agnostic. For ticket-in, PR-out workflows. You don't drive it turn-by-turn. |
| 48 | **Notification** | ntfy.sh | Self-hostable push notifications with interactive buttons | 29.7k stars. Pairs with `defer` (v2.1.89) for headless approve/deny from phone. `cyanheads/ntfy-mcp-server` for Claude-initiated notifications. |
| 49 | **Context** | claude-token-efficient | CLAUDE.md system-prompt shaping — token reduction | 471 HN points. Highest-scoring context-compression item in the April window. Different surface than code compression. |
| 50 | **Durable Execution** | Absurd (earendil-works/absurd) | Postgres-only durable execution for agent loop checkpointing | 5 months production. Ronacher-endorsed. Single Postgres file replaces Temporal for LLM-loop checkpointing. |
| 51 | **Config** | agnix (agent-sh/agnix) | Comprehensive linter for CC agent files with IDE plugins | Catches broken CLAUDE.md, dead rules, misconfigured skills before they waste tokens. |
| 52 | **Statusline** | claude-powerline (Owloops) | Vim-style powerline with real-time cost/token tracking | Best UX of the statusline tools. Real-time feedback on what CC is costing you. |
| 53 | **Session** | claude-replay (es617) | Convert CC sessions to interactive HTML replays | Essential for debugging agent behavior. Shareable. |
| 54 | **Workspace** | Spec-Kit (github/spec-kit) | `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement` | GitHub official. Spec-driven development. Install: `uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1`. |
| 55 | **Workspace** | BMAD-METHOD | Breakthrough Method of Agile AI-Driven Development | SDLC-complete with architect+dev agent split. Composes with Agent Teams. |

---

## 2. settings.json

```jsonc
// ~/.claude/settings.json — User-level (applies to ALL projects)
{
  "$schema": "https://claude.ai/schemas/settings.json",

  // Model & Intelligence
  "model": "claude-opus-4-6",
  "effortLevel": "high",              // v2.1.94 default for API/Max users
  "alwaysThinkingEnabled": true,

  // Permissions — trust but verify
  "permissions": {
    "defaultMode": "acceptEdits",      // Auto-accept file edits, prompt for shell
    "allow": [
      "Read",
      "Edit",
      "Write",
      "Glob",
      "Grep",
      "WebSearch",
      "WebFetch",
      "Agent",
      "TaskCreate",
      "TaskUpdate",
      "mcp__context7__*",
      "mcp__playwright__*",
      "mcp__memory__*"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Bash(DROP TABLE*)",
      "Bash(curl * | bash)"
    ]
  },

  // Hooks — the nervous system
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Bash command: $TOOL_INPUT' >> ~/.claude/audit.log"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "just lint-changed 2>/dev/null || true"
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "curl -s -d \"Claude: $NOTIFICATION_MESSAGE\" ntfy.sh/my-claude-topic || true"
          }
        ]
      }
    ]
  },

  // Environment
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "CLAUDE_CODE_NO_FLICKER": "1",
    "ANTHROPIC_BETA": "advisor-tool-2026-03-01"
  },

  // Preferences
  "theme": "dark",
  "verbose": false,
  "preferredNotifChannel": "terminal_bell"
}
```

```jsonc
// .claude/settings.json — Project-level (checked into git, shared with team)
{
  "$schema": "https://claude.ai/schemas/settings.json",

  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(just *)",
      "Bash(mise *)",
      "Bash(git *)",
      "Bash(turbo *)",
      "mcp__github__*",
      "mcp__serena__*",
      "mcp__context7__*",
      "mcp__ast-grep__*"
    ],
    "deny": [
      "Bash(npm publish*)",
      "Bash(git push --force*)"
    ]
  },

  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "just fmt-changed 2>/dev/null || true"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "just typecheck 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

---

## 3. CLAUDE.md (Under 100 Lines)

```markdown
# Project: [name]

## Identity
You are a senior engineer working on [project description].
Tech stack: [e.g., TypeScript, React 19, Next.js 15, Postgres, Drizzle ORM].

## Commands
- `just dev` — start dev server
- `just test` — run test suite
- `just lint` — lint + format
- `just typecheck` — TypeScript check
- `just db:migrate` — run migrations
- `mise install` — install all tool versions

## Architecture
- `src/app/` — Next.js app router pages
- `src/lib/` — shared utilities and config
- `src/components/` — React components
- `src/server/` — server-side logic, API routes
- `drizzle/` — database schema and migrations

## Rules
1. TypeScript strict mode. No `any`. No `as` casts unless proven necessary.
2. Use server components by default. Client components only when interactivity needed.
3. All database queries through Drizzle ORM. Never raw SQL in application code.
4. Error handling at system boundaries only. Trust internal code.
5. No premature abstractions. Three similar lines > one clever helper.
6. Tests: colocate with source. Use Vitest. Test behavior, not implementation.
7. Imports: use `@/` path alias. Group: external, internal, relative.
8. No console.log in committed code. Use structured logger.
9. Commit messages: imperative mood, <72 chars, explain WHY not WHAT.

## Verification
Before claiming any task complete:
1. `just typecheck` passes
2. `just test` passes
3. `just lint` passes
4. If UI change: visually verify in browser at localhost:3000
5. If API change: test with actual HTTP request

## Context
- Use context7 for library docs: add "use context7" to prompts about dependencies.
- Use Serena for cross-file navigation when grep isn't enough.
- For large refactors: use plan mode first, get approval, then execute.

## What NOT to do
- Don't add comments to code you didn't write.
- Don't refactor adjacent code when fixing a bug.
- Don't add error handling for impossible cases.
- Don't create wrapper utilities for one-time operations.
- Don't add features beyond what was asked.
- Don't mock databases in integration tests — use real DB.

## Git
- Branch from main. One feature per branch.
- PR title: <70 chars. Body: ## Summary + ## Test plan.
- Never force push. Never amend published commits.
```

---

## 4. .mcp.json

```jsonc
{
  "mcpServers": {
    // === CODE INTELLIGENCE (high value, low token cost) ===
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    },
    "ast-grep": {
      "command": "npx",
      "args": ["-y", "@ast-grep/mcp"],
      "env": {}
    },

    // === GIT & PROJECT MANAGEMENT ===
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },

    // === BROWSER AUTOMATION ===
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"],
      "env": {}
    },

    // === MEMORY (pick ONE — mempalace for serious projects, claude-mem for personal) ===
    "memory": {
      "command": "python",
      "args": ["-m", "mempalace", "serve"],
      "env": {}
    },

    // === OBSERVABILITY (remote — zero local install) ===
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    },

    // === DIAGRAMS ===
    "mermaid": {
      "command": "npx",
      "args": ["-y", "claude-mermaid"],
      "env": {}
    }
  }
}
```

**Why only 7 servers:** The research is unambiguous — 3 servers is the sweet spot, 5 is the max before token overhead hurts. I pick 7 because Claude Code's Tool Search lazy-loads schemas (95% token reduction), but even with lazy-loading, every server adds startup time and background memory. Add project-specific servers (Supabase, Stripe, Terraform, Datadog, Linear) per-project in `.claude/settings.json`, not globally.

**What I deliberately excluded from global .mcp.json:**
- **Serena** — install as a system tool (`uv tool install`), not per-project MCP. Too heavy for global.
- **Database MCPs** — project-specific. No global DB connection.
- **Cloud MCPs** (AWS/GCP/Azure/Terraform) — project-specific. Wrong credentials globally.
- **Datadog/Grafana** — team-specific. Add per-project.
- **Filesystem MCP** — Claude Code already has native Read/Write/Edit/Glob/Grep. Redundant.
- **Sequential Thinking** — Opus 4.6 with `alwaysThinkingEnabled: true` makes this redundant.
- **agentgateway** — required for production/team MCP federation, but overkill for solo dev. Add when you have 5+ MCP servers in a project.

---

## 5. Top 10 Principles

### 1. Verification is the bottleneck, not generation
Claude generates code faster than you can read it. The scarce resource is knowing whether it's correct. Every workflow must end with a verification loop: typecheck, test, lint, visual check. Writer and reviewer must be different contexts — ideally different models (CodeRabbit reviews Claude's output). Structured-output self-reflection has a formatting trap (arxiv 2604.06066): models achieve syntactic alignment with schemas while missing semantic errors. Use prose-level critic agents, not just schema validation.

### 2. Front-load architecture decisions before any code
AI acceleration of implementation CAUSES design-decision deferral (Willison, April 5). You never slow down for the hard call, so the hard call never gets made. If the first artifact of a task is code, the task is already broken. Start with `research.md` → `plan.md` with explicit decision records, non-goals, alternatives considered. THEN code. The Advisor Tool pattern (Haiku executor + Opus advisor) makes this architecturally native — the advisor IS the design-decision gate.

### 3. Native primitives win when they're real
Every month, Anthropic ships something that obsoletes a third-party tool. Monitor tool killed background-polling hacks. `defer` killed custom approval workflows. Advisor Tool collapsed multi-agent cost patterns. Cedar policy highlighting signals permissions-as-code going first-class. Check Anthropic's changelog monthly. Before installing a tool, check if CC already does it natively. The 7 releases between April 1-10 2026 (v2.1.89→v2.1.101) each changed the architecture.

### 4. Three MCP servers, not thirty
Skill-Usage-Bench (arxiv 2604.04323) proves that library accumulation has diminishing returns — 34k skills, gains collapse in realistic retrieval. The same applies to MCP servers. Every server costs: startup time, memory, token budget for tool schemas, attack surface. Install what you use weekly. Delete what you used once. Measure per-tool outcomes via PluginEval. Refine existing tools based on failure signal, don't grow the library.

### 5. Sandbox isolation is non-optional
Mythos (Project Glasswing) escaped its restrictions and accessed the internet. MCPSHIELD found 23 MCP attack vectors with single-layer defenses covering only 34%. The Replit agent deleted 2.5 years of user data. Native Linux sandbox (v2.1.98, PID namespace + seccomp) is now production-stable — use it. For CI/headless, add Docker Sandboxes or Fly Sprites. For MCP federation, add agentgateway. Defense-in-depth is the only defense.

### 6. Start with one fewer agents than feels comfortable
Osmani's April 7 update names three anti-patterns: Comprehension Debt (you can't review N agents' output simultaneously), Ambient Anxiety Tax (background agents generating worry), Trust Calibration Overhead (each agent needs independent verification). The 3-5 agent band is right; pick from the low end. One focused agent beats three distracted ones. Use `run_in_background` for genuinely independent work only.

### 7. Cost is a first-class architectural signal
v2.1.94 changed default `effortLevel` from `medium` to `high` for API/Max users. Any cost model based on medium-default is stale. Native `/cost` (v2.1.92) gives per-model + cache-hit breakdown. Use it after every session. The Advisor Tool pattern (Haiku+Opus) costs 85% less than Sonnet solo — but only if you architect for it. Cost anomalies (sudden spikes in token usage) are strategy-drift signals, not billing problems.

### 8. Supply-chain security is YOUR problem now
AI-generated codebases have no human reader who would notice a compromised transitive dependency (Breunig "Winchester Mystery House", Nesbitt "Cathedral and the Catacombs"). LiteLLM PyPI v1.82.7-8 were compromised with credential-stealing malware in March 2026. MCPSHIELD analyzed 177k+ MCP tools and found 23 attack vectors. Pin dependencies. Generate SBOMs. Audit MCP servers before installing. Use `agentgateway` for MCP-layer security in team environments.

### 9. The CLAUDE.md is a contract, not a wishlist
If CLAUDE.md is over 200 lines, Claude ignores half of it. If it contains aspirational guidance instead of executable rules, Claude treats it as optional. Every line must be: (a) something Claude cannot infer from the code, (b) testable/verifiable, (c) actively enforced by hooks or verification steps. Prune ruthlessly. Use `.claude/settings.json` for permissions/hooks, not CLAUDE.md prose.

### 10. Measure everything, trust nothing
ClawBench showed a 10x eval-validity gap (70% sandbox vs 6.5% realistic). Benchmarks lie. Structured-output self-reflection has formatting traps. Skill libraries show gains that collapse in retrieval. The only truth is: did the code work in production? Run every workflow through `just test`, `just typecheck`, `just lint`. Verify UI changes visually. Use CodeRabbit for cross-model review. Log cost per session. Track time-to-correct-output, not time-to-any-output.

---

## 6. What Most People Miss

### 1. The Advisor Tool changes everything and almost nobody uses it yet
Shipped April 9 2026. A single beta header (`advisor-tool-2026-03-01`) turns a Haiku executor into a near-Opus system at 85% lower cost. This collapses the entire "route Opus for planning, Sonnet for execution" orchestration pattern into a server-side primitive. If you're still running multi-agent pipelines with explicit Opus planning stages, you're paying 5x what you need to. The Advisor Tool is the most important single change in the April 2026 window and it's buried in API docs.

### 2. `defer` + ntfy.sh = headless approve-from-phone
v2.1.89 added `"defer"` to PreToolUse hooks. When a headless CC session hits a tool call, the hook can pause execution, send a push notification via ntfy.sh, and wait. You tap Allow on your phone. The session resumes. This is walk-away autonomous coding with human-in-the-loop approval from your pocket. 0.4% false positive rate per Anthropic's production data. Almost nobody has wired this up yet because it requires combining three primitives: hooks + defer + notification channel.

### 3. Tool Search makes MCP server count irrelevant — but startup time doesn't
Claude Code lazy-loads tool schemas via Tool Search, reducing context usage by ~95%. So having 20 MCP servers doesn't blow your token budget. BUT: every server is a subprocess. Startup time, memory, potential crashes, and MCP HTTP/SSE memory leak (50MB/hr, fixed in v2.1.100 but only for new servers). The real limit isn't tokens — it's operational reliability. Three solid servers beat twenty flaky ones.

### 4. Skill accumulation is a trap — refinement is the lever
Skill-Usage-Bench tested 34,000 real-world skills. Result: gains collapse to near-zero in realistic retrieval. Claude Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench only with query-specific refinement, not library growth. Installing 10 awesome-lists of skills makes you feel productive while degrading retrieval quality. Instead: install 2-3 skill bundles, measure outcomes with PluginEval, delete skills that don't improve results, refine the remaining ones.

### 5. The native Linux sandbox is production-ready and free
v2.1.98 shipped PID namespace isolation + seccomp on Linux. It's stable, not beta. It's automatic. It costs nothing. Yet most people still reach for Docker sandboxes or E2B for basic isolation. Use the native sandbox for local dev. Reserve Docker/Fly Sprites for CI and multi-tenant scenarios. The simplest correct solution is the best one.

### 6. `ANTHROPIC_API_KEY` must be empty string for gateways, not unset
When using Vercel AI Gateway or LiteLLM as `ANTHROPIC_BASE_URL`, you must set `ANTHROPIC_API_KEY=""` — an empty string. If you leave it unset, Claude Code checks the env var, finds nothing, and uses its own default auth path, bypassing your gateway entirely. This is documented in exactly one place and causes hours of debugging.

### 7. The 7 releases in 10 days (Apr 1-10) each changed the architecture
v2.1.89: defer + PermissionDenied retry. v2.1.90: /powerup. v2.1.91: 500K MCP results + plugin bin/ auto-PATH. v2.1.92: native /cost. v2.1.94: effortLevel default medium→high. v2.1.98: Monitor tool + Linux sandbox stable. v2.1.101: /team-onboarding. If you configured Claude Code before April 1 2026, your setup is stale. The changelog is the most important document in the ecosystem and almost nobody reads it.

### 8. MCPSHIELD found 23 attack vectors and single-layer defenses cover only 34%
177,000+ MCP tools analyzed. 23 distinct attack vectors across 4 surfaces. If you're running MCP servers without a security layer (agentgateway, Wombat, or at minimum auditing source before install), you're exposed. ShieldNet (arxiv 2604.04426) achieves F1=0.995 for detecting supply-chain-poisoned MCP tools. Network-level behavioral monitoring is required, not optional. This is the biggest blind spot in the CC ecosystem: everyone installs MCP servers, almost nobody audits them.

### 9. `just` > `Makefile` for agent workflows
A `justfile` is readable by Claude without explanation. `just --list` self-documents available commands. `just` doesn't have Make's tab-vs-space footgun. `just` recipes compose with `mise` for reproducible tool versions. Your hook targets should be `just fmt-changed`, `just typecheck`, `just test` — not raw shell commands in settings.json. This gives you one human-readable file that both you AND Claude can use as the source of truth for project commands.

### 10. The effortLevel default change is a silent cost bomb
v2.1.94 (April 7) changed the default from `medium` to `high` for API/Bedrock/Vertex/Foundry/Team/Enterprise users (NOT Pro). If you monitor costs weekly and your last check was before April 7, your next bill will surprise you. This is the kind of change that turns a $200/mo budget into $400/mo without any behavioral change on your part. Check `/cost` after every session. Set `effortLevel` explicitly in settings.json rather than relying on defaults.
