#!/usr/bin/env bash
# Project-level PostToolUse hook: Run project linter after file edits.
# Customize the lint command for your project's toolchain.

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

EXTENSION="${FILE_PATH##*.}"

# Customize these commands for your project:
case "$EXTENSION" in
  ts|tsx|js|jsx|mjs|cjs)
    # Option A: Biome (fast, recommended)
    # npx biome check "$FILE_PATH" 2>&1 | tail -20 || true

    # Option B: ESLint + Prettier
    # npx eslint "$FILE_PATH" 2>&1 | tail -20 || true

    # Option C: TypeScript type-check (slower but catches type errors)
    # npx tsc --noEmit 2>&1 | grep -i "error" | head -10 || true
    ;;
  py)
    # ruff check "$FILE_PATH" 2>&1 | tail -20 || true
    # python -m mypy "$FILE_PATH" 2>&1 | tail -10 || true
    ;;
  rs)
    # cargo clippy --quiet 2>&1 | head -20 || true
    ;;
  go)
    # go vet ./... 2>&1 | tail -10 || true
    ;;
esac

exit 0
