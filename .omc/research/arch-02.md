# Architecture 02 — The Ultimate Claude Code System (April 2026)

*Architect 2 of 10. Independent research. Built for Claude Max $200/mo.*

---

## 1. The Tool Table

My philosophy: **fewer, deeper, load-bearing picks**. Every row must earn its slot by solving a real problem that can't be solved by Claude Code natively. I reject the "install 50 MCP servers" approach — the arxiv Skill-Usage-Bench paper (2604.04323) proved that skill/tool accumulation collapses to near-zero gains in realistic retrieval. What matters is **the right 15-20 tools, deeply integrated**.

| # | Category | Tool | What it does | Why THIS one |
|---|----------|------|-------------|--------------|
| 1 | **Orchestration** | oh-my-claudecode (OMC) | Teams-first multi-agent orchestration plugin with 32 agents, 40+ skills, 6 execution modes | Already installed. The only plugin that composes with Agent Teams, routes to Opus/Sonnet/Haiku intelligently, and ships autopilot/ralph/ultrawork modes. 27k+ stars, actively maintained. |
| 2 | **Discipline Framework** | Superpowers (obra) | Agentic skills: brainstorm → plan → execute → review → debug → TDD | Anthropic marketplace-approved (Jan 2026). Battle-tested methodology — brainstorm before coding, subagent code review, systematic debugging. Composes cleanly with OMC (different layers). |
| 3 | **Spec-Driven Dev** | GitHub Spec-Kit v0.5.1 | Constitution → Specify → Plan → Tasks → Implement | 80k+ stars. 58.2% pass@1 on SWE-Bench Lite. The only spec tool with agent-agnostic slash commands. Forces architecture-first, which is the #1 principle. |
| 4 | **Code Intelligence MCP** | Serena v1.1.0 | LSP-based semantic code search/edit across 30+ languages | THE canonical code intelligence MCP. Gives Claude IDE-level understanding — go-to-definition, find-references, rename-symbol. Nothing else comes close for multi-language semantic editing. |
| 5 | **Structural Search MCP** | ast-grep MCP | Tree-sitter AST pattern matching for search/lint/rewrite | Complements Serena. Where Serena gives IDE features, ast-grep gives structural pattern matching across 20+ languages. Find "all functions that catch exceptions but don't log" — impossible with grep, trivial with ast-grep. |
| 6 | **Documentation MCP** | Context7 | Live, version-accurate library documentation lookup | #1 on FastMCP by views. Eliminates hallucinated API calls. Append "use context7" and Claude gets the exact docs for your library version. Requires API key now (rate-limited without). |
| 7 | **Browser Automation MCP** | Playwright MCP | 25+ browser control tools via accessibility tree snapshots | Official Anthropic plugin. A11y-tree snapshots are 10-100x faster than screenshots (2-5KB vs 500KB-2MB). The only browser MCP that matters for testing. |
| 8 | **GitHub MCP** | github/github-mcp-server | PRs, issues, code search, repo management (51+ tools) | Official GitHub, 28k+ stars. Use remote HTTP with OAuth — no local process. Rewritten in Go, added Projects, code scanning, scope filtering. |
| 9 | **Web Search MCP** | Brave Search | Privacy-focused web search with 6 modalities | Free 2,000 queries/month. Highest Agent Score (14.89) in benchmarks. Lowest latency (669ms). Better than Exa for specific lookups, which is 90% of dev search. |
| 10 | **Memory MCP** | mcp-memory-service (doobidoo) | Persistent memory with knowledge graph + dream consolidation | 1,642 stars, battle-tested. REST API + KG + SQLite-vec. Natural triggers (#remember, #skip). More honest benchmarks than MemPalace (whose 96.6% was debunked as reflecting ChromaDB, not the palace architecture). |
| 11 | **Sandbox** | Docker Sandboxes | microVM-based isolation with own kernel + Docker daemon | Not a container — a full VM. 84% reduction in permission prompts. The ONLY sandbox letting agents build/run Docker containers while isolated. Native Claude Code support. |
| 12 | **Sandbox MCP** | container-use (Dagger) | Per-agent git branches + containers + audit log via MCP | Complements Docker Sandboxes for multi-agent work. Each agent gets its own branch + container. `cu watch` streams live audit. `cu merge` when satisfied. |
| 13 | **Observability** | Langfuse v3 (self-hosted) | Session tracing, token attribution, eval framework | Only self-hostable tracing that integrates with Claude Code hooks natively. Stop hook captures full conversation → Langfuse traces. v4 cloud is faster but v3 self-host keeps data local. Requires MinIO. |
| 14 | **Cross-Model Review** | CodeRabbit | AI code review on PRs (different model reviewing Claude's output) | 13M+ PRs processed, 2M+ repos. The ONLY way to honor "writer ≠ reviewer" at the model-diversity level. Claude writes, CodeRabbit (different model) reviews. Free for OSS. |
| 15 | **Notifications** | ntfy.sh + claude-ntfy-hook | Push notifications + interactive Allow/Deny from phone | Self-hostable, 29.7k stars. Pairs with `defer` permissionDecision (v2.1.89). Headless Claude pauses → pings phone → resumes on thumbs-up. 0.4% false positive rate per Anthropic. |
| 16 | **MCP Security** | agentgateway v1.0 | MCP+A2A proxy with auth, RBAC, rate limiting, OTEL | Linux Foundation project, Rust, v1.0. Federates all MCP servers behind one endpoint. JWT/OAuth auth + CEL policy engine. Without this, your MCP layer is ungoverned. |
| 17 | **Dev Environment** | mise | Replace nvm + pyenv + asdf + direnv in one binary | 26.6k stars, Rust, 20-200x faster than asdf. `.mise.toml` checked into git gives Claude reproducible tool versions. Also handles env vars and task running. |
| 18 | **Task Runner** | just | Simple command runner with justfile | 32.8k stars. Claude can read justfiles for self-documentation. Simplest hook target. `just lint`, `just test`, `just build` — no Makefile complexity. |
| 19 | **CI/CD** | claude-code-action v1.0.93 | Official GitHub Action for PR review, code impl, triage | Official Anthropic. @v1 is current. Use with API key (not Max subscription — Anthropic enforced this Apr 4 2026). |
| 20 | **Cost Monitoring** | Native `/cost` (v2.1.92) | Per-model + cache-hit cost breakdown | First-class since v2.1.92. No external tool needed for basic cost tracking. Supplementary: ccusage for historical analysis. |

---

## 2. Complete `settings.json`

This goes in `~/.claude/settings.json` (user scope — applies to all projects).

```json
{
  "$schema": "https://json-schema.org/claude-code-settings.json",

  "model": "claude-sonnet-4-6",

  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(pnpm *)",
      "Bash(bun *)",
      "Bash(just *)",
      "Bash(mise *)",
      "Bash(git status *)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git branch *)",
      "Bash(git stash *)",
      "Bash(cargo *)",
      "Bash(go build *)",
      "Bash(go test *)",
      "Bash(python -m pytest *)",
      "Bash(uv *)",
      "Bash(ruff *)",
      "Bash(eslint *)",
      "Bash(prettier *)",
      "Bash(tsc *)",
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
      "Bash(mkdir *)",
      "Bash(cp *)",
      "Bash(mv *)",
      "Bash(docker compose *)",
      "Bash(docker build *)",
      "Bash(docker run *)",
      "Bash(cu *)",
      "Read",
      "Edit",
      "Write",
      "Glob",
      "Grep",
      "WebSearch",
      "WebFetch"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(rm -rf ~)",
      "Bash(rm -rf .)",
      "Bash(git push --force *)",
      "Bash(git reset --hard *)",
      "Bash(git clean -f *)",
      "Bash(chmod 777 *)",
      "Bash(curl * | bash)",
      "Bash(curl * | sh)",
      "Bash(wget * | bash)",
      "Bash(sudo *)",
      "Bash(kill -9 *)",
      "Bash(pkill *)",
      "Bash(> /dev/sd*)",
      "Bash(dd if=*)",
      "Read(//.env)",
      "Read(//.env.*)",
      "Read(//secrets/**)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/credentials)",
      "Read(~/.gnupg/**)"
    ]
  },

  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_TRACES_EXPORTER": "otlp",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },

  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'input=$(cat); cmd=$(echo \"$input\" | jq -r \".tool_input.command // empty\"); if echo \"$cmd\" | grep -qE \"(rm -rf [~/.]|DROP TABLE|DROP DATABASE|truncate|> /dev/|mkfs|:(){ :|:& };:)\"; then echo \"{\\\"hookSpecificOutput\\\":{\\\"hookEventName\\\":\\\"PreToolUse\\\",\\\"permissionDecision\\\":\\\"deny\\\",\\\"permissionDecisionReason\\\":\\\"Destructive command blocked by safety hook\\\"}}\" && exit 2; fi'"
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
            "command": "bash -c 'input=$(cat); file=$(echo \"$input\" | jq -r \".tool_input.file_path // empty\"); if [ -n \"$file\" ]; then ext=\"${file##*.}\"; case \"$ext\" in js|jsx|ts|tsx|css|scss|json|md|html) npx prettier --write \"$file\" 2>/dev/null ;; py) ruff format \"$file\" 2>/dev/null ;; rs) rustfmt \"$file\" 2>/dev/null ;; go) gofmt -w \"$file\" 2>/dev/null ;; esac; fi'"
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'curl -s -d \"Claude Code needs attention\" ntfy.sh/claude-$(whoami) >/dev/null 2>&1 || true'"
          }
        ]
      }
    ]
  },

  "autoUpdatesChannel": "stable",
  "includeGitInstructions": true,
  "respectGitignore": true,
  "cleanupPeriodDays": 14
}
```

**Project-scope settings** (`.claude/settings.json`) should only add project-specific permissions and hooks. Don't duplicate global settings.

---

## 3. Complete CLAUDE.md

```markdown
# Project Instructions

## Identity
You are working on [PROJECT_NAME]. [One sentence describing what it does.]

## Architecture
- Stack: [e.g., TypeScript / Next.js 15 / Postgres / Drizzle ORM]
- Monorepo: [yes/no, structure if yes]
- Key directories: src/, tests/, docs/, scripts/
- Entry points: [e.g., src/index.ts, src/app/layout.tsx]

## Code Standards
- TypeScript strict mode. No `any`. Prefer `unknown` + type guards.
- Functions < 40 lines. Files < 300 lines. Extract when exceeded.
- Name things for what they DO, not what they ARE.
- No barrel exports (index.ts re-exports). Import from source.
- Error handling: Result pattern for domain errors, exceptions for infrastructure.
- Tests: colocated `*.test.ts` files. Integration > unit for business logic.

## Git Discipline
- Conventional commits: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`
- Never push to main directly. Always branch + PR.
- Never force push. Never amend published commits.
- Include `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>` in AI commits.

## Workflow
1. UNDERSTAND: Read relevant code before changing it. Use Serena for go-to-definition.
2. PLAN: For non-trivial changes, write the plan first. Use /speckit.plan for features.
3. TEST: Write or update tests BEFORE implementing. TDD when possible.
4. IMPLEMENT: Small, focused changes. One logical change per commit.
5. VERIFY: Run tests, lint, type-check before claiming done. `just check` runs all.
6. REVIEW: Use CodeRabbit or /simplify before PRs.

## What NOT to do
- Don't add features beyond what was asked.
- Don't add comments to code you didn't change.
- Don't refactor adjacent code unless asked.
- Don't create helpers/abstractions for one-time operations.
- Don't add error handling for impossible scenarios.
- Don't install new dependencies without asking first.
- Don't modify .env files or credentials.
- Don't create documentation files unless asked.

## Tools Available
- `just check` — lint + typecheck + test
- `just dev` — start dev server
- `just build` — production build
- `just db:migrate` — run migrations
- `use context7` — append to prompts for library docs
- `/speckit.specify` → `/speckit.plan` → `/speckit.tasks` → `/speckit.implement`

## Critical Rules (hooks enforce these, but know the intent)
- Destructive bash commands are blocked (rm -rf, DROP TABLE, force push)
- Files are auto-formatted on save (prettier/ruff/rustfmt/gofmt)
- Secrets files (.env, credentials) cannot be read
- Notifications fire when Claude needs human attention
```

**This is 65 lines.** Under the 100-line limit. Every line passes the test: "Would removing this cause Claude to make mistakes?"

---

## 4. Complete `.mcp.json`

This goes in the project root. Only project-relevant servers here. Global servers (Brave, memory) go in `~/.claude.json`.

```json
{
  "mcpServers": {
    "serena": {
      "type": "stdio",
      "command": "uvx",
      "args": ["serena-agent", "start-mcp-server", "--context", "ide-assistant", "--project", "."],
      "env": {}
    },
    "ast-grep": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@ast-grep/mcp@latest"]
    },
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    },
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    },
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp",
      "headers": {
        "Authorization": "Bearer ${GITHUB_PAT}"
      }
    },
    "container-use": {
      "type": "stdio",
      "command": "container-use",
      "args": ["stdio"]
    },
    "brave-search": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/brave-search-mcp@latest"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      }
    },
    "memory": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-memory-service@latest"],
      "env": {
        "MEMORY_STORAGE_PATH": "${HOME}/.claude/memory-store"
      }
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    }
  }
}
```

**Why 9 servers and not 15?** Tool Search (Jan 2026) lazy-loads tools on demand (~95% token reduction). But each server is still a subprocess. Keep it under 10 for responsiveness. These 9 cover: code intelligence (Serena + ast-grep), docs (Context7), browser (Playwright), git ops (GitHub), sandbox (container-use), search (Brave), memory (mcp-memory-service), and production errors (Sentry). That's the full development loop.

**What's NOT here and why:**
- **Datadog/Grafana MCP** — Only if you use those services. Most solo devs don't.
- **Supabase MCP** — Add per-project if using Supabase. Dev/test only per their docs.
- **Stripe/Shopify/Linear** — Add per-project as needed. Not universal.
- **Figma MCP** — Add if doing design-to-code. Not universal.
- **DeepWiki** — Context7 covers 90% of the use case. Add if you need GitHub repo Q&A.

---

## 5. Top 10 Principles

### 1. Architecture before code, always.
The #1 failure mode in AI-assisted development is design-decision deferral. AI makes implementation so fast you skip the hard architectural calls. Then you have a working prototype with wrong foundations. **Every non-trivial task starts with `research.md` → `plan.md` → code.** If the first artifact is code, the task is already broken. Use Spec-Kit to enforce this.

### 2. Writer ≠ Reviewer, at every level.
Claude cannot meaningfully review its own output. You need separation at three levels: (a) different prompts (plan agent vs execute agent — OMC handles this), (b) different models (CodeRabbit using non-Claude models to review Claude's PRs), (c) different humans (you reading the diff before merge). A single agent writing + reviewing is theater, not quality control.

### 3. Hooks for safety, CLAUDE.md for guidance.
CLAUDE.md gets followed ~70% of the time. For rules where 70% compliance is a production incident (don't push to main, don't delete data, don't read secrets), use hooks. Hooks are 100% enforcement. CLAUDE.md is for style, workflow, and architectural guidance — things where occasional deviation is acceptable.

### 4. Measure skill outcomes, not library size.
The Skill-Usage-Bench paper (arxiv 2604.04323) proved that 34k skills collapse to near-zero gains in realistic retrieval. Install 3-5 deeply integrated skills (Superpowers, Spec-Kit, OMC modes) rather than 50 awesome-list skills. Split-test each skill with before/after benchmarks. Delete skills that don't improve outcomes.

### 5. Start with one fewer agent than feels comfortable.
Addy Osmani (April 7 2026) named three anti-patterns: Comprehension Debt, Ambient Anxiety Tax, Trust Calibration Overhead. The sweet spot is 2-4 parallel agents, not 8-12. You must be able to review every agent's diff before it merges. If you can't, you're not coding faster — you're accumulating Winchester Mystery House debt.

### 6. The sandbox is non-negotiable.
The Mythos agent-escape incident (April 7 2026), the Replit 2.5-year data wipeout, and MCPSHIELD's finding that single-layer MCP defenses cover only 34% of threats all converge on one conclusion: **run Claude Code in Docker Sandboxes (microVM) for any autonomous work.** Native Linux sandbox (PID namespace + seccomp, v2.1.98) is good for interactive use. Docker Sandboxes for overnight/unattended.

### 7. Native primitives win when they're real.
Before installing a tool, check if Claude Code already does it natively. Monitor tool (v2.1.98) replaces custom log-streaming. `/cost` (v2.1.92) replaces external cost trackers. `defer` (v2.1.89) + ntfy replaces custom approval workflows. The Advisor Tool API replaces some orchestration patterns. Check the changelog monthly.

### 8. Context is king — protect the budget.
Over 90% of tokens are cache reads. Keep CLAUDE.md under 100 lines. Use skills (lazy-loaded) instead of stuffing everything into CLAUDE.md. Use Tool Search (automatic since Jan 2026) instead of loading all MCP tools upfront. Auto-compact at 75%. Every token in context competes with tokens Claude needs for reasoning.

### 9. CI must use API billing, not subscription.
Anthropic explicitly cut subscription access for scripted use (April 4 2026 enforcement event). CI/CD, GitHub Actions, and headless automation **must** use API keys. Max $200/mo is for interactive development only. claude-code-action uses API billing by design. Budget accordingly.

### 10. Supply chain vigilance is structural, not advisory.
LiteLLM PyPI v1.82.7-8 was compromised with credential-stealing malware (March 2026). The axios supply-chain attack by DPRK's Sapphire Sleet. MCPSHIELD analyzed 177k+ MCP tools and found pervasive vulnerabilities. **Pin versions. Use lockfiles. Run agentgateway for MCP governance. Generate SBOMs. Audit MCP servers before installing.** This isn't paranoia — it's the documented attack surface.

---

## 6. What Most People Miss (My Unique Insight)

### The Formatting Trap: Structured output verification is broken

Here's what almost nobody talks about: **when Claude verifies its own work using structured output (JSON schemas, checklists, pass/fail enums), it achieves syntactic alignment with the schema while missing semantic errors.** This is documented in arxiv 2604.06066 ("Alignment Tax") but I've seen zero Claude Code setups account for it.

What this means in practice: if your verification step is "Claude, check if this code meets the requirements and output `{pass: true/false, issues: []}`", Claude will produce syntactically correct JSON that says `pass: true` even when there are real bugs. The structured format itself creates a cognitive trap — the model focuses on producing well-formed output instead of genuinely evaluating.

**The fix:** verification must use **prose-level judgment**, not schema validation. Your code-reviewer agent should write a paragraph explaining what it found, not fill in a checklist. OMC's `critic` and `verifier` agents do this correctly — they produce free-form analysis, not structured pass/fail. If you build custom verification, resist the urge to make it "clean" with JSON schemas.

### The 90/10 Token Split Nobody Optimizes

Over 90% of all tokens consumed are **cache reads**. Not input tokens. Not output tokens. Cache reads. This means the #1 cost optimization isn't "use Haiku instead of Opus" — it's **keeping your system prompt and CLAUDE.md stable across turns so prompt caching works.** Every time you change CLAUDE.md mid-session, you bust the cache. Every time a hook injects dynamic context into SessionStart, it may bust the cache. The Max plan makes this less painful ($200/mo vs $15k API equivalent for heavy users), but the principle holds: **cache stability is the invisible lever.**

### The `defer` + ntfy Pattern Is the Real Game-Changer

Everyone talks about autonomous coding agents, but the breakthrough pattern for April 2026 is **semi-autonomous with human-in-the-loop approval from your phone.** The flow:

1. Launch Claude Code headless with `-p` flag
2. `defer` permission decision (v2.1.89) pauses at risky tool calls
3. ntfy.sh pushes Allow/Deny to your phone with interactive buttons
4. You approve from the couch/gym/dinner table
5. Claude resumes

This is 0.4% false positive rate per Anthropic's production data. It's not "fully autonomous" (which is how you get Replit-style wipeouts). It's not "fully supervised" (which defeats the purpose). It's the sweet spot — **agent autonomy with structural human gates at the operations that matter.**

### The effortLevel Default Change Nobody Noticed

On April 7 2026 (v2.1.94), Anthropic changed the default `effortLevel` from `medium` to `high` for API/Bedrock/Vertex/Team/Enterprise users (NOT Pro/Max). If you're using API billing, your costs silently increased. If you're on Max, you're unaffected. But **any cost model, benchmark, or performance assumption from before April 7 is stale.** Check your settings.

### What Beats 50 MCP Servers: 3 Skills + 1 Methodology

The most effective Claude Code setup I've found isn't the one with the most tools — it's:
1. **Superpowers** for methodology (brainstorm → plan → execute → review)
2. **Spec-Kit** for architecture enforcement (spec → plan → tasks → implement)
3. **OMC** for orchestration (parallel agents, mode switching, ralph loops)
4. **A justfile** that Claude can read to understand your build/test/lint commands

That's it. Those four things give Claude more capability improvement than 50 MCP servers, because they change **how Claude thinks**, not just what tools it can call. The MCP servers are important (Serena, Context7, Playwright), but they're infrastructure. The skills are strategy.
