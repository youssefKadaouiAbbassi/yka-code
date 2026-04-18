# Deferred: post-lint-gate → PreToolUse "ask" mode

**Status:** Plan only. Current `post-lint-gate.sh` is advisory (stderr only); upgrading to PreToolUse "ask" mode requires a minimum CC version that isn't currently verifiable.

## Today's flow

`post-lint-gate.sh` fires on `PostToolUse` with matcher `Write|Edit|MultiEdit`. After the edit lands, it runs eslint/ruff/shellcheck/clippy/govet and emits warnings to stderr. Claude sees the warning in the tool output and MAY fix — no enforcement.

## Target flow ("ask" + updatedInput)

Research (2026-04-18) confirmed `PreToolUse` supports `permissionDecision: "ask"` + an `updatedInput` field. With this, the hook could:

1. Run the linter BEFORE the edit (on the proposed new file content)
2. If lint would fail → return `{permissionDecision: "ask", updatedInput: <auto-fixed-content>}`
3. User sees: "Linter found N issues, Claude wants to edit with this auto-fixed version instead — accept?"

**Better UX** than post-hoc warnings. Enforces lint before bad code lands.

## Why deferred

The research subagent confirmed the feature exists but **did NOT confirm a minimum CC version** that supports `"ask"` + `updatedInput`. Shipping this without a version check risks:

- On older CC: hook returns `"ask"`, CC treats as unknown → undefined behavior (may block edit entirely, may crash, may silently fall through)
- Can't reliably gate: `claude --version` parsing works, but we'd need to know the exact minimum version

Wire this only after:
1. Identifying the minimum CC version that supports `"ask"` + `updatedInput` (probably deepwiki-queryable once the CHANGELOG indexes it)
2. Hardcoding that minimum in the hook script itself (`claude --version | ...` check at top)
3. Falling back to the current post-hoc flow on older CC

## Harness

When ready, run eval against the SAME edit on:
- CC N-2 (expect: falls back to post-hoc advisory)
- CC N-1
- CC N (latest; expect: full "ask" + auto-fix flow)

All three should produce valid output (not crash). Only latest should show the "ask" dialog.

## What to write

`configs/hooks/pre-lint-gate.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Version check: require CC >= X.Y.Z for "ask" mode
cc_ver="$(claude --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo '0.0.0')"
MIN_VER="X.Y.Z"  # fill in once confirmed
if ! printf '%s\n%s\n' "$MIN_VER" "$cc_ver" | sort -V | head -1 | grep -qx "$MIN_VER"; then
  # Older CC — defer to post-lint-gate's post-hoc flow
  exit 0
fi

# ... lint the proposed edit ...
# ... if fails: return {permissionDecision: "ask", updatedInput: fixed_content} ...
```

Then register in `hook-registry.ts` as PreToolUse with matcher `Write|Edit|MultiEdit`, and remove/deprecate `post-lint-gate.sh`.

## Hard rule

Until the minimum CC version is pinned, **do not remove post-lint-gate.sh**. Users on older CC need the advisory flow.
