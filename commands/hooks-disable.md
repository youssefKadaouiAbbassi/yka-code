---
description: [yka-code] Disable a yka-code hook persistently (state file). Use "all" for kill-switch. Usage: /hooks-disable pre-pr-gate
allowed-tools: Bash
argument-hint: <hook-name> | all
---

# /hooks-disable

Disable the named hook by appending it to `~/.claude/yka-hooks-disabled`. Persists until re-enabled.

**Hook name:** `$ARGUMENTS`

If `$ARGUMENTS` is empty, tell the user to provide a hook name (e.g. `pre-pr-gate`) or `all`, then stop.

Otherwise run:

```bash
yka-code-setup hooks disable $ARGUMENTS 2>/dev/null || bunx --bun @youssefKadaouiAbbassi/yka-code-setup hooks disable $ARGUMENTS
```

Show the output verbatim. No further action.

## One-shot alternative (when the user wants bypass for a single command, no persistent state)

Suggest: `YKA_HOOKS_BYPASS=<name> <their-command>` — hook exits 0 for that invocation only.
