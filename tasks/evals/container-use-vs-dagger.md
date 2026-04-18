# Eval: container-use vs Dagger direct

**Question:** Is `dagger` (Dagger's canonical CLI) now the right entry point for sandboxed per-agent execution, replacing `container-use`?

**Context (2026-04-18):**
- **container-use** (current): `dagger/container-use` v0.4.2, last release 2025-08-19 (~8 months stale).
- **Dagger direct** (candidate): `dagger` CLI from `dagger/dagger`, actively maintained; container-use was built on top of Dagger's core and Dagger has moved on.

Staleness alone ≠ broken. Need concrete evidence that Dagger direct is the right move.

## Check first — is container-use actually broken or just slow-shipping?

```
container-use --version
container-use init
container-use list
```

If it works for the user's current needs, **no action needed**. Watch for:
- Upstream bug you hit that's fixed on main but not released
- Dagger-side changes that break container-use's wrapper
- Dagger release that exposes equivalent per-agent sandboxing as a first-party primitive

If none of those → defer indefinitely. Not every stale repo needs replacing.

## If a concrete break exists

Three paths:

1. **Patch container-use**: upstream a fix to `dagger/container-use` main branch.
2. **Vendor a local fork**: pin a sha of dagger/container-use main + document the pin in `src/components/security.ts`.
3. **Migrate to Dagger direct**: rewrite the per-agent sandbox flow using `dagger` CLI + Dagger's session primitives.

### Fixtures for Dagger-direct migration

If we choose path 3:

1. "Run an unverified npm package's build in isolation" — measure time from prompt to sandboxed execution result
2. "Run a security-patch on a known-vulnerable deps" — confirm isolation
3. "Spawn two agent sandboxes in parallel, merge results" — confirm per-agent isolation

Use the same scenarios `container-use` handles today. Score on latency, DX (flags needed, error messages), and isolation correctness.

## Harness

Spin up both stacks, run each fixture 5 times, aggregate:
- median latency
- failure rate (sandbox leak, permission denied, etc.)
- user-facing error clarity

## Pass criteria for MIGRATE

- Dagger direct handles all 3 scenarios with equivalent isolation guarantees
- Latency within 1.5× of container-use (Dagger's overhead is ~constant; container-use may be thinner)
- Upstream is actively-maintained with <3mo release cadence

## Rollout

1. Install `dagger` alongside `container-use` (both present until migration)
2. Wrap Dagger calls in our existing `skills/security-audit` / sandboxing workflows
3. Deprecate container-use in a subsequent release after 30 days of parallel use

## Hard rule

**Don't pre-empt a working tool's replacement because "upstream is slow."** Stale ≠ broken. Migration has real cost (install path rewrites, skill updates, workflow documentation). Earn it with concrete evidence.
