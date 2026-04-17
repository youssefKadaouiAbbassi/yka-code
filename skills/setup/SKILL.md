---
name: setup
description: [yka-code] Install or update the Ultimate Claude Code System. Use when the user asks to set up, install, bootstrap, or reinstall the yka-code harness (hooks, MCP servers, skills, plugins, shell rc).
---

# Setup Skill

Launches the `yka-code-setup` CLI installer.

## Usage

Run `bunx @youssefKadaouiAbbassi/yka-code-setup` (or `bun run bin/setup.ts` from this repo).

What it does:

1. Scans the environment (OS, shell, package manager, existing tools)
2. Asks scope (global `~/.claude/` or local `./.claude/`) + install mode (clean / add-on-top / fresh)
3. Installs primordial core (settings.json, CLAUDE.md, hooks, tmux, starship, mise, just, etc.)
4. Prompts for categories (Code Intelligence, Browser+Web, Memory, Security, Workstation, …)
5. Verifies every component and reports a summary

## Flags

- `--global` / `--local` — scope
- `--clean-install` / `--add-on-top` — mode (requires `--yes-wipe` for clean in non-interactive)
- `--tier primordial|recommended|all` — tier
- `--non-interactive` — skip prompts
- `--dry-run` — preview without writing
- `--verbose` — verbose output
