# Dependency Management

## Node.js

**Lockfile discipline** — always commit `package-lock.json`. Use `npm ci` in CI (deterministic, fast, fails on lockfile mismatch). Never `npm install` in CI.

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

**Auditing** — run `npm audit` before merging PRs. Fix auto-fixable issues with `npm audit fix`. Manual review for breaking changes from `npm audit fix --force`.

**Docker** — keep `devDependencies` out of production images.
```dockerfile
FROM node:20-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-slim
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=build /app/dist ./dist
CMD ["node", "dist/index.js"]
```

## Python

**Lockfile workflow** — use `pip-tools` for reproducible installs.
```bash
# requirements.in — what you depend on (ranges for libs, pins for apps)
fastapi==0.109.0
pydantic>=2.0,<3.0

# Generate lockfile
pip-compile requirements.in -o requirements.txt

# Install from lockfile (CI and deploys)
pip install -r requirements.txt
```

**Virtual environments** — always isolate. Never install into system Python.
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
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

[project.optional-dependencies]
dev = ["pytest>=8.0", "ruff>=0.2"]
```

**Auditing** — run `pip audit` before merging. Fails on known vulnerabilities.
```bash
pip install pip-audit
pip-audit -r requirements.txt
```

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

**Lock transitive deps** — lockfiles (`package-lock.json`, `requirements.txt` from pip-compile) pin the full dependency tree. Without them, builds are non-deterministic.

**Separate dev and prod deps** — dev tools (linters, test frameworks, type checkers) never ship to production. Use `devDependencies` (Node) or `[project.optional-dependencies]` (Python).

**License compliance:**
| License | Status | Notes |
|---------|--------|-------|
| MIT, Apache 2.0, BSD, ISC | Safe | Permissive, no concerns |
| LGPL | Caution | OK for dynamic linking, review if bundling |
| GPL, AGPL | Avoid | Copyleft — can infect your codebase |
| No license | Avoid | No legal right to use |

Check with `npx license-checker --summary` (Node) or `pip-licenses` (Python).
