# Deep Research: Anthropic-Native Primitives Inventory + Practitioner Dotfiles
*Compiled April 12 2026. Sources: platform.claude.com/docs, code.claude.com/docs (all 110 pages), Anthropic engineering blog, GitHub repos, practitioner blogs and dotfiles. 30+ web fetches.*

---

## PART A — EXHAUSTIVE ANTHROPIC-NATIVE INVENTORY

### A1. Complete Tool Surface (platform.claude.com/docs/en/agents-and-tools/tool-use/tool-reference)

**Server Tools (Anthropic executes):**

| Tool | Type String(s) | Status |
|------|---------------|--------|
| Web Search | `web_search_20260209`, `web_search_20250305` | GA |
| Web Fetch | `web_fetch_20260209`, `web_fetch_20250910` | GA |
| Code Execution | `code_execution_20260120`, `code_execution_20250825` | GA |
| **Advisor Tool** | `advisor_20260301` | Beta: `advisor-tool-2026-03-01` |
| Tool Search | `tool_search_tool_regex_20251119`, `tool_search_tool_bm25_20251119` | GA |
| MCP Connector | `mcp_toolset` | Beta: `mcp-client-2025-11-20` |

**Client Tools (caller executes, Anthropic defines schema):**

| Tool | Type String(s) | Status |
|------|---------------|--------|
| Memory Tool | `memory_20250818` | GA |
| Bash Tool | `bash_20250124` | GA |
| Text Editor | `text_editor_20250728` (Claude 4), `text_editor_20250124` (older) | GA |
| Computer Use | `computer_20251124`, `computer_20250124` | Beta: `computer-use-2025-11-24` |

**Tool Definition Properties (apply to all tools):**
- `cache_control` — prompt-cache breakpoint
- `strict` — schema conformance guarantee
- `defer_loading` — exclude from initial system prompt; load on demand via tool search
- `allowed_callers` — restrict callers to `"direct"` or `"code_execution_20260120"`
- `input_examples` — example inputs (user-defined tools only)
- `eager_input_streaming` — fine-grained input streaming (user-defined tools only)

**Programmatic Tool Calling (new in 2026):** Code running inside `code_execution_20260120` sandbox can call tools via `allowed_callers: ["code_execution_20260120"]`. Response includes `caller` field.

---

### A2. Current Claude Model Lineup (as of April 2026)

**Current/Flagship:**
- `claude-opus-4-6` — most intelligent, 1M context, 128k output, $5/$25 MTok
- `claude-sonnet-4-6` — best speed/intelligence balance, 1M context, 64k output, $3/$15 MTok
- `claude-haiku-4-5-20251001` — fastest, 200k context, 64k output, $1/$5 MTok

**Legacy (still available):**
- `claude-sonnet-4-5`, `claude-opus-4-5`, `claude-opus-4-1`, `claude-sonnet-4`, `claude-opus-4`

**Special / Restricted:**
- **Claude Mythos Preview** (`claude-mythos-preview` via Project Glasswing) — invitation-only, defensive cybersecurity workflows only. Identified thousands of zero-day vulnerabilities in every major OS and browser. Partners include AWS, Apple, Broadcom, Cisco, CrowdStrike, Google, JPMorganChase, Microsoft, Nvidia. Not available for general sign-up. Source: [anthropic.com/glasswing](https://www.anthropic.com/glasswing)

**Extended Output Beta:** `output-300k-2026-03-24` header enables 300k output tokens for Opus 4.6 and Sonnet 4.6 on Batch API.

**Adaptive Thinking:** Replaces manual `budget_tokens`. Use `thinking: {type: "adaptive"}` + `effort: 1-5`. Supported on Opus 4.6, Sonnet 4.6, Haiku 4.5. Manual mode deprecated on 4.6 models.

---

### A3. Advisor Tool — Full Spec (NEW, Beta as of April 9 2026)

**Beta header:** `advisor-tool-2026-03-01`
**Type:** `advisor_20260301`, name must be `"advisor"`
**How it works:** executor (Haiku/Sonnet/Opus) calls `advisor` tool → Anthropic runs separate inference pass with Opus 4.6 as advisor → advisor result returned inline in same `/v1/messages` call. No extra round trips.
**Valid pairs:** Haiku 4.5 + Opus 4.6, Sonnet 4.6 + Opus 4.6, Opus 4.6 + Opus 4.6
**Performance:** Haiku+Opus = 41.2% SWE-bench Multilingual vs 19.7% Haiku solo at 85% lower cost
**Key parameters:**
- `max_uses` — per-request cap on advisor calls
- `caching: {type: "ephemeral", ttl: "5m"|"1h"}` — advisor-side prompt caching (enable at 3+ calls/conversation)
**Result variants:** `advisor_result` (text) or `advisor_redacted_result` (encrypted_content)
**Streaming:** advisor sub-inference does NOT stream; stream pauses then `advisor_tool_result` arrives fully formed
**Usage:** reported in `usage.iterations[]` array; advisor tokens NOT in top-level `usage` totals
**Platform:** Anthropic API only (not Bedrock, Vertex, Foundry)
**Source:** [platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool)

---

### A4. `ant` CLI — Full Spec (NEW, April 8 2026)

**Repo:** `github.com/anthropics/anthropic-cli` (Go, MIT, v1.1.0, 276 stars)
**Install:** `brew install anthropics/tap/ant` or `go install github.com/anthropics/anthropic-cli/cmd/ant@latest`
**Primary use:** `ant messages create` — send messages to Claude with YAML/JSON input, multiple output formats
**Formats:** `auto`, `explore`, `json`, `jsonl`, `pretty`, `raw`, `yaml`
**Transform:** GJSON syntax for output transformation (`--transform`)
**File handling:** `@file` notation, `@file://` for string, `@data://` for base64
**Beta:** `ant beta:messages create --beta advisor-tool-2026-03-01`
**Use with Claude Code:** replaces many `curl` calls in CI/GitOps; the docs show `ant messages create` as the CLI equivalent of Python/TypeScript SDK calls throughout platform docs

**v4 blueprint coverage:** v4 correctly identifies `ant` as first-party GitOps. However the v4 description of `ant` as handling "agents, skills, beta headers, Managed Agent definitions versioned as YAML" overstates current documented scope — the public repo only documents `messages create` as a command. The agent/skill YAML management may be planned or in private beta. Current documented commands: `messages create`, `beta:messages create`.

---

### A5. Claude Code CLI — Complete Feature Inventory

**Source:** code.claude.com/docs (110 pages, llms.txt index)

#### A5.1 Commands (slash commands) — complete list

| Command | Version | Purpose |
|---------|---------|---------|
| `/powerup` | v2.1.90 | Interactive lessons with animated demos |
| `/buddy` | v2.1.89 | April 1st joke — hatch a creature that watches you code |
| `/team-onboarding` | v2.1.101 | Generate teammate ramp-up guide |
| `/ultraplan` | v2.1.91 | Cloud planning session (research preview) |
| `/fast` | v2.1.36 | Toggle fast mode (Opus 4.6, 2.5× faster, $30/$150 MTok) |
| `/effort` | v2.1.77 | Set effort level (low/medium/high) |
| `/loop` | v2.1.71 | Recurring prompt on interval |
| `/schedule` | — | Create cloud/desktop scheduled tasks |
| `/remote-control` / `/rc` | v2.1.79 | Bridge session to claude.ai/code |
| `/teleport` | — | Transfer web/iOS session to terminal (`claude --teleport`) |
| `/desktop` | — | Hand terminal session to Desktop app |
| `/mobile` | — | Show QR code for Claude mobile app download |
| `/copy N` | v2.1.77 | Copy Nth-latest response |
| `/btw` | v2.1.81 | Ask side question during response |
| `/branch` / `/fork` | v2.1.77 | Fork conversation |
| `/color` | v2.1.75 | Set prompt-bar color |
| `/mcp` | v2.1.84 | MCP server management dialog |
| `/plugin install/uninstall/update` | v2.1.71 | Plugin management |
| `/reload-plugins` | v2.1.69 | Activate plugin changes |
| `/release-notes` | v2.1.92 | Interactive version picker |
| `/env` | v2.1.89 | Set env vars for Bash |
| `/stats` | v2.1.89 | Session statistics |
| `/cost` | v2.1.92 | Cost breakdown (per-model, cache-hit) |
| `/context` | v2.1.74 | Context usage + optimization tips |
| `/compact` | v2.1.91 | Compact conversation context |
| `/status` | v2.1.83 | Session status (works while Claude responds) |
| `/heapdump` | v2.1.73 | Memory profiling |
| `/feedback` | v2.1.91 | Submit documentation feedback |
| `/permissions` | v2.1.72 | View/manage permissions |
| `/plan` | v2.1.72 | Enter plan mode |
| `/hooks` | — | Browse configured hooks (read-only) |
| `/tasks` | — | Task list view (for ultraplan / agent teams) |
| `/agents` | — | Browse available agents |
| All bundled skills | — | `/simplify`, `/batch`, `/debug`, `/loop`, `/claude-api` |

#### A5.2 CLI Flags — complete list

| Flag | Version | Description |
|------|---------|-------------|
| `--bare` | v2.1.81 | Scripted `-p`; skips hooks, LSP, plugin sync; requires API key |
| `--exclude-dynamic-system-prompt-sections` | v2.1.98 | For improved cross-user prompt caching |
| `--channels` | v2.1.81 | Enable channels (Telegram/Discord/iMessage) |
| `--worktree` | v2.1.76 | Create/use git worktree session |
| `--add-dir` | v2.1.90 | Grant access to additional directory |
| `--agent` | v2.1.69 | Use specific agent |
| `--name` / `-n` | v2.1.76 | Set session display name |
| `--resume` | v2.1.85 | Resume previous session |
| `--continue` | v2.1.85 | Continue from deferred tool |
| `--remote-control` / `--rc` | v2.1.51 | Start with Remote Control enabled |
| `--spawn` | — | Remote Control spawn mode (same-dir/worktree/session) |
| `--capacity` | — | Max concurrent Remote Control sessions |
| `--plugin-dir` | v2.1.76 | Load plugin from directory (dev/test) |
| `--effort` | v2.1.72 | Set effort level |
| `--model` | v2.1.70 | Set model |
| `--print` / `-p` | — | Non-interactive/headless mode |
| `--dangerously-skip-permissions` | v2.1.97 | Skip all permission prompts |
| `--setting-sources` | v2.1.90 | Specify settings sources |
| `--console` | v2.1.79 | Anthropic Console auth |
| `--verbose` | v2.1.71 | Verbose output |
| `--debug` | v2.1.89 | Debug logging |
| `--teammate-mode` | — | Force in-process or tmux for agent teams |
| `--teleport` | — | Receive session transferred from web/iOS |
| `--json-schema` | v2.1.84 | JSON schema output |
| `--version` | — | Check version |

#### A5.3 Environment Variables — complete list (new items highlighted)

| Variable | Version | Purpose |
|----------|---------|---------|
| `CLAUDE_CODE_NO_FLICKER` | v2.1.89 | Opt into flicker-free alt-screen rendering |
| `CLAUDE_CODE_PERFORCE_MODE` | v2.1.98 | Edit/Write/NotebookEdit fail on read-only files with `p4 edit` hint |
| `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` | v2.1.98 | Strip cloud credentials from subprocess env; enables PID namespace isolation |
| `CLAUDE_CODE_SCRIPT_CAPS` | v2.1.98 | Limit per-session script invocations |
| `CLAUDE_CODE_USE_MANTLE` | v2.1.94 | Enable Amazon Bedrock Mantle (`=1`) |
| `CLAUDE_CODE_USE_FOUNDRY` | — | Enable Microsoft Azure Foundry |
| `CLAUDE_CODE_MAX_CONTEXT_TOKENS` | v2.1.98 | Maximum context tokens |
| `DISABLE_COMPACT` | v2.1.98 | Disable context compaction |
| `CLAUDE_CODE_DISABLE_MOUSE` | — | Disable mouse capture in fullscreen mode |
| `CLAUDE_CODE_SCROLL_SPEED` | — | Multiply mouse wheel scroll distance (1-20) |
| `CLAUDE_CODE_DISABLE_FAST_MODE` | — | Disable fast mode org-wide |
| `CLAUDE_CODE_USE_POWERSHELL_TOOL` | v2.1.84 | Enable PowerShell tool (Windows, preview) |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | — | Enable experimental agent teams |
| `ANTHROPIC_FOUNDRY_API_KEY` | — | Azure Foundry API key |
| `ANTHROPIC_FOUNDRY_RESOURCE` | — | Azure resource name |
| `ANTHROPIC_FOUNDRY_BASE_URL` | — | Azure Foundry base URL |
| `CLAUDE_CODE_CERT_STORE` | v2.1.101 | `bundled` to use only bundled CAs |
| `MCP_CONNECTION_NONBLOCKING` | v2.1.89 | Skip MCP wait in `-p` mode |
| `OTEL_LOG_USER_PROMPTS` | v2.1.101 | Log user prompts in OTEL |
| `OTEL_LOG_TOOL_DETAILS` | v2.1.101 | Log tool details in OTEL |
| `OTEL_LOG_TOOL_CONTENT` | v2.1.101 | Log tool content in OTEL |
| `TRACEPARENT` | v2.1.98 | W3C trace parent (set by Claude for Bash subprocesses) |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | — | Load CLAUDE.md from `--add-dir` paths (`=1`) |
| `SLASH_COMMAND_TOOL_CHAR_BUDGET` | — | Override skill description character budget |
| `ANTHROPIC_AUTH_TOKEN` | — | API auth token (sent as Authorization + X-Api-Key) |
| `ANTHROPIC_BETAS` | v2.1.78 | Beta features to enable |
| `DISABLE_AUTOUPDATER` | v2.1.98 | Suppress auto-updater |
| `CLAUDE_STREAM_IDLE_TIMEOUT_MS` | v2.1.84 | Streaming idle watchdog (default 90s) |

#### A5.4 Settings Keys — complete list (new items highlighted)

**Permission modes:** `defaultMode: "acceptEdits" | "plan" | "auto"` — Auto mode (v2.1.83) hands permission prompts to classifier

**Hooks — complete event list:**
- Session: `SessionStart`, `SessionEnd`, `InstructionsLoaded`
- Turn: `UserPromptSubmit`, `Stop`, `StopFailure`, `SubagentStart`, `SubagentStop`
- Tool: `PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `PermissionRequest`, `PermissionDenied`
- Team/Task: `TaskCreated`, `TaskCompleted`, `TeammateIdle`
- File/Env: `FileChanged`, `CwdChanged`, `ConfigChange`, `WorktreeCreate`, `WorktreeRemove`
- Context: `PreCompact`, `PostCompact`, `Elicitation`, `ElicitationResult`, `Notification`

**Hook fields:** `type` (command/http/prompt/agent), `if` (conditional, permission rule syntax, v2.1.85), `async` (background), `timeout`, `statusMessage`, `once`

**permissionDecision values:** `allow` | `deny` | `ask` | `defer` (v2.1.89 — pause headless session, resume with `--resume`)

**Key settings:**
- `showThinkingSummaries: false` (default in interactive sessions, v2.1.90)
- `disableSkillShellExecution: true` — block inline shell from skills
- `fastModePerSessionOptIn: true` — reset fast mode each session
- `allowManagedHooksOnly: true` — only allow managed hooks (v2.1.101)
- `sandbox.filesystem.*` — allowRead/allowWrite/denyRead/denyWrite
- `sandbox.network.allowMachLookup` — allow Mach lookup on macOS
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` env or settings — enable teams
- `forceRemoteSettingsRefresh` — block startup until remote settings fetched
- `cleanupPeriodDays` — days to keep transcript history
- `worktree.sparsePaths` — sparse-checkout paths for worktrees
- `modelOverrides` — map model picker entries to custom provider IDs
- `managed-settings.d/` directory (v2.1.83) — drop-in policy fragments

#### A5.5 Keybindings (keybindings.json)

| Binding | Action |
|---------|--------|
| `Ctrl+O` | Focus View toggle (fullscreen mode) — Ctrl+O once = transcript, twice = focus view (prompt + tool summary + response) |
| `Ctrl+X Ctrl+E` | Open external editor (readline) |
| `Ctrl+X Ctrl+K` | Stop all background agents |
| `Ctrl+B` | Background current task |
| `Shift+Down` | Cycle through agent team teammates |
| `Ctrl+S` | Screenshot stats (16× faster) |
| `/` (transcript mode) | Open search |
| `n` / `N` | Next/previous search match |
| `[` (transcript mode) | Write conversation to native scrollback |
| `v` (transcript mode) | Open conversation in $EDITOR |

---

### A6. Features NOT in v4 Blueprint (or under-documented)

#### A6.1 Features confirmed in docs but absent/thin in v4

1. **`/powerup` command** — interactive in-product lessons with animated demos (v2.1.90). v4 does not mention this at all.

2. **`/fast` command + Fast Mode** — Opus 4.6 at 2.5× speed, $30/$150 MTok, separate rate limits with auto-fallback. v4 mentions it tangentially but not as a production pattern.

3. **`/ultraplan` command** — cloud planning with web review, inline comments, emoji reactions on plan sections, execute on web OR teleport back to terminal. v4 does not cover this.

4. **Channels** (v2.1.80+) — Telegram, Discord, iMessage, custom webhook channels that PUSH events INTO a running session. Three official channel plugins in `anthropics/claude-plugins-official`. `--channels` flag. Enterprise `channelsEnabled` / `allowedChannelPlugins` managed settings. v4 names `ntfy.sh` for defer/approval but misses the dedicated Channels primitive entirely.

5. **Remote Control** — `claude remote-control` server mode with `--spawn worktree|same-dir|session`, `--capacity N`, `/rc` command, QR code, Dispatch integration, Android support. v4 mentions Remote Control but misses server mode architecture and the `--spawn` flag.

6. **`--teleport` flag** — `claude --teleport` receives a session transferred from web or iOS. The `/teleport` slash command transfers from Claude Code to a URL the web can pick up. v4 does not document this.

7. **Computer Use in CLI** — separate from Desktop. Enable via `/mcp` → `computer-use` built-in server. macOS only, Pro/Max only, requires Accessibility + Screen Recording permissions. `per-app approval`, machine-wide lock, `Esc` to abort. v4 mentions Computer Use landed in CLI but has no depth.

8. **Auto Mode** (v2.1.83) — permission classifier, `permissions.defaultMode: "auto"`, `PermissionDenied` hook with `retry: true`. v4 does not cover this permission mode.

9. **Agent Teams** — experimental, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`, lead + teammates with shared task list, mailbox messaging, `TeammateIdle` / `TaskCreated` / `TaskCompleted` hooks, `tmux` or iTerm2 split-pane mode, `--teammate-mode` flag. v4 covers Superpowers / BMAD teams but not native Agent Teams.

10. **Ultraplan** — `v2.1.91+`, cloud planning with web-based review interface, section-level commenting, emoji reactions, execute-on-web or teleport-back-to-terminal. v4 does not mention this.

11. **`CLAUDE_CODE_PERFORCE_MODE`** — documented in v2.1.98, Edit/Write/NotebookEdit fail on read-only files with `p4 edit` hint. v4 blueprint mentions this in passing but does not include it as a configuration item.

12. **`--exclude-dynamic-system-prompt-sections`** — v2.1.98, for improved cross-user prompt caching. v4 blueprint mentions it but does not include in settings/flags inventory.

13. **`--bare` flag** — v2.1.81, scripted `-p` calls; skips hooks, LSP, plugin sync; requires API key. v4 does not mention this important CI optimization.

14. **Bedrock Mantle** (`CLAUDE_CODE_USE_MANTLE=1`, v2.1.94) — Amazon Bedrock powered by Mantle. New provider path distinct from standard Bedrock.

15. **Microsoft Foundry** (`CLAUDE_CODE_USE_FOUNDRY=1`) — Azure AI Foundry support with API key or Entra ID auth. `ANTHROPIC_FOUNDRY_RESOURCE`, `ANTHROPIC_FOUNDRY_API_KEY`, `ANTHROPIC_FOUNDRY_BASE_URL`. v4 mentions Foundry support but no configuration detail.

16. **Vertex AI Setup Wizard** — interactive GCP authentication wizard (v2.1.98). Not mentioned in v4.

17. **Focus View (`Ctrl+O`)** — In fullscreen mode (`CLAUDE_CODE_NO_FLICKER=1`): Ctrl+O once = transcript mode with `/` search, Ctrl+O twice = focus view (last prompt + tool summary + response only). v4 does not document the fullscreen rendering architecture.

18. **LLM Gateway Configuration** (`llm-gateway.md`) — Native docs for LiteLLM, `apiKeyHelper` setting, `CLAUDE_CODE_API_KEY_HELPER_TTL_MS`, `X-Claude-Code-Session-Id` header, Bedrock/Vertex/Foundry pass-through via LiteLLM. v4 covers LiteLLM in Slot 25 but misses the native `apiKeyHelper` setting.

19. **`/teleport` and `/desktop` commands** — transfer sessions between surfaces. v4 does not document these.

20. **PowerShell Tool** (v2.1.84, Windows) — `CLAUDE_CODE_USE_POWERSHELL_TOOL=1`. v4 does not mention Windows PowerShell tool.

21. **Plugin `userConfig` + keychain secrets** (v2.1.91) — plugins can prompt for settings at enable time, store sensitive values in OS keychain. v4 does not cover.

22. **Conditional hooks with `if` field** (v2.1.85) — hook fires only when `if: "Bash(git commit *)"` matches. v4 does not document this pattern.

23. **Dispatch** (Desktop app feature) — message a task from Claude mobile app, spawns Desktop session. Mentioned in v4 obliquely but not as a discrete primitive.

24. **Scheduled tasks** (3 variants):
    - Cloud scheduled tasks (`/schedule`, run on Anthropic infrastructure)
    - Desktop scheduled tasks (run on local machine)
    - `/loop` (in-session recurring)
    v4 mentions `/loop` but not the cloud/desktop variants.

25. **Claude Code on Web** — full cloud environment, PR auto-fix, web-based scheduled tasks, iOS app integration. v4 focuses on CLI/desktop.

26. **Slack Integration** — `@Claude` mention spawns web session, returns PR. v4 does not mention this.

27. **GitHub Code Review** (`code-review.md`) — automatic code review on every PR. Separate from GitHub Actions.

28. **JetBrains Plugin** — IntelliJ, PyCharm, WebStorm support. v4 only mentions VS Code.

29. **Agent SDK (`claude-agent-sdk`)** — full SDK overview:
    - Python: `pip install claude-agent-sdk`, `from claude_agent_sdk import query, ClaudeAgentOptions`
    - TypeScript: `npm install @anthropic-ai/claude-agent-sdk`
    - Built-in tools: Read, Write, Edit, Bash, Monitor, Glob, Grep, WebSearch, WebFetch, AskUserQuestion
    - `AgentDefinition` for custom agents
    - `HookMatcher` for SDK-native hooks
    - `supportedAgents()` not documented in public docs but `agents: {...}` option available
    - `agentProgressSummaries` not found in public docs
    - Session resume: capture `session_id` from `SystemMessage` with `subtype: "init"`
    - File checkpointing: rewind file changes
    - Structured outputs with schema validation
    - `settingSources: ["project"]` to enable filesystem-based config
    - Microsoft Azure support: `CLAUDE_CODE_USE_FOUNDRY=1`

30. **`/buddy` command** (v2.1.89) — April 1 joke: hatch a creature that watches you code. v4 mentions BUDDY from source leak but it shipped as `/buddy` command on April 1.

31. **`/team-onboarding`** (v2.1.101) — generate teammate ramp-up guide from local Claude Code usage. v4 does not mention.

32. **`OTEL_LOG_USER_PROMPTS` / `OTEL_LOG_TOOL_DETAILS` / `OTEL_LOG_TOOL_CONTENT`** (v2.1.101) — granular OTEL logging controls. v4 mentions OTel but not these specific variables.

33. **`CLAUDE_CODE_CERT_STORE=bundled`** (v2.1.101) — use only bundled CAs (bypass system CA store). Enterprise network config.

34. **`allowManagedHooksOnly`** (v2.1.101) — setting to allow only managed hooks, preventing user-added hooks.

35. **Context Editing API (`clear_thinking`, `clear_tool_uses`)** — documented on platform.claude.com, used for context window management in long agentic loops. Partially incompatible with advisor tool blocks.

36. **Fine-grained Tool Streaming** (`eager_input_streaming`) — streams tool inputs token by token. v4 does not mention.

37. **Strict Tool Use** (`strict: true` on tool definitions) — guarantees schema validation on tool names and inputs. v4 does not mention.

38. **Service Tiers / Priority Tier** — `anthropic-priority: tier-1` header, per-model Priority Tier subscription. Available for Opus 4.6, Sonnet 4.6, Haiku 4.5. v4 does not mention.

39. **`disableSkillShellExecution`** (v2.1.91) — blocks inline shell execution in skills. Mentioned in v4 but not in settings inventory.

40. **`managed-settings.d/`** drop-in directory (v2.1.83) — multiple policy fragment files merged. v4 mentions managed settings but not the d/ directory pattern.

41. **`InstructionsLoaded`, `PostCompact`, `WorktreeCreate/Remove`, `ConfigChange`, `Notification`, `StopFailure`, `ElicitationResult`** hook events — v4 hook inventory is incomplete.

42. **`cedar` policy syntax highlighting** — mentioned in v4 blueprint but never elaborated. Cedar policies visible in permission rules syntax (`Bash(git commit *)` etc.) but no dedicated Cedar doc page found.

43. **`output-300k-2026-03-24` beta header** — 300k output tokens on Batch API for Opus 4.6 / Sonnet 4.6. Not in v4.

---

### A7. Anthropic-Native Platform Features (platform.claude.com)

**Batch Processing API** — process up to 10,000 requests at 50% cost discount
**Token Counting API** — count tokens before sending
**Message Batches API** — async batch with `output-300k-2026-03-24` beta
**Prompt Caching** — 5-minute and 1-hour TTL options
**Files API** — upload files for reuse across requests
**Models API** — `GET /v1/models` returns capabilities + token limits programmatically
**Zero Data Retention (ZDR)** — Advisor Tool, extended thinking eligible
**Context Editing** — `clear_thinking`, `clear_tool_uses` for long agent loops
**Interleaved Thinking** — auto-enabled on Opus 4.6 with adaptive thinking
**`thinking: {display: "summarized"|"omitted"}`** — control thinking visibility

---

## PART B — PRACTITIONER ACTUAL TOOLING EXTRACTIONS

### B1. Boris Tane (`boristane.com/blog/how-i-use-claude-code/`)

**Actual tools/config found:**
- Claude Code (primary, 9 months daily use)
- Drizzle ORM (`drizzle:generate` for migrations, instruction in CLAUDE.md)
- TypeScript strict (no `any` or `unknown` types instruction in CLAUDE.md)
- `gh` CLI (used via Bash, not as MCP server)
- Custom workflow: `research.md` → `plan.md` → annotation cycle (1-6×) → implement

**MCP servers:** None mentioned. Boris explicitly rejects MCP/plugins/ralphs/gastrophane as producing "a mess that completely falls apart."
**Hooks:** None mentioned.
**Plan mode:** Explicitly rejected ("plan mode sucks").
**Key config pattern:** CLAUDE.md with project conventions + persistent markdown artifacts as state.
**Not in v4:** His research.md/plan.md/annotation workflow is mentioned in v4 Principle 4 but his explicit rejection of MCP/plugins is NOT noted.

**Source:** [boristane.com/blog/how-i-use-claude-code/](https://boristane.com/blog/how-i-use-claude-code/)

---

### B2. Andrej Karpathy

**Actual setup documented:**
- `llm-wiki.md` gist: personal knowledge base pattern — accumulated markdown files, LLM adds to them. The "LLM wiki" pattern.
- `add_to_zshrc.sh` gist: AI-powered git commit message generator function
- `forrestchang/andrej-karpathy-skills` repo: CLAUDE.md derived from Karpathy's LLM coding pitfall observations — principles for goal-driven execution, success criteria, loop-until-done patterns

**CLAUDE.md content (derived, from forrestchang repo):**
- Goal-driven execution: give explicit success criteria
- LLMs excel at looping until they meet specific goals
- Focus on verification: define what "done" looks like

**MCP servers:** Not documented
**Hooks:** Not documented
**Key pattern:** LLM wiki (accumulated markdown), Karpathy's "80% agent, 20% manual" shift documented January 2026
**Not in v4:** The Karpathy LLM wiki / `qmd` pattern is mentioned in v4 (Principle 4, Scout C) but his actual dotfiles setup is not documented.

**Sources:** [gist.github.com/karpathy](https://gist.github.com/karpathy), [github.com/forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)

---

### B3. mattpocock

**Actual setup documented (via citypaul/.dotfiles which aggregates mattpocock patterns):**
- 20+ specialized skills organized in `.claude/skills/` with on-demand loading
- Skills cover: TDD workflow, mutation testing, hexagonal architecture, DDD, TypeScript strict, functional programming, API design, CLI design, legacy code patterns, CI debugging
- Web quality skills imported from `addyosmani/web-quality-skills` 
- OpenCode compatibility: `--with-opencode` flag mentioned
- Tools: Vitest (Browser Mode), Zod, TypeScript strict, Playwright
- Custom commands: test design review, mutation analysis, TDD workflow verification, refactoring priority, web quality audit

**MCP servers:** Not explicitly documented
**Hooks:** Not explicitly documented  
**Key pattern:** Auto-discovered skills that reduce loaded context from ~3,000 to ~100 lines (v3.0 skill architecture)
**Not in v4:** The `addyosmani/web-quality-skills` import pattern, OpenCode compatibility layer.

**Source:** [github.com/citypaul/.dotfiles](https://github.com/citypaul/.dotfiles)

---

### B4. Geoffrey Huntley (`ghuntley.com/rad/`)

**Explicit tools:**
- Cursor Cloud Agents
- Cursor Workflow Automations (risk-based deployment)
- PostHog (analytics)
- PDL (professional data lookup)
- Perplexity (search integration)
- PipeDrive-style CRM (custom-built)
- ZenDesk-style support (custom-built)
- Discord integration (community tracking)

**MCP servers:** Not explicitly named
**Hooks:** Not documented
**Key pattern:** Building entire SaaS tooling stack via Claude rather than buying commercial tools
**Not in v4:** Huntley's approach is not mentioned in v4.

**Source:** [ghuntley.com/rad/](https://ghuntley.com/rad/)

---

### B5. Addy Osmani

**Actual tools documented:**
- Claude Code (primary, Google workspace context)
- `addyosmani/web-quality-skills` — open skill library covering Core Web Vitals (LCP/INP/CLS), WCAG accessibility, SEO, performance
- Published essays on Comprehension Debt, Ambient Anxiety Tax, Trust Calibration Overhead
- Operational rule: "start with one fewer agent than feels comfortable" (3-4 agent ceiling)

**MCP servers:** Not documented in available sources
**Hooks:** Not documented
**Not in v4:** Osmani's web-quality-skills repo is not referenced in v4.

---

### B6. Freek Van der Herten

**Actual setup (freek.dev/3026-my-claude-code-setup):**
- CLAUDE.md: "be critical and not sycophantic", follow Spatie PHP guidelines, use `gh` for GitHub ops
- `laravel-php-guidelines.md` in skills
- settings.json: broad permissions + `alwaysThinkingEnabled: true`
- 4 custom agents: `laravel-simplifier` (Opus), `laravel-debugger` (Sonnet), `laravel-feature-builder` (Opus), `task-planner` (Opus)
- 40+ skills loaded contextually
- Custom statusline.sh: repo name + context % with color-coding

**MCP servers:** Not explicitly named
**Hooks:** Not documented
**Not in v4:** Custom status line scripts, model-specific agent definitions.

---

### B7. citypaul/.dotfiles

**Actual setup:**
- CLAUDE.md with TDD-is-non-negotiable, immutability-by-default, schema-first principles
- 20+ specialized skills (see B3 above for full list)
- OpenCode compatibility (`--with-opencode` flag)
- addyosmani/web-quality-skills imported as skill package

**Source:** [github.com/citypaul/.dotfiles](https://github.com/citypaul/.dotfiles)

---

### B8. fcakyon/claude-codex-settings (AGENTS.md symlink pattern)

**The pattern:**
```bash
ln -sfn CLAUDE.md AGENTS.md
ln -sfn CLAUDE.md GEMINI.md
```
**Purpose:** Single source of truth. CLAUDE.md is primary; AGENTS.md and GEMINI.md are symlinks so the same instructions work across Claude Code, Codex CLI, and Gemini CLI.

**Repo structure:** `.claude/`, `.agents/plugins/`, `.codex/`, `.cursor-plugin/`, `.vscode/`, `/plugins/` with individual SKILL.md files per plugin.
**Aggregates:** Official skills from Anthropic, OpenAI, MongoDB, Stripe, Supabase, Cloudflare
**Install methods:** Claude Code CLI, Codex, Gemini, npx skills

**Not in v4:** The multi-AI symlink pattern and the cross-tool skill aggregation registry.

**Source:** [github.com/fcakyon/claude-codex-settings](https://github.com/fcakyon/claude-codex-settings)

---

### B9. nicknisi/dotfiles

**Actual setup found:**
- CLAUDE.md present in repo root
- `tools/gpt5-mcp-server` directory (MCP server implementation)
- tmux status bar integration showing Claude working status
- Primary tools: Neovim (Lua config), tmux, ZSH

**Source:** [github.com/nicknisi/dotfiles](https://github.com/nicknisi/dotfiles)

---

### B10. Boris Cherny (Creator of Claude Code)

**Public setup not documented.** No public dotfiles or CLAUDE.md found. The "sankalp blog" reference appears to be a confusion; Boris Cherny does not have a public blog at that URL. The engineering post "Scaling Managed Agents: Decoupling the brain from the hands" (April 8 2026) attributed to Anthropic engineering, which Cherny leads.

---

## PART C — HIGHEST-LEVERAGE ADDITIONS FOR v4 (NOT CURRENTLY IN BLUEPRINT)

### Tier 1: Architecture-Level Gaps (should be in §1 Mental Model)

1. **Auto Mode permission system** — `permissions.defaultMode: "auto"` + `PermissionDenied` hook is now a first-class permission architecture tier. v4's permission coverage stops at allow/deny/ask/defer but misses the auto mode classifier layer entirely.

2. **Channels primitive** — Telegram/Discord/iMessage/webhook push-INTO-session is a fundamentally different communication pattern from Remote Control (you controlling a session) or Slack (spawning new sessions). `--channels plugin:telegram@claude-plugins-official` belongs as a Slot 28 primitive equal to ntfy.sh.

3. **Agent Teams architecture** — native multi-agent with shared task list, mailbox messaging, `TeammateIdle`/`TaskCreated`/`TaskCompleted` hooks, and `--teammate-mode` flag. v4 Slot 5 covers OpenHands/BMAD but not the native Anthropic primitive.

4. **`/ultraplan` cloud planning** — section-level commenting, cloud-execute vs teleport-back-to-terminal. New workflow primitive that does not map to existing slots.

5. **Surface portability** — sessions transfer between CLI / VS Code / Desktop / Web / iOS / Android via `/teleport`, `/desktop`, `--teleport`, Remote Control. v4's mental model treats Claude Code as a single-surface tool.

### Tier 2: Configuration Gaps (should be in §4 Slot Roster)

6. **Fast Mode** — `/fast`, `fastMode: true`, `fastModePerSessionOptIn`, $30/$150 MTok, 2.5× speed. Should be in Slot 22 (cost tracking) or its own efficiency note.

7. **LLM Gateway native config** — `apiKeyHelper` setting + `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` for rotating tokens. Slot 25 covers LiteLLM but misses the native `apiKeyHelper` pattern.

8. **Bedrock Mantle + Foundry** — separate provider paths from standard Bedrock and Vertex. Three environment variables each. Slot 20 CI/CD should cover all four provider paths.

9. **Conditional hooks (`if` field)** — reduces hook process overhead dramatically. Slot 2 (hooks) should include this.

10. **`disableSkillShellExecution`** — security hardening for skill inline shell. Slot 2 / Slot 29 MCP security.

### Tier 3: Ecosystem Gaps (should be in practitioner section)

11. **`fcakyon/claude-codex-settings` symlink pattern** — `ln -s CLAUDE.md AGENTS.md` cross-tool portability. Most practitioners are now doing this.

12. **citypaul/.dotfiles skill architecture** — 20+ skills reducing context from ~3000 to ~100 lines at session start. The best documented public implementation of the skill-library pattern.

13. **Claude Mythos Preview / Project Glasswing** — invitation-only model for defensive cybersecurity. Partners include the largest cloud/security companies. Not a general-availability product but represents the frontier of Anthropic's capability surface.

---

## PART D — v4 BLUEPRINT VERIFICATION ITEMS

| v4 Claim | Status |
|----------|--------|
| Advisor Tool: 41.2% SWE-bench vs 19.7% solo, 85% cost reduction | **CONFIRMED** by official docs |
| `defer` permissionDecision at 0.4% FP | **CONFIRMED** by docs (mentioned in v2.1.89 release) |
| Monitor tool first-class in v2.1.98 | **CONFIRMED** — Monitor tool in CLI tools list |
| Linux PID namespace + seccomp production-stable v2.1.98 | **CONFIRMED** via `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` enabling it |
| `ant` CLI as GitOps for agents | **PARTIALLY CONFIRMED** — public repo only shows `messages create`; agent/skill YAML management not in public docs |
| April 4 2026 subscription enforcement (Cline, Cursor, Windsurf, OpenClaw cut) | **CONFIRMED** via principle 7 docs + multiple sources |
| `effortLevel` default flipped to `high` in v2.1.94 | **CONFIRMED** |
| openclaude 20.6k⭐ born April 1 2026 | **NOT VERIFIED** in official docs (third-party) |
| AGENTS.md donated to Linux Foundation December 9 2025 | **NOT VERIFIED** in official docs |
| Cedar policy syntax highlighting v2.1.100 | **MENTIONED** in blueprint but no dedicated doc page found |
| `/buddy` BUDDY virtual pet | **CONFIRMED** — `/buddy` command in v2.1.89 (April 1st) |

---

## Sources

- [code.claude.com/docs/llms.txt](https://code.claude.com/docs/llms.txt) — complete 110-page index
- [code.claude.com/docs/en/whats-new/2026-w13](https://code.claude.com/docs/en/whats-new/2026-w13) — v2.1.83–v2.1.85
- [code.claude.com/docs/en/whats-new/2026-w14](https://code.claude.com/docs/en/whats-new/2026-w14) — v2.1.86–v2.1.91
- [code.claude.com/docs/en/changelog](https://code.claude.com/docs/en/changelog) — v2.1.69–v2.1.101 full history
- [platform.claude.com/docs/en/agents-and-tools/tool-use/tool-reference](https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-reference)
- [platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool)
- [platform.claude.com/docs/en/about-claude/models/overview](https://platform.claude.com/docs/en/about-claude/models/overview)
- [code.claude.com/docs/en/hooks](https://code.claude.com/docs/en/hooks)
- [code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills)
- [code.claude.com/docs/en/plugins](https://code.claude.com/docs/en/plugins)
- [code.claude.com/docs/en/agent-sdk/overview](https://code.claude.com/docs/en/agent-sdk/overview)
- [code.claude.com/docs/en/agent-teams](https://code.claude.com/docs/en/agent-teams)
- [code.claude.com/docs/en/channels](https://code.claude.com/docs/en/channels)
- [code.claude.com/docs/en/remote-control](https://code.claude.com/docs/en/remote-control)
- [code.claude.com/docs/en/computer-use](https://code.claude.com/docs/en/computer-use)
- [code.claude.com/docs/en/ultraplan](https://code.claude.com/docs/en/ultraplan)
- [code.claude.com/docs/en/fast-mode](https://code.claude.com/docs/en/fast-mode)
- [code.claude.com/docs/en/fullscreen](https://code.claude.com/docs/en/fullscreen)
- [code.claude.com/docs/en/llm-gateway](https://code.claude.com/docs/en/llm-gateway)
- [code.claude.com/docs/en/microsoft-foundry](https://code.claude.com/docs/en/microsoft-foundry)
- [github.com/anthropics/anthropic-cli](https://github.com/anthropics/anthropic-cli)
- [anthropic.com/glasswing](https://www.anthropic.com/glasswing)
- [boristane.com/blog/how-i-use-claude-code/](https://boristane.com/blog/how-i-use-claude-code/)
- [freek.dev/3026-my-claude-code-setup](https://freek.dev/3026-my-claude-code-setup)
- [github.com/citypaul/.dotfiles](https://github.com/citypaul/.dotfiles)
- [github.com/fcakyon/claude-codex-settings](https://github.com/fcakyon/claude-codex-settings)
- [github.com/nicknisi/dotfiles](https://github.com/nicknisi/dotfiles)
- [github.com/forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)
- [fortune.com/2026/04/07/anthropic-claude-mythos-model-project-glasswing-cybersecurity/](https://fortune.com/2026/04/07/anthropic-claude-mythos-model-project-glasswing-cybersecurity/)

