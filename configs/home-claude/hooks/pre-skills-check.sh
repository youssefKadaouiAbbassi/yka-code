#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/_hook-guard.sh" "pre-skills-check"
source "$(dirname "${BASH_SOURCE[0]}")/_hook-stdin.sh"
set -euo pipefail
trap 'rc=$?; [ $rc -ne 0 ] && echo "[pre-skills-check] rc=$rc line=$LINENO" >&2; exit 0' ERR

command -v jq >/dev/null 2>&1 || exit 0

read_hook_stdin

tool_name="$(printf '%s' "$HOOK_INPUT" | jq -r '.tool_name // empty' 2>/dev/null)"
case "$tool_name" in
  Bash|Edit|Write|MultiEdit) ;;
  *) exit 0 ;;
esac

transcript="$(printf '%s' "$HOOK_INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)"
[[ -z "$transcript" || ! -f "$transcript" ]] && exit 0

skill_seen="$(jq -rs '
  [.[] | select(.type == "assistant") | .message.content[]? |
   select(.type == "tool_use" and .name == "Skill") | .input.skill] |
  any(. == "karpathy-guidelines" or . == "coding-style")
' "$transcript" 2>/dev/null || echo false)"
[[ "$skill_seen" == "true" ]] && exit 0

turn_start="$(jq -s '[to_entries[] | select(
  .value.type == "user" and
  ((.value.isMeta // false) == false) and
  (.value.message.content | if type == "array" then all(.[]; .type != "tool_result") else true end)
)] | (last.key // -1) + 1 | if . < 1 then 1 else . end' "$transcript" 2>/dev/null || echo 1)"
: "${turn_start:=1}"

turn_json="$(sed -n "${turn_start},\$p" "$transcript")"

user_prompt="$(printf '%s\n' "$turn_json" | head -1 | jq -r '
  if .type == "user" then
    if (.message.content | type) == "string" then .message.content
    else (.message.content | map(select(.type == "text").text) | join(" "))
    end
  else empty end
' 2>/dev/null || true)"
[[ -z "$user_prompt" ]] && exit 0

if ! printf '%s' "$user_prompt" | grep -qiE '\b(build|implement|add|ship|fix|refactor|audit|review|write|create|debug|migrate|port|extract|dedupe|simplify|clean.up|update|change|modify|delete|remove|rename|upgrade|bump|replace|optimize|improve|edit|wire|bug|broken)'; then
  exit 0
fi

cat >&2 <<'EOF'
=== yka-code PreToolUse block ===
This turn involves code work and you have not invoked Skill(karpathy-guidelines) or Skill(coding-style) yet.

Before your first Bash/Edit/Write/MultiEdit call, you MUST invoke:
  Skill(skill: "karpathy-guidelines")
  Skill(skill: "coding-style")

Invoke them, then retry this tool call.
EOF
exit 2
