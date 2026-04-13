#!/usr/bin/env bash
# SessionEnd hook: Save session metadata, extract decisions, log metrics.

set -euo pipefail

SESSION_LOG_DIR="${HOME}/.claude/session-logs"
mkdir -p "$SESSION_LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')
SESSION_FILE="$SESSION_LOG_DIR/$TIMESTAMP.log"

{
  echo "=== Session End: $TIMESTAMP ==="
  echo "Directory: $(pwd)"

  if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    echo "Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    echo ""
    echo "Commits this session:"
    # Show commits from the last 4 hours (typical session)
    git log --since="4 hours ago" --oneline 2>/dev/null | head -20 || echo "(none)"
    echo ""
    echo "Files changed this session:"
    git diff --name-only HEAD~5 HEAD 2>/dev/null | head -30 || echo "(none)"
  fi
} > "$SESSION_FILE" 2>&1

# Rotate logs: keep last 100 sessions
ls -t "$SESSION_LOG_DIR"/*.log 2>/dev/null | tail -n +101 | xargs rm -f 2>/dev/null || true

exit 0
