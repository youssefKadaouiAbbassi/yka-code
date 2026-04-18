---
name: skill-authoring
description: [yka-code] RED-GREEN-REFACTOR discipline for adding or modifying a skill. Use when the user asks to create a new SKILL.md, modify an existing skill's routing/behavior/Phase-0 preamble, or when a skill's body needs to change in response to observed model behavior. Delegates the eval harness to `evals-first`. Owns the observed-failure-first loop + skill-specific consistency checks (routing table, CLAUDE.md cross-refs, deletion cleanup).
---

# Skill-authoring

A skill is a prompt-shaped contract: when its description matches, Claude loads the body and acts on it. The failure mode isn't "broken code" — it's "Claude didn't do the thing." The only signal is running it and observing.

This skill enforces observed-failure-first for skill writes.

## When to activate

- User: "add a skill that does X", "write a skill for Y", "modify the routing table", "this skill isn't firing"
- Any SKILL.md file is about to be created or edited
- A description, frontmatter, or Phase-0 preamble is about to change on an existing skill

## The loop

### Phase 1 — Observe the failure

Before writing ANY markdown, name the current broken behavior in one sentence:

- "Claude writes library claims without citing docfork when the library is Next.js."
- "Claude routes `refactor this bug` to `refactor-safely` when it should split the work."
- "After a feature lands, Claude never cuts a release tag."

If you can't observe the failure, the skill isn't ready. Ask what behavior the user has actually seen.

### Phase 2 — Delegate the eval

Invoke `Skill(skill: "evals-first")`. It owns the harness (`claude -p` subprocess, Claude Max, JSON output, fixtures). Produce an eval in `tests/evals/skills/<skill-name>.ts` that:

- Runs `claude -p` on a prompt that should trigger the skill
- Asserts the skill was invoked (check `toolUses` for `Skill("<name>", ...)`) OR that the expected tool chain ran (e.g., `mcp__docfork__search_docs` before `Write`)
- Fails cleanly RIGHT NOW (before the skill is written or changed)

### Phase 3 — Write the minimum SKILL.md

Use this skeleton:

```markdown
---
name: <kebab-case>
description: [yka-code] <When to activate — MUST contain the trigger phrases from Phase 1, written so Claude's description-match picks it up. Chain notes: "Pairs with X", "Delegates Y to Z".>
---

# <Title>

<One-paragraph statement of the discipline.>

## When to activate
<Bullet list of user-prompt signals + task shapes.>

## The loop
<Numbered steps — the actual procedure.>

## Hard rules
<Numbered list — non-negotiable invariants.>

## Chains with
<Other skills this cooperates with or delegates to.>

## What this skill avoids
<Bullet list of out-of-scope concerns that readers might assume this skill handles.>
```

Keep the body tight. A skill that's 200 lines rarely fires more usefully than one that's 80.

### Phase 4 — Rerun the eval

`bun test tests/evals/skills/<name>.ts`. Green → proceed. Red → fix the body, not the eval. Don't refactor for "cleanliness" while in green — that's a separate pass.

### Phase 5 — Consistency sweep

Before committing, run the checklist:

- **Routing**: if the skill should auto-route via `/do`, is it in `skills/do/SKILL.md` Phase-1 table?
- **Toolkit listing**: is it in `skills/do/SKILL.md` "Our custom — complementary sub-skills" or "primary routes" block, depending on role?
- **CLAUDE.md**: does any project/global CLAUDE.md rule reference this skill? Update the cross-reference.
- **Stale deletion**: if you're replacing a skill (not adding), delete the old directory — `deploySkills()` removes stale entries via the manifest.
- **Description has trigger phrases**: the phrase the user will type should appear in the `description:` verbatim (that's the match signal).
- **Phase-0 loads**: if the skill runs subagents or does research, does it name `karpathy-guidelines` / `research-first` / `coding-style` in the subagent Phase-0 preamble?

### Phase 6 — Ship

Commit with a message that names the observed failure:

```
skill(audit-rigor): fix silent version-claim assertions

Claude was asserting React 19 behavior without any MCP citation
when research-first skill hadn't auto-loaded. Added a Phase-0
preamble check + stop-research-check hook advisory.
```

## Hard rules

1. **Never write a SKILL.md without an eval that fails first.** Vibe-authored skills rot on first model update.
2. **Never describe the skill as "comprehensive" / "complete" / "flexible."** Describe it by the behavior it fires on.
3. **Never add a Phase-0 preamble that loads >3 skills.** Four is too many; the body gets crowded.
4. **Never delete a skill without checking the routing table.** Orphan references in `do/SKILL.md` are worse than the stale skill.
5. **Never leave a routing table reference AFTER deleting a skill's directory.** The `deploySkills` manifest removes the files; you must remove the references.

## Chains with

- **`evals-first`** — owns the harness; this skill delegates Phase 2 to it.
- **`doc-hygiene`** — applies to the SKILL.md body itself (no filler, dated verification, <50 lines when possible).
- **`coding-style`** — for any TypeScript helpers (eval fixtures, hook scripts) the skill spawns.
- **`/do`** — must be updated when a skill changes routing.

## What this skill avoids

- Editing the installer's deployment logic — `deploySkills()` already does manifest-based sync.
- Shipping shared prompts between skills — if two skills need the same preamble, extract it to a references file and have both load it; don't duplicate inline.
- Building a "skill linter" — the eval IS the lint.
