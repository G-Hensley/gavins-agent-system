---
name: skill-router
description: Ensure the right skills activate for every task. Use when starting any conversation, beginning a new task, or switching between tasks. Check which skills apply and invoke them before responding. If there is even a small chance a skill is relevant, invoke it.
last_verified: 2026-04-04
---

# Skill Router

Before responding to any task, check which skills apply and invoke them.

## Process

### Step 1: Check Priority Order

1. **User instructions** (CLAUDE.md, direct requests) — highest priority
2. **Skills** — override default behavior where they apply
3. **Default system behavior** — lowest priority

### Step 2: Select Skills

For each task, check this routing:

**Ideation / "I want to build..."** → `brainstorming`
**Requirements / PRDs / user stories** → `product-management`
**Technical design / system design** → `architecture`
**Implementation planning** → `writing-plans`
**Executing plans (small)** → `executing-plans`
**Executing plans (large, multi-task)** → `subagent-driven-development`
**Multiple independent problems** → `parallel-agents`
**Bug / test failure / unexpected behavior** → `systematic-debugging`
**Writing code** → `test-driven-development`
**Claiming work is done** → `validation-and-verification`
**Code review (request or receive)** → `code-review`
**Git operations (commit, push, PR, worktree, branch cleanup)** → `git-workflow`
**Backend (Python, Node, Java, APIs, services)** → `backend-engineering`
**Database (schema, queries, migrations, DynamoDB)** → `database-engineering`
**Frontend code (React, Next.js, components, state)** → `frontend-engineering`
**UI/UX design (colors, typography, spacing, hierarchy)** → `frontend-design`
**DevOps (CI/CD, Docker, AWS infra, monitoring)** → `devops`
**Automation (CLI tools, scripts, pipelines, batch)** → `automation-engineering`
**QA (test strategy, E2E, load testing, test data)** → `qa-engineering`
**Refactoring / cleaning up / technical debt** → `refactoring`
**API design / OpenAPI / REST conventions** → `api-design`
**Threat modeling / attack surface / VAST** → `threat-modeling`
**Security (frontend, API, DB, AWS, supply chain, appsec)** → `security`
**Documentation (CLAUDE.md, README, ADR, runbook, API docs)** → `doc-writing`
**AI agents / chatbots / LLM / RAG / prompt engineering** → `ai-engineering`
**Safety rules / hooks / "block this" / "warn me when"** → `hookify`
**Starting a new project / setting up project context** → `project-scaffolding`
**Creating or improving skills** → `skill-creator`

### Step 3: Lifecycle Skills

These skills apply at phase transitions, not to domain work:

**After brainstorming/planning, before coding** → `project-scaffolding` (creates project CLAUDE.md + CONTEXT.md)
**After completing work, before claiming done** → `validation-and-verification` (evidence before claims)

### Step 4: Skills vs Agents

**Skills** provide knowledge and process — they guide HOW to work.
**Agents** do the work — dispatch them for actual implementation, review, or design.

When a task needs both knowledge AND execution:
1. Invoke the skill (loads domain knowledge)
2. Dispatch the appropriate agent (does the work using that knowledge)

Example: "Build an API endpoint" → invoke `backend-engineering` skill + dispatch `backend-engineer` agent.

### Step 5: Flag Gaps

After completing a task, check whether the system served you well:

- **No skill matched** — you improvised without guidance → log to `improvements/skills/`
- **Skill matched but reference was thin** — you had to research what a reference should have covered → log to `improvements/skills/`
- **Agent lacked a skill** — the dispatched agent needed domain knowledge it didn't have → log to `improvements/agents/`
- **New pattern emerged** — you solved something in a way that should be codified → log to `improvements/skills/`

Write the suggestion file *immediately* — don't defer. Use the format in `improvements/README.md`.

### Step 6: Apply Rules

- If a skill might apply, invoke it — do not rationalize skipping it
- Multiple skills can apply to one task (e.g., TDD + backend-engineering for an API)
- Skills that apply to process (TDD, verification) apply alongside domain skills
- When in doubt, invoke the skill — it's cheaper than missing it
