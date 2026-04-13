# Architecture Prompt for the AI

*Copy-paste the block below into the AI of your choice (Claude, GPT, Gemini, etc.). Attach `RESEARCH_CORPUS.md` as context, or paste its contents after the prompt if the AI doesn't support attachments. Tune the "About me" section before pasting.*

---

## THE PROMPT

You are a senior software architect. I am attaching a complete research corpus about the Claude Code ecosystem as of April 11, 2026 (`RESEARCH_CORPUS.md`). It is the consolidated output of 17 parallel research lanes — platform state, verified configuration schemas, the full plugin/skill/subagent ecosystem, the MCP server roster, self-hosted multi-agent orchestration platforms, adjacent frameworks, spec-driven development tools, sandbox runtimes, CI/CD and production deployment, observability/memory/cost/evaluation stacks, the post-leak ecosystem, documented incidents and regressions, workstation conventions, the distilled CLAUDE.md principle corpus, architecture-updating essays, the April 2026 arxiv research frontier, and a consolidated bibliography of ~260 sources. Treat it as ground truth. Do not re-research, do not contradict primary-source findings, do not substitute your training data for the corpus. Where I've flagged a claim as single-sourced or skeleton, preserve that flag.

Your job: **produce the best possible system architecture for my Claude Code setup as a single markdown document I can use as a blueprint.**

### About me (EDIT THIS BEFORE SUBMITTING)

- **Who:** solo developer / small team / enterprise / other — [pick one]
- **Primary stack:** [TypeScript, Python, Rust, Go, other]
- **Deployment targets:** [Vercel, Cloudflare, AWS, GCP, self-hosted, other]
- **OS:** Linux / macOS / Windows
- **Anthropic plan:** Max / Team / Enterprise / API only
- **Risk tolerance:** I accept / reject Zero Data Retention constraints, managed Code Review, cloud sandboxes, etc.
- **Existing tooling I'm attached to:** [e.g., neovim, tmux, chezmoi, Nx, pnpm]
- **Things I want to do that are unusual:** [e.g., run 20+ parallel agents, ship a Cowork-style SaaS to users, do ML-heavy Python work, build mobile apps, automate security research]
- **Things I explicitly don't want:** [e.g., self-hosted orchestration, plugin maximalism, spec-driven ceremony, Bedrock routing]

### What I want from you

I want **maximum, not minimum**. Give me the full architecture with every component from the corpus that could plausibly earn its slot for my profile. I will trim what I don't need. Do not protect me from complexity. Do not give me a "getting started" blueprint. Give me the whole machine.

Specifically, produce a single markdown document structured as follows:

#### Section 1 — Mental Model
One coherent mental model I can carry in my head. Not a layer cake. Not a list of layers. An actual architectural framing (e.g., kernel/userland/init from Anthropic's "Scaling Managed Agents" post, or a different framing if you have a better one). Explain the core abstractions and the brain↔hands contract. 600–1200 words. Prose, not bullets.

#### Section 2 — Principles
10–15 load-bearing opinions. Each principle must be: (a) one bold claim, (b) 1–3 sentences of justification citing specific evidence from the corpus (section anchors like "corpus Part M.1" are fine), (c) explicit about what it makes impossible. Pull from the corpus's 18 CLAUDE.md principles (Part O), the production harness insights (Part P.1), Anthropic's own engineering posts, the arxiv findings (Part Q), and the incident evidence (Part M).

#### Section 3 — The Full Topology
An ASCII diagram (or multiple) showing:
- Claude Code as kernel (session / harness / sandbox)
- All the userland slots filled with EVERY component from the corpus that's plausibly relevant to my profile — alternatives shown side by side, not just the "primary" pick
- The init system (CLAUDE.md + hooks + spec-kit gates)
- The observability plane (tracing + cost + memory + replay)
- Remote services (GitHub, Vercel, cloud sandboxes, Anthropic API)
- The sandbox isolation boundary
- Inter-component arrows showing data flow and integration points

Be maximal. I would rather see 40 boxes and trim 30 than see 10 and wonder what I'm missing.

#### Section 4 — The Slot Roster (the meat of the document)
For each of these **24 slots**, list every relevant component from the corpus with a one-line description, star count / version / license / install command where known, and a clear "when to pick this over the alternatives" sentence. Bold the primary recommendation for my profile but don't hide the alternates.

1. **Base CLI kernel** — Claude Code + Codex CLI + Gemini CLI + Goose + Aider + OpenCode + etc.
2. **Agent-first IDEs** — Antigravity, Cursor 3, Windsurf, Zed (ACP), VS Code extension, JetBrains, Neovim (coder/claudecode.nvim + greggh)
3. **Discipline / skills / plugin frameworks** — Superpowers, SuperClaude, BMAD, OMC, get-shit-done, all the VoltAgent/alirezarezvani/mattpocock/Karpathy/JimLiu/Skill_Seekers skills collections, awesome lists (hesreallyhim, rohitg00, jeremylongshore, affaan-m, davila7/claude-code-templates, Chat2AnyLLM, andyrewlee/awesome-agent-orchestrators), poshan0126/dotclaude, citypaul/.dotfiles, fcakyon/claude-codex-settings, nicknisi/dotfiles
4. **Subagent collections** — wshobson/agents, VoltAgent/awesome-claude-code-subagents, contains-studio/agents, iannuttall, lst97
5. **Self-hosted multi-agent orchestration platforms** — **every one from corpus Part E**: Paperclip, Ruflo, Vibe-Kanban, Gastown, Multica, Claude Squad, ComposioHQ/agent-orchestrator, claude-mpm, multiclaude, overstory, claude-code-by-agents, claude_code_agent_farm, untra/operator, Claw-Kanban, swarmclaw, praktor, sandstorm, oh-my-claudecode, plus the 96-project `awesome-agent-orchestrators` long tail. Show a comparison table. Identify which ones compose with each other, which are mutually exclusive.
6. **First-party orchestration** — Claude Code Agent Teams (experimental), Claude Managed Agents, Claude Cowork
7. **Adjacent agent frameworks** — Hermes, Letta (claude-subconscious, letta-cowork), CrewAI, Langroid, Microsoft Agent Framework 1.0, LangGraph, Temporal, Airflow, Argo
8. **Spec-driven development** — Spec-Kit, Kiro, Tessl, cc-sdd, gsd-build, OpenSpec, BMAD, Drew Breunig's Plumb, eforge, OmoiOS, metaskill, claude-agent-builder
9. **MCP servers — code intelligence** — Serena, code-graph-mcp, codebase-memory-mcp, CodeGraphContext, codegraph-rust
10. **MCP servers — docs / library lookup** — Context7, DeepWiki, ref.tools, docs-mcp-server
11. **MCP servers — browser** — Playwright MCP, chrome-devtools-mcp, Browserbase, Puppeteer, lightpanda, trycua/cua, page-agent
12. **MCP servers — GitHub / git** — github/github-mcp-server, gitlab-mcp-server, and community forks
13. **MCP servers — database** — Supabase MCP, postgres-mcp, mysql-mcp, sqlite-mcp, mongodb-mcp (note the Supabase-dev-only caveat)
14. **MCP servers — memory** — modelcontextprotocol/memory (official), memento-mcp, mcp-memory-service, ClawMem, claude-mem, claude-echoes, collabmem, memU, lodmem, claude-memory-compiler, claude-brain
15. **MCP servers — observability** — sentry-mcp, posthog-mcp (plus Langfuse/Arize/Braintrust/LangSmith/Helicone)
16. **MCP servers — search** — Exa, Perplexity Sonar, Tavily, Brave, Serper
17. **MCP servers — sandbox bridges** — container-use, microsandbox, E2B MCP wrappers
18. **Sandbox runtimes** — Docker sbx, E2B, Daytona, Modal, container-use, Cloudflare Sandbox SDK, Vercel Sandbox, Fly.io Sprites, Depot Remote Agent Sandboxes, microsandbox, Northflank, trailofbits/claude-code-devcontainer, arrakis, Claude Managed Agents. Show a decision tree by use case (interactive, CI, autonomous overnight, SaaS serving).
19. **Hooks ecosystem** — karanb192, disler (mastery + observability), doobidoo, kenryu42, sangrokjung, lasso-security, bartolli, diet103, plus patterns for PreToolUse/PostToolUse/SessionStart/SessionEnd/StopFailure/UserPromptSubmit
20. **CI/CD** — anthropics/claude-code-action v1, Code Review for Claude Code managed app, the 5 systemprompt.io recipes, GitLab integration + GitLab Duo Agent Platform with Claude, CircleCI MCP, Buildkite, Dagger (container-use), Vercel AI Gateway, preview deploys, ArgoCD/Flux GitOps pattern, Temporal/Argo/Airflow with Agent SDK
21. **Observability / tracing** — native OTel, Langfuse (self-host + cloud), Arize Phoenix, Braintrust, LangSmith, Helicone, Honeycomb, Datadog, Grafana, SigNoz, claude_telemetry wrapper, anthropics/claude-code-monitoring-guide, ColeMurray reference stack
22. **Cost / desktop / session tooling** — ccusage, ccost, cccost, usage-analyzer, ccusage-vscode, Claude-Code-Usage-Monitor, kerf-cli, claude-devtools, claude-replay, claude-code-log, workpulse, claude-hud, daedalus
23. **Context compression** — context-mode, graphify, caveman, rtk, Squeez
24. **Workstation** — Ghostty / WezTerm / Kitty / iTerm2; tmux / Zellij; zsh / fish + Starship; VS Code / Zed / Neovim; chezmoi + age / Stow / yadm; git worktrees; claudecode-discord; ocp; agenttray; peon-ping

For each slot, give a crisp "when to use which" rule. Maximize breadth. Do not filter out options I didn't ask about.

#### Section 5 — Integration / Wiring Recipes
At least 10 concrete recipes showing how the components actually connect. Minimum coverage:
1. How Superpowers' subagent-driven-development loop composes with container-use for per-agent branches
2. How Claude Code Agent Teams interacts with (vs replaces) a self-hosted orchestration platform
3. How spec-kit's `/speckit.*` phases feed plan.md into Superpowers' execution layer
4. How native OTel → Langfuse → Grafana dashboards actually wire up end-to-end
5. How managed Code Review + `claude-code-action@v1` + a bughunter-severity jq gate compose into a merge pipeline
6. How mcp-memory-service's dream-consolidation hooks + SessionEnd DECISIONS.md + a CLAUDE.md self-improvement loop compose into durable memory
7. How Paperclip / Vibe-Kanban / Multica / Gastown wrap around Claude Code — show what each intercepts, where the `execute(name, input) → string` contract sits, what they change vs. leave alone
8. How a Vercel AI Gateway routing with Max subscription custom headers works for projects that DON'T deploy to Vercel
9. How Fly Sprites + Depot + Cloudflare Sandbox SDK + Vercel Sandbox + container-use compose into a sandbox-per-use-case strategy (interactive / CI / serving users / overnight)
10. How Hermes-agent / Letta / CrewAI integrate with Claude Code as sidecars rather than replacements

Each recipe: 3-8 steps, concrete commands, a short rationale. Show me the arrows and the packets on the arrows.

#### Section 6 — Routing Decisions (Decision Trees)
Explicit decision trees for:
- "Which orchestration layer should I install?" (Agent Teams vs Paperclip vs Vibe-Kanban vs Multica vs Ruflo vs OMC vs Gastown vs Superpowers-alone)
- "Which sandbox for which use case?"
- "Which memory system?"
- "Which observability backend?"
- "Which spec tool?"
- "When to use Auto Mode / Plan Mode / container-use / trailofbits-devcontainer / Managed Agents"
- "CLAUDE.md vs AGENTS.md vs GEMINI.md vs REVIEW.md — which file, which rules"

Each decision tree: a mermaid or ASCII flowchart plus a 2-3 sentence rule per branch.

#### Section 7 — Maximum Install Playbook
A runnable bash script (or equivalent) that installs the entire maximal stack in the correct dependency order. Observability first, then core primitives, then orchestration, then orchestration-adjacents, then production/CI. Idempotent. Should work from a fresh Linux machine with `git + docker + node + uv + gh + python3 + brew-or-equivalent` pre-installed.

#### Section 8 — Trim-Down Guide
For each slot in Section 4, tell me: "If you remove this component, you lose X. Replace with Y (same slot) or Z (different slot) if you need to reduce surface area." Give me a priority-ordered list of trim candidates — "here's what to remove first if the stack feels heavy."

#### Section 9 — Failure Modes & Trust Signals
Name the 10 most likely failure modes given the stack I'm installing. Each with: (a) which corpus finding documents it (arxiv 2604.04978 for the permission gate, issue #42796 for thrashing, Part M.2 for the 2.5-years wipeout, etc.), (b) which component in my architecture is the defense, (c) what to monitor as the canary, (d) what to do when it trips.

#### Section 10 — Review Against the 10 Principles
Close the loop. Walk through your own Section 2 principles and rate how well your architecture honors each one, 1–5. Be honest: if a principle trades off against another, say so. If you had to pick between two principles in conflict, say which you picked and why.

### Quality bar

- **Evidence-backed, not vibes-backed.** Every strong claim points at a specific Part of the corpus. "Corpus Part K.3" is a citation. "The docs say" without a pointer is not.
- **Opinionated AND comprehensive.** Name the primary pick AND show every alternate from the corpus. Do not hide choices from me.
- **Working configs.** Every schema, env var, command, and file path must match the verified schemas in Part B and Part R. Do NOT invent keys. If the corpus says `defaultModel` doesn't exist, your blueprint must use `model`. If Spec-Kit is `uv tool install specify-cli --from git+...`, do not write `pipx install` or `npm install -g`.
- **No catalogue-without-architecture.** Every slot in Section 4 must have integration prose, not just a list.
- **Copy-pasteable.** Every file block should have a path in a comment at the top. Every shell command should be runnable as-is with clearly named env-var placeholders.
- **Honest about gaps.** Where the corpus flags something as `[skeleton]`, `not battle-tested`, `single-sourced`, or `could not verify`, preserve the flag in your output.
- **No restating research as prose.** The corpus is the research. Your job is architecture, not summarization. Every paragraph should contain either a decision, a connection, an install command, a schema, or a principle — not recapitulation.

### Length target

- Minimum 15,000 words. Expected 20,000–30,000. Maximum 40,000. This is a blueprint, not a summary. Err on the side of more file examples, more integration recipes, more alternates shown — not more prose.

### What to NOT do

- Do not give me a "getting started" or "minimalist" version. I already have one of those.
- Do not omit a component because you think I don't need it — I'll decide.
- Do not collapse the 20+ self-hosted orchestration platforms into "install Paperclip" with a footnote. Show them all, with comparison criteria.
- Do not invent tools or versions not present in the corpus.
- Do not re-litigate whether Claude Code is "better than" plain ReAct — the METR finding in Part Q.10 is the evidence; acknowledge it and move on.
- Do not add safety disclaimers or "consult a professional" language. I'm an adult.
- Do not skip Section 10 (self-review). The self-review is how I know you actually integrated your own principles.

---

### Output format

Return one markdown document. Headings should use `#`, `##`, `###`. Use fenced code blocks for every file, every command, every schema. Prefer tables for comparison data. ASCII diagrams for topology. Wrap the whole thing in a clear title at the top and an explicit "End of blueprint" marker at the bottom so I know you finished.

Begin.

---

## HOW TO USE THIS PROMPT

1. Edit the "About me" section above to match your profile.
2. Attach `RESEARCH_CORPUS.md` as a file to the AI session (Claude: drag-and-drop or `/file`; GPT/Gemini: attachment button). If the AI doesn't support file attachments, paste the corpus contents directly after the prompt.
3. Send.
4. If the output is shorter than 15,000 words or skips sections, send: "Continue. You truncated sections N–M. Produce them with the same quality bar."
5. If the output catalogues without connecting, send: "Section 5 (Integration/Wiring Recipes) is missing. Produce it now, with 10 concrete recipes showing exact arrows and packets."
6. If the output invents schemas, send: "You invented [key]. That key does not exist per corpus Part B. Rewrite the affected file using the verified schema."
7. Keep the corpus attached. Do not let the AI work from memory alone — it will hallucinate.

---

## CONFIDENCE NOTES FOR THE TARGET AI

If you are the AI reading this: the corpus is from April 11, 2026. It is internally consistent but not externally re-validated at your inference time. Treat it as authoritative over your training data for any claim about Claude Code, its ecosystem, or the specific projects/repos it names. If you must reconcile a contradiction between the corpus and your training data, the corpus wins and you note the discrepancy in a "caveats" footnote at the end of the relevant section.

Specific traps to avoid (from the corpus):
- `defaultModel` does not exist. Use `model`.
- `autoAccept` does not exist. Use `permissions.defaultMode: "acceptEdits"`.
- `mcpServers` is not a top-level key of `settings.json`. Project MCP lives in `.mcp.json`; user MCP in `~/.claude.json` under `projects[path].mcpServers`; plugin MCP in `plugin.json`.
- Spec-Kit install is `uv tool install specify-cli --from git+...@v0.5.1`, not pipx or npm.
- Spec-Kit commands are prefixed: `/speckit.constitution`, `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`.
- Claude Code 2.1.101 is the current release as of April 10, 2026.
- Opus 4.6 (Feb 5), Sonnet 4.6 (Feb 17), Haiku 4.5 (Oct 15 2025) are the April 2026 model lineup.
- `claw-code` is at `ultraworkers/claw-code` (transferred from `instructkr/claw-code`), with 181k stars and NO license.
- `goose` is at `aaif-goose/goose` (transferred from `block/goose`).
- Superpowers has ZERO PreToolUse/PostToolUse/Stop hooks — its discipline is prompt-level. Real enforcement must be layered on top via user-scope hooks.
- `container-use` has NO `.claude/container-use.yaml` file — use `cu config` subcommands.
- Fly Sprites has NO `--cpu` or `--disk` flags — 100GB/8CPU are platform defaults from `sprite create`.
- Langfuse v3 docker-compose requires MinIO; cannot be dropped.
- Vercel AI Gateway Max-path requires `ANTHROPIC_CUSTOM_HEADERS="x-ai-gateway-api-key: Bearer ..."`, NOT `ANTHROPIC_API_KEY` or `ANTHROPIC_AUTH_TOKEN` alone.
- The `gh api | jq` Code Review severity incantation is literally `--jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson'`.
- Anthropic's subscription plans prohibit scripted/automated use. CI must use API billing.
- Native binary installer is the post-axios-DPRK recommended install. Not `npm install -g`.

End of prompt.
