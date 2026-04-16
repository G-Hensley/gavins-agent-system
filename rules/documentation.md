---
paths:
  - "**/*.md"
  - "**/CLAUDE.md"
  - "**/README.md"
---

# Documentation Rules

## Keep Docs Current

- When you add, remove, or rename a skill, agent, command, rule, or hook, check that all docs referencing counts or lists are still accurate
- Key files to verify: README.md, CLAUDE.md, CONTEXT.md, docs/STATUS.md, evals/agent-coverage.md
- Don't hardcode counts when avoidable — but when docs state a number, update it everywhere

## After Multiple Commits

- If 3+ code commits have been made without updating docs, proactively check for drift
- Run `/doc-sync` or manually compare recent changes against doc content
- Pay special attention to: README install instructions, skill/agent counts, pipeline descriptions

## Doc Quality

- Every doc file should have a clear purpose — if you can't say what it's for in one sentence, split or delete it
- Keep CLAUDE.md under 200 lines — move detailed instructions to rules/ or skills/
- Reference files under 200 lines each — split large references into focused files
- Update `last_verified` on skills when you verify their content is still accurate
