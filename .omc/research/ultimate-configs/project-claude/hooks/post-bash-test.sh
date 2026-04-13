#!/usr/bin/env bash
# Project-level PostToolUse hook: Auto-run tests after Bash commands that modify code.
# Only triggers after build/compile commands, not after every bash invocation.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_result.exit_code // "0"' 2>/dev/null)

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Only auto-test after commands that are likely to have changed compiled output
# Skip if the previous command already failed
if [ "$EXIT_CODE" != "0" ]; then
  exit 0
fi

# Customize: uncomment and adjust for your project
# Patterns that should trigger a test run:
# case "$COMMAND" in
#   *"npm run build"*|*"pnpm build"*|*"cargo build"*|*"go build"*|*"make"*)
#     echo "Build completed. Running quick test suite..."
#     # npm test -- --run 2>&1 | tail -20 || true
#     # cargo test 2>&1 | tail -20 || true
#     # go test ./... 2>&1 | tail -20 || true
#     ;;
# esac

exit 0
