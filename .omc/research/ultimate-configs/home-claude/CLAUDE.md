# Global Instructions

## Workflow

1. **Explore before coding.** Read existing code, understand patterns, check tests. Never implement blind.
2. **Plan in markdown.** Write a plan.md before multi-file changes. Get approval before executing.
3. **Implement incrementally.** One logical change at a time. Commit after each working state.
4. **Verify everything.** Run tests, linters, type-checks after every change. Show fresh output.

## Code Quality

- Match existing codebase patterns: naming, error handling, imports, file structure.
- Prefer the smallest viable change. Do not refactor adjacent code unless asked.
- No new abstractions for single-use logic. No premature optimization.
- Write tests for new behavior. Red-green-refactor: failing test first, then implementation.
- Handle errors explicitly. No swallowed exceptions, no empty catch blocks.
- Use descriptive names. Code should read like prose, not puzzles.

## Verification (Non-Negotiable)

- Run the test suite before claiming completion. Show the output.
- Run the linter/formatter. Fix all errors before finishing.
- Run type-checking if the project uses types. Zero type errors.
- If a test fails, fix production code. Never modify a test just to make it pass.
- Never say "should work" or "likely works." Prove it runs.

## Context Management

- Start sessions by reading CLAUDE.md, relevant docs, and the plan file.
- When context is large, use subagents for exploration. Keep the main thread focused.
- Checkpoint progress to markdown files for long tasks. Sessions are ephemeral; files persist.
- After completing a non-trivial task, append lessons to `.claude/lessons.md`.

## Self-Improvement

- When a mistake is caught, add a lesson to `.claude/lessons.md` with date and context.
- Review lessons.md at session start. Do not repeat known mistakes.
- When a pattern works well, document it. When it fails, document why.

## Never Do These

- Never commit secrets, tokens, API keys, or credentials to any file.
- Never run destructive commands (rm -rf, DROP DATABASE, terraform destroy) without explicit approval.
- Never modify .env files or anything in .gitignore that contains secrets.
- Never push to main/master without explicit instruction.
- Never skip tests or linting to "save time."
- Never leave debug code (console.log, debugger, TODO, HACK) in committed code.
- Never hallucinate APIs, libraries, or features. If unsure, look it up or say so.
- Never self-approve. If review is needed, say so and stop.

## Git Discipline

- Commit messages: imperative mood, under 72 chars, explain WHY not WHAT.
- One logical change per commit. Do not bundle unrelated changes.
- Always pull before pushing. Always check branch before committing.
- Create feature branches for non-trivial work. Never commit directly to main.

## Communication

- Be direct. State what you did, what you found, what remains.
- When uncertain, say so explicitly. Do not guess and present it as fact.
- When blocked, explain why and suggest alternatives.
- Provide file:line references for all changes discussed.
