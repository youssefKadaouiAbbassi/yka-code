# Deep Interview Spec: Claude Code Blueprint v3.0 — Maximal, Vertical-Agnostic, Dual-Tier

## Metadata
- Interview ID: dic-blueprint-v3-20260411
- Rounds: 3
- Final Ambiguity Score: 19.8%
- Type: brownfield (v2.0 blueprint exists, will be superseded, not revised)
- Generated: 2026-04-11
- Threshold: 0.20
- Status: PASSED
- Target output path: `CLAUDE_CODE_BLUEPRINT_v3.md` (new file; v2.0 preserved for diff)

## Clarity Breakdown
| Dimension | Score | Weight | Weighted |
|---|---|---|---|
| Goal Clarity | 0.97 | 0.35 | 0.3395 |
| Constraint Clarity | 0.75 | 0.25 | 0.1875 |
| Success Criteria | 0.80 | 0.25 | 0.2000 |
| Context Clarity | 0.50 | 0.15 | 0.0750 |
| **Total Clarity** | | | **0.8020** |
| **Ambiguity** | | | **0.1980 (19.8%)** |

## Goal

Produce **one** markdown blueprint (`CLAUDE_CODE_BLUEPRINT_v3.md`, 15k–40k words, expected 20k–30k) that designs a maximal Claude Code system architecture grounded exclusively in `RESEARCH_CORPUS.md` (199KB, Parts A–S, ~260 citations, April 11 2026). The blueprint must be **vertical-agnostic, stack-agnostic, and tier-agnostic**: equally useful for a solo developer shipping a personal SaaS and for the same operator running enterprise-grade output. It must honor the 10-section structure in `ARCHITECTURE_PROMPT.md` verbatim, and it must show **every** corpus component that plausibly earns a slot — alternates in full, primaries picked by merit (verified schemas, composability, battle-testing, corpus evidence) rather than profile-fit.

This replaces the v2.0 "trust, not capability" thesis blueprint, which pre-filtered components against a solo-dev-Linux-TypeScript prior and rejected maximalism. The user explicitly overrides both framings.

## Constraints

1. **Corpus is ground truth.** `RESEARCH_CORPUS.md` (Parts A–S) overrides training data for every claim about Claude Code 2.1.101, its ecosystem, or named projects. Every strong claim points at a specific Part (e.g., "corpus Part K.3"). Training-data claims without a pointer are not citations.
2. **Verified schemas only.** Every schema, env var, command, path, and config key must match Part B (schemas) and Part R (load-bearing configs). Schema traps from ARCHITECTURE_PROMPT.md "Confidence Notes" section are non-negotiable:
   - `defaultModel` does not exist → use `model`
   - `autoAccept` does not exist → use `permissions.defaultMode: "acceptEdits"`
   - `mcpServers` is NOT top-level in `settings.json` → user MCP in `~/.claude.json`, project MCP in `.mcp.json`, plugin MCP in `plugin.json`
   - Spec-Kit install: `uv tool install specify-cli --from git+...@v0.5.1` (not pipx, not npm)
   - Spec-Kit commands prefixed: `/speckit.constitution`, `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`
   - Current release: Claude Code 2.1.101 (April 10, 2026)
   - Model lineup: Opus 4.6 (Feb 5), Sonnet 4.6 (Feb 17), Haiku 4.5 (Oct 15 2025)
   - `claw-code` at `ultraworkers/claw-code` (transferred from `instructkr`), 181k⭐, NO license
   - `goose` at `aaif-goose/goose` (transferred from `block/goose`)
   - Superpowers has ZERO PreToolUse/PostToolUse/Stop hooks — enforcement is prompt-level only
   - `container-use` has NO `.claude/container-use.yaml` — use `cu config` subcommands
   - Fly Sprites has NO `--cpu` / `--disk` flags — 100GB/8CPU are platform defaults
   - Langfuse v3 docker-compose requires MinIO, cannot be dropped
   - Vercel AI Gateway Max-path requires `ANTHROPIC_CUSTOM_HEADERS="x-ai-gateway-api-key: Bearer ..."` (not `ANTHROPIC_API_KEY` alone)
   - Code Review severity jq: `--jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson'`
   - Anthropic subscription plans prohibit scripted/automated use → CI must use API billing
   - Native binary installer is post-axios-DPRK canonical: `curl -fsSL https://claude.ai/install.sh | bash` (not `npm install -g`)
3. **No filtering by profile.** Every component from the corpus that could plausibly earn a slot gets listed in Section 4. No "solo dev skip this" omissions. No "enterprise only" omissions. Dual-tier side-by-side.
4. **Merit-based primary selection.** When bolding a primary pick in each slot, the criterion is corpus-evidenced merit (verified schemas, battle-testing, composability, stars+commits+release-velocity, license clarity), not profile-fit.
5. **No safety disclaimers, no "consult a professional," no hedging.** The user is an adult. Preserve corpus-flagged caveats (`[skeleton]`, `not battle-tested`, `single-sourced`, `could not verify`) verbatim inline — that's evidence, not disclaimer.
6. **No research summarization.** The corpus is the research. The blueprint is architecture. Every paragraph must contain a decision, a connection, an install command, a schema, or a principle — not recapitulation.
7. **Copy-pasteable.** Every file block has a path comment. Every shell command is runnable with clearly named env-var placeholders. Every config matches the verified schemas in Part B.
8. **Integration prose in every slot.** Section 4 cannot be a catalogue. Every slot must say how its components compose with adjacent slots (e.g., observability slot ↔ orchestration slot, sandbox slot ↔ hooks slot).
9. **Self-review required.** Section 10 rates the blueprint against its own Section 2 principles on 1–5. No skipping. If principles trade off, call the trade-off and pick a side.
10. **v2.0 is preserved.** Write to `CLAUDE_CODE_BLUEPRINT_v3.md`, not to the existing `CLAUDE_CODE_BLUEPRINT.md`. The user diffs and decides.

## Non-Goals

- Not a "getting started" or "minimalist" version — v2.0 already fills that role.
- Not a comparison against plain ReAct — corpus Part Q.10 (METR 50.7% finding) is the evidence; acknowledge and move on.
- Not thesis-driven. v2.0's "trust, not capability" framing is explicitly rejected for this document. Not because trust doesn't matter, but because the user is choosing maximal inclusion and will trim downstream.
- Not a revision of v2.0. The new file stands alone. Do not reference v2.0 in the prose except to note where its recommendations appear as alternates.
- Not a re-research pass. Do not fetch URLs, do not hit the web, do not ask for more corpus items. The corpus is closed.
- Not short. Anything under 15k words is a truncation, not a blueprint.
- Not a filter by "what the user probably wants." Include everything that could plausibly earn a slot.

## Acceptance Criteria

- [ ] Document written to `CLAUDE_CODE_BLUEPRINT_v3.md` (not overwriting v2.0)
- [ ] Length between 15,000 and 40,000 words (target 20k–30k)
- [ ] All 10 sections present and non-empty:
  - [ ] §1 Mental Model — 600–1200 words prose, kernel/userland/init framing (or better) with explicit brain↔hands contract
  - [ ] §2 Principles — 10–15 load-bearing opinions, each with (a) bold claim, (b) 1–3 sentence justification citing specific corpus Part, (c) explicit "what it makes impossible"
  - [ ] §3 Full Topology — ASCII diagram(s) showing kernel, every plausible userland component, init system, observability plane, remote services, sandbox boundary, inter-component arrows. Maximal — 40+ boxes target.
  - [ ] §4 Slot Roster — 24 slots (per ARCHITECTURE_PROMPT.md), each slot listing every corpus component with one-line description, stars/version/license/install command where known, primary pick bolded, alternates shown, integration prose connecting to adjacent slots
  - [ ] §5 Integration Recipes — ≥10 concrete wiring recipes with 3–8 steps each, concrete commands, arrows-and-packets. Minimum coverage per ARCHITECTURE_PROMPT.md §5 list.
  - [ ] §6 Decision Trees — mermaid or ASCII flowcharts for: orchestration layer, sandbox per use case, memory system, observability backend, spec tool, Auto Mode vs alternatives, CLAUDE.md vs AGENTS.md vs GEMINI.md vs REVIEW.md
  - [ ] §7 Max Install Playbook — runnable bash script, idempotent, correct dependency order (observability → primitives → orchestration → adjacents → production/CI), works on fresh Linux with `git docker node uv gh python3` pre-installed
  - [ ] §8 Trim-Down Guide — per-slot "remove this, lose X, replace with Y" + priority-ordered trim candidates
  - [ ] §9 Failure Modes — top 10 failure modes with: corpus citation, architectural defense, canary metric, response playbook
  - [ ] §10 Self-Review — walks through each §2 principle, rates architecture against it 1–5, calls out trade-off picks honestly
- [ ] Every slot in §4 contains integration prose, not only a list
- [ ] Every self-hosted orchestration platform from corpus Part E appears in §4 Slot 5 (Paperclip, Ruflo, Vibe-Kanban, Gastown, Multica, Claude Squad, ComposioHQ/agent-orchestrator, claude-mpm, multiclaude, overstory, claude-code-by-agents, claude_code_agent_farm, untra/operator, Claw-Kanban, swarmclaw, praktor, sandstorm, oh-my-claudecode, plus long tail). Comparison table included. Composition-vs-mutual-exclusivity called out.
- [ ] Every MCP server family from Parts D/R appears in §4 Slots 9–17
- [ ] Every sandbox runtime from Part I appears in §4 Slot 18 with decision tree by use case
- [ ] Schema traps are NOT tripped. Spot-check: `model` (not `defaultModel`), `permissions.defaultMode: "acceptEdits"` (not `autoAccept`), MCP location split correct, Spec-Kit install correct, native binary installer headlined.
- [ ] Every strong claim cites a specific corpus Part (e.g., "Part M.2", "Part Q.10", "Part R.4")
- [ ] Corpus-flagged caveats preserved (`[skeleton]`, `not battle-tested`, `single-sourced`, `could not verify`)
- [ ] Document ends with explicit "End of blueprint" marker
- [ ] `CLAUDE_CODE_BLUEPRINT.md` (v2.0) is untouched on disk

## Assumptions Exposed & Resolved

| Assumption | Challenge | Resolution |
|---|---|---|
| v2.0 blueprint's "trust, not capability" thesis is carried forward | User said "MAXIMAL, I will trim" which directly contradicts v2.0's anti-maximalism stance | v3 rejects the thesis framing; v2.0 is preserved as-is for diff |
| Profile fields (stack/OS/deploy/team) need to be filled before the blueprint can be written | User: "ur question is irrelevant ... works for solo and enterprise" and "our thing should work with anything" | Profile is explicitly vertical/stack/tier-agnostic. Merit-based primary selection replaces profile-based selection. |
| Solo-dev is the target reader (inherited from v2.0) | User explicitly said "works for solo and enterprise" | Target reader is "solo operator who builds enterprise-grade output." Both tiers shown first-class. |
| We should filter orchestration platforms to 2–3 primaries | ARCHITECTURE_PROMPT.md §5 explicitly says "Do not collapse 20+ self-hosted orchestration platforms into 'install Paperclip' with a footnote" | Show every platform from Part E with comparison table. |
| Anthropic plan constraint matters | User confirmed Max plan in original prompt | Max plan is the one load-bearing user fact: enables 1M ctx Opus 4.6 beta; blueprint assumes Max-path with separate API key for CI (prompt's "subscription plans prohibit scripted use" trap) |
| v2.0 should be overwritten | Preserving prior work is strictly safer and reversible | Write to v3 file; user decides downstream |

## Technical Context

### Ground truth corpus shape
`RESEARCH_CORPUS.md` Parts (from TOC):
- **A** — Claude Code Platform State (2.1.101, April 2026): release timeline, native primitives, OTel beta, Agent Teams experimental, Managed Agents beta, model routing, revenue signals
- **B** — Verified Configuration Schemas: `settings.json` full key list, hook events (26), plugin manifest, MCP registration, Skill frontmatter, slash-command schema, Agent Teams runtime state
- **C** — Plugin, Skill, and Subagent Ecosystem: official marketplace (101 plugins), awesome lists, VoltAgent/alirezarezvani/mattpocock/Karpathy/JimLiu/Skill_Seekers collections, subagent catalogs
- **D** — MCP Server Ecosystem (Full Roster): code intel, docs/library, browser, GitHub/git, database, memory, observability, search, sandbox bridges
- **E** — Self-Hosted Multi-Agent Orchestration Platforms: Paperclip, Ruflo, Vibe-Kanban, Gastown, Multica, Claude Squad, ComposioHQ/agent-orchestrator, claude-mpm, multiclaude, overstory, claude-code-by-agents, claude_code_agent_farm, untra/operator, Claw-Kanban, swarmclaw, praktor, sandstorm, oh-my-claudecode, 96-project awesome-agent-orchestrators long tail
- **F** — Adjacent Agent Frameworks: Hermes, Letta, CrewAI, Langroid, Microsoft Agent Framework 1.0, LangGraph, Temporal, Airflow, Argo
- **G** — Spec-Driven Development: Spec-Kit, Kiro, Tessl, cc-sdd, gsd-build, OpenSpec, BMAD, Plumb, eforge, OmoiOS, metaskill, claude-agent-builder
- **H** — Execution & Discipline: Superpowers internals, hook library, TDD patterns
- **I** — Sandbox Runtimes: Docker sbx, E2B, Daytona, Modal, container-use, Cloudflare Sandbox SDK, Vercel Sandbox, Fly.io Sprites, Depot, microsandbox, Northflank, trailofbits devcontainer, arrakis, Managed Agents
- **J** — CI/CD and Production Deployment: `claude-code-action@v1`, Code Review managed app, 5 systemprompt.io recipes, GitLab Duo, CircleCI MCP, Buildkite, Dagger, Vercel AI Gateway, preview deploys, ArgoCD/Flux, Temporal/Argo/Airflow with Agent SDK
- **K** — Observability, Memory, Cost, Evaluations: native OTel, Langfuse, Arize Phoenix, Braintrust, LangSmith, Helicone, Honeycomb, Datadog, Grafana, SigNoz, `claude_telemetry`, `anthropics/claude-code-monitoring-guide`, ColeMurray stack, full memory MCP roster
- **L** — Post-Leak Ecosystem and Alternative Clients
- **M** — Incidents, Regressions, Trust Signals: Replit 2.5-year wipeout, axios DPRK supply chain, arxiv 2604.04978 permission gate FN, issue #42796 thrashing, eval awareness strategy drift
- **N** — Workstation: Ghostty/WezTerm/Kitty/iTerm2, tmux/Zellij, zsh/fish + Starship, editors, chezmoi+age/Stow/yadm, git worktrees, claudecode-discord, ocp, agenttray, peon-ping
- **O** — Distilled CLAUDE.md Principles (18 principles)
- **P** — Architecture-Updating Essays: production harness insights, Scaling Managed Agents, Dark Factory, gsd-build, factory model
- **Q** — Research Frontier (arxiv April 2026)
- **R** — Load-Bearing Configuration Examples
- **S** — Consolidated Bibliography

### Architectural framing (inherited from corpus Part A.5 + P)
Anthropic's "Scaling Managed Agents" post defines three primitives: **session** (append-only event log), **harness** (tool loop / brain), **sandbox** (execution substrate / hands). Brain↔hands contract collapses to `execute(name, input) → string`. This framing should structure §1 Mental Model and §3 Topology.

### Execution responsibilities
The executor writing this blueprint must:
- Read `RESEARCH_CORPUS.md` start-to-end once before writing
- Cite corpus Parts, not training data
- Produce a single continuous document in one Write call (135KB/≈33k tokens is within one-shot capability of a 128k-output opus agent)
- Not fetch URLs, not hit the web, not ask follow-up questions
- Not invent components absent from the corpus
- Preserve corpus-flagged caveats verbatim
- Write to `CLAUDE_CODE_BLUEPRINT_v3.md` at the repo root

## Ontology (Key Entities)

| Entity | Type | Fields | Relationships |
|---|---|---|---|
| Blueprint | core domain | sections[10], length, target_path, format | produced from ResearchCorpus, supersedes PriorBlueprint |
| ResearchCorpus | external ground truth | parts[A–S], citations, schemas, verified_facts | consumed by Blueprint |
| Profile | contextual | team_size, stack, deploy, os, plan, risk | rejected as filter; vertical-agnostic stance |
| Slot | sub-component of Blueprint | index[1–24], primary, alternates, integration_prose | filled by corpus components |
| Principle | sub-component of Blueprint | claim, justification, impossible_consequence | referenced by §10 self-review |
| PriorBlueprint | brownfield artifact | version, thesis, path, length | preserved, superseded, not overwritten |
| SoloOperator-EnterpriseOutput | target archetype | (replaces prior solo-dev framing) | drives dual-tier selection |
| DualTier | constraint | solo_track, enterprise_track, shown_side_by_side | shapes every Slot |
| MeritSelection | selection criterion | (verified, battle-tested, composable, licensed) | replaces profile-fit selection |
| VerticalAgnostic | constraint | (no stack/use-case/team filtering) | applied to all 24 slots |

## Ontology Convergence

| Round | Entity Count | New | Changed | Stable | Stability Ratio |
|---|---|---|---|---|---|
| 1 | 6 | 6 | - | - | N/A |
| 2 | 8 | 2 (SoloOperator, DualTier) | 0 | 6 | 75% |
| 3 | 10 | 2 (MeritSelection, VerticalAgnostic) | 0 | 8 | 80% |

Stability converging toward 1.0. The core ontology of the blueprint is stable: Blueprint ← ResearchCorpus (merit-selected, vertical-agnostic, dual-tier) supersedes PriorBlueprint.

## Interview Transcript

<details>
<summary>Full Q&A (3 rounds)</summary>

### Round 1
**Targeted dimension:** Constraint Clarity (score 0.10) — profile is all placeholders
**Q:** "The existing v2.0 blueprint assumes solo dev / Linux / TypeScript / Max and is thesis-driven ('trust, not capability' — rejects maximalism). Your new instruction says 'MAXIMAL, I will trim.' Before I ask about stack/deploy/OS, I need to know the team context because it structurally decides whether Section 4 tilts solo-orchestration (Superpowers + OMC + Paperclip + Agent Teams experimental) or enterprise-orchestration (Managed Agents + ZDR + Code Review managed app + compliance gates). Which describes you?"
**Options offered:** Solo dev (confirm v2.0) / Small team / Enterprise / Solo-SaaS-shipping
**A:** "we want the best ever that works for solo and for entreprise cuz rn we can build entreprise stuff just solo so ur question is irrelevant"
**Interpretation:** User rejects the binary. Target archetype is "solo operator, enterprise-grade output." Dual-tier, not either/or.
**Ambiguity after round:** 38.5%

### Round 2
**Targeted dimension:** Constraint Clarity (still 0.20) — use-case shape is the next gate
**Q:** "Given solo-operator-enterprise-output, the use-case shape decides which slots get headlined as primary picks. Which best describes what you're actually building? Pick the dominant one."
**Options offered:** Generalist dev platform / Ship SaaS to users / Parallel-agent farm / Research-ML heavy
**A:** "our thing should work with anything"
**Interpretation:** User rejects vertical filtering. Blueprint is stack-agnostic, use-case-agnostic, tier-agnostic. Merit-based primary selection replaces profile-fit selection.
**Ambiguity after round:** 19.8% (threshold met)

### Round 3 (scoring only, no question)
Threshold met; ontology converging at 80% stability. Proceeded to crystallize.
</details>

## Rounds-to-answer tally
- Rounds asked: 2 (minimum viable)
- Interview style per user: user rejects binary filters, prefers maximal inclusion, dislikes excessive interviewing. Minimum viable clarification, maximum execution.

## Handoff to Execution
Single document-generation task. The deep-interview → ralplan → autopilot 3-stage pipeline is overkill for a markdown blueprint: ralplan adds consensus refinement of an implementation plan, autopilot adds execution phases for code. Neither maps cleanly to "write one large opinionated markdown doc from a closed corpus." The appropriate execution pattern is **single executor agent (model=opus)** with this spec as input, producing `CLAUDE_CODE_BLUEPRINT_v3.md` in one pass, followed by an optional verifier pass that rates the output against Section 10 self-review criteria and the acceptance checklist above.
