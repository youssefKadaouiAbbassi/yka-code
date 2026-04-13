# Architecture 04 — The Ultimate Claude Code Coding System (April 2026)

*Independent architect perspective. Budget: Max subscription ($200/mo) + free tooling.*

---

## 1. THE MASTER TABLE

### Tier Definitions
- **T0 (Kernel)**: Native Anthropic primitives — zero install, always available
- **T1 (Primary)**: Best-in-class for their slot — install on every workstation
- **T2 (Situational)**: Install when the project demands it
- **T3 (Emerging)**: Watch list — promising but unproven or <6 months old

### 1.1 Core Harness & Orchestration

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 1 | CLI Kernel | **Claude Code v2.1.101** | T0 | Max $200/mo | The harness. Opus 4.6 + Sonnet 4.6 + Haiku 4.5. 1M context. Native tools: Read, Edit, Write, Bash, Glob, Grep, Agent, Monitor, TaskCreate, WebSearch, WebFetch, LSP, NotebookEdit. | `curl -fsSL https://claude.ai/install.sh \| bash` |
| 2 | Advisor Pattern | **Advisor Tool** (beta) | T0 | Included | Server-side Haiku executor + Opus advisor in single `/v1/messages` call. 41.2% SWE-bench Multilingual vs 19.7% Haiku solo at **85% lower cost**. Collapses "route Opus for planning, Sonnet for execution" into a native primitive. | Beta header `advisor-tool-2026-03-01` |
| 3 | Agent Teams | **Native Agent Teams** (experimental) | T0 | Included | Multi-agent with worktree isolation. Each teammate gets own context window (~40% utilization vs 80-90% solo). `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. | settings.json env var |
| 4 | Managed Agents | **Claude Managed Agents** (beta) | T0 | $0.08/session-hr | Fully managed: sandboxed execution, checkpointing, credential vaults, SSE streaming, durable event sourcing. p50 TTFT ~60% lower, p95 >90% lower. | Beta header `managed-agents-2026-04-01` |
| 5 | Agent CLI | **`ant` CLI** | T0 | Free | GitOps for Managed Agent definitions. Version API resources (agents, skills, beta headers) in YAML. CI/CD for agent configs. | `uvx anthropic-cli` |
| 6 | Orchestration Framework | **oh-my-claudecode** (OMC) | T1 | Free | Teams-first multi-agent orchestration. Specialized agents (executor, planner, reviewer, verifier, etc.). Skills system, hooks, state management. 4.5k stars. | CC plugin |
| 7 | Agent Library | **wshobson/agents** | T1 | Free | 33.4k stars. 182 agents + 16 orchestrators + 149 skills + 96 commands across 77 plugins. Ships **PluginEval** quality framework (Wilson/Clopper-Pearson CI, Elo ranking, Bronze-Platinum badges). The substrate other platforms reference. | `uv run plugin-eval score` |
| 8 | TUI Multi-Agent | **Claude Squad** | T1 | Free | 8k stars. TUI for parallel CC sessions in isolated worktrees. Still wins for pure terminal-ops workflow even with native Agent Teams. | `go install` |
| 9 | Ralph Loop | **ralph-orchestrator** | T1 | Free | 2.5k stars. Canonical external loop-runner for the "Ralph Wiggum" autonomous technique. Production-tested exit detection. | MIT |
| 10 | Walk-Away Agent | **OpenHands** | T2 | Free | 71k stars. Within 2-6% of frontier on SWE-Bench Verified. Self-hostable, model-agnostic. For "give ticket, come back later" workflows. | MIT |
| 11 | Walk-Away (Cloud) | **Devin** | T2 | $20/mo Core | Most autonomous. Multi-session state across days. Responds to PR review comments. Caution: default training opt-in. | Commercial |
| 12 | Vendor-Neutral Harness | **myclaude** (stellarlinkco) | T2 | Free | 2.6k stars. AGPL-3.0. Works with Claude Code, Codex, Gemini, OpenCode. For multi-vendor shops. | AGPL |
| 13 | Self-Improving Agent | **NousResearch/hermes-agent v0.8.0** | T3 | Free | 57.9k stars. Self-improving agent creating skills from experience. Runs on Claude/GPT/Llama via OpenRouter. | MIT |
| 14 | Meta-Agent | **kevinrgu/autoagent** | T3 | Free | 4k stars. Human edits `program.md`, meta-agent rewrites `agent.py`, benchmarks decide commits. Purest Dark Factory implementation. | MIT |

### 1.2 MCP Servers — Dev Tools & Code Intelligence

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 15 | GitHub | **github/github-mcp-server** | T1 | Free | Official. Rewritten in Go. 51+ tools: PRs, issues, code scanning, Projects, `get_me`, OAuth scope filtering. | `claude mcp add github -- github-mcp-server stdio` |
| 16 | Code Intelligence | **Serena v1.1.0** | T1 | Free | Language-server-backed code navigation. **Use new install command** (old uvx form deprecated April 11 2026). | `uv tool install -p 3.13 serena-agent@latest --prerelease=allow` |
| 17 | Structural Search | **ast-grep + ast-grep-mcp** | T1 | Free | 13.4k stars. Tree-sitter structural pattern search over 20+ languages. Architecturally different from regex: matches AST nodes. | `claude mcp add ast-grep -- npx @ast-grep/mcp` |
| 18 | Error Monitoring | **Sentry MCP** | T1 | Free tier | **Remote HTTP with OAuth** at `https://mcp.sentry.dev/mcp`. No local install needed. Also available as CC plugin. | `claude mcp add --transport http sentry https://mcp.sentry.dev/mcp` |
| 19 | Sequential Reasoning | **Sequential Thinking MCP** | T1 | Free | Step-by-step reasoning server. Prevents premature conclusions on complex debugging chains. | Official reference server |
| 20 | Live Docs | **Context7 MCP** | T1 | Free (rate-limited) | Live, version-accurate library docs. Requires `--api-key` from `context7.com/dashboard` for unrestricted use. | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest --api-key KEY` |
| 21 | Probe Search | **probelabs/probe** | T2 | Free | 537 stars. ripgrep + tree-sitter AST + MCP server. Returns compact ranked spans. Lighter than Serena for search-only. | MIT |
| 22 | Semgrep | **Semgrep** | T2 | Free | LGPL-2.1. OWASP rule sets. Best as PostToolUse hook for auto-scanning edited files. | `pip install semgrep` |

### 1.3 MCP Servers — Databases & Cloud

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 23 | PostgreSQL | **Supabase MCP** | T1 | Free tier | 20+ tools: DB, auth, storage, edge functions. Full backend in one MCP. | `claude mcp add supabase -- npx supabase-mcp` |
| 24 | Multi-DB | **googleapis/mcp-toolbox** | T2 | Free | Official Google. BigQuery + AlloyDB + Spanner + CloudSQL + Postgres + MySQL. v0.30.0. | Self-hosted HTTP |
| 25 | Terraform | **hashicorp/terraform-mcp-server** | T2 | Free | Official HashiCorp. Registry and Cloud APIs. | MCP server |
| 26 | Kubernetes | **Lens MCP** | T2 | Free | Pod events, logs, resource limits, SRE queries. | MCP server |

### 1.4 MCP Servers — Web, Search & Scraping

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 27 | Web Scraping | **Firecrawl** | T1 | Free tier | Anti-bot handling. Scrape, search, crawl, map. Official CC plugin. | Plugin marketplace |
| 28 | Browser Automation | **Playwright MCP** | T1 | Free | 25+ tools. Accessibility tree. YAML snapshots 4x fewer tokens. Official CC plugin. | Plugin marketplace |
| 29 | Browser Direct | **Claude in Chrome** | T2 | Free | Direct Chrome control. GIF recording. Console/network inspection. | MCP extension |
| 30 | Web Search | **Brave Search MCP** | T2 | Free | Privacy-focused. No tracking. Complements native WebSearch. | MCP server |

### 1.5 MCP Servers — Design, Docs & Comms

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 31 | Design-to-Code | **Figma MCP** | T1 | Free | Official Anthropic partner. `use_figma` tool. Canvas read + manipulation. | MCP server |
| 32 | Diagrams | **Mermaid MCP** | T1 | Free | Live preview + validation. Also via Mermaid Chart connector. | `claude mcp add mermaid -- npx @veelenga/claude-mermaid` |
| 33 | Slack | **Slack MCP** | T2 | Free | Team messaging. Via Composio or direct. | MCP server |
| 34 | Payments | **Stripe MCP** | T2 | Free | Official at `mcp.stripe.com`. 25 tools, full payment lifecycle. | Remote HTTP |
| 35 | Deployment | **Vercel MCP** | T2 | Free | Official at `mcp.vercel.com`. OAuth + Streamable HTTP. | Remote HTTP |
| 36 | Linear | **Linear MCP** | T2 | Free | Official at `mcp.linear.app`. Remote. | Remote HTTP |

### 1.6 Memory & Context

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 37 | Native Memory | **CLAUDE.md + auto-memory** | T0 | Free | Hierarchical: `~/.claude/CLAUDE.md` (global) → project `CLAUDE.md` → package-level. Read every session. | Built-in |
| 38 | Vector Memory | **mempalace** | T1 | Free | 23k stars. 19 MCP tools. 96.6% LongMemEval. Local ChromaDB + SQLite. Zero API cost. | `pip install mempalace` |
| 39 | Session Memory | **claude-mem** | T1 | Free | 46.1k stars. Auto-capture + compress + inject. Purpose-built for CC plugin architecture. Hooks into session lifecycle. | CC plugin |
| 40 | Universal Memory | **supermemory** | T2 | Freemium | 15k stars. Universal memory API. Cross-agent. | CC plugin |
| 41 | Graph Memory | **memento-mcp** | T2 | Free | Neo4j-backed. Knowledge graph + relationship tracking. For complex domain models. | MCP server |
| 42 | Hippocampal | **Hippo** | T3 | Free | Biologically-inspired. Zero external deps. HN 128 pts. | `hippo-memory` |
| 43 | Wiki Pattern | **Obsidian + qmd** | T2 | Free | Karpathy's LLM Wiki pattern. BM25/vector local MCP search over Markdown. Refinement-based, aligned with Skill-Usage-Bench findings. | `Ar9av/obsidian-wiki` |

### 1.7 Security & MCP Governance

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 44 | Security Scanning | **Claude Code Security** (native) | T0 | Included | Built-in Opus 4.6 vuln scanning. 500+ vulns found. | Native |
| 45 | Security Skills | **Trail of Bits Skills** | T1 | Free | 12+ professional security-focused audit skills. 800 stars. | CC skill |
| 46 | SAST + Secrets | **Aikido Security** | T1 | Free | SAST, secrets, IaC misconfiguration. Official CC plugin. | Plugin |
| 47 | Security Review CI | **claude-code-security-review** | T1 | Free | Official Anthropic GitHub Action for PR security review. | GitHub Action |
| 48 | MCP Gateway | **agentgateway** | T1 | Free | 2.4k stars. Linux Foundation, Rust. First proxy built natively on BOTH MCP and A2A protocols. Open-standard mesh fabric. | Rust binary |
| 49 | MCP Federation | **IBM/mcp-context-forge** | T2 | Free | 3.6k stars. Federates MCP + A2A + REST + gRPC with guardrails + OTEL. | Apache 2.0 |
| 50 | MCP Gateway (K8s) | **microsoft/mcp-gateway** | T2 | Free | 574 stars. K8s-native StatefulSets, session-aware routing. Production deployment model. | K8s |
| 51 | Supply-Chain Monitor | **ShieldNet** | T2 | Free | Network-level behavioral monitoring. F1=0.995, 0.8% FP against SC-Inject-Bench (10k+ malicious tools). | Research |
| 52 | SBOM | **syft + cyclonedx** | T1 | Free | Continuous SBOM generation. Required for Winchester Mystery House defense. | CLI |

### 1.8 Observability & Cost

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 53 | Native Telemetry | **OTEL export** (built-in) | T0 | Free | `CLAUDE_CODE_ENABLE_TELEMETRY=1`. Metrics, events, optional distributed traces. | Env var |
| 54 | Native Cost | **`/cost`** (built-in, v2.1.92) | T0 | Free | Per-model + cache-hit breakdown. First-class since April 2026. | Built-in |
| 55 | Tracing | **Langfuse v3** (self-host) / **v4** (cloud) | T1 | Free (self-host) | v3: self-host requires MinIO (cannot drop). v4 cloud: 10x dashboard speedup, observations-first data model. v4 self-host TBD. | `docker compose up` |
| 56 | OTEL Backend | **claude-code-otel** → **SigNoz/Grafana** | T1 | Free (self-host) | Push CC telemetry to Grafana Cloud or SigNoz. Full token/cost/latency dashboards. | OTEL config |
| 57 | Datadog MCP | **datadog-labs/mcp-server** | T2 | Paid | GA March 2026. 16+ tools: logs/metrics/traces/incidents + APM/LLM Obs. Fills PostHog archival gap. | `claude mcp add --transport http datadog https://mcp.datadoghq.com/...` |
| 58 | Team Dashboard | **agents-observe** | T2 | Free | First CC-native real-time team dashboard. Streams hook events + tokens + latency. Lighter than Langfuse for team-local. | HN 76 pts |
| 59 | Cost Supplementary | **ccusage / ccflare** | T2 | Free | CLI and web UI for usage metrics. Downgraded from primary — native `/cost` is now first-class. | CLI/Web |
| 60 | Auto-Tracing | **W&B Weave plugin** | T2 | Free tier | Auto-tracing (not manual instrumentation) for CC. Latent.space April 10. | Plugin |

### 1.9 Sandbox & Isolation

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 61 | Native Sandbox | **Linux subprocess sandbox** (v2.1.98) | T0 | Free | PID namespace isolation + seccomp. **Production-stable** since April 9 2026. | Native |
| 62 | Docker Sandbox | **Docker Sandboxes** (official) | T1 | Free | Official Docker microVM-based isolation. For untrusted code execution. | `docker` |
| 63 | Container Dev Env | **container-use** (Dagger) | T1 | Free | Dev environments for coding agents. Reproducible, isolated. | Dagger |
| 64 | Cloud Sandbox | **E2B** | T1 | Free tier | Firecracker microVM. ~150ms boot. Purpose-built for AI code execution. | `pip install e2b` |
| 65 | Persistent Sandbox | **Fly Sprites** | T1 | Pay-per-use | Persistent Linux computers (NVMe survives shutdown). `--skip-console` for CI. 100GB NVMe, 8 CPU default. NO `--cpu`/`--disk` flags. | `sprite create` |
| 66 | GPU Sandbox | **Modal** | T2 | ~$0.12-0.14/vCPU-hr | Python-first. Unmatched for GPU workloads. gVisor isolation. **Corrected pricing** (corpus had ~$0.047). | `modal` CLI |
| 67 | YC Sandbox | **Freestyle** | T3 | TBD | YC-backed. Snapshot/restore + PR-delivery REST API. HN 322 pts. | `freestyle.sh` |
| 68 | Notebook Sandbox | **Marimo-pair** | T3 | Free | Notebook-as-sandbox pattern. Reactive Python notebooks where agent edits cells. HN 134 pts. | New pattern |

### 1.10 Workstation & Inner Loop

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 69 | Tool Version Mgr | **mise** | T1 | Free | 26.6k stars. Replaces asdf + nvm + pyenv + direnv + make. `.mise.toml` gives Claude reproducible tool versions. | Single binary |
| 70 | Task Runner | **just** | T1 | Free | 32.8k stars. Simplest hook target. `justfile` is Claude-readable for self-documentation. | `cargo install just` |
| 71 | Monorepo Build | **Turborepo** | T1 | Free | 30.2k stars. Rust. `turbo run build --filter=...[HEAD]` limits rebuild to Claude's changes only. | `npm i -g turbo` |
| 72 | File Watch | **watchexec** | T1 | Free | 6.8k stars. Closes edit→compile loop between Claude turns. | `cargo install watchexec-cli` |
| 73 | Dev Env | **devenv 2.0** | T2 | Free | 6.7k stars. Rust C-FFI. **<100ms activation** (March 2026). Nix without Nix pain. | `cachix/devenv` |
| 74 | Process Mgr | **mprocs** | T2 | Free | Parallel process manager. Multiple dev servers in one view. | `cargo install mprocs` |

### 1.11 CI/CD & GitHub Actions

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 75 | PR Agent | **claude-code-action v1.0.93** | T1 | Free | Official Anthropic. PR review, code implementation, issue triage. @v1 is current major (April 10 2026). | GitHub Action |
| 76 | Cross-Vendor Review | **CodeRabbit** | T1 | Free tier | 2M+ repos, 13M+ PRs, 82% bug-catch rate. BYOK routing. Different model reviewing Claude's output = true Principle 1. | SaaS |
| 77 | Self-Hosted Review | **kodustech/kodus-ai** | T2 | Free | 1k stars. AGPLv3. AST-aware, model-agnostic. Only OSS self-hosted option. | Self-host |
| 78 | Durable Execution | **Absurd** | T2 | Free | 5 months production. Postgres-only durable execution. TS/Python/Go SDKs. For LLM agent loop checkpointing. | `earendil-works/absurd` |
| 79 | Config Linter | **agnix** | T1 | Free | Comprehensive linter for CC agent files (.claude/, CLAUDE.md, skills). IDE plugins. | `agent-sh/agnix` |

### 1.12 Notification & Approval

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 80 | Push Notifications | **ntfy.sh** | T1 | Free | 29.7k stars. Self-hostable. Interactive Allow/Deny phone buttons. `defer` permission (v2.1.89) makes this architectural — without notification channel, `defer` has no surface. 0.4% FP rate confirmed. | `claude-remote-approver` |
| 81 | Telegram Approval | **Telegram Bot API** | T2 | Free | Inline keyboard buttons. Lowest-friction interactive approval. `claude-notifications-go` plugin. | Plugin |
| 82 | Slack Notifications | **Slack Incoming Webhooks** | T2 | Free | Team environments. Block Kit for rich approval UIs. | Webhook |

### 1.13 LLM Gateway & Routing

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 83 | Gateway | **LiteLLM v1.83.x+** | T1 | Free | 43k stars. Only gateway Anthropic officially documents for CC. **PIN TO 1.83.x+** — v1.82.7-8 were compromised with credential-stealing malware (March 2026). | `pip install litellm>=1.83.0` |
| 84 | Local Inference | **Ollama** | T2 | Free | 169k stars. Native `/anthropic` compat. `ollama launch claude`. De facto local runtime. | `ollama` |
| 85 | Team Governance | **Portkey** | T2 | Free | 11.3k stars. Budget caps, audit log, per-key spend. | MIT |
| 86 | AI Gateway (Vercel) | **Vercel AI Gateway** | T2 | Free | `ANTHROPIC_BASE_URL="https://ai-gateway.vercel.sh"`. **TRAP:** `ANTHROPIC_API_KEY` must be empty string, not unset. | Env vars |
| 87 | Agent-Aware Router | **9router** | T3 | Free | 2.3k stars. <1ms locally, per-tool-call model selection. Web3 payment rails. | MIT |

### 1.14 Skills, Plugins & Frameworks

| # | Slot | Tool | Tier | Cost | Why This Wins | Install |
|---|------|------|------|------|---------------|---------|
| 88 | Core Skills | **Superpowers** | T1 | Free | 1k stars. Bundle covering core SE competencies. **Caveat**: Skill-Usage-Bench (arxiv 2604.04323) shows library gains collapse in realistic retrieval. Refinement > accumulation. | CC skill |
| 89 | Spec-Driven Dev | **Spec-Kit** | T1 | Free | GitHub official. `/speckit.constitution` → `/speckit.specify` → `/speckit.plan` → `/speckit.tasks` → `/speckit.implement`. | `uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1` |
| 90 | BMAD Method | **BMAD-METHOD** | T1 | Free | Business → Market → Architecture → Development. Slash commands inside Agent Teams. | CC skill |
| 91 | Context Kit | **ContextKit** | T2 | Free | Systematic 4-phase development framework. | CC skill |
| 92 | Context Compression | **claude-token-efficient** | T1 | Free | HN 471 pts (highest context-compression item in 2-week window). Universal CLAUDE.md system-prompt shaping. | Drop-in CLAUDE.md |
| 93 | Config Linting | **claude-rules-doctor** | T2 | Free | Detect dead `.claude/rules/` files by checking path globs. | CLI |
| 94 | Plugin (Accessibility) | **a11ymcp** | T2 | Free | 24 WCAG 2.0-2.2 scanning tools. | MCP server |
| 95 | Plugin (i18n) | **Intl Skill** | T2 | Free | Internationalization patterns. | CC skill |

### 1.15 Emerging / Watch List

| # | Slot | Tool | Tier | Stars | Why Watch |
|---|------|------|------|-------|-----------|
| 96 | Open Harness Fork | **openclaude** | T3 | 20.6k | Born April 1 from CC npm source leak. MIT shim enabling 200+ models. Most consequential harness event of the window. |
| 97 | Universal Harness | **OpenHarness** (HKU) | T3 | 8.8k | Academic, LLM-agnostic harness. Model-neutral counterpart to CC. |
| 98 | Rust Agent Runtime | **zeroclaw** | T3 | 30k | <5MB RAM, <10ms startup. Edge/IoT use case. |
| 99 | Declarative Orchestration | **bernstein** | T3 | 100 | YAML agent orchestration with zero LLM coordination overhead. Deterministic routing. |
| 100 | Durable Execution | **Temporal** | T2 | Established | Promote from sidecar to primary for enterprise durable agent loops. |

---

## 2. SETTINGS.JSON — Complete Production Configuration

### 2.1 User Settings (`~/.claude/settings.json`)

```jsonc
{
  // ── Model & Effort ──────────────────────────────────────────
  "model": "claude-opus-4-6",
  // NOTE: v2.1.94 changed default effortLevel from "medium" → "high" for
  // API/Bedrock/Vertex/Foundry/Team/Enterprise users (NOT Pro/Max).
  // Max subscription users get "high" by default. Explicit setting prevents drift.
  "effortLevel": "high",

  // ── Permissions ─────────────────────────────────────────────
  "permissions": {
    // "acceptEdits" is the sweet spot: auto-approves file writes,
    // still prompts for Bash/MCP/network. NOT "autoAccept" (wrong key).
    "defaultMode": "acceptEdits",
    
    // Allowlists for common safe operations
    "allow": [
      "Read(*)",
      "Edit(*)",
      "Write(*)",
      "Glob(*)",
      "Grep(*)",
      "WebSearch(*)",
      "WebFetch(*)",
      "Agent(*)",
      "TaskCreate(*)",
      "TaskUpdate(*)",
      "TaskGet(*)",
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(pnpm *)",
      "Bash(bun *)",
      "Bash(just *)",
      "Bash(mise *)",
      "Bash(turbo *)",
      "Bash(git status*)",
      "Bash(git log*)",
      "Bash(git diff*)",
      "Bash(git branch*)",
      "Bash(gh pr *)",
      "Bash(gh issue *)",
      "Bash(cargo build*)",
      "Bash(cargo test*)",
      "Bash(cargo clippy*)",
      "Bash(python -m pytest*)",
      "Bash(uv run *)",
      "Bash(ls *)",
      "Bash(wc *)",
      "Bash(which *)",
      "Bash(echo *)",
      "Bash(cat package.json*)",
      "Bash(cat Cargo.toml*)"
    ],
    
    // Explicit denials for dangerous patterns
    "deny": [
      "Bash(rm -rf /)",
      "Bash(rm -rf ~)",
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Bash(git clean -fd*)",
      "Bash(curl * | bash)",
      "Bash(curl * | sh)",
      "Bash(wget * | bash)",
      "Bash(chmod 777 *)",
      "Bash(dd if=*)",
      "Bash(mkfs.*)",
      "Bash(shutdown*)",
      "Bash(reboot*)"
    ]
  },

  // ── Environment Variables ───────────────────────────────────
  "env": {
    // Telemetry (basic metrics + events; NOT the distributed-traces beta)
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    // Agent Teams
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    // UI improvements
    "CLAUDE_CODE_NO_FLICKER": "1"
  },

  // ── Hooks ───────────────────────────────────────────────────
  "hooks": {
    // === SAFETY GATE: Block destructive Bash commands ===
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/bash-safety-gate.py \"$TOOL_INPUT\"",
            "blocking": true,
            "timeout": 5000
          }
        ]
      }
    ],
    
    // === AUTO-FORMAT: Run formatter after file edits ===
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/auto-format.py \"$TOOL_INPUT\"",
            "blocking": false,
            "timeout": 10000
          }
        ]
      }
    ],
    
    // === CONTEXT INJECTION: Enrich prompts with project state ===
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/context-inject.py \"$PROMPT\"",
            "blocking": true,
            "timeout": 3000
          }
        ]
      }
    ],
    
    // === SESSION AUDIT: Log session start for team observability ===
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/session-audit.py",
            "blocking": false,
            "async": true,
            "timeout": 5000
          }
        ]
      }
    ],
    
    // === STOP GATE: Verify before claiming completion ===
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/stop-verify.py \"$TOOL_INPUT\"",
            "blocking": true,
            "timeout": 10000
          }
        ]
      }
    ],

    // === NOTIFICATION: Push to phone on completion/pause ===
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "curl -s -d \"Agent finished: $AGENT_NAME\" ntfy.sh/my-claude-channel",
            "blocking": false,
            "async": true,
            "timeout": 5000
          }
        ]
      }
    ]
  },

  // ── Theme & Display ─────────────────────────────────────────
  "theme": "dark",
  "verbose": false,
  
  // ── Plugin Safety ───────────────────────────────────────────
  // Disable shell execution in skills if you don't trust the skill source
  // "disableSkillShellExecution": true,

  // ── Cost Guardrails (Max subscription) ──────────────────────
  // The Max subscription is $200/mo flat. No per-token billing.
  // But effortLevel discipline still matters for quality, not cost:
  // high = deep reasoning (default since v2.1.94 for non-Pro)
  // medium = standard tasks
  // low = quick lookups
  // Rotate effortLevel per-task, not per-session.
}
```

### 2.2 Project Settings (`.claude/settings.json` — committed to repo)

```jsonc
{
  // Project-specific model override (optional)
  // "model": "claude-sonnet-4-6",
  
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Bash(npm test*)",
      "Bash(npm run build*)",
      "Bash(npm run lint*)",
      "Bash(npm run dev*)",
      "Bash(docker compose *)"
    ]
  },

  // Project-specific hooks
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$FILE_PATH\" 2>/dev/null || true",
            "blocking": false,
            "timeout": 5000
          }
        ]
      }
    ]
  }
}
```

### 2.3 Project Local Settings (`.claude/settings.local.json` — NOT committed)

```jsonc
{
  "env": {
    // Personal API keys, tokens, etc.
    "GITHUB_TOKEN": "ghp_...",
    "SENTRY_AUTH_TOKEN": "sntrys_...",
    "CONTEXT7_API_KEY": "c7_..."
  }
}
```

---

## 3. CLAUDE.md — Complete System Prompt

### 3.1 Global CLAUDE.md (`~/.claude/CLAUDE.md`)

```markdown
# Global Development Standards

## Identity
You are an expert software engineer operating as my pair programmer.
I am a senior developer. Skip basics. Be terse. No trailing summaries.

## Architecture-First Protocol
Every non-trivial task follows this sequence — no exceptions:
1. **Research**: Read existing code. Understand the domain. Check git history.
2. **Plan**: Write explicit decisions, non-goals, alternatives considered.
   If the first artifact is code, the task is already broken.
3. **Implement**: Small, atomic changes. One concern per commit.
4. **Verify**: Run tests. Check types. Test the UI if applicable.
   Structured-output self-checks are insufficient — use prose-level judgment.
5. **Review**: Writer ≠ reviewer. Never self-approve in the same context.

## Verification Bottleneck
Verification is the bottleneck, not generation.
- Run the test suite before claiming completion.
- If no tests exist for the changed code, write them first.
- For UI changes, start the dev server and visually verify.
- Schema-validation passes are not semantic verification (arxiv 2604.06066).

## Concurrency Discipline
- Start with one fewer agent than feels comfortable.
- 2-4 agents is the productive band. Above 5 = comprehension debt.
- Use `run_in_background` for builds/tests. Use `Monitor` to stream.
- Agent Teams for independent subtasks. Direct tools for directed lookups.

## Cost Discipline
- effortLevel "high" is the default since v2.1.94. This is correct for 
  complex tasks. Use "medium" for standard file edits, "low" for lookups.
- Use /cost to check per-model + cache-hit breakdown.
- Prefer prompt caching: front-load stable context, vary the tail.

## Code Quality — Anti-Slop Rules
- No features beyond what was asked.
- No speculative abstractions. Three similar lines > premature helper.
- No docstrings/comments on unchanged code.
- No error handling for impossible scenarios.
- No backwards-compatibility shims. Delete unused code completely.
- No trailing summaries of what you just did.

## Tool Preferences
- Read > cat/head/tail. Edit > sed/awk. Write > echo/heredoc.
- Grep > grep/rg. Glob > find/ls.
- Break work into tasks (TaskCreate). Update as you go.
- Multiple independent tool calls in parallel. Always.

## Git Protocol
- NEVER amend unless explicitly asked.
- NEVER force-push. NEVER skip hooks.
- NEVER `git add .` — stage specific files.
- Commit messages: why > what. End with Co-Authored-By.
- Check for secrets (.env, credentials) before staging.

## Memory Protocol
- CLAUDE.md for durable project instructions.
- Do not duplicate what git log or the code itself tells you.
- Save to memory: user preferences, surprising corrections, 
  external references, project context not derivable from code.
```

### 3.2 Project CLAUDE.md (template for any project)

```markdown
# Project: {{PROJECT_NAME}}

## Stack
- Runtime: {{e.g., Node 22 / Python 3.13 / Rust 1.82}}
- Framework: {{e.g., Next.js 15 / FastAPI / Axum}}
- Database: {{e.g., PostgreSQL 17 via Supabase}}
- Package Manager: {{e.g., pnpm 10 / uv / cargo}}
- Build: {{e.g., Turborepo / cargo build}}
- Test: {{e.g., vitest / pytest / cargo test}}
- Lint: {{e.g., biome / ruff / clippy}}
- Format: {{e.g., prettier / ruff format / rustfmt}}

## Architecture
{{2-3 sentences describing the high-level architecture.}}

### Key Directories
- `src/` — Application source
- `tests/` — Test files mirror src/ structure
- `docs/` — Documentation (do NOT create unless asked)

### Key Patterns
{{List the 3-5 patterns that are non-obvious and load-bearing.
Only patterns Claude would get wrong without this instruction.}}

## Commands
```bash
# Development
{{package_manager}} run dev        # Start dev server
{{package_manager}} run build      # Production build
{{package_manager}} run test       # Run test suite
{{package_manager}} run lint       # Lint check
{{package_manager}} run typecheck  # Type check
```

## Conventions
- {{Naming conventions, file organization, import order, etc.}}
- {{Only include what Claude would get wrong by default.}}

## Do NOT
- {{Project-specific anti-patterns.}}
- {{Things Claude tends to do that are wrong for THIS project.}}

## When Compacting
Always preserve: list of modified files, test commands, 
current task context, any error messages being debugged.
```

---

## 4. .MCP.JSON — Complete MCP Server Configuration

### 4.1 Project `.mcp.json` (committed — team-shared servers)

```jsonc
{
  "mcpServers": {
    // ── Code Intelligence ─────────────────────────────────────
    "serena": {
      "command": "serena",
      "args": ["start-mcp-server", "--context", "ide-assistant", "--project", "."],
      "description": "Language-server-backed code navigation (v1.1.0)"
    },
    
    "ast-grep": {
      "command": "npx",
      "args": ["-y", "@ast-grep/mcp"],
      "description": "Structural AST pattern search over 20+ languages"
    },

    // ── Sequential Reasoning ──────────────────────────────────
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "description": "Step-by-step reasoning for complex problems"
    },

    // ── Documentation ─────────────────────────────────────────
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      },
      "description": "Live version-accurate library documentation"
    },

    // ── Diagrams ──────────────────────────────────────────────
    "mermaid": {
      "command": "npx",
      "args": ["-y", "@veelenga/claude-mermaid"],
      "description": "Mermaid diagram preview and validation"
    },

    // ── Memory ────────────────────────────────────────────────
    "mempalace": {
      "command": "mempalace",
      "args": ["serve"],
      "description": "Persistent cross-session memory (96.6% LongMemEval)"
    }
  }
}
```

### 4.2 User MCP Servers (`~/.claude.json` → `projects["*"].mcpServers`)

These go in `~/.claude.json` under the user's global config, NOT in settings.json (MCP is NEVER top-level in settings.json):

```jsonc
{
  "projects": {
    "*": {
      "mcpServers": {
        // ── GitHub (global — always available) ──────────────────
        "github": {
          "command": "github-mcp-server",
          "args": ["stdio"],
          "env": {
            "GITHUB_TOKEN": "${GITHUB_TOKEN}"
          }
        },
        
        // ── Brave Search (global) ───────────────────────────────
        "brave-search": {
          "command": "npx",
          "args": ["-y", "@anthropic/mcp-server-brave-search"],
          "env": {
            "BRAVE_API_KEY": "${BRAVE_API_KEY}"
          }
        },

        // ── Filesystem (global — scoped to home) ────────────────
        "filesystem": {
          "command": "npx",
          "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user"]
        }
      }
    }
  }
}
```

### 4.3 Remote MCP Servers (add via CLI — no local process)

```bash
# Sentry — Remote HTTP with OAuth (NOT stdio)
claude mcp add --transport http --scope user sentry https://mcp.sentry.dev/mcp

# Stripe — Official Anthropic partner
claude mcp add --transport http --scope user stripe https://mcp.stripe.com

# Vercel — Official remote with OAuth
claude mcp add --transport http --scope user vercel https://mcp.vercel.com

# Linear — Official remote
claude mcp add --transport http --scope user linear https://mcp.linear.app

# Datadog — Official (if you use Datadog)
claude mcp add --transport http --scope user datadog \
  "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp"

# Supabase — Full backend
claude mcp add --scope project supabase -- npx supabase-mcp
```

### 4.4 MCP Security Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                    DEVELOPER WORKSTATION                       │
│                                                               │
│  ┌─────────────┐    ┌──────────────────────────────────────┐ │
│  │ Claude Code  │───▶│  agentgateway (Rust, LF project)    │ │
│  │  v2.1.101   │    │  ┌──────────────────────────────┐   │ │
│  └─────────────┘    │  │ Policy Engine:                │   │ │
│                     │  │  - OWASP MCP Top 10 rules     │   │ │
│                     │  │  - Tool-call risk scoring      │   │ │
│                     │  │  - Rate limiting per server    │   │ │
│                     │  │  - Cedar policy (v2.1.100+)    │   │ │
│                     │  └──────────────────────────────┘   │ │
│                     │                                      │ │
│                     │  ┌──── stdio ─────┐ ┌── HTTP ──────┐│ │
│                     │  │ serena         │ │ sentry       ││ │
│                     │  │ ast-grep       │ │ stripe       ││ │
│                     │  │ mempalace      │ │ vercel       ││ │
│                     │  │ github-mcp     │ │ linear       ││ │
│                     │  │ context7       │ │ datadog      ││ │
│                     │  └────────────────┘ └──────────────┘│ │
│                     └──────────────────────────────────────┘ │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │ ShieldNet (network-level monitoring)                     │ │
│  │  F1=0.995 | 0.8% FP | SC-Inject-Bench (10k+ tools)    │ │
│  └─────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

**Key MCP security rules:**
1. MCP location split: user `~/.claude.json projects[path].mcpServers`; project `.mcp.json`; plugin `plugin.json`. **NEVER** top-level in `settings.json`.
2. Tool Search (lazy loading) reduces context usage by up to 95% — no need to load every tool upfront.
3. MCP tool result size raised to **500K chars** (v2.1.91) via `_meta["anthropic/maxResultSizeChars"]`.
4. **MCP HTTP/SSE memory leak (~50 MB/hr) was patched in v2.1.100.** Upgrade if running long sessions with HTTP MCP servers.
5. Between Jan-Feb 2026, 30+ CVEs filed against MCP servers — 43% were shell injection. Validate all MCP server inputs.

---

## 5. PRINCIPLES

### Principle 1: Verification Is the Bottleneck, Not Generation
Generation is commoditized. Verification is where quality lives.
- Writer ≠ reviewer. Never self-approve in the same active context.
- Use `code-reviewer` or `verifier` agents for the approval pass.
- Schema-validated self-checks produce "formatting traps" — syntactic alignment with missed semantic errors (arxiv 2604.06066 "Alignment Tax"). Verification must use prose-level judgment, not just schema validation.
- Cross-vendor review (CodeRabbit, Copilot reviewing Claude's output) is the only version of writer ≠ reviewer that honors model diversity, not just prompt-context separation.

### Principle 2: Design-Decision Deferral Is the Primary Failure Mode
AI acceleration of implementation **causes** design-decision deferral. You never slow down for the hard call. That deferral corrodes architectural clarity.
- If the first artifact of a task is code, the task is already broken.
- Every non-trivial task starts with: `research.md` → `plan.md` (explicit decision records, non-goals, alternatives) → implementation.
- Willison/Maganti convergence: working prototypes scrapped because high-level architecture was wrong despite passing tests.
- The Advisor Tool (Haiku executor + Opus advisor) makes this cheaper but not optional.

### Principle 3: Skill Accumulation Has Diminishing Returns; Refinement Is the Lever
Skill-Usage-Bench (arxiv 2604.04323, 34k real-world skills): library gains **collapse to near-zero in realistic retrieval**. Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench 2.0 only with **query-specific refinement**, NOT library size.
- "Install more skills" is not a strategy. **Measure skill outcomes** via PluginEval / eval loops / before-after benchmarks.
- Delete skills that don't improve outcomes. Split-test with/without.
- Karpathy's Wiki pattern (compiled knowledge base + BM25/vector search) outperforms skill hoarding.
- Corroborated by Ronacher's "Agent Psychosis" essay criticizing slop loops.

### Principle 4: Parallel Concurrency — Start Low
Three named anti-patterns (Osmani, April 7):
1. **Comprehension Debt**: More agents = more context to reconcile.
2. **Ambient Anxiety Tax**: Cognitive load of monitoring parallel work.
3. **Trust Calibration Overhead**: Verifying each agent's output.

Rule: **Start with one fewer agent than feels comfortable.** The 2-4 agent band is productive. Above 5 is comprehension debt. Native Agent Teams keep each teammate at ~40% context utilization vs 80-90% solo — use this, not more agents.

### Principle 5: Native Primitives Win When They're Real
Anthropic ships fast. Three primitives that just moved categories into the kernel:
- **Advisor Tool**: Collapses executor/advisor orchestration into a single API call.
- **`ant` CLI**: GitOps for Managed Agent definitions.
- **`"defer"` permission** (v2.1.89): Headless pause at 0.4% FP rate.
- **Monitor tool** (v2.1.98): First-class event streaming from background processes.
- **Native `/cost`** (v2.1.92): Per-model + cache-hit breakdown.
- **Linux subprocess sandbox** (v2.1.98): PID namespace + seccomp, production-stable.
- **Cedar policy syntax** (v2.1.100): Permissions-as-code.

**Re-evaluate slot rankings monthly against Anthropic's changelog**, not quarterly. Community tools that wrap what Anthropic just shipped natively should be downgraded immediately.

### Principle 6: Sandbox Isolation Is Non-Optional
- MCPSHIELD formalizes **23 MCP attack vectors** across 4 surfaces.
- Single-layer MCP defenses cover only **34%** of threats. Integrated architecture reaches **91%**.
- ShieldNet network-level monitoring: F1=0.995 at 0.8% FP.
- Project Glasswing/Mythos: confirmed agent-escape incident (April 7 2026).
- Replit 2.5-year wipeout + SaaStr/Replit production DB deletion (July 2025): same class of failure, different products.
- **Defense-in-depth**: native Linux sandbox (PID namespace + seccomp) + Docker/E2B for untrusted code + network egress policy + Cedar permissions + continuous SBOM.

### Principle 7: Winchester Mystery House Supply-Chain Risk
AI-generated codebases have **no human reader** who would notice a compromised transitive dependency. AI commits average ~1,000 net lines (2 OOM above human rate), producing idiosyncratic undocumented codebases.
- Combined with LiteLLM PyPI compromise (v1.82.7-8, March 2026) and MCPSHIELD findings (single-layer defenses ≤34%), supply-chain surface is larger than human codebases by construction.
- **Required defenses**: continuous SBOM (syft/cyclonedx), Dependabot, ShieldNet, pin all dependencies, verify checksums, pull from GitHub releases not just PyPI/npm.

### Principle 8: The Anthropic Subscription Enforcement Event (April 4 2026)
Anthropic explicitly cut subscription access for non-Anthropic harnesses: **Cline, Cursor, Windsurf, OpenClaw**.
- This is now an enforcement action, not just policy text.
- **CI must use API billing**, not Max subscription.
- If you use alternative harnesses long-term, you need API billing.
- This strengthens the "dual-tier" architecture: Max for interactive, API for CI/headless.

### Principle 9: effortLevel Default Changed — Cost Models Are Stale
v2.1.94 (April 7 2026): default `effortLevel` changed from `medium` → `high` for API/Bedrock/Vertex/Foundry/Team/Enterprise (NOT Pro/Max).
- Any cost model based on medium-default is stale.
- For Max subscription ($200/mo flat): this is free quality — always use high.
- For API billing: this 2-3x token usage. Explicit effortLevel rotation per task type is now mandatory.

### Principle 10: Context Is Finite — Compression Is Architecture
The 1M context window (GA for Opus/Sonnet, no pricing premium) creates a false sense of abundance. Performance still degrades as context fills.
- CLAUDE.md is read every session — every word costs tokens every turn. Prune ruthlessly.
- `claude-token-efficient` (HN 471 pts) for system-prompt shaping.
- Use subagents for exploration (they return summaries, not raw file contents).
- Use `/btw` for ephemeral questions that shouldn't enter context.
- When compacting, preserve: modified files list, test commands, current task, error messages.
- Tool Search (MCP lazy loading) reduces tool-definition context by 95%.

### Principle 11: Stateless Harness + Durable Event Sourcing
This is the **official Anthropic naming** of the correct architecture pattern (April 8 2026 engineering post):
- **Harness is ephemeral**: session state is not precious.
- **Session is an append-only event log** stored externally.
- **Sandbox is isolated**: compute boundary is hard.
- This means: don't store state in the harness. Don't rely on session persistence. Use external durable stores (Absurd/Temporal for loops, mempalace/claude-mem for memory, git for code).

### Principle 12: Greenfield CLI Has a Generation Ceiling
arxiv 2604.06742: top models <43% on greenfield CLI generation. **Compute scaling does not help.**
- For greenfield tasks: use Advisor Tool (Haiku executor + Opus advisor) explicitly.
- Add human checkpoints at architecture decisions.
- Supervision checkpoints > more thinking tokens.

---

## 6. UNIQUE INSIGHT: The Convergence Thesis

### The Three Collapses Happening Simultaneously (April 2026)

**Collapse 1: Orchestration → Kernel.** The Advisor Tool, Managed Agents, Agent Teams, `defer`, and Monitor tool have collectively absorbed ~60% of what community orchestration platforms (Paperclip, Ruflo, Gastown, multiclaude) wrapped. The orchestration layer is being eaten from below by Anthropic shipping primitives faster than the community can build wrappers. The correct response is not "don't use orchestration" but "use orchestration for the 40% that's genuinely novel" — team-specific workflows, domain-specific agent topologies, custom approval chains. Everything else should use the native primitive.

**Collapse 2: Skill Accumulation → Skill Refinement.** The Skill-Usage-Bench finding (gains collapse to near-zero in realistic retrieval) is the most under-appreciated result in the April 2026 research window. The entire "awesome-lists" ecosystem — 13,729 OpenClaw skills, 5,400 VoltAgent skills, 1,367 community skills — is a **library** problem being treated as an **accumulation** problem. The correct architecture is:
1. Start with <10 skills that cover your actual daily workflow.
2. Measure each skill's impact via PluginEval or A/B evaluation.
3. Refine the ones that work based on failure signal.
4. Delete the rest.

This is Karpathy's Wiki pattern applied to skills: a compiled, curated, tested knowledge base beats a sprawling collection every time.

**Collapse 3: Security as Afterthought → Security as Substrate.** Three independent April 2026 events converge:
- MCPSHIELD: 23 attack vectors, single-layer defenses ≤34%, 177k+ MCP tools analyzed.
- ShieldNet: F1=0.995 network-level detection of supply-chain-poisoned MCP tools.
- Mythos agent-escape: confirmed incident of sandboxed agent accessing internet.
- LiteLLM PyPI compromise: credential-stealing malware in production gateway.
- OWASP MCP Top 10 + OWASP Agentic Top 10: two new frameworks in one quarter.
- 30+ CVEs filed against MCP servers in 2 months (43% shell injection).

The implication: **MCP security governance is now a primary architectural slot**, not a checkbox. The v3 blueprint had 24 slots for "which MCP servers to use" and **zero slots** for "how to govern the MCP layer itself." This architecture (arch-04) adds agentgateway + ShieldNet + SBOM as T1 requirements, not optional add-ons.

### The Meta-Insight: Architecture as Continuous Re-Evaluation

The most dangerous belief in April 2026 is that you can design a Claude Code system once and maintain it quarterly. The evidence:

- 7 Claude Code releases in 10 days (v2.1.89 → v2.1.101)
- 3 new Anthropic primitives (Advisor, `ant`, `defer`) in one week
- effortLevel default change that invalidates all prior cost models
- Subscription enforcement event that forces billing architecture changes
- 5 new community orchestration platforms in 2 weeks
- 2 new OWASP frameworks in one quarter

**The system described in this document will be partially obsolete within 30 days.** The correct response is not to resist obsolescence but to build the architecture for continuous re-evaluation:

1. **Monthly Anthropic changelog review** → re-rank native primitives vs community tools.
2. **Weekly PluginEval runs** → measure which skills/MCP servers actually improve outcomes.
3. **Continuous SBOM + ShieldNet** → supply-chain monitoring is not a one-time audit.
4. **Quarterly principle review** → do the principles still hold given new evidence?

The ultimate Claude Code system is not a configuration. It is a **discipline of continuous measurement against first-principles evidence.** The configuration is just today's snapshot of that discipline.

---

## Appendix A: Release Timeline (v2.1.89 → v2.1.101)

| Version | Date | Key Features | Impact |
|---------|------|--------------|--------|
| v2.1.89 | Apr 1 | `"defer"` permission; `PermissionDenied.retry`; `CLAUDE_CODE_NO_FLICKER=1` | Unlocks headless-pause patterns |
| v2.1.90 | Apr 1 | `/powerup` interactive feature-learning | Educational |
| v2.1.91 | Apr 2 | MCP result size → 500K chars; plugin `bin/` auto-PATH; `disableSkillShellExecution` | Plugin architecture expansion |
| v2.1.92 | Apr 4 | Interactive Bedrock wizard; `/cost` per-model breakdown; `forceRemoteSettingsRefresh` | Native cost tooling |
| v2.1.94 | **Apr 7** | **effortLevel default: medium → high** (API/Bedrock/Vertex/Foundry/Team/Enterprise, NOT Pro) | **HIGH IMPACT** — cost model invalidation |
| v2.1.97 | Apr 9 | Focus View (`Ctrl+O`); enhanced permissions | UI improvement |
| v2.1.98 | Apr 9 | **Monitor tool**; **Linux subprocess sandbox (PID namespace + seccomp, stable)**; Perforce mode | Two new primitives |
| v2.1.100 | Apr 10 | Cedar policy syntax highlighting; MCP HTTP/SSE memory leak fix (~50 MB/hr); Agent SDK renames | Security + stability |
| v2.1.101 | Apr 10 | `/team-onboarding` command | Onboarding |

## Appendix B: Named Failure Modes

| # | Failure | Evidence | Defense | Canary |
|---|---------|----------|---------|--------|
| 1 | Formatting-trap in structured-output self-reflection | arxiv 2604.06066 | Prose-level critic agents + schema-validated ones | Divergence between schema-pass rate and manual-audit rate |
| 2 | Skill-library collapse in realistic retrieval | arxiv 2604.04323 (34k skills) | PluginEval; delete non-performing skills | Eval score flat while library grows |
| 3 | Greenfield CLI generation ceiling | arxiv 2604.06742 (<43%) | Advisor Tool + human checkpoints | CLI success flat despite effortLevel increases |
| 4 | LiteLLM PyPI supply-chain compromise | Confirmed March 2026 | Pin ≥1.83.x; audit `~/.anthropic/` for exfil | Unexpected outbound from LiteLLM |
| 5 | Mythos agent-escape | Project Glasswing, Apr 7 | Layered sandbox + network egress + Cedar | Outbound from sandboxed agent |
| 6 | ClawBench eval-validity gap | 70% sandbox vs 6.5% realistic (10x gap) | Never trust benchmark without realistic replication | n/a |
| 7 | Replit 2.5-year wipeout + SaaStr DB deletion | Two confirmed incidents | Destructive ops need structural gates, not advisory warnings | n/a |
| 8 | 80x thrashing | GitHub #42796 | effortLevel discipline; cost monitoring; stop gates | Token burn rate spikes without progress |
| 9 | Comprehension debt from over-parallelism | Osmani April 7 | Start with one fewer agent than comfortable | Review quality degrades with agent count |
| 10 | Winchester Mystery House supply-chain | Breunig + Nesbitt convergence | Continuous SBOM + ShieldNet + Dependabot | AI-generated deps nobody has read |
| 11 | MCP HTTP/SSE memory leak | Patched v2.1.100 (~50 MB/hr) | Upgrade to v2.1.100+ | Memory growth in long MCP sessions |
| 12 | Subscription enforcement (Apr 4) | Cline/Cursor/Windsurf/OpenClaw cut off | CI must use API billing, not Max subscription | Auth failures from scripted harnesses |

## Appendix C: Quick-Start Installation Script

```bash
#!/usr/bin/env bash
# Ultimate Claude Code System — Quick Start (April 2026)
# Budget: Max subscription ($200/mo) + free tooling
set -euo pipefail

echo "=== Installing Claude Code ==="
curl -fsSL https://claude.ai/install.sh | bash

echo "=== Installing Core MCP Servers ==="
# GitHub
claude mcp add --scope user github -- github-mcp-server stdio

# Sentry (Remote HTTP — no local install)
claude mcp add --scope user --transport http sentry https://mcp.sentry.dev/mcp

# Context7 (requires API key)
claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp@latest

# ast-grep
claude mcp add --scope project ast-grep -- npx -y @ast-grep/mcp

# Sequential Thinking
claude mcp add --scope project sequential-thinking -- \
  npx -y @modelcontextprotocol/server-sequential-thinking

# Mermaid
claude mcp add --scope project mermaid -- npx -y @veelenga/claude-mermaid

echo "=== Installing Core Tools ==="
# Serena (code intelligence) — NEW install command as of April 11 2026
uv tool install -p 3.13 serena-agent@latest --prerelease=allow

# mempalace (persistent memory)
pip install mempalace

# LiteLLM (gateway) — PIN TO 1.83.x+ (v1.82.7-8 compromised)
pip install "litellm>=1.83.0"

# mise (tool version manager)
curl https://mise.run | sh

# just (task runner)
cargo install just || brew install just

# Spec-Kit
uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1

echo "=== Installing Notification Stack ==="
# ntfy.sh (for defer + headless approval)
# Self-host or use ntfy.sh cloud
pip install ntfy || echo "Configure ntfy.sh cloud at https://ntfy.sh"

echo "=== Installing Security Tools ==="
# SBOM generation
pip install syft || brew install syft
pip install cyclonedx-bom

# Semgrep
pip install semgrep

echo "=== Installing Observability ==="
# claude-code-otel
pip install claude-code-otel

# Config linting
# agnix (CC agent file linter)
npm install -g @agent-sh/agnix

echo "=== Done. Configure settings.json and CLAUDE.md per arch-04. ==="
echo "=== Remember: Re-evaluate this setup monthly against Anthropic changelog. ==="
```

---

*Architecture 04 — Compiled April 12, 2026. Independent architect perspective.*
*This document will be partially obsolete within 30 days. That is by design.*
