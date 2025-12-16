# Project Guidelines — Attendance Management (Monorepo)

Last updated: 2025-12-16

## Overview
This repository is a monorepo containing a Ruby backend (Hanami/Roda/ROM style stack with RSpec tests and Sorbet/RBS types) and a JavaScript frontend (Node/Yarn workspace). Docker is available for local development. The backend exposes authentication and user management endpoints and includes OpenAPI specs. Tests live under `apps/backend/spec` and cover domain, infrastructure, presentation, and integration layers.

Top-level items of interest:
- `apps/backend` — Ruby backend application (domain, application/use_cases, infrastructure, presentation/controllers, specs, OpenAPI).
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
- `apps/backend/spec` — RSpec tests
  - `integration` — end-to-end style specs for controllers/auth
  - `infrastructure` — entities, repositories specs
  - `domain`, `application`, `presentation` — unit and component tests
- `apps/backend/openApi` — OpenAPI components and paths
- `apps/backend/sig` — RBS type signatures (generated and stubs)
- `apps/frontend/src` — Frontend source (components, routes)

## How Junie should work on this repo
1. Prefer small, focused changes. Keep existing style and conventions.
2. If you change backend Ruby code, you must run the relevant RSpec tests before submitting.
3. Do not introduce new external services or long-running background commands unless requested.
4. When unsure about behavior, check specs under `apps/backend/spec` and OpenAPI under `apps/backend/openApi`.

## Running Backend (local)
Prerequisites: Ruby (version compatible with the project), Bundler, and a database (via Docker or locally). On Windows, use PowerShell.

- Install dependencies:
  - Ruby gems: `cd apps\backend; bundle install`
  - If using Docker for DB: `docker-compose up -d`
- Database setup (if applicable for the stack): run the project’s migration task (check available Rake tasks). Common examples:
  - `bundle exec rake db:create`
  - `bundle exec rake db:migrate`
- Run the app (example, adjust to project’s actual entry):
  - `bundle exec rackup` or `bundle exec hanami server` (depending on framework in use)

If a framework-specific command exists in this project, prefer that over the generic examples.

## Running Frontend (local)
- From repo root: `yarn install`
- Then: `yarn --filter apps/frontend dev` (or `cd apps\frontend; yarn dev`) depending on workspace setup.

## Tests
Backend uses RSpec. Always run specs relevant to changed files; for broader changes, run the full suite.

- Run all backend tests:
  - `cd apps\backend; bundle exec rspec`
- Run a subset (example for auth specs):
  - `bundle exec rspec spec\integration\auth_integration_spec.rb`
- Coverage is generated under `apps/backend/coverage` (open `index.html`).

Frontend test setup is not enforced here; if frontend tests are added, follow the package.json scripts.

## Build and CI
- Unless otherwise specified, Junie should not build release artifacts before submitting. Focus on tests passing locally.
- If a build is required, prefer repo scripts (Turbo/Yarn workspaces) and document the steps taken.

## Code Style
- Ruby:
  - Match existing code style and module structure in `apps/backend/lib`.
  - Keep method and class naming consistent with surrounding code.
  - Maintain RBS signatures in `apps/backend/sig` if you alter public APIs; adjust generated files only via proper generation steps if available.
  - Favor RSpec idioms used in nearby specs; don’t add new testing frameworks.
- JavaScript/TypeScript (frontend):
  - Follow existing patterns in `apps/frontend/src`.
  - Use Yarn workspace scripts; do not introduce npm if Yarn is used.

## When to run tests before submitting
- Any backend code change (domain, infrastructure, application, presentation) → run RSpec.
- Changes to generated type signatures alone typically do not require tests, but if they reflect code changes, run tests.
- Documentation-only changes (like this guidelines file) do not require running tests.

## Notes for Windows users
- Use PowerShell path separators (`\`).
- To chain commands, use `;` instead of `&&`.

## Contact/Extensions
- OpenAPI files in `apps/backend/openApi` describe backend endpoints; use them to validate request/response shapes.
- If environment variables are needed, document them in the PR description.
