# Project Guidelines — Attendance Management (Monorepo)

Last updated: 2026-06-19

## Overview

This repository is a monorepo containing a Ruby backend (Sinatra/ROM style stack with RSpec tests and Sorbet/RBS
types) and a JavaScript frontend (Node/Yarn workspace). Docker is available for local development. The backend exposes
authentication and user management endpoints and includes OpenAPI specs. Tests live under `apps/backend/spec` and cover
domain, infrastructure, presentation, and integration layers.

Top-level items of interest:

- `apps/backend` — Ruby backend application (domain, application/use_cases, infrastructure, presentation/controllers,
  specs, OpenAPI).
- `apps/frontend` — Frontend application (Node-based; src, components, routes).
- `docker-compose.yaml` — Services orchestration for local dev.
- `lefthook.yml` — Git hooks configuration.
- `turbo.json`, `package.json`, `yarn.lock` — Monorepo tooling.

## Project Structure (key folders)

- `apps/backend/lib` — Backend source code
  - `app_exception`, `constant`
  - `application` — use cases (e.g., `auth/signup_use_case.rb`)
  - `domain` — entities and repositories interfaces
  - `infrastructure` — persistence (ROM), repositories, entities
  - `presentation` — controllers, responses
- `apps/backend/helper` — Common helper utilities (e.g., JWT verification, response formatting). No unit tests required.
- `apps/backend/tasks` — Rake tasks (e.g., database migrations using Ridgepole). No unit tests required.
- `apps/backend/spec` — RSpec tests
  - `integration` — end-to-end style specs for controllers/auth
  - `infrastructure` — entities, repositories specs
  - `domain`, `application`, `presentation` — unit and component tests
- `apps/backend/openApi` — OpenAPI components and paths
- `apps/backend/sig` — RBS type signatures (generated and stubs)
- `apps/frontend/src` — Frontend source
  - `components` — Logic-less UI components
  - `features/components` — Components with business logic
  - `features/pages` — API requests and feature components orchestration
  - `lib` — Domain-specific common functions
  - `routes` — Solid Router route definitions
  - `schema` — Schema definitions (e.g., Zod, Valibot)
  - `util` — General utility logic

## How Junie should work on this repo

1. Prefer small, focused changes. Keep existing style and conventions.
2. If you change backend Ruby code, you must run the relevant RSpec tests before submitting.
3. If you change frontend code, follow the testing strategy:

- `src/util`: Unit tests
- `src/features/pages`: Integration tests
- `src/routes`: Unit tests
- `src/lib`:Unit tests

4. Backend unit tests should be performed only for code under `apps/backend/lib`. (Note: Code in other directories like
   `config` or `helper` does not require unit tests.)
5. Do not introduce new external services or long-running background commands unless requested.
6. When unsure about behavior, check specs under `apps/backend/spec` and OpenAPI under `apps/backend/openApi`.

- Backend uses `openapi_first` to validate requests against the OpenAPI spec in tests.

7. **Only use commands defined in `package.json` for running tasks, tests, and development.**

- Frontend tests and dev server use `infisicalLauncher` for secret management. Ensure it is available via `yarn`.

## Running Application (local)

Prerequisites: Node.js (>=22), Yarn, Ruby, Bundler, and a database (via Docker or locally). On Windows, use PowerShell.

### Starting Backend and Frontend together

From the repository root:

- Install dependencies: `yarn install`
- Start both services: `yarn dev`

### Running individual services

#### Backend

- Install dependencies: `cd apps\backend; bundle install`
- Start backend: `cd apps\backend; yarn dev`
- Database setup: `cd apps\backend; yarn migrate`

#### Frontend

- Install dependencies: `cd apps\frontend; yarn install`
- Start frontend: `cd apps\frontend; yarn dev`

### Generating API Types

The frontend uses `openapi-typescript` to generate TypeScript types from the backend OpenAPI specification.

- Run from frontend directory: `cd apps\frontend; yarn generate:api-types`
- Generated types are saved to `apps\frontend\src\schema\apiTypes.ts`.
- Run this whenever backend OpenAPI definitions change.

## Tests

### Backend Tests

Backend uses RSpec. Always run specs relevant to changed files; for broader changes, run the full suite via
`package.json` scripts.

- Run all backend tests:
  - `cd apps\backend; yarn test`
- Run linting:
  - `cd apps\backend; yarn lint`
- Run typecheck:
  - `cd apps\backend; yarn typecheck`

### Frontend Tests

- Run all frontend tests:
  - `cd apps\frontend; yarn test`
- Run E2E tests:
  - `cd apps\frontend; yarn test:e2e`

## Build and CI

- Unless otherwise specified, Junie should not build release artifacts before submitting. Focus on tests passing
  locally.
- If a build is required, prefer repo scripts (Turbo/Yarn workspaces): `yarn build`.

## Git Hooks (Lefthook)

This project uses `lefthook` for managing Git hooks.

- It is configured in `lefthook.yml` at the root.
- It typically runs linters and formatters before commits.
- To run hooks manually: `yarn lefthook run pre-commit`

## Code Style

- General:
  - Use LF (Line Feed) for line endings across all files.
- Ruby:
  - Match existing code style and module structure in `apps/backend/lib`.
  - Keep method and class naming consistent with surrounding code.
  - Maintain RBS signatures in `apps/backend/sig` if you alter public APIs; adjust generated files only via proper
    generation steps if available.
  - Favor RSpec idioms used in nearby specs; don’t add new testing frameworks.
- JavaScript/TypeScript (frontend):
  - Follow existing patterns in `apps/frontend/src`.
  - Use Yarn workspace scripts; do not introduce npm if Yarn is used.

## When to run tests before submitting

- Any backend code change (domain, infrastructure, application, presentation) → run backend tests via `yarn test`.
- Changes to generated type signatures alone typically do not require tests, but if they reflect code changes, run
  tests.
- If you change OpenAPI definitions, ensure you run `yarn generate:api-types` in `apps/frontend` to keep types in sync.
- Documentation-only changes (like this guidelines file) do not require running tests.

## Notes for Windows users

- Use PowerShell path separators (`\`).
- To chain commands, use `;` instead of `&&`.

## Contact/Extensions

- OpenAPI files in `apps/backend/openApi` describe backend endpoints; use them to validate request/response shapes.
  - The frontend uses these to generate types and the backend uses them for request validation in integration tests.
- If environment variables are needed, document them in the PR description.
  - Note: Frontend environment variables are managed via `infisical`.
