<!-- Generated: 2026-04-14 | Parent: ../AGENTS.md -->

# tests/integration

## Purpose

Cross-module integration tests that verify contracts between the installer code, the shipped config templates, and the shell hook scripts **without** spinning up a full container install. These sit between `tests/unit/` (pure functions) and `tests/e2e/` (full `testcontainers` runs): they exercise real binaries and real files, but against the repo's own `bin/`, `configs/`, and `tests/fixtures/` trees rather than a simulated target machine.

Three contracts are covered:

1. **CLI surface** — `bin/setup.ts` flags, subcommands, and help output.
2. **Config invariants** — `configs/**` JSON validity, required keys, pinned model, MCP server set, hook shebang/strict-mode, file count.
3. **Hook I/O** — shell hooks in `configs/hooks/*.sh` produce the correct `{ decision, reason }` JSON for given PreToolUse payloads.

## Key Files

| File | What it verifies |
|------|------------------|
| `cli.test.ts` | Executes `bun run bin/setup.ts` with `--help`, `--non-interactive --dry-run`, `--tier primordial --dry-run`, and the `status` / `restore` subcommands. Asserts output markers and exit codes. |
| `config-validation.test.ts` | Parses `configs/home-claude/settings.json`, `configs/home-claude/CLAUDE.md`, `configs/tmux.conf`, `configs/starship.toml`. Enforces: >=40 deny rules in settings.json, every `*.sh` in `configs/hooks/` and `configs/project-claude/hooks/` starts with `#!/usr/bin/env bash` and contains `set -euo pipefail`. MCP servers are registered at install time via `claude mcp add`, not declared in a static mcp.json — verification of the MCP set belongs in e2e, not integration. |
| `hooks.test.ts` | Pipes JSON fixtures from `tests/fixtures/` into `pre-destructive-blocker.sh` and `pre-secrets-guard.sh`, asserts `decision: "allow"` for safe inputs and `decision: "block"` with a non-empty `reason` for `rm -rf /` and AWS-key payloads. Entire suite is gated with `describe.skipIf(!jqAvailable)` — hooks require `jq`. |

## Dependencies

### Test Runner

- **`bun:test`** — built-in Bun test framework. Run via `bun test tests/integration/` or the root `bun test` (which globs all tests).

### Bun APIs Used

- **`Bun.$`** (tagged shell) — runs `bun run bin/setup.ts ...` and pipes stdin into hook scripts.
- **`Bun.spawn`** — runs subcommands (`status`, `restore`) when the exit code matters more than stdout.
- **`Bun.file(...).json() / .text()`** — reads config templates without loading `node:fs`.
- **`Bun.Glob`** — enumerates `configs/hooks/*.sh` and the full `configs/**/*` tree.
- **`Bun.which("jq")`** — runtime probe that drives `describe.skipIf` for hook tests.

### Fixtures

- `tests/fixtures/hook-stdin-bash.json` — safe Bash `ls -la` payload.
- `tests/fixtures/hook-stdin-bash-destructive.json` — `rm -rf /` payload.
- `tests/fixtures/hook-stdin-bash-secrets.json` — AWS key leak payload.
- `tests/fixtures/hook-stdin-edit.json` — non-Bash `Edit` tool payload (should always `allow`).

### External Requirements

- **Bun** >= 1.2 (same as the repo-wide requirement).
- **`jq`** — required for `hooks.test.ts`. Absent → those tests skip, not fail. The rest of the suite runs without it.
- **`bash`** — required for `hooks.test.ts`; the shell hooks are `#!/usr/bin/env bash`.

### Files Under Test (outside `tests/`)

- `bin/setup.ts` — CLI entry point.
- `configs/home-claude/settings.json`, `configs/home-claude/CLAUDE.md`.
- `configs/project-claude/mcp.json`.
- `configs/hooks/*.sh`, `configs/project-claude/hooks/*.sh`.
- `configs/tmux.conf`, `configs/starship.toml`.

## For AI Agents

### Running The Suite

```bash
bun test tests/integration/                          # whole directory
bun test tests/integration/cli.test.ts               # one file
bun test tests/integration/ -t "primordial"          # single test by name substring
```

`hooks.test.ts` auto-skips when `jq` is missing — install it (`brew install jq` / `apt install jq`) before relying on a green run.

### When To Add A Test Here (Not Unit / Not E2E)

Add an integration test when the thing you're verifying is a **contract between two subsystems owned by this repo** that can be exercised by reading a real file or running a real binary, but does **not** require a sandboxed `~/.claude/` install.

- Adding a new MCP server → add a `registerMcp()` call in the relevant `src/components/*.ts` and update the install journal / uninstall allowlist in `src/utils/backup.ts` (`CODE_TOOLS_MANAGED_MCPS`). There is no static mcp.json to update.
- Adding a new hook in `configs/hooks/` → it is automatically swept by the shebang / `set -euo pipefail` tests; add a dedicated `describe` block in `hooks.test.ts` with fixtures if it has decision logic.
- Adding a new CLI flag or subcommand to `bin/setup.ts` → add an assertion in `cli.test.ts` (`--help` output and, if stateless, a `--dry-run` invocation).
- Changing the pinned deny-rule floor, model, or total config file count → update the constants in `config-validation.test.ts` in the same commit. These numbers are load-bearing guardrails, not arbitrary.

### When NOT To Add A Test Here

- **Pure function logic** (deep-merge helpers, path resolution, string formatting) → `tests/unit/`.
- **Full install on a clean system** (verify primordial backup, idempotency across reruns, OS-adaptive package manager dispatch) → `tests/e2e/` with `testcontainers`.
- **Shellcheck lint** → `bun run lint:hooks`, not a test.
- **CI-level bats verification** → `tests/ci/verify.bats` via `bun run test:ci`.

### Conventions To Match

- Use `Bun.file()` and `Bun.$`, never `node:fs` + `child_process`. The rest of the suite is Bun-native.
- Resolve repo paths from `import.meta.dir` / `import.meta.url`, never from `process.cwd()` — tests must pass regardless of where `bun test` is invoked from.
- JSON fixtures live in `tests/fixtures/` and are read by `Bun.file(...).text()`; don't inline large payloads in test files.
- Gate tests that need external binaries with `describe.skipIf(!Bun.which("<bin>"))` so CI on minimal images skips cleanly instead of failing.
- One `describe` per subject under test; nested `describe` per scenario group (see `hooks.test.ts`).

### Hard Rules

1. **No writes outside `tests/` and no touching `~/.claude/`.** Integration tests are read-only against `configs/` and `bin/`. Anything that would mutate the developer's real environment belongs in `tests/e2e/` inside a container.
2. **No network.** If a test needs to reach `github.com` or an MCP endpoint, it's an e2e or a unit test with a mocked fetch — not an integration test.
3. **Deterministic only.** No `Date.now()` comparisons, no random fixtures, no ordering assumptions on `Glob.scan`.
4. **Keep runtimes short.** The whole `tests/integration/` directory should complete in a few seconds; each `bun run bin/setup.ts` invocation is the dominant cost — avoid adding more than is needed.

### Writer vs Reviewer

Authoring changes to these tests is a writer pass. Approval (did the new assertion actually protect the invariant it claims to?) belongs in a separate `code-reviewer` / `verifier` lane, per the repo-wide Principle 7.

<!-- MANUAL: -->
