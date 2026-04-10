# Agent Template

Use this as the starting structure when generating a new agent file.

## Template

```markdown
---
name: <kebab-case-name>
description: <Role title>. <When to use — 1-2 sentences describing dispatch triggers and capabilities.>
tools: <comma-separated list, e.g., Read, Write, Edit, Bash, Grep, Glob>
model: <opus | sonnet | haiku>
skills:
  - <skill-name>
memory: <user | project>
---

You are a senior <role title>. <One sentence about what you do.>

## Before Starting

<Preconditions, setup steps, or context gathering. Remove section if not needed.>

## How You Work

<Numbered steps for the agent's core process. Be specific and actionable.>

## What You Build

<Concrete deliverables — files, tests, configs, documents.>

## What You Don't Do

- Don't <anti-pattern that prevents scope creep>
- Don't <anti-pattern that prevents overlap with other agents>
- Don't <quality anti-pattern>

<Status report instruction or memory update instruction.>
```

## Frontmatter Field Reference

| Field | Required | Values | Notes |
|-------|----------|--------|-------|
| name | yes | kebab-case | Must match filename |
| description | yes | string | Used by skill-router and Agent tool for dispatch |
| tools | yes | CSV | Read, Write, Edit, Bash, Grep, Glob — only include what's needed |
| model | yes | opus/sonnet/haiku | opus=complex, sonnet=implementation, haiku=simple |
| skills | yes | YAML list | Must reference existing skills in ~/.claude/skills/ |
| memory | no | user/project | user=persistent preferences, project=task-scoped context |

## Model Selection Guide

- **opus**: Architecture, design, complex reasoning, security review. Agents that make judgment calls.
- **sonnet**: Implementation, code review, exploration, QA. Agents that execute defined work.
- **haiku**: Documentation, simple transforms, fast lookups. Agents where speed > depth.

## Tool Selection Guide

Most agents need: `Read, Write, Edit, Bash, Grep, Glob`

Remove `Write` and `Edit` for read-only agents (reviewers, explorers).
Remove `Bash` if the agent doesn't need to run commands.

## Existing Skills (for reference)

architecture, ai-engineering, api-design, automation-engineering, backend-engineering,
brainstorming, code-review, create-agent, database-engineering, devops, doc-writing,
executing-plans, frontend-design, frontend-engineering, git-workflow, hookify,
parallel-agents, product-management, qa-engineering, refactoring, security,
skill-router, subagent-driven-development, systematic-debugging,
test-driven-development, threat-modeling, validation-and-verification, writing-plans
