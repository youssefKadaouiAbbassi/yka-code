# Architecture 07 — The Gravitational Model: Claude Code as a Planetary System

*Architect 7 of 10 · Independent design · April 12, 2026*

---

## Unique Thesis: The Gravitational Orbit Model

Most Claude Code system designs treat the ecosystem as a flat catalog: "here are 30 slots, pick one from each." That framing is architecturally dishonest. The ecosystem has **gravity** — some components are load-bearing primitives that warp everything around them, while others are satellites that only exist because the primitive's gravity field creates a niche.

**The insight:** April 2026 is a phase transition. Three Anthropic-native primitives landed in 10 days (Advisor Tool Apr 9, `defer` permission Apr 1, Monitor tool Apr 9) that collapse entire categories of third-party tooling into server-side features. A maximalist system must be organized not as a flat catalog but as **concentric orbits around the kernel**, where each orbit has a gravitational relationship to the one inside it:

1. **Core (the star):** Claude Code binary + Anthropic API primitives (Advisor, Managed Agents, Agent Teams)
2. **Inner orbit (structural):** Things that modify the core's behavior (settings.json, CLAUDE.md, hooks, permissions, sandbox)
3. **Middle orbit (extension):** Things that add capabilities (MCP servers, plugins, skills)
4. **Outer orbit (orchestration):** Things that run multiple cores (multi-agent frameworks, CI/CD, durable execution)
5. **Halo (observation):** Things that watch everything else (observability, cost tracking, security audit)

The gravitational rule: **when a capability migrates inward (from outer orbit to core), everything in the orbit it left must be re-evaluated.** The Advisor Tool migrated "executor/advisor orchestration" from the outer orbit to the core in a single API call. That means every third-party orchestrator that existed primarily to pair fast+smart models just lost its gravitational justification.

---

## 1. The Complete System Table

### Orbit 0 — The Star: Claude Code Kernel

| # | Component | What It Is | Install/Config | Cost | Why It's Here | Gravitational Effect |
|---|-----------|-----------|----------------|------|---------------|---------------------|
| 0.1 | **Claude Code CLI v2.1.101** | The agentic coding agent | `curl -fsSL https://claude.ai/install.sh \| bash` | Max $200/mo (Pro $100, Max $200) | The kernel. Everything else orbits this. | Defines all tool primitives, permission model, hook events, context window |
| 0.2 | **Anthropic API (Opus 4.6 / Sonnet 4.6 / Haiku 4.5)** | Model backend | API key or Max subscription | API: pay-per-token; Max: included | Three tiers of intelligence at different cost points | Model routing is the first architectural decision |
| 0.3 | **Advisor Tool** (beta `advisor-tool-2026-03-01`) | Server-side executor+advisor pairing | Beta header in API calls; `/advisor` toggle in CC | Haiku+Opus: 85% cheaper than Opus alone | Collapses orchestrator-level model pairing into a single API call | **Gravity collapse:** Demotes external orchestrators that existed for model-pairing |
| 0.4 | **Agent Teams** (experimental `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) | Native multi-agent with worktree isolation | env var + settings.json | Included in subscription | TaskCreate + SendMessage + worktree = coordination primitives | **Gravity collapse:** Partially obsoletes Claude Squad, multiclaude for team-coordination use cases |
| 0.5 | **Managed Agents** (beta `managed-agents-2026-04-01`) | Hosted autonomous agent runtime | API header; `$0.08/session-hour` | $0.08/session-hr | "Stateless Harness + Durable Event Sourcing" — the official Anthropic architecture pattern | **Gravity collapse:** Walk-away autonomy without self-hosting |
| 0.6 | **Monitor Tool** (v2.1.98) | First-class streaming from `run_in_background` | Native primitive, no install | Free | Closes the observability gap for background processes | Replaces polling patterns in hooks |
| 0.7 | **`ant` CLI** | GitOps for Managed Agent definitions | `github.com/anthropics/anthropic-cli` | Free | CI/CD for agent configuration as code | New surface for agent lifecycle management |
| 0.8 | **Native `/cost`** (v2.1.92) | Per-model + cache-hit cost breakdown | Built-in slash command | Free | First-party cost visibility | Demotes ccusage/kerf-cli to supplementary |
| 0.9 | **`defer` Permission Decision** (v2.1.89) | Pause headless sessions for external approval | PreToolUse hook returning `"defer"` | Free | 0.4% FP rate in production (Anthropic engineering post) | **Enables:** headless-with-human-gate pattern |
| 0.10 | **Native Linux Sandbox** (v2.1.98) | PID namespace + seccomp isolation | Production-stable on Linux | Free | No Docker required for process isolation | Changes "which sandbox" decision tree |
| 0.11 | **Plugin Framework** (v2.1.91+) | `bin/` auto-PATH + `disableSkillShellExecution` | `.claude-plugin/plugin.json` | Free | Executable distribution via plugins | Plugins can now ship CLI tools |
| 0.12 | **Cedar Policy Syntax** (v2.1.100) | Permissions-as-code highlighting | Native | Free | Cedar is now first-class for permission rules | Structured permission policies |

### Orbit 1 — Inner Orbit: Structural Configuration

| # | Component | What It Is | Install/Config | Cost | Orbit Justification |
|---|-----------|-----------|----------------|------|---------------------|
| 1.1 | **`settings.json`** | Behavioral configuration (see §2 below) | `~/.claude/settings.json` + `.claude/settings.json` + `.claude/settings.local.json` | Free | Modifies the kernel's permission model, hooks, env |
| 1.2 | **`CLAUDE.md`** | Natural-language system prompt injection | Project root + `~/.claude/CLAUDE.md` + subdirectories | Free | Modifies the kernel's reasoning and decision-making |
| 1.3 | **Hooks** (26 events, 12 blocking) | Shell/HTTP/LLM commands at lifecycle points | `settings.json` hooks array | Free | Structural enforcement (100% compliance vs CLAUDE.md's ~70%) |
| 1.4 | **Permissions Model** | `allowedTools`, `denyTools`, `defaultMode` | `settings.json` permissions object | Free | Defines the trust boundary |
| 1.5 | **`.mcp.json`** | MCP server declarations (see §4 below) | Project root, committed to git | Free | Defines the tool surface |
| 1.6 | **Environment Variables** | 170+ env vars controlling CC behavior | `settings.json` env field or shell | Free | Runtime behavior switches |
| 1.7 | **Skills** (SKILL.md format) | On-demand knowledge injection | `~/.claude/skills/` or `.claude/skills/` | Free | Context-efficient domain knowledge |
| 1.8 | **`~/.claude.json`** | User-scope MCP + project overrides | Home directory | Free | Per-user credential isolation |

### Orbit 2 — Middle Orbit: Capability Extension

#### 2A — Code Intelligence & Search

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2A.1 | **Serena** (v1.1.0, Apr 11 2026) | 4k+ | `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` | Free | Full LSP: go-to-def, references, rename, diagnostics across 20+ languages |
| 2A.2 | **ast-grep MCP** | 13.4k | `claude mcp add ast-grep -- npx @ast-grep/mcp` | Free | Structural pattern search via tree-sitter, 20+ languages |
| 2A.3 | **Context7 MCP** | 5k+ | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest --api-key KEY` | Free (rate-limited without key) | Live library docs with version accuracy |
| 2A.4 | **probe** | 537 | `claude mcp add probe -- probe-mcp-server` | Free | ripgrep + tree-sitter AST, compact ranked spans |
| 2A.5 | **Semgrep** | 12k+ | PostToolUse hook or CLI | Free (OSS rules) | OWASP rule sets, security-focused static analysis |

#### 2B — Databases & Data

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2B.1 | **Supabase MCP** | Official | `claude mcp add supabase -- npx supabase@latest -- start` | Free tier | Full backend: DB + auth + storage + edge functions |
| 2B.2 | **PostgreSQL MCP** | Official | `claude mcp add postgres -- npx @modelcontextprotocol/server-postgres postgres://...` | Free | Direct Postgres access for existing DBs |
| 2B.3 | **Google MCP Toolbox** | 13.5k | Self-hosted HTTP | Free (GCP costs) | BigQuery + AlloyDB + Spanner + CloudSQL |
| 2B.4 | **Prisma CLI** (v6.6+) | Built-in | `npx prisma` | Free | migrate-dev/status/reset natively |

#### 2C — Cloud & Infrastructure

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2C.1 | **Terraform MCP** | Official | `claude mcp add terraform -- npx @hashicorp/terraform-mcp-server` | Free | Registry + Cloud APIs |
| 2C.2 | **AWS MCP** | Community | `claude mcp add aws` | Free | AWS infra management |
| 2C.3 | **Cloudflare MCP** | Official | Remote HTTP | Free | 2,500 API endpoints in ~1k tokens — best context engineering |
| 2C.4 | **Vercel MCP** | Official | `mcp.vercel.com` with OAuth | Free | Deployment + project management |
| 2C.5 | **Docker MCP** | Official | Registry | Free | Container operations |

#### 2D — Communication & Project Management

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2D.1 | **GitHub MCP** | Official | `claude mcp add github -- npx @modelcontextprotocol/server-github` | Free | PRs, issues, code search, projects — rewritten in Go, 51+ tools |
| 2D.2 | **Linear MCP** | Official | `mcp.linear.app` remote | Free | Issue tracking |
| 2D.3 | **Sentry MCP** | Official | Remote HTTP OAuth at `https://mcp.sentry.dev/mcp` | Free tier | Error monitoring — use remote, NOT stdio |
| 2D.4 | **Slack MCP** | Community | Via registry/Composio | Free | Team messaging |
| 2D.5 | **Figma MCP** | Official | Anthropic partner | Free | Design-to-code |

#### 2E — Browser & Testing

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2E.1 | **Playwright MCP** | Official | `claude mcp add playwright -- npx @playwright/mcp@latest` | Free | 25+ browser tools via accessibility tree |
| 2E.2 | **Playwright CLI** | Microsoft | Token-efficient YAML snapshots, 4× fewer tokens | Free | Adjunct to Playwright MCP |
| 2E.3 | **a11ymcp** | Community | `claude mcp add a11y -- npx a11ymcp` | Free | 24 WCAG 2.0-2.2 scanning tools |

#### 2F — Memory & Knowledge Persistence

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2F.1 | **Native Auto Memory** | Built-in | v2.1.59+, `~/.claude/projects/<project>/memory/` | Free | Zero-config, ranked by confidence + frequency |
| 2F.2 | **mempalace** | 23k | `pip install mempalace` — 19 MCP tools, 96.6% LongMemEval | Free | Vector-backend, highest benchmark score |
| 2F.3 | **claude-mem** | 12.9k | Plugin install | Free | Auto-capture, compress, inject across sessions |
| 2F.4 | **Karpathy LLM Wiki** | Emerging | Obsidian + `qmd` BM25/vector local MCP | Free | Refinement-based, aligned with Skill-Usage-Bench finding |
| 2F.5 | **Hippo** | Community | Biologically-inspired, zero external deps | Free | Non-vector structured memory |
| 2F.6 | **memento-mcp** | Community | Neo4j-backed graph memory | Free (Neo4j) | Knowledge graph for entity relationships |

#### 2G — File Format & Documentation

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2G.1 | **Stripe MCP** | Official | `mcp.stripe.com` remote HTTP | Free | 25 tools, full payment lifecycle |
| 2G.2 | **markdownify-mcp** | Community | `claude mcp add markdownify` | Free | Convert anything to Markdown |
| 2G.3 | **MarkItDown** | Skill | 15+ file formats to Markdown | Free | Office, PDF, media conversion |

#### 2H — Observability & Monitoring

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2H.1 | **Native OTEL** | Built-in | `CLAUDE_CODE_ENABLE_TELEMETRY=1` + OTEL endpoint | Free | Per-session cost, token counts, tool calls |
| 2H.2 | **Datadog MCP** | Official | `claude mcp add --transport http datadog https://mcp.datadoghq.com/...` | Datadog pricing | 16+ tools: logs/metrics/traces/incidents. Replaces archived PostHog/mcp |
| 2H.3 | **Langfuse v3** (self-host) / **v4** (cloud) | 10k+ | Docker-compose (v3 requires MinIO) | Free (self-host) | v3: stable self-host; v4: 10× dashboard speedup (cloud preview, self-host TBD) |
| 2H.4 | **claude-code-otel** | Community | OTEL integration | Free | Dedicated CC observability |
| 2H.5 | **agents-observe** | Community | Hook-based team dashboard | Free | Lightest-weight team-local observability |

#### 2I — Security & Audit

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2I.1 | **Claude Code Security** | Built-in | Native (Opus 4.6, 500+ vulns found) | Free | First-party vulnerability scanning |
| 2I.2 | **Aikido Security** | Plugin | Official marketplace | Free tier | SAST + secrets + IaC misconfiguration |
| 2I.3 | **Trail of Bits Skills** | 800+ | `.claude/skills/` | Free | 12+ professional security audit skills |
| 2I.4 | **OWASP Skill** | Community | Install skill | Free | OWASP Top 10:2025 + ASVS 5.0 + agentic AI security |
| 2I.5 | **ShieldNet** (arxiv 2604.04426) | Research | Network-level behavioral monitoring | Research | F1=0.995 at 0.8% FP against supply-chain-poisoned MCP tools |
| 2I.6 | **agentgateway** | 2.4k | Linux Foundation, Rust | Free | MCP + A2A proxy, open-standard mesh fabric |

#### 2J — Cost & Usage

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 2J.1 | **Native `/cost`** (v2.1.92) | Built-in | Slash command | Free | Per-model + cache-hit breakdown, first-class |
| 2J.2 | **ccusage** | Community | CLI | Free | Supplementary: historical usage analysis |
| 2J.3 | **ccflare** / **better-ccflare** | Community | Web UI / Docker | Free | Dashboard visualization |
| 2J.4 | **Morphic LLM** | Commercial | Proxy | Variable | Cost optimization proxy for high-volume |

### Orbit 3 — Outer Orbit: Orchestration & Multi-Agent

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 3.1 | **oh-my-claudecode** | 4.5k+ | CC plugin/framework | Free | Teams-first orchestration with OMC skills ecosystem |
| 3.2 | **wshobson/agents** | 33.4k | Install | Free | **Tier 1 by ecosystem leverage**: 182 agents + 16 orchestrators + 149 skills + 96 commands + PluginEval quality framework |
| 3.3 | **Claude Squad** | 8k+ | Standalone TUI | Free | Terminal-ops workflow, tmux pane management — still wins over Agent Teams for pure terminal use |
| 3.4 | **ralph-orchestrator** | 2.5k | CLI | Free | Canonical external loop-runner for Ralph Wiggum technique |
| 3.5 | **Spec-Kit** (GitHub) | Official | `uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1` | Free | Spec-driven development: `/speckit.constitution`, `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement` |
| 3.6 | **BMAD-METHOD** | Community | Slash commands | Free | Business analyst + architect + dev agent personas |
| 3.7 | **Superpowers** | 1k+ | CC skill bundle | Free | Core engineering competencies (caveat: Skill-Usage-Bench shows diminishing returns from accumulation) |
| 3.8 | **OpenHands** | 71k | Self-hostable | Free | Walk-away autonomous agent, within 2-6% of frontier on SWE-Bench |
| 3.9 | **Devin** | Commercial | Cloud | $20/mo + per-ACU | Most autonomous walk-away agent, multi-session state |
| 3.10 | **myclaude** | 2.6k | Multi-vendor harness | Free | Vendor-neutral: Claude Code + Codex + Gemini + OpenCode |

### Orbit 4 — Sandbox & Execution Environments

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 4.1 | **Native Linux Sandbox** (v2.1.98) | Built-in | Production-stable | Free | PID namespace + seccomp, no Docker needed |
| 4.2 | **Docker Sandboxes** | Official | `docker` | Free | microVM-based isolation |
| 4.3 | **E2B** | 5k+ | `pip install e2b-code-interpreter` | Free tier + usage | Firecracker microVMs, <200ms cold start |
| 4.4 | **Fly Sprites** | Commercial | `sprite create` (no `--cpu`/`--disk` flags; `--skip-console` for CI) | Usage-based | 100GB NVMe, 8 CPU defaults, persistent sessions |
| 4.5 | **Container Use (Dagger)** | Community | Dagger integration | Free | Dev environments for coding agents |
| 4.6 | **Modal** | Commercial | `modal` CLI | **$0.119-0.142/vCPU-hr** (NOT $0.047 — corpus was wrong) | GPU workloads |
| 4.7 | **Freestyle** | YC-backed | `freestyle.sh` | Usage-based | Snapshot/restore + PR-delivery REST API |

### Orbit 5 — CI/CD & Deployment

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 5.1 | **claude-code-action** | Official (`@v1`, v1.0.93 Apr 10 2026) | GitHub Action | Free | PR review, code implementation, triage |
| 5.2 | **claude-code-security-review** | Official | GitHub Action | Free | Security-focused CI review |
| 5.3 | **`ant` CLI** | Anthropic | Go-based, GitOps for Managed Agents | Free | CI/CD for agent definitions as code |
| 5.4 | **Absurd** | Community | Postgres-only durable execution | Free | LLM agent loop checkpointing — challenges "you need a workflow runtime" assumption |
| 5.5 | **Temporal** | Enterprise | Self-hosted or cloud | Free (self-host) | Enterprise durable execution |

### Orbit 6 — Workstation & Build Loop

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 6.1 | **mise** | 26.6k | Single binary | Free | Replaces asdf + nvm + pyenv + direnv + make. `.mise.toml` gives CC reproducible tool versions |
| 6.2 | **just** | 32.8k | Single binary | Free | Simplest hook target, `justfile` is Claude-readable |
| 6.3 | **Turborepo** | 30.2k | `npm i -g turbo` | Free | `turbo run build --filter=...[HEAD]` limits rebuild to files Claude changed |
| 6.4 | **watchexec** | 6.8k | Single binary | Free | File-watch trigger closing edit→compile loop between Claude turns |
| 6.5 | **devenv 2.0** | 6.7k | Rust C-FFI, <100ms activation | Free | Materially changes inner-loop timing |

### Orbit 7 — LLM Gateway & Model Routing

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 7.1 | **LiteLLM** | 43k | **Pin to v1.83.x+** (v1.82.7-8 compromised with credential-stealing malware) | Free | Only gateway Anthropic officially documents for CC |
| 7.2 | **Vercel AI Gateway** | Official | `ANTHROPIC_BASE_URL=https://ai-gateway.vercel.sh` + `ANTHROPIC_API_KEY=""` (MUST be empty string, not unset) | Free tier | Managed routing with analytics |
| 7.3 | **OpenRouter** | Commercial | API key | Variable | 200+ cloud models without local infra |
| 7.4 | **Ollama** | 169k | Single binary | Free | De facto local inference, native `/anthropic` compat |

### Orbit 8 — MCP Security & Federation (NEW — v3 missed this entirely)

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 8.1 | **agentgateway** | 2.4k | Linux Foundation, Rust | Free | First proxy on both MCP + A2A protocols |
| 8.2 | **IBM mcp-context-forge** | 3.6k | Apache 2.0 | Free | MCP + A2A + REST + gRPC federation with guardrails + OTEL |
| 8.3 | **microsoft/mcp-gateway** | 574 | K8s-native | Free | StatefulSets, session-aware routing for production |
| 8.4 | **MCPSHIELD** (arxiv 2604.05969) | Research | Analysis framework | N/A | 23 MCP attack vectors; single-layer ≤34%, integrated 91%; 177k+ tools analyzed |

### Orbit 9 — Notification & Approval Channels

| # | Component | Stars | Install | Cost | Why This One |
|---|-----------|-------|---------|------|-------------|
| 9.1 | **ntfy.sh** | 29.7k | Self-hostable | Free | Interactive Allow/Deny phone buttons via `claude-ntfy-hook` |
| 9.2 | **Telegram Bot API** | N/A | Free, no self-hosting | Free | Inline keyboard for approval. `claude-notifications-go` plugin |
| 9.3 | **Slack Incoming Webhooks** | N/A | Block Kit | Free | Team environments |

---

## 2. `settings.json` — The Gravitational Field Configuration

The `settings.json` file is the gravitational field — it bends the kernel's behavior without modifying its source. Three scopes cascade with strict precedence: **Managed > Enterprise > User > Project > Local**.

```jsonc
// ~/.claude/settings.json — User scope (personal, not committed)
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",

  // ── Model & Intelligence ──────────────────────────────────────────
  "model": "claude-opus-4-6",                    // NOT "defaultModel"
  "effortLevel": "high",                          // v2.1.94 changed default from medium→high for API/Team/Enterprise
  // NOTE: For Pro subscribers, default is still medium. Set explicitly.

  // ── Permissions ───────────────────────────────────────────────────
  "permissions": {
    "defaultMode": "acceptEdits",                 // NOT "autoAccept"
    "allowedTools": [
      "Read", "Write", "Edit", "Glob", "Grep",
      "Bash(git *)", "Bash(npm *)", "Bash(npx *)",
      "Bash(pnpm *)", "Bash(bun *)",
      "Bash(mise *)", "Bash(just *)",
      "Bash(turbo *)",
      "Bash(uv *)", "Bash(uvx *)",
      "WebSearch", "WebFetch",
      "mcp__github__*",
      "mcp__context7__*",
      "mcp__serena__*",
      "mcp__playwright__*",
      "mcp__sentry__*"
    ],
    "denyTools": [
      "Bash(rm -rf /)*",
      "Bash(git push --force)*",
      "Bash(git push * --force)*",
      "Bash(docker rm -f)*",
      "Bash(kubectl delete)*",
      "Bash(DROP TABLE)*",
      "Bash(curl * | sh)*",
      "Bash(curl * | bash)*"
    ]
  },

  // ── Hooks — Structural Enforcement (100% compliance) ──────────────
  "hooks": {
    // Gate: prevent pushes to main/master
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$TOOL_INPUT\" | jq -r '.command' | grep -qE 'git push.*(main|master)'; then echo '{\"decision\":\"deny\",\"reason\":\"Direct push to main/master blocked. Use a feature branch.\"}'; exit 2; fi"
          }
        ]
      }
    ],
    // Lint: auto-format after file writes
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(echo \"$TOOL_INPUT\" | jq -r '.file_path // .filePath // empty'); if [ -n \"$FILE\" ] && echo \"$FILE\" | grep -qE '\\.(ts|tsx|js|jsx)$'; then npx prettier --write \"$FILE\" 2>/dev/null; fi"
          }
        ]
      }
    ],
    // Context injection: add project state on every prompt
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"message\": \"Current branch: '$(git branch --show-current 2>/dev/null || echo none)' | Last commit: '$(git log --oneline -1 2>/dev/null || echo none)'\"}'"
          }
        ]
      }
    ],
    // Notification: alert on task completion
    "TaskCompleted": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "curl -s -d \"Task completed: $TASK_NAME\" ntfy.sh/my-claude-channel 2>/dev/null || true"
          }
        ]
      }
    ]
  },

  // ── Environment Variables ─────────────────────────────────────────
  "env": {
    // Telemetry (ENABLE_TELEMETRY alone is sufficient for basic metrics)
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    // Enhanced telemetry for distributed traces (beta — only if you want traces)
    // "CLAUDE_CODE_ENHANCED_TELEMETRY_BETA": "1",

    // OTEL endpoint for observability
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://localhost:4318",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "http/protobuf",

    // Agent Teams (experimental)
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",

    // Flicker-free rendering
    "CLAUDE_CODE_NO_FLICKER": "1",

    // Context budget discipline
    "CLAUDE_CODE_MAX_CONTEXT_PERCENTAGE": "60"
  },

  // ── Preferences ───────────────────────────────────────────────────
  "theme": "dark",
  "verbose": false,

  // ── Cost Guard Rails ──────────────────────────────────────────────
  "costThreshold": {
    "warningUsd": 5.0,
    "hardLimitUsd": 25.0
  }
}
```

### Key Schema Traps (verified against primary sources)

| Trap | Wrong | Right |
|------|-------|-------|
| Model field | `defaultModel` | `model` |
| Permission mode | `autoAccept` | `acceptEdits` |
| MCP location | Top-level in settings.json | NEVER — use `~/.claude.json` (user) or `.mcp.json` (project) |
| Skill frontmatter | `allowed_tools` | `allowed-tools` (hyphenated) |
| Telemetry | Both env vars needed | `CLAUDE_CODE_ENABLE_TELEMETRY=1` alone is sufficient for basic metrics |
| Enhanced telemetry | Same as basic | `ENHANCED_TELEMETRY_BETA` exclusively gates distributed-traces beta |
| Vercel AI Gateway | Leave API key unset | `ANTHROPIC_API_KEY=""` — MUST be empty string, not unset |

---

## 3. `CLAUDE.md` — The Gravitational Lens

CLAUDE.md bends the model's reasoning the way a gravitational lens bends light. But there's a compliance ceiling: **~70% adherence**, and a **~150-200 instruction budget** before compliance drops off (the system prompt already uses ~50). This means every line must earn its place.

### Design Principles for CLAUDE.md

1. **Ask "would removing this cause a mistake?"** If not, cut it.
2. **Hooks for enforcement, CLAUDE.md for judgment.** "Don't push to main" belongs in a hook (100% compliance). "Prefer composition over inheritance" belongs in CLAUDE.md (judgment call).
3. **Skills for domain knowledge, CLAUDE.md for cross-cutting concerns.** Don't bloat CLAUDE.md with React patterns — put those in a skill.
4. **`@import` for modularity.** Use `@path/to/file` syntax to import specialized instructions.
5. **Absolute dates, not relative.** "Freeze after Thursday" → "Freeze after 2026-04-15."

```markdown
# CLAUDE.md

## Identity
You are working on [project-name], a [one-line description].
Tech stack: TypeScript, React 19, Next.js 15, Drizzle ORM, PostgreSQL 16, Tailwind CSS 4.

## Architecture Decisions (front-loaded, not discovered)
- Monorepo with Turborepo. Packages: `apps/web`, `packages/ui`, `packages/db`.
- State management: React Server Components + Zustand for client state. No Redux.
- Database: Drizzle ORM with explicit migrations. Never use `db push` in production.
- Auth: Supabase Auth with RLS policies. Never bypass RLS.
- API: tRPC v11 with Zod validation at boundaries only.

## Non-Goals (what NOT to build)
- Do not add i18n until explicitly requested.
- Do not add analytics/tracking unless security-reviewed.
- Do not create abstraction layers for things used in fewer than 3 places.

## Code Style (only what the linter can't catch)
- Prefer `function` declarations over arrow functions for named exports.
- Test files colocated: `foo.ts` → `foo.test.ts` in same directory.
- No barrel files (`index.ts` re-exports). Import from source directly.
- Error messages must be actionable: include what happened, why, and what to do.

## Build & Test
- `just check` — runs typecheck + lint + test (use this before committing)
- `just dev` — starts dev server at localhost:3000
- `turbo run build --filter=...[HEAD]` — rebuild only what changed
- Tests: Vitest for unit, Playwright for e2e. Run `just test` before claiming done.

## Git Protocol
- Branch naming: `feat/`, `fix/`, `refactor/`, `chore/` prefixes.
- Commits: conventional commits. Subject < 72 chars. Body explains WHY.
- Never amend published commits. Create new commits for fixes.
- Never force push to main. Always PR with at least the CI check passing.

## Verification (the bottleneck, not generation)
- After implementation: run tests, check types, verify in browser for UI changes.
- Writer ≠ reviewer. Do not self-approve. Use a separate review pass.
- Structured output passes schema ≠ semantic correctness. Check both.

## Context Budget Discipline
- Compact when context exceeds 60% of window. Earlier is better.
- For large refactors: break into subtasks, each in a fresh context.
- Read only the files you need. Don't `cat` entire directories.

## Security
- Never commit secrets (.env, API keys, credentials).
- Validate at system boundaries only (user input, external APIs). Trust internal code.
- Generate SBOM with `syft` for any new dependency.

@.claude/AGENTS.md
@.claude/DESIGN.md
```

### The 150-Instruction Budget Allocation

| Category | Budget | Rationale |
|----------|--------|-----------|
| Architecture decisions | 25 | Front-loaded, prevents design-decision deferral |
| Non-goals | 10 | Prevent scope creep — highest ROI per instruction |
| Code style | 15 | Only what linters can't enforce |
| Build & test | 10 | Commands Claude needs to verify its work |
| Git protocol | 10 | Structural constraints |
| Verification | 10 | The actual bottleneck |
| Context discipline | 5 | Prevent context window waste |
| Security | 10 | Boundary-only validation |
| Domain-specific (via @import) | 55 | Loaded from skills/imports, not inlined |
| **Total** | **~150** | Leaves headroom for system prompt |

---

## 4. `.mcp.json` — The Tool Surface Declaration

`.mcp.json` is committed to git (shared with team). Credentials go in `~/.claude.json` (user-scope, never committed).

```jsonc
// .mcp.json — Project root, committed to git
{
  "mcpServers": {
    // ── Code Intelligence ───────────────────────────────────────────
    "serena": {
      "type": "stdio",
      "command": "serena",
      "args": ["start-mcp-server", "--context", "ide-assistant", "--project", "."],
      "description": "LSP-powered code intelligence: go-to-def, references, rename, diagnostics"
    },
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      },
      "description": "Live, version-accurate library documentation"
    },

    // ── Project Services ────────────────────────────────────────────
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      },
      "description": "PRs, issues, code search, projects"
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp",
      "description": "Error monitoring — remote HTTP with OAuth, NOT stdio"
    },

    // ── Database ────────────────────────────────────────────────────
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      },
      "description": "Direct PostgreSQL access"
    },

    // ── Browser Testing ─────────────────────────────────────────────
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "description": "Browser automation via accessibility tree"
    },

    // ── Infrastructure ──────────────────────────────────────────────
    "terraform": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@hashicorp/terraform-mcp-server"],
      "description": "Terraform Registry and Cloud APIs"
    },

    // ── Observability ───────────────────────────────────────────────
    "datadog": {
      "type": "http",
      "url": "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp",
      "description": "Logs, metrics, traces, incidents — replaces archived PostHog/mcp"
    },

    // ── Payments ────────────────────────────────────────────────────
    "stripe": {
      "type": "http",
      "url": "https://mcp.stripe.com",
      "description": "25 tools, full payment lifecycle"
    },

    // ── Design ──────────────────────────────────────────────────────
    "figma": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic/figma-mcp"],
      "description": "Design-to-code, canvas manipulation"
    },

    // ── Memory (optional, only if native auto-memory insufficient) ──
    // "mempalace": {
    //   "type": "stdio",
    //   "command": "python",
    //   "args": ["-m", "mempalace.server"],
    //   "description": "Vector memory with 96.6% LongMemEval score"
    // },

    // ── Deployment ──────────────────────────────────────────────────
    "vercel": {
      "type": "http",
      "url": "https://mcp.vercel.com",
      "description": "Deployment logs, project management"
    }
  }
}
```

### MCP Server Selection Principles

1. **Prefer remote HTTP over stdio when available.** Remote servers (Sentry, Stripe, Vercel, Datadog, Linear) are zero-install, always-updated, and don't consume local process slots.
2. **Never put credentials in `.mcp.json`.** Use `${ENV_VAR}` references. Set actual values in `~/.claude.json` or shell environment.
3. **Budget your tool count.** Each MCP server adds tools to the system prompt. 10-15 servers is the practical ceiling before tool-description tokens crowd out working context.
4. **Validate with `claude mcp list`.** After configuration, verify all servers connect successfully.
5. **MCP security is a real concern, not theoretical.** MCPSHIELD (arxiv 2604.05969) found 23 attack vectors. Use agentgateway or IBM mcp-context-forge in production to federate and audit MCP traffic.

### The v2.1.100 MCP HTTP/SSE Memory Leak

Patched in v2.1.100 (Apr 10 2026). Prior versions leaked ~50 MB/hr per MCP HTTP/SSE connection. If running older versions with many HTTP MCP servers, upgrade.

---

## 5. Principles — The Gravitational Laws

These are the laws that govern the system. They are not preferences — they are constraints that, when violated, produce named failure modes.

### Principle 1: Verification is the bottleneck, not generation
**What it means:** The cost of generating code approaches zero. The cost of knowing whether it's correct does not. Every architectural decision must optimize for verification speed, not generation speed.
**What it makes impossible:** Shipping code without running tests. Claiming a UI change works without checking a browser. Self-approving your own output.
**Caveat (Apr 2026):** Structured-output self-reflection produces "formatting traps" — syntactic alignment with schema while missing semantic errors (arxiv 2604.06066). Verification must use prose-level judgment, not just schema validation.

### Principle 2: Design decisions must be front-loaded, not deferred
**What it means:** AI acceleration of implementation causes design-decision deferral — you never have to slow down for the hard call. That deferral corrodes architecture. If the first artifact of a task is code, the task is already broken.
**What it makes impossible:** Starting with code. The sequence is: `research.md` → `plan.md` (with decision records, non-goals, alternatives considered) → code.
**Source:** Simon Willison / Maganti convergence; Boris Tane's "research.md first" workflow.

### Principle 3: Hooks for enforcement, CLAUDE.md for judgment
**What it means:** CLAUDE.md has ~70% compliance. Hooks have 100%. Any rule where 70% compliance = production incident belongs in a hook, not in CLAUDE.md.
**What it makes impossible:** Using CLAUDE.md for "don't push to main" or "don't delete production data."

### Principle 4: Writer ≠ Reviewer (at the model-diversity level)
**What it means:** The same model that wrote the code cannot be the sole reviewer. True verification requires either a different model family (CodeRabbit, Copilot Code Review) or a structurally separate Claude context (Agent Teams with a reviewer teammate).
**What it makes impossible:** `self-approve` in the same context window.
**Why model diversity matters:** A single model has correlated blind spots. A different model family has uncorrelated ones.

### Principle 5: Parallel concurrency has a human ceiling
**What it means:** 3-5 concurrent agents is the productive band. Pick from the low end, not the high end. Named anti-patterns: Comprehension Debt, Ambient Anxiety Tax, Trust Calibration Overhead (Osmani, April 7 2026).
**Rule:** "Start with one fewer agents than feels comfortable."
**What it makes impossible:** Launching 10 parallel agents and expecting coherent output.

### Principle 6: Context budget is the primary resource constraint
**What it means:** Quality degrades at 20-40% of the 200K window. The 60% ceiling is a hard operational constraint, not a suggestion. Earlier compaction is better.
**What it makes impossible:** Loading 10 CLAUDE.md files and 15 MCP servers and expecting good output.
**Corollary:** Skills over CLAUDE.md for domain knowledge. Skills are loaded on demand; CLAUDE.md is loaded every session.

### Principle 7: Native primitives win when they're real
**What it means:** When Anthropic ships a native primitive (Advisor Tool, Agent Teams, Monitor, `defer`, `/cost`), the third-party tool that existed to fill that gap must be re-evaluated. Many should be downgraded to "supplementary."
**What it makes impossible:** Building on top of a third-party abstraction when the kernel already does it.
**Operational rule:** Re-evaluate against Anthropic's changelog monthly, not quarterly.

### Principle 8: Skill-library accumulation has diminishing returns; refinement is the lever
**What it means:** Skill-Usage-Bench (arxiv 2604.04323, 34k real-world skills) shows skill-library gains collapse to near-zero in realistic retrieval. Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench 2.0 only with query-specific refinement, NOT library size.
**What it makes impossible:** "Install more skills to get better results." Measure per-skill outcomes (PluginEval, eval loops, before/after benchmarks). Delete skills that don't improve outcomes.

### Principle 9: Sandbox isolation is non-optional and must be layered
**What it means:** Single-layer defenses cover ≤34% of MCP threats (MCPSHIELD). Integrated architecture reaches 91%. Network-level behavioral monitoring (ShieldNet, F1=0.995) is a required defense layer.
**Named incidents:** Replit 2.5-year wipeout (Claude Code), SaaStr/Replit production DB deletion (July 2025), Mythos agent-escape (Project Glasswing, Apr 2026).
**What it makes impossible:** Running Claude Code with full filesystem access, no sandbox, and trusting the instruction to "be careful."

### Principle 10: The supply chain is now the largest attack surface
**What it means:** AI-generated codebases have no human reader who would notice a compromised transitive dependency. The transitive dependency graph is nobody's responsibility by construction. LiteLLM PyPI v1.82.7-8 was compromised with credential-stealing malware in March 2026.
**What it makes impossible:** Shipping without continuous SBOM generation (syft, cyclonedx, Dependabot). Every new dependency must be audited.
**Source:** Drew Breunig "Winchester Mystery House" + Andrew Nesbitt "Cathedral and the Catacombs."

### Principle 11: CI must use API billing, not subscription
**What it means:** Anthropic explicitly cut subscription access for non-Anthropic harnesses (Cline, Cursor, Windsurf, OpenClaw) on April 4 2026. This went from policy text to enforcement action. CI/CD and headless automation must use API billing.
**What it makes impossible:** Running `claude --print` in CI on a Max subscription long-term.

### Principle 12: Destructive ops need structural gates, not advisory warnings
**What it means:** "Are you sure?" is not a gate. A PreToolUse hook returning `deny` is. A `defer` decision that pauses for phone-button approval is.
**Named incidents:** Replit 2.5-year wipeout, SaaStr production DB deletion.
**What it makes impossible:** Relying on CLAUDE.md to prevent `rm -rf` or `DROP TABLE`.

### Principle 13: Benchmarks lie without realistic-conditions replication
**What it means:** ClawBench measured ~70% sandbox performance vs 6.5% in realistic conditions — a 10× eval-validity gap. Never trust a benchmark without running it on 10 real tasks from your own repo.
**What it makes impossible:** Adopting a component based on its SWE-Bench score alone.

### Principle 14: The effortLevel default change is a cost trap
**What it means:** v2.1.94 (Apr 7 2026) changed `effortLevel` default from `medium` → `high` for API/Bedrock/Vertex/Foundry/Team/Enterprise (NOT Pro). Any cost model based on medium-default is stale.
**What it makes impossible:** Ignoring the effortLevel setting and wondering why costs doubled.

### Principle 15: One fewer agent than feels comfortable
**What it means:** This is Principle 5's operational corollary, stated as a rule. When you're about to launch N agents, launch N-1 instead. The coordination overhead of the Nth agent exceeds its marginal contribution more often than not.
**What it makes impossible:** The "throw more agents at it" reflex.

---

## 6. Unique Insight: The Orbital Decay Pattern

Here is the architectural insight that no flat catalog can give you:

**The Claude Code ecosystem is experiencing orbital decay.** Every week, Anthropic ships a native primitive that pulls a capability from an outer orbit into the core. This is not random — it follows a predictable pattern:

1. **Community builds it** (outer orbit): Claude Squad, ccusage, custom model-routing scripts
2. **Anthropic observes adoption** (measurement): Which patterns get 1k+ stars? Which workflows are everyone doing manually?
3. **Anthropic ships it natively** (gravity collapse): Agent Teams, `/cost`, Advisor Tool, Monitor tool
4. **Community tool becomes supplementary** (orbital decay): Still useful for edge cases, but no longer load-bearing

**The implication for system design:** Don't build your architecture on the assumption that any particular third-party tool will remain primary. Build it in orbits, with explicit gravitational relationships, so that when a tool decays you know exactly what replaces it and what depends on it.

**The April 2026 phase transition specifically:**

| What Collapsed | From (Orbit) | To (Orbit) | What Got Demoted |
|---------------|-------------|------------|-----------------|
| Model pairing (fast+smart) | Outer orbit orchestrators | Core (Advisor Tool) | BMAD architect/dev split, custom Haiku→Opus routing |
| Background process observation | Middle orbit (polling scripts) | Core (Monitor tool) | Custom `tail -f` + hook patterns |
| Cost visibility | Middle orbit (ccusage, kerf-cli) | Core (`/cost`) | Third-party cost dashboards as primary |
| Headless human-gate | Outer orbit (custom webhook approval) | Core (`defer`) | Bespoke webhook-pause patterns |
| Process isolation on Linux | Outer orbit (Docker for sandboxing) | Core (native seccomp+PID namespace) | Docker-as-sandbox for simple cases |

**What hasn't collapsed yet (and probably will):**
- **Memory:** Native auto-memory is basic. mempalace/claude-mem still add value. But watch for native vector memory.
- **MCP federation:** agentgateway/IBM are outer orbit. If Anthropic ships native MCP governance, they decay.
- **Code intelligence:** Serena fills a gap. If CC ships native LSP, Serena decays.
- **Walk-away agents:** Managed Agents is the early kernel version. OpenHands/Devin still differentiate. Watch for Managed Agents v2.

**The design rule:** For each component in your system, know which orbit it's in, what it depends on, and what would cause it to decay. When it does decay, the migration should be a configuration change (swap a MCP server, remove a hook), not an architecture rewrite.

### The Counter-Pattern: Orbital Escape Velocity

Not everything decays inward. Some community tools achieve **escape velocity** — they do something so orthogonal to Anthropic's interests that they'll never be absorbed:

- **wshobson/agents** (33.4k★) — PluginEval quality framework. Anthropic won't build a community-facing eval harness.
- **agentgateway** (Linux Foundation) — Multi-vendor federation. Anthropic won't build a tool that routes to OpenAI.
- **CodeRabbit** — Cross-model review. Anthropic won't build a tool that uses GPT-4 to review Claude's output.
- **mise** — Dev tool version management. Completely orthogonal to AI.
- **ntfy.sh** — Push notifications. Not an AI feature.

**These are the safe bets.** Build on components with escape velocity. Treat everything else as potentially temporary.

### The Monthly Checkpoint

Every month, run this checklist:
1. Read the Claude Code changelog for the past 30 days
2. For each new native feature, identify which orbit-3+ component it partially or fully replaces
3. If a component decayed, update `.mcp.json` and `settings.json` to use the native primitive
4. If a component didn't decay but the native version is close, add a comment noting the likely timeline
5. Re-measure: is your total tool count still under the 10-15 server budget? Is your CLAUDE.md still under 150 instructions?

This is not maintenance. This is **gravitational housekeeping** — the price of building on a platform that's evolving faster than any ecosystem in history.

---

## Appendix A: Named Failure Modes

| # | Failure Mode | Source | Canary Signal | Defense |
|---|-------------|--------|---------------|---------|
| 1 | Formatting trap in structured-output self-reflection | arxiv 2604.06066 | Schema-pass rate diverges from manual-audit pass rate | Prose-level critic agents + schema validation |
| 2 | Skill-library collapse in realistic retrieval | arxiv 2604.04323 | Eval score flat while library grows | PluginEval / split-test per skill; delete non-performing skills |
| 3 | Greenfield CLI generation ceiling (<43%) | arxiv 2604.06742 | CLI-task success flat despite effortLevel increases | Advisor Tool pattern + human checkpoints at architecture decisions |
| 4 | LiteLLM PyPI supply-chain compromise | v1.82.7-8 malware | Unexpected outbound connections | Pin to 1.83.x+; rotate all API keys |
| 5 | Mythos agent-escape (Project Glasswing) | Anthropic Apr 7 2026 | Outbound connections from sandboxed agent | Layered sandbox + network egress policy + Cedar policies |
| 6 | ClawBench eval-validity gap (70% sandbox vs 6.5% realistic) | AI Engineer Europe Apr 10 | Blueprint recommends based on sandbox benchmark | Run on 10 real tasks from your own repo before adopting |
| 7 | Winchester Mystery House (AI-generated codebase with no human reader) | Drew Breunig Mar 26 | Transitive dependency graph nobody monitors | Continuous SBOM + ShieldNet |
| 8 | Design-decision deferral | Willison/Maganti convergence | Working prototype scrapped because architecture was wrong | research.md → plan.md → code (never code first) |
| 9 | effortLevel cost trap | v2.1.94 default change Apr 7 | Costs doubled without config change | Set effortLevel explicitly in settings.json |
| 10 | MCP HTTP/SSE memory leak (~50 MB/hr) | v2.1.100 fix Apr 10 | Growing RSS on long sessions with HTTP MCP | Upgrade to v2.1.100+ |
| 11 | 80× thrashing (GitHub #42796) | Community report | API costs spike on repeated tool-call loops | Cost threshold in settings.json + Monitor tool for background detection |
| 12 | Replit 2.5-year data wipeout | Named incident | Destructive command in auto-approved session | PreToolUse deny hook for destructive ops |
| 13 | SaaStr/Replit production DB deletion | July 2025 | Destructive DB command during code freeze | `defer` + phone approval for production DB access |
| 14 | Subscription enforcement (Apr 4 2026) | Anthropic policy action | CI pipeline using Max subscription stops working | Use API billing for all non-interactive use |
| 15 | Comprehension Debt from too many parallel agents | Osmani Apr 7 | Developer can't track what agents are doing | N-1 rule; 3-5 agent band; start from low end |
| 16 | MCP tool poisoning (single-layer ≤34% coverage) | MCPSHIELD arxiv 2604.05969 | Unusual MCP tool behavior | agentgateway + ShieldNet + SBOM |

## Appendix B: The Budget

| Component | Monthly Cost |
|-----------|-------------|
| Claude Max subscription | $200 |
| Everything else in this document | $0 (free/open-source/included) |
| **Total** | **$200/mo** |

The entire system runs on a single Max subscription. API billing is only needed for CI/CD headless use, which would be additional. Every MCP server, plugin, skill, hook, and orchestration tool listed here is free or open-source. The $200 buys the kernel; the ecosystem is free.

## Appendix C: Quick Start (5 commands)

```bash
# 1. Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# 2. Initialize project
cd your-project && claude /init

# 3. Add essential MCP servers
claude mcp add github -- npx -y @modelcontextprotocol/server-github
claude mcp add playwright -- npx @playwright/mcp@latest
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# 4. Enable agent teams
echo '{"env":{"CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS":"1"}}' | \
  jq -s '.[0] * .[1]' ~/.claude/settings.json - > /tmp/s.json && \
  mv /tmp/s.json ~/.claude/settings.json

# 5. Start with planning, not coding
claude "Read the codebase and create a plan for [your task] in plan.md"
```

---

*End of Architecture 07 — The Gravitational Model*
