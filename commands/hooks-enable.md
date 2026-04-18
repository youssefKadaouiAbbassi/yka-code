---
description: [yka-code] Re-enable a yka-code hook. Use "all" to clear every disable. Usage: /hooks-enable pre-pr-gate
allowed-tools: Bash
argument-hint: <hook-name> | all
---

# /hooks-enable

Re-enable the named hook by removing it from `~/.claude/yka-hooks-disabled`.

**Hook name:** `$ARGUMENTS`

If `$ARGUMENTS` is empty, tell the user to provide a hook name (e.g. `pre-pr-gate`) or `all` to clear every disable, then stop.

Otherwise run:

```bash
yka-code-setup hooks enable $ARGUMENTS 2>/dev/null || bunx --bun @youssefKadaouiAbbassi/yka-code-setup hooks enable $ARGUMENTS
```

Show the output verbatim. No further action.
