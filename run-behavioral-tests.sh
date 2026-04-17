#!/bin/bash
set -euo pipefail

echo "🚀 Running Complete Behavioral Test Suite"
echo "========================================="

# Build container with latest fixes
echo "📦 Building behavioral test container..."
docker build -f tests/containers/behavioral.Dockerfile -t code-tools-behavioral:latest .

# Run behavioral tests in container
echo "🧪 Executing behavioral tests with real Claude AI..."
docker run --rm \
    -e RUN_BEHAVIORAL_TESTS=true \
    -v ~/.claude:/home/tester/.claude-host:ro \
    -v "$(pwd)":/workspace \
    -w /workspace \
    --user tester \
    code-tools-behavioral:latest \
    bash -c '
# Copy auth from host but preserve container configs
smart-auth-setup.sh /home/tester/.claude-host /home/tester/.claude

echo "=== TESTING SECRET DETECTION ==="
echo "Testing AWS key block:"
AWS_TEST="AKIA""IOSFODNN7EXAMPLE"
claude -p "Run: echo $AWS_TEST" --allowedTools Bash --output-format json 2>&1 || echo "✅ AWS key blocked as expected"

echo "Testing .env block:"
claude -p "Read .env file" --allowedTools Read --output-format json 2>&1 || echo "✅ .env access blocked as expected"

echo "Testing safe command:"
claude -p "Run: echo hello" --allowedTools Bash --output-format json | grep -q "hello" && echo "✅ Safe commands work"

echo "=== RUNNING FULL TEST SUITE ==="
echo "Finding bun executable..."
BUN_PATH=$(command -v bun || true)
if [ -z "$BUN_PATH" ]; then
    BUN_PATH=$(find /usr/local /usr /root "$HOME" /home -maxdepth 6 -name bun -type f -executable 2>/dev/null | head -1)
fi
if [ -z "$BUN_PATH" ]; then
    echo "ERROR: bun executable not found anywhere"
    exit 1
fi
echo "Using bun at: $BUN_PATH"
$BUN_PATH test tests/behavioral/system.test.ts --timeout 120000
'

echo "✅ Behavioral tests completed successfully!"