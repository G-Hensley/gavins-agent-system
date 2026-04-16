---
name: resolve-pr-comments
description: Resolve all unresolved PR review comments. Use when the user says "resolve PR comments", "fix review feedback", "address PR feedback", or after receiving a PR review. Fetches comments via gh, fixes each, runs tests, commits, and pushes.
last_verified: 2026-04-10
disable-model-invocation: true
argument-hint: "[pr-number]"
allowed-tools: [Read, Write, Edit, Bash, Grep, Glob]
---

# Resolve PR Comments

Fetch all unresolved review comments on a PR, fix each one, verify, commit, and push.

## Process

### 1. Identify the PR

- If `$0` is provided, use it as the PR number
- Otherwise, detect from current branch: `gh pr view --json number -q .number`
- If no PR found, ask the user

### 2. Fetch Unresolved Comments

```
gh api repos/{owner}/{repo}/pulls/{pr}/comments --jq '.[] | select(.position != null) | {id, path, line: .original_line, body, user: .user.login}'
```

- Group comments by file
- Skip bot comments and resolved threads
- Present a summary: "Found N unresolved comments across M files"

### 3. Fix Each Comment

For each comment, in order:
1. Read the referenced file and line
2. Understand what the reviewer is asking for
3. Make the fix
4. If the fix is ambiguous, ask the user before proceeding

### 4. Verify

After all fixes:
- Run tests: `uv run pytest` (Python) or `pnpm test` (TypeScript)
- Run linter: `ruff check` (Python) or `pnpm lint` (TypeScript)
- If any fail, fix before proceeding

### 5. Commit and Push

- Stage only the files that were changed to address comments
- Commit message: `fix: address PR review feedback`
- Verify active GitHub account: `gh auth status`
- Push to the PR branch
- Do NOT include SQL keywords like DROP TABLE in commit messages

### 6. Report

List each comment addressed with:
- File and line
- What the reviewer asked
- What was changed
