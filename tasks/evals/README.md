# Deferred evaluation plans

Side-by-side comparisons and deferred feature work from the 2026-04-18 stack audit that need real data (not training-data vibes) before execution.

Run each with the `evals-first` skill's harness: spawn `claude -p` via `Bun.spawnSync` (Claude Max subscription, NOT Anthropic SDK), `--output-format json`, no `--bare` flag.

## Pending evals

| File | Compare | Decide |
|---|---|---|
| `docfork-vs-context7.md` | docfork (current) vs Context7 (53k stars, free tier) | Keep docfork / swap / run both |
| `composio-vs-arcade.md` | Composio (current, working) vs arcade-mcp | Keep composio / swap / run both |
| `container-use-vs-dagger.md` | container-use (current) vs Dagger direct | Migration plan |

## Deferred feature work

| File | Why deferred |
|---|---|
| `secrets-to-sops-migration.md` | Working config; reshape is multi-subsystem (rc + claude launch + chezmoi) |
| `post-lint-gate-ask-mode.md` | No minimum CC version verified for PreToolUse `"ask"` + `updatedInput` |
| `oxc-language-server-add.md` | Distribution path shifted (removed from oxlint npm v1.37.0) |

Each doc is self-contained: question, fixtures, pass criteria, rollout plan.
