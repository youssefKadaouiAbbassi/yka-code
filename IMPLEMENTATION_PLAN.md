# code-tools Interactive Installer — Implementation Plan

## Context for the next AI

This repo contains the research + architecture for the **Ultimate Claude Code System v12** — 40 components validated by 10 independent architects, 9 unbiased researchers, 5 adversarial reviewers, and 4 functionality verifiers across a multi-day session.

**The system definition is at:** `.omc/research/FINAL_SYSTEM_v12.md`
**The config templates are at:** `.omc/research/ultimate-configs/` (22 files — settings.json, CLAUDE.md, hooks, agents, mcp.json)
**The README explains the full system:** `README.md`

**Your job:** Build an interactive CLI installer that deploys this system onto any machine.

---

## What to build

An interactive TypeScript CLI + Claude Code plugin that:
1. Detects the user's OS, shell, package manager, and existing tools
2. Shows the user what it found and what it's about to do (transparent)
3. Backs up everything it overrides to `~/.claude-backup/{timestamp}/`
4. Silently installs the **primordial layer** (non-negotiable core — settings.json, CLAUDE.md, hooks, tmux, starship, mise, just, git aliases, telemetry)
5. Interactively asks about **14 optional categories** with explanations
6. Adapts install commands to detected OS (brew/apt/pacman/dnf)
7. Verifies each install succeeded
8. Shows a final summary

## Technology stack

Same as [skills.sh](https://github.com/vercel-labs/skills) (the Vercel agent skills CLI):
- **TypeScript** — language
- **@clack/prompts** — interactive TUI (beautiful prompts, spinners, selects, confirms)
- **picocolors** — terminal colors (lightweight)
- **simple-git** — git operations
- **which** — binary detection
- **fs-extra** — file operations
- **yaml** — config parsing

Publishable as: `npx @youssefKadaouiAbbassi/code-tools-setup`

## The three install tiers

### PRIMORDIAL (always install, override existing, no asking)

These ARE the system. User's existing config gets backed up then overridden.

| What | Why it overrides |
|---|---|
| `settings.json` | Our 40+ deny rules ARE the enforcement layer |
| `CLAUDE.md` + AGENTS.md + GEMINI.md symlinks | Our 85-line config IS the workflow |
| 6 hook scripts (destructive blocker, secrets guard, lint gate, session-start, session-end, stop summary) | Hooks enforce 100%, CLAUDE.md ~80% |
| `tmux.conf` | OUR layout designed for Claude Code (prefix Ctrl-A, status bar with git/context%/cost, pre-built pane layouts) |
| `starship.toml` | OUR prompt showing git branch + CC context % + cost |
| `statusline.sh` | OUR statusline for CC |
| `mise` + `just` | Required for build loop — everything else's install flows through mise |
| Git worktree aliases | Added non-destructively to .gitconfig |
| Native telemetry env vars | Powers the /cost command |
| `tasks/lessons.md` | Created if doesn't exist, NEVER overwritten if it does |

### RECOMMENDED (ask, default YES)

| Category | Components | Description for user |
|---|---|---|
| Code Intelligence | Serena + ast-grep CLI | Gives Claude deep code understanding (types, references, structural patterns) |
| Browser + Web | Playwright CLI + Crawl4AI + Docfork + DeepWiki | Browser automation, web scraping, library docs, repo Q&A |
| Memory + Context | claude-mem + context-mode | Persistent memory across sessions + 98% output compression |
| Security | Snyk MCP + container-use | Dependency vulnerability scanning + Docker isolation per agent |
| GitHub | github-mcp + claude-code-action + Code Review + CodeRabbit | Batch GitHub ops, CI review, cross-vendor review |
| Workstation extras | Ghostty + tmux + chezmoi + age | Terminal + multiplexer + encrypted dotfiles |

### OPTIONAL (ask, default NO)

| Category | Components | Description for user |
|---|---|---|
| Phone Notifications | Channels + claude-ntfy-hook | Message Claude from phone + Allow/Deny for risky ops |
| Observability | ccflare | Terminal cost dashboard |
| Orchestration | Multica | Agent issue board with skill compounding |
| Database | PostgreSQL MCP Pro | Natural language SQL, index tuning, health analysis |
| Design | Google Stitch + awesome-design-md | Design-to-code pipeline, brand templates |
| Knowledge | Obsidian + claude-obsidian | Karpathy LLM Wiki pattern |
| Workflow | n8n + Composio | Visual automation + 500+ app integrations |
| ML Research | autoresearch | Autonomous experiments (Karpathy, 700 experiments/2 days) |

## Interactive flow

```
╔══════════════════════════════════════════════════╗
║  Ultimate Claude Code System — v12 Setup          ║
╚══════════════════════════════════════════════════╝

Scanning your environment...

  OS:              macOS 15.4 (Apple Silicon)
  Shell:           zsh 5.9
  Package manager: brew 4.5.1
  Claude Code:     2.1.104 ✓
  Docker:          not found ✗
  Node:            22.11 ✓
  tmux:            not installed ✗
  mise:            not installed ✗

Here's what's about to happen:

CORE (installing now — these make the system work):

  settings.json     Your current one has 0 deny rules. Ours has 40+
                    that block destructive commands. Yours backed up.

  CLAUDE.md         85 lines of workflow rules + symlinks.
                    Yours backed up.

  Hooks             6 scripts running on every tool call:
                    block destructive commands, guard secrets,
                    auto-lint, inject context, log sessions,
                    scan for debug code.

  [... explains each primordial component ...]

All existing configs backed up to ~/.claude-backup/20260413/

Installing core...
  ✓ settings.json deployed
  ✓ CLAUDE.md + symlinks deployed
  ✓ 6 hooks wired
  ✓ tmux installed + configured
  ✓ Starship installed + configured
  ✓ mise installed
  ✓ just installed
  ✓ Git aliases added
  ✓ Telemetry enabled

Core system ready. Now the extras:

? What do you want on top?
  ❯ Everything (all 40 components)
    Let me pick
    Nothing — just the core

[If "Let me pick":]

? Code Intelligence
  Serena: gives Claude deep understanding of your code
  (types, references, cross-file analysis). 40+ languages.
  ast-grep: structural code search on the AST.
  ? Install?  [Y/n]

? Browser + Web
  [... explains each category with context ...]
  ⚠ Note: Crawl4AI v0.8.5 had a supply chain issue. We install v0.8.6+.
  ? Install?  [Y/n]

[... same for each category ...]

Verifying...
  ✓ 7 MCP servers responding
  ✓ 6 hooks active
  ✓ settings.json valid

╔══════════════════════════════════════════════════╗
║  Setup complete! 40/40 components installed       ║
║  Restart terminal to activate tmux + Starship     ║
╚══════════════════════════════════════════════════╝
```

## File structure

```
code-tools/
├── .claude-plugin/
│   └── plugin.json                  ← Claude Code plugin manifest
├── skills/
│   └── setup/
│       └── SKILL.md                 ← /setup skill (runs the CLI)
├── agents/                          ← 8 agent definitions (copy from ultimate-configs)
│   ├── researcher.md
│   ├── implementer.md
│   ├── reviewer.md
│   ├── architect.md
│   ├── security.md
│   ├── tdd.md
│   ├── devops.md
│   └── writer.md
├── src/
│   ├── index.ts                     ← Main CLI entry with @clack/prompts interactive flow
│   ├── types.ts                     ← Shared types (OS, Shell, PackageManager, DetectedEnvironment, InstallResult, ComponentCategory, etc.)
│   ├── utils.ts                     ← Shared utilities (exec, commandExists, installBinary, appendToShellRc, log, file ops)
│   ├── detect.ts                    ← Environment detection (OS, shell, pkg manager, all 40 tools)
│   ├── backup.ts                    ← Backup engine (createBackup, listBackups, getLatestBackup)
│   ├── primordial.ts                ← Silent core install (settings.json, CLAUDE.md, hooks, tmux, starship, mise, just, git aliases, telemetry, lessons.md)
│   ├── verify.ts                    ← Post-install verification (check binaries, MCP configs, file presence)
│   ├── status.ts                    ← Show what's installed vs missing (colored table by category)
│   ├── restore.ts                   ← Restore from backup
│   └── components/
│       ├── index.ts                 ← Barrel exporting all 14 categories as ordered array
│       ├── code-intel.ts            ← Serena + ast-grep
│       ├── browser-web.ts           ← Playwright CLI + Crawl4AI + Docfork + DeepWiki
│       ├── memory-context.ts        ← claude-mem + context-mode
│       ├── security.ts              ← Snyk MCP + container-use
│       ├── github.ts                ← github-mcp + CI action + Review + CodeRabbit
│       ├── notifications.ts         ← Channels + claude-ntfy-hook
│       ├── observability.ts         ← ccflare
│       ├── orchestration.ts         ← Multica
│       ├── database.ts              ← PostgreSQL MCP Pro
│       ├── design.ts                ← Google Stitch + awesome-design-md
│       ├── knowledge.ts             ← Obsidian + claude-obsidian
│       ├── workflow.ts              ← n8n + Composio
│       ├── ml-research.ts           ← autoresearch
│       └── workstation.ts           ← Ghostty + tmux + chezmoi + age
├── bin/
│   └── setup.ts                     ← CLI entry point (#!/usr/bin/env tsx)
├── configs/                         ← Config templates deployed by primordial.ts
│   ├── home-claude/
│   │   ├── settings.json            ← Copy from .omc/research/ultimate-configs/home-claude/settings.json
│   │   └── CLAUDE.md                ← Copy from .omc/research/ultimate-configs/home-claude/CLAUDE.md
│   ├── hooks/
│   │   ├── pre-destructive-blocker.sh  ← Copy from ultimate-configs
│   │   ├── pre-secrets-guard.sh
│   │   ├── post-lint-gate.sh
│   │   ├── session-start.sh
│   │   ├── session-end.sh
│   │   └── stop-summary.sh
│   ├── project-claude/
│   │   ├── settings.json            ← Copy from ultimate-configs
│   │   ├── settings.local.json      ← Copy from ultimate-configs
│   │   ├── CLAUDE.md                ← Copy from ultimate-configs
│   │   ├── mcp.json                 ← Copy from ultimate-configs
│   │   └── hooks/
│   │       ├── post-edit-lint.sh
│   │       └── post-bash-test.sh
│   ├── tmux.conf                    ← NEW: Claude-optimized (Ctrl-A prefix, mouse, status bar with git/time)
│   ├── starship.toml                ← NEW: Minimal prompt (git branch, node version, directory)
│   └── statusline.sh               ← NEW: Shell script for CC statusline
├── bootstrap.sh                     ← curl|bash for fresh machines (installs Node + CC + runs installer)
├── package.json
├── tsconfig.json
└── README.md
```

## Execution phases (dependency order)

```
Phase 0: Scaffolding (ALL PARALLEL)
  package.json, tsconfig.json, .gitignore
  
Phase 1: Core types + utils (SEQUENTIAL — utils imports types)
  src/types.ts → src/utils.ts

Phase 2-5: PARALLEL BATCHES
  [Phase 2] src/detect.ts — OS/shell/package-manager/tools detection
  [Phase 3] src/backup.ts — backup engine
  [Phase 4] configs/ — 17 config files (copy from ultimate-configs + author 3 new)
  [Phase 5] agents/ — 8 agent definitions (copy from ultimate-configs)

Phase 6: Primordial installer (depends on Phase 2+3+4)
  src/primordial.ts — silent core install

Phase 7: Component installers (ALL 14 PARALLEL, barrel last)
  src/components/*.ts — 14 category files + index.ts barrel

Phase 8: Post-install (ALL 3 PARALLEL)
  src/verify.ts, src/status.ts, src/restore.ts

Phase 9: Main CLI (depends on ALL above)
  src/index.ts — @clack/prompts interactive flow
  bin/setup.ts — CLI entry point

Phase 10: Plugin + Skill (PARALLEL)
  .claude-plugin/plugin.json
  skills/setup/SKILL.md

Phase 11: Bootstrap (INDEPENDENT)
  bootstrap.sh

Phase 12: README update (LAST)
```

## Key implementation details

### OS-adaptive installs
Define a helper `installBinary(pkg: InstallPackage, env: DetectedEnvironment)` in utils.ts that takes:
```typescript
interface InstallPackage {
  name: string;      // binary name to check
  brew?: string;     // brew package name
  apt?: string;      // apt package name
  pacman?: string;   // pacman package name
  dnf?: string;      // dnf package name
  npm?: string;      // npm global package
  cargo?: string;    // cargo package
  pip?: string;      // pip package
  curl?: string;     // curl install command
}
```
It checks which package manager the user has and uses the appropriate command.

### MCP server registration
Adding MCP entries requires careful JSON merging into `~/.claude/settings.json` or `.mcp.json` — don't overwrite, deep-merge. Write a `mergeSettings(existing, patch)` function.

### Shell rc file editing
When adding lines to `.zshrc`/`.bashrc` (e.g., `eval "$(starship init zsh)"`), use a marker comment `# code-tools-managed` and check for it before appending. Never duplicate.

### Idempotency
Every install function must check "is this already installed?" before acting. Pattern:
```typescript
async install(env) {
  if (await verify(env)) {
    return { component: name, success: true, message: "Already installed", skipped: true };
  }
  // ... actual install
}
```

### Config file resolution
Use `import.meta.url` to find the `configs/` directory relative to the package installation:
```typescript
const configsDir = new URL("../configs", import.meta.url).pathname;
```

## The v12 system (40 components) — reference

Full definition at `.omc/research/FINAL_SYSTEM_v12.md`. Summary:

| # | Category | Tool |
|---|---|---|
| 1 | Core | Claude Code 2.1.104 |
| 2 | Config | CLAUDE.md <100 lines + symlinks |
| 3 | Settings | settings.json (40+ deny rules) |
| 4 | Hooks | Unified hooks (6 scripts) |
| 5 | Security | Claude Code Security (native) + Snyk MCP |
| 6 | Semantic code | Serena v1.1.0 |
| 7 | Structural search | ast-grep CLI/skill |
| 8 | Browser | Playwright CLI |
| 9 | Web scraping | Crawl4AI (library, pin v0.8.6+) |
| 10 | Library docs | Docfork |
| 11 | Repo Q&A | DeepWiki |
| 12 | Memory | claude-mem (bind 127.0.0.1) |
| 13 | Context | context-mode |
| 14 | Sandbox L1 | Native PID-ns + seccomp |
| 15 | Sandbox L2 | container-use (cu stdio) |
| 16 | GitHub CLI | gh CLI |
| 17 | GitHub MCP | github-mcp-server (remote HTTP) |
| 18 | CI | claude-code-action@v1 + --bare |
| 19 | Native review | Claude Code Review |
| 20 | Cross-vendor review | CodeRabbit |
| 21 | Bidirectional comms | Channels (--channels plugin:telegram) |
| 22 | Defer approval | claude-ntfy-hook |
| 23 | Observability | Native /cost + telemetry |
| 24 | Terminal dashboard | ccflare |
| 25 | Native orchestration | Agent Teams (experimental) |
| 26 | Issue orchestration | Multica (10.2k) |
| 27 | ML research | autoresearch (71.3k) |
| 28 | Workflow | n8n (184k) |
| 29 | Database | PostgreSQL MCP Pro (crystaldba, 2.5k) |
| 30 | Design generation | Google Stitch |
| 31 | Design templates | awesome-design-md (47.2k) |
| 32 | Knowledge base | Obsidian + claude-obsidian |
| 33 | Tool versions | mise (26.6k) |
| 34 | Task runner | just (32.8k) |
| 35 | Integrations | Composio MCP |
| 36 | Terminal | Ghostty (50.6k) |
| 37 | Multiplexer | tmux |
| 38 | Parallel FS | Git worktrees |
| 39 | Dotfiles | chezmoi + age |
| 40 | Self-improvement | tasks/lessons.md |

## MCP Servers (7)
Serena, Docfork, github-mcp, context-mode, Composio, PostgreSQL MCP Pro, Snyk MCP

## 12 Principles
1. Verification > generation (reviewer = different model)
2. Hooks enforce 100%, CLAUDE.md advises 80%
3. Front-load architecture — first artifact = research.md, never code
4. Skill accumulation has diminishing returns — measure, delete non-earners
5. Native primitives replace plugins when they ship — re-evaluate monthly
6. Sandbox non-optional — native + container-use layered
7. Writer ≠ reviewer at model-diversity level
8. 3-5 parallel agents, start with one fewer than comfortable
9. Subscription = interactive, API key = CI (enforced April 4)
10. Pin model + effortLevel defaults (they drift silently)
11. CLAUDE.md under 100 lines — delete rules Claude follows without being told
12. Monthly metabolic audit — shed tools that don't earn their keep

## Links to key source files

- [FINAL_SYSTEM_v12.md](.omc/research/FINAL_SYSTEM_v12.md) — full system definition
- [ultimate-configs/home-claude/settings.json](.omc/research/ultimate-configs/home-claude/settings.json) — settings template (194 lines)
- [ultimate-configs/home-claude/CLAUDE.md](.omc/research/ultimate-configs/home-claude/CLAUDE.md) — CLAUDE.md template (64 lines)
- [ultimate-configs/home-claude/hooks/](.omc/research/ultimate-configs/home-claude/hooks/) — 6 hook scripts
- [ultimate-configs/project-claude/agents/](.omc/research/ultimate-configs/project-claude/agents/) — 8 agent definitions
- [ultimate-configs/project-claude/mcp.json](.omc/research/ultimate-configs/project-claude/mcp.json) — MCP server template (14 servers)
- [deep-interview spec](.omc/specs/deep-interview-code-tools-installer.md) — the original spec
- [@clack/prompts](https://github.com/bombshell-dev/clack) — the TUI library to use
- [skills.sh](https://github.com/vercel-labs/skills) — reference implementation using same stack
