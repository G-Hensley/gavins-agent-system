---
name: doc-sync
description: Check for stale documentation and update it. Use when docs may be out of date, after significant code changes, when the user says "sync docs", "update docs", "are docs current", or when triggered by the doc-drift hook. Compares code changes against doc timestamps and updates what's drifted.
last_verified: 2026-04-10
disable-model-invocation: true
allowed-tools: [Read, Write, Edit, Bash, Grep, Glob]
---

# Doc Sync

Review code changes since documentation was last updated. Identify stale docs and update them.

## Context

Recent commits: !`git log --oneline -10 2>/dev/null || echo "no git history"`
Last doc changes: !`git log --oneline --diff-filter=M -- '*.md' -5 2>/dev/null || echo "no doc changes found"`

## Process

### 1. Identify What Changed

Compare code changes against documentation timestamps:

```bash
# Files changed since the most recent doc commit
LAST_DOC_COMMIT=$(git log -1 --format=%H -- '*.md' 2>/dev/null)
git diff --name-only $LAST_DOC_COMMIT..HEAD 2>/dev/null
```

If no doc commit found, compare against the last 10 commits.

### 2. Map Changes to Docs

Check each documentation file against what it covers:

| Doc File | Stale When |
|----------|-----------|
| `README.md` | New skills/agents/commands added or removed, install process changed, repo structure changed |
| `CLAUDE.md` | New rules, workflow changes, stack preferences changed |
| `CONTEXT.md` | Pipeline changed, new agents, parallelism rules updated |
| `docs/STATUS.md` | Any improvement completed, eval run, counts changed |
| `docs/SKILL-CHAINS.md` | New skills added to chains, `follows:` fields changed |
| `docs/HANDOFF-PROTOCOLS.md` | New agents, handoff contracts changed |
| `evals/agent-coverage.md` | New agents or evals added |
| Individual `SKILL.md` files | Skill content changed but `last_verified` not updated |
| Individual agent `.md` files | Agent skills or handoff sections changed |

### 3. Check Counts and Lists

Verify that hardcoded counts are still accurate:
- Number of skills (check `ls skills/ | wc -l`)
- Number of agents (check `ls agents/ | wc -l`)
- Number of rules (check `ls rules/ | wc -l`)
- Number of reference files
- Number of eval checks in validate.sh output

Cross-reference against README.md, CONTEXT.md, STATUS.md.

### 4. Update Stale Docs

For each stale document:
- Read the current content
- Identify the specific sections that are outdated
- Update only the stale parts — don't rewrite docs that are current
- Update `last_verified` dates on skills that were verified

### 5. Report

Summarize what was updated:
- Which docs were stale and why
- What was changed in each
- Any docs that need manual review (ambiguous changes)
