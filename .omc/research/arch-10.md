# Architecture 10: The Metabolic System
## A Claude Code Coding System Designed as a Living Organism, Not a Machine

*Architect 10 — April 12, 2026*

---

## Thesis: The Organism Metaphor

Every other architecture I could write treats Claude Code as a machine you configure — bolt on MCP servers, tune settings, wire hooks. That framing is wrong. The correct framing is **metabolic**: Claude Code is a living system with an immune system (sandbox + hooks + MCP gateways), a nervous system (hooks + notifications + defer), a digestive system (context window + memory + RAG), a skeletal system (CLAUDE.md + settings.json + .mcp.json), and metabolic rate (effortLevel + cost + billing tier). You don't "configure" an organism — you cultivate conditions for health.

The machine metaphor leads to Winchester Mystery Houses (Breunig, March 26 2026) — endlessly accumulated rooms with no occupant who understands the whole. The organism metaphor leads to **homeostasis**: every component must justify its metabolic cost (context tokens, dollars, cognitive load) or be shed.

This architecture is organized around that principle. Every tool earns its place by passing a metabolic fitness test: **Does it reduce the total energy the system expends to produce verified, correct, shippable code?**

---

## 1. The Master Table: 32-Slot Organism Anatomy

### Layer 0: Kernel (The Heart)

| Slot | Category | Primary (Free/Included) | Secondary ($) | Why It Earns Its Metabolic Cost |
|------|----------|------------------------|---------------|-------------------------------|
| 1 | **CLI Harness** | **Claude Code v2.1.101** (Max $200/mo) | Gemini CLI (free), OpenCode (free), Aider (free/OSS) | The heart pumps. Everything flows through here. Native Monitor tool, run_in_background, Focus View (Ctrl+O), Agent SDK integration. |
| 2 | **Model Routing / Advisor** | **Advisor Tool** (native API, beta header `advisor-tool-2026-03-01`) | LiteLLM v1.83.x+ (free, **pin version — v1.82.7-8 compromised**), Ollama (free) | Server-side Haiku/Sonnet executor + Opus advisor in a single `/v1/messages` call. Collapses the entire "route Opus for planning" orchestration pattern. 85% cost reduction measured. |
| 3 | **Plugin/Skill Framework** | **Claude Code native plugins** (stable since Oct 2025), `bin/` auto-PATH (v2.1.91), `disableSkillShellExecution` setting | wshobson/agents (33.4k stars, MIT, 182 agents + 149 skills + PluginEval), Superpowers (1k stars) | **CAVEAT**: Skill-Usage-Bench (arxiv 2604.04323) shows skill-library gains collapse to near-zero in realistic retrieval. Install <10 high-quality skills, measure outcomes via PluginEval, delete what doesn't pay rent. Refinement > accumulation. |
| 4 | **Billing Tier** | **Max 20x ($200/mo)** for interactive dev | API pay-as-you-go for CI/CD only (Batch API = 50% discount) | 93% savings vs API for heavy interactive use. >90% of tokens are cache reads at $0.30/MTok. Native `/cost` command (v2.1.92) for per-model + cache-hit breakdown. API billing for CI because Anthropic enforced subscription-access cutoff for non-Anthropic harnesses (Apr 4 2026). |

### Layer 1: Nervous System (Sensing & Responding)

| Slot | Category | Primary | Secondary | Metabolic Justification |
|------|----------|---------|-----------|------------------------|
| 5 | **Hooks Engine** | **Native hooks** (26 events, 12 blocking, 4 handler types: command/http/prompt/agent) | — | Deterministic guarantees that prompts cannot provide. `PreToolUse` for lint/format gates, `PostToolUse` for logging, `UserPromptSubmit` for context injection. `defer` permission decision (v2.1.89) unlocks headless-pause. `PermissionDenied.retry` for self-healing. |
| 6 | **Notification / Defer Channel** | **ntfy.sh** (29.7k stars, Apache-2.0, self-hostable, interactive Allow/Deny buttons) | Telegram Bot API (free, inline keyboard), Slack webhooks | Exists because `defer` (v2.1.89) needs a user-facing surface. 0.4% false positive rate in production (Anthropic auto-mode post). Headless Claude pauses at tool boundaries, pings phone, resumes on approval. |
| 7 | **Agent Teams** | **Native Agent Teams** (experimental, v2.1.32+, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`, 2-16 sessions) | Claude Squad (8k stars, terminal-ops), oh-my-claudecode (4.5k stars, teams-first orchestration) | Peer-to-peer messaging + shared task list + direct tool access per teammate. "Start with one fewer agent than feels comfortable" (Osmani, April 7). 3-5 agent band, pick from low end. |
| 8 | **Walk-Away Autonomous Agents** | **OpenHands** (71k stars, MIT, self-hostable) | Devin ($20/mo, most autonomous), Google Jules (free 15/day), langchain-ai/open-swe (9.5k stars) | Architecturally distinct from Slot 1: you give it a ticket and come back later. For background issue resolution, batch PRs, after-hours work. |

### Layer 2: Immune System (Security & Integrity)

| Slot | Category | Primary | Secondary | Metabolic Justification |
|------|----------|---------|-----------|------------------------|
| 9 | **Sandbox** | **Native Linux subprocess sandbox** (v2.1.98, PID namespace + seccomp-bpf, ~2-3% CPU, <10ms startup — now production-stable) | Docker Sandboxes (microVM), container-use/Dagger, E2B, Fly Sprites (`--skip-console` for CI) | Native sandbox for everyday commands. Docker microVM for untrusted code. Fly Sprites for cloud CI with 100GB NVMe default. Decision tree: trusted code → native seccomp; untrusted → Docker microVM; CI → Fly Sprites. |
| 10 | **MCP Security Gateway** | **agentgateway** (2.4k stars, Linux Foundation, Rust, MCP + A2A native) | IBM/mcp-context-forge (3.6k stars, federated guardrails + OTEL), Docker MCP Gateway (container isolation + signature verification), MCPShield (CLI scanner) | **v3 missed this slot entirely.** OWASP MCP Top 10 exists. MCPSHIELD (arxiv 2604.05969): 23 attack vectors across 4 surfaces; single-layer defenses cover only 34%, integrated reaches 91%. ShieldNet (arxiv 2604.04426): F1=0.995 at 0.8% FP. MCP-layer security is non-optional. |
| 11 | **Supply Chain Defense** | **Dependabot** (free on GitHub) + **syft** (SBOM generation, free) + **MCPShield CLI** (typosquat/CVE scanner) | ShieldNet (network-level behavioral monitoring), Aikido Security plugin (SAST + secrets + IaC) | Winchester Mystery House + Catacombs risk (Breunig + Nesbitt, March-April 2026): AI-generated codebases have no human reader for transitive deps. LiteLLM PyPI v1.82.7-8 compromised March 2026. Continuous SBOM generation is table-stakes. |
| 12 | **Permission & Policy** | **Cedar policy syntax** (v2.1.100 added highlighting — Cedar is now first-class) + native permissions (`allow`/`deny`/`ask` arrays) | Anthropic Vaults API (credential management for MCP) | 5-scope priority: Enterprise → Session → Project Shared → Project Local → User Global. Deny checked first, then ask, then allow. Cedar for permissions-as-code at scale. |

### Layer 3: Digestive System (Context & Memory)

| Slot | Category | Primary | Secondary | Metabolic Justification |
|------|----------|---------|-----------|------------------------|
| 13 | **Context Engineering** | **CLAUDE.md** (native, <200 lines, path-scoped YAML frontmatter) + `claude-token-efficient` (471 HN pts, highest-scoring context-compression item) | ContextKit (4-phase framework), Squeez, caveman | CLAUDE.md is the single highest-leverage context. Path scoping (YAML frontmatter) keeps it lean. Token-efficient formatting reduces system prompt size. Every token in CLAUDE.md is in every session — metabolic cost is multiplicative. |
| 14a | **Vector Memory** | **claude-mem** (12.9k stars, auto-capture + compress + inject) | mempalace (23k stars, 96.6% LongMemEval, 19 MCP tools), supermemory (15k stars) | Cross-session context persistence via semantic search. MCP result size now 500K chars (v2.1.91) — memory-heavy servers can return full context. |
| 14b | **Structured/Graph Memory** | **Karpathy LLM Wiki pattern** (April 3 2026, Obsidian Markdown + `qmd` BM25/vector local MCP) | Palinode (git-versioned markdown), Engram (knowledge graph + NER), Hippo (biologically-inspired, zero deps) | Refinement-based approach aligned with Skill-Usage-Bench finding. Compiled knowledge base, not accumulated skill library. `claude-memory-compiler` (Cole Medin, April 6) automates session→knowledge-article pipeline. |
| 15 | **Documentation RAG** | **Context7 MCP** (live, version-accurate library docs — now requires `--api-key`) | Serena v1.1.0 (install: `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` — NOT the deprecated `uvx` form), probe (537 stars, ripgrep + tree-sitter + MCP) | Live documentation retrieval beats stale training data. Context7 for library docs, Serena for codebase intelligence. |

### Layer 4: Skeletal System (Structure & Code Intelligence)

| Slot | Category | Primary | Secondary | Metabolic Justification |
|------|----------|---------|-----------|------------------------|
| 16 | **Code Intelligence MCP** | **ast-grep** (13.4k stars, structural-pattern search, 20+ languages, `ast-grep/ast-grep-mcp`) | Semgrep (OWASP rule sets, use as PostToolUse hook), codegraph-rust, probe | Structural AST search is a different primitive than text grep. ast-grep finds patterns across languages; Semgrep catches security anti-patterns deterministically. |
| 17 | **GitHub Integration** | **GitHub MCP** (official, Go rewrite, 51+ tools, OAuth scope filtering, `get_me`) | claude-code-action v1.0.93 (April 10 2026, @v1), claude-code-security-review (GitHub Action) | Core development loop: PRs, issues, code scanning. Remote HTTP at `https://mcp.sentry.dev/mcp` for Sentry (OAuth, not stdio). |
| 18 | **Database** | **Supabase MCP** (full: DB + auth + storage + edge) | Google MCP Toolbox for Databases (BigQuery + AlloyDB + Spanner + CloudSQL + Postgres + MySQL), Prisma CLI v6.6+ (built-in migrate) | Pick one database MCP per project. Supabase if full-stack, Google Toolbox if GCP, Prisma if ORM-first. |
| 19 | **Cloud/Infra** | **Terraform MCP** (HashiCorp official) | AWS MCP, Azure Skills Plugin (Microsoft official), Cloudflare MCP (2,500 endpoints in ~1k tokens) | IaC is the lingua franca. Terraform primary, cloud-specific secondaries as needed. |

### Layer 5: Circulatory System (Communication & Integration)

| Slot | Category | Primary | Secondary | Metabolic Justification |
|------|----------|---------|-----------|------------------------|
| 20 | **Web/Search** | **Firecrawl** (official plugin, anti-bot handling) | Brave Search MCP (privacy-focused), Perplexity Sonar (AI-powered) | Web access for research, documentation fetching, competitive analysis. Firecrawl for scraping, Brave for search. |
| 21 | **Browser Automation** | **Playwright MCP** (@playwright/mcp, 25+ tools, accessibility tree) | Playwright CLI (YAML snapshots, 4x fewer tokens), Claude in Chrome | E2E testing + UI verification. Playwright CLI variant is token-efficient. |
| 22 | **Communication** | **Slack MCP** (via registry) | Discord/Telegram/iMessage (Claude Code Channels, research preview March 2026), Google Workspace MCP | Notification delivery and team communication. Channels feature for multi-platform messaging. |
| 23 | **Design** | **Figma MCP** (official Anthropic partner, design-to-code) | Mermaid Chart (official connector, diagram validation), VoltAgent awesome-design-md (55+ brand DESIGN.md files) | Design-to-code pipeline. Figma as source of truth, Mermaid for technical diagrams. |

### Layer 6: Respiratory System (Build & Environment)

| Slot | Category | Primary | Secondary | Metabolic Justification |
|------|----------|---------|-----------|------------------------|
| 24 | **Build Loop / Workstation** | **mise** (26.6k stars, replaces asdf+nvm+pyenv+direnv+make, `.mise.toml` checked-in) | just (32.8k stars, simplest hook target), Turborepo (30.2k stars, `--filter=...[HEAD]`), watchexec (file-watch trigger) | Reproducible tool versions for Claude's Bash tool. `mise` gives a single `.mise.toml` that ensures Claude and humans use identical tool versions. `just` for Claude-readable task definitions. |
| 25 | **Observability** | **claude-code-otel** (OpenTelemetry integration) + native `/cost` (v2.1.92) | Langfuse v3 (self-host, requires MinIO — v4 cloud preview is 10x faster but no self-host path yet), Datadog MCP (official remote, 16+ tools), agents-observe (team dashboard) | OTEL for distributed tracing. Langfuse for detailed session analysis. Native `/cost` is now first-class — downgrade ccusage/kerf-cli to supplementary. |
| 26 | **CI/CD** | **claude-code-action** (@v1, v1.0.93) + `ant` CLI (Anthropic, GitOps for Managed Agents YAML) | Fly Sprites with `--skip-console`, Modal (caution: $0.119-0.142/vCPU-hr, not $0.047 as previously claimed) | `ant` CLI is a completely new surface: version-control agent definitions in YAML with native CC integration. CI must use API billing (subscription enforcement Apr 4 2026). |

### Layer 7: Endocrine System (Regulation & Self-Improvement)

| Slot | Category | Primary | Secondary | Metabolic Justification |
|------|----------|---------|-----------|------------------------|
| 27 | **Cross-Vendor Code Review** | **CodeRabbit** (2M+ repos, 82% bug-catch rate, BYOK) | Greptile ($30/user/mo, full codebase graph), kodus-ai (1k stars, AGPLv3, self-hosted, AST-aware) | Writer != reviewer (Principle 1) at the model-diversity level. A different model family reviewing Claude's output is the only true independence. |
| 28 | **LLM Gateway** | **LiteLLM v1.83.x+** (43k stars, MIT, only gateway Anthropic officially documents: `ANTHROPIC_BASE_URL=http://0.0.0.0:4000`) | Portkey (11.3k stars, team governance), OpenRouter (200+ cloud models), 9router (agent-tool-aware routing) | Cost caps, audit logs, model fallback, budget enforcement. **CRITICAL: Pin LiteLLM >= 1.83.x. Versions 1.82.7-8 were PyPI-compromised.** |
| 29 | **Durable Execution** | **Absurd** (earendil-works, 5 months production, Postgres-only, TS/Python/Go SDKs) | Temporal (enterprise), inngest (event-driven) | LLM agent loop checkpointing. Ronacher's Absurd (April 4 2026): single Postgres replaces Temporal for LLM-loop checkpointing — 5-month production result. |
| 30 | **Self-Improvement** | **PluginEval** (wshobson/agents: static + LLM judge + Monte Carlo, Wilson/Clopper-Pearson CI, Elo ranking) | RoboPhD (arxiv 2604.04347, `optimize_anything()`, ARC-AGI 27.8%→65.8%), SkillX (arxiv 2604.04804, hierarchical skill-KB) | Measure skill outcomes, not accumulate skills. PluginEval is the benchmark framework; RoboPhD/SkillX are the self-improvement runtimes. |

### Speculative Layer (Monitor, Don't Install Yet)

| Slot | Category | Watch | Why It's Not Primary Yet |
|------|----------|-------|--------------------------|
| 31 | **Local Rust Agent Runtime** | zeroclaw-labs/zeroclaw (30k stars, <5MB RAM, <10ms startup) | Claude Code on Raspberry Pi / ARM / IoT is emerging but only 3 projects. |
| 32 | **Self-Modifying Agents** | NousResearch/hermes-agent v0.8.0 (57.9k stars, self-improving), kevinrgu/autoagent (purest Dark Factory) | Self-improving agents creating skills from experience. Measured results (ARC-AGI improvement) but production-readiness unclear. |

---

## 2. settings.json — The Skeleton

```jsonc
// ~/.claude/settings.json — User Global scope
// Schema: https://json.schemastore.org/claude-code-settings.json
{
  // ── Model & Effort ──────────────────────────────────────────
  "model": "claude-sonnet-4-6",           // NOT "defaultModel" — schema trap
  // NOTE: v2.1.94 changed default effortLevel from medium→high for API/Team/Enterprise.
  // Max subscription users: explicitly set to control cost.

  // ── Permissions ─────────────────────────────────────────────
  "permissions": {
    "defaultMode": "acceptEdits",          // NOT "autoAccept" — schema trap
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Agent",
      "Bash(npm run lint)",
      "Bash(npm run test *)",
      "Bash(npm run build)",
      "Bash(npx tsc --noEmit)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git add *)",
      "Bash(git stash *)",
      "Bash(mise install *)",
      "Bash(just *)",
      "Bash(jq *)",
      "Bash(curl -fsSL *)",
      "Bash(gh pr *)",
      "Bash(gh issue *)",
      "WebSearch",
      "WebFetch"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(rm -rf ~)",
      "Bash(git push --force *)",
      "Bash(git reset --hard *)",
      "Bash(git checkout -- .)",
      "Bash(git clean -fd)",
      "Bash(DROP TABLE *)",
      "Bash(DROP DATABASE *)",
      "Bash(curl * | bash)",
      "Bash(curl * | sh)",
      "Bash(chmod 777 *)",
      "Bash(> /dev/sda*)",
      "Bash(mkfs*)",
      "Bash(dd if=*)"
    ]
    // Everything not in allow/deny goes to "ask" by default
  },

  // ── Agent Teams ─────────────────────────────────────────────
  "agentTeams": {
    "enabled": true                        // Requires CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 env
  },

  // ── Hooks ───────────────────────────────────────────────────
  "hooks": {
    // Gate: lint on every file write
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "changed_file=$(echo $CLAUDE_TOOL_INPUT | jq -r '.file_path // empty'); [ -z \"$changed_file\" ] && exit 0; case \"$changed_file\" in *.ts|*.tsx|*.js|*.jsx) npx eslint --fix \"$changed_file\" 2>/dev/null;; *.py) ruff check --fix \"$changed_file\" 2>/dev/null;; *.rs) rustfmt \"$changed_file\" 2>/dev/null;; esac; exit 0"
          }
        ]
      }
    ],
    // Gate: security scan on Bash commands
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "cmd=$(cat /dev/stdin | jq -r '.tool_input.command // empty'); case \"$cmd\" in *'curl'*'|'*'bash'*|*'curl'*'|'*'sh'*|*'eval'*) echo 'DENY: Piped execution blocked' >&2; exit 2;; esac; exit 0"
          }
        ]
      }
    ],
    // Notification: ping phone on defer
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "curl -s -d \"$CLAUDE_NOTIFICATION\" ntfy.sh/claude-$(whoami) >/dev/null 2>&1",
            "async": true
          }
        ]
      }
    ],
    // Logging: async session telemetry
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"ts\":\"'$(date -u +%FT%TZ)'\",\"tool\":\"'$CLAUDE_TOOL_NAME'\",\"session\":\"'$CLAUDE_SESSION_ID'\"}' >> ~/.claude/logs/tool-events.jsonl",
            "async": true
          }
        ]
      }
    ]
  },

  // ── Environment ─────────────────────────────────────────────
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "CLAUDE_CODE_NO_FLICKER": "1",
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1"
    // Do NOT add CLAUDE_CODE_ENHANCED_TELEMETRY_BETA unless you intend distributed-traces beta
  }
}
```

### Project-Level Settings (`.claude/settings.json`)

```jsonc
// .claude/settings.json — Project Shared scope (committed to repo)
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(docker compose *)",
      "Bash(mise run *)",
      "Bash(just *)"
    ],
    "deny": [
      "Bash(npm publish *)",
      "Bash(docker push *)"
    ]
  },
  "hooks": {
    // Project-specific: type-check after every edit to .ts/.tsx
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "changed=$(cat /dev/stdin | jq -r '.tool_input.file_path // empty'); case \"$changed\" in *.ts|*.tsx) npx tsc --noEmit --pretty 2>&1 | head -20;; esac; exit 0"
          }
        ]
      }
    ],
    // On commit: auto-generate SBOM
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "cmd=$(cat /dev/stdin | jq -r '.tool_input.command // empty'); case \"$cmd\" in *'git commit'*) syft . -o cyclonedx-json > sbom.json 2>/dev/null &;; esac; exit 0",
            "async": true
          }
        ]
      }
    ]
  }
}
```

---

## 3. CLAUDE.md — The DNA

```markdown
# Project: [name]

## Build & Run
- `mise install` — set up all tool versions from .mise.toml
- `just build` — build the project
- `just test` — run the test suite
- `just lint` — lint and format

## Architecture
[2-3 sentences describing the high-level architecture. Link to docs/architecture.md for detail.]

## Code Conventions
- [Language]-specific style: [link to .editorconfig or formatter config]
- Commits: conventional commits (feat/fix/chore/docs/refactor/test)
- PRs: one logical change per PR, must pass CI, require CodeRabbit review

## Non-Obvious Constraints
- [List things Claude cannot infer from code. Examples:]
- The `legacy_auth` module is being replaced — do not extend it, migrate callers to `auth_v2`
- API responses must not exceed 50KB — paginate if approaching limit
- The `payments` table uses soft deletes — never `DELETE FROM payments`

## Decision Log
- [Date]: [Decision] — [Why, in one sentence]

## What Not To Do
- Do not add dependencies without checking `sbom.json` for known CVEs via `mcpshield scan`
- Do not mock the database in integration tests — use the real test database
- Do not create new utility files — find an existing home for the function
```

### Key CLAUDE.md Design Principles

1. **Under 200 lines.** Every token is in every session. Metabolic cost is multiplicative.
2. **Path-scoped rules via YAML frontmatter** in `.claude/rules/` for directory-specific instructions — keeps root CLAUDE.md lean.
3. **No code patterns.** Claude can read the code. CLAUDE.md is for things Claude *cannot* infer: constraints, non-goals, decisions, social context.
4. **Decision log.** Every design decision recorded with *why*. This directly addresses the "design-decision deferral" failure mode (Willison/Maganti, April 5 2026): if the first artifact of a task is code, the task is already broken.
5. **`research.md` + `plan.md` before code.** Front-load architecture decisions in explicit documents with alternatives considered and non-goals stated. Reference from CLAUDE.md.

---

## 4. .mcp.json — The Nervous Wiring

```jsonc
// .mcp.json — Project-level MCP servers
{
  "mcpServers": {
    // ── Code Intelligence ──────────────────────────────────────
    "ast-grep": {
      "command": "npx",
      "args": ["-y", "@ast-grep/mcp"]
    },

    // ── GitHub ─────────────────────────────────────────────────
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },

    // ── Sentry (Remote HTTP, NOT stdio) ────────────────────────
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
      // OAuth-based — no local installation needed
    },

    // ── Database (pick one per project) ────────────────────────
    "supabase": {
      "command": "npx",
      "args": ["-y", "supabase", "mcp"]
    },

    // ── Documentation RAG ──────────────────────────────────────
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest", "--api-key", "${CONTEXT7_API_KEY}"]
    },

    // ── Observability ──────────────────────────────────────────
    "datadog": {
      "type": "http",
      "url": "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp"
      // Replaces archived PostHog/mcp
    },

    // ── Deployment ─────────────────────────────────────────────
    "vercel": {
      "type": "http",
      "url": "https://mcp.vercel.com"
      // OAuth + Streamable HTTP
    },

    // ── Payments (if applicable) ───────────────────────────────
    "stripe": {
      "type": "http",
      "url": "https://mcp.stripe.com"
      // Official Anthropic partner, 25 tools
    },

    // ── Project Management ─────────────────────────────────────
    "linear": {
      "type": "http",
      "url": "https://mcp.linear.app"
    },

    // ── Web Scraping ───────────────────────────────────────────
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"],
      "env": {
        "FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}"
      }
    },

    // ── Browser Automation ─────────────────────────────────────
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp"]
    },

    // ── Memory (user-scoped, not project — configure in ~/.claude.json) ──
    // "claude-mem": { ... }  // Configured at user scope via: claude mcp add --scope user claude-mem

    // ── Security Gateway ───────────────────────────────────────
    // agentgateway sits in front of ALL of the above when deployed in production.
    // Local dev: direct connections. Production: route through agentgateway for audit + policy.
  }
}
```

### MCP Configuration Principles

- **User-scoped** (`~/.claude.json projects[path].mcpServers`): memory, personal tools, search
- **Project-scoped** (`.mcp.json`): project-specific integrations committed to repo
- **Plugin-scoped** (`plugin.json`): plugin-bundled MCP servers
- **NEVER** top-level in `settings.json` — schema trap
- **Remote HTTP** preferred over stdio for vendor-managed servers (Sentry, Vercel, Stripe, Linear, Datadog) — zero local installation, auto-updates
- **MCP result size**: 500K chars max via `_meta["anthropic/maxResultSizeChars"]` (v2.1.91)
- Tool Search (native) discovers tools on demand — 95% context reduction vs dump-all-tools clients

---

## 5. Principles — The Metabolic Laws

### Principle 1: Verification Is the Bottleneck, Not Generation
Generation is infinite and cheap. Verification is scarce and expensive. Every architectural decision must be evaluated by: does it make verification easier or harder? The writer/reviewer split must use prose-level judgment, not just schema validation — structured-output constraints during self-reflection produce "formatting traps" (arxiv 2604.06066): syntactic alignment masking semantic errors. Use CodeRabbit (Slot 27) for cross-vendor review. Never self-approve in the same context.

### Principle 2: Design Decisions Must Be Front-Loaded
AI acceleration of implementation *causes* design-decision deferral — you never slow down for the hard call (Willison/Maganti, April 5 2026). If the first artifact of a task is code, the task is already broken. Required sequence: `research.md` (problem analysis + alternatives) → `plan.md` (explicit decisions + non-goals + trade-offs) → implementation. CLAUDE.md's Decision Log anchors this.

### Principle 3: The Advisor Pattern Is the New Default
The Advisor Tool (April 9 2026, `advisor-tool-2026-03-01`) collapses "route Opus for planning, Sonnet for execution" into a server-side primitive. Haiku+Opus: 41.2% SWE-bench vs 19.7% Haiku solo at 85% lower cost. Sonnet+Opus: 74.8% SWE-bench Multilingual, 2.7 points above Sonnet alone. For long-horizon agentic tasks, enable Advisor by default. This downgrades most external orchestration layers from "primary architecture" to "supplementary workflow."

### Principle 4: Metabolic Cost Governs Everything
Every tool, MCP server, skill, plugin, and CLAUDE.md line has a metabolic cost in tokens, dollars, latency, and cognitive load. The system must continuously shed what doesn't pay rent. Measure with PluginEval (Slot 30). Kill with prejudice. Three skills that work > thirty that clutter context.

### Principle 5: Parallel Concurrency Must Be Bounded
3-5 agents, pick from the low end (Osmani, April 7 2026). Three named anti-patterns: **Comprehension Debt** (too many agents to track), **Ambient Anxiety Tax** (uncertainty about what agents are doing), **Trust Calibration Overhead** (verifying agent work costs more than doing it). "Start with one fewer agent than feels comfortable."

### Principle 6: Skill Refinement Over Accumulation
Skill-Usage-Bench (arxiv 2604.04323, 34k real-world skills): skill-library gains collapse to near-zero in realistic retrieval. Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench 2.0 only with query-specific refinement, NOT library size. Measure each skill's delta. Delete what doesn't improve outcomes. Corroborated by Ronacher's "Agent Psychosis" essay.

### Principle 7: Native Primitives Win When They're Real
Advisor Tool, `ant` CLI, `defer` at 0.4% FP, Monitor tool, Agent Teams, native Linux sandbox, Cedar policy support, `/cost` command — Anthropic ships faster than the ecosystem. Re-evaluate slot rankings monthly against the changelog, not quarterly. When a native primitive covers 80% of an external tool's use case, drop the external tool.

### Principle 8: Sandbox Isolation Is Non-Optional
MCPSHIELD: 23 MCP attack vectors, single-layer defense covers only 34%, integrated architecture reaches 91%. Mythos agent-escape incident (Project Glasswing, April 7 2026): a model accessed the internet despite restrictions. Defense is layered: native seccomp (Layer 1) + Docker microVM (Layer 2) + MCP gateway (Layer 3) + network egress policy (Layer 4) + Cedar permission rules (Layer 5).

### Principle 9: The Winchester House Is the Default Outcome
AI-generated codebases have no human reader (Breunig, March 26 2026). AI commits average ~1,000 net lines, 2 orders of magnitude above human rate (Nesbitt, April 6 2026). The transitive dependency graph is nobody's responsibility by construction. Continuous SBOM generation (syft + Dependabot + MCPShield) is not optional — it's the immune system response to the organism's own growth rate.

### Principle 10: Deterministic Gates Beat Advisory Prompts
Hooks guarantee execution; prompts do not. Security checks, formatting, linting, SBOM generation — anything that must happen every time belongs in hooks, not CLAUDE.md instructions. The organism's reflexes (hooks) must not depend on its conscious decisions (model outputs).

### Principle 11: Billing Architecture Is Security Architecture
Anthropic enforced subscription-access cutoff for non-Anthropic harnesses (Cline, Cursor, Windsurf, OpenClaw) on April 4 2026. Max $200/mo for interactive development. API pay-as-you-go for CI/CD, headless, and non-Claude-Code harnesses. This is policy-as-architecture: the billing split is a load-bearing security boundary.

### Principle 12: Durable Execution Enables Walk-Away Confidence
Agent loops crash. Networks partition. Machines sleep. Without checkpointing, a 4-hour agent run that fails at hour 3.5 starts from zero. Absurd (Ronacher, April 4 2026) proves that a single Postgres file can replace Temporal for LLM-loop checkpointing. For any agent loop >30 minutes, durable execution is mandatory.

### Principle 13: The Eval-Validity Gap Is 10x
ClawBench (AI Engineer Europe, April 10 2026): ~70% sandbox performance vs 6.5% realistic performance. Never trust a benchmark without a realistic-conditions replication. Before adopting a benchmark-leading component, run it on 10 real tasks from your own repo.

### Principle 14: Notifications Close the Autonomy Loop
Without a notification channel, `defer` has no user-facing surface. With one (ntfy.sh + phone), headless Claude pauses at tool boundaries, pings you, and resumes on approval. This transforms Claude Code from "interactive terminal tool" to "autonomous agent with human-in-the-loop checkpoints." The notification channel is the regulatory hormone of the organism.

### Principle 15: effortLevel Is Not Free
v2.1.94 (April 7 2026) changed default `effortLevel` from `medium` to `high` for API/Bedrock/Vertex/Foundry/Team/Enterprise (NOT Pro/Max subscription). Any cost model based on medium-default is stale. For Max subscription: the platform manages cost. For API billing: set `effortLevel` explicitly and monitor with `/cost`.

---

## 6. Unique Insight: The Organism's Autoimmune Disease

Here is the insight no other architecture will give you:

**The greatest threat to a Claude Code system is not external attack, not cost overrun, not hallucination. It is autoimmune disease — the system's own defense mechanisms attacking its productive capacity.**

Every defense layer has a metabolic cost:
- Every hook adds latency to every tool call
- Every MCP gateway adds a network hop
- Every permission rule adds a decision point
- Every SBOM scan adds build time
- Every CodeRabbit review adds PR cycle time
- Every skill measurement via PluginEval adds evaluation overhead

An over-defended system produces nothing. The Winchester Mystery House is not just a code-generation failure — it's also a *configuration* failure. You can build a Winchester Mystery House out of hooks and MCP servers just as easily as out of generated code.

**The metabolic principle resolves this tension.** Every defense must justify its cost in the same currency as every productive tool: does it reduce the total energy the system expends to produce verified, correct, shippable code? A security hook that catches 1 vulnerability per 10,000 invocations at 50ms per invocation is costing 500 seconds of latency per catch. Is that worth it? Maybe. But you need to measure.

This is why Slot 30 (Self-Improvement / PluginEval) is not a luxury — it's the organism's **thyroid gland**. Without measurement, the system cannot distinguish between productive tissue and tumors. Without measurement, every new MCP server is a potential autoimmune trigger.

### The Homeostasis Protocol

1. **Monthly metabolic audit:** For every tool in the system, measure: invocations, success rate, latency contribution, dollar cost, context tokens consumed. If a tool's success rate is <5% or its cost-per-success exceeds the cost of doing it manually, shed it.

2. **Quarterly principle review:** Re-evaluate all 15 principles against the latest Anthropic changelog and ecosystem state. Principles that no longer hold (because native primitives replaced them) are archived, not accumulated.

3. **Continuous immune calibration:** Defense layers are tuned by false-positive rate, not false-negative rate. A security hook with 10% FP rate will be disabled by users within a week — a 0.4% FP rate (like `defer`) will be tolerated indefinitely. Design for the lowest FP rate you can achieve, not the lowest FN rate.

4. **The shedding rule:** When the system has >20 MCP servers configured, >10 skills installed, or >500 lines of hooks configuration — it is sick. It has accumulated faster than it has refined. Stop adding. Start measuring. Delete until healthy.

### Why This Matters for the $200/mo Budget

The Max 20x plan at $200/mo is the organism's food supply. It is abundant but finite. The metabolic principle ensures you spend it on production (writing and verifying code) rather than on maintaining the elaborate defense and orchestration apparatus that was supposed to help. The healthiest system is the smallest system that still produces verified, shippable code with acceptable risk.

The perfect Claude Code setup is not the one with the most tools. It's the one where every tool is working, every tool is measured, and nothing is there "just in case."

---

## Appendix A: Post-Corpus Release Timeline (v2.1.89 → v2.1.101)

| Version | Date | Key Feature | Impact |
|---------|------|-------------|--------|
| 2.1.89 | Apr 1 | `defer` permission decision, `PermissionDenied.retry` | Headless-pause patterns |
| 2.1.90 | Apr 1 | `/powerup` interactive feature-learning | Onboarding |
| 2.1.91 | Apr 2 | MCP 500K result size, plugin `bin/` auto-PATH, `disableSkillShellExecution` | Plugin architecture expansion |
| 2.1.92 | Apr 4 | Per-model `/cost` breakdown, Bedrock wizard | Native cost tooling |
| 2.1.94 | Apr 7 | **effortLevel default: medium→high** (API/Team/Enterprise) | Cost model invalidation |
| 2.1.97 | Apr 9 | Focus View (`Ctrl+O`) | UX |
| 2.1.98 | Apr 9 | **Monitor tool**, Linux PID namespace + seccomp stable, Perforce mode | Session primitives + sandbox graduation |
| 2.1.100 | Apr 10 | Cedar policy syntax highlighting, MCP HTTP/SSE memory leak fix | Permissions-as-code, stability |
| 2.1.101 | Apr 10 | `/team-onboarding` | Team workflow |

## Appendix B: Failure Mode Registry (16 Total)

| # | Failure | Source | Canary Signal |
|---|---------|--------|---------------|
| 1 | Writer self-approving | Principle 1 | Review pass rate >95% (too high = rubber-stamp) |
| 2 | Design-decision deferral | Willison/Maganti Apr 5 | First artifact of task is code, not plan |
| 3 | Cost anomaly from effortLevel drift | v2.1.94 | Monthly bill spikes without usage increase |
| 4 | Parallel agent Comprehension Debt | Osmani Apr 7 | Agent count >5 with declining throughput |
| 5 | Supply-chain compromise | LiteLLM v1.82.7-8, Mar 2026 | Unexpected outbound connections |
| 6 | MCP single-layer defense gap | MCPSHIELD arxiv 2604.05969 | No MCP gateway in architecture |
| 7 | Agent escape | Project Glasswing/Mythos, Apr 7 | Outbound from sandboxed agent |
| 8 | Destructive agent action | Replit 2.5-year wipeout, SaaStr/Replit Jul 2025 | No structural gate on destructive ops |
| 9 | Skill-library collapse | Skill-Usage-Bench arxiv 2604.04323 | Eval score flat while library grows |
| 10 | Formatting-trap in structured self-reflection | Alignment Tax arxiv 2604.06066 | Schema-pass rate >> manual-audit pass rate |
| 11 | Greenfield CLI ceiling | arxiv 2604.06742 | CLI task success flat despite effortLevel increase |
| 12 | Eval-validity gap (10x) | ClawBench, Apr 10 | Adopting tool based on sandbox benchmark alone |
| 13 | Winchester Mystery House codebase | Breunig Mar 26 | No human reader + no SBOM + growing deps |
| 14 | Subscription enforcement | Anthropic Apr 4 | CI using subscription billing |
| 15 | Ambient Anxiety Tax | Osmani Apr 7 | Developer unsure what agents are doing |
| 16 | Autoimmune disease (this architecture's unique contribution) | Metabolic principle | >20 MCP servers, >10 skills, >500 lines hooks |

## Appendix C: Composition Rules

**Cleanly composable:**
- Advisor Tool + Agent Teams — Advisor inside each teammate
- oh-my-claudecode + Agent Teams — OMC as workflow layer on native teams
- ntfy.sh + `defer` — notification channel for headless pause
- ralph-orchestrator + Claude Squad — Ralph as loop, Squad as pane manager
- agentgateway + any MCP server — gateway as transparent proxy
- mise + just — mise for tool versions, just for task definitions
- PluginEval + any skill — measurement layer for any skill

**Mutually exclusive:**
- Paperclip vs Ruflo — both wrap the session loop
- Gastown vs multiclaude — both auto-merge PR ratchets
- Max subscription vs API billing for same workload — pick one per use case
- claude-mem vs Karpathy Wiki pattern — different memory philosophies (vector vs structured)

**Obsoleted by native primitives:**
- Most external orchestration → Advisor Tool + Agent Teams (partial, ~60% coverage)
- External sandbox wrappers → native Linux seccomp (for trusted code)
- ccusage/kerf-cli → native `/cost` (for basic cost tracking; keep for advanced analytics)
