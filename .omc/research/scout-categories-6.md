# Scout Report: Six Under-Covered Blueprint Categories
**Date:** 2026-04-11  
**Scope:** Categories 1–6 as specified. Primary sources only. Stars and licenses verified on GitHub where accessible.

---

## Category 1 — Local LLM Routing / Proxy / Gateway / Hybrid Local+Frontier

### Context
George Liu's HN post "Running Google Gemma 4 locally with LM Studio headless CLI + Claude Code" named the hybrid local+frontier pattern as a real production category. Claude Code speaks the Anthropic Messages API natively; local servers (Ollama, LM Studio) historically speak OpenAI's chat completions format. The ecosystem has converged on two approaches: (a) a translation proxy (LiteLLM, Portkey) and (b) a native Anthropic-compat endpoint shipped by the inference server itself (LM Studio ≥0.4.1, Ollama with `/anthropic` path).

### Official Claude Code Gateway Documentation
The official `llm-gateway` docs page (`https://code.claude.com/docs/en/llm-gateway`) confirms ANTHROPIC_BASE_URL as the primary override mechanism. Officially documented gateways: **LiteLLM** (with security warning: PyPI versions 1.82.7/1.82.8 were compromised — rotate credentials if installed). Bedrock and Vertex pass-through are also documented via `ANTHROPIC_BEDROCK_BASE_URL` and `ANTHROPIC_VERTEX_BASE_URL`.

---

### Entry 1.1 — LiteLLM
- **Repo:** https://github.com/BerriAI/litellm
- **Version:** 1.83.3 (April 5, 2026)
- **Stars:** ~43k
- **License:** MIT (enterprise directory has separate terms)
- **Works with Claude Code via ANTHROPIC_BASE_URL:** YES — officially documented. Set `ANTHROPIC_BASE_URL=http://0.0.0.0:4000`.
- **Key trap:** PyPI versions 1.82.7 and 1.82.8 were compromised with credential-stealing malware (March 2026). Anthropic explicitly warns in its docs. Pin to 1.83.x+.
- **Why it matters:** The only gateway explicitly documented by Anthropic for Claude Code. Handles format translation (Anthropic ↔ OpenAI), load balancing, cost tracking, guardrails, and Bedrock/Vertex pass-through in one binary.

### Entry 1.2 — LM Studio (headless CLI)
- **URL:** https://lmstudio.ai / https://lmstudio.ai/docs/integrations/claude-code
- **Version:** 0.4.1 introduced `/v1/messages` Anthropic-compat endpoint; 0.4.0 introduced headless `lms` CLI daemon.
- **License:** Proprietary (free for personal use)
- **Works with Claude Code via ANTHROPIC_BASE_URL:** YES — native. Set `ANTHROPIC_BASE_URL=http://localhost:1234`, `ANTHROPIC_AUTH_TOKEN=lmstudio` (placeholder). No proxy needed.
- **Headless commands:** `lms daemon up`, `lms server start`, `lms get <model>`, `lms chat`.
- **Key trap:** GUI must have previously downloaded the model; headless mode does not browse the model catalog. Token placeholder `lmstudio` must still be set or Claude Code rejects the auth header.
- **Why it matters:** Zero-proxy path to run Gemma 4, Qwen, Mistral locally inside a terminal workflow. The HN-viral pattern that triggered this category research.

### Entry 1.3 — Ollama
- **Repo:** https://github.com/ollama/ollama
- **Stars:** ~169k
- **License:** MIT
- **Works with Claude Code via ANTHROPIC_BASE_URL:** YES — Ollama ships a native `/anthropic` compatibility path. Set `ANTHROPIC_BASE_URL=http://localhost:11434`, `ANTHROPIC_AUTH_TOKEN=ollama`. Also callable via `ollama launch claude`.
- **Key trap:** Anthropic-compat path is labeled experimental; not all Anthropic beta headers are forwarded. Complex tool-use schemas may fail on smaller models.
- **Why it matters:** Largest community, simplest install (`brew install ollama`), 169k stars. The de-facto local inference runtime for most developers.

### Entry 1.4 — Portkey AI Gateway
- **Repo:** https://github.com/Portkey-AI/gateway
- **Dedicated Claude Code page:** https://portkey.ai/for/claude-code
- **Version:** 2.0 (pre-release on `2.0.0` branch); 1.x stable on main
- **Stars:** ~11.3k
- **License:** MIT (open-source core; enterprise SaaS tier)
- **Works with Claude Code via ANTHROPIC_BASE_URL:** YES. Set `ANTHROPIC_BASE_URL=https://api.portkey.ai` plus `x-portkey-api-key` header via `ANTHROPIC_AUTH_TOKEN`.
- **Key trap:** Full observability features require cloud signup; self-hosted gateway 2.0 still pre-release as of April 2026.
- **Why it matters:** Enterprise-grade audit logging, budget caps, and semantic caching on top of the Claude Code call stream. The governance layer for teams that can't hand raw API keys to every developer.

### Entry 1.5 — OpenRouter
- **URL:** https://openrouter.ai / https://openrouter.ai/docs/guides/coding-agents/claude-code-integration
- **License:** Proprietary SaaS (no self-hosting)
- **Pricing:** 5.5% platform fee on credits; no markup on per-token model costs.
- **Works with Claude Code via ANTHROPIC_BASE_URL:** YES — OpenRouter speaks Anthropic Messages format natively. Set `ANTHROPIC_BASE_URL=https://openrouter.ai/api`. No local proxy needed.
- **Key trap:** Closed SaaS; data leaves your network. Free router introduced March 12, 2026.
- **Why it matters:** Instant access to 200+ models (GPT-5, Gemini 3, DeepSeek, Llama) through one endpoint — cost comparison and automatic fallback across providers without running any local infra.

### Entry 1.6 — vLLM
- **Repo:** https://github.com/vllm-project/vllm
- **Version:** v0.19.0 (April 3, 2026)
- **Stars:** ~76.2k
- **License:** Apache-2.0
- **Works with Claude Code via ANTHROPIC_BASE_URL:** YES, via LiteLLM as intermediary (vLLM exposes OpenAI-format; LiteLLM translates). Configure LiteLLM with `drop_params: true`, `modify_params: true`.
- **Key trap:** Requires NVIDIA GPU (or ROCm). Not a plug-and-play local tool; more a production server for teams running inference on dedicated hardware. Does not ship a native Anthropic-compat endpoint.
- **Why it matters:** Highest-throughput open-source inference server; the right backend when running Claude-sized open models (Llama 3, Qwen-2.5) on dedicated GPU infra.

---

## Category 2 — Sub-One-Minute Inner Build Loop / Dev Environment / Parallel Process Runner

### Context
Ryan Lopopolo's "Dark Factory" essay names sub-one-minute builds as a non-negotiable constraint for parallel agent work. Claude Code invokes build tools via the Bash tool or PostToolUse/Stop hooks; the build tool itself is external. The relevant question: which tools keep the inner loop tight and can be wired as a `claude code` hook target?

---

### Entry 2.1 — Turborepo
- **Repo:** https://github.com/vercel/turborepo
- **Version:** v2.9.6 (April 10, 2026)
- **Stars:** ~30.2k
- **License:** MIT
- **What it does:** High-performance JS/TS monorepo build system in Rust with local + remote caching, task graph, and `--watch` mode.
- **Claude Code connection:** Wire as the build step in a PostToolUse hook: `turbo run build --filter=...[HEAD]`. Remote cache (Vercel or self-hosted) means subsequent agent runs hit cache even after context reset.

### Entry 2.2 — Nx
- **Repo:** https://github.com/nrwl/nx
- **Version:** 22.6.5 (April 10, 2026)
- **Stars:** ~28.5k
- **License:** MIT
- **What it does:** Monorepo platform with task graph, affected-file computation, and distributed cloud caching. 5M weekly downloads; 7x faster CI than Turborepo in large-scale benchmarks (2026).
- **Claude Code connection:** `nx affected --target=build` after edits — limits rebuild scope to files Claude actually changed. Nx Agents (CI) can parallelize test shards matching Claude's parallel subtask model.

### Entry 2.3 — mise
- **Repo:** https://github.com/jdx/mise
- **Version:** v2026.4.8 (April 10, 2026)
- **Stars:** ~26.6k
- **License:** MIT
- **What it does:** "The front-end to your dev env" — unified tool version manager (Node, Python, Rust, Go, etc.), `.env` manager, and task runner in one binary. Replaces asdf, nvm, pyenv, direnv, and make for many teams.
- **Claude Code connection:** `mise run test` as a hook build step; `.mise.toml` checked into the repo ensures Claude's Bash tool always uses the same tool versions as CI. Critical for reproducible agent environments.

### Entry 2.4 — just
- **Repo:** https://github.com/casey/just
- **Version:** Active (1,665 commits; no stamped semver, rolling releases)
- **Stars:** ~32.8k
- **License:** See repo (permissive)
- **What it does:** A command runner (not a build system) — project-specific task recipes in a `justfile`, analogous to `make` but without the dependency graph foot-guns.
- **Claude Code connection:** `just test` or `just lint` as PostToolUse hook targets. Simple, human-readable `justfile` that Claude can read and reason about to understand available project commands.

### Entry 2.5 — watchexec
- **Repo:** https://github.com/watchexec/watchexec
- **Stars:** ~6.8k (last updated March 2026)
- **License:** Apache-2.0
- **What it does:** Watches filesystem paths and re-runs commands on change. More ergonomic defaults than `entr` (no explicit file listing required, gitignore-aware).
- **Claude Code connection:** Background process that triggers `just test` or `cargo build` whenever Claude writes a file — closes the edit→compile→error feedback loop within seconds, surfacing compiler errors Claude can read on next turn.

### Entry 2.6 — mprocs
- **Repo:** https://github.com/pvolok/mprocs
- **Version:** 0.6.4
- **Stars:** ~2.5k
- **License:** MIT
- **What it does:** Runs multiple processes in parallel in a TUI with per-process panes. Simpler than tmux for finite-lifetime dev tasks.
- **Claude Code connection:** `mprocs` as a dev harness that runs the Claude Code session, the file watcher, the test runner, and the build process concurrently — single-pane-of-glass for the human supervisor.

### Entry 2.7 — devenv (Nix-based)
- **Repo:** https://github.com/cachix/devenv
- **Version:** 2.0.0
- **License:** Apache-2.0
- **What it does:** Declarative, reproducible dev environments using Nix. Per-project shell with exact tool versions locked in `devenv.nix`.
- **Claude Code connection:** `devenv shell` guarantees the same runtime for both the developer and Claude's Bash tool calls — eliminates "works on my machine" failures when Claude runs tests.

---

## Category 3 — Cross-Vendor AI Code Reviewers (Not Claude Itself)

### Context
Principle "writer ≠ reviewer" is best served by a reviewer on a *different* model family. All entries below integrate with GitHub PR flow and use a model other than Claude as the primary reviewer.

---

### Entry 3.1 — CodeRabbit
- **URL:** https://coderabbit.ai
- **Pricing:** Free tier (public repos, basic summaries); Lite $12/user/month; Pro $25/user/month (BYOK option at ~$0.01–0.05/review using your own Claude/GPT/Gemini key)
- **Model used:** Proprietary mix; BYOK allows Claude, Gemini, or GPT-4o. Default model undisclosed.
- **GitHub PR integration:** YES — installs as a GitHub App; comments inline on diffs; supports GitLab, Bitbucket, Azure DevOps too.
- **MCP/Claude Code artifact awareness:** YES — CodeRabbit has a Claude Code integration guide (Feb 2026). It can review PRs generated by Claude Code sessions.
- **Benchmark:** Catches ~82% of bugs in third-party benchmarks (vs. Greptile's ~44%).
- **Pick this over Claude Code review when:** You want a different model family as reviewer (preventing same-model echo chamber), need 40+ linter integrations in one PR comment, or want GitLab/Bitbucket support.

### Entry 3.2 — Greptile
- **URL:** https://www.greptile.com
- **Pricing:** $30/user/month; no free tier. Alternative: $0.45/file changed, capped at $50/developer/month.
- **Model used:** Undisclosed (proprietary indexing + frontier LLM calls). Full codebase graph indexing distinguishes it.
- **GitHub PR integration:** YES — GitHub and GitLab via webhook.
- **MCP/Claude Code artifact awareness:** Not explicitly documented.
- **Pick this over CodeRabbit when:** The bug requires tracing across multiple files or git history — Greptile's codebase graph finds cross-file regressions that diff-only reviewers miss.

### Entry 3.3 — GitHub Copilot Code Review
- **URL:** https://docs.github.com/en/copilot/how-tos/use-copilot-agents/request-a-code-review
- **Pricing:** Included in GitHub Copilot Pro ($10/month) and Enterprise plans.
- **Model used:** Microsoft's purpose-tuned mix (GPT-family + CodeQL integration); not Claude.
- **GitHub PR integration:** NATIVE — available in `gh pr create` and `gh pr edit` via CLI since March 2026 (GitHub Changelog 2026-03-11).
- **Pick this when:** Already on GitHub Copilot subscription; want CodeQL security findings surfaced in the same PR review comment without a separate SAST pipeline.

### Entry 3.4 — Korbit AI
- **URL:** https://www.korbit.ai / https://github.com/apps/korbit-ai
- **Pricing:** Freemium (GitHub App); paid tiers for teams.
- **Model used:** Undisclosed; zero-retention, zero-training policy claimed.
- **GitHub PR integration:** YES — installs as GitHub App.
- **Pick this when:** Data privacy is a hard requirement (zero-retention policy) and you still want automated PR summaries, bug detection, and query answering on the diff.

### Entry 3.5 — Bito AI
- **URL:** https://bito.ai/product/ai-code-review-agent/
- **GitHub repo (OSS agent):** https://github.com/gitbito/CodeReviewAgent
- **Pricing:** Pro $15/developer/month; integrates with GitHub, GitLab, Bitbucket.
- **Model used:** Configurable; supports OpenAI and Anthropic models.
- **Pick this when:** Onboarding acceleration is the goal — Bito is strongest at explaining unfamiliar code to new team members while also reviewing it.

---

## Category 4 — Code Search / Semantic Indexing / AST Query

### Context
Principle 6 ("output channel is the leverage point for context") means a fast code index returning *small targeted spans* reduces context consumption and improves accuracy. These tools feed Claude Code either as MCP tools or as Bash-invocable commands.

---

### Entry 4.1 — ast-grep
- **Repo:** https://github.com/ast-grep/ast-grep
- **Version:** 0.42.1 (April 4, 2026)
- **Stars:** ~13.4k
- **License:** MIT
- **Language coverage:** 20+ languages via tree-sitter parsers (Rust, TypeScript, Python, Go, Java, C, C++, etc.)
- **Speed:** Comparable to ripgrep; operates on AST not text.
- **Claude Code integration:** Two paths:
  1. **MCP server** — `ast-grep/ast-grep-mcp` (https://github.com/ast-grep/ast-grep-mcp) adds four MCP tools for structural search, replace, lint, and AST visualization. Add via `claude mcp add`.
  2. **Bash invocation** — `sg --pattern 'async function $NAME($_$$)' src/` piped into Claude's context.
- **Why it matters:** Finds structural patterns (all async functions without try-catch, all React hooks violating rules-of-hooks) that regex cannot express. The MCP bridge is the cleanest integration point.

### Entry 4.2 — Zoekt
- **Repo:** https://github.com/sourcegraph/zoekt
- **Stars:** ~1.5k (library; embedded in Sourcegraph which has much higher usage)
- **License:** Apache-2.0
- **Language coverage:** All text-based source files (trigram index, language-agnostic).
- **Speed claim:** Sub-second search on million-file corpora; powers all Sourcegraph instances and sourcegraph.com's 1M+ repo index.
- **Claude Code integration:** Bash invocation via `zoekt-webserver` or `zoekt` CLI. Not MCP-native. Best used as a backend for a custom search MCP tool.
- **Why it matters:** Gold-standard for large-corpus text+regex code search. If your repo is >100k files, Zoekt's trigram index outperforms ripgrep's linear scan.

### Entry 4.3 — Semgrep (sg)
- **URL:** https://semgrep.dev / https://github.com/returntocorp/semgrep
- **License:** LGPL-2.1 (OSS engine); proprietary SaaS tiers.
- **Language coverage:** 30+ languages with language-specific semantic rules.
- **Speed:** Fast; incremental scanning supported.
- **Claude Code integration:** Bash invocation — `semgrep --config=auto src/` returns structured JSON that Claude can parse. Security-rule sets available for common vulnerability patterns.
- **Why it matters:** Best tool for security-pattern search (OWASP rules, custom taint analysis). When Claude writes code, a PostToolUse hook running `semgrep` catches injections and insecure patterns before they reach review.

### Entry 4.4 — GritQL / Grit
- **URL:** https://grit.io / https://github.com/getgrit/gritql
- **License:** MIT (engine); proprietary cloud service.
- **Language coverage:** Multi-language (JS/TS, Python, Go, Rust, and more).
- **Claude Code integration:** Bash invocation — `grit apply <pattern>` for structural rewrite; `grit check` for query. More expressive than ast-grep for multi-step rewrites.
- **Why it matters:** Combines structural search with rewrite rules in one declarative language. Useful for large-scale automated refactors that Claude proposes but can't safely do file-by-file at scale.

### Entry 4.5 — Probe
- **Repo:** https://github.com/probelabs/probe
- **License:** MIT
- **Description:** AI-friendly semantic code search combining ripgrep speed with tree-sitter AST parsing. Designed specifically for AI coding assistant context retrieval.
- **Claude Code integration:** Bash invocation or MCP tool (documented as compatible with Claude Code and Cursor).
- **Why it matters:** Newer entrant (2025) purpose-built for feeding AI agents — returns compact, ranked code spans rather than raw file dumps, reducing context window usage.

---

## Category 5 — Autonomous Coding Agents (Alternatives to Claude Code, Not Harnesses)

### Context
These are "give it a task + walk away" agents — they manage their own loop, file edits, test runs, and PR creation. Architecturally different from Claude Code (interactive) or Aider (driven). The question is when you'd delegate *to* one of these instead of using Claude Code interactively.

---

### Entry 5.1 — OpenHands (formerly OpenDevin)
- **URL:** https://openhands.dev / https://github.com/All-Hands-AI/OpenHands
- **Version:** 1.6.0 (March 30, 2026)
- **Stars:** ~71k
- **License:** MIT (enterprise directory separate)
- **Status:** Active; $18.8M Series A; CodeAct 2.1 released November 2025.
- **Pricing:** Open-source self-hosted (free, bring your own LLM key); OpenHands Cloud free individual tier + paid commercial tiers.
- **Autonomy model:** Full loop — reads codebase, writes code, runs tests, creates PRs. SWE-Bench Verified: open-weight models within 2–6% of frontier proprietary models.
- **Use instead of Claude Code when:** You have a well-defined GitHub issue and want a fully unattended batch run without keeping a terminal session open. Best for "fix this bug" tasks that don't need iterative human steering.

### Entry 5.2 — Devin (Cognition AI)
- **URL:** https://devin.ai
- **Status:** Generally available; Devin 2.0 in production.
- **Pricing:** Core $20/month (pay-per-ACU at $2.25); Teams $500/month (250 ACUs included at $2.00/ACU). Enterprise on request.
- **Autonomy model:** Fully autonomous — accepts tickets from Linear/Jira/Slack, browses the web, writes code, runs tests, opens PRs, responds to review comments. No human-in-the-loop required.
- **SWE-Bench score:** 13.86% end-to-end (7x over previous SOTA); Devin 2.0 completes 83% more junior tasks per ACU than Devin 1.
- **Key trap:** Default opt-in to training on your code; must explicitly opt out for proprietary repos.
- **Use instead of Claude Code when:** The task is a well-specified JIRA ticket requiring web research + multi-session persistence. Devin maintains state across days; Claude Code resets per session.

### Entry 5.3 — SWE-agent / mini-SWE-agent
- **Repo:** https://github.com/SWE-agent/SWE-agent
- **Version:** v1.1.0 (May 2025); mini-swe-agent is the active successor.
- **Stars:** ~19k
- **License:** MIT
- **Status:** Original SWE-agent in maintenance mode; mini-SWE-agent (100 lines of Python) is the recommended path. Achieves 65% on SWE-Bench Verified.
- **Pricing:** Free (bring your own model API key).
- **Autonomy model:** Batch — given a GitHub issue URL, runs to completion and outputs a patch. Research-grade Agent-Computer Interface (ACI).
- **Use instead of Claude Code when:** Running automated benchmarks, CI-integrated issue triage, or you need a lightweight scriptable agent that produces a diff for human review.

### Entry 5.4 — Google Jules
- **URL:** https://jules.google
- **Status:** Out of beta (August 2025); Jules Tools CLI released October 2025; Jules V2 waitlist open (2026).
- **Pricing:** Free tier (15 tasks/day, 3 concurrent); Google AI Pro $19.99/month (5x limits); Ultra $124.99/month (20x limits). Gemini 3 Pro now available in Jules.
- **Autonomy model:** Asynchronous — assign a GitHub issue, Jules works in a cloud VM, returns an audio changelog + PR. No local compute required.
- **Use instead of Claude Code when:** You want Google's Gemini models (not Anthropic) handling the agent loop, or you need async batch processing of many issues in parallel without managing local infra.

### Entry 5.5 — Cline
- **URL:** https://cline.bot
- **Status:** Active; $32M raised (Series A July 2025). Top fully OSS coding agent by adoption.
- **Autonomy model:** IDE-embedded but can run headless in loop mode; local-first, model-agnostic (Claude, GPT-5, Gemini, local). Diff + command approvals.
- **Use instead of Claude Code when:** You want a fully open-source agent with VS Code integration and plan/act mode, or you want to run against a local model without Anthropic billing.

---

## Category 6 — Ambient Notification / Long-Horizon Pause / Approval Channels

### Context
Claude Code v2.1.89 shipped `"defer"` as a 4th `permissionDecision` value for headless (`-p` flag) sessions. When a hook returns `{"permissionDecision": "defer"}`, the process exits with `stop_reason: "tool_deferred"` and the pending tool call preserved. A calling process must resume via `claude -p --resume <session-id>`. This requires a notification channel to wake a human approver.

### Defer mechanics (from official hooks docs)
- Available only in non-interactive mode (`-p` flag); requires Claude Code ≥ v2.1.89.
- Precedence when multiple hooks conflict: `deny > defer > ask > allow`.
- The calling process reads `deferred_tool_use` from the SDK result, surfaces it to a human, then resumes.

---

### Entry 6.1 — ntfy.sh
- **Repo:** https://github.com/binwiederhier/ntfy
- **Version:** v2.21.0
- **Stars:** ~29.7k
- **License:** Apache-2.0 / GPL-2.0 (dual)
- **Pricing:** Self-hostable (free); ntfy.sh cloud: Free, Basic $5/mo, Pro $10/mo, Business $20/mo.
- **Wire to Claude Code defer:** PreToolUse hook posts to `https://ntfy.sh/<topic>` with the tool call preview. Human sees mobile push notification, taps Allow/Deny. Advanced: `claude-ntfy-hook` (https://github.com/nickknissen/claude-ntfy-hook) adds interactive Allow/Deny phone buttons that resume the deferred session.
- **Why this channel:** No API key required for basic use; self-hosted option for air-gapped environments; MCP server available (`cyanheads/ntfy-mcp-server`) for in-agent notification dispatch.

### Entry 6.2 — Telegram Bot API
- **URL:** https://core.telegram.org/bots/api
- **License:** Proprietary (free API)
- **Wire to Claude Code defer:** Hook script calls `https://api.telegram.org/bot<TOKEN>/sendMessage` with inline keyboard buttons (Allow/Deny/Edit). Webhook receives button press, resumes `claude -p --resume`. Free, fast, no infrastructure.
- **Why this channel:** Zero cost, real-time delivery, rich inline keyboard for structured approvals. The `claude-notifications-go` plugin (https://github.com/777genius/claude-notifications-go) supports Telegram out of the box with one-line installation.

### Entry 6.3 — Slack (Incoming Webhooks + Block Kit)
- **URL:** https://api.slack.com/messaging/webhooks
- **License:** Proprietary SaaS
- **Wire to Claude Code defer:** Hook posts Block Kit message with "Approve" / "Deny" buttons to a Slack channel. Slack sends an interactive component payload to a callback URL; that callback resumes Claude. The `claude-notifications-go` plugin supports Slack webhooks.
- **Why this channel:** Approval flow lives inside the team's existing communication tool. Block Kit supports rich previews of diffs or tool inputs. Best for team environments where multiple humans may need to approve.

### Entry 6.4 — Pushover
- **URL:** https://pushover.net
- **License:** Proprietary; $5 one-time per platform (iOS/Android).
- **Wire to Claude Code defer:** Hook script posts to `https://api.pushover.net/1/messages.json` with priority, sound, and supplementary URL linking to a web approval page.
- **Why this channel:** Reliable delivery guarantees, priority levels (emergency = repeat until acknowledged), delivery receipts. Best for solo developers who need guaranteed wake-up for high-stakes tool calls.

### Entry 6.5 — trigger.dev
- **URL:** https://trigger.dev
- **License:** Open-source (Apache-2.0); cloud hosted.
- **Wire to Claude Code defer:** Claude Code hook triggers a durable Trigger.dev task with typed payload (tool name, inputs, session ID). Task waits for human approval via a web dashboard, Slack notification, or email, then calls `claude -p --resume`. Automatic retries, typed payloads, full execution trace.
- **Why this channel:** Best when the approval workflow itself needs durability — if the approver is offline for 8 hours, the task is still pending, not lost. Pairs with Hookdeck for reliable webhook ingestion.

---

## Summary Table

| Category | Top Entry | #2 | #3 |
|----------|-----------|-----|-----|
| 1 — LLM Gateway | LiteLLM (officially documented) | LM Studio headless CLI | Ollama |
| 2 — Build Loop | mise (unified, 26.6k★) | Turborepo (30.2k★) | just (32.8k★) |
| 3 — Cross-Vendor Review | CodeRabbit (82% bug catch rate) | Greptile (full codebase graph) | GitHub Copilot Review |
| 4 — Code Search/AST | ast-grep + MCP server | Semgrep (security patterns) | Probe (AI-native) |
| 5 — Autonomous Agents | OpenHands (71k★, MIT) | Devin (most autonomous) | Google Jules (async) |
| 6 — Notification/Defer | ntfy.sh (29.7k★, self-hostable) | Telegram Bot API (free) | Slack Block Kit (team) |

---

## Sources

- https://code.claude.com/docs/en/llm-gateway (official LiteLLM gateway docs + security warning)
- https://github.com/BerriAI/litellm (43k★, MIT, v1.83.3)
- https://lmstudio.ai/docs/integrations/claude-code (LM Studio 0.4.1 Anthropic compat)
- https://github.com/ollama/ollama (169k★, MIT)
- https://github.com/Portkey-AI/gateway (11.3k★, v2.0 pre-release)
- https://openrouter.ai/docs/guides/coding-agents/claude-code-integration
- https://github.com/vllm-project/vllm (76.2k★, Apache-2.0, v0.19.0)
- https://github.com/vercel/turborepo (30.2k★, MIT, v2.9.6)
- https://github.com/nrwl/nx (28.5k★, MIT, v22.6.5)
- https://github.com/jdx/mise (26.6k★, MIT, v2026.4.8)
- https://github.com/casey/just (32.8k★)
- https://github.com/watchexec/watchexec (6.8k★)
- https://github.com/pvolok/mprocs (2.5k★, MIT, v0.6.4)
- https://github.com/cachix/devenv (Apache-2.0, v2.0.0)
- https://coderabbit.ai
- https://www.greptile.com
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/request-a-code-review
- https://www.korbit.ai
- https://bito.ai/product/ai-code-review-agent/
- https://github.com/ast-grep/ast-grep (13.4k★, MIT, v0.42.1)
- https://github.com/ast-grep/ast-grep-mcp
- https://github.com/sourcegraph/zoekt (1.5k★, Apache-2.0)
- https://github.com/returntocorp/semgrep
- https://grit.io
- https://github.com/probelabs/probe
- https://openhands.dev / https://github.com/All-Hands-AI/OpenHands (71k★, MIT, v1.6.0)
- https://devin.ai/pricing/
- https://github.com/SWE-agent/SWE-agent (19k★, MIT)
- https://jules.google
- https://cline.bot
- https://github.com/binwiederhier/ntfy (29.7k★, Apache-2.0/GPL-2.0)
- https://core.telegram.org/bots/api
- https://github.com/777genius/claude-notifications-go
- https://trigger.dev
- https://code.claude.com/docs/en/hooks (defer mechanics, requires v2.1.89+)

