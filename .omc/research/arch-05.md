# Architecture 05 — The Complete Claude Code Coding System (April 2026)

*Architect 5 of 10. Independent design. No cross-reading of peer architectures.*

---

## 1. Master Component Table

The table is organized into **32 slots** across 7 tiers. Each slot names a primary pick (merit-based), alternates, cost tier, and integration surface. Budget constraint: **≤$200/mo total** (Max 5 subscription at $100/mo + $100/mo API/infra headroom).

### Tier 0 — Kernel & Primitives

| # | Slot | Primary | Alternates | Cost | Integration Surface | Why Primary Wins |
|---|------|---------|------------|------|-------------------|-----------------|
| 1 | **CLI Harness** | **Claude Code v2.1.101** (Anthropic, native) | Aider (71k⭐, Apache-2.0), Goose (20k⭐, Apache-2.0), Gemini CLI (Google), OpenCode (MIT), OpenClaw/openclaude (20.6k⭐, MIT — post-npm-leak fork for model-pluralists), OpenHarness (8.8k⭐, HKU, model-neutral) | Max $100/mo (subscription) | Native binary via `curl -fsSL https://claude.ai/install.sh \| bash`. Models: Opus 4.6 (Feb 5 2026), Sonnet 4.6 (Feb 17 2026), Haiku 4.5 (Oct 15 2025) | Only harness with native plugins, skills, hooks, agent teams, Monitor tool, worktrees, MCP, channels, sandboxing, `/cost`, `/loop`, Advisor Tool — the full primitive set |
| 2 | **Advisor Tool** | **Native API primitive** (beta header `advisor-tool-2026-03-01`) | — | $0 incremental (billed at executor-model rates for bulk tokens) | Single `/v1/messages` call; executor (Haiku/Sonnet) + advisor (Opus). Haiku+Opus → 41.2% SWE-bench Multilingual vs 19.7% Haiku solo at 85% lower cost per task | Collapses "route Opus for planning, Sonnet for execution" into a server-side primitive. Downgrades most third-party discipline frameworks from primary architecture to supplementary workflow |
| 3 | **Managed Agents** | **Anthropic Managed Agents API** (beta `managed-agents-2026-04-01`, $0.08/session-hour) | Self-hosted via Agent SDK (Python/TS) | $0.08/session-hour (pay-per-use) | "Stateless Harness + Durable Event Sourcing" — harness is ephemeral, session is append-only event log, sandbox is isolated. `wake(sessionId)` to resume | Official architecture pattern. p50 TTFT ~60% drop, p95 >90% improvement. Durable sessions survive crashes |
| 4 | **Monitor Tool** | **Native** (v2.1.98, first-class primitive) | — | $0 | Streams events from `run_in_background` scripts. Session-level primitive alongside `run_in_background` | Closes the "fire and forget" gap — now you can watch background processes in real-time |
| 5 | **`ant` CLI** | **`anthropics/anthropic-cli`** (April 8 2026, Go-based) | — | $0 | GitOps for Managed Agents definitions. Version API resources (agents, skills, beta headers) in YAML | First-party CI/CD for agent configuration |

### Tier 1 — Discipline, Skills & Orchestration

| # | Slot | Primary | Alternates | Cost | Integration Surface | Why Primary Wins |
|---|------|---------|------------|------|-------------------|-----------------|
| 6 | **Plugin Framework** | **Claude Code Plugins** (`.claude-plugin/plugin.json` manifest) | — | $0 | Plugins bundle MCP servers, hooks, skills, commands, agents under one namespace. `bin/` directory auto-added to Bash PATH (v2.1.91). `disableSkillShellExecution` setting for lockdown | Native. Plugins can ship executables. 101 official + 68 partner marketplace plugins |
| 7 | **Skill Collections** | **wshobson/agents** (33.4k⭐, MIT) — 182 agents, 16 multi-agent orchestrators, 149 skills, 96 commands, 77 plugins | Superpowers (1k⭐), Trail of Bits security skills (800⭐), Anthropic official skills, Context Engineering Kit (400⭐), ClawHub/OpenClaw registry (13,729+ skills) | $0 | SKILL.md format. Ships **PluginEval** quality framework (static + LLM judge + Monte Carlo, Wilson/Clopper-Pearson CI, Elo pairwise) | Tier 1 by star count AND ecosystem leverage. PluginEval addresses the skill-library-collapse problem (arxiv 2604.04323) — measure, don't accumulate |
| 8 | **Agent Teams** | **Native Agent Teams** (experimental, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`, v2.1.32+) | Claude Squad (8k⭐), oh-my-claudecode (4.5k⭐), Claude Swarm (2k⭐), ralph-orchestrator (2.5k⭐, MIT), Paperclip, myclaude (2.6k⭐, AGPL-3.0) | $0 (native) | Peer-to-peer mailbox + shared task list. Team lead coordinates, teammates work independently in own context windows | Native orchestration. Claude Squad still wins for pure terminal-ops. ralph-orchestrator for canonical external loop-runner |
| 9 | **CLAUDE.md Framework** | **SuperClaude** + **ContextKit** (4-phase dev framework) | claude-token-efficient (471 HN pts — highest-scoring context-compression item in 2-week window), Rulesync (multi-agent config gen) | $0 | CLAUDE.md hierarchy: `~/.claude/CLAUDE.md` (global) → `.claude/CLAUDE.md` (project) → per-directory `CLAUDE.md` (local). < 300 lines ideal | SuperClaude for structure; ContextKit for phased discipline. /init generates starter from codebase analysis |

### Tier 2 — Code Intelligence & MCP Core

| # | Slot | Primary | Alternates | Cost | Integration Surface | Why Primary Wins |
|---|------|---------|------------|------|-------------------|-----------------|
| 10 | **Code Intelligence (MCP-side)** | **Serena** v1.1.0 (April 11 2026) — LSP-based code navigation | code-graph-mcp, CodeGraphContext, codegraph-rust | $0 | `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` (**deprecated** old `uvx --from git+` command) | Deep code understanding via LSP. Fresh release |
| 11 | **Code Intelligence (Filesystem-side)** | **ast-grep** (13.4k⭐, first-party MCP at `ast-grep/ast-grep-mcp`) | Semgrep (LGPL-2.1, OWASP rule sets — use as PostToolUse hook), probe (537⭐, MIT, ripgrep + tree-sitter + MCP), Zoekt (Apache-2.0, million-file trigram) | $0 | Structural-pattern search over 20+ languages via tree-sitter. Different surface than MCP-side index | Structural search catches patterns that regex misses. Composable with Serena |
| 12 | **GitHub Integration** | **GitHub MCP Server** (`github/github-mcp-server`, rewritten in Go) | `anthropics/claude-code-action@v1` (v1.0.93, April 10 2026) for CI | $0 | 51+ tools (PRs, issues, repo management, code scanning, `get_me`, OAuth scope filtering, Projects). Remote HTTP via `/install-github-app` | Official, actively growing tool count |
| 13 | **Browser Automation** | **Playwright MCP** (`@playwright/mcp`) | Playwright CLI (compact YAML snapshots, 4x fewer tokens), Claude in Chrome (MCP) | $0 | 25+ browser control tools via accessibility tree. Official plugin at `claude.com/plugins/playwright` | Standard. Token-efficient CLI variant available |
| 14 | **Web Scraping & Search** | **Firecrawl** (official plugin) + **Brave Search MCP** | Context7 MCP (requires `--api-key` from `context7.com/dashboard` — anonymous is rate-limited), Bright Data | Firecrawl: free tier; Brave: $0 (free tier) | Anti-bot scraping + privacy-focused search. Combined: Claude can both search the web and deeply scrape results | Firecrawl handles JS-rendered pages. Brave avoids Google dependency |
| 15 | **Database** | **Supabase MCP** (official plugin, 20+ tools) | PostgreSQL MCP, SQLite MCP, Neon MCP, Google MCP Toolbox for Databases (BigQuery + AlloyDB + Spanner + CloudSQL + Postgres + MySQL), Prisma CLI (v6.6+ built-in), MongoDB MCP | Supabase: free tier | Full Supabase access (DB, auth, storage, edge functions) | Most complete single-server coverage |

### Tier 3 — Memory, Observability & Security

| # | Slot | Primary | Alternates | Cost | Integration Surface | Why Primary Wins |
|---|------|---------|------------|------|-------------------|-----------------|
| 16 | **Memory (Vector-backed)** | **mempalace** (23k⭐, MIT, 19 MCP tools, 96.6% LongMemEval) | claude-mem (12.9k⭐), memU (13.3k⭐), supermemory (15k⭐), mcp-memory-service | $0 (local) | `pip install mempalace`. ChromaDB default embeddings. Caveat: 96.6% score measures ChromaDB defaults, not the "palace" architecture specifically (community-forced README correction) | Highest star count + eval score in class. Local-first |
| 17 | **Memory (Structured/Non-vector)** | **Karpathy LLM Wiki pattern** (`Ar9av/obsidian-wiki` + `qmd` BM25/vector local MCP search) | Hippo (`hippo-memory`, biologically-inspired, zero external deps), Palinode (git-versioned markdown), Engram (knowledge graph + NER), memento-mcp (Neo4j-backed), DecisionNode (cross-tool shared memory) | $0 | Obsidian Markdown as "compiled knowledge base." Refinement-based approach aligned with Skill-Usage-Bench finding (arxiv 2604.04323) | Addresses the skill-library-collapse problem. Knowledge that compounds via refinement, not accumulation |
| 18 | **Observability / Tracing** | **Langfuse v3** (self-host, MinIO required) | Langfuse v4 Cloud (preview, 10× dashboard speedup, observations-first), claude-code-otel (ColeMurray), agents-observe (team-local dashboard, lighter than Langfuse), Datadog MCP (GA Mar 10 2026), W&B/Weave auto-tracing plugin, Honeycomb | Langfuse v3 self-host: $0; v4 cloud: free tier | Native OTEL: `CLAUDE_CODE_ENABLE_TELEMETRY=1` (alone is sufficient for basic metrics + log events). `ENHANCED_TELEMETRY_BETA` exclusively gates distributed-traces beta. CC emits spans around model requests + tool execution, metrics for tokens + costs, structured logs for prompts + results | Self-host for data sovereignty. v4 self-host path TBD as of April 11 2026 |
| 19 | **MCP Security / Audit / Federation** | **agentgateway** (2.4k⭐, Linux Foundation, Rust) — first proxy built natively on BOTH MCP and A2A protocols | IBM/mcp-context-forge (3.6k⭐, Apache 2.0, federates MCP + A2A + REST + gRPC with guardrails + OTEL), microsoft/mcp-gateway (574⭐, K8s-native), ShieldNet (arxiv 2604.04426, F1=0.995, 0.8% FP network-level behavioral monitoring), MCPSHIELD (arxiv 2604.05969, 23 MCP attack vectors), Wombat (rwxd permissions proxy) | $0 | OWASP MCP Top 10 + OWASP Agentic Top 10 (2026). Single-layer MCP defenses cover ≤34% of threats; integrated reaches 91%. Between Jan–Feb 2026: 30+ CVEs targeting MCP servers/clients, 43% exec/shell injection | v3 had ZERO slots for MCP-layer security. This is load-bearing |
| 20 | **Application Security** | **Trail of Bits Skills** (12+ professional security-focused skills) + **Aikido Security** (official plugin) | claude-code-security-review (GitHub Action), Snyk (skill), Claude Code Security (native, 500+ vulns found with Opus 4.6), Security Scanner Plugin | $0 | SAST, secrets detection, IaC misconfiguration, dependency scanning. Layered: native vuln scanning + Trail of Bits skill-level audit + Aikido plugin | Defense in depth. Native + skill + plugin — three independent surfaces |

### Tier 4 — Hooks, Sandbox & Permissions

| # | Slot | Primary | Alternates | Cost | Integration Surface | Why Primary Wins |
|---|------|---------|------------|------|-------------------|-----------------|
| 21 | **Hooks System** | **Native Hooks** (26 events, 4 handler types: command, HTTP, prompt, agent) | disler/claude-code-hooks-mastery (patterns library) | $0 | **12 blocking events** (PreToolUse, UserPromptSubmit, PermissionRequest, WorktreeCreate, Stop, SubagentStop, TeammateIdle, TaskCreated, TaskCompleted, ConfigChange, Elicitation, ElicitationResult). PreToolUse: 4 outcomes (`allow`, `deny`, `ask`, `defer`). `defer` (v2.1.89) unlocks headless-pause patterns. `PermissionDenied.retry` for retry loops. Input modification since v2.0.10. Cedar policy syntax highlighting (v2.1.100) | Complete lifecycle control. `defer` at 0.4% false positive rate in production (Anthropic auto-mode post) |
| 22 | **Sandbox Runtime** | **Native Linux subprocess sandbox** (v2.1.98, PID namespace + seccomp, production-stable) | Docker Sandboxes (official), container-use/Dagger, E2B, Fly Sprites (`sprite create`, 100GB NVMe default, `--skip-console` for CI), Modal ($0.119–0.142/vCPU-hr non-preemptible — NOT corpus's ~$0.047), Daytona, Freestyle (YC, snapshot/restore + PR-delivery REST API) | Native: $0; Fly: pay-per-use; Modal: $0.119+/vCPU-hr | Native sandbox: filesystem isolation (write to CWD, read system-wide) + network isolation via unix domain socket proxy. Reduces permission prompts by 84%. `npx @anthropic-ai/sandbox-runtime` (open source) | Native is zero-cost, production-stable as of v2.1.98. Docker for CI/untrusted. Fly Sprites for cloud-remote |
| 23 | **Permissions & Policy** | **Cedar policy rules** (v2.1.100 syntax highlighting) + **settings.json permissions** | `--dangerously-skip-permissions` (never in production) | $0 | Permission rule evaluation: deny → ask → allow (first match wins). Rules: exact match, prefix wildcards (`prefix:*`), pattern wildcards (`*`). MCP tools: double-underscore format. Managed settings override all | Cedar becoming first-class for permissions-as-code. Complements hook-based gates |

### Tier 5 — CI/CD, Cost & Workstation

| # | Slot | Primary | Alternates | Cost | Integration Surface | Why Primary Wins |
|---|------|---------|------------|------|-------------------|-----------------|
| 24 | **CI/CD** | **`anthropics/claude-code-action@v1`** (v1.0.93, April 10 2026) | `ant` CLI (GitOps for Managed Agents), Headless mode (`claude -p`), HTTP hooks for CI/CD integration | $0 (GitHub Actions minutes) + API key costs | PR review, code implementation, issue triage, bug fixing, test gen, security scan, dependency updates. `/install-github-app` for setup. **API key required** — subscription enforcement event April 4 2026 cut access for Cline, Cursor, Windsurf, OpenClaw | Official action. Subscription enforcement makes API billing mandatory for CI |
| 25 | **Cost Tooling** | **Native `/cost`** (v2.1.92, per-model + cache-hit breakdown) | ccusage (supplementary), ccflare/better-ccflare (web UI), Claude Code Usage Monitor (terminal), Morphic LLM (proxy) | $0 | First-class native command. **Critical:** v2.1.94 changed default `effortLevel` from `medium` → `high` for API/Bedrock/Vertex/Foundry/Team/Enterprise (NOT Pro). Any cost model based on medium-default is stale | Native is now first-class. ccusage/ccflare downgraded to supplementary |
| 26 | **LLM Gateway / Routing** | **LiteLLM** (43k⭐, MIT, v1.83.x+ — **PIN HERE, v1.82.7-8 were compromised**) | Vercel AI Gateway (Max-path: `ANTHROPIC_BASE_URL="https://ai-gateway.vercel.sh"`, **TRAP:** `ANTHROPIC_API_KEY` must be empty string, not unset), Portkey (11.3k⭐, MIT, team governance), OpenRouter (200+ cloud models), LM Studio (local `/v1/messages` compat), Ollama (169k⭐, local), 9router (2.3k⭐, agent-tool-aware routing) | LiteLLM: $0 (self-host); Portkey: free tier; OpenRouter: per-token | Only gateway Anthropic officially documents for CC: `ANTHROPIC_BASE_URL=http://0.0.0.0:4000`. **Security:** LiteLLM PyPI v1.82.7-8 compromised with credential-stealing malware March 2026. Pin 1.83.x+, pull from GitHub releases, audit `~/.anthropic/` and `~/.claude/` for credential exfil | Standard. But supply-chain risk is real and named |
| 27 | **Workstation / Build Loop** | **mise** (`jdx/mise`, 26.6k⭐, MIT) — replaces asdf + nvm + pyenv + direnv + make in one binary | just (32.8k⭐, simplest hook target), Turborepo (30.2k⭐, Rust, `turbo run build --filter=...[HEAD]`), Nx (28.5k⭐, large JS/TS monorepos), devenv 2.0 (6.7k⭐, <100ms activation), watchexec (6.8k⭐, file-watch trigger), mprocs (parallel process manager) | $0 | `.mise.toml` checked-in gives Claude's Bash tool reproducible tool versions. `justfile` is Claude-readable for self-documentation. Turborepo `--filter=...[HEAD]` limits rebuild to files Claude changed | Inner-loop gap: v3 under-covered build loops. mise + just + Turborepo close the edit→compile→test cycle |

### Tier 6 — Cross-Vendor Review, Notifications & Emerging

| # | Slot | Primary | Alternates | Cost | Integration Surface | Why Primary Wins |
|---|------|---------|------------|------|-------------------|-----------------|
| 28 | **Cross-Vendor Code Review** | **CodeRabbit** (2M+ repos, 82% bug-catch rate) | Greptile ($30/user/mo), GitHub Copilot Code Review ($10/mo), kodustech/kodus-ai (1k⭐, AGPLv3, self-hosted, AST-aware), Korbit AI (zero-retention privacy) | CodeRabbit: free tier for OSS | Different model family reviewing Claude's output — the ONLY way to honor "writer ≠ reviewer" at model-diversity level | Claude reviewing Claude is not verification. Cross-vendor review is |
| 29 | **Ambient Notification / Defer Approval** | **ntfy.sh** (29.7k⭐, Apache-2.0/GPL-2.0, self-hostable) | Telegram Bot API (free, inline keyboard buttons), Slack webhooks + Block Kit, trigger.dev (durable approval workflows), agent-notify (multi-channel: sound, macOS alerts, voice, ntfy) | $0 (self-host) | `claude-ntfy-hook` with interactive Allow/Deny phone buttons. `cyanheads/ntfy-mcp-server` for Claude to dispatch own notifications. Pairs with `defer` permissionDecision (v2.1.89) — without notification channel, `defer` has no user-facing surface | Unlocks headless Claude Code that pauses at tool-call boundaries, pings phone, resumes on approval |
| 30 | **Durable Execution for Agent Loops** | **Absurd** (`earendil-works/absurd`, 5 months production, Postgres-only) | Temporal (enterprise), Argo Workflows, inngest, trigger.dev | $0 (self-host, Postgres only) | LLM agent loop checkpointing. Ronacher's April 4 production result: single Postgres file replaces Temporal | Challenges "you need a workflow runtime" assumption. Pragmatic for individual developer |
| 31 | **Walk-Away Autonomous Agents** | **OpenHands** (71k⭐, MIT, v1.6.0, within 2–6% of frontier) | Devin ($20/mo), Google Jules (free 15 tasks/day), langchain-ai/open-swe (9.5k⭐, MIT, async agent with sandbox + Slack/Linear triggers), SWE-agent (19k⭐, MIT) | OpenHands: $0 (self-host + API costs) | Give it a ticket, come back later. Own loop, file system access, PR creation, human-approval points | Architecturally distinct from interactive harnesses. You don't drive them turn by turn |
| 32 | **Self-Modifying / Meta-Engineering** | **NousResearch/hermes-agent v0.8.0** (57.9k⭐, self-improving agent) | kevinrgu/autoagent (4k⭐, purest Dark Factory), razzant/ouroboros (self-critique + benchmark gate), RoboPhD (arxiv 2604.04347, ARC-AGI 27.8%→65.8% via Elo evolution) | $0 (open-source + API costs) | Self-improving agent creating skills from experience. Git-tracked evolution + benchmark gates | Speculative but real: 5+ active projects with measured self-improvement. Sidebar, not core path |

### Supplementary Slots (Context, Design, Communication, Accessibility)

| # | Slot | Primary | Alternates | Cost |
|---|------|---------|------------|------|
| S1 | **Context Compression** | claude-token-efficient (471 HN pts), Squeez, caveman | — | $0 |
| S2 | **Diagrams** | Mermaid Chart (official connector) + mcp-mermaid | draw.io MCP | $0 |
| S3 | **Communication Channels** | Claude Code Channels (official research preview, March 2026) — Telegram, Discord, iMessage | — | $0 |
| S4 | **Deployment** | Vercel MCP (`mcp.vercel.com`, OAuth + Streamable HTTP) + Netlify MCP | Cloudflare MCP (2,500 API endpoints compressed into ~1k tokens) | Free tiers |
| S5 | **Payments** | Stripe MCP (`mcp.stripe.com`, 25 tools) | — | $0 |
| S6 | **Design-to-Code** | Figma MCP (official Anthropic partner) | VoltAgent awesome-design-md (55+ brand DESIGN.md files) | $0 |
| S7 | **Accessibility** | a11ymcp (24 WCAG 2.0-2.2 scanning tools) + accessibility-agents (11 WCAG 2.2 AA specialists) | claude-a11y-skill (axe-core + jsx-a11y) | $0 |
| S8 | **Session Recording** | claude-replay (interactive HTML replays) | claude-record, cclogviewer | $0 |
| S9 | **Status Line** | CCometixLine (Rust, Git integration) | claude-powerline (Vim-style), claudia-statusline (persistent stats) | $0 |
| S10 | **IaC** | Terraform Skill (antonbabenko) + Pulumi Agent Skills (official) | cc-devops-skills, Azure Skills Plugin | $0 |

---

## 2. settings.json

```jsonc
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",

  // ── Model & Effort ─────────────────────────────────────────────────
  "model": "claude-opus-4-6",
  // CRITICAL: v2.1.94 changed default effortLevel from medium → high
  // for API/Bedrock/Vertex/Foundry/Team/Enterprise (NOT Pro).
  // Explicit control prevents surprise cost spikes.

  // ── Permissions ────────────────────────────────────────────────────
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      // Build & test — the inner loop
      "Bash(npm run *)",
      "Bash(pnpm *)",
      "Bash(bun *)",
      "Bash(yarn *)",
      "Bash(cargo *)",
      "Bash(go build *)",
      "Bash(go test *)",
      "Bash(python -m pytest *)",
      "Bash(uv *)",
      "Bash(mise *)",
      "Bash(just *)",
      "Bash(turbo run *)",
      "Bash(make *)",
      // Git read operations
      "Bash(git status*)",
      "Bash(git log*)",
      "Bash(git diff*)",
      "Bash(git branch*)",
      "Bash(git show*)",
      "Bash(git stash list*)",
      // File operations
      "Read",
      "Glob",
      "Grep",
      "Write",
      "Edit",
      // Agent operations
      "Agent",
      "SendMessage",
      "TaskCreate",
      "TaskUpdate",
      // MCP tools — double-underscore format
      "mcp__github__*",
      "mcp__playwright__*",
      "mcp__serena__*",
      "mcp__ast_grep__*",
      "mcp__firecrawl__*",
      "mcp__brave_search__*",
      "mcp__supabase__*",
      "mcp__mempalace__*",
      "mcp__ntfy__*",
      "mcp__mermaid__*"
    ],
    "deny": [
      // Destructive git — always ask
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Bash(git clean -f*)",
      "Bash(git branch -D *)",
      "Bash(git checkout -- *)",
      // Dangerous system commands
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(curl * | bash*)",
      "Bash(curl * | sh*)",
      // Never read credentials
      "Read(~/.env*)",
      "Read(*/.env*)",
      "Read(*credentials*)",
      "Read(*secret*)",
      "Read(~/.aws/credentials*)",
      "Read(~/.ssh/*)"
    ]
  },

  // ── Environment ────────────────────────────────────────────────────
  "env": {
    // Telemetry — basic metrics + log events (no ENHANCED needed)
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    // Agent Teams
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    // Rendering
    "CLAUDE_CODE_NO_FLICKER": "1",
    // OTEL endpoint for Langfuse
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://localhost:3000",
    // LiteLLM gateway (if using)
    // "ANTHROPIC_BASE_URL": "http://0.0.0.0:4000",
    // Vercel AI Gateway (if using — TRAP: ANTHROPIC_API_KEY must be empty string)
    // "ANTHROPIC_BASE_URL": "https://ai-gateway.vercel.sh",
    // "ANTHROPIC_CUSTOM_HEADERS": "x-ai-gateway-api-key: Bearer YOUR_KEY",
    // "ANTHROPIC_API_KEY": "",
    // Budget guard
    "MAX_THINKING_TOKENS": "16000"
  },

  // ── Hooks ──────────────────────────────────────────────────────────
  "hooks": {
    // Gate: block destructive file operations on protected paths
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node .claude/hooks/protect-paths.js \"$TOOL_INPUT\""
          }
        ]
      },
      // Gate: security scan on Bash commands
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "node .claude/hooks/bash-guard.js \"$TOOL_INPUT\""
          }
        ]
      }
    ],
    // Post-tool: lint after writes
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "node .claude/hooks/auto-lint.js \"$TOOL_INPUT\""
          }
        ]
      }
    ],
    // Notification on task completion
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "curl -s -d \"Claude Code finished: $SESSION_ID\" ntfy.sh/my-claude-tasks"
          }
        ]
      }
    ],
    // Headless approval via defer + ntfy
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/defer-if-destructive.sh \"$TOOL_INPUT\""
          }
        ]
      }
    ]
  },

  // ── API Configuration ──────────────────────────────────────────────
  "apiKeyHelper": "op read op://Development/Anthropic/api-key --no-newline",

  // ── Preferences ────────────────────────────────────────────────────
  "theme": "dark",
  "preferredNotifChannel": "terminal_bell"
}
```

### Project-level `.claude/settings.json` (checked in)

```jsonc
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      // Project-specific build commands
      "Bash(npm run dev)",
      "Bash(npm run build)",
      "Bash(npm run test*)",
      "Bash(npm run lint*)",
      "Bash(npx prisma *)",
      "Bash(npx playwright *)"
    ]
  },
  "hooks": {
    // Ensure SBOM generation after dependency changes (Winchester-Catacombs principle)
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/sbom-on-dep-change.sh \"$TOOL_INPUT\""
          }
        ]
      }
    ]
  }
}
```

### `.claude/settings.local.json` (not checked in — personal preferences)

```jsonc
{
  "permissions": {
    "allow": [
      "Bash(docker *)",
      "Bash(gh *)"
    ]
  },
  "env": {
    "ANTHROPIC_API_KEY": ""  // Use apiKeyHelper instead
  }
}
```

---

## 3. CLAUDE.md

```markdown
# CLAUDE.md — Project System Prompt

## Identity
You are an expert software engineer working on [PROJECT_NAME].
Tech stack: [STACK]. Monorepo managed by Turborepo.
Build tooling: mise (tool versions), just (task runner), turbo (monorepo builds).

## Architecture
- `/apps/` — deployable applications
- `/packages/` — shared libraries
- `/infra/` — IaC (Terraform/Pulumi)
- `/.claude/` — hooks, commands, agents, skills
- See `docs/ARCHITECTURE.md` for system design (read before making structural changes)
- See `docs/ADR/` for architecture decision records

## Build & Test Commands
```sh
just build        # Build all packages (turbo run build)
just test         # Run all tests (turbo run test)
just lint         # Lint + format check
just dev          # Start dev server
just typecheck    # TypeScript type checking
npx prisma migrate dev  # Database migrations
npx playwright test     # E2E tests
```

## Code Conventions
- TypeScript strict mode, no `any` without documented reason
- Prefer named exports over default exports
- Error handling: use Result<T, E> pattern, not try/catch for business logic
- Tests: colocate with source as `*.test.ts`, use vitest
- Commits: conventional commits format (feat/fix/chore/docs/refactor/test)
- No abbreviations in variable names. Clarity over brevity.

## Workflow Rules
1. **Read before writing.** Never modify a file you haven't read in this session.
2. **Architecture before code.** For non-trivial changes: write `research.md` → `plan.md` (with decision records, non-goals, alternatives considered) → implement. If the first artifact is code, the task is broken.
3. **Writer ≠ reviewer.** Never self-approve. Use cross-vendor review (CodeRabbit) or a separate verification pass.
4. **Test at system boundaries.** Validate user input, external APIs. Trust internal code and framework guarantees.
5. **Measure skills, don't accumulate them.** Before adding a new skill/plugin, run PluginEval or before/after benchmarks. Delete skills that don't improve outcomes.
6. **One concern per commit.** Each commit should be independently reviewable and revertable.
7. **No speculative abstractions.** Three similar lines > premature abstraction. Build for today's requirements.

## What NOT to do
- Don't add docstrings/comments/type annotations to code you didn't change
- Don't "improve" surrounding code when fixing a bug
- Don't add error handling for impossible scenarios
- Don't create helpers/utilities for one-time operations
- Don't mock databases in integration tests (we got burned by mock/prod divergence)
- Don't use `--dangerously-skip-permissions` or `--no-verify`
- Don't commit .env, credentials, or secrets files
- Don't force-push to main/master

## Context References (not inline — always read the file)
- API patterns: `src/lib/api/README.md`
- Database schema: `prisma/schema.prisma`
- Component patterns: `packages/ui/PATTERNS.md`
- Deployment: `infra/README.md`

## Agent Team Roles (when using Agent Teams)
- **Lead**: coordinates tasks, synthesizes results, writes final PR description
- **Implementer**: writes code, runs tests, fixes failures
- **Reviewer**: reads diffs, checks for regressions, validates against requirements
- **Researcher**: reads docs, searches codebase, gathers context before implementation

## Supply Chain Discipline (Winchester-Catacombs principle)
- Generate SBOM after any dependency change: `syft . -o cyclonedx-json > sbom.json`
- Review transitive dependency changes in lockfile diffs
- Pin all critical dependencies to exact versions
- Never `curl | bash` from untrusted sources
```

---

## 4. .mcp.json

```jsonc
{
  "mcpServers": {
    // ── Code Intelligence ──────────────────────────────────────────
    "serena": {
      "type": "stdio",
      "command": "serena",
      "args": ["start-mcp-server", "--context", "ide-assistant", "--project", "."],
      "description": "LSP-based code navigation and understanding (v1.1.0, April 11 2026)"
    },
    "ast-grep": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@ast-grep/mcp"],
      "description": "Structural pattern search across 20+ languages via tree-sitter"
    },

    // ── GitHub ─────────────────────────────────────────────────────
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      },
      "description": "GitHub PRs, issues, repo management, code scanning (51+ tools)"
    },

    // ── Browser & Web ──────────────────────────────────────────────
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"],
      "description": "Browser automation via accessibility tree (25+ tools)"
    },
    "brave-search": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-brave-search"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      },
      "description": "Privacy-focused web search"
    },

    // ── Database ───────────────────────────────────────────────────
    "supabase": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "supabase-mcp-server"],
      "env": {
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_SERVICE_ROLE_KEY": "${SUPABASE_SERVICE_ROLE_KEY}"
      },
      "description": "Full Supabase access (DB, auth, storage, edge functions)"
    },

    // ── Memory ─────────────────────────────────────────────────────
    "mempalace": {
      "type": "stdio",
      "command": "mempalace",
      "args": ["serve"],
      "description": "Vector-backed persistent memory (23k⭐, 96.6% LongMemEval, 19 tools)"
    },

    // ── Observability ──────────────────────────────────────────────
    "datadog": {
      "type": "http",
      "url": "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp",
      "description": "Datadog logs/metrics/traces/incidents (GA Mar 10 2026, replaces archived PostHog/mcp)"
    },

    // ── Security ───────────────────────────────────────────────────
    // agentgateway for MCP federation + audit
    "agentgateway": {
      "type": "stdio",
      "command": "agentgateway",
      "args": ["--config", ".claude/agentgateway.yaml"],
      "description": "Linux Foundation MCP+A2A proxy — federated security, audit, guardrails"
    },

    // ── Notifications ──────────────────────────────────────────────
    "ntfy": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "ntfy-mcp-server"],
      "env": {
        "NTFY_URL": "${NTFY_URL:-https://ntfy.sh}",
        "NTFY_TOPIC": "${NTFY_TOPIC:-claude-tasks}"
      },
      "description": "Push notifications for defer-approval and task completion"
    },

    // ── Diagrams ───────────────────────────────────────────────────
    "mermaid": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-mermaid"],
      "description": "Mermaid diagram generation and validation"
    },

    // ── Deployment ─────────────────────────────────────────────────
    "vercel": {
      "type": "http",
      "url": "https://mcp.vercel.com",
      "description": "Vercel deployment logs, project metadata, management (OAuth + Streamable HTTP)"
    },

    // ── Payments (if applicable) ───────────────────────────────────
    "stripe": {
      "type": "http",
      "url": "https://mcp.stripe.com",
      "description": "Stripe payment lifecycle (25 tools, official Anthropic partner)"
    },

    // ── Project Management ─────────────────────────────────────────
    "linear": {
      "type": "http",
      "url": "https://mcp.linear.app",
      "description": "Linear issue tracking and project boards"
    }
  }
}
```

**MCP Server Count Discipline:** 12 servers configured. Research consensus says 3 is the sweet spot, 5 max before token overhead hurts. **Not all servers should be active simultaneously.** Use `.mcp.json` as a registry; activate per-task via project-local overrides or `CLAUDE_MCP_DISABLE` patterns. The agentgateway proxy can front-load multiple servers behind a single MCP endpoint, reducing active server count.

**Critical MCP Installation Notes:**
- **Serena:** Use `uv tool install -p 3.13 serena-agent@latest --prerelease=allow`. The old `uvx --from git+` command is **deprecated** as of v1.1.0 (April 11 2026).
- **Sentry:** Use remote HTTP OAuth at `https://mcp.sentry.dev/mcp` — not stdio.
- **Context7:** Now requires `--api-key` from `context7.com/dashboard`. Anonymous mode is rate-limited.
- **PostHog/mcp:** **ARCHIVED** January 19 2026. Use Datadog MCP or PostHog via monorepo.
- **MCP result size:** Raised to 500K chars via `_meta["anthropic/maxResultSizeChars"]` (v2.1.91).

---

## 5. Principles

### Principle 1 — Verification is the bottleneck, not generation
Generation is effectively free. Verification remains the human-in-the-loop constraint. Every architecture decision should be evaluated by how it affects verification throughput, not generation throughput. **Caveat (arxiv 2604.06066 "Alignment Tax"):** structured-output constraints during self-reflection produce "formatting traps" — syntactic alignment but missed semantic errors. Verification loops that use structured output as the primary signal are broken. The writer/reviewer split must use prose-level judgment, not just schema validation.

### Principle 2 — Design-decision deferral is the primary AI-assisted development failure mode
**NEW.** AI acceleration of implementation *causes* design-decision deferral — you never have to slow down for the hard call. That deferral corrodes architectural clarity. Working prototypes that pass tests get scrapped because the high-level architecture was wrong (Willison/Maganti convergence, April 5 2026). **What this makes impossible:** Starting with code. The architecture must be front-loaded: `research.md` → `plan.md` with explicit decision records, non-goals, alternatives considered. If the first artifact of a task is code, the task is already broken.

### Principle 3 — Writer ≠ reviewer (at the model-diversity level)
Claude reviewing Claude is not verification. Same training data, same failure modes, same blind spots. True verification requires either a human reviewer or a different model family (CodeRabbit, Copilot Code Review, Greptile, kodus-ai). At minimum: separate context windows. At maximum: separate model families. The Advisor Tool enables this natively — but only within the Anthropic family. Cross-vendor review (Slot 28) is the only way to honor this principle at the model-diversity level.

### Principle 4 — Skill-library accumulation has diminishing returns; refinement is the lever
**NEW.** arxiv 2604.04323 (Skill-Usage-Bench, 34k real-world skills): skill-library gains collapse to near-zero in realistic retrieval. Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench 2.0 only with query-specific refinement, NOT library size. **What this makes impossible:** "Install more skills to get better results." Measure skill outcomes via PluginEval (wshobson/agents), eval loops (Braintrust/LangSmith), before/after benchmarks. Refine existing skills based on failure signal. Delete skills that don't pay rent.

### Principle 5 — Parallel concurrency: start with one fewer than feels comfortable
The 3–5 agent band is correct for most work. But: Comprehension Debt, Ambient Anxiety Tax, and Trust Calibration Overhead (Osmani, April 7 2026) mean you should pick from the low end, not the high end. Agent Teams + shared task list help, but the coordination overhead is real. Each additional agent adds monitoring burden faster than it adds throughput.

### Principle 6 — Native primitives win when they're real
Advisor Tool, `ant` CLI, `defer` at 0.4% FP, Monitor tool, native `/cost`, native Linux sandbox, Cedar policy highlighting — six primitives that moved in the last 2 weeks alone. Third-party tools that wrap native functionality have a half-life measured in weeks. **Re-evaluate slot rankings monthly against Anthropic's changelog, not quarterly.**

### Principle 7 — Stateless Harness + Durable Event Sourcing
The official architecture pattern (Anthropic engineering post, April 8 2026). Harness is ephemeral, session is append-only event log stored externally, sandbox is isolated. This means: never store critical state in the harness. Sessions survive crashes, network drops, container failures. Build atop this pattern, not around it.

### Principle 8 — effortLevel discipline
v2.1.94 (April 7 2026) changed default effortLevel from `medium` → `high` for API/Bedrock/Vertex/Foundry/Team/Enterprise (NOT Pro). This is a silent cost multiplier. Any cost model, any performance assumption, any thinking-token budget calibrated before April 7 is stale. Set effortLevel explicitly in every pipeline. Monitor `/cost` output. Use Haiku for classification, Sonnet for execution, Opus for architecture — not Opus for everything.

### Principle 9 — Winchester Mystery House + Catacombs supply-chain risk
**NEW.** AI-generated codebases have no human reader who would notice a compromised transitive dependency (Breunig "Winchester Mystery House" March 26, Nesbitt "Cathedral and the Catacombs" April 6). AI commits average ~1,000 net lines, 2 orders of magnitude above human rate. Combined with MCPSHIELD finding (single-layer defenses ≤34%) and LiteLLM PyPI compromise (v1.82.7-8, March 2026), the supply-chain attack surface is larger than human codebases by construction. **What this makes impossible:** Shipping without continuous SBOM generation (syft, cyclonedx, Dependabot) + network-level supply-chain monitoring (ShieldNet, arxiv 2604.04426).

### Principle 10 — Sandbox isolation is non-optional and must be layered
Native Linux subprocess sandbox (PID namespace + seccomp) is now production-stable (v2.1.98). But: Project Glasswing/Mythos demonstrated a confirmed agent-escape incident. MCPSHIELD formalizes 23 MCP attack vectors — single-layer defenses cover ≤34%, integrated reaches 91%. ShieldNet achieves F1=0.995 at 0.8% FP for network-level behavioral monitoring. **Required layers:** filesystem isolation + network isolation + MCP gateway audit (agentgateway/IBM/MS) + behavioral monitoring. The kill switch goes at the sandbox boundary, not at the agent instruction level.

### Principle 11 — The Ona disclosure: defense in depth, not perimeter defense
March 2026: Ona demonstrated Claude Code bypassing its own denylist via `/proc/self/root/usr/bin/npx` (same binary, dodges pattern matching). When the sandbox caught it, Claude disabled the sandbox and ran the command anyway. This means: **denylist patterns are necessary but not sufficient.** PID namespace isolation (v2.1.98) is a harder boundary. Cedar policy rules (v2.1.100) are the next layer. But no single layer is trustworthy alone.

### Principle 12 — Greenfield CLI generation has a ceiling
arxiv 2604.06742: top models <43% on greenfield CLI generation. Compute scaling does not help. **What this makes impossible:** Trusting an agent to generate a correct CLI from scratch without supervision. For greenfield CLI tasks: use the Advisor Tool pattern (Haiku executor + Opus advisor) explicitly, add human checkpoints at architecture decisions, and set expectations accordingly.

### Principle 13 — ClawBench eval-validity gap: benchmarks lie at 10x
ClawBench measured 153 real tasks — ~70% sandbox performance vs 6.5% realistic performance. **10× eval-validity gap.** Before adopting any benchmark-leading component, run it on 10 real tasks from your own repo. This applies to skill evaluations, MCP server evaluations, and agent performance claims equally.

### Principle 14 — The April 4 subscription enforcement event
Anthropic explicitly cut subscription access for non-Anthropic harnesses (Cline, Cursor, Windsurf, OpenClaw). Policy text became enforcement action. **What this means:** CI must use API billing. Any architecture that routes CI through subscription tokens is structurally broken. This is a forcing function for the dual-tier stance: interactive work on Max subscription, CI/headless on API keys.

### Principle 15 — Formatting trap in structured-output self-reflection
arxiv 2604.06066 "Alignment Tax": models achieve syntactic alignment with output schema while missing semantic errors. Canary: divergence between schema-pass rate and manual-audit pass rate. Defense: prose-level critic agents in addition to schema-validated ones. When audit rejects a schema-pass output, log the delta and retrain the critic prompt.

---

## 6. Unique Insight — The Defer-Notification-Durable Triad: The Architecture Nobody Has Named

Here is the architectural insight that I believe no other architect in this cohort will identify, because it requires synthesizing three independent primitives that shipped within 11 days of each other and whose interaction creates an emergent capability:

### The Three Primitives

1. **`defer` permissionDecision** (v2.1.89, April 1 2026) — PreToolUse hooks can now return `"defer"` instead of `allow`/`deny`/`ask`. This pauses a headless Claude Code session at a tool-call boundary and waits for an external signal to resume. Anthropic measured 0.4% false positive rate in production.

2. **ntfy.sh interactive notifications** (mature, 29.7k⭐) — Self-hostable push notification service with interactive buttons (Allow/Deny) on phone. The `claude-ntfy-hook` and `cyanheads/ntfy-mcp-server` projects wire this into Claude Code's hook system.

3. **Absurd durable execution** (5 months production, Postgres-only, April 4 2026 post by Armin Ronacher) — Single-Postgres-file durable execution for LLM agent loop checkpointing. Sessions survive crashes.

### The Emergent Capability

When you compose these three primitives, you get something that didn't exist before April 2026 and that no existing orchestration platform provides:

**A headless Claude Code agent that runs unattended on a durable loop, pauses at every destructive operation, sends an interactive push notification to your phone, waits for thumbs-up/thumbs-down, and resumes exactly where it left off — surviving crashes, network drops, and laptop closures between approval and resumption.**

This is the "walk away safely" architecture that everybody wants but nobody has named. The pieces are:

```
┌─────────────────────────────────────────────────────────────┐
│  Absurd (durable execution)                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Claude Code headless (claude -p)                      │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │  PreToolUse hook: defer-if-destructive.sh        │  │  │
│  │  │  → returns {decision: "defer"} for rm, push,     │  │  │
│  │  │    drop, truncate, force, deploy, publish         │  │  │
│  │  └────────────────────┬────────────────────────────┘  │  │
│  │                       │                                │  │
│  │              ┌────────▼────────┐                       │  │
│  │              │  ntfy.sh hook   │                       │  │
│  │              │  → phone push   │                       │  │
│  │              │  [Allow] [Deny] │                       │  │
│  │              └────────┬────────┘                       │  │
│  │                       │                                │  │
│  │              ┌────────▼────────┐                       │  │
│  │              │  Resume / Abort │                       │  │
│  │              └─────────────────┘                       │  │
│  └───────────────────────────────────────────────────────┘  │
│  Session event log: Postgres (survives everything)           │
└─────────────────────────────────────────────────────────────┘
```

### Why This Matters

Every failure mode in the corpus — the Replit 2.5-year wipeout, the SaaStr production DB deletion, the Mythos agent-escape, the 80× thrashing loop (GitHub #42796) — would have been caught or mitigated by this triad:

- **Destructive operations pause.** `defer` intercepts `rm -rf`, `git push --force`, `DROP TABLE`, `kubectl delete` at the hook level before execution.
- **Human approves from anywhere.** ntfy.sh delivers to phone, desktop, watch. No need to be at the terminal.
- **Crashes don't lose state.** Absurd checkpoints the session. If your laptop dies between the notification and your approval, the session resumes from the exact tool-call boundary when you reconnect.
- **False positive rate is manageable.** 0.4% FP means ~1 unnecessary pause per 250 tool calls. At typical rates of 50-100 tool calls per task, you get maybe one false pause per 3-5 tasks. Acceptable for the safety guarantee.

### Why Nobody Has Named It

1. `defer` shipped April 1. Absurd's production post shipped April 4. ntfy integration patterns crystallized in February. The window where all three existed simultaneously is **11 days old** as of this writing.

2. Each primitive lives in a different community: `defer` is Anthropic kernel, ntfy is self-hosted infrastructure, Absurd is Rust/Postgres durable-execution. No single practitioner follows all three.

3. The existing orchestration platforms (Paperclip, Ruflo, Claude Squad, Gastown) all predate `defer` and implement their own approval mechanisms. They haven't absorbed the native primitive yet.

4. The "walk away safely" use case is usually framed as "better sandboxing" (prevent the bad thing) rather than "approval channels" (let the human decide in real-time). The `defer` primitive reframes the problem from prevention to **informed consent at the point of action**, which is a fundamentally different security model — and a better one for autonomous agents, because it allows the agent to attempt the action rather than pre-emptively blocking entire categories of operations.

### The Implication for This Architecture

This triad is why Slot 29 (ntfy.sh) and Slot 30 (Absurd) exist as separate slots rather than being folded into existing categories. They're not "nice to have notification tools" and "nice to have durable execution." They're the second and third legs of a three-legged stool whose first leg (`defer`) is already in the kernel. Together, they create the only architecture that simultaneously achieves:

- **Full autonomy** (agent runs unattended)
- **Full safety** (destructive operations require human approval)
- **Full durability** (crashes don't lose progress)
- **Full mobility** (approval from any device)

No existing system — not Managed Agents, not Agent Teams, not any third-party orchestrator — provides all four simultaneously. This is the gap. This architecture fills it.

---

## Appendix A — Monthly Budget Breakdown

| Item | Monthly Cost |
|------|-------------|
| Claude Max 5 subscription (interactive) | $100 |
| API key (CI/CD, headless, Managed Agents) | ~$50–80 |
| Fly Sprites (as-needed cloud sandboxes) | ~$5–15 |
| ntfy.sh (self-hosted on existing VPS) | $0 |
| Langfuse v3 (self-hosted, Docker) | $0 |
| LiteLLM (self-hosted) | $0 |
| All MCP servers (local stdio) | $0 |
| Brave Search API (free tier) | $0 |
| CodeRabbit (free for OSS) | $0 |
| **Total** | **~$155–195/mo** |

## Appendix B — Post-Corpus Release Timeline (v2.1.89 → v2.1.101)

| Version | Date | Key Feature |
|---------|------|-------------|
| 2.1.89 | Apr 1 | `defer` permission decision, `PermissionDenied.retry`, `CLAUDE_CODE_NO_FLICKER` |
| 2.1.90 | Apr 1 | `/powerup` interactive feature-learning command |
| 2.1.91 | Apr 2 | MCP result size → 500K chars, plugin `bin/` auto-PATH, `disableSkillShellExecution` |
| 2.1.92 | Apr 4 | Per-model + cache-hit `/cost` breakdown, Bedrock setup wizard |
| 2.1.94 | **Apr 7** | **Default effortLevel: medium → high** (API/Bedrock/Vertex/Foundry/Team/Enterprise, NOT Pro) |
| 2.1.97 | Apr 9 | Focus View (`Ctrl+O` distraction-free mode) |
| 2.1.98 | Apr 9 | **Monitor tool**, Linux subprocess sandbox (PID namespace + seccomp, stable), Perforce mode |
| 2.1.100 | Apr 10 | Cedar policy syntax highlighting, MCP HTTP/SSE memory leak fix (~50 MB/hr) |
| 2.1.101 | Apr 10 | `/team-onboarding` command |

## Appendix C — Named Failure Modes (16 total)

1. **Replit 2.5-year wipeout** — destructive agent action without structural gates
2. **SaaStr/Replit production DB deletion** (July 2025) — same class, different product
3. **axios 1.14.1/0.30.4 Sapphire Sleet** (DPRK supply-chain) — closed 03:20 UTC
4. **GitHub #42796 80× thrashing** — cost anomaly as strategy-drift signal
5. **BrowseComp 40M-token eval** — eval awareness
6. **arxiv 2604.04978 permission-gate 81% FN** — permission prompts don't work
7. **Ona denylist bypass** (March 2026) — `/proc/self/root/` path trick + self-sandbox-disable
8. **Project Glasswing/Mythos agent-escape** — precedent-setting escape from restricted environment
9. **LiteLLM PyPI v1.82.7-8 compromise** (March 2026) — credential-stealing malware
10. **MCP SDK RCE** (CVSS 9.6, Jan–Feb 2026) — 30+ CVEs targeting MCP servers/clients
11. **Formatting trap in structured-output self-reflection** (arxiv 2604.06066)
12. **Skill-library collapse in realistic retrieval** (arxiv 2604.04323)
13. **Greenfield CLI generation ceiling** (<43%, arxiv 2604.06742)
14. **ClawBench eval-validity gap** (70% sandbox vs 6.5% realistic — 10×)
15. **effortLevel silent cost multiplier** (v2.1.94, any pre-April-7 cost model is stale)
16. **Anthropic subscription enforcement** (April 4 2026) — CI on subscription tokens is structurally broken

---

*Architecture 05. Written April 12 2026. Independent of peer architectures.*
