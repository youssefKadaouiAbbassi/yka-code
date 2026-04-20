#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/_hook-guard.sh" "session-start-yka-update-check"
set -u
trap 'exit 0' ERR

[[ "${YKA_UPDATE_NOTIFY:-1}" == "0" ]] && exit 0

command -v curl >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

journal="${YKA_CODE_JOURNAL_PATH:-$HOME/.config/yka-code/install.json}"
[[ -f "$journal" ]] || exit 0

installed_at="$(jq -r '.installedAt // empty' "$journal" 2>/dev/null)"
[[ -z "$installed_at" ]] && exit 0

now_epoch="$(date +%s)"
installed_epoch="$(date -d "$installed_at" +%s 2>/dev/null || echo 0)"
(( now_epoch - installed_epoch < 86400 )) && exit 0

response="$(curl -sf --max-time 3 \
  -H 'Accept: application/vnd.github+json' \
  "https://api.github.com/repos/youssefKadaouiAbbassi/yka-code/commits?since=${installed_at}&per_page=100" 2>/dev/null)"
[[ -z "$response" ]] && exit 0

count="$(printf '%s' "$response" | jq 'length' 2>/dev/null)"
[[ -z "$count" || "$count" == "0" || "$count" == "null" ]] && exit 0

latest_msg="$(printf '%s' "$response" | jq -r '.[0].commit.message // ""' 2>/dev/null | head -1)"
installed_date="${installed_at%%T*}"

banner="[yka-code] update available — ${count} new commit(s) since ${installed_date}."
[[ -n "$latest_msg" ]] && banner+=$'\n'"Latest: \"${latest_msg}\""
banner+=$'\n'"Run \`yka-code-setup update\` to pull."

python3 - "$banner" <<'PY' 2>/dev/null || true
import json, sys
print(json.dumps({"systemMessage": sys.argv[1]}))
PY

exit 0
