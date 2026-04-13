#!/usr/bin/env bash
# SessionStart hook: Load context and inject memory at session start.
# Outputs context information that gets injected into the session.

set -euo pipefail

echo "=== Session Context ==="
echo "Date: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "Host: $(hostname)"
echo "Dir: $(pwd)"

# Show git context if in a repo
if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  echo ""
  echo "=== Git Context ==="
  echo "Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  echo "Last commit: $(git log -1 --format='%h %s' 2>/dev/null)"
  DIRTY=$(git status --porcelain 2>/dev/null | wc -l)
  echo "Uncommitted changes: $DIRTY files"

  if [ "$DIRTY" -gt 0 ]; then
    echo ""
    echo "Changed files:"
    git status --porcelain 2>/dev/null | head -20
  fi
fi

# Load lessons if they exist
LESSONS_FILE=".claude/lessons.md"
if [ -f "$LESSONS_FILE" ]; then
  LESSON_COUNT=$(grep -c "^-\|^##" "$LESSONS_FILE" 2>/dev/null || echo "0")
  echo ""
  echo "=== Lessons Loaded ==="
  echo "$LESSON_COUNT lessons from $LESSONS_FILE"
  echo "Review these before starting work."
fi

# Load project memory if it exists
MEMORY_FILE=".claude/memory.md"
if [ -f "$MEMORY_FILE" ]; then
  echo ""
  echo "=== Project Memory ==="
  head -30 "$MEMORY_FILE"
fi

# Warn about active worktrees
if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  WORKTREE_COUNT=$(git worktree list 2>/dev/null | wc -l)
  if [ "$WORKTREE_COUNT" -gt 1 ]; then
    echo ""
    echo "=== Active Worktrees ==="
    git worktree list 2>/dev/null
  fi
fi

exit 0
