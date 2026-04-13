#!/usr/bin/env bash
# PreToolUse hook: Block destructive Bash commands.
# Runs on every Bash tool invocation. Exits non-zero to block the command.
# Claude Code passes tool input as JSON on stdin.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Destructive filesystem patterns
DESTRUCTIVE_PATTERNS=(
  'rm -rf /'
  'rm -rf /\*'
  'rm -rf ~'
  'rm -rf \$HOME'
  'rm -rf \.'
  'sudo rm -rf'
  'chmod -R 777 /'
  'mkfs\.'
  'dd if=/dev/zero'
  'dd if=/dev/random'
  '> /dev/sd'
  'mv .* /dev/null'
)

# Infrastructure destruction patterns
INFRA_PATTERNS=(
  'terraform destroy'
  'terraform apply.*-auto-approve'
  'pulumi destroy'
  'kubectl delete (namespace|ns|all)'
  'kubectl delete -A'
  'helm uninstall.*--no-hooks'
  'aws .* delete'
  'gcloud .* delete'
  'az .* delete'
)

# Database destruction patterns
DB_PATTERNS=(
  'DROP DATABASE'
  'DROP SCHEMA.*CASCADE'
  'DROP TABLE.*CASCADE'
  'TRUNCATE'
  'DELETE FROM .* WHERE 1'
  'DELETE FROM [^W]*$'
)

# Git destruction patterns
GIT_PATTERNS=(
  'git push --force origin (main|master)'
  'git push -f origin (main|master)'
  'git reset --hard'
  'git clean -fdx'
  'git branch -D'
  'git checkout -- \.'
  'git restore \.'
)

# System patterns
SYSTEM_PATTERNS=(
  'shutdown'
  'reboot'
  'halt'
  'init [06]'
  'systemctl (stop|disable|mask)'
  'kill -9 -1'
  'killall'
)

# Pipe-to-shell patterns
PIPE_PATTERNS=(
  'curl.*\| *sh'
  'curl.*\| *bash'
  'wget.*\| *sh'
  'wget.*\| *bash'
)

check_patterns() {
  local patterns=("$@")
  for pattern in "${patterns[@]}"; do
    if echo "$COMMAND" | grep -qEi "$pattern"; then
      echo "BLOCKED: Destructive command detected matching pattern: $pattern"
      echo "Command was: $COMMAND"
      echo "This command requires explicit human approval. Ask the user to run it manually."
      exit 2
    fi
  done
}

check_patterns "${DESTRUCTIVE_PATTERNS[@]}"
check_patterns "${INFRA_PATTERNS[@]}"
check_patterns "${DB_PATTERNS[@]}"
check_patterns "${GIT_PATTERNS[@]}"
check_patterns "${SYSTEM_PATTERNS[@]}"
check_patterns "${PIPE_PATTERNS[@]}"

exit 0
