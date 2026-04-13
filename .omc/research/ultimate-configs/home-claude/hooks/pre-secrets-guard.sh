#!/usr/bin/env bash
# PreToolUse hook: Prevent writing secrets into source files.
# Scans Write/Edit tool input for patterns that look like secrets.

set -euo pipefail

INPUT=$(cat)
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // empty' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ -z "$CONTENT" ]; then
  exit 0
fi

# Skip known safe files
case "$FILE_PATH" in
  *.md|*.txt|*.json.example|*.env.example|*/.gitignore)
    exit 0
    ;;
esac

# Block writing to secret files
case "$FILE_PATH" in
  *.env|*.env.*|*credentials*|*secrets*|*.pem|*.key|*.p12|*.pfx)
    echo "BLOCKED: Attempted to write to sensitive file: $FILE_PATH"
    echo "Use .env.example for documenting required variables."
    exit 2
    ;;
esac

# Secret patterns to detect in content
SECRET_PATTERNS=(
  # AWS
  'AKIA[0-9A-Z]{16}'
  # Generic long tokens (base64-like, 40+ chars)
  'sk-[a-zA-Z0-9]{20,}'
  'ghp_[a-zA-Z0-9]{36}'
  'gho_[a-zA-Z0-9]{36}'
  'github_pat_[a-zA-Z0-9_]{22,}'
  'glpat-[a-zA-Z0-9_-]{20}'
  'xoxb-[0-9]{10,}-[0-9]{10,}-[a-zA-Z0-9]{24}'
  'xoxp-[0-9]{10,}-[0-9]{10,}-[a-zA-Z0-9]{24}'
  'SG\.[a-zA-Z0-9_-]{22}\.[a-zA-Z0-9_-]{43}'
  'sk_live_[0-9a-zA-Z]{24,}'
  'rk_live_[0-9a-zA-Z]{24,}'
  'pk_live_[0-9a-zA-Z]{24,}'
  'sntrys_[a-zA-Z0-9]{60,}'
  # Private keys
  '-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----'
  '-----BEGIN PGP PRIVATE KEY BLOCK-----'
)

for pattern in "${SECRET_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qE "$pattern"; then
    echo "BLOCKED: Content appears to contain a secret matching pattern: ${pattern:0:30}..."
    echo "Never hardcode secrets in source files. Use environment variables."
    exit 2
  fi
done

exit 0
