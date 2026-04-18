# Deferred: secrets.env → sops exec-env migration

**Status:** Plan written, NOT yet executed. Current secrets flow is working; this is a security upgrade that touches multiple subsystems and warrants its own feature PR.

## Current flow (audit finding)

`~/.config/yka-code/secrets.env`:
- Plaintext file, chmod 600
- Contains DOCFORK_API_KEY, GITHUB_PAT, COMPOSIO_API_KEY, COMPOSIO_MCP_SERVER_ID
- Sourced from shell rc on every shell start: `[ -f "$secrets" ] && source "$secrets"`

## Risk

Any user-owned process (malicious npm postinstall, compromised CC plugin, curl|sh gone wrong) can `cat ~/.config/yka-code/secrets.env` and exfiltrate every API key. chmod 600 defends only against other system users; it does NOT defend against malicious processes running as the user.

## Target flow (sops exec-env)

1. Secrets stored encrypted at `~/.config/yka-code/secrets.enc` (age backend, key already provisioned by the installer)
2. On shell start, NO sourcing happens — secrets aren't decrypted at shell startup
3. `claude` is launched via `sops exec-env` wrapper, which decrypts the secrets in-memory only for the child process:
   ```
   alias claude='sops exec-env "$HOME/.config/yka-code/secrets.enc" claude'
   ```
4. Secrets are never on disk in plaintext. Non-claude subprocesses (a malicious `npm postinstall`) cannot read them.

## Why deferred

Implementation touches:
1. **CLI installer** — add sops binary (DONE in Phase 1), add age-encryption step for secrets, change `saveSecretsToFile` to write encrypted form
2. **Shell rc block** — swap `source ...secrets.env` for a `claude` alias (but this needs to coexist with `claude mcp list` etc. that also consume secrets from env)
3. **chezmoi integration** — if user uses chezmoi, the encrypted secrets file needs to be chezmoi-managed
4. **Migration path** — existing users have plaintext secrets.env; migration must auto-encrypt, then delete plaintext atomically
5. **Rollback** — user can always `sops -d secrets.enc > secrets.env` to get back to the old flow

This is a 3-5 PR stack, not a single-turn implementation. Specifying it here so the next agent has a clear plan when the user requests the migration.

## Minimum viable preparatory work (already done)

- `sops` binary installed via `installDevCliBaseline` in core.ts
- `age` binary installed via `workstation.ts` (already in place)
- `gitleaks` binary installed to scan FOR secrets before they enter the repo

## Rollout plan (when the user requests this)

1. Write an eval: given a populated `secrets.env`, running `sops encrypt` + `sops exec-env` must produce the same env vars as `source`.
2. Add `migrateSecretsToSops(env, dryRun)` in `src/core.ts` that:
   a. Reads plaintext secrets.env
   b. Writes an age-encrypted secrets.enc (`sops -e --age $(age-keygen) --output secrets.enc plaintext.env.tmp`)
   c. Wires `alias claude='sops exec-env ... claude'` in shell rc
   d. Deletes plaintext secrets.env (with backup)
3. Add a `--migrate-secrets-to-sops` flag on the setup command
4. Update `doc-hygiene` docs: update the README + CLAUDE.md sourcing instructions
5. Eval verifies new flow produces identical env state

Do not ship without step 1 (eval) passing. Missing secrets = every MCP silently breaks with auth errors.
