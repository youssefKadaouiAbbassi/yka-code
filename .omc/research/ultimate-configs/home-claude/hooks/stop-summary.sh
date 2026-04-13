#!/usr/bin/env bash
# Stop hook: Runs when the agent stops (completes or hits an error).
# Checks for leftover debug code and uncommitted changes.

set -euo pipefail

# Check for debug code in recently modified files
if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  CHANGED_FILES=$(git diff --name-only --diff-filter=ACMR HEAD 2>/dev/null || true)

  if [ -n "$CHANGED_FILES" ]; then
    DEBUG_FOUND=""
    while IFS= read -r file; do
      if [ -f "$file" ]; then
        # Check for common debug patterns
        HITS=$(grep -n "console\.log\|debugger\|FIXME\|HACK\|XXX\|TODO.*REMOVE\|binding\.pry\|import pdb\|breakpoint()" "$file" 2>/dev/null || true)
        if [ -n "$HITS" ]; then
          DEBUG_FOUND="${DEBUG_FOUND}\n${file}:\n${HITS}\n"
        fi
      fi
    done <<< "$CHANGED_FILES"

    if [ -n "$DEBUG_FOUND" ]; then
      echo "WARNING: Debug code found in changed files:"
      echo -e "$DEBUG_FOUND"
      echo ""
      echo "Clean these up before committing."
    fi
  fi

  # Report uncommitted changes
  UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l)
  if [ "$UNCOMMITTED" -gt 0 ]; then
    echo ""
    echo "Note: $UNCOMMITTED uncommitted file(s). Remember to commit or stash."
  fi
fi

exit 0
