# Skill Template

Use this as the starting structure when generating a new skill.

## Template — Reference Skill (domain knowledge)

```markdown
---
name: <kebab-case-name>
description: <What it covers and when to use it. Front-load keywords. Max 250 chars.>
last_verified: <YYYY-MM-DD>
paths:
  - "<glob pattern for auto-activation>"
---

# <Skill Name>

<One paragraph overview of what this skill covers.>

## Process

### 1. <First Step>
<Instructions for Claude when this skill is active.>

### 2. <Second Step>
<Continue with numbered steps.>

## Reference Files

- `references/<name>.md` — <What it covers>
```

## Template — Task Skill (step-by-step workflow)

```markdown
---
name: <kebab-case-name>
description: <Action verb + what it does. When to use. Trigger keywords.>
last_verified: <YYYY-MM-DD>
disable-model-invocation: true
argument-hint: "[<required-arg>]"
---

# <Skill Name>

<One sentence: what this skill does when invoked.>

## Process

### 1. Gather Input
<What to collect from arguments or the user.>

### 2. <Core Action>
<The main work the skill performs.>

### 3. Verify
<How to confirm the work is correct.>

## Reference Files

- `references/<name>.md` — <What it covers>
```

## Template — Forked Skill (isolated subagent)

```markdown
---
name: <kebab-case-name>
description: <What it does in isolation.>
last_verified: <YYYY-MM-DD>
context: fork
agent: <Explore | Plan | general-purpose | custom-agent-name>
model: <opus | sonnet | haiku>
allowed-tools: [Read, Grep, Glob, Bash]
---

<Task instructions for the subagent. This becomes the task prompt.>

Research $ARGUMENTS and report:
1. <What to find>
2. <What to analyze>
3. <What to return>
```

## Frontmatter Field Reference

| Field | Required | Values | Notes |
|-------|----------|--------|-------|
| name | yes | kebab-case | Must match directory name, max 64 chars |
| description | recommended | string | Front-load use case. Used for auto-invocation matching |
| last_verified | yes | YYYY-MM-DD | For staleness detection |
| paths | no | glob list | Auto-activate when working with matching files |
| context | no | `fork` | Run in isolated subagent |
| agent | no | string | Subagent type when context: fork |
| model | no | opus/sonnet/haiku | Override session model |
| allowed-tools | no | list | Restrict available tools |
| disable-model-invocation | no | boolean | true = manual invoke only |
| user-invocable | no | boolean | false = Claude-only, hidden from menu |
| argument-hint | no | string | Shown in autocomplete (e.g., `[filename]`) |

## Dynamic Context Injection

Inject live data into skill content (runs before Claude sees it):

```markdown
Current branch: !`git branch --show-current`
Changed files: !`git diff --name-only HEAD~1`
```

Commands must have fallbacks: `!`git status --short 2>/dev/null || echo "not a git repo"``

## String Substitutions

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed to skill |
| `$0`, `$1`, ... | Individual arguments (0-indexed) |
| `${CLAUDE_SKILL_DIR}` | Absolute path to skill directory |
| `${CLAUDE_SESSION_ID}` | Current session ID |

## Existing Skills (for conflict check)

ai-engineering, api-design, architecture, automation-engineering, backend-engineering,
brainstorming, code-review, create-agent, create-skill, database-engineering, devops,
doc-writing, executing-plans, frontend-design, frontend-engineering, git-workflow,
hookify, parallel-agents, product-management, project-scaffolding, qa-engineering,
refactoring, security, skill-router, subagent-driven-development,
systematic-debugging, test-driven-development, threat-modeling,
validation-and-verification, writing-plans
