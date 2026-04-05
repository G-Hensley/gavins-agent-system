# GitHub Actions

## Standard CI Structure
```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:   # runs first — cheapest
  test:   # needs: lint — matrix across versions
  build:  # needs: test
  deploy: # needs: build, if: github.ref == 'refs/heads/main'
```
Gate each stage with `needs:` — if lint fails, test never starts.

## Matrix Strategy
```yaml
strategy:
  matrix:
    node-version: [18, 20]     # or python-version: ["3.11", "3.12"]
  fail-fast: true              # stop all matrix jobs on first failure
```

## Dependency Caching
```yaml
# Node
- uses: actions/setup-node@v4
  with: { node-version: 20, cache: 'npm' }   # or 'pnpm', 'yarn'

# Python
- uses: actions/setup-python@v5
  with: { python-version: '3.11', cache: 'pip' }

# Docker layers (buildx)
- uses: actions/cache@v4
  with:
    path: /tmp/.buildx-cache
    key: buildx-${{ hashFiles('Dockerfile') }}
```
Cache key must include a lock file hash — stale caches are worse than no cache.

## Security Scanning
```yaml
# Secrets detection (runs before code leaves the repo)
- uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

# Dependency audit
- run: npm audit --audit-level=high      # or: pip-audit -r requirements.txt

# Container image scan
- uses: aquasecurity/trivy-action@0.20.0
  with:
    image-ref: myapp:${{ github.sha }}
    exit-code: 1
    severity: CRITICAL,HIGH
```
Run gitleaks before build — stop secrets from reaching any artifact.

## Claude Code PR Review
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: |
      Review this PR for security issues, correctness, and adherence
      to project conventions. Flag blocking issues and suggestions separately.
```
Trigger on `pull_request: types: [opened, synchronize]`.

## Secrets Management
- Store secrets in GitHub Secrets (Settings → Secrets and variables → Actions)
- Use OIDC for AWS auth — no static `AWS_ACCESS_KEY_ID` in secrets
- Never `echo` a secret; GitHub masks `${{ secrets.X }}` but not derived values
- Rotate secrets on a schedule (90-day max for API keys)

## Branch Protection (repo settings, not workflow)
- Require status checks: `lint`, `test`, `security-scan`
- Require at least 1 PR review before merge
- Dismiss stale reviews on new push
- Block force push to `main`
- Require branches to be up to date before merge
