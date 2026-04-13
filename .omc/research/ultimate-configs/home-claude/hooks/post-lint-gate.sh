#!/usr/bin/env bash
# PostToolUse hook: Run linter/formatter on edited files.
# Runs after every Write/Edit. Reports errors but does not block (exit 0).
# The agent sees the output and should fix issues before continuing.

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

EXTENSION="${FILE_PATH##*.}"
DIR=$(dirname "$FILE_PATH")

# Walk up to find project root (look for package.json, Cargo.toml, go.mod, pyproject.toml)
PROJECT_ROOT=""
SEARCH_DIR="$DIR"
while [ "$SEARCH_DIR" != "/" ]; do
  for marker in package.json Cargo.toml go.mod pyproject.toml Makefile; do
    if [ -f "$SEARCH_DIR/$marker" ]; then
      PROJECT_ROOT="$SEARCH_DIR"
      break 2
    fi
  done
  SEARCH_DIR=$(dirname "$SEARCH_DIR")
done

if [ -z "$PROJECT_ROOT" ]; then
  exit 0
fi

cd "$PROJECT_ROOT"

case "$EXTENSION" in
  ts|tsx|js|jsx|mjs|cjs)
    # Try biome first, then eslint
    if [ -f "biome.json" ] || [ -f "biome.jsonc" ]; then
      npx biome check "$FILE_PATH" 2>&1 | tail -20 || true
    elif [ -f ".eslintrc.json" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.cjs" ] || [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ]; then
      npx eslint "$FILE_PATH" --no-error-on-unmatched-pattern 2>&1 | tail -20 || true
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      ruff check "$FILE_PATH" 2>&1 | tail -20 || true
    elif command -v flake8 &>/dev/null; then
      flake8 "$FILE_PATH" 2>&1 | tail -20 || true
    fi
    ;;
  rs)
    if [ -f "Cargo.toml" ]; then
      cargo clippy --quiet --message-format=short 2>&1 | grep -i "error\|warning" | head -20 || true
    fi
    ;;
  go)
    if [ -f "go.mod" ]; then
      go vet "$FILE_PATH" 2>&1 | tail -10 || true
    fi
    ;;
esac

exit 0
