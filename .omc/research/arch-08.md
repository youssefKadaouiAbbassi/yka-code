# Architecture 08 — The Stateless Harness as Operating System

**Architect 8 of 10 — Independent design, April 12 2026**

---

## Unique Insight: The Harness Is an OS, Not a Tool — and Your `.claude/` Directory Is `/etc/`

The conventional framing treats Claude Code as "a coding assistant with plugins." This is wrong in the same way calling Unix "a program that runs other programs" is wrong. Claude Code in April 2026 is a **userspace operating system** whose kernel is the Claude model, whose syscalls are tools (Bash, Read, Edit, Write, Grep, Glob, Agent, WebSearch...), whose device drivers are MCP servers, whose process model is subagents and Agent Teams, whose filesystem is the project directory + git worktrees, whose init system is `CLAUDE.md`, and whose `/etc/` is `~/.claude/` + `.claude/` + `settings.json`.

This reframe is not metaphorical. It is architecturally precise:

| OS Concept | Claude Code Equivalent | Evidence |
|---|---|---|
| Kernel | Claude Opus 4.6 / Sonnet 4.6 model | Stateless, re-instantiated per syscall boundary (Anthropic engineering: "Stateless Harness + Durable Event Sourcing") |
| Syscalls | Built-in tools (Bash, Read, Edit, Agent, etc.) | Fixed set, permission-gated, the only way to affect the world |
| Device drivers | MCP servers | Dynamically loaded, schema-negotiated, hot-pluggable at runtime via Tool Search |
| Shared libraries | Skills (`.md` files with frontmatter) | Loaded on demand, provide capabilities without modifying the kernel |
| Packages | Plugins (`.claude-plugin/plugin.json`) | Bundle skills + MCP servers + hooks + `bin/` executables (v2.1.91: auto-PATH) |
| Process model | Subagents (ephemeral) / Agent Teams (persistent peers) | Fork-like isolation, message passing, worktree = process address space |
| Init system | `CLAUDE.md` hierarchy (global → project → local → folder) | Read at boot, configures all subsequent behavior |
| `/etc/` | `~/.claude/settings.json` + `.claude/settings.json` + `.claude/settings.local.json` | Hierarchical config with managed overrides from enterprise admin |
| Device nodes (`/dev/`) | `.mcp.json` (project) + `~/.claude.json` (user) | Maps logical tool names to transport endpoints |
| Cron | Hooks (`PreToolUse`, `PostToolUse`, 26 events total) + CronCreate | Event-driven automation, deterministic execution |
| IPC | `SendMessage` tool + TaskCreate/TaskUpdate | Typed messaging between agents, shared work queues |
| Supervisor / systemd | Advisor Tool (server-side executor+advisor split) | Kernel-level process supervision pattern, April 9 2026 |
| Package manager | `claude install <plugin>`, OpenClaw registry (13,729+ skills), marketplace subscriptions | Install, update, discover capabilities |

**Why this matters for system design:** Once you see the harness as an OS, you stop asking "what plugins should I install?" and start asking "what is my boot sequence, what are my security policies, what is my process isolation model, and what is my driver stack?" Those are the questions this architecture answers.

The corollary: **most people are running their OS with no `/etc/`, no firewall, no process isolation, and every driver loaded into kernel space.** That's the default Claude Code experience. This architecture is the equivalent of a properly configured production Linux system.

---

## 1. The Complete System Table

### Tier 0 — Kernel & Core Primitives (Ships with Claude Code, zero install)

| # | Category | Component | What It Is | Cost | Why It's Here |
|---|---|---|---|---|---|
| 1 | **Model kernel** | Claude Opus 4.6 | Primary model (Feb 5 2026). Default `effortLevel: high` since v2.1.94 (Apr 7) for API/Team/Enterprise users | Max $200/mo or API billing | The CPU |
| 2 | **Model kernel** | Claude Sonnet 4.6 | Fast executor model (Feb 17 2026). Use for high-throughput parallel agents | Included in Max / API | The co-processor |
| 3 | **Model kernel** | Claude Haiku 4.5 | Lightweight model for quick lookups, status checks, linting passes | Included in Max / API | The microcontroller |
| 4 | **Advisor primitive** | Advisor Tool | Server-side Haiku/Sonnet executor + Opus advisor in single API call. Beta header: `advisor-tool-2026-03-01`. Haiku+Opus scored 41.2% on SWE-bench vs 19.7% solo at 85% lower cost | API billing only | Collapses orchestration into kernel |
| 5 | **Process model** | Subagents (`Agent` tool) | Ephemeral workers with `isolation: "worktree"`. Fork-like semantics, auto-cleanup | Free (native) | Process isolation |
| 6 | **Process model** | Agent Teams | Persistent peer coordination. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. SendMessage + TaskCreate + worktree isolation | Free (native, experimental) | Multi-process orchestration |
| 7 | **Managed compute** | Managed Agents | Anthropic-hosted headless sessions. `managed-agents-2026-04-01`. $0.08/session-hour | API billing | Serverless compute |
| 8 | **Session primitive** | Monitor tool | Stream events from `run_in_background` scripts (v2.1.98) | Free (native) | Process monitoring |
| 9 | **Permission primitive** | `defer` decision | PreToolUse hooks can return `"defer"` to pause headless sessions for external approval (v2.1.89). 0.4% FP in production | Free (native) | Supervisor call |
| 10 | **CLI companion** | `ant` CLI | Anthropic CLI for versioning agents, skills, beta headers in YAML. GitOps for Managed Agents | Free | Package manifest tool |
| 11 | **Sandbox** | Native Linux sandbox | PID namespace + seccomp isolation, production-stable since v2.1.98 | Free (native) | Kernel-level containment |
| 12 | **Cost introspection** | `/cost` command | Per-model + cache-hit breakdown (v2.1.92). First-class native cost tooling | Free (native) | Resource accounting |

### Tier 1 — Init System & Configuration (Zero cost, high leverage)

| # | Category | Component | What It Is | Cost | Why It's Here |
|---|---|---|---|---|---|
| 13 | **Init** | `CLAUDE.md` hierarchy | Global (`~/.claude/CLAUDE.md`) → Project (`.claude/CLAUDE.md`) → Local → Folder-level. Boot sequence for every session | Free | The init system |
| 14 | **Config** | `settings.json` hierarchy | User → Project shared → Project local → Enterprise managed. 60+ settings, 170+ env vars | Free | `/etc/` equivalent |
| 15 | **Device map** | `.mcp.json` (project) / `~/.claude.json` (user) | MCP server declarations. Project-scope for team sharing | Free | Device node registry |
| 16 | **Hooks engine** | 26 hook events | PreToolUse, PostToolUse, Notification, Stop, SubagentStop, UserPromptSubmit, etc. 12 blocking events. 4 handler types: command, prompt, agent, http | Free | Event-driven automation |
| 17 | **Permissions** | `allowedTools` / `deniedTools` | Ordered rule evaluation: deny → ask → allow. Pattern: `Tool(specifier)`. Cedar policy syntax highlighting (v2.1.100) | Free | Security policy |
| 18 | **Context compression** | `claude-token-efficient` | Universal CLAUDE.md system-prompt shaping (471 HN pts — highest-scoring context item in window) | Free | Boot image compression |

### Tier 2 — Essential Device Drivers (MCP Servers)

| # | Category | Component | Install | Cost | Why It's Here |
|---|---|---|---|---|---|
| 19 | **Code intelligence** | GitHub MCP Server | `claude mcp add github -- npx -y @modelcontextprotocol/server-github` | Free | PRs, issues, repo management — the primary development surface |
| 20 | **Code intelligence** | Serena v1.1.0 | `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` | Free | LSP-grade code graph, cross-file navigation. **Install command updated Apr 11 2026** |
| 21 | **Code intelligence** | ast-grep MCP | `claude mcp add ast-grep -- npx -y @ast-grep/ast-grep-mcp` | Free | Structural pattern search over 20+ languages via tree-sitter (13.4k stars) |
| 22 | **Documentation** | Context7 | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest --api-key <KEY>` | Free (rate-limited without key) | Live version-accurate library docs. **Now requires API key** |
| 23 | **Browser** | Playwright MCP | `claude mcp add playwright -- npx -y @playwright/mcp@latest` | Free | Browser automation, E2E testing, visual verification |
| 24 | **Error tracking** | Sentry MCP | Remote HTTP OAuth at `https://mcp.sentry.dev/mcp` — no local install | Free tier | Production error context. **Use remote HTTP, not stdio** |
| 25 | **Database** | PostgreSQL MCP | `claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres` | Free | Direct database access (use read-only credentials) |
| 26 | **Database** | Supabase MCP | Via plugin or `claude mcp add supabase -- npx -y supabase-mcp-server` | Free tier | Full backend: DB + auth + storage + edge functions |
| 27 | **Observability** | Datadog MCP | `claude mcp add --transport http datadog https://mcp.datadoghq.com/api/unstable/mcp-server/mcp` | Free tier | Logs/metrics/traces/incidents. **Replaces archived PostHog/mcp** |
| 28 | **Cloud** | Terraform MCP | `claude mcp add terraform -- npx -y @hashicorp/terraform-mcp-server` | Free | IaC management |
| 29 | **Memory** | mempalace | `pip install mempalace` | Free | 23k stars, 19 MCP tools, 96.6% LongMemEval. Vector-backed persistent memory |
| 30 | **Payments** | Stripe MCP | Remote HTTP at `mcp.stripe.com` | Free | Official Anthropic partner, 25 tools |
| 31 | **Design** | Figma MCP | Official Anthropic partner plugin | Free | Design-to-code pipeline |
| 32 | **Search** | Brave Search MCP | `claude mcp add brave-search -- npx -y @anthropic/mcp-server-brave-search` | Free tier | Privacy-focused web search |
| 33 | **Deployment** | Vercel MCP | Remote HTTP at `mcp.vercel.com` with OAuth | Free tier | Deploy, logs, project management |
| 34 | **Project mgmt** | Linear MCP | Remote HTTP at `mcp.linear.app` | Free tier | Issue tracking, project boards |

### Tier 3 — Userspace Programs (Skills, Plugins, Orchestrators)

| # | Category | Component | What It Is | Cost | Why It's Here |
|---|---|---|---|---|---|
| 35 | **Orchestration** | oh-my-claudecode (OMC) | Teams-first multi-agent orchestration. Autopilot, ralph, ultrawork, team modes. 4.5k stars | Free | The systemd of Claude Code |
| 36 | **Orchestration** | wshobson/agents | 33.4k stars, MIT. 182 agents + 16 orchestrators + 149 skills + 96 commands. Ships PluginEval quality framework | Free | **Tier 1 ecosystem substrate** — largest CC agent library |
| 37 | **Orchestration** | Claude Squad | 8k+ stars. TUI for managing multiple agents in isolated worktrees | Free | Terminal-native multi-agent |
| 38 | **Orchestration** | ralph-orchestrator | 2.5k stars. Canonical external loop-runner implementing Ralph Wiggum technique | Free | Autonomous loop primitive |
| 39 | **Skills** | Superpowers (obra) | 1k+ stars. Core software engineering competencies bundle | Free | Baseline skill library — but see Principle 11 on diminishing returns |
| 40 | **Skills** | Trail of Bits Security | 800+ stars. 12+ professional security-focused skills | Free | Security audit capability |
| 41 | **Skills** | Spec-Kit (GitHub) | `uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1` | Free | Specification-driven development |
| 42 | **Plugin framework** | BMAD-METHOD | Structured workflow with architect+dev separation | Free | Discipline framework |
| 43 | **Config** | SuperClaude Framework | CLAUDE.md configuration framework with commands and personas | Free | System prompt engineering |
| 44 | **Config** | ContextKit | Systematic 4-phase development framework | Free | Structured development lifecycle |
| 45 | **Workflow** | Simone | Project management workflow with documents and guidelines | Free | PM-oriented workflow |

### Tier 4 — Infrastructure & Security Layer

| # | Category | Component | What It Is | Cost | Why It's Here |
|---|---|---|---|---|---|
| 46 | **LLM Gateway** | LiteLLM | 43k stars, MIT. Only gateway Anthropic officially documents. **Pin to v1.83.x+ — v1.82.7-8 compromised with credential-stealing malware** | Free (self-host) | Model routing, budget caps, audit |
| 47 | **Sandbox** | Docker Sandboxes | Official Docker microVM-based isolation | Free | Heavy containment for untrusted code |
| 48 | **Sandbox** | E2B | Cloud sandboxes for code execution | Free tier | Ephemeral compute |
| 49 | **Sandbox** | Freestyle | YC-backed cloud sandboxes with snapshot/restore + PR-delivery REST API (322 HN pts) | Free tier | Agent-native sandbox |
| 50 | **CI/CD** | claude-code-action | Official GitHub Action v1.0.93 (Apr 10 2026). PR review, code implementation, triage | Free | CI integration |
| 51 | **CI/CD** | claude-code-security-review | Official Anthropic security-focused GitHub Action | Free | Automated security review |
| 52 | **Code review** | CodeRabbit | 2M+ repos, 82% bug-catch rate. Cross-vendor model diversity | Free tier / $15/mo | Writer ≠ reviewer at model-diversity level |
| 53 | **MCP security** | agentgateway | 2.4k stars, Linux Foundation, Rust. Proxy for both MCP and A2A protocols | Free | MCP layer security |
| 54 | **MCP security** | IBM mcp-context-forge | 3.6k stars. Federates MCP + A2A + REST + gRPC with guardrails + OTEL | Free | Enterprise MCP governance |
| 55 | **Observability** | Langfuse v3 (self-host) | Tracing + prompt management. Requires MinIO for Docker Compose. v4 cloud preview is 10x faster but self-host path TBD | Free (self-host) | LLM observability |
| 56 | **Observability** | claude-code-otel | OpenTelemetry integration for CC usage/costs | Free | OTEL-native telemetry |
| 57 | **Cost** | ccusage | CLI for CC usage metrics. Supplementary to native `/cost` | Free | Detailed usage analytics |
| 58 | **Supply-chain** | Aikido Security plugin | SAST + secrets + IaC misconfiguration scanning | Free tier | Automated security scanning |

### Tier 5 — Walk-Away & Autonomous Layer

| # | Category | Component | What It Is | Cost | Why It's Here |
|---|---|---|---|---|---|
| 59 | **Autonomous agent** | OpenHands | 71k stars, MIT. Within 2-6% of frontier on SWE-Bench Verified, self-hostable | Free | Walk-away coding agent |
| 60 | **Autonomous agent** | open-swe (LangChain) | 9.5k stars, MIT. Enterprise async agent with sandbox providers, Slack/Linear triggers | Free | Self-hosted Devin alternative |
| 61 | **Notification** | ntfy.sh | 29.7k stars. Self-hostable push notifications with interactive Allow/Deny buttons | Free | `defer` decision notification channel |
| 62 | **Durable execution** | Absurd | Postgres-only durable execution for agent loop checkpointing. 5 months production | Free | Checkpoint/resume for long loops |
| 63 | **Self-improving** | NousResearch/hermes-agent v0.8.0 | 57.9k stars. Self-improving agent creating skills from experience | Free | Meta-engineering |
| 64 | **Build loop** | mise | 26.6k stars. Replaces asdf + nvm + pyenv + direnv + make in one binary | Free | Reproducible tool versions for Claude's Bash |
| 65 | **Build loop** | just | 32.8k stars. Simple command runner, Claude-readable justfile | Free | Self-documenting task runner |
| 66 | **Knowledge** | Karpathy LLM Wiki / qmd | Obsidian Markdown as compiled knowledge base with BM25/vector local MCP search | Free | Refinement-based knowledge (per Skill-Usage-Bench) |

---

## 2. settings.json — The Complete `/etc/` Configuration

```jsonc
{
  // ──────────────────────────────────────────────
  // §1  SCHEMA & MODEL KERNEL
  // ──────────────────────────────────────────────
  "$schema": "https://claude.ai/schemas/settings.json",

  // Primary model — NOTE: the key is "model", NOT "defaultModel"
  "model": "claude-opus-4-6",

  // ──────────────────────────────────────────────
  // §2  PERMISSIONS — The Security Policy
  // Evaluation order: deny first, then ask, then allow.
  // First matching rule wins.
  // Pattern: "Tool" or "Tool(specifier)"
  // ──────────────────────────────────────────────
  "permissions": {
    "defaultMode": "acceptEdits",

    "allow": [
      // Safe read-only tools — always allow
      "Read",
      "Glob",
      "Grep",
      "WebSearch",
      "WebFetch",

      // Agent spawning — core process model
      "Agent",
      "TaskCreate",
      "TaskUpdate",
      "TaskGet",
      "TaskList",
      "SendMessage",

      // File operations — acceptEdits covers Edit/Write with user review
      "Edit",
      "Write",
      "NotebookEdit",

      // Controlled execution
      "Bash(git *)",
      "Bash(npm test*)",
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(pnpm *)",
      "Bash(yarn *)",
      "Bash(bun *)",
      "Bash(cargo *)",
      "Bash(go *)",
      "Bash(python *)",
      "Bash(uv *)",
      "Bash(mise *)",
      "Bash(just *)",
      "Bash(make *)",
      "Bash(docker *)",
      "Bash(kubectl *)",
      "Bash(terraform *)",
      "Bash(gh *)",
      "Bash(jq *)",
      "Bash(curl *)",
      "Bash(cat *)",
      "Bash(ls *)",
      "Bash(find *)",
      "Bash(head *)",
      "Bash(tail *)",
      "Bash(wc *)",
      "Bash(sort *)",
      "Bash(diff *)",
      "Bash(echo *)",
      "Bash(mkdir *)",
      "Bash(cp *)",
      "Bash(mv *)",
      "Bash(which *)",
      "Bash(env *)",
      "Bash(pwd)",
      "Bash(date)",

      // MCP tools — allow all by default, deny dangerous ones explicitly
      "mcp__*"
    ],

    "deny": [
      // NEVER allow destructive git operations without explicit ask
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Bash(git clean -f*)",
      "Bash(rm -rf *)",
      "Bash(rm -r /*)",

      // Block credential-exfiltrating patterns
      "Bash(*curl*anthropic*key*)",
      "Bash(*wget*anthropic*key*)",

      // Block interactive commands that hang
      "Bash(git rebase -i*)",
      "Bash(git add -i*)",
      "Bash(vim *)",
      "Bash(nano *)",
      "Bash(less *)"
    ]
  },

  // ──────────────────────────────────────────────
  // §3  HOOKS — Event-Driven Automation
  // 26 events, 12 blocking, 4 handler types
  // ──────────────────────────────────────────────
  "hooks": {
    // Auto-format on file write
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$CLAUDE_TOOL_ARG_FILE_PATH\" =~ \\.(ts|tsx|js|jsx)$ ]]; then npx prettier --write \"$CLAUDE_TOOL_ARG_FILE_PATH\" 2>/dev/null; elif [[ \"$CLAUDE_TOOL_ARG_FILE_PATH\" =~ \\.py$ ]]; then ruff format \"$CLAUDE_TOOL_ARG_FILE_PATH\" 2>/dev/null; elif [[ \"$CLAUDE_TOOL_ARG_FILE_PATH\" =~ \\.rs$ ]]; then rustfmt \"$CLAUDE_TOOL_ARG_FILE_PATH\" 2>/dev/null; fi"
          }
        ]
      },
      // Security scan on Bash execution
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$CLAUDE_TOOL_ARG_COMMAND\" | grep -qE '(curl|wget).*(-d|--data|POST)'; then echo 'WARNING: outbound data transfer detected' >&2; fi"
          }
        ]
      }
    ],

    // Gate destructive operations
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$CLAUDE_TOOL_INPUT\" | jq -r '.command' | grep -qE '^(rm -rf|git push --force|git reset --hard|DROP TABLE|DELETE FROM)'; then echo '{\"decision\": \"deny\", \"reason\": \"Destructive operation requires explicit user confirmation\"}'; else echo '{\"decision\": \"allow\"}'; fi"
          }
        ]
      }
    ],

    // Notification on completion
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "curl -s -o /dev/null \"https://ntfy.sh/claude-$(whoami)\" -d \"$CLAUDE_NOTIFICATION_TITLE: $CLAUDE_NOTIFICATION_MESSAGE\" 2>/dev/null || true"
          }
        ]
      }
    ],

    // Log all tool usage for observability
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo \"$(date -Iseconds) session_end cost=$CLAUDE_SESSION_COST tokens=$CLAUDE_SESSION_TOKENS\" >> ~/.claude/session-log.jsonl 2>/dev/null || true"
          }
        ]
      }
    ]
  },

  // ──────────────────────────────────────────────
  // §4  ENVIRONMENT — Kernel Parameters
  // ──────────────────────────────────────────────
  "env": {
    // Telemetry (basic metrics — NOT enhanced beta)
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",

    // Rendering
    "CLAUDE_CODE_NO_FLICKER": "1",

    // Agent Teams (experimental)
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",

    // Gateway routing (uncomment if using LiteLLM)
    // "ANTHROPIC_BASE_URL": "http://localhost:4000",
    // "ANTHROPIC_CUSTOM_HEADERS": "",

    // Sandbox enforcement
    "CLAUDE_CODE_SANDBOX_STRATEGY": "native"
  },

  // ──────────────────────────────────────────────
  // §5  ATTRIBUTION
  // ──────────────────────────────────────────────
  "attribution": {
    "gitCommitTrailer": "Co-Authored-By: Claude <noreply@anthropic.com>",
    "gitCommitMessage": ""
  },

  // ──────────────────────────────────────────────
  // §6  CONTEXT & PERFORMANCE
  // ──────────────────────────────────────────────
  "contextCompression": true,
  "maxTurnsPerSession": 200
}
```

### Environment-Specific Overrides

**`.claude/settings.json`** (project-level, committed to git):
```jsonc
{
  "$schema": "https://claude.ai/schemas/settings.json",
  "permissions": {
    "allow": [
      // Project-specific tools
      "Bash(docker compose *)",
      "Bash(pnpm exec prisma *)"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$CLAUDE_TOOL_ARG_FILE_PATH\" =~ \\.prisma$ ]]; then npx prisma format; fi"
          }
        ]
      }
    ]
  }
}
```

**`.claude/settings.local.json`** (personal, gitignored):
```jsonc
{
  "model": "claude-sonnet-4-6",  // Use Sonnet for fast iteration
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:4000"  // Local LiteLLM proxy
  }
}
```

---

## 3. CLAUDE.md — The Init System

```markdown
# CLAUDE.md — System Boot Sequence

## Identity

You are a senior software engineer working in this codebase.
You write minimal, correct, well-tested code.
You do not add features, abstractions, or "improvements" beyond what was asked.

## Architecture Decision: Research Before Code

The first artifact of any non-trivial task is NEVER code. It is:
1. `research.md` — what exists, what's been tried, what failed
2. `plan.md` — explicit decisions, non-goals, alternatives rejected
3. Then code.

If the first artifact is code, the task is already broken.
(Source: Willison "Eight Years / Three Months", Tane "research.md first")

## Build & Test

```bash
# Install dependencies
pnpm install

# Run tests (always run before committing)
pnpm test

# Run specific test file
pnpm test -- path/to/file.test.ts

# Type check
pnpm typecheck

# Lint
pnpm lint

# Build
pnpm build

# Dev server
pnpm dev
```

## Code Style

- TypeScript strict mode. No `any` unless unavoidable and commented.
- Prefer `const` over `let`. Never `var`.
- Named exports only. No default exports.
- Error handling: fail fast, fail loud. No silent catches.
- Tests: colocate with source (`foo.test.ts` next to `foo.ts`).
- Imports: absolute paths from `@/` alias.
- No barrel files (`index.ts` re-exports).
- Commit messages: imperative mood, <72 chars, explain WHY not WHAT.

## Verification Protocol

Before claiming any task complete:
1. `pnpm typecheck` passes with zero errors
2. `pnpm test` passes — all tests green
3. `pnpm lint` passes — zero warnings
4. If UI change: visually verify in browser, test golden path + edge cases
5. If API change: test with actual HTTP requests
6. No new `console.log` left in committed code

## Git Workflow

- Work in feature branches: `feat/description`, `fix/description`
- Commit early and often. Atomic commits.
- Never force push to main/master.
- Never amend published commits.
- Always run hooks (never `--no-verify`).

## Agent Coordination

- Use subagents for research that would bloat main context.
- Use `isolation: "worktree"` for parallel implementation work.
- Agent count: start with ONE fewer than feels comfortable (Osmani).
- Practical band: 2-4 parallel agents for most tasks.

## What Not To Do

- Don't add comments to code you didn't change.
- Don't refactor adjacent code "while you're in there."
- Don't add error handling for impossible scenarios.
- Don't create abstractions for one-time operations.
- Don't install new dependencies without explicit approval.
- Don't write documentation files unless asked.
- Don't summarize what you just did — the diff speaks.

## Security

- Never commit secrets, API keys, or credentials.
- Always use parameterized queries for SQL.
- Validate all user input at system boundaries.
- Trust internal code and framework guarantees.
- Check OWASP Top 10 for web-facing changes.

## Context Budget

This file is loaded into every session. Keep it under 150 lines.
Link to detailed docs instead of inlining them.
Use file:line references, not code snippets (they go stale).
```

### Folder-Level CLAUDE.md Example

**`src/api/CLAUDE.md`**:
```markdown
# API Layer

## Conventions
- All handlers in `src/api/routes/`
- Middleware in `src/api/middleware/`
- Validation: Zod schemas colocated with route handlers
- Response format: `{ data, error, meta }` envelope
- Auth: JWT via `src/api/middleware/auth.ts` — don't reinvent

## Testing
```bash
pnpm test -- src/api/**/*.test.ts
```

## Common Mistakes
- Don't create new middleware without checking existing ones first
- Don't return raw database objects — always map through response DTOs
- Don't catch errors in route handlers — let the error middleware handle them
```

---

## 4. .mcp.json — The Device Node Registry

```jsonc
{
  "mcpServers": {
    // ── Code Intelligence ──────────────────────────
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },

    "serena": {
      "command": "serena",
      "args": ["start-mcp-server", "--context", "ide-assistant", "--project", "."],
      "note": "Install: uv tool install -p 3.13 serena-agent@latest --prerelease=allow (v1.1.0, Apr 11 2026)"
    },

    "ast-grep": {
      "command": "npx",
      "args": ["-y", "@ast-grep/ast-grep-mcp"]
    },

    // ── Documentation ──────────────────────────────
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    },

    // ── Browser & Testing ──────────────────────────
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    },

    // ── Error Tracking ─────────────────────────────
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp",
      "note": "Remote HTTP with OAuth — no local install needed"
    },

    // ── Database ───────────────────────────────────
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${DATABASE_URL_READONLY}"
      },
      "note": "ALWAYS use read-only credentials"
    },

    // ── Observability ──────────────────────────────
    "datadog": {
      "type": "http",
      "url": "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp",
      "env": {
        "DD_API_KEY": "${DD_API_KEY}",
        "DD_APP_KEY": "${DD_APP_KEY}"
      }
    },

    // ── Search ─────────────────────────────────────
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      }
    },

    // ── Memory ─────────────────────────────────────
    "mempalace": {
      "command": "mempalace",
      "args": ["serve", "--project", "."],
      "note": "Install: pip install mempalace"
    },

    // ── Deployment ─────────────────────────────────
    "vercel": {
      "type": "http",
      "url": "https://mcp.vercel.com",
      "note": "OAuth authentication required on first use"
    },

    // ── Payments ───────────────────────────────────
    "stripe": {
      "type": "http",
      "url": "https://mcp.stripe.com",
      "note": "Official Anthropic partner, 25 tools"
    },

    // ── Project Management ─────────────────────────
    "linear": {
      "type": "http",
      "url": "https://mcp.linear.app"
    },

    // ── Infrastructure ─────────────────────────────
    "terraform": {
      "command": "npx",
      "args": ["-y", "@hashicorp/terraform-mcp-server"]
    },

    // ── Design ─────────────────────────────────────
    "figma": {
      "type": "http",
      "url": "https://mcp.figma.com",
      "note": "Official Anthropic partner. Design-to-code pipeline"
    }
  }
}
```

**Key `.mcp.json` principles:**
1. **Environment variables for secrets** — never hardcode tokens. Use `${VAR}` syntax
2. **Read-only database credentials** — always. No exceptions
3. **Remote HTTP for vendor-hosted servers** — Sentry, Stripe, Vercel, Linear, Figma all offer managed endpoints. Prefer remote HTTP over local stdio when available (less maintenance, auto-updates)
4. **Project scope** — this file is committed to git so the whole team gets the same driver stack
5. **Notes for humans** — the `note` field isn't processed by Claude Code but helps teammates understand install requirements

---

## 5. Architectural Principles

### Principle 1: Verification Is the Bottleneck, Not Generation

Generation is cheap and fast. Verification is expensive and slow. Every architectural decision should optimize for verification throughput, not generation speed.

**Concretely:** The writer of code must never be its sole reviewer. Use cross-model review (CodeRabbit with non-Claude models), cross-agent review (separate verifier subagent), or structured prose-level critique (not just schema validation).

**Trap:** Structured-output constraints during self-reflection produce "formatting traps" — syntactic alignment with output schema while missing semantic errors (arxiv 2604.06066 "Alignment Tax"). Verification loops using structured output as the primary signal are broken. Use prose-level judgment.

### Principle 2: Design-Decision Deferral Is the Primary Failure Mode

AI acceleration of implementation **causes** design-decision deferral. You never have to slow down for the hard architectural call because the code writes itself. That deferral corrodes clarity.

**Concretely:** The first artifact of any non-trivial task is `research.md` and `plan.md`, never code. If the first artifact is code, the task is already broken. This is not process overhead — it is the primary defense against the Winchester Mystery House pattern.

**Source:** Willison "Eight Years / Three Months" (April 5), Maganti case study, Tane "research.md first" workflow.

### Principle 3: The Harness Is Stateless; The Session Is an Event Log

Anthropic's own engineering term of art: **"Stateless Harness + Durable Event Sourcing."** The harness is ephemeral. The session is an append-only event log stored externally. The sandbox is isolated.

**Concretely:** Never rely on in-memory state surviving between turns. Use git, files, TaskCreate, and CLAUDE.md as durable state. Use the Monitor tool for streaming observation of background processes. Session state is conversation context + git state + file state. Nothing else.

### Principle 4: Native Primitives Win When They're Real

Every month, Anthropic ships primitives that collapse entire categories of community tooling into the kernel. In the last 10 days alone: Advisor Tool collapsed orchestration, `defer` collapsed approval workflows, Monitor tool collapsed background process observation, native Linux sandbox went production-stable, `/cost` became first-class.

**Concretely:** Re-evaluate the slot rankings against Anthropic's changelog **monthly**, not quarterly. When a native primitive ships, the community tool it replaces becomes supplementary, not primary.

**Recent evidence:** v2.1.89-v2.1.101 shipped 7 releases in 10 days, each one collapsing a community-tool category.

### Principle 5: Parallel Concurrency — Start With One Fewer Than Comfortable

The optimal agent count for most tasks is 2-4. Not 1 (underutilized), not 8 (Comprehension Debt + Ambient Anxiety Tax + Trust Calibration Overhead).

**Concretely:** Pick from the low end of the band, not the high end. One orchestrator + 2-3 workers is the sweet spot. Use `isolation: "worktree"` for every parallel agent to prevent file conflicts.

**Named anti-patterns (Osmani, April 7):** Comprehension Debt (can't read all the diffs), Ambient Anxiety Tax (unease about unseen parallel work), Trust Calibration Overhead (deciding which agent's output to trust).

### Principle 6: MCP Is a Driver Layer, Not an Extension Layer

MCP servers are device drivers: they expose external resources through a standardized interface. They are NOT plugins that add intelligence. Intelligence lives in the model kernel. Drivers just give it I/O.

**Concretely:** Install MCP servers based on workflow bottlenecks, not ecosystem coverage. Start with GitHub (the primary development surface), then add based on pain. The Tool Search lazy-loading system means 10+ MCP servers add near-zero overhead (95% context reduction vs. clients that dump all tool definitions).

### Principle 7: Skill-Library Accumulation Has Diminishing Returns

arxiv 2604.04323 (Skill-Usage-Bench): 34k-skill library — pass rates approach no-skill baselines in realistic retrieval. Claude Opus 4.6 improves 57.7% → 65.5% on Terminal-Bench 2.0 only with **query-specific refinement**, NOT library size accumulation.

**Concretely:** Measure per-skill outcomes via PluginEval / eval loops. Delete skills that don't improve outcomes. Split-test with/without each skill. Three well-tuned skills beat thirty unvetted ones.

**Corroboration:** Ronacher's "Agent Psychosis" essay — "slop loops" that accumulate skills without measuring outcomes.

### Principle 8: Cost Discipline Is Architectural, Not Operational

Default `effortLevel` changed from `medium` to `high` in v2.1.94 (April 7) for API/Bedrock/Vertex/Foundry/Team/Enterprise users. Any cost model based on the medium default is stale.

**Concretely:** Use the Advisor Tool pattern (Haiku executor + Opus advisor) for 85% cost reduction on suitable tasks. Use native `/cost` for per-model + cache-hit breakdown. Use `ccusage` for historical trends. Set budget caps in LiteLLM or Portkey for team governance.

### Principle 9: Sandbox Isolation Is Non-Optional

Every production-adjacent agent session must run in a sandbox. The spectrum: native Linux sandbox (PID namespace + seccomp, v2.1.98, production-stable) → Docker sandboxes → E2B/Freestyle cloud sandboxes.

**Evidence:** Project Glasswing Mythos agent-escape incident (April 7) — one confirmed instance of an agent accessing the internet despite restrictions. MCPSHIELD (arxiv 2604.05969): single-layer MCP defenses cover only 34% of threats; integrated architecture reaches 91%.

**Concretely:** Use native sandbox as baseline. Add Docker for untrusted code. Add network egress policy. Cedar policy rules (v2.1.100) for permissions-as-code.

### Principle 10: Writer ≠ Reviewer at the Model-Diversity Level

Claude reviewing Claude is better than nothing but weaker than cross-model review. The only version of "writer ≠ reviewer" that honors the principle at the model-diversity level is using a different model family for review.

**Concretely:** CodeRabbit (non-Claude models), GitHub Copilot Code Review (Microsoft models), or kodus-ai (self-hosted, model-agnostic) as cross-vendor review on Claude-generated PRs.

### Principle 11: Supply-Chain Risk Is Larger for AI-Generated Code

AI-generated codebases have no human reader who would notice a compromised transitive dependency. AI commits average ~1,000 net lines (2 orders of magnitude above human rate), producing idiosyncratic undocumented codebases. The transitive dependency graph is nobody's responsibility by construction.

**Concretely:** Continuous SBOM generation (syft, cyclonedx, Dependabot). ShieldNet (arxiv 2604.04426) for network-level MCP monitoring. Aikido Security plugin for SAST. Never skip lockfile review. Pin versions explicitly.

**Named incidents:** LiteLLM PyPI v1.82.7-8 credential-stealing malware (March 2026). axios 1.14.1/0.30.4 by Sapphire Sleet (DPRK).

### Principle 12: The Eval-Validity Gap Is 10x

ClawBench measured 153 real tasks: benchmarks showed ~70% sandbox performance vs 6.5% realistic performance. **10x eval-validity gap.**

**Concretely:** Never trust a benchmark without realistic-conditions replication. Before adopting a benchmark-leading component, run it on 10 real tasks from your own repo.

### Principle 13: Subscription Plans Prohibit Scripted Use — CI Must Use API Billing

Anthropic explicitly cut subscription access for non-Anthropic harnesses on April 4, 2026 (Cline, Cursor, Windsurf, OpenClaw). This went from policy text to enforcement action.

**Concretely:** Interactive development: Max subscription ($200/mo). CI/CD, Managed Agents, headless sessions: API billing. This is not a suggestion — it's a policy enforcement boundary.

### Principle 14: Context Is the Fundamental Constraint

Everything competes for the context window. CLAUDE.md, tool schemas, conversation history, file contents, MCP results. Context engineering is the practice of deliberately structuring this information so the model does its best work.

**Concretely:** Keep CLAUDE.md under 150 lines. Use pointers (file:line), not copies. Use subagents to offload research (separate context windows). Use Tool Search lazy-loading (95% context reduction). Use `claude-token-efficient` for system-prompt compression.

### Principle 15: The Boot Sequence Determines Everything

The order in which Claude receives information shapes all subsequent behavior. `CLAUDE.md` is read at session start. Hooks fire at tool boundaries. Skills are loaded on demand. The boot sequence IS the architecture.

**Concretely:** `CLAUDE.md` → `settings.json` permissions/hooks → `.mcp.json` driver stack → first user prompt → skill/plugin activation. Get this sequence right and everything downstream follows. Get it wrong and no amount of tooling compensates.

---

## 6. Unique Insight (Extended): The OS Metaphor As Decision Framework

The deepest insight isn't "Claude Code is like an OS" — it's that **the OS metaphor gives you a decision framework that the plugin/tool metaphor does not.**

When someone asks "should I install this MCP server?", the plugin metaphor says "does it look useful?" The OS metaphor asks: "Is this a kernel module or a userspace program? Does it need ring-0 access to my files? Does it have an isolation boundary? What happens if it misbehaves? Is there a lighter-weight alternative that achieves the same goal from userspace?"

**Decision tree derived from the OS metaphor:**

```
Is this capability available natively in Claude Code?
├── YES → Use the native primitive. Period. (Principle 4)
│         Native: Agent, worktree, Monitor, /cost, defer, native sandbox
└── NO → Does it need file/network access?
    ├── YES → It's a driver (MCP server)
    │   ├── Does the vendor offer a remote HTTP endpoint?
    │   │   ├── YES → Use remote HTTP (Sentry, Stripe, Vercel, Linear)
    │   │   └── NO → Run locally with minimal permissions
    │   └── Is there an agentgateway/mcp-context-forge proxy?
    │       ├── YES → Route through the proxy (Principle 9)
    │       └── NO → Accept the risk with hook-based monitoring
    └── NO → It's a userspace program (skill/plugin)
        ├── Does it measurably improve outcomes? (Principle 7)
        │   ├── YES → Install, measure with PluginEval, keep if positive
        │   └── NO/UNKNOWN → Don't install. Try without it first.
        └── Does it duplicate a native primitive? (Principle 4)
            ├── YES → Don't install. The native version wins.
            └── NO → Evaluate cost/benefit per the eval-validity gap (Principle 12)
```

**The meta-principle:** The reason most Claude Code setups underperform is that they're configured like "a tool with plugins" — flat, undifferentiated, no security policy, no boot sequence, no process isolation. The moment you configure it like an OS — with a proper init system (CLAUDE.md), device drivers (.mcp.json), a security policy (permissions + hooks), process isolation (worktrees), and a supervisor (Advisor Tool) — the same underlying model produces dramatically better outcomes. Not because it's smarter, but because its environment is structured to prevent the failure modes that unstructured environments invite.

The system table in Section 1 is not a shopping list. It's a **system architecture** with tiers that correspond to OS layers: kernel → init → drivers → userspace → infrastructure → autonomous. Install bottom-up. Skip tiers you don't need. Never install a higher tier without the lower tiers being solid.

**The April 2026 inflection point:** The Advisor Tool (April 9) is the equivalent of hardware-assisted virtualization arriving in CPUs. It doesn't add a new capability — it moves an existing capability (executor/advisor split) from software orchestration into the kernel. Just as VT-x collapsed VMware's binary translation layer, the Advisor Tool collapses the orchestration platforms that existed solely to route "easy tasks to Sonnet, hard tasks to Opus." Those platforms still have value for other things (team coordination, Kanban, loop management), but their raison d'etre just moved into the kernel. Every architecture that doesn't acknowledge this transition is building on stale assumptions.

---

*End of Architecture 08*
