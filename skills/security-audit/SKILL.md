---
name: security-audit
description: Run a full security audit on the current project. Use when the user says "security audit", "audit this project", "check for vulnerabilities", or before a release. Runs gitleaks, dependency audit, and code scanning in sequence.
last_verified: 2026-04-10
disable-model-invocation: true
allowed-tools: [Read, Bash, Grep, Glob]
---

# Security Audit

Run a comprehensive security audit: secrets scanning, dependency vulnerabilities, and code-level security review.

## Process

### 1. Detect Project Stack

- Check for `package.json` → Node.js project
- Check for `pyproject.toml` or `requirements.txt` → Python project
- Check for both → polyglot project
- Note the stack for tool selection

### 2. Secrets Scanning

Run gitleaks on the repo:
```
gitleaks detect --source . --verbose --no-banner 2>&1
```

- If gitleaks is not installed: `brew install gitleaks` or skip with warning
- Report any findings with file, line, and rule that triggered
- Do NOT echo the secret value — report the type and location only

### 3. Dependency Audit

**Node.js:**
```
pnpm audit --audit-level=moderate 2>&1
```

**Python:**
```
uv run pip-audit 2>&1 || pip audit 2>&1
```

- Report each vulnerable dependency with CVE, severity, and fix version
- Flag any critical/high findings as blockers

### 4. Static Analysis

**Python:**
```
ruff check . 2>&1
bandit -r src/ -ll 2>&1 || echo "bandit not installed"
```

**TypeScript:**
```
pnpm lint 2>&1 || echo "no lint script"
```

- Focus on security-relevant findings (injection, unsafe deserialization, hardcoded secrets)

### 5. Code Review

Dispatch the appropriate security reviewer agents based on what exists:
- Files in `src/api/`, `routes/`, `handlers/` → `backend-security-reviewer`
- Files in `src/components/`, `pages/`, `app/` → `frontend-security-reviewer`
- CloudFormation, CDK, Terraform files → `cloud-security-reviewer`
- Cross-cutting concerns → `appsec-reviewer`

### 6. Report

Produce a summary table:

| Category | Tool | Findings | Blockers |
|----------|------|----------|----------|
| Secrets | gitleaks | N | Y/N |
| Dependencies | pnpm audit / pip-audit | N | Y/N |
| Static Analysis | ruff / bandit / eslint | N | Y/N |
| Code Review | security agents | N | Y/N |

- Critical and High findings are blockers — must be fixed before merge/release
- Medium and Low are advisory — fix if practical
