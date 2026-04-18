---
description: [yka-code] Show which yka-code hooks are currently enabled vs disabled (state file + YKA_HOOKS_BYPASS env var).
allowed-tools: Bash
---

# /hooks-list

Run:

```bash
yka-code-setup hooks list 2>/dev/null || bunx --bun @youssefKadaouiAbbassi/yka-code-setup hooks list
```

Show the output verbatim. No further action.
