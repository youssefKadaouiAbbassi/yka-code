# Eval: docfork vs Context7

**Question:** Is Context7 a better docs MCP than docfork for this stack, as of the date this eval runs?

**Context (2026-04-18):**
- **docfork** (current): remote MCP at `https://mcp.docfork.com/mcp`, requires `DOCFORK_API_KEY`. Upstream GitHub repo is ambiguous; npm `docfork-mcp` was unpublished 2025-06-05.
- **Context7** (candidate): `upstash/context7`, ~53k stars, free tier, remote MCP at `https://mcp.context7.com/mcp`, `CONTEXT7_API_KEY` header (optional at low rate limits).

## Setup

Install Context7 alongside docfork (both registered):

```
claude mcp add context7 -s user --transport http https://mcp.context7.com/mcp -H "CONTEXT7_API_KEY: $CONTEXT7_API_KEY"
```

Don't remove docfork yet. Run both through identical fixtures.

## Fixtures (5 real tasks)

1. **React 19 Server Components** — "How do I migrate a Pages-Router component to App-Router RSC?"
2. **Bun 1.3 `bun install`** — "Does Bun install respect npm workspaces as of current stable?"
3. **Prisma 6 migrations** — "How do I declare a composite unique index in the current Prisma schema?"
4. **Stripe SDK subscription billing** — "Show me the current recommended SDK flow for setting up metered subscriptions."
5. **Tailwind v4 `@theme` directive** — "Give me the current `@theme` syntax and a complete migration example from v3."

## Harness

`tests/evals/docfork-vs-context7.ts`:

```typescript
import { spawnSync } from "bun";

const FIXTURES = [
  "React 19 Server Components: migrate a Pages-Router component to App-Router RSC.",
  "Bun current stable `bun install`: does it respect npm workspaces?",
  "Prisma 6: declare a composite unique index in the schema.",
  "Stripe SDK current: recommended flow for metered subscriptions.",
  "Tailwind v4 `@theme` directive: syntax + migration example from v3.",
];

function runClaude(prompt: string, mcpAllowlist: string[]) {
  const proc = spawnSync([
    "claude", "-p", prompt,
    "--output-format", "json",
    "--allowed-tools", mcpAllowlist.join(","),
  ], { timeout: 180_000, stdout: "pipe", stderr: "pipe" });
  const raw = new TextDecoder().decode(proc.stdout);
  return raw.trim().split("\n").filter(Boolean).map(JSON.parse);
}

// Compare: same prompt, once via docfork only, once via context7 only.
for (const fixture of FIXTURES) {
  const dfResult = runClaude(fixture, ["mcp__docfork__search_docs", "mcp__docfork__fetch_doc"]);
  const ctxResult = runClaude(fixture, ["mcp__context7__search_docs", "mcp__context7__fetch_doc"]);
  // Score each: citation count, final-message length, response latency, tool_use count
}
```

## Pass criteria for SWAP

Context7 wins 4/5 fixtures on BOTH:
- **Accuracy**: cites current upstream docs (not stale API signatures)
- **Coverage**: returns a useful answer where docfork returned "no docs found"

If Context7 ties or loses on even one dimension → keep docfork + Context7 side-by-side (additive), don't swap.

## Rollout if Context7 wins

1. Add `CONTEXT7_API_KEY` to `MCP_ENV_VARS` in `src/commands/setup.ts`
2. Register via `registerMcp` in a new component or extend `memoryContextCategory`
3. Update `skills/do/SKILL.md` toolkit listing: replace "docfork" with "context7 (primary), docfork (fallback)"
4. Keep docfork registered for 1 release for fallback — deprecate in next audit cycle

## If both lose / tie

Current state wins by default; record the result here as evidence for the next audit.
