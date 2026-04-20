# yka-code — local dev

Thin README while the system is in flux. Real README comes later.

## Prereqs

- Bun ≥ 1.2 (`curl -fsSL https://bun.sh/install | bash`)
- Claude Code CLI (`npm i -g @anthropic-ai/claude-code` — ≥ v2.1.32 for agent teams)
- `gh` CLI authenticated (for plugin + skills.sh fetches)

## Install from this working tree — nuke and pave, full tier

One command. Wipes `~/.claude/` (auto-backup first), installs everything we have, no prompts.

```bash
bun install
bun run bin/setup.ts --clean-install --yes-wipe --non-interactive --tier all --global
```

That's it. Auto-backup lands in `~/.claude-backup/<timestamp>/` — run `bun run bin/setup.ts restore` to roll back.

Runs directly from source; no npm publish needed.

### If you want to preview first

```bash
bun run bin/setup.ts --dry-run --non-interactive --tier all --global
```

No filesystem writes — just prints what would happen.

## Subcommands

```bash
bun run bin/setup.ts setup    # (default) install / re-install
bun run bin/setup.ts update   # git pull + replay setup + refresh plugins
bun run bin/setup.ts status   # what's installed, what's missing
bun run bin/setup.ts restore  # roll back to pre-install backup
bun run bin/setup.ts hooks    # list / disable / enable individual hooks
```

First-time users: `--clean-install` (backs up existing `~/.claude/`, installs fresh). Non-first-time: default or `--add-on-top`.

## Running tests

```bash
bun test                        # full suite (~300 tests)
bun test tests/unit             # unit only
bun test tests/integration      # integration only
bun tsc --noEmit                # typecheck
bun run lint:hooks              # shellcheck on hook scripts
```

## Build a standalone binary

```bash
bun run build             # → dist/yka-code-setup (compiled bun binary)
bun run build:npm         # → dist/ as npm-publishable ES module
```

## Uninstall

```bash
bun run bin/setup.ts restore   # rolls back ~/.claude/ to pre-install state
```

Or manually: `rm -rf ~/.claude/skills ~/.claude/hooks ~/.claude/commands ~/.claude/agents`, restore `~/.claude/settings.json` from `~/.claude-backup/<timestamp>/`.
