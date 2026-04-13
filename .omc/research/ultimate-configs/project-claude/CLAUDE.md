# Project Instructions

## Overview

<!-- Describe the project in 2-3 sentences. What it does, who it's for, what stack it uses. -->

## Tech Stack

<!-- List primary technologies, versions, and key dependencies. Example: -->
<!-- - Runtime: Node.js 22, TypeScript 5.7 -->
<!-- - Framework: Next.js 15 (App Router) -->
<!-- - Database: PostgreSQL 17 via Drizzle ORM -->
<!-- - Testing: Vitest, Playwright -->
<!-- - Linting: Biome -->

## Architecture

<!-- High-level architecture: monolith/microservices, key directories, data flow. -->
<!-- Link to architecture docs if they exist. -->

### Directory Structure

```
src/
  app/        # Routes and pages
  lib/        # Shared utilities
  components/ # UI components
  server/     # Server-side logic
  db/         # Database schema and migrations
tests/        # Test files mirror src/ structure
docs/         # Documentation
```

## Development Commands

```bash
# Install dependencies
pnpm install

# Run development server
pnpm dev

# Run tests
pnpm test

# Run linter
pnpm lint

# Run type-check
pnpm typecheck

# Run formatter
pnpm format

# Build for production
pnpm build

# Run database migrations
pnpm db:migrate
```

## Code Conventions

### Naming

- Files: kebab-case (`user-profile.ts`)
- Components: PascalCase (`UserProfile.tsx`)
- Functions/variables: camelCase (`getUserProfile`)
- Constants: SCREAMING_SNAKE_CASE (`MAX_RETRY_COUNT`)
- Types/interfaces: PascalCase (`UserProfile`)
- Database tables: snake_case (`user_profiles`)

### Patterns

- Use named exports, not default exports.
- Colocate tests with source: `foo.ts` -> `foo.test.ts`.
- Error handling: use Result types or explicit try/catch. Never swallow errors.
- Database: all queries go through the ORM. No raw SQL in application code.
- API routes: validate input at the boundary with schema validation (Zod/Valibot).
- Components: prefer composition over inheritance. Keep components under 150 lines.

### Testing

- Every new feature needs tests. Every bug fix needs a regression test.
- Unit tests for pure logic. Integration tests for API routes. E2E tests for critical flows.
- Test file naming: `*.test.ts` for unit, `*.spec.ts` for integration, `*.e2e.ts` for E2E.
- Use factories for test data. Do not hardcode UUIDs or timestamps.

## Git Workflow

- Branch naming: `feat/short-description`, `fix/short-description`, `chore/short-description`
- Commit messages: conventional commits (`feat:`, `fix:`, `chore:`, `docs:`, `test:`, `refactor:`)
- PR titles: same format as commit messages, under 72 characters.
- Squash merge to main. Delete branches after merge.

## Environment

- `.env.example` documents all required variables with dummy values.
- Never commit `.env` or any file containing real credentials.
- Use `process.env.VARIABLE` with validation at startup. Fail fast on missing vars.

## Known Gotchas

<!-- Document project-specific pitfalls. Examples: -->
<!-- - The auth middleware must run before the rate limiter. -->
<!-- - PostgreSQL NOTIFY channels have a 8000 byte payload limit. -->
<!-- - The legacy /api/v1 routes cannot be removed until mobile app v3.2 is sunset. -->

## Review Checklist

Before marking any PR as ready:
- [ ] Tests pass (`pnpm test`)
- [ ] Linter clean (`pnpm lint`)
- [ ] Types check (`pnpm typecheck`)
- [ ] No console.log/debugger left in code
- [ ] No hardcoded secrets or credentials
- [ ] Breaking changes documented
- [ ] Migration is reversible (if applicable)
