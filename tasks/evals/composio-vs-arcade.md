# Eval: Composio vs arcade-mcp

**Question:** Does arcade-mcp cover the SaaS integrations the user actually uses, well enough to swap out Composio?

**Context (2026-04-18):**
- **Composio** (current): 500+ claimed toolkits, v3 endpoint with `x-api-key`, working OAuth connections for this user (Gmail, Slack, Linear if any). Per-server persistent URL via `COMPOSIO_MCP_SERVER_ID`.
- **arcade-mcp** (candidate): `ArcadeAI/arcade-mcp`, Production/Stable classifier, 34+ official toolkits.

**The real comparison isn't "who has more toolkits"** — it's "does arcade cover the ones this user actually touches in a given month?"

## Step 1: inventory actual Composio usage

Before writing the eval, check usage:

```
grep -r 'COMPOSIO_' ~/.claude/session-logs/ 2>/dev/null
grep -r 'mcp__composio' ~/.claude/session-logs/ 2>/dev/null | head -20
claude mcp list | grep composio
```

List the specific Composio toolkits invoked in the last 30 days. If the list is 0-1 toolkits, the answer is "skip the eval, drop composio as unused" → move to `DROP` in a future audit.

## Fixtures (derived from actual usage)

Pick 3-5 tasks that hit integrations the user actively uses. Examples:

1. "Pull my latest 5 Linear issues assigned to me"
2. "Post a message to #eng-team in Slack"
3. "Create a Notion page under Projects / Q2"
4. "Search my Gmail for `stripe invoice` in the last 30 days"
5. "Get open PRs I'm a reviewer on" (GitHub — separate MCP, skip for this eval)

If actual usage is <3 toolkits → skip eval, do nothing until usage grows.

## Harness

```typescript
// Register both MCPs side-by-side with isolated allowlists per run.
// Score: did the task complete? Latency? Tool-call count? Error rate?
```

## Pass criteria for SWAP

- arcade covers EVERY actively-used toolkit with equivalent or better behavior
- OAuth flow works cleanly on a fresh re-auth
- Latency is within 2× of composio
- Error messages are at least as actionable

## If arcade wins

1. Migration needs a transition window: keep composio registered until arcade OAuth connections are re-established for every active toolkit
2. Update `src/components/workflow.ts`: swap the HTTP URL shape
3. Update `MCP_ENV_VARS` in `setup.ts`: add `ARCADE_API_KEY`, deprecate `COMPOSIO_MCP_SERVER_ID`
4. User re-runs `setup` → re-auths each toolkit → removes composio

## If composio wins or ties

Current config stays. Record result as evidence against the SWAP recommendation in next audit.

## Hard guardrail

**Do NOT swap before verifying OAuth connections can be re-established for every integration the user actively uses.** Swapping pre-emptively = breaking live workflows.
