# Architecture 01 — The Complete Claude Code System (April 2026)

> Architect: Agent 01. Solo research pass. Constraint: Claude Max $200/mo — everything else free or self-hosted.

---

## 1. The Tool Table

Every pick is justified. Free/self-hosted unless noted. Ordered by architectural priority — install top-down, stop when you're productive.

| # | Category | Tool | What it does | Why THIS one |
|---|----------|------|--------------|--------------|
| 1 | **CLI Kernel** | Claude Code v2.1.101 | Agentic coding CLI — the runtime everything attaches to | It IS the system. Opus 4.6 on Max $200/mo. Native sandbox, hooks, skills, worktrees, Monitor tool, Agent Teams, 1M context. |
| 2 | **Orchestration Plugin** | oh-my-claudecode v4.11 | 19 agents + 36 skills + team modes (Ralph, Autopilot, Ultrawork) | Most mature plugin-based orchestration. Built-in LSP, AST-grep, Python REPL MCP. 30-50% token savings via routing. Free. |
| 3 | **Discipline Framework** | Superpowers (obra/superpowers) | Structured lifecycle: brainstorm → plan → TDD → implement → review | Teaches Claude HOW to work, not just WHAT to build. Composable with OMC — different layers. Free. |
| 4 | **Skill Library** | wshobson/agents | 182 agents + 149 skills + 96 commands + PluginEval quality framework | Largest CC agent library (33k⭐). PluginEval is the only skill-measurement system that exists. Free, MIT. |
| 5 | **Code Intelligence MCP** | Serena v1.1.0 | LSP-based symbolic code editing across 30+ languages | Only MCP that does semantic rename/refactor, not just search. Install: `uv tool install -p 3.13 serena-agent@latest --prerelease=allow`. Free. |
| 6 | **Library Docs MCP** | Context7 | Live, version-accurate library documentation lookup | #1 on FastMCP by views. Append "use context7" to prompts with unfamiliar libs. Free (rate-limited without API key). |
| 7 | **Browser Automation MCP** | Playwright MCP | Accessibility-tree browser automation (10-100× faster than screenshots) | Official Anthropic plugin. A11y-tree snapshots = 2-5KB vs 500KB screenshots. Essential for UI verification. Free. |
| 8 | **GitHub MCP** | github/github-mcp-server | PR/issue/repo operations (51+ tools, rewritten in Go) | Official GitHub. Remote HTTP — no local process. Most-starred MCP server (28k⭐). Free. |
| 9 | **Chrome Automation** | Claude in Chrome MCP | Direct Chrome browser control, GIF recording, console/network reads | For testing live pages, not just headless. Pairs with Playwright for full coverage. Free. |
| 10 | **Memory MCP** | mcp-memory-service | Persistent knowledge graph with autonomous consolidation | 1.6k⭐, SQLite-vec default (no external deps), REST API, 5ms retrieval, hooks integration. Truly self-hosted. Free. |
| 11 | **Sandbox** | Native Linux sandbox (v2.1.98) | PID namespace + seccomp + bubblewrap filesystem/network isolation | Production-stable since April 2026. No Docker needed. Zero config — built into Claude Code. Free. |
| 12 | **Container Sandbox** | Dagger container-use v0.4.2 | Per-agent git branch + container with live audit log | For when you need full isolation beyond native sandbox. `cu watch` streams audit. Free. |
| 13 | **Web Search MCP** | Exa MCP | Semantic/exploratory web search | Most-used search MCP in 2026. Best for research-phase work. Free tier available. |
| 14 | **Database MCP** | Supabase MCP v0.7.0 | Full Supabase access — DB, auth, storage, edge functions | Official plugin with OAuth 2.1. Covers Postgres + auth + storage in one server. Free tier. |
| 15 | **Error Monitoring** | Sentry MCP (remote HTTP) | Production error investigation via OAuth | Remote at `https://mcp.sentry.dev/mcp` — no local install. Free tier (50k events/mo). |
| 16 | **Observability** | Datadog MCP (remote) | Logs, metrics, traces, incidents (16+ tools) | Replaced archived PostHog MCP. Official Datadog, GA March 2026. Free 14-day trial, then self-host alternative: Langfuse v3. |
| 17 | **Observability (self-host)** | Langfuse v3 | Session tracing, prompt management, eval dashboards | Self-hosted with MinIO required. v4 cloud preview exists but self-host path TBD. Free, MIT. |
| 18 | **Cost Tracking** | Native `/cost` (v2.1.92) | Per-model + cache-hit cost breakdown | First-class since April 2026. Supplement with `ccusage` CLI for historical analysis. Free. |
| 19 | **CI/CD** | claude-code-action v1.0.93 | GitHub Actions — PR review, code implementation, triage | Official Anthropic. @v1 is current. Requires API key (not Max subscription — Anthropic enforced this April 4). |
| 20 | **Security Review** | claude-code-security-review | AI-powered GitHub Action for security scanning | Official Anthropic. Pairs with Aikido plugin for SAST + secrets + IaC scanning. Free. |
| 21 | **Security Skills** | Trail of Bits skills | 12+ professional security-focused audit skills | From actual security researchers, not AI-generated. Industry gold standard. Free, MIT. |
| 22 | **MCP Security** | agentgateway (Linux Foundation) | Proxy for MCP + A2A with guardrails | 2.4k⭐, Rust, first proxy built on BOTH MCP and A2A protocols. Fills the "govern MCP layer" gap. Free. |
| 23 | **Code Review** | CodeRabbit (free tier) | Cross-vendor AI reviewer — different model reviews Claude's output | 2M+ repos, 82% bug-catch rate. Writer ≠ reviewer at the MODEL level, not just prompt level. Free tier for OSS. |
| 24 | **Tool Version Manager** | mise (jdx/mise) | Replaces asdf + nvm + pyenv + direnv + make | 26.6k⭐, single binary. `.mise.toml` gives Claude's Bash reproducible tool versions. Free. |
| 25 | **Task Runner** | just (casey/just) | Simple command runner — justfile is Claude-readable | 32.8k⭐. Simplest hook target. Claude reads justfile for self-documentation. Free. |
| 26 | **Git Workflow** | Native worktrees (--worktree/-w) | Isolated branches for parallel agent work | Built into Claude Code. `isolation: "worktree"` auto-cleans if no changes. Free. |
| 27 | **Session Manager** | Claude Squad | TUI for multiple AI terminal agents in isolated worktrees | 8k⭐. Best for pure terminal-ops parallel workflow. Complements Agent Teams. Free. |
| 28 | **Desktop DevTools** | claude-devtools | Per-turn token attribution, context-window viz, subagent trees | Zero outbound network. `brew install --cask claude-devtools`. Free. |
| 29 | **Status Line** | claudia-statusline | Rust-based with persistent stats and progress bars | Rust = fast, no runtime deps. Tracks cost across sessions. Free. |
| 30 | **Notification Channel** | ntfy.sh | Self-hostable push notifications with interactive Allow/Deny | 29.7k⭐. Pairs with `defer` permission (v2.1.89) for headless approval from phone. Free. |
| 31 | **Documentation MCP** | DeepWiki MCP | Free remote Q&A on any GitHub repo | `https://mcp.deepwiki.com/mcp` — no auth, no install. Ask questions about any repo. Free. |
| 32 | **Design-to-Code** | Figma MCP | Read designs, manipulate canvas (official Anthropic partner) | Only design tool with official Anthropic partnership. Essential for UI work. Free with Figma account. |
| 33 | **Diagrams** | Mermaid MCP | Preview/generate Mermaid diagrams with live reload | Built into GitHub rendering. Claude already knows Mermaid syntax. Free. |
| 34 | **Config Linter** | agnix | Comprehensive linter for CC agent files | Catches dead rules, broken globs, schema violations. IDE plugins available. Free. |
| 35 | **Walk-Away Agent** | OpenHands | Autonomous coding agent — give it a ticket, come back later | 71k⭐, MIT, within 2-6% of frontier. For tasks you don't need to supervise. Free, self-hosted. |

---

## 2. Complete `settings.json`

```json
{
  "$schema": "https://json-schema.org/claude-code-settings.json",

  "model": "claude-opus-4-6",
  "effortLevel": "high",

  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(pnpm *)",
      "Bash(bun *)",
      "Bash(just *)",
      "Bash(mise *)",
      "Bash(git *)",
      "Bash(gh *)",
      "Bash(uv *)",
      "Bash(cargo *)",
      "Bash(make *)",
      "Bash(docker compose *)",
      "Bash(cu *)",
      "Bash(jq *)",
      "Bash(rg *)",
      "Bash(fd *)",
      "Bash(delta *)",
      "Bash(cat *)",
      "Bash(ls *)",
      "Bash(wc *)",
      "Bash(head *)",
      "Bash(tail *)",
      "Bash(sort *)",
      "Bash(grep *)",
      "Bash(find *)",
      "Bash(echo *)",
      "Bash(which *)",
      "Bash(type *)",
      "Bash(pwd)",
      "Bash(date)",
      "Read(~/.zshrc)",
      "Read(~/.gitconfig)"
    ],
    "deny": [
      "Bash(curl * | bash *)",
      "Bash(wget * | bash *)",
      "Bash(rm -rf /)",
      "Bash(rm -rf ~)",
      "Bash(: > *)",
      "Bash(chmod 777 *)",
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(//*.pem)",
      "Read(//*.key)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/credentials)",
      "Read(~/.claude/credentials*)"
    ]
  },

  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_TRACES_EXPORTER": "otlp",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "CLAUDE_CODE_NO_FLICKER": "1"
  },

  "autoUpdatesChannel": "stable",
  "cleanupPeriodDays": 14,
  "includeGitInstructions": true,
  "respectGitignore": true,
  "showThinkingSummaries": true,
  "outputStyle": "concise",

  "attribution": {
    "commit": true,
    "pr": true
  },

  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker *", "podman *"],
    "filesystem": {
      "denyRead": ["~/.aws/credentials", "~/.ssh/*"]
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org", "registry.yarnpkg.com", "pypi.org"],
      "allowLocalBinding": true
    }
  },

  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "input=$(cat); cmd=$(echo \"$input\" | jq -r '.tool_input.command // empty'); if echo \"$cmd\" | grep -qE '(rm\\s+-rf\\s+[/~]|:(\\s*)>|chmod\\s+777|curl.*\\|.*sh)'; then echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"Blocked dangerous command pattern\"}}'; exit 2; fi"
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
            "command": "input=$(cat); file=$(echo \"$input\" | jq -r '.tool_input.file_path // .tool_input.edits[0].file_path // empty'); if [ -n \"$file\" ] && echo \"$file\" | grep -qE '\\.(ts|tsx|js|jsx)$'; then npx --yes biome check --write \"$file\" 2>/dev/null || true; fi"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"hookSpecificOutput\":{\"hookEventName\":\"Stop\",\"additionalContext\":\"Session stopped. Review changes with git diff before committing.\"}}'"
          }
        ]
      }
    ]
  },

  "statusLine": {
    "type": "command",
    "command": "claudia-statusline 2>/dev/null || echo ''"
  }
}
```

---

## 3. Complete `CLAUDE.md` (96 lines)

```markdown
# CLAUDE.md

## Identity
You are a senior engineer. Think before you code. Plan before you implement. Verify before you claim done.

## Architecture-First Rule
The first artifact of any non-trivial task is a plan — NOT code. Write explicit decisions,
non-goals, and alternatives considered. If the first thing you produce is code, start over.

## Code Standards
- TypeScript strict, ESM-only, no `any`. Prefer Zod for runtime validation at boundaries.
- Use existing patterns in the codebase. Don't invent new abstractions for one-time operations.
- Tests: colocate with source. Prefer integration tests over mocks. Run tests before claiming done.
- No sycophantic summaries. No trailing "let me know if you need anything."
- No unnecessary error handling for impossible scenarios. Trust framework guarantees.
- Comments only where logic isn't self-evident. No JSDoc on private functions.

## Git
- Atomic commits. One logical change per commit. Imperative mood.
- Never force-push to main. Never skip hooks. Never amend published commits.
- Always `git diff` before committing. Include `Co-Authored-By: Claude <noreply@anthropic.com>`.

## Workflow
1. **Understand**: Read existing code first. `git log --oneline -20` for recent context.
2. **Plan**: For changes >50 lines, write plan in chat. Get approval before coding.
3. **Implement**: Small, verifiable steps. Run tests after each significant change.
4. **Verify**: Run the full test suite. Start dev server for UI changes. Check in browser.
5. **Report**: State what changed and what you verified. No padding.

## Tool Usage
- Use `just` for project commands — read the justfile first.
- Use `mise` for tool versions — check `.mise.toml` before installing anything.
- Prefer native tools: `git` over shell wrappers, `gh` for GitHub, `uv` for Python.
- MCP: Use Context7 for unfamiliar libraries. Use Serena for refactors across files.

## When Stuck
- Read the error message. Read it again. Check your assumptions.
- `git stash` before trying risky fixes. Diagnose before switching approaches.
- After 3 failed attempts at the same approach, stop and explain what you've tried.

## What NOT To Do
- Don't add features beyond what was asked. Bug fix ≠ refactor opportunity.
- Don't create helpers or abstractions for one-time operations.
- Don't add docstrings to code you didn't change.
- Don't "improve" surrounding code. The diff should contain only what was requested.
- Don't generate or guess URLs.
- Don't use `sleep` loops — use `run_in_background` + Monitor tool.
- Don't commit .env files, credentials, or large binaries.

## Security
- Never expose secrets in code, logs, or commit messages.
- Validate at system boundaries only (user input, external APIs).
- Use parameterized queries. No string concatenation for SQL/shell commands.
- Review OWASP Top 10 implications for any auth/input/output change.

## Performance
- Profile before optimizing. Measure after optimizing.
- Three similar lines are better than a premature abstraction.
- Database: check query plans. Add indexes based on actual query patterns.

## Dependencies
- Check `mise.toml` and lockfiles before adding new deps.
- Prefer well-maintained packages. Check last commit date, open issues, license.
- Pin versions. Run `npm audit` / equivalent after adding deps.

## Monorepo
- `just build` or `turbo run build --filter=...[HEAD]` — only rebuild what changed.
- Respect workspace boundaries. Don't import across package boundaries without discussion.

## Review Checklist (before claiming done)
- [ ] Tests pass
- [ ] No TypeScript errors
- [ ] No lint warnings introduced
- [ ] UI changes verified in browser
- [ ] git diff reviewed — only intended changes
- [ ] No secrets or credentials in diff
```

---

## 4. Complete `.mcp.json`

```json
{
  "mcpServers": {
    "serena": {
      "type": "stdio",
      "command": "serena",
      "args": ["start-mcp-server", "--context", "ide-assistant", "--project", "${PWD}"],
      "env": {}
    },
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {}
    },
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "env": {}
    },
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp",
      "headers": {
        "Authorization": "Bearer ${GITHUB_TOKEN}"
      }
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    },
    "deepwiki": {
      "type": "http",
      "url": "https://mcp.deepwiki.com/mcp"
    },
    "memory": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-memory-service"],
      "env": {}
    },
    "container-use": {
      "type": "stdio",
      "command": "cu",
      "args": ["stdio"],
      "env": {}
    },
    "exa": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/exa-mcp-server"],
      "env": {
        "EXA_API_KEY": "${EXA_API_KEY}"
      }
    },
    "mermaid": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "claude-mermaid"],
      "env": {}
    }
  }
}
```

**Why only 10 MCP servers:** Tool Search (Jan 2026) lazy-loads tool schemas on demand — 95% token reduction. But each server is still a process. 10 servers covers: code intelligence (Serena), docs (Context7 + DeepWiki), browser (Playwright), GitHub, errors (Sentry), search (Exa), memory, sandbox (container-use), and diagrams (Mermaid). Add more per-project in `.mcp.json` overrides — don't bloat the global config.

**What's NOT here and why:**
- **Figma MCP** — add per-project when doing design work, not globally
- **Supabase/Stripe/Shopify** — project-specific, not global
- **Database MCPs** — use project `.mcp.json` with the right connection string
- **Datadog/Langfuse** — observability is org-specific, configure per-team
- **LiteLLM** — compromised in March 2026 (v1.82.7-8). If you need a gateway, pin to v1.83.x+ and pull from GitHub, not PyPI

---

## 5. Top 10 Principles

### 1. Verification is the bottleneck, not generation
Claude generates code faster than you can verify it. **The scarce resource is human attention for review, not AI tokens for generation.** Structure everything around making verification easy: small diffs, test coverage, browser checks. Never let Claude self-approve — the writer and reviewer must be separate passes (ideally separate models via CodeRabbit or OMC's code-reviewer agent).

**Trap:** Structured-output constraints during self-reflection produce "formatting traps" — syntactic alignment but missed semantic errors (arxiv 2604.06066). Use prose-level judgment, not just schema validation.

### 2. Architecture first, code second — always
AI acceleration of implementation causes design-decision deferral. You never have to slow down for the hard call, so you never make it, and the architecture rots. The first artifact of every non-trivial task is `plan.md` with explicit decisions, non-goals, alternatives considered. If the first artifact is code, the task is already broken. (Willison "Eight Years / Three Months", April 5; Maganti case study.)

### 3. Skills have diminishing returns — refinement is the lever
Skill-library gains collapse to near-zero in realistic retrieval (arxiv 2604.04323, Skill-Usage-Bench, 34k real-world skills). Claude Opus 4.6 goes 57.7% → 65.5% on Terminal-Bench 2.0 only with query-specific refinement, NOT library size. **Don't install 50 awesome-list skills.** Install 5, measure outcomes with PluginEval, delete what doesn't pay rent, refine what does.

### 4. Native primitives win when they're real
Before reaching for a third-party tool, check if Anthropic shipped it natively. In the last 30 days alone: Advisor Tool (server-side executor/advisor split), `ant` CLI (GitOps for agents), `defer` permission (headless approval at 0.4% FP), Monitor tool, native Linux sandbox, `/cost` per-model breakdown, Cedar policy syntax. Each one obsoleted a category of third-party tooling. Check the changelog monthly.

### 5. Parallel agents: start with one fewer than feels comfortable
The 3-5 agent band is right. Pick from the low end. Three new anti-patterns from Osmani (April 7): **Comprehension Debt** (can't hold N agent contexts), **Ambient Anxiety Tax** (monitoring parallelism costs attention), **Trust Calibration Overhead** (each agent needs separate trust assessment). Two focused agents beat four distracted ones.

### 6. Sandbox isolation is non-optional
The Mythos agent-escape incident (Project Glasswing, April 7) is a precedent-setting event. MCPSHIELD (arxiv 2604.05969) found single-layer MCP defenses cover only 34% of threats; integrated architecture reaches 91%. ShieldNet (arxiv 2604.04426) achieves F1=0.995 at 0.8% FP for network-level behavioral monitoring. **Layer your defenses:** native sandbox + container-use for untrusted code + deny rules + hooks for dangerous commands.

### 7. Supply chain is nobody's responsibility by construction
AI-generated codebases have no human reader who would notice a compromised transitive dependency (Breunig "Winchester Mystery House", March 26; Nesbitt "Cathedral and the Catacombs", April 6). LiteLLM PyPI v1.82.7-8 were compromised with credential-stealing malware in March 2026. The axios supply-chain attack (Sapphire Sleet, DPRK) hit Claude Code's own ecosystem. **Pin versions. Audit deps. Use the native binary installer, not npm.**

### 8. Cost discipline is architectural, not behavioral
effortLevel default changed from `medium` to `high` in v2.1.94 (April 7) for API/Bedrock/Vertex/Team/Enterprise users. Any cost model based on medium-default is stale. On Max $200/mo this doesn't matter (unlimited). But the Advisor Tool (85% cost reduction via Haiku+Opus split) means cost optimization is now a server-side primitive, not a prompt-engineering trick.

### 9. The writer never reviews their own work
OMC's code-reviewer agent, CodeRabbit, or a separate Claude session — the reviewing entity must not share context with the writing entity. This is the single highest-leverage quality practice. It catches bugs that no amount of self-reflection finds, because the reviewer doesn't share the writer's blind spots.

### 10. Measure before you optimize, delete before you add
Before adding a new MCP server: measure what's slow. Before adding a new skill: measure what's failing. Before adding a new agent: measure what's blocked. The ClawBench eval-validity gap (70% sandbox performance vs 6.5% realistic) proves benchmarks lie. Run tools on 10 real tasks from YOUR repo before adopting them.

---

## 6. What Most People Miss (Unique Insights)

### Insight 1: The Advisor Tool collapsed an entire architectural layer
Most people are still running "Opus for planning, Sonnet for execution" as a prompt-engineering discipline. The Advisor Tool (beta header `advisor-tool-2026-03-01`) does this server-side in a SINGLE `/v1/messages` call. Haiku+Opus scored 41.2% on SWE-bench Multilingual vs 19.7% Haiku solo at 85% lower cost per task. **This means most of v3's "discipline framework" discussion is now supplementary, not primary.** The orchestration layer just moved into the kernel.

### Insight 2: Tool Search changed the MCP economics completely
The January 2026 Tool Search feature (BM25 + regex over installed servers, 85-95% token reduction, 77K → 8.7K tokens for 50-tool setups) **eliminated** the old "keep under 5 MCP servers" advice. You can now run 10-15 servers without context bloat. But most setups from early 2025 are still running 2-3 servers because the advice calcified. The constraint isn't token cost anymore — it's process overhead and security surface.

### Insight 3: The `defer` permission + ntfy.sh = phone-approval headless sessions
v2.1.89 shipped `defer` as a `permissionDecision` for PreToolUse hooks. Combined with ntfy.sh's interactive Allow/Deny push notifications, you get: Claude Code running headlessly, pausing at tool-call boundaries, pinging your phone, and resuming on thumbs-up. At 0.4% false positive rate in production (per Anthropic's auto-mode post), this is safe to recommend. **Almost nobody has wired this up yet.** It's the missing piece for "start a task before bed, approve from phone in the morning."

### Insight 4: The skill economy is already commoditized — curation is the moat
There are 13,729+ skills on ClawHub, 9,397+ indexed by Chat2AnyLLM, and multiple awesome-lists with 1,000+ entries each. But arxiv 2604.04323 (Skill-Usage-Bench) proved that skill-library gains collapse in realistic retrieval. **The competitive advantage isn't having more skills — it's having fewer, better ones that you've measured.** wshobson/agents' PluginEval (Wilson/Clopper-Pearson CI, Elo ranking, Bronze→Platinum badges) is the only quality framework that exists. Use it.

### Insight 5: Cedar policy is becoming first-class for permissions-as-code
v2.1.100 (April 10) added Cedar policy syntax highlighting. Cedar is Amazon's open-source policy language. This quietly signals that Claude Code's permission system is moving toward declarative policy files, not just `permissions.allow/deny` arrays in settings.json. Watch this space — it's the path to "infrastructure as code for agent permissions."

### Insight 6: Your CLAUDE.md is too long
Drew Breunig reverse-engineered how Claude Code builds its system prompt (April 4). Every token in CLAUDE.md competes with tool schemas, MCP descriptions, skill frontmatter, and hook context for the same context window. The `claude-token-efficient` project (471 HN points — highest-scoring context-compression item in the 2-week window) exists because people stuff 500+ lines into CLAUDE.md. **96 lines is the target.** If you can't fit your standards in 96 lines, you have too many standards.

### Insight 7: The "research.md first" pattern is the highest-leverage habit
Boris Tane's workflow: before ANY implementation, write a `research.md` that documents what you found, what you considered, and what you decided. This isn't a plan — it's a decision record. It forces you to think before Claude thinks for you. Combined with Principle 2 (architecture first), this is the single change that most improves code quality in AI-assisted development.

### Insight 8: Agent Teams experimental is good enough for most orchestration
People install Paperclip (51k⭐), Claude Squad (8k⭐), and OMC for multi-agent work. But native Agent Teams (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) with `.claude/agents/*.md` role definitions + `SendMessage` + shared task list covers 60% of what those tools do — at zero install cost. The "experimental" tag scares people off, but it's been stable since v2.1.32 (January 2026). **Start native, add tools only when you hit a wall.**

### Insight 9: The Monitor tool + run_in_background = async build watching
v2.1.98 shipped the Monitor tool as a first-class primitive for streaming events from background processes. Combined with `run_in_background`, Claude can kick off a build, continue other work, and react to build completion/failure events. **This eliminates the `sleep` polling anti-pattern** that wastes context and tokens. Most people don't know this exists yet.

### Insight 10: MCP security is the biggest gap in everyone's setup
v3 had 24 slots for WHICH MCP servers to use and ZERO for governing the MCP layer itself. MCPSHIELD analyzed 177k+ MCP tools and found 23 attack vectors across 4 surfaces. ~40% of public MCP servers are susceptible to command injection. The agentgateway (Linux Foundation, Rust, 2.4k⭐) is the first proxy built on both MCP and A2A protocols. **If you're running 10+ MCP servers without a security layer, you have 10+ unaudited attack surfaces.**

---

## 7. Installation Playbook (order matters)

```bash
# 1. Claude Code (native binary — not npm, after axios supply-chain incident)
curl -fsSL https://claude.ai/install.sh | bash

# 2. mise (tool version manager — replaces nvm/pyenv/asdf)
curl https://mise.jdx.dev/install.sh | sh
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc

# 3. just (task runner)
mise use --global just

# 4. uv (Python package manager — for Serena, skills)
mise use --global uv

# 5. Serena (code intelligence MCP)
uv tool install -p 3.13 serena-agent@latest --prerelease=allow

# 6. oh-my-claudecode (orchestration plugin)
# In Claude Code: /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
# Then: /plugin install oh-my-claudecode
# Then: /oh-my-claudecode:omc-setup

# 7. wshobson/agents (skill library + PluginEval)
# In Claude Code: /plugin install wshobson/agents

# 8. Superpowers (discipline framework)
# In Claude Code: /plugin install obra/superpowers

# 9. Trail of Bits security skills
# Clone to ~/.claude/skills/: git clone https://github.com/trailofbits/skills ~/.claude/skills/trailofbits

# 10. ntfy.sh (notification channel for defer approvals)
# Self-host: docker run -p 2586:80 binwiederhier/ntfy
# Or use hosted: https://ntfy.sh (free)

# 11. container-use (sandbox)
# npm install -g @anthropic-ai/container-use
# Or: mise use --global npm:@anthropic-ai/container-use

# 12. claudia-statusline
cargo install claudia-statusline

# 13. claude-devtools
brew install --cask claude-devtools

# 14. agnix (config linter)
npm install -g agnix
```

---

## 8. Architecture Diagram (Mental Model)

```
┌─────────────────────────────────────────────────────────┐
│                    YOUR TERMINAL                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │          Claude Code v2.1.101 (Kernel)            │  │
│  │  ┌─────────┐ ┌──────────┐ ┌───────────────────┐  │  │
│  │  │ Sandbox │ │  Hooks   │ │  Agent Teams (exp) │  │  │
│  │  │ seccomp │ │ 26 events│ │  SendMessage/Tasks │  │  │
│  │  │ PID ns  │ │ command/ │ │  .claude/agents/*  │  │  │
│  │  │ bwrap   │ │ prompt/  │ │                    │  │  │
│  │  │         │ │ agent/   │ │  ┌──────────────┐  │  │  │
│  │  │         │ │ http     │ │  │ oh-my-claude │  │  │  │
│  │  │         │ │          │ │  │ Superpowers  │  │  │  │
│  │  │         │ │          │ │  │ wshobson/agt │  │  │  │
│  │  └─────────┘ └──────────┘ │  │ ToB security │  │  │  │
│  │                           │  └──────────────┘  │  │  │
│  │  ┌─────────────────────────────────────────┐   │  │  │
│  │  │            MCP Layer (10 servers)        │   │  │  │
│  │  │ Serena│Context7│Playwright│GitHub│Sentry │   │  │  │
│  │  │ Memory│container-use│Exa│DeepWiki│Mermaid│   │  │  │
│  │  └────────────────────┬────────────────────┘   │  │  │
│  │                       │ Tool Search (lazy load) │  │  │
│  └───────────────────────┼───────────────────────────┘  │
│                          │                               │
│  ┌───────────────────────┼───────────────────────────┐  │
│  │     Workstation       │                            │  │
│  │  mise │ just │ git │ gh │ uv │ cargo │ docker    │  │
│  │  agnix │ claudia-statusline │ claude-devtools     │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
           │                              │
           ▼                              ▼
    ┌──────────────┐              ┌──────────────┐
    │ GitHub       │              │ ntfy.sh      │
    │ claude-code- │              │ defer →      │
    │ action CI    │              │ phone approve│
    │ security-rev │              │              │
    │ CodeRabbit   │              │ Langfuse v3  │
    └──────────────┘              └──────────────┘
```

---

## 9. Key Decisions and Trade-offs

| Decision | What I chose | What I rejected | Why |
|----------|-------------|-----------------|-----|
| Orchestration | OMC plugin | Paperclip, Ruflo, Claude Squad as primary | OMC is a plugin inside CC, not a wrapper around it. Composable, not competing. |
| Memory | mcp-memory-service | claude-mem (12.9k⭐), mempalace (23k⭐) | SQLite-vec = zero external deps. mempalace has inflated LongMemEval scores (community forced README correction). |
| Code review | CodeRabbit (free tier) + OMC code-reviewer | GitHub Copilot Code Review | Different model reviewing Claude = true writer≠reviewer. Copilot uses same Microsoft model family. |
| Gateway | None (direct Anthropic) | LiteLLM, OpenRouter | On Max $200/mo, you don't need a gateway. LiteLLM had a supply-chain compromise in March 2026. |
| Sandbox | Native + container-use | E2B, Modal, Fly Sprites | Native sandbox is free and production-stable since April 2026. container-use for the extra isolation cases. |
| Build tools | mise + just | Turborepo, Nx, make | mise replaces 5 tools in one binary. just is Claude-readable. Turbo/Nx for monorepos only — add per-project. |
| Walk-away agent | OpenHands | Devin ($20/mo), Jules | OpenHands is MIT, self-hosted, within 2-6% of frontier. Devin has default training opt-in on your code. |
| Notifications | ntfy.sh | Telegram, Slack webhooks | Self-hostable, interactive Allow/Deny buttons, purpose-built for the `defer` pattern. |
| Skills framework | Superpowers + measure with PluginEval | 10+ awesome-list collections | Skill-Usage-Bench proved accumulation doesn't work. Few + measured > many + hoped. |
| Status line | claudia-statusline | CCometixLine, claude-powerline | Rust = no runtime deps, persistent stats. Cost tracking across sessions. |

---

*End of Architecture 01.*
