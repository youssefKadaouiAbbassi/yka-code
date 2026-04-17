#!/usr/bin/env bash
# PreToolUse(Bash): gate commands that create PRs or push to a remote branch.
# Blocks pushes to the default branch; warns on missing recent tests; advises
# on oversize diffs. Runs only on specific commands — cheap for everything else.
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

input="$(cat)"
tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty')"

if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

command_str="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
if [[ -z "$command_str" ]]; then
  exit 0
fi

is_pr_create=0
is_push=0
if printf '%s' "$command_str" | grep -qE 'gh[[:space:]]+pr[[:space:]]+create'; then
  is_pr_create=1
fi
if printf '%s' "$command_str" | grep -qE 'git[[:space:]]+push([[:space:]]|$)'; then
  is_push=1
fi

[[ $is_pr_create -eq 0 && $is_push -eq 0 ]] && exit 0

deny() {
  local reason="$1"
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$reason"
  exit 0
}

git rev-parse --is-inside-work-tree &>/dev/null || exit 0

# Check 1: pushing to the default branch.
# Prefer the repo's canonical default (origin/HEAD); if unset, try to resolve it once,
# then fall back to blocking pushes to any common default-branch name.
default_branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || true)"
if [[ -z "$default_branch" ]]; then
  git remote set-head origin --auto &>/dev/null || true
  default_branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || true)"
fi
current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || printf '')"

common_defaults='main master develop trunk'
is_default=0
[[ -n "$default_branch" && "$current_branch" == "$default_branch" ]] && is_default=1
if [[ $is_default -eq 0 ]]; then
  for b in $common_defaults; do
    [[ "$current_branch" == "$b" ]] && { is_default=1; default_branch="$b"; break; }
  done
fi

if [[ $is_push -eq 1 && $is_default -eq 1 ]]; then
  deny "pre-pr-gate: refusing to push directly to default branch '${default_branch}'. Create a feature branch first."
fi

# Check 2: oversize diff advisory (PR creation only)
if [[ $is_pr_create -eq 1 ]]; then
  base="origin/${default_branch}"
  if git rev-parse --verify "$base" &>/dev/null; then
    diff_lines="$(git diff "${base}...HEAD" --shortstat 2>/dev/null | grep -oE '[0-9]+ insertion' | head -1 | grep -oE '[0-9]+' || printf '0')"
    if [[ -n "$diff_lines" ]] && [[ "$diff_lines" -gt 500 ]]; then
      printf 'Advisory: this PR would contain %d+ insertions. Consider splitting into smaller PRs.\n' "$diff_lines" >&2
    fi
  fi
fi

# Check 3: recent-test advisory — look for test invocations in the last 10 min
# via bash history if available. Non-blocking; purely advisory on stderr.
if [[ $is_pr_create -eq 1 ]]; then
  recent_test=0
  for hf in "$HOME/.bash_history" "$HOME/.zsh_history"; do
    [[ -f "$hf" ]] || continue
    if awk -v cutoff="$(date -d '10 minutes ago' '+%s' 2>/dev/null || date -v-10M '+%s' 2>/dev/null || echo 0)" '
      /^: [0-9]+:/ { ts=substr($0,3,index($0,":")-3)+0; if (ts >= cutoff) { found=1 } }
      END { exit !found }
    ' "$hf" 2>/dev/null; then
      recent_test=1
      break
    fi
  done
  # Fall back to a file-mtime probe: if test output files exist and are recent, treat as "tested"
  if [[ $recent_test -eq 0 ]]; then
    for probe in coverage/ .nyc_output/ target/debug/deps/ pytest_cache/ .pytest_cache/; do
      [[ -d "$probe" ]] && [[ -n "$(find "$probe" -mmin -10 -type f 2>/dev/null | head -1)" ]] && { recent_test=1; break; }
    done
  fi
  if [[ $recent_test -eq 0 ]]; then
    printf 'Advisory: no test run detected in the last 10 minutes. Run your test suite before opening the PR.\n' >&2
  fi
fi

exit 0
