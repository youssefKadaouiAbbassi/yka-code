# Architect 9 — The Closed-Loop Claude Code System

**Thesis: The ultimate Claude Code system is not a tool collection — it is a closed-loop control system where every output becomes an input to a corrective feedback cycle. The configuration is the controller; the tools are the plant; the hooks are the sensors; and the human is the setpoint.**

*Compiled 2026-04-12. Independent research by Architect 9.*

---

## 1. The Complete Tool Table

### Tier 0 — The Kernel (Non-Negotiable Foundation)

| # | Category | Primary Tool | Install / Config | Cost | Why Primary | Alternates |
|---|----------|-------------|-----------------|------|-------------|------------|
| 1 | **CLI Harness** | Claude Code v2.1.101 | `curl -fsSL https://claude.ai/install.sh \| bash` | Max $200/mo | The runtime. Everything else is a peripheral. v2.1.101 ships Monitor tool, Linux PID namespace sandbox, Cedar policy syntax, `/team-onboarding`. | Gemini CLI (free 60 req/min), OpenCode (OSS), Aider (multi-model), Goose (Rust, extensible) |
| 2 | **Subscription** | Claude Max $200/mo | claude.ai billing | $200/mo | Only plan that gives unlimited Opus 4.6 for interactive use. API billing for CI/headless (subscription enforcement event Apr 4 2026). | Max $100 (5x less Opus), Pro $20 (limited), API pay-per-token |
| 3 | **Model** | Opus 4.6 (planning/review) + Sonnet 4.6 (execution) | `model: "claude-sonnet-4-6"` in settings.json, Opus via `/model` or Advisor Tool | Included in Max | Advisor Tool (Apr 9 2026): Haiku+Opus scored 41.2% vs 19.7% solo on BrowseComp at 85% lower cost. Sonnet within 1.2pts of Opus on SWE-bench at 5x lower cost. | Haiku 4.5 (quick lookups, status lines) |
| 4 | **Effort Level** | `high` (new default since v2.1.94, Apr 7) | `CLAUDE_CODE_EFFORT_LEVEL=high` | More tokens | Changed from `medium` → `high` for API/Teams/Enterprise. Any cost model based on medium-default is stale. Override to `medium` for routine tasks. | `low` for bulk file ops, `medium` for standard |

### Tier 1 — The Feedback Sensors (Hooks, Observability, Cost)

| # | Category | Primary Tool | Install / Config | Cost | Why Primary | Alternates |
|---|----------|-------------|-----------------|------|-------------|------------|
| 5 | **Hooks Engine** | Native CC Hooks (26 events, 12 blocking) | `settings.json → hooks{}` | Free | Deterministic automation at lifecycle boundaries. PreToolUse is the ONLY hook that blocks actions. v2.1.89 added `"defer"` for headless-pause, `PermissionDenied.retry`. 4 handler types: command, http, prompt, agent. | Custom MCP tool-call interceptors |
| 6 | **Observability** | claude-code-otel + Langfuse v3 (self-host) | `CLAUDE_CODE_ENABLE_TELEMETRY=1` + `docker compose up` (Langfuse requires MinIO) | Free (self-host) | OTEL gives spans/traces. Langfuse v3 gives dashboards. v4 cloud preview is 10x faster but self-host path TBD. `ENHANCED_TELEMETRY_BETA` gates distributed-traces beta only — don't enable unless intentional. | Datadog MCP (GA Mar 2026, 16+ tools, `claude mcp add --transport http datadog https://mcp.datadoghq.com/...`), agents-observe (lightweight team dashboard), W&B Weave auto-tracing |
| 7 | **Cost Tracking** | Native `/cost` (v2.1.92+) + ccusage | `/cost` built-in; `npm i -g ccusage` | Free | v2.1.92 added native per-model + cache-hit `/cost` breakdown. ccusage for historical analysis. ccflare/better-ccflare for web UI dashboards. | Claude Code Usage Monitor (real-time terminal), Vibe-Log (session analysis) |
| 8 | **Notification / Defer Channel** | ntfy.sh + Telegram Bot | `claude-ntfy-hook` for ntfy; Telegram via CC Channels plugin | Free | `"defer"` permissionDecision (v2.1.89) needs a user-facing surface. ntfy.sh (29.7k stars, self-hostable) with interactive Allow/Deny buttons. Scout C confirmed `defer` at 0.4% FP rate in production. | Slack webhooks + Block Kit, trigger.dev (durable approval workflows) |

### Tier 2 — The Control Surfaces (Context, Memory, Skills)

| # | Category | Primary Tool | Install / Config | Cost | Why Primary | Alternates |
|---|----------|-------------|-----------------|------|-------------|------------|
| 9 | **Context Engineering** | CLAUDE.md (< 200 lines) + path-scoped rules | `.claude/CLAUDE.md` + `.claude/rules/*.md` with YAML frontmatter | Free | Single highest-leverage input. /init generates starter. Path scoping keeps context lean. Don't include code snippets — use `file:line` references. 40% token reduction measured from well-structured CLAUDE.md. | claude-token-efficient (471 HN pts, CLAUDE.md system-prompt shaping), ContextKit (4-phase framework) |
| 10 | **Memory** | Native auto-memory (`~/.claude/projects/*/memory/`) + claude-mem | Built-in; `npm i -g claude-mem` for cross-session | Free | Native memory has frontmatter types (user, feedback, project, reference) with MEMORY.md index. claude-mem adds auto-capture + compress + inject. | mempalace (23k stars, 96.6% LongMemEval, 19 MCP tools), ClawMem (hooks + MCP + hybrid RAG), Hippo (biologically-inspired, zero deps) |
| 11 | **Skills Framework** | Anthropic Skills (`/skill`) + Superpowers + Trail of Bits | `/skill install`; `uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1` for Spec-Kit | Free | **CAVEAT (arxiv 2604.04323):** Skill-library gains collapse to near-zero in realistic retrieval. Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench 2.0 only with query-specific refinement, NOT accumulation. Measure per-skill outcomes via PluginEval. Delete skills that don't improve outcomes. | OpenClaw registry (13,729+ skills), wshobson/agents (33.4k stars, 182 agents, PluginEval framework), VoltAgent awesome-agent-skills (1,000+) |
| 12 | **Plugin System** | Native CC Plugins (`/plugin install`) | `plugin.json` manifest at `<root>/.claude-plugin/plugin.json`; v2.1.91 added `bin/` auto-PATH + `disableSkillShellExecution` | Free | 101 official marketplace plugins (33 Anthropic + 68 partner). Plugins bundle skills + MCP servers + commands. `bin/` directory (v2.1.91) lets plugins ship executables. | Community plugin repos (ComposioHQ, ccplugins, GiladShoham awesome-claude-plugins) |

### Tier 3 — The Actuators (MCP Servers — What Claude Can Touch)

| # | Category | Primary Tool | Install / Config | Cost | Why Primary | Alternates |
|---|----------|-------------|-----------------|------|-------------|------------|
| 13 | **Code Intelligence** | Serena v1.1.0 (Apr 11 2026) | `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` (**NOT** the deprecated uvx command) | Free | LSP-grade code intelligence via MCP. 9a pattern: MCP-side index. | ast-grep MCP (13.4k stars, structural-pattern search 20+ langs), probe (537 stars, ripgrep + tree-sitter + MCP), CodeGraphContext |
| 14 | **GitHub** | github/github-mcp-server | `claude mcp add github -- npx -y @anthropic-ai/github-mcp-server` | Free | 51+ tools (grown past 51, rewritten in Go). PRs, issues, code scanning, `get_me`, OAuth scope filtering. | GitHub plugin (official marketplace) |
| 15 | **Database** | PostgreSQL MCP + Supabase MCP | `claude mcp add postgres -- npx -y @anthropic-ai/postgres-mcp-server` | Free | Direct DB access. Supabase adds auth/storage/edge. Google MCP Toolbox (v0.30.0, BigQuery+AlloyDB+Spanner+CloudSQL+Postgres+MySQL) for enterprise GCP. | Prisma CLI (built-in v6.6+), Drizzle MCP, Neon MCP |
| 16 | **Web Search** | Brave Search MCP | `claude mcp add brave-search -- npx -y @anthropic-ai/brave-search-mcp-server` | Free tier | Privacy-focused. Pairs with Firecrawl for deep scraping. | Perplexity Sonar MCP, Context7 MCP (now requires `--api-key` from context7.com/dashboard) |
| 17 | **Web Scraping** | Firecrawl MCP/Plugin | `claude mcp add firecrawl -- npx -y @anthropic-ai/firecrawl-mcp-server` or official CC plugin | Free tier | Anti-bot handling, crawl/scrape/search/map. Official CC plugin available. | markdownify-mcp, Bright Data MCP |
| 18 | **Browser Automation** | Playwright MCP | `claude mcp add playwright -- npx -y @anthropic-ai/playwright-mcp-server` | Free | 25+ browser control tools via accessibility tree. Playwright CLI (2026): compact YAML snapshots, 4x fewer tokens. | Claude in Chrome (MCP), Puppeteer (deprecated) |
| 19 | **Diagrams** | Mermaid MCP | `claude mcp add mermaid -- npx -y @anthropic-ai/mermaid-mcp-server` | Free | Preview Mermaid diagrams with live reload. Mermaid Chart official connector validates diagrams. | draw.io MCP, Figma MCP (official, design-to-code) |
| 20 | **File Conversion** | MarkItDown (skill) | Skill install | Free | 15+ file formats to Markdown (Office, PDF, media). | Marker (PDF/EPUB/Office to Markdown/HTML/JSON), md-to-pdf-mcp |
| 21 | **Communication** | Slack MCP + Google Workspace MCP | Via Composio or registry | Free | Slack for team messaging. Google Workspace MCP covers Gmail, Calendar, Docs, Sheets, Slides, Drive, Tasks. | MS Teams MCP, Discord/Telegram via CC Channels |
| 22 | **Deployment** | Vercel MCP + Cloudflare MCP | `claude mcp add vercel -- npx -y @vercel/mcp` (OAuth + Streamable HTTP) | Free | Vercel for Next.js/React. Cloudflare for Workers/Pages (2,500 API endpoints compressed into ~1k tokens). | Netlify MCP, AWS Lambda via AWS MCP |
| 23 | **Payments** | Stripe MCP | Remote HTTP at `mcp.stripe.com`, 25 tools | Free | Official Anthropic partner. Full payment lifecycle. | Shopify (4 MCP servers: Dev, Storefront, Customer, Checkout) |
| 24 | **Observability (External)** | Datadog MCP (GA Mar 2026) | `claude mcp add --transport http datadog https://mcp.datadoghq.com/api/unstable/mcp-server/mcp` | Datadog plan | 16+ tools across logs/metrics/traces/incidents + optional APM/LLM Observability. Fills gap left by PostHog/mcp archival (Jan 19 2026). | Grafana MCP (skill), GCP Observability MCP |
| 25 | **Security** | Aikido Security (CC plugin) + Snyk skill | Official plugin install | Free tier | SAST + secrets + IaC scanning. Claude Code native security scanning found 500+ vulns with Opus 4.6. Trail of Bits skills for professional auditing. | claude-code-security-review (GitHub Action), Security Scanner Plugin |
| 26 | **Accessibility** | a11ymcp | `claude mcp add a11y -- npx -y @ronantakizawa/a11ymcp` | Free | 24 accessibility scanning tools, WCAG 2.0-2.2. | accessibility-agents (11 WCAG 2.2 AA specialists), claude-a11y-skill |
| 27 | **Sequential Thinking** | Sequential Thinking MCP | `claude mcp add thinking -- npx -y @anthropic-ai/sequential-thinking-mcp-server` | Free | Step-by-step reasoning tool. Useful for complex problem decomposition. | Advisor Tool (server-side, replaces need for external reasoning MCP in many cases) |
| 28 | **Project Management** | Linear MCP | Remote HTTP at `mcp.linear.app` | Linear plan | Official remote. Issue tracking + project boards. | Jira MCP (Atlassian Rovo), Notion MCP |

### Tier 4 — The Orchestration Layer (Multi-Agent, CI/CD, Sandbox)

| # | Category | Primary Tool | Install / Config | Cost | Why Primary | Alternates |
|---|----------|-------------|-----------------|------|-------------|------------|
| 29 | **Multi-Agent** | Native Agent Teams (experimental) | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in settings.json, requires v2.1.32+ | Free | 2-16 coordinated sessions. Shared task list, peer messaging, file locking. Best for: research/review, new modules, debugging competing hypotheses, cross-layer coordination. | oh-my-claudecode (4.5k stars, teams-first orchestration), Claude Squad (8k stars, TUI for worktree agents), wshobson/agents (33.4k stars, 182 agents + 16 orchestrators), ralph-orchestrator (2.5k stars) |
| 30 | **Walk-Away Agents** | Claude Managed Agents | `managed-agents-2026-04-01` beta header; `ant` CLI for GitOps definitions | $0.08/session-hr + tokens | Fully managed: sandboxing, tools, SSE streaming. "Stateless Harness + Durable Event Sourcing" architecture. Give it a ticket, come back later. | OpenHands (71k stars, MIT, self-hostable, within 2-6% of frontier), Devin ($20/mo, multi-session state), Google Jules (free 15/day) |
| 31 | **CI/CD** | claude-code-action v1.0.93 | GitHub Actions: `uses: anthropics/claude-code-action@v1` | API tokens | Official GitHub Action for PR review, code implementation, triage. `ant` CLI (Apr 8 2026) enables GitOps for Managed Agents definitions. **API billing required for CI** — subscription plans prohibit scripted use (enforcement event Apr 4 2026). | claude-code-security-review (security-focused Action), HTTP Hooks CI/CD |
| 32 | **Sandbox** | Native Linux sandbox (v2.1.98, production-stable) | Built-in; PID namespace + seccomp-bpf | Free | Now production-ready (was beta). Kernel namespace isolation (mount, network, PID, IPC). ~2-3% CPU overhead, <10ms startup. Cedar policy syntax highlighting (v2.1.100). | Docker Sandboxes (official, microVM), Container Use/Dagger (dev environments), E2B (15M sessions/mo), Fly Sprites (`sprite create --skip-console` for CI) |
| 33 | **MCP Security** | agentgateway (Linux Foundation, 2.4k stars, Rust) | Self-host | Free | First proxy built on BOTH MCP and A2A protocols. v3 had ZERO slots for governing the MCP layer itself. OWASP MCP Top 10 exists but as prose, not tooling. MCPSHIELD: single-layer defenses cover only 34%, integrated reaches 91%. ShieldNet: F1=0.995 at 0.8% FP. | IBM/mcp-context-forge (3.6k stars, federates MCP+A2A+REST+gRPC), microsoft/mcp-gateway (K8s-native), Wombat (rwxd proxy) |
| 34 | **LLM Gateway** | LiteLLM (43k stars, MIT) | `ANTHROPIC_BASE_URL=http://0.0.0.0:4000` — **PIN TO v1.83.x+** (v1.82.7-8 were compromised with credential-stealing malware, March 2026) | Free | Only gateway Anthropic officially documents for CC. Routes across 100+ providers. Team governance: budget caps, audit log via Portkey (11.3k stars). | LM Studio (local `/v1/messages` compat), Ollama (169k stars, native `/anthropic` compat), OpenRouter (200+ cloud models), Morphic LLM (cost optimization) |
| 35 | **Cross-Vendor Review** | CodeRabbit | BYOK config | Free tier | 2M+ repos, 13M+ PRs, 82% bug-catch rate. Different model family reviewing Claude's output — the ONLY version of "writer != reviewer" that honors the principle at the model-diversity level. | Greptile ($30/user/mo, full codebase graph), GitHub Copilot Code Review ($10/mo, CodeQL), kodustech/kodus-ai (OSS, self-hosted) |
| 36 | **Durable Execution** | Absurd (`earendil-works/absurd`) | Postgres-only, TS/Python/Go SDKs, `absurdctl` CLI | Free | 5 months production. Single Postgres file replaces Temporal for LLM-loop checkpointing (Armin Ronacher, April 4). | Temporal (enterprise), trigger.dev (event-driven), inngest (durable functions) |

### Tier 5 — The Inner Loop (Build, Workstation, Design)

| # | Category | Primary Tool | Install / Config | Cost | Why Primary | Alternates |
|---|----------|-------------|-----------------|------|-------------|------------|
| 37 | **Build Tooling** | mise (26.6k stars) + just (32.8k stars) | `curl https://mise.jdx.dev/install.sh \| sh`; `cargo install just` | Free | mise replaces asdf+nvm+pyenv+direnv+make in one binary. `.mise.toml` gives Claude's Bash tool reproducible tool versions. just: simplest hook target, `justfile` is Claude-readable. | Turborepo (30.2k stars, `turbo run build --filter=...[HEAD]`), Nx (28.5k stars, large monorepos), watchexec (file-watch trigger) |
| 38 | **Dev Environment** | devenv 2.0 (6.7k stars, Mar 5 2026) | `cachix/devenv`, Rust C-FFI replaces Nix subprocess | Free | <100ms activation. Materially changes inner-loop timing vs Nix. | Docker Dev Environments, Daytona (self-hosted), Gitpod |
| 39 | **Design** | Figma MCP (official) + VoltAgent awesome-design-md | Figma MCP via official plugin; awesome-design-md for 55+ brand DESIGN.md files | Free | Official Anthropic partner for design-to-code. DESIGN.md files shape Claude's UI generation toward brand consistency. | v0 (Vercel), Lovable, Bolt |
| 40 | **Context Compression** | /compact (native) + /clear | Built-in | Free | Auto-compaction summarizes conversation at context limits. 60-80% shorter. Use /clear when switching tasks, /compact when context gets long. Prompt caching reduces repeated context cost by 90%. | caveman (compression), Squeez, claude-token-efficient |
| 41 | **Session Management** | Claude Squad (8k stars) | `go install github.com/smtg-ai/claude-squad@latest` | Free | TUI for managing multiple AI agents in isolated git worktrees. Still wins for pure terminal-ops workflow even though Agent Teams overlaps. | cc-sessions, claude-replay (interactive HTML replays), cclogviewer |
| 42 | **Status Line** | claude-powerline | `cargo install claude-powerline` | Free | Vim-style powerline with real-time tracking. Context window usage %, color-coded (green <40%, yellow 40-59%, red 60%+). | CCometixLine (Rust, Git integration), claudia-statusline (persistent stats + progress bars) |
| 43 | **Config Management** | agnix | `npm i -g agnix` | Free | Comprehensive linter for CC agent files with IDE plugins. Catches dead rules, stale paths, format errors. | claude-rules-doctor (dead rules detection), ClaudeCTX (config switching), ccexp (interactive config discovery) |
| 44 | **Knowledge Wiki** | Karpathy LLM Wiki pattern + Obsidian | `qmd` BM25/vector local MCP search, `Ar9av/obsidian-wiki` | Free | Refinement-based approach aligned with Skill-Usage-Bench finding. Compiled knowledge base via Obsidian Markdown. | Context7 MCP (now needs API key), Spec-Kit |
| 45 | **Voice** | VoiceMode MCP | `claude mcp add voicemode -- npx -y @mbailey/voicemode` | Free | Natural voice conversations for CC. Useful for hands-free sessions. | stt-mcp-server-linux (push-to-talk) |

---

## 2. settings.json — The Complete Controller Configuration

```jsonc
{
  // ═══════════════════════════════════════════════════════
  // MODEL & REASONING — The Setpoint
  // ═══════════════════════════════════════════════════════
  "model": "claude-sonnet-4-6",
  // NOT "defaultModel" — verified verbatim trap
  // Sonnet for execution. Switch to Opus via /model for planning/review.
  // Advisor Tool (beta header advisor-tool-2026-03-01) collapses the
  // Opus-planning/Sonnet-execution pattern into a server-side primitive.

  // ═══════════════════════════════════════════════════════
  // PERMISSIONS — The Safety Envelope
  // ═══════════════════════════════════════════════════════
  "permissions": {
    "defaultMode": "acceptEdits",
    // NOT "autoAccept" — verified verbatim trap
    // acceptEdits: Claude can edit files without asking, but
    // Bash commands still require approval. The right balance
    // between flow and safety for interactive use.

    "allow": [
      // Tools Claude can use without asking
      "Read",
      "Write",
      "Edit",
      "Glob",
      "Grep",
      "Bash(npm test*)",
      "Bash(npm run*)",
      "Bash(npx prettier*)",
      "Bash(npx eslint*)",
      "Bash(git status)",
      "Bash(git diff*)",
      "Bash(git log*)",
      "Bash(git branch*)",
      "Bash(just *)",
      "Bash(mise *)",
      "Bash(turbo run *)",
      "Bash(cargo test*)",
      "Bash(cargo clippy*)",
      "Bash(python -m pytest*)",
      "Bash(uv run*)",
      "Bash(bun test*)",
      "Bash(bun run*)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(head *)",
      "Bash(tail *)",
      "Bash(wc *)",
      "Bash(find *)",
      "Bash(grep *)",
      "Bash(rg *)",
      "Bash(which *)",
      "Bash(echo *)",
      "Bash(date)",
      "Bash(pwd)",
      "Bash(env)",
      "mcp__github__*",
      "mcp__brave-search__*",
      "mcp__filesystem__*",
      "mcp__memory__*",
      "mcp__playwright__*",
      "mcp__context7__*",
      "mcp__serena__*",
      "mcp__thinking__*"
    ],
    "deny": [
      // Deny is checked FIRST — these are hard blocks
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(chmod 777*)",
      "Bash(curl * | bash*)",
      "Bash(wget * | bash*)",
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Bash(docker rm*)",
      "Bash(docker rmi*)",
      "Bash(kill -9*)",
      "Bash(pkill*)",
      "Bash(shutdown*)",
      "Bash(reboot*)"
    ]
  },

  // ═══════════════════════════════════════════════════════
  // HOOKS — The Sensor Array
  // 26 events, 12 blocking (exit code 2 blocks PreToolUse,
  // UserPromptSubmit, PermissionRequest, WorktreeCreate,
  // Stop, SubagentStop, TeammateIdle, TaskCreated,
  // TaskCompleted, ConfigChange, Elicitation, ElicitationResult)
  // 4 handler types: command, http, prompt, agent
  // ═══════════════════════════════════════════════════════
  "hooks": {
    // Gate: Prevent destructive file operations on protected paths
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const f=JSON.parse(process.argv[1]).tool_input?.file_path||''; if(/\\.(env|pem|key|crt)$/.test(f)||/node_modules|vendor|\\.git\\//.test(f)){process.exit(2)}\"",
            "timeout": 3000
          }
        ]
      },
      // Gate: Lint-on-save for TypeScript files
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const f=JSON.parse(process.argv[1]).tool_input?.file_path||''; if(/\\.tsx?$/.test(f)){const{execSync}=require('child_process'); try{execSync('npx tsc --noEmit 2>&1',{timeout:15000})}catch(e){console.error(e.stdout?.toString()); process.exit(2)}}\"",
            "timeout": 20000
          }
        ]
      }
    ],
    // Sensor: Log every tool use for observability
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"$(date -Iseconds) | $CLAUDE_SESSION_ID | $(echo $1 | jq -r '.tool_name')\" >> ~/.claude/logs/tool-audit.log",
            "timeout": 2000
          }
        ]
      }
    ],
    // Notification: Ping phone when Claude stops (for walk-away sessions)
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "curl -s -d \"Claude finished: $(echo $1 | jq -r '.stop_reason')\" ntfy.sh/my-claude-alerts || true",
            "timeout": 5000
          }
        ]
      }
    ],
    // Sensor: Track cost per session
    "Notification": [
      {
        "matcher": "cost_update",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"$(date -Iseconds) | COST: $(echo $1 | jq -r '.cost // \"unknown\"')\" >> ~/.claude/logs/cost.log",
            "timeout": 2000
          }
        ]
      }
    ]
  },

  // ═══════════════════════════════════════════════════════
  // SANDBOX — The Isolation Boundary
  // v2.1.98: Native Linux subprocess sandbox with PID namespace
  // + seccomp is now production-stable (not beta)
  // ═══════════════════════════════════════════════════════
  "sandbox": {
    "enabled": true,
    "network": {
      "allowedHosts": [
        "registry.npmjs.org",
        "pypi.org",
        "files.pythonhosted.org",
        "github.com",
        "api.github.com",
        "crates.io",
        "static.crates.io"
      ]
    }
  },

  // ═══════════════════════════════════════════════════════
  // AGENT TEAMS — The Orchestration Primitive
  // ═══════════════════════════════════════════════════════
  "experimental": {
    "agentTeams": true
    // Requires v2.1.32+. 2-16 coordinated sessions.
    // Shared task list with dependency tracking.
    // Peer-to-peer messaging between teammates.
    // File locking to prevent conflicts.
    // No nested teams — teammates cannot spawn teams.
  },

  // ═══════════════════════════════════════════════════════
  // PLUGINS & MARKETPLACES
  // ═══════════════════════════════════════════════════════
  "plugins": {
    "marketplaces": [
      {
        "type": "github",
        "url": "anthropics/claude-plugins-official"
      },
      {
        "type": "github",
        "url": "anthropics/claude-plugins-community"
      }
    ]
  },

  // ═══════════════════════════════════════════════════════
  // ENVIRONMENT — Persistent Across Sessions
  // ═══════════════════════════════════════════════════════
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    // DO NOT also set ENHANCED_TELEMETRY_BETA unless you
    // intentionally want the distributed-traces beta.
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "CLAUDE_CODE_NO_FLICKER": "1"
    // v2.1.89: flicker-free rendering
  },

  // ═══════════════════════════════════════════════════════
  // ATTRIBUTION
  // ═══════════════════════════════════════════════════════
  "attribution": {
    "commits": true,
    "pullRequests": true
  }
}
```

---

## 3. CLAUDE.md — The System Prompt

```markdown
# Project: [PROJECT_NAME]

## Build & Test
- `just check` — full lint + type check + test suite
- `just dev` — start dev server
- `just test` — run tests (vitest / pytest / cargo test)
- `just fmt` — format all files

## Architecture
- Monorepo: `apps/` (deployables), `packages/` (shared libs)
- API: `apps/api/src/routes/` — Express/Hono/Actix handlers
- UI: `apps/web/src/` — React/Vue/Svelte components
- DB: `packages/db/` — Drizzle/Prisma schema + migrations
- See `docs/ARCHITECTURE.md` for detailed dependency graph

## Code Style
- TypeScript: strict mode, no `any`, prefer `unknown`
- Functions: max 40 lines, max 4 params
- Naming: camelCase functions, PascalCase types/components
- Imports: absolute paths via `@/` alias
- Tests: colocated `__tests__/` or `.test.ts` siblings
- Commits: conventional commits (feat/fix/chore/docs/refactor)

## Workflow Rules
- NEVER commit to main directly. Always branch + PR.
- Run `just check` before every commit.
- When creating PRs, include a test plan.
- For DB changes: migration file required, no raw SQL in app code.
- For API changes: update OpenAPI spec in `docs/api/`.

## Context Pointers (not inline code)
- Error handling pattern: `packages/shared/src/errors.ts:12-45`
- Auth middleware: `apps/api/src/middleware/auth.ts:1-30`
- Component patterns: `apps/web/src/components/README.md`
- DB schema: `packages/db/schema/` (Drizzle schema files)

## What NOT to Do
- Don't add error handling for impossible states.
- Don't create helper abstractions for one-time operations.
- Don't add comments where the code is self-evident.
- Don't refactor surrounding code when fixing a bug.
- Don't install new dependencies without explicit approval.
- Don't mock the database in integration tests.

## Agent-Specific
- Use subagents for research tasks to keep main context clean.
- For multi-file changes spanning 3+ files, plan first.
- When uncertain about architecture, ask before coding.
- Prefer editing existing files over creating new ones.
```

### Path-Scoped Rules (`.claude/rules/`)

```yaml
# .claude/rules/api-conventions.md
---
globs: ["apps/api/**/*.ts"]
---
- All route handlers return typed responses via `ApiResponse<T>`
- Use Zod schemas for request validation at the boundary
- Database queries go through the repository pattern in `packages/db`
- Never throw raw errors; wrap in AppError from `packages/shared`
```

```yaml
# .claude/rules/ui-conventions.md
---
globs: ["apps/web/**/*.tsx"]
---
- Use React Server Components by default; client components only when needed
- Tailwind CSS for styling; no inline styles or CSS modules
- Component props use TypeScript interfaces, not type aliases
- State management via React Query for server state, Zustand for client state
```

```yaml
# .claude/rules/db-conventions.md
---
globs: ["packages/db/**/*"]
---
- Schema changes require a migration file via `drizzle-kit generate`
- All migrations must be reversible (include down migration)
- Foreign keys: always define onDelete behavior explicitly
- Indexes: add for any column used in WHERE/JOIN/ORDER BY
```

---

## 4. .mcp.json — The Tool Topology

```jsonc
{
  // ═══════════════════════════════════════════════════════
  // PROJECT-SCOPE MCP SERVERS
  // Written to .mcp.json in project root.
  // Shared with team via git (--scope project).
  //
  // IMPORTANT: MCP tool names follow mcp__<server>__<tool>.
  // Tool Search lazy-loads definitions on demand (~85-95%
  // context reduction vs loading all tools upfront).
  // MCP tool result size: 500K chars (v2.1.91).
  // ═══════════════════════════════════════════════════════
  "mcpServers": {
    // ─── Code Intelligence ───────────────────────────────
    "serena": {
      "type": "stdio",
      "command": "serena",
      "args": ["start-mcp-server", "--context", "ide-assistant", "--project", "."],
      "description": "LSP-grade code intelligence (go-to-definition, references, symbols)"
    },
    "thinking": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/sequential-thinking-mcp-server"],
      "description": "Step-by-step reasoning for complex problem decomposition"
    },

    // ─── Version Control & Project Management ────────────
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/github-mcp-server"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      },
      "description": "PRs, issues, code scanning, repo management (51+ tools)"
    },
    "linear": {
      "type": "http",
      "url": "https://mcp.linear.app",
      "description": "Issue tracking and project boards"
    },

    // ─── Web & Search ────────────────────────────────────
    "brave-search": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/brave-search-mcp-server"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      },
      "description": "Privacy-focused web search"
    },
    "firecrawl": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/firecrawl-mcp-server"],
      "env": {
        "FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}"
      },
      "description": "Deep web scraping with anti-bot handling"
    },

    // ─── Database ────────────────────────────────────────
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/postgres-mcp-server"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      },
      "description": "Direct PostgreSQL access for queries and schema inspection"
    },

    // ─── Browser Automation ──────────────────────────────
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/playwright-mcp-server"],
      "description": "25+ browser control tools via accessibility tree"
    },

    // ─── Diagrams ────────────────────────────────────────
    "mermaid": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mermaid-mcp-server"],
      "description": "Preview and validate Mermaid diagrams with live reload"
    },

    // ─── Deployment ──────────────────────────────────────
    "vercel": {
      "type": "http",
      "url": "https://mcp.vercel.com",
      "description": "Deployment logs, project metadata (OAuth + Streamable HTTP)"
    },

    // ─── Observability ───────────────────────────────────
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp",
      "description": "Error monitoring via remote HTTP with OAuth (NOT stdio)"
    },

    // ─── Payments ────────────────────────────────────────
    "stripe": {
      "type": "http",
      "url": "https://mcp.stripe.com",
      "description": "25 tools covering full payment lifecycle"
    },

    // ─── Documentation ───────────────────────────────────
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest", "--api-key", "${CONTEXT7_API_KEY}"],
      "description": "Live, version-accurate library documentation (API key now required)"
    },

    // ─── Memory (structured) ─────────────────────────────
    "memory": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/memory-mcp-server"],
      "description": "Persistent key-value memory for cross-session state"
    }
  }
}
```

### User-Scope MCP Servers (in `~/.claude.json` under `projects[path].mcpServers`)

These are personal, not committed to git:

```jsonc
{
  "projects": {
    "/home/user/myproject": {
      "mcpServers": {
        // Personal Slack workspace
        "slack": {
          "type": "stdio",
          "command": "npx",
          "args": ["-y", "@anthropic-ai/slack-mcp-server"],
          "env": { "SLACK_TOKEN": "xoxb-..." }
        },
        // Google Workspace (personal account)
        "google-workspace": {
          "type": "stdio",
          "command": "npx",
          "args": ["-y", "@anthropic-ai/google-workspace-mcp-server"],
          "env": { "GOOGLE_CREDENTIALS_PATH": "~/.config/google/credentials.json" }
        },
        // Datadog (org-specific)
        "datadog": {
          "type": "http",
          "url": "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp"
        }
      }
    }
  }
}
```

### MCP Location Rules (Verified Schema Traps)
- **User scope:** `~/.claude.json` → `projects[path].mcpServers`
- **Project scope:** `.mcp.json` in project root
- **Plugin scope:** `plugin.json` in `<plugin-root>/.claude-plugin/`
- **NEVER** put MCP servers at the top level of `settings.json`

---

## 5. Principles — The Control Theory of AI-Assisted Development

### Principle 1: The Closed-Loop Imperative

**Every output must feed back into a corrective cycle.** This is the organizing principle of the entire system. In control theory, an open-loop system (one without feedback) drifts. A closed-loop system (one with sensors measuring output and feeding it back to the controller) converges on the setpoint.

Applied to Claude Code:
- **Open loop (BAD):** Claude generates code → you ship it. No measurement, no correction.
- **Closed loop (GOOD):** Claude generates code → hooks run linters/tests (sensor) → failures feed back as context → Claude corrects → hooks verify again → convergence.

Every tool in the table above is classified by its role in the loop: kernel (plant), hooks (sensors), CLAUDE.md (controller), human (setpoint), MCP servers (actuators).

### Principle 2: Verification is the Bottleneck, Not Generation

Generation is cheap and fast. Verification is expensive and slow. The system must be designed to maximize verification throughput, not generation throughput.

**The Advisor Tool (April 9 2026) is the most significant architectural event since Agent Teams.** It collapses the "route Opus for planning, Sonnet for execution" orchestration pattern into a server-side primitive. Haiku+Opus scored 41.2% on BrowseComp vs 19.7% solo at 85% lower cost. This means verification-via-advisor is now nearly free at the API level.

**Structured-output formatting trap (arxiv 2604.06066):** Models achieve syntactic alignment with output schema while missing semantic errors. Verification loops that use structured output as the primary verification signal are broken. The writer/reviewer split must use prose-level judgment, not just schema validation.

**Operational rule:** Never claim completion without running the full test suite AND getting review from a different context (cross-vendor via CodeRabbit, or different agent via Agent Teams, or human).

### Principle 3: The Writer is Never the Reviewer

This is Principle 2's corollary, stated as a hard constraint. The agent that generates code MUST NOT be the same agent that verifies it. This applies at every level:

- **Model level:** Use CodeRabbit / Greptile / Copilot Code Review (different model family reviewing Claude's output). This is the strongest form.
- **Context level:** Use Agent Teams with a dedicated reviewer teammate that has NOT seen the implementation context.
- **Tool level:** PostToolUse hooks that run linters/tests as independent verification.

### Principle 4: Design Decisions Must Be Front-Loaded

**AI acceleration of implementation causes design-decision deferral** (Simon Willison / Maganti / Boris Tane converging). You never have to slow down for the hard call. That deferral corrodes architectural clarity. Willison cites a case where a working prototype had to be scrapped because the high-level architecture was wrong despite passing tests.

**Operational rule:** If the first artifact of a task is code, the task is already broken. The sequence must be:
1. `research.md` — what exists, what constraints apply
2. `plan.md` — explicit decisions, non-goals, alternatives considered
3. Code — implementing the decided plan
4. Verification — the closed loop

### Principle 5: Skill Refinement Over Accumulation

**arxiv 2604.04323 (Skill-Usage-Bench, 34k real-world skills):** Skill-library gains collapse to near-zero in realistic retrieval. Claude Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench 2.0 only with query-specific refinement, NOT library size.

**Operational rule:** Install 5-10 skills maximum. Measure each via PluginEval (wshobson/agents) or before/after benchmarks. Delete skills that don't measurably improve outcomes. The Karpathy LLM Wiki pattern (Obsidian Markdown + `qmd` BM25/vector search) is the refinement-based alternative to skill accumulation.

### Principle 6: Native Primitives Win When They're Real

When Anthropic ships a native primitive, it replaces the third-party tool that filled the gap. This has happened repeatedly in 2026:

- **Advisor Tool** (Apr 9) → replaces orchestration-layer executor/advisor patterns
- **`ant` CLI** (Apr 8) → replaces custom GitOps for agent definitions
- **`"defer"` permission** (Apr 1) → replaces custom approval workflows
- **Native `/cost`** (Apr 4) → demotes ccusage/kerf-cli to supplementary
- **Monitor tool** (Apr 9) → replaces polling-based background-process observation
- **Native Linux sandbox** (Apr 9, production-stable) → reduces need for Docker sandboxes in many cases
- **Cedar policy syntax** (Apr 10) → first-class permissions-as-code

**Operational rule:** Re-evaluate slot rankings against Anthropic's changelog monthly, not quarterly.

### Principle 7: Parallelism Requires Isolation, Not Just Concurrency

**Addy Osmani (April 7):** Three anti-patterns — Comprehension Debt, Ambient Anxiety Tax, Trust Calibration Overhead. New rule: **start with one fewer agents than feels comfortable.** The 3-5 agent band is right; pick from the low end.

Practical: Agent Teams give you shared task lists and peer messaging, but the actual value is **isolation**. Each teammate has its own context window. This means a reviewer teammate hasn't seen implementation details, making its review genuinely independent.

### Principle 8: The Winchester Mystery House is the Default Outcome

**Drew Breunig (March 26) + Andrew Nesbitt (April 6):** AI-generated codebases have no human reader who would notice a compromised transitive dependency. AI commits averaging ~1,000 net lines, 2 orders of magnitude above human rate, produce idiosyncratic undocumented codebases.

Combined with:
- MCPSHIELD (arxiv 2604.05969): single-layer MCP defenses ≤34%, integrated reaches 91%
- ShieldNet (arxiv 2604.04426): F1=0.995 at 0.8% FP for supply-chain-poisoned MCP tools
- LiteLLM PyPI compromise (v1.82.7-8, March 2026): credential-stealing malware

**Operational rule:** Continuous SBOM generation (syft, cyclonedx) is mandatory. Supply-chain monitoring (Dependabot + ShieldNet) is mandatory. Pin all dependencies. Audit transitive deps quarterly.

### Principle 9: Sandbox Isolation is Non-Optional

**Project Glasswing / Claude Mythos (April 7):** One confirmed incident — a Mythos instance accessed the internet despite restrictions. This is a precedent-setting agent-escape event.

**Layered defense:**
1. Native Linux sandbox (PID namespace + seccomp, production-stable v2.1.98)
2. Network allowlist (sandbox.network.allowedHosts in settings.json)
3. Cedar policy rules (syntax highlighting added v2.1.100)
4. MCP gateway (agentgateway / IBM mcp-context-forge) for MCP-layer governance
5. `deny` rules in permissions as the final hard block

### Principle 10: Context is the Fundamental Constraint

Everything in this system is designed around one reality: **the context window is finite, expensive, and the single biggest determinant of output quality.**

- CLAUDE.md < 200 lines (40% token reduction measured)
- Path-scoped rules (only load when working in matching directories)
- Tool Search lazy-loading (85-95% context reduction for MCP tools)
- Subagents for research (separate context, keeps main clean)
- /compact when context gets long (60-80% shorter)
- /clear when switching tasks
- Prompt caching (90% cost reduction on repeated context)

### Principle 11: Cost Awareness is Architecture, Not Accounting

- Max $200/mo for interactive use (unlimited Opus 4.6)
- API billing for CI/headless (subscription enforcement event Apr 4 2026 — Anthropic cut subscription access for Cline, Cursor, Windsurf, OpenClaw)
- v2.1.94 changed default effortLevel from `medium` → `high` — any cost model based on medium-default is stale
- Advisor Tool: 85% cost reduction via executor/advisor split
- Sonnet within 1.2pts of Opus on SWE-bench at 5x lower cost — use Sonnet for 80% of work
- Branch8 case study: $2,400 → $680/mo (72% reduction) with these strategies

### Principle 12: The Human is the Setpoint, Not a Passenger

The human sets the desired output (the setpoint). The system converges toward it. The human does NOT:
- Read every line of generated code (that's what cross-vendor review is for)
- Approve every tool call (that's what permission rules are for)
- Monitor every session (that's what ntfy.sh/defer is for)

The human DOES:
- Write the CLAUDE.md (set the controller)
- Define the permission envelope (set the safety boundary)
- Review the architectural decisions (verify the design, not the implementation)
- Intervene when the system diverges (the error signal)

---

## 6. Unique Insight: The Impedance Mismatch Problem

**The deepest problem in AI-assisted development is not tool selection, not model capability, not cost optimization. It is impedance mismatch between the feedback loop's clock speed and the human's comprehension speed.**

Here's what I mean:

Claude Code can generate 1,000 lines per minute. A human can comprehend approximately 200 lines of unfamiliar code per hour. This is a 300:1 mismatch. Every tool in the ecosystem addresses a symptom of this mismatch, but almost none address the mismatch itself.

**The tools address symptoms:**
- Cross-vendor review (CodeRabbit) → "I can't read fast enough, so I'll have another AI read for me"
- Agent Teams → "I can't supervise all the work, so I'll have an AI supervise for me"
- Hooks → "I can't check every edit, so I'll automate the checks"
- SBOM generation → "I can't audit every dependency, so I'll automate the audit"

These are all correct solutions. But they share a hidden assumption: **the human can still comprehend the aggregate output of all these verification layers.** At 300:1 speed mismatch, this assumption breaks down around 3-5 agents running in parallel (exactly Osmani's empirically-derived limit).

**The real architecture question is:** How do you build a system where the human's comprehension speed is the bottleneck, and yet the system converges on correct output?

**The answer is the closed-loop control system:**

1. **The setpoint is NOT "correct code."** The setpoint is "code that passes all automated verification layers AND that the human can audit at the architectural level." This means the human reviews `plan.md`, not `implementation.ts`.

2. **The sensor array is layered.** Each layer catches a different class of error:
   - Layer 0: Type checker (catches type errors — free, instant)
   - Layer 1: Linter (catches style/pattern errors — free, instant)
   - Layer 2: Test suite (catches behavioral errors — free, seconds)
   - Layer 3: PostToolUse hooks (catches policy violations — free, instant)
   - Layer 4: Cross-vendor review (catches semantic errors — paid, minutes)
   - Layer 5: Security scanner (catches vulnerabilities — free/paid, minutes)
   - Layer 6: SBOM audit (catches supply-chain risk — free, seconds)
   - Layer 7: Human architectural review (catches design errors — expensive, hours)

3. **The controller (CLAUDE.md + hooks + permissions) is designed so that Layers 0-6 catch 99%+ of issues before they reach Layer 7.** The human only needs to review what passes through all six automated layers — which, if the layers are well-configured, is architecturally sound code that happens to also be correct.

4. **The error signal flows downward.** When the human rejects something at Layer 7, the correction doesn't just fix the code — it updates the controller:
   - A rejected pattern becomes a rule in CLAUDE.md ("What NOT to Do")
   - A rejected architecture becomes a path-scoped rule
   - A missed check becomes a new hook
   - A missed vulnerability becomes a new deny rule

   This is the *closed* part of the closed loop. The system learns from every rejection, tightening the controller so that class of error is caught at a lower (cheaper, faster) layer next time.

**The impedance mismatch is not solved. It is managed.** The system pushes error detection as far down the layer stack as possible, so the human's limited comprehension bandwidth is spent only on what automated layers cannot catch: architectural coherence, product direction, and ethical judgment.

**This is why the "ultimate Claude Code system" is not a maximalist tool list.** Adding more tools increases the plant's capability but does nothing for the sensor-controller-human feedback loop. Adding more hooks (sensors) directly reduces the load on the human (Layer 7). Adding more rules to CLAUDE.md (controller) directly reduces the error rate at lower layers.

**The cost of the system is dominated by the cost of human attention, not the cost of API tokens.** A well-configured CLAUDE.md that prevents 100 bad architectural decisions saves more time than any MCP server. A well-configured PreToolUse hook that blocks 1,000 bad file edits saves more time than any skill library.

**The maximalist perfection is not in the number of tools installed. It is in the tightness of the feedback loop.**

---

## Appendix A: The Monthly Audit Checklist

The closed-loop system requires periodic recalibration. Monthly:

1. **Review `/cost` output.** Is effortLevel appropriate? Is Sonnet vs Opus split correct?
2. **Review `~/.claude/logs/tool-audit.log`.** Which MCP servers are never used? Remove them (context budget).
3. **Review `~/.claude/logs/cost.log`.** Anomalous sessions? Token burn rate?
4. **Check Anthropic changelog.** New native primitives that replace third-party tools?
5. **Run PluginEval on installed skills.** Any skill with negative or neutral impact? Delete it.
6. **Audit SBOM.** New transitive dependencies? Known vulnerabilities?
7. **Review CLAUDE.md "What NOT to Do" section.** New patterns to add from the month's rejections?
8. **Check MCP server versions.** Pin to latest stable. Watch for supply-chain compromises (LiteLLM precedent).

## Appendix B: The Decision Tree for "Which Sandbox?"

```
Is this interactive development (you're at the terminal)?
├─ YES → Native Linux sandbox (v2.1.98, PID namespace + seccomp)
│        Reason: <10ms startup, ~2-3% CPU, production-stable.
│        Add: sandbox.network.allowedHosts for network control.
│        Add: Cedar policies for fine-grained permissions.
│
└─ NO → Is this CI/CD or headless?
         ├─ YES → Is this a short-lived task (<30 min)?
         │        ├─ YES → Fly Sprites (`sprite create --skip-console`)
         │        │        100GB NVMe, 8 CPU. $0.047/vCPU-hr.
         │        └─ NO → Docker Sandboxes (official)
         │                 Persistent environment. microVM isolation.
         │
         └─ NO → Is this a walk-away agent?
                  ├─ YES → Claude Managed Agents ($0.08/session-hr)
                  │        "Stateless Harness + Durable Event Sourcing"
                  │        Fully managed: sandboxing, tools, SSE streaming.
                  └─ NO → E2B / Modal
                           API-first sandbox for programmatic use.
                           Modal pricing: $0.119-0.142/vCPU-hr (NOT $0.047).
```

## Appendix C: Named Incidents for §9 Failure Modes (Reference)

| # | Incident | Date | Class | Defense |
|---|----------|------|-------|---------|
| 1 | Replit 2.5-year codebase wipeout (Claude Code) | 2025 | Destructive agent action | Structural gates, not advisory warnings |
| 2 | SaaStr/Replit production DB deletion during code freeze | Jul 2025 | Destructive agent action | Same class, different product |
| 3 | axios 1.14.1/0.30.4 Sapphire Sleet (DPRK) compromise | 2026 | Supply-chain | Pin deps, SBOM, audit |
| 4 | LiteLLM PyPI v1.82.7-8 credential-stealing malware | Mar 2026 | Supply-chain | Pin to 1.83.x+, GitHub releases |
| 5 | Project Glasswing/Mythos agent-escape | Apr 7 2026 | Agent escape | Layered sandbox + network egress policy |
| 6 | GitHub #42796 80x thrashing | 2026 | Cost anomaly | effortLevel discipline, cost monitoring |
| 7 | Anthropic subscription enforcement cutoff | Apr 4 2026 | Platform policy | API billing for CI, subscription for interactive only |
| 8 | ClawBench eval-validity gap (70% sandbox vs 6.5% realistic) | Apr 2026 | Eval validity | Never trust benchmark without realistic replication |
| 9 | MCP HTTP/SSE memory leak (~50 MB/hr) | Pre-v2.1.100 | Resource leak | Update to v2.1.100+ |
| 10 | MCPSHIELD: single-layer MCP defenses ≤34% | Apr 2026 | MCP security | Integrated defense reaches 91% |

---

*End of Architect 9 — The Closed-Loop Claude Code System*
