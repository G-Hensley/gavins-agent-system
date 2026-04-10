---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.py"
  - "**/package.json"
  - "**/pyproject.toml"
  - "**/requirements*.txt"
  - "**/Cargo.toml"
---

# Dependency & Library Rules

## Context7 — Always Check Docs First

Before using any third-party package, library, or framework API:

1. Use Context7 MCP (`resolve-library-id` then `get-library-docs`) to look up the current API surface
2. Do not rely on training data for library APIs — versions change, methods get deprecated
3. This applies to: npm packages, PyPI packages, framework APIs (Next.js, FastAPI, etc.), AWS SDK, database drivers, test frameworks

If Context7 is unavailable, state that you're working from training data and flag that the API usage should be verified.

## Package Managers — Strict Enforcement

- **TypeScript/Node.js**: pnpm only. Never npm or yarn. Never npx — use `pnpm exec` or `pnpm create`.
  - `pnpm install` not `npm install`. `pnpm add <pkg>` not `npm install <pkg>`.
  - `pnpm exec <tool>` not `npx <tool>`. `pnpm create next-app` not `npx create-next-app`.
  - `pnpm run dev` not `npm run dev`. `pnpm test` not `npm test`.
  - CI: `pnpm install --frozen-lockfile` not `npm ci`.
- **Python**: uv only. Never pip, poetry, or pipenv.
  - `uv add <pkg>` not `pip install`. `uv run pytest` not `pytest` or `python -m pytest`.
- Run `pnpm audit` or `uv pip audit` when adding or updating dependencies.
- If docs, tutorials, or AI output uses npm/npx/yarn/pip — translate to pnpm/uv before running.

## Version Pinning

- Exact versions for production dependencies
- Lock files (`pnpm-lock.yaml`, `uv.lock`) always committed
- Review changelogs before major version bumps
