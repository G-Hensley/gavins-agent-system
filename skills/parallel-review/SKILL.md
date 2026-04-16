---
name: parallel-review
description: Dispatch multiple reviewer agents in parallel with structured output. Use when the user says "review this", "full review", "parallel review", or before merging significant changes. Each reviewer writes findings to reviews/<name>.md, then a punchlist is generated.
last_verified: 2026-04-10
disable-model-invocation: true
---

# Parallel Review

Dispatch specialist reviewers in parallel, each writing findings to disk. Aggregate into a ranked punchlist.

## Process

### 1. Determine Scope

- Identify changed files: `git diff --name-only HEAD~1` or `git diff --name-only main...HEAD`
- Determine which reviewers are relevant based on file types:
  - `*.py`, `*.ts`, `*.js` source files → `code-quality-reviewer`
  - Backend routes, handlers, auth → `backend-security-reviewer`
  - React components, client-side code → `frontend-security-reviewer`
  - CloudFormation, CDK, IAM, infra → `cloud-security-reviewer`
  - Cross-cutting (deps, auth flow, config) → `appsec-reviewer`
- Skip reviewers that have no matching files

### 2. Create Output Directory

```bash
mkdir -p reviews/
```

### 3. Dispatch Reviewers in Parallel

Dispatch each relevant reviewer as a subagent. Each reviewer MUST:
- Write findings to `reviews/<reviewer-name>.md`
- Never report findings inline only — disk output is the contract
- Use this format for each finding:

```markdown
## [P0|P1|P2] Finding Title

- **File:** path/to/file.ts:42
- **Severity:** P0 (blocker) | P1 (should fix) | P2 (nice to have)
- **Description:** What's wrong
- **Fix:** How to fix it
```

### 4. Aggregate Punchlist

After all reviewers complete, read all `reviews/*.md` files and produce `reviews/PUNCHLIST.md`:

- Deduplicate findings (same file + same issue from multiple reviewers)
- Sort by severity: P0 first, then P1, then P2
- Include source reviewer for each finding
- Summary counts at top: N findings (X P0, Y P1, Z P2)

### 5. Report

Present the punchlist summary to the user:
- Total findings by severity
- P0 blockers listed explicitly
- Path to full punchlist: `reviews/PUNCHLIST.md`

## Severity Guide

| Level | Meaning | Action |
|-------|---------|--------|
| P0 | Blocker — security vuln, data loss, broken functionality | Must fix before merge |
| P1 | Should fix — code quality, missing validation, test gaps | Fix in this PR if practical |
| P2 | Nice to have — naming, style, minor optimization | Fix or defer with justification |
