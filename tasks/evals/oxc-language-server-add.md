# Deferred: oxc_language_server ADD

**Status:** Plan only. Distribution path changed recently; needs validation before wiring into `installRealLspBinaries`.

## Audit finding (2026-04-18)

> **oxc LSP binary removed from `oxlint` npm pkg in v1.37.0** (2026-01-05) — distribution shifted to Rust crate + VS Code extension; CLI install path changed.

The upside still stands: fast Rust LSP + lint + format for TS/JS in one binary. Complements (doesn't replace) typescript-language-server.

## What I don't know yet

1. Is there a published crate name for the LSP binary? (`cargo install oxc_language_server`?)
2. Is the VS Code extension's bundled LSP binary reusable standalone, or is it runtime-linked?
3. Is there a GitHub release with a prebuilt binary (like the `gitleaks` / `lazygit` pattern we use for other CLIs)?
4. Does Claude Code's LSP harness require the binary to be on PATH, or can it point to an arbitrary path?

Until these are known, adding the install = either a broken install step or a stale path.

## Before implementing

Verify via `mcp__deepwiki__ask_question` on `oxc-project/oxc`:

> "What's the canonical way to install `oxc_language_server` as a standalone binary (no VS Code extension, no npm) as of {TODAY_ISO}? Is there a GitHub release with prebuilt binaries, or is `cargo install <crate>` the recommended path?"

## Rollout plan (once distribution is clarified)

Add to `installRealLspBinaries` in `cc-plugins.ts`:

```typescript
{
  name: "oxc_language_server (TS/JS lint + format + type-aware lint)",
  needs: () => commandExists("npm"), // or whatever the trigger is
  install: "<install command from deepwiki>",
  verify: "oxc_language_server",
},
```

Leave typescript-language-server and pyright installed — oxc is ADDITIVE, not replacing.

## Hard rule

**Do NOT install oxc_language_server from npm.** The binary was removed from that distribution channel in v1.37.0. Wire the current canonical path once confirmed.
