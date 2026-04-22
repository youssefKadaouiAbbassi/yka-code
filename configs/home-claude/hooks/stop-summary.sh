#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/_hook-guard.sh" "stop-summary"
source "$(dirname "${BASH_SOURCE[0]}")/_hook-stdin.sh"
# Stop hook: scans recently modified files for debug patterns.
# Advisory only — reports findings but never blocks completion.
# NOTE: no `set -e`, no `pipefail` — grep|head SIGPIPE would otherwise
# kill the script silently and CC reports it as "Failed with non-blocking
# status code: No stderr output". Keep it fault-tolerant end-to-end.
set -u
trap 'exit 0' ERR

read_hook_stdin

# Skip when launched outside a project (e.g., $HOME) — scanning home dir
# floods output with Chrome caches, JSONL transcripts, etc.
if [[ "$PWD" == "$HOME" ]] || [[ ! -d .git && ! -f package.json && ! -f Cargo.toml && ! -f go.mod && ! -f pyproject.toml ]]; then
  exit 0
fi

MAX_FILES=200
MAX_SECONDS=3

mapfile -t recent_files < <(
  timeout "$MAX_SECONDS" find . \
    \( -type d \( -name .git -o -name node_modules -o -name target -o -name .venv -o -name venv -o -name __pycache__ -o -name dist -o -name build -o -name out -o -name coverage -o -name .next -o -name .nuxt -o -name .turbo -o -name .omc -o -name .dev \) -prune \) -o \
    -type f -mmin -5 -print 2>/dev/null \
  | head -n "$MAX_FILES"
) || true

if [[ ${#recent_files[@]} -eq 0 ]]; then
  exit 0
fi

combined='console\.log\s*\(|^\s*debugger\s*;|(\/\/|#)\s*TODO|(\/\/|#)\s*FIXME|pdb\.set_trace\s*\(|binding\.pry|^\s*print\s*\('

hits="$(timeout "$MAX_SECONDS" grep -lEZ "$combined" "${recent_files[@]}" 2>/dev/null | tr '\0' '\n' || true)"

if [[ -n "$hits" ]]; then
  {
    printf '\n=== Stop Hook Advisory: Debug patterns found ===\n'
    while IFS= read -r hit_file; do
      [[ -z "$hit_file" ]] && continue
      printf '%s:\n' "$hit_file"
      grep -nEi "$combined" "$hit_file" 2>/dev/null | head -3 | sed 's/^/  /'
      printf '\n'
    done <<< "$hits"
    printf 'Review these before considering work complete.\n\n'
  } >&2
fi

# Retrospective: did this turn do parallelizable work without firing team-do?
# Two signals: (a) ≥3 distinct edit-files from Write/Edit/MultiEdit, or
# (b) ≥3 Agent() tool-use calls with no TeamCreate. Both mean the turn
# should have been team-do. Advisory only.
if command -v jq >/dev/null 2>&1; then
  transcript="$(printf '%s' "$HOOK_INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || true)"
  if [[ -n "$transcript" && -f "$transcript" ]]; then
    turn_start="$(jq -s '[to_entries[] | select(
      .value.type == "user" and
      ((.value.isMeta // false) == false) and
      (.value.message.content | if type == "array" then all(.[]; .type != "tool_result") else true end)
    )] | (last.key // -1) + 1 | if . < 1 then 1 else . end' "$transcript" 2>/dev/null || echo 1)"
    turn_json="$(sed -n "${turn_start},\$p" "$transcript" 2>/dev/null || true)"

    edit_files="$(printf '%s' "$turn_json" | jq -r '
      select(.type == "assistant")
      | .message.content[]?
      | select(.type == "tool_use" and (.name == "Write" or .name == "Edit" or .name == "MultiEdit"))
      | .input.file_path // empty
    ' 2>/dev/null | sort -u | grep -cv '^$' || echo 0)"

    agent_calls="$(printf '%s' "$turn_json" | jq -r '
      select(.type == "assistant")
      | .message.content[]?
      | select(.type == "tool_use" and .name == "Agent")
      | .name
    ' 2>/dev/null | grep -c '^Agent$' || echo 0)"

    team_used="$(printf '%s' "$turn_json" | jq -r '
      select(.type == "assistant")
      | .message.content[]?
      | select(.type == "tool_use" and (.name == "TeamCreate" or .name == "SendMessage"))
      | .name
    ' 2>/dev/null | head -1 || true)"

    if [[ -z "$team_used" && ( "${edit_files:-0}" -ge 3 || "${agent_calls:-0}" -ge 3 ) ]]; then
      {
        printf '\n=== Team-do Advisory ===\n'
        if [[ "${edit_files:-0}" -ge 3 ]]; then
          printf 'This turn edited %s distinct files with no TeamCreate/SendMessage calls.\n' "$edit_files"
        fi
        if [[ "${agent_calls:-0}" -ge 3 ]]; then
          printf 'This turn spawned %s Agent() calls — that pattern IS team-do.\n' "$agent_calls"
          printf 'team-do gives you the same parallelism PLUS: task list, SendMessage, shutdown protocol,\n'
          printf 'handoff docs that survive compaction, and the reaper hook for cleanup.\n'
        fi
        printf 'Next turn with ≥3 concurrent parcels: route to team-do via /do Phase 2.\n'
        printf 'ToolSearch preload for TeamCreate/SendMessage/TaskCreate is Phase 2''s job now;\n'
        printf 'team-do''s entry cost is zero.\n\n'
      } >&2
    fi
  fi
fi

exit 0
