# VERIFIED_FACTS.md — Claude Code Ecosystem, April 11 2026

*Synthesis of 4 parallel verification agents run against primary sources. **Overrides `RESEARCH_CORPUS.md` where conflicts exist.** The writer of `CLAUDE_CODE_BLUEPRINT_v3.md` must read this file before writing, prefer it over the corpus on any disagreement, and flag each correction inline in the blueprint using the pattern: `> **Correction (Apr 11 verify pass):** corpus says X; primary source confirms Y.`*

Source reports (full tables, citations, flagged columns):
- `.omc/research/verify-platform-schemas.md` (Agent A: Parts A / B / R)
- `.omc/research/verify-orchestration.md` (Agent B: Part E)
- `.omc/research/verify-mcp-servers.md` (Agent C: Part D)
- `.omc/research/verify-sandbox-cicd-obs.md` (Agent D: Parts I / J / K / M)

---

## 1. Platform State & Schemas (Agent A — 45 claims, 35✅ / 3❌ / 3❓ / 4⚠️)

### 1.1 Hard contradictions in corpus (must be flagged inline)

| # | Corpus claim | Verified fact | Severity |
|---|---|---|---|
| 1 | `/loop` shipped in v2.1.63 (Feb 28 2026) | **`/loop` shipped in v2.1.71** (March 7 2026). v2.1.63 shipped `/simplify` and `/batch`. Corpus contradicts itself in two places. | HIGH |
| 2 | Exit-code-2 blocking hooks are 4 (PreToolUse, UserPromptSubmit, PermissionRequest, WorktreeCreate) | **12 blocking events.** Corpus missed: Stop, SubagentStop, TeammateIdle, TaskCreated, TaskCompleted, ConfigChange, Elicitation, ElicitationResult. Also: WorktreeCreate aborts on **any non-zero exit**, not just 2. | HIGH — silent policy gaps in any hook guide derived from corpus alone |
| 3 | `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` is needed alongside `CLAUDE_CODE_ENABLE_TELEMETRY=1` for telemetry | **`CLAUDE_CODE_ENABLE_TELEMETRY=1` alone is sufficient** for basic metrics + log events. `ENHANCED_TELEMETRY_BETA` exclusively gates the distributed-traces beta feature. Pairing both silently opts enterprises into a beta feature. | MEDIUM |
| 4 | MCP donated to Agentic AI Foundation in January 2026 | **December 9 2025** per Anthropic blog post + Linux Foundation press release. Off by ~3 weeks. | MEDIUM |
| 5 | Managed Agents launch customers: Notion, Rakuten, Asana | **Also Vibecode and Sentry** per Anthropic launch blog. Corpus list is incomplete. | MEDIUM |

### 1.2 Releases that shipped AFTER the corpus froze (v2.1.89 → v2.1.101, 7 drops in 10 days)

| Version | Date | What shipped | Blueprint impact |
|---|---|---|---|
| **2.1.89** | Apr 1 2026 | `"defer"` permission decision for PreToolUse hooks (pauses headless sessions for external approval); `PermissionDenied` hook supports `{retry: true}`; `CLAUDE_CODE_NO_FLICKER=1` for flicker-free rendering | **Hooks slot** — `defer` unlocks headless-pause patterns. Update §1 mental model and §4 Slot 19 decision tree. |
| **2.1.90** | Apr 1 2026 | `/powerup` interactive feature-learning command with animated demos | Minor. Reference in §7 install playbook. |
| **2.1.91** | Apr 2 2026 | MCP tool result size raised to **500K chars** via `_meta["anthropic/maxResultSizeChars"]`; plugins can ship executables under `bin/` (auto-added to Bash PATH); `disableSkillShellExecution` setting | **§4 Slot 3 plugins**: `bin/` directory is a new primitive. **§4 Slot 14 memory**: 500K MCP result size changes what memory-heavy MCP servers can return. |
| **2.1.92** | Apr 4 2026 | Interactive Bedrock setup wizard; per-model + cache-hit `/cost` breakdown; `forceRemoteSettingsRefresh` fail-closed policy | **§4 Slot 22 cost tooling**: native `/cost` is now first-class. Downgrade `ccusage` etc. to "supplementary." |
| **2.1.94** | **Apr 7 2026** | **Default `effortLevel` changed from `medium` → `high`** for API-key, Bedrock, Vertex, Foundry, Team, and Enterprise users (NOT Pro) | **HIGH IMPACT.** Any cost model or performance assumption based on medium-default is stale. Update §9 failure modes (thrashing cost discussion) and §2 principles (`effortLevel` discipline). |
| **2.1.98** | Apr 9 2026 | **Monitor tool** (first-class primitive for streaming events from `run_in_background` scripts); **Linux subprocess sandboxing with PID namespace isolation + seccomp** (now stable, not beta); `CLAUDE_CODE_PERFORCE_MODE`; `--exclude-dynamic-system-prompt-sections` flag | **§1 mental model**: Monitor tool belongs alongside `run_in_background` as a session-level primitive. **§4 Slot 18 sandbox**: native Linux subprocess sandbox is now production-ready — affects the "which sandbox for which use case" decision tree. |
| **2.1.101** | Apr 10 2026 | `/team-onboarding` command | Reference in §7. |

### 1.3 Confirmed verbatim (zero-tolerance schema traps — no correction needed, anchor in blueprint)

- `model` not `defaultModel` ✅
- `permissions.defaultMode: "acceptEdits"` not `autoAccept` ✅
- MCP location split: user `~/.claude.json projects[path].mcpServers`; project `.mcp.json`; plugin `plugin.json`; NEVER top-level in `settings.json` ✅
- 26 hook events (all listed in corpus B.2) ✅
- Plugin manifest at `<plugin-root>/.claude-plugin/plugin.json` ✅
- Skill frontmatter `allowed-tools` not `allowed_tools` ✅
- Spec-Kit install: `uv tool install specify-cli --from git+https://github.com/github/spec-kit@v0.5.1` ✅
- Spec-Kit commands prefixed: `/speckit.constitution`, `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement` ✅
- Native binary installer: `curl -fsSL https://claude.ai/install.sh | bash` ✅
- Model lineup: Opus 4.6 (Feb 5 2026), Sonnet 4.6 (Feb 17 2026), Haiku 4.5 (Oct 15 2025) ✅
- Agent Teams flag `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`, requires v2.1.32+ ✅
- Managed Agents beta header `managed-agents-2026-04-01`, pricing $0.08/session-hour ✅

---

## 2. Orchestration Platforms (Agent B — 18/18 corpus, 5 new scouted, 6 composition pairs)

### 2.1 Corpus corrections

| # | Corpus claim | Verified fact | Action |
|---|---|---|---|
| 1 | `steveyegge/gastown` | Canonical org is **`gastownhall/gastown`**. `steveyegge/` redirects but is not canonical. | Update link in §4 Slot 5. |
| 2 | Multica license: Apache-2.0 | GitHub API returns **`NOASSERTION`**. LICENSE file may exist but SPDX not declared. | Flag for compliance-sensitive users. |
| 3 | Praktor: created Apr 11 2026 | **Created Feb 13 2026.** Correct owner: **`mtzanidakis/praktor`** (corpus had no URL). | Fix in §4 Slot 5. |
| 4 | Multiclaude: MIT | License field is **null**. Repo is **dormant since Jan 28 2026** with low star velocity. | Downgrade in §4 Slot 5 ranking; flag as dormant. |
| 5 | `baryhuang/claude-code-by-agents`: active | **Stalled since Jan 1 2026** — 3+ months no commits. | Flag as likely abandoned. |
| 6 | `wshobson/agents` absent from Part E | **33.4k⭐, MIT, actively maintained.** Largest CC agent/skill library. Tier 1 omission. | **Add as Tier 1 primary in Slot 5** — between Ruflo and Vibe-Kanban by star count. |

### 2.2 New additions (5 scouted for Slot 5)

1. **`wshobson/agents`** — 33.4k⭐, MIT, April 2026 active. 182 agents + 16 multi-agent orchestrators + 149 skills + 96 commands across 77 plugins. Ships **PluginEval** quality framework (static + LLM judge + Monte Carlo, Wilson/Clopper-Pearson CI, Elo pairwise ranking, Bronze/Silver/Gold/Platinum badges). CLI: `uv run plugin-eval score/certify/compare`. **Tier 1 by star count, Tier 1 by ecosystem leverage — many other platforms reference or depend on this substrate.**

2. **`mikeyobrien/ralph-orchestrator`** — 2,522⭐, MIT, active April 2026. The canonical external loop-runner implementing the "Ralph Wiggum" technique. Replaces the corpus's unverified `ralph-claude-code` / `ralph-tui` / `ralphy` long-tail mentions.

3. **`stellarlinkco/myclaude`** — 2,582⭐, AGPL-3.0, active April 2026. Vendor-neutral multi-agent workflow harness (Claude Code, Codex, Gemini, OpenCode). Created July 2025, substantial traction, overlooked by corpus.

4. **`coollabsio/jean`** — 819⭐, Apache-2.0, active April 2026. From the Coolify team — production-grade OSS pedigree. Desktop/web dev environment for AI agents; cross-project orchestration.

5. **`chernistry/bernstein`** — 100⭐, Apache-2.0, created March 22 2026, active April 11 2026. Declarative YAML agent orchestration with **zero LLM coordination overhead** (deterministic routing — no LLM in the loop for coordination). Architecturally distinct; very recent.

### 2.3 Composition map (from Agent B's report, for §5 integration recipes)

**Cleanly composable (10 pairs identified):**
- Paperclip + Vibe-Kanban — different layers (org-chart vs Kanban)
- Paperclip + wshobson/agents — Paperclip as dispatcher, wshobson as agent substrate
- Multica + claude-mpm — Multica as dashboard, claude-mpm as agent library
- ralph-orchestrator + Claude Squad — Ralph as loop, claude-squad as pane manager
- Agent Teams (experimental) + BMAD-METHOD — BMAD slash commands invoked inside Agent Teams

**Mutually exclusive (8 pairs):**
- Paperclip vs Ruflo — both wrap the session loop
- Gastown vs multiclaude — both auto-merge PR ratchets
- vibe-kanban vs Multica — overlapping Kanban abstractions

**Obsoleted by first-party Agent Teams (partial):**
- Claude-Squad — Agent Teams' `teammateMode: tmux` overlaps, but claude-squad still wins for pure terminal-ops workflow

---

## 3. MCP Server Ecosystem (Agent C — ~26 confirmed, 10 stale, 11 unverified, 10 new)

### 3.1 Dead / archived

| Server | Verdict | Replacement |
|---|---|---|
| **`PostHog/mcp`** | **ARCHIVED Jan 19 2026.** Read-only. | Use the new server via the PostHog monorepo, the PostHog Wizard, or **`datadog-labs/mcp-server`** (fills the observability gap). |

### 3.2 Stale commands (must update verbatim in blueprint)

| Server | Corpus command | Correct command (Apr 11 2026) |
|---|---|---|
| **Serena** | `claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project $(pwd)` | **`uv tool install -p 3.13 serena-agent@latest --prerelease=allow`**. The corpus command is explicitly deprecated in Serena's own README. v1.1.0 shipped **today, April 11 2026**. |
| **Sentry MCP** | Generic stdio approach | **Remote HTTP with OAuth at `https://mcp.sentry.dev/mcp`** — no local installation needed. Also available as a Claude plugin. |
| **Context7** | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest` | Now requires `--api-key` from `context7.com/dashboard`. Anonymous mode is rate-limited. |
| **github/github-mcp-server** | 51 tools | Tool count grown past 51 — server rewritten in Go, added Projects tools, code scanning, `get_me`, OAuth scope filtering, since Jan 28 2026. |

### 3.3 New additions (10 picks across slots)

| Slot | Addition | Why it earns a slot |
|---|---|---|
| 15 Observability | **`datadog-labs/mcp-server`** (GA Mar 10 2026) | Official Datadog remote MCP, 16+ tools across logs/metrics/traces/incidents + optional APM/LLM Observability toolsets. **Fills the gap left by PostHog archival.** Install: `claude mcp add --transport http datadog https://mcp.datadoghq.com/api/unstable/mcp-server/mcp`. |
| 14 Memory | **`milla-jovovich/mempalace`** (April 2026) | **23k⭐**, 19 MCP tools, **96.6% LongMemEval** (caveat: score measures ChromaDB default embeddings, not the "palace" architecture — community scrutiny forced a README correction). MIT, Python. `pip install mempalace`. |
| Cross (partner) | **`stripe/mcp`** at `mcp.stripe.com` | Official Anthropic partner, 25 tools covering full payment lifecycle. Part of `stripe/ai` monorepo. Remote HTTP. |
| 13 Databases | **`googleapis/mcp-toolbox`** (v0.30.0 Mar 2026) | Official Google, BigQuery + AlloyDB + Spanner + CloudSQL + Postgres + MySQL. Self-hosted HTTP. Fills enterprise GCP gap. |
| Cross | **`vercel/mcp`** at `mcp.vercel.com` | Official Vercel remote with OAuth + Streamable HTTP. |
| Cross | **Linear MCP** at `mcp.linear.app` | Official remote. |
| Cross | **Cloudflare MCP** | 2,500 API endpoints compressed into ~1k tokens — impressive context engineering. |
| 14 Memory | **`supermemory`** | 15k⭐ universal memory API. |
| Cross | **Figma MCP** | Official Anthropic partner, design-to-code. |
| 11 Browser | `@playwright/cli` token-efficient variant | Adjunct to Playwright MCP. |

### 3.4 Registry count

Corpus claim "~2,000 as of early 2026 with 407% growth" is **unverifiable directly** — the v0 registry API uses cursor pagination with no `total_count` field. The 407% growth likely refers to the broader GitHub/npm/PyPI ecosystem, not the curated registry.

**Best estimate:**
- Curated `registry.modelcontextprotocol.io`: 1,500–2,500 entries
- Broader ecosystem across GitHub/npm/PyPI: **12,000+**

Blueprint should cite the broader number with the "curated registry count unverifiable via API" caveat.

---

## 4. Sandbox / CI/CD / Observability / Incidents (Agent D — 5 confirmations, 3 corrections, 5 new, 0 retractions)

### 4.1 Confirmed verbatim — anchor these in the blueprint

- **jq severity gate incantation** confirmed character-for-character: `--jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson'`. **The space before `-->` is load-bearing** because the HTML comment format is `<!-- bughunter-severity: {...} -->`.
- **Vercel AI Gateway Max-path** confirmed verbatim from official docs:
  ```bash
  export ANTHROPIC_BASE_URL="https://ai-gateway.vercel.sh"
  export ANTHROPIC_CUSTOM_HEADERS="x-ai-gateway-api-key: Bearer your-ai-gateway-api-key"
  export ANTHROPIC_API_KEY=""  # MUST be empty string, not unset
  ```
  **NEW TRAP not in corpus**: `ANTHROPIC_API_KEY` must be set to the empty string, **not** left unset. Claude Code checks `ANTHROPIC_API_KEY` first and will use it if non-empty, bypassing the gateway entirely.
- **Fly Sprites** `sprite create` confirmed: NO `--cpu` or `--disk` flags. 100GB NVMe and 8 CPU are platform defaults. **Bonus new flag**: `--skip-console` (exits after creation without entering the console) for CI/scripted use.
- **`anthropics/claude-code-action`**: `@v1` is current major, latest patch **v1.0.93 (April 10 2026)**. No v2 exists. **Corpus typo**: v1.0.93 is dated 2026 not 2025 (the action postdates CC 2.0's September 2025 launch).
- **All 5 incidents confirmed:** Replit 2.5-year wipeout; axios 1.14.1 / 0.30.4 by Sapphire Sleet (DPRK); arxiv 2604.04978 permission-gate 81% FN; GitHub #42796 80× thrashing; BrowseComp 40M-token eval awareness.
- **Langfuse v3 docker-compose requires MinIO** — confirmed, cannot be dropped.

### 4.2 Corrections

| # | Corpus claim | Verified fact |
|---|---|---|
| 1 | **Modal pricing** ~$0.047/vCPU-hr | **$0.119–0.142/vCPU-hr** on Modal's sandbox tier (non-preemptible, required for sandboxes). Corpus likely reflects older or preemptible base compute. 2.5–3× higher. |
| 2 | Sapphire Sleet axios attack window closed 03:29 UTC | **03:20 UTC** per Microsoft primary source. |
| 3 | `claude-code-action` v1.0.93 dated April 10 **2025** | April 10 **2026** (corpus transcription typo — the action postdates CC 2.0 Sep 2025 launch). |
| 4 | "Replit agent" wording conflation | Corpus body (M.2) correctly attributes the 2.5-year wipeout to **Claude Code**, not Replit. The **SaaStr / Jason Lemkin Replit incident** (July 2025, production DB deleted during a code freeze) is a **separate real event not currently in the corpus**. Worth adding to §9 as a distinct data point — same class of failure mode, different product. |

### 4.3 New entrants

1. **Langfuse v4 Cloud preview** (March 10 2026) — observations-first data model, new wide ClickHouse table eliminating read-time joins, **10× dashboard speedup**. Python SDK 4.x / JS SDK v5. **Self-hosted v4 path not yet published** — v3 MinIO-required constraint still holds for self-host. Add to Slot 21 as "v3 (self-host, stable, MinIO required) vs v4 (cloud preview, observations-first)."

2. **`abshkbh/arrakis-mcp-server`** — MCP integration repo for the `arrakis` sandbox. Corpus Part I.x mentions `arrakis` but omits this companion server — which is the actual integration path for Claude Code. Add to Slot 17 sandbox bridges.

3. **LangSmith Sandboxes** (LangChain) — secure code execution for agents. Adjacent to Claude Code observability stack. Add to Slot 21 observability.

4. **Fly Sprites `--skip-console` flag** — non-interactive sprite creation for CI. Add to §4 Slot 18 + §7 install playbook.

5. **Anthropic subscription policy enforcement** (April 4 2026) — Anthropic explicitly cut subscription access for non-Anthropic harnesses including **Cline, Cursor, Windsurf, OpenClaw**. This is a **named policy event** that strengthens the "CI must use API billing" architectural constraint. Add to Part J as a load-bearing named event, and to §9 failure modes as a trust signal. This is also relevant to the blueprint's dual-tier stance: if you intend to use alternative harnesses long-term, you now need API billing, not Max subscription.

---

## 5. Writer Directives (binding on the Phase 4 opus writer)

1. **This file overrides the corpus** on any disagreement. Where they agree, either can be cited.
2. **Correction flag pattern** (apply inline wherever a corrected fact appears):
   > **Correction (Apr 11 verify pass):** corpus says X; primary source confirms Y. [source]
   Do not silently overwrite. The correction is visible to the reader.
3. **New additions must be added to their respective slots** with the full metadata from this file.
4. **`wshobson/agents` must be a Tier 1 primary in Slot 5** — it is a load-bearing absence from the corpus.
5. **The 7 post-corpus releases (v2.1.89 → 2.1.101) must be reflected:**
   - §1 Mental Model: Monitor tool (v2.1.98) belongs alongside `run_in_background` as a session-level primitive; `"defer"` permission decision (v2.1.89) unlocks a new headless-pause pattern
   - §4 Slot 1 kernel: list the 7 drops as a compact timeline
   - §4 Slot 3 plugin framework: `bin/` directory auto-PATH (v2.1.91) + `disableSkillShellExecution` setting
   - §4 Slot 18 sandbox: native Linux subprocess sandbox with PID namespace + seccomp is now production-stable (v2.1.98) — affects the "which sandbox for which use case" decision tree
   - §4 Slot 19 hooks: `defer` + `PermissionDenied.retry` expand the decision tree
   - §4 Slot 22 cost: native per-model + cache-hit `/cost` (v2.1.92) is now first-class; downgrade `ccusage` / `kerf-cli` to "supplementary"
   - §9 failure modes: **v2.1.94 effortLevel default changed from `medium` → `high`** for API/Bedrock/Vertex/Foundry/Team/Enterprise (NOT Pro). Any cost model based on medium-default is stale. This deserves its own bullet under the "cost anomalies as strategy-drift signal" failure mode.
6. **Anthropic subscription-enforcement event (Apr 4 2026)** must appear in:
   - Part J / §4 CI/CD slot: as the hard evidence that "subscription plans prohibit scripted use" went from policy text to enforcement action
   - §9 failure modes: as a trust signal and a forcing function for the CI billing split
7. **Langfuse v4 Cloud preview** must appear in Slot 21 with explicit v3 / v4 split: "v3 self-host requires MinIO (cannot be dropped); v4 cloud preview is 10× faster on dashboards; v4 self-host path TBD as of April 11 2026."
8. **PostHog/mcp is archived.** Replace with Datadog MCP primary (+ PostHog-via-monorepo as alternate + archive note).
9. **Serena install command** must use the new form, not the deprecated one. Note v1.1.0 shipped April 11 2026.
10. **Sentry MCP** must use the remote HTTP OAuth path, not stdio.
11. **Modal pricing** must be updated.
12. **Fly Sprites `--skip-console` flag** must appear in the CI sandbox section.
13. **SaaStr / Replit incident** should be added as a distinct data point in §9 alongside the corpus's Claude Code 2.5-year wipeout — both are destructive-agent-action failure modes with different products, strengthening the principle "destructive ops need structural gates, not advisory warnings."

---

## 6. Summary tallies

| Category | Verified ✅ | Corrected ❌ | New additions ➕ | Dead ⚰️ |
|---|---|---|---|---|
| Platform state (A/B/R) | 35 | 5 hard + 7 post-corpus drops | 7 releases | 0 |
| Orchestration (E) | 18 | 5 | 5 | 2 dormant |
| MCP servers (D) | 26 | 10 | 10 | 1 archived |
| Sandbox / CI / obs (I/J/K/M) | ~20 | 3 | 5 | 0 |
| **TOTALS** | **~99** | **~23** | **~27** | **3** |

Corpus accuracy rate: **~81%** (99 / (99+23)). Sufficient to anchor the blueprint, but the 23 corrections and 27 additions are load-bearing enough that without this verify pass the blueprint would have shipped with broken commands, a dead MCP server, a missing Tier 1 orchestration platform, stale cost assumptions from a default-effort change that landed 4 days ago, and missing primitives from 7 releases.

End of VERIFIED_FACTS.md
