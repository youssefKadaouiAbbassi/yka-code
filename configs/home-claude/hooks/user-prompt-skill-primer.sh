#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/_hook-guard.sh" "user-prompt-skill-primer"
source "$(dirname "${BASH_SOURCE[0]}")/_hook-stdin.sh"
set -euo pipefail
trap 'rc=$?; [ $rc -ne 0 ] && echo "[user-prompt-skill-primer] rc=$rc line=$LINENO" >&2; exit 0' ERR

command -v jq >/dev/null 2>&1 || exit 0

read_hook_stdin

prompt="$(printf '%s' "$HOOK_INPUT" | jq -r '.prompt // empty' 2>/dev/null)"
[[ -z "$prompt" ]] && exit 0

if ! printf '%s' "$prompt" | grep -qiE '\b(build|implement|add|ship|fix|refactor|audit|review|write|create|debug|migrate|port|extract|dedupe|simplify|clean.up|update|change|modify|delete|remove|rename|upgrade|bump|replace|optimize|improve|edit|wire|bug|broken)'; then
  exit 0
fi

base_loaded="false"
transcript="$(printf '%s' "$HOOK_INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)"
if [[ -n "$transcript" && -f "$transcript" ]]; then
  base_loaded="$(jq -rs '
    [.[] | select(.type == "assistant") | .message.content[]? |
     select(.type == "tool_use" and .name == "Skill") | .input.skill] |
    any(. == "karpathy-guidelines" or . == "coding-style")
  ' "$transcript" 2>/dev/null || echo false)"
fi

tdd_required="no"
if printf '%s' "$prompt" | grep -qiE '\b(implement|build|design|create|write).*\b(class|function|algorithm|parser|validator|reducer|middleware|handler|rate.?limiter|cache|queue|scheduler|state.?machine|fsm|protocol|codec|compiler|interpreter|serializer|encoder|decoder|hash|crypt|auth|guard|policy|router)' \
  || printf '%s' "$prompt" | grep -qiE '\b(correctness.?critical|infrastructure code|production code|core logic|business logic|security.?sensitive|concurrent|thread.?safe|atomic)\b' \
  || printf '%s' "$prompt" | grep -qiE '\b(fix|regression).*\b(bug|crash|error|failing test)'; then
  tdd_required="yes"
fi

multi_file="no"
if printf '%s' "$prompt" | grep -qiE '\b(multi.?file|across|refactor|reorganize|audit|review|build.*system|redesign|plan and implement)' \
  || [[ "$tdd_required" == "yes" ]]; then
  multi_file="yes"
fi

fuzzy_scope="no"
if printf '%s' "$prompt" | grep -qiE '\b(rough idea|thinking (of|about)|maybe we should|not sure yet|figure out|something like|brainstorm|explore options|weigh tradeoffs|tradeoffs|kinda want|want to maybe)\b'; then
  fuzzy_scope="yes"
fi

plan_first="no"
if [[ "$multi_file" == "yes" || "$fuzzy_scope" == "yes" ]]; then
  plan_first="yes"
fi

block_a=""
if [[ "$base_loaded" != "true" ]]; then
  block_a="### Base pair (load once per session)

Before your FIRST Bash/Edit/Write/Read tool call, invoke in parallel:

- \`Skill(skill: \"karpathy-guidelines\")\`
- \`Skill(skill: \"coding-style\")\`

"
fi

block_b="### Per-turn task-shape reminders

"

if [[ "$plan_first" == "yes" ]]; then
  if [[ "$fuzzy_scope" == "yes" ]]; then
    block_b+="- **Plan first — scope is fuzzy.** Invoke \`Skill(skill: \"brainstorming\")\` to produce a short spec at \`tasks/specs/<date>-<topic>.md\` BEFORE any edit. Alternative: call \`EnterPlanMode\` to draft a plan for user approval, then \`ExitPlanMode\` once approved. Do not begin implementation without agreed scope.
"
  else
    block_b+="- **Plan first — multi-file scope.** For work spanning ≥2 files or ≥2 subsystems: call \`EnterPlanMode\` to draft an implementation plan for user approval BEFORE any Edit/Write, then \`ExitPlanMode\` once approved. Alternative: \`Skill(skill: \"brainstorming\")\` for spec-first scoping if the shape is still unclear.
"
  fi
fi

if [[ "$multi_file" == "yes" ]]; then
  block_b+="- **Classify via /do.** Invoke \`Skill(skill: \"do\")\` — it routes to the right sub-workflow (ship-feature / fix-bug / refactor-safely / security-audit / onboard-codebase) and decides whether team-do should fire for parallel multi-subsystem work.
"
fi

if [[ "$tdd_required" == "yes" ]]; then
  block_b+="- **TDD (red → green → refactor).** Invoke \`Skill(skill: \"test-driven-development\")\` BEFORE writing the production implementation. Required for correctness-critical paths, net-new classes/algorithms, bug regressions, and anywhere \"it works\" is ambiguous without tests.
"
fi

block_b+="- **Done-gate (non-negotiable).** Before emitting ANY claim of completion (\"done\", \"complete\", \"shipped\", \"passes\", \"ready\", \"fixed\", \"works\", \"all good\", a checkmark, \"lgtm\") AFTER any \`Write\` / \`Edit\` / \`MultiEdit\` this turn, invoke \`Skill(skill: \"verification-before-completion\")\`. The upstream iron-law self-challenge re-runs verification and produces fresh evidence. The \`stop-verification-check.sh\` hook emits a post-hoc advisory if you skip.
"

injection="## Skill invocation directive (injected by yka-code hook)

${block_a}${block_b}
These are requirements, not suggestions."

if command -v python3 >/dev/null 2>&1; then
  python3 - "$injection" <<'PY' 2>/dev/null || true
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": sys.argv[1]}}))
PY
else
  printf '%s' "$injection" | jq -Rs --arg event "UserPromptSubmit" '{hookSpecificOutput: {hookEventName: $event, additionalContext: .}}'
fi

exit 0
