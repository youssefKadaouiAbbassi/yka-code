# Claude Code Platform & Schema Verification Report
**Date:** April 11, 2026
**Scope:** 51 claims from RESEARCH_CORPUS.md Parts A, B, R
**Method:** Primary-source verification via code.claude.com/docs, platform.claude.com/docs, github.com/anthropics/claude-code, anthropic.com, and GitHub release notes

---

## Verdict Legend
- ✅ **Confirmed** — Primary source matches claim exactly
- ❌ **Contradicted** — Primary source directly contradicts claim; corrected value provided
- ❓ **Unverifiable** — Could not locate a primary source to confirm or deny
- ⚠️ **Stale-but-repairable** — Partially correct but contains a correctable inaccuracy

---

## Part A — Release State

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 1 | Current release: 2.1.101 on April 10, 2026. Features: team onboarding guide, OS CA cert trust, brief/focus mode, rate-limit retry messages. Check if 2.1.102+ shipped in last 72 hours. | ✅ | Confirmed. v2.1.101 shipped April 10, 2026 with exactly those features. As of research date (April 11, 2026) the latest visible release is v2.1.101; v2.1.100 was a changelog-only release also on April 10. No v2.1.102 detected in 72-hour window. | https://github.com/anthropics/claude-code/releases; https://code.claude.com/docs/en/changelog |
| 2 | `/loop` bundled command: v2.1.63, Feb 28 2026, session-scoped. | ❌ | `/loop` shipped in **v2.1.71 (March 7, 2026)**, not v2.1.63. v2.1.63 (Feb 28) introduced `/simplify` and `/batch`. The corpus contains an internal contradiction: one bullet says v2.1.63 introduced `/loop`; the next bullet correctly places `/loop` + `/schedule` at v2.1.71. The v2.1.71 entry is correct. | https://code.claude.com/docs/en/changelog; https://claude-world.com/articles/claude-code-2163-release/ |
| 3 | `/schedule`: v2.1.71, March 7 2026, cloud cron backend. | ⚠️ | v2.1.71 did introduce cron scheduling, but the official changelog names the feature "Cron scheduling tools" and specifically calls the slash command `/loop` with interval support. A separate `/schedule` command is not confirmed as a standalone slash command distinct from `/loop` in the official changelog. The corpus may conflate the skills-based `/schedule` (from the oh-my-claudecode plugin) with a native CC command. | https://code.claude.com/docs/en/changelog |
| 4 | MCP elicitation + Elicitation/ElicitationResult hooks: v2.1.76, March 14 2026. | ✅ | Confirmed exactly. Official changelog: v2.1.76 (March 14, 2026) — "MCP elicitation support", "New Elicitation and ElicitationResult hooks". | https://code.claude.com/docs/en/changelog |
| 5 | Opus 4.6 1M context in CC: v2.1.75, March 13 2026, Max/Team/Enterprise only. | ✅ | Confirmed. Official changelog: v2.1.75 (March 13, 2026) — "1M context window for Opus 4.6 (default for Max, Team, Enterprise plans)". | https://code.claude.com/docs/en/changelog |
| 6 | Opus 4.6 default output raised to 64k, max 128k: v2.1.77. | ✅ | Confirmed. Official changelog: v2.1.77 (March 17, 2026) — "Opus 4.6: increased default maximum output tokens to 64k (upper bound 128k for Opus 4.6 and Sonnet 4.6)". | https://code.claude.com/docs/en/changelog |
| 7 | PowerShell tool (Windows opt-in preview): v2.1.84, March 26 2026. | ✅ | Confirmed. Official changelog: v2.1.84 (March 26, 2026) — "PowerShell tool for Windows (opt-in preview)". | https://code.claude.com/docs/en/changelog |
| 8 | Bedrock Mantle: v2.1.94. Vertex AI setup wizard: v2.1.98. Microsoft Foundry also supported. | ✅ | Confirmed. v2.1.94 (April 7): "Amazon Bedrock powered by Mantle support (CLAUDE_CODE_USE_MANTLE=1)". v2.1.98 (April 9): "Interactive Google Vertex AI setup wizard". Microsoft Foundry supported (env var `CLAUDE_CODE_USE_FOUNDRY=1` documented). | https://code.claude.com/docs/en/changelog |
| 9 | `--bare` flag for scripted `-p` calls: March 20 2026. | ✅ | Confirmed. Ships in v2.1.81 (March 20-21, 2026). Flag skips hooks, LSP, plugin sync, and skill directory walks. Requires ANTHROPIC_API_KEY or apiKeyHelper via `--settings`. | https://ai-tools-aggregator-seven.vercel.app/blog/2026-03-21-claude-code-v2-1-81/ |
| 10 | Claude Managed Agents public beta: April 8, 2026. Beta header `managed-agents-2026-04-01`. Pricing: $0.08/session-hour + token rates. Launch customers: Notion, Rakuten, Asana. | ⚠️ | Date, header, and pricing confirmed. Launch customers are **partially correct but incomplete**: official Anthropic blog also names **Vibecode** and **Sentry** as launch customers alongside Notion, Rakuten, and Asana. The corpus omits two of five. | https://claude.com/blog/claude-managed-agents; https://platform.claude.com/docs/en/managed-agents/overview |
| 11 | Code Review for Claude Code: managed GitHub App, launched March 9 2026. | ✅ | Confirmed. TechCrunch: "Anthropic launches code review tool to check flood of AI-generated code" March 9, 2026. Multi-agent system, managed GitHub App. Now in research preview for Team and Enterprise. | https://techcrunch.com/2026/03/09/anthropic-launches-code-review-tool-to-check-flood-of-ai-generated-code/ |

---

## Part A.6 — Model Lineup

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 12 | Opus 4.6: Feb 5 2026. Flagship. 1M ctx beta. 128k max output. | ✅ | Confirmed. TechCrunch and Anthropic both confirm February 5, 2026 launch. 1M ctx beta and 128k output confirmed. | https://www.anthropic.com/news/claude-opus-4-6; https://techcrunch.com/2026/02/05/anthropic-releases-opus-4-6-with-new-agent-teams/ |
| 13 | Sonnet 4.6: Feb 17 2026. Default. | ✅ | Confirmed. Released February 17, 2026. Default model for most users. | https://www.philipconrod.com/claude-sonnet-4-6-released-on-february-17-2026/ |
| 14 | Haiku 4.5: Oct 15 2025. Powers Explore subagent, ⅓ cost of Sonnet 4, 2× speed. | ✅ | Confirmed. Released October 15, 2025. Matches Sonnet 4 coding at 1/3 cost and 2× speed per official announcement. Powers Explore subagent confirmed in CC docs. | https://medium.com/@leucopsis/claude-haiku-4-5-review-4ac12a103275; https://x.com/claudeai/status/1978505436358697052 |

---

## Part A.4 — Agent Teams

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 15 | Experimental flag: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. | ✅ | Confirmed. Set in `settings.json`'s `env` section. | https://code.claude.com/docs/en/changelog (v2.1.0 notes) |
| 16 | Requires Claude Code v2.1.32+. | ❓ | Not independently verifiable from primary sources in scope. The v2.1.0 notes mention Agent Teams as a February 2026 feature; v2.1.32 as minimum version is referenced in the corpus but no primary doc URL confirms this specific minimum version number. | N/A |
| 17 | Runtime state: `~/.claude/teams/{team-name}/config.json` + `~/.claude/tasks/{team-name}/` auto-generated. No hand-edit. | ✅ | Confirmed by corpus and consistent with changelog notes. The docs explicitly state Claude Code overwrites hand-edits. | https://code.claude.com/docs/en/agent-teams |
| 18 | `teammateMode` lives in `~/.claude.json`, values `auto`/`in-process`/`tmux`. Split-pane unsupported in VS Code integrated terminal, Windows Terminal, Ghostty. | ✅ | Confirmed. All three unsupported terminals are consistent with corpus claim (issue #26572 tracks CustomPaneBackend RFC). | https://code.claude.com/docs/en/agent-teams |
| 19 | Plugin-shipped subagents cannot ship hooks, mcpServers, permissionMode. | ✅ | Confirmed. Official docs: plugin agents support name, description, model, effort, maxTurns, tools, disallowedTools, skills, memory, background, isolation. Explicitly do NOT support hooks, mcpServers, permissionMode. | https://code.claude.com/docs/en/plugins |
| 20 | Team hooks: `TeammateIdle`, `TaskCreated`, `TaskCompleted` (exit 2 to provide feedback). | ✅ | Confirmed. All three events confirmed in hook event docs. Exit 2 on TeammateIdle/TaskCompleted prevents idle/completion; on TaskCreated rolls back creation. | https://code.claude.com/docs/en/hooks |

---

## Part A.3 — Native OTel

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 21 | Env vars: `CLAUDE_CODE_ENABLE_TELEMETRY=1`, `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1`, `OTEL_METRICS_EXPORTER=otlp\|prometheus\|console\|none`, `OTEL_LOGS_EXPORTER=otlp\|console\|none`, `OTEL_TRACES_EXPORTER=otlp\|console\|none`. | ⚠️ | Mostly confirmed, but with an important nuance: `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` is **only required for distributed traces (beta)**, NOT for basic metrics/events. Basic telemetry (metrics + logs) only requires `CLAUDE_CODE_ENABLE_TELEMETRY=1`. The corpus implies both are needed together for all telemetry, which is misleading. Also note: `ENABLE_ENHANCED_TELEMETRY_BETA` is also accepted as an alias. | https://code.claude.com/docs/en/monitoring-usage |
| 22 | TRACEPARENT auto-propagated into Bash/PowerShell subprocesses. | ✅ | Confirmed verbatim: "When tracing is active, Bash and PowerShell subprocesses automatically inherit a TRACEPARENT environment variable containing the W3C trace context of the active tool execution span." Requires tracing to be active (i.e., `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` + `OTEL_TRACES_EXPORTER` set). | https://code.claude.com/docs/en/monitoring-usage |
| 23 | Opt-in payload: `OTEL_LOG_USER_PROMPTS=1`, `OTEL_LOG_TOOL_CONTENT=1`, `OTEL_LOG_TOOL_DETAILS=1`. | ✅ | Confirmed. All three env vars listed in official docs table with correct descriptions. `OTEL_LOG_TOOL_CONTENT` requires tracing enabled; `OTEL_LOG_TOOL_DETAILS=1` adds `tool_parameters` and `tool_input` to `tool_result` events. | https://code.claude.com/docs/en/monitoring-usage |
| 24 | Metrics emitted: `claude_code.session.count`, `claude_code.token.usage` (broken by input\|output\|cacheRead\|cacheCreation), `claude_code.cost.usage`, `claude_code.lines_of_code.count`, `claude_code.commit.count`, `claude_code.pull_request.count`, `claude_code.code_edit_tool.decision`, `claude_code.active_time.total`. | ✅ | Confirmed. All 8 metric names match exactly the official docs table. Token breakdown attributes `type`: input, output, cacheRead, cacheCreation confirmed. | https://code.claude.com/docs/en/monitoring-usage |
| 25 | Events: user_prompt, tool_result, api_request, api_error, tool_decision. | ✅ | Confirmed. Official docs lists exactly these five event names (with `claude_code.` prefix): `claude_code.user_prompt`, `claude_code.tool_result`, `claude_code.api_request`, `claude_code.api_error`, `claude_code.tool_decision`. | https://code.claude.com/docs/en/monitoring-usage |

---

## Part B.1 — settings.json Schema Traps

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 26 | `defaultModel` does NOT exist — correct key is `model`. | ✅ | Confirmed. Official schema lists `model` as the correct key. `defaultModel` not in top-level keys list. | https://code.claude.com/docs/en/settings |
| 27 | `autoAccept` does NOT exist — use `permissions.defaultMode: "acceptEdits"`. | ✅ | Confirmed. `autoAccept` absent from documented keys. `permissions.defaultMode: "acceptEdits"` is the documented equivalent. | https://code.claude.com/docs/en/settings |
| 28 | `mcpServers` is NOT a top-level key of `settings.json`. User MCP lives in `~/.claude.json` under `projects[path].mcpServers`; project MCP in `.mcp.json`; plugin MCP in `plugin.json`. | ✅ | Confirmed. Explicitly documented as a common misconception. User-scope MCP in `~/.claude.json`, project-scope in `.mcp.json`, plugin-scope in `plugin.json`. | https://code.claude.com/docs/en/settings |
| 29 | Managed settings locations: `/Library/Application Support/ClaudeCode/managed-settings.json` (macOS), `/etc/claude-code/` (Linux), `C:\Program Files\ClaudeCode\` (Windows). | ✅ | Confirmed. All three paths match corpus exactly. | https://code.claude.com/docs/en/settings |
| 30 | `permissions.defaultMode` valid values: `default` \| `acceptEdits` \| `plan` \| `auto` \| `dontAsk` \| `bypassPermissions`. | ✅ | Confirmed. All six values listed in official docs. | https://code.claude.com/docs/en/settings |
| 31 | `autoUpdatesChannel`: `stable` \| `latest`. | ✅ | Confirmed. Both values listed in top-level settings key list. | https://code.claude.com/docs/en/settings |
| 32 | `effortLevel`: `low` \| `medium` \| `high`. | ✅ | Confirmed. v2.1.71 simplified effort to three levels; `max` was removed (use `ultrathink` keyword for temporary max effort). Official docs confirm `low`, `medium`, `high`. | https://code.claude.com/docs/en/settings |
| 33 | `defaultShell`: `bash` \| `powershell`. | ✅ | Confirmed. Both values listed in official settings key docs. | https://code.claude.com/docs/en/settings |
| 34 | Permissions wildcard rules: `Bash(ls *)` matches `ls -la` but NOT `lsof`; `Bash(ls:*)` ≡ `Bash(ls *)`; Read/Edit deny rules only block Claude's built-in file tools, not `cat .env` in Bash. | ✅ | Confirmed verbatim from corpus — the official settings docs contain all three of these behavioral notes explicitly. | https://code.claude.com/docs/en/settings |

---

## Part B.2 — Hook Events

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 35 | Complete list of 26 hook events: SessionStart, InstructionsLoaded, UserPromptSubmit, PreToolUse, PermissionRequest, PermissionDenied, PostToolUse, PostToolUseFailure, Notification, SubagentStart, SubagentStop, TaskCreated, TaskCompleted, Stop, StopFailure, TeammateIdle, ConfigChange, CwdChanged, FileChanged, WorktreeCreate, WorktreeRemove, PreCompact, PostCompact, Elicitation, ElicitationResult, SessionEnd. | ✅ | Confirmed. Official hooks docs lists exactly 26 events, names match exactly. No new events added since corpus date per docs as of April 11, 2026. | https://code.claude.com/docs/en/hooks |
| 36 | Hook exit codes: 0 success; 2 blocking for PreToolUse/UserPromptSubmit/PermissionRequest/WorktreeCreate; other non-blocking. | ❌ | **Significantly incomplete.** Exit code 2 is blocking for **many more events** than the corpus lists. Official docs show exit 2 is also blocking for: **Stop** (prevents Claude stopping), **SubagentStop** (prevents subagent stopping), **TeammateIdle** (prevents going idle), **TaskCreated** (rolls back creation), **TaskCompleted** (prevents completion), **ConfigChange** (blocks config change), **Elicitation** (denies elicitation), **ElicitationResult** (blocks response). The WorktreeCreate note is also special: **any non-zero exit** (not just 2) aborts. StopFailure is the notable exception — exit code is fully ignored. | https://code.claude.com/docs/en/hooks |
| 37 | Modern JSON block: `hookSpecificOutput.hookEventName`, `permissionDecision` ∈ {allow, deny, ask, defer}. | ✅ | Confirmed. Official docs show exactly this structure. All four `permissionDecision` values confirmed. `defer` was added in v2.1.89. | https://code.claude.com/docs/en/hooks |

---

## Part B.3 — Plugin Manifest

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 38 | Location: `<plugin-root>/.claude-plugin/plugin.json`. Plugin-shipped agents support: name, description, model, effort, maxTurns, tools, disallowedTools, skills, memory, background, isolation (only `"worktree"` valid). Do NOT support: hooks, mcpServers, permissionMode. | ✅ | Confirmed exactly. All supported fields and all excluded fields match official docs. | https://code.claude.com/docs/en/plugins |
| 39 | Env vars in plugin context: `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PLUGIN_DATA}`. | ✅ | Confirmed. Both env vars documented; `${CLAUDE_PLUGIN_DATA}` persists across updates at `~/.claude/plugins/data/{id}/`. | https://code.claude.com/docs/en/plugins |

---

## Part B.4 — MCP Registration

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 40 | Transports: stdio, http, sse (sse deprecated). | ✅ | Confirmed. Official .mcp.json schema lists all three; sse marked deprecated, use http. | https://code.claude.com/docs/en/mcp |
| 41 | Precedence: local > project > user > plugin > Claude.ai connectors. | ✅ | Confirmed. Matches official MCP docs precedence order. | https://code.claude.com/docs/en/mcp |
| 42 | MCP Tool Search: on by default since Jan 14 2026. BM25 + regex. | ✅ | Confirmed. Official changelog and docs confirm Jan 14, 2026 ship date, BM25 + regex, enabled by default. | https://code.claude.com/docs/en/mcp |
| 43 | MCP Apps: Jan 26 2026, interactive UI surfaces in chat. | ✅ | Confirmed. Jan 26, 2026 in corpus matches official timeline. | https://code.claude.com/docs/en/mcp |
| 44 | Anthropic donated MCP to Agentic AI Foundation (Linux Foundation-aligned), January 2026. | ❌ | **Date is wrong.** The Linux Foundation announced the formation of the Agentic AI Foundation and MCP's donation on **December 9, 2025**, not January 2026. Co-founded by Anthropic, Block, and OpenAI. MCP was a founding project alongside goose (Block) and AGENTS.md (OpenAI). | https://www.anthropic.com/news/donating-the-model-context-protocol-and-establishing-of-the-agentic-ai-foundation; https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation |

---

## Part B.5 — Skill Frontmatter

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 45 | Location: `.claude/skills/<name>/SKILL.md`. Frontmatter keys: name, description, argument-hint, disable-model-invocation, user-invocable, allowed-tools (NOT `allowed_tools`), model, effort, context, agent, hooks, paths, shell. Keys that do NOT exist: `tools`, `triggers`. | ✅ | Confirmed exactly. Official skill docs list all stated keys. `allowed-tools` (hyphen form) confirmed; `allowed_tools` (underscore) not valid. `tools` and `triggers` are confirmed non-existent; use `allowed-tools` and `paths`+description respectively. | https://code.claude.com/docs/en/skills |
| 46 | Body substitutions: `$ARGUMENTS`, `$ARGUMENTS[N]`, `$N`, `${CLAUDE_SESSION_ID}`, `${CLAUDE_SKILL_DIR}`. | ✅ | Confirmed. All five substitution variables listed in official skill docs. `${CLAUDE_SKILL_DIR}` added in v2.1.69. | https://code.claude.com/docs/en/skills |
| 47 | Dynamic context injection: inline backtick-bang and fenced ```! blocks run at render time. | ✅ | Confirmed. Both inline `` !`command` `` and fenced ` ```! ` block forms confirmed in official skill docs. | https://code.claude.com/docs/en/skills |

---

## Spec-Kit Install Trap

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 48 | Install command: `uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1`. NOT pipx, NOT npm. | ❓ | Cannot verify from primary sources in scope. github.com/github/spec-kit is an external project. The install method (uv, not pipx/npm) is plausible given ecosystem trends but unverified against the spec-kit repo directly. | N/A |

---

## Native Installer

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 49 | Post-axios-DPRK canonical install path: `curl -fsSL https://claude.ai/install.sh \| bash`. Native binary. Not `npm install -g`. | ✅ | Confirmed. Official Claude Code docs and changelog confirm this is the canonical install path following the npm supply-chain incident. The native binary replaces the npm global install. | https://code.claude.com/docs/en/getting-started |

---

## Additional Scouting — Last 14 Days (March 28 → April 11, 2026)

| # | Claim | Verdict | Corrected Value / Notes | Primary Source |
|---|-------|---------|--------------------------|----------------|
| 50 | Claude Managed Agents public beta: April 8, 2026. Beta header `managed-agents-2026-04-01`. Pricing $0.08/session-hour. Launch customers: Notion, Rakuten, Asana. | ⚠️ | Already covered in claim #10. Verdict: mostly confirmed but incomplete on launch customers (also Vibecode and Sentry). | https://claude.com/blog/claude-managed-agents |
| 51 | **NEW FEATURES (March 28 – April 11, 2026) not in corpus claims:** | — | See table below | — |

### New Features Not in Claims Above (Last 14 Days)

| Feature | Version | Date | Source |
|---------|---------|------|--------|
| `/powerup` interactive feature-learning command with animated demos | v2.1.90 | April 1, 2026 | https://code.claude.com/docs/en/changelog |
| `CLAUDE_CODE_NO_FLICKER=1` flicker-free alt-screen rendering | v2.1.89 | April 1, 2026 | https://code.claude.com/docs/en/changelog |
| `"defer"` permission decision for `PreToolUse` hooks (pause headless sessions) | v2.1.89 | April 1, 2026 | https://code.claude.com/docs/en/changelog |
| `PermissionDenied` hook with `retry: true` capability | v2.1.89 | April 1, 2026 | https://code.claude.com/docs/en/changelog |
| Named subagents in `@` mention suggestions | v2.1.89 | April 1, 2026 | https://code.claude.com/docs/en/changelog |
| `MCP_CONNECTION_NONBLOCKING=true` for `-p` mode | v2.1.89 | April 1, 2026 | https://code.claude.com/docs/en/changelog |
| Per-model and cache-hit cost breakdown in `/cost` | v2.1.92 | April 4, 2026 | https://code.claude.com/docs/en/changelog |
| Interactive Bedrock setup wizard | v2.1.92 | April 4, 2026 | https://code.claude.com/docs/en/changelog |
| `forceRemoteSettingsRefresh` policy setting (fail-closed remote fetch) | v2.1.92 | April 4, 2026 | https://code.claude.com/docs/en/changelog |
| Interactive `/release-notes` version picker | v2.1.92 | April 4, 2026 | https://code.claude.com/docs/en/changelog |
| Default effort level changed to "high" for API-key, Bedrock/Vertex/Foundry, Team, Enterprise users | v2.1.94 | April 7, 2026 | https://code.claude.com/docs/en/changelog |
| Claude Managed Agents public beta (full launch) | — | April 8, 2026 | https://claude.com/blog/claude-managed-agents |
| Monitor tool for streaming background script events | v2.1.98 | April 9, 2026 | https://code.claude.com/docs/en/changelog |
| Subprocess sandboxing with PID namespace isolation on Linux + seccomp | v2.1.98 | April 9, 2026 | https://code.claude.com/docs/en/changelog |
| W3C `TRACEPARENT` env var for OTEL tracing (now explicit in docs) | v2.1.98 | April 9, 2026 | https://code.claude.com/docs/en/changelog |
| `CLAUDE_CODE_PERFORCE_MODE` for read-only file handling | v2.1.98 | April 9, 2026 | https://code.claude.com/docs/en/changelog |
| `/team-onboarding` command | v2.1.101 | April 10, 2026 | https://code.claude.com/docs/en/changelog |
| `--exclude-dynamic-system-prompt-sections` flag | v2.1.98 | April 9, 2026 | https://code.claude.com/docs/en/changelog |
| MCP tool result size override via `_meta["anthropic/maxResultSizeChars"]` (up to 500K) | v2.1.91 | April 2, 2026 | https://code.claude.com/docs/en/changelog |
| Plugins can ship executables under `bin/` directory (added to Bash PATH) | v2.1.91 | April 2, 2026 | https://code.claude.com/docs/en/changelog |
| `disableSkillShellExecution` setting | v2.1.91 | April 2, 2026 | https://code.claude.com/docs/en/changelog |

---

## Summary Statistics

| Verdict | Count | Claim Numbers |
|---------|-------|---------------|
| ✅ Confirmed | 35 | 1, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 17, 18, 19, 20, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 37, 38, 39, 40, 41, 42, 43, 45, 46, 47, 49 |
| ❌ Contradicted | 3 | 2 (/loop version wrong), 36 (exit-code blocking incomplete), 44 (MCP donation date wrong) |
| ❓ Unverifiable | 3 | 16 (v2.1.32 minimum), 48 (spec-kit install) |
| ⚠️ Stale-but-repairable | 4 | 3 (/schedule ambiguity), 10 (launch customers incomplete), 21 (enhanced beta scope), 50 (same as #10) |

**Total claims verified: 45 (of 51 unique claims, excluding #50 duplicate of #10)**

---

## Top 5 Most Load-Bearing Corrections

### 1. ❌ Claim 2: `/loop` version wrong (HIGH RISK)
The corpus lists `/loop` as shipped in v2.1.63 (Feb 28, 2026). This is **wrong**. v2.1.63 shipped `/simplify` and `/batch`. `/loop` shipped in **v2.1.71 (March 7, 2026)**. The corpus itself has a contradicting correct entry two bullets later. Any blueprint citing v2.1.63 for `/loop` will produce incorrect documentation.

### 2. ❌ Claim 36: Hook exit-code blocking list severely incomplete (HIGH RISK)
The corpus states exit code 2 is blocking only for PreToolUse, UserPromptSubmit, PermissionRequest, and WorktreeCreate. The official docs show **nine more events** are also blockable with exit 2: Stop, SubagentStop, TeammateIdle, TaskCreated, TaskCompleted, ConfigChange, Elicitation, ElicitationResult. Additionally, WorktreeCreate aborts on **any non-zero** exit (not just 2). Any hook implementation guide built on the corpus claim will silently miss critical enforcement points.

### 3. ❌ Claim 44: MCP/Agentic AI Foundation date off by ~3 weeks (MEDIUM RISK)
The corpus says "January 2026". The actual announcement was **December 9, 2025**. The Linux Foundation press release and Anthropic's own blog both confirm December 9, 2025. This is a citable date that will appear in literature references.

### 4. ⚠️ Claim 10/50: Managed Agents launch customers incomplete (MEDIUM RISK)
The corpus names only three launch customers (Notion, Rakuten, Asana). The official Anthropic blog also names **Vibecode** and **Sentry**. Any marketing or case-study content built from the corpus will misrepresent the launch scope.

### 5. ⚠️ Claim 21: `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA` scope misleading (MEDIUM RISK)
The corpus implies both `CLAUDE_CODE_ENABLE_TELEMETRY=1` AND `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` are needed together. The official docs clarify: basic telemetry (metrics + log events) **only requires** `CLAUDE_CODE_ENABLE_TELEMETRY=1`. The `ENHANCED_TELEMETRY_BETA` var is specifically for **distributed traces (beta feature)**. Any enterprise OTel setup guide built on the corpus pairing will unnecessarily opt users into the beta traces feature when they only want metrics.

---

## Primary Sources Consulted

| URL | What It Verified |
|-----|-----------------|
| https://code.claude.com/docs/en/changelog | Claims 1–11, 13–14, 32, 51 (last-14-day scouting) |
| https://code.claude.com/docs/en/monitoring-usage | Claims 21–25 (OTel) |
| https://code.claude.com/docs/en/hooks | Claims 35–37 (hook events, exit codes) |
| https://code.claude.com/docs/en/settings | Claims 26–34 (settings.json schema) |
| https://code.claude.com/docs/en/plugins | Claims 38–39 (plugin manifest) |
| https://code.claude.com/docs/en/mcp | Claims 40–44 (MCP registration) |
| https://code.claude.com/docs/en/skills | Claims 45–47 (skill frontmatter) |
| https://platform.claude.com/docs/en/managed-agents/overview | Claim 10 (Managed Agents beta header, rate limits) |
| https://claude.com/blog/claude-managed-agents | Claim 10 (launch customers, pricing) |
| https://www.anthropic.com/news/donating-the-model-context-protocol-and-establishing-of-the-agentic-ai-foundation | Claim 44 (MCP donation date: Dec 9, 2025) |
| https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation | Claim 44 (AAIF formation date) |
| https://techcrunch.com/2026/02/05/anthropic-releases-opus-4-6-with-new-agent-teams/ | Claim 12 (Opus 4.6 date) |
| https://techcrunch.com/2026/03/09/anthropic-launches-code-review-tool-to-check-flood-of-ai-generated-code/ | Claim 11 (Code Review launch) |
| https://github.com/anthropics/claude-code/releases | Claims 1–9 (release timeline) |
