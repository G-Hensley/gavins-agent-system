# Dependency Management

## Node.js (pnpm only)

**Lockfile discipline** — always commit `pnpm-lock.yaml`. Use `pnpm install --frozen-lockfile` in CI (deterministic, fast, fails on lockfile mismatch). Never `pnpm install` without lockfile in CI.

**Version pinning** — use exact versions for applications, `^` ranges for libraries.
```json
{
  "dependencies": {
    "express": "4.18.2",
    "zod": "3.22.4"
  },
  "devDependencies": {
    "vitest": "^1.0.0"
  },
  "engines": {
    "node": ">=20.0.0"
  }
}
```

**Auditing** — run `pnpm audit` before merging PRs. Fix auto-fixable issues with `pnpm audit --fix`. Manual review for breaking changes.

**Docker** — keep `devDependencies` out of production images.
```dockerfile
FROM node:20-slim AS build
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

FROM node:20-slim
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod
COPY --from=build /app/dist ./dist
CMD ["node", "dist/index.js"]
```

## Python (uv only)

**Lockfile workflow** — use `uv` for reproducible installs.
```bash
# pyproject.toml is the single source of truth
# Generate lockfile
uv lock

# Install from lockfile (CI and deploys)
uv sync --frozen
```

**Virtual environments** — `uv` manages these automatically. Never use `pip`, `poetry`, or `pipenv`.
```bash
# uv creates and manages .venv automatically
uv sync          # install deps into .venv
uv run pytest    # run commands in the venv
uv add fastapi   # add a dependency
```

**Project metadata** — use `pyproject.toml` as the single source of truth.
```toml
[project]
name = "my-service"
version = "1.0.0"
requires-python = ">=3.11"
dependencies = [
    "fastapi==0.109.0",
    "pydantic>=2.0,<3.0",
]

[dependency-groups]
dev = ["pytest>=8.0", "ruff>=0.2"]
```

**Auditing** — run `uv pip audit` before merging. Fails on known vulnerabilities.

## Cross-Language

**Automated updates** — configure Dependabot or Renovate. Group minor/patch updates, review majors individually.
```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      minor-and-patch:
        update-types: ["minor", "patch"]
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
```

**Before major version bumps** — read changelog, check for breaking changes in your usage, run full test suite, update one major dep per PR to isolate blast radius.

**Lock transitive deps** — lockfiles (`pnpm-lock.yaml`, `uv.lock`) pin the full dependency tree. Without them, builds are non-deterministic.

**Separate dev and prod deps** — dev tools (linters, test frameworks, type checkers) never ship to production. Use `devDependencies` (Node) or `[dependency-groups]` (Python).

**License compliance:**
| License | Status | Notes |
|---------|--------|-------|
| MIT, Apache 2.0, BSD, ISC | Safe | Permissive, no concerns |
| LGPL | Caution | OK for dynamic linking, review if bundling |
| GPL, AGPL | Avoid | Copyleft — can infect your codebase |
| No license | Avoid | No legal right to use |

Check with `pnpm licenses list` (Node) or `uv pip list --format=columns` (Python).
