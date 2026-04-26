# New skill: project-orchestration

## What I Observed

There is no skill that stitches the existing skills/agents into a full end-to-end pipeline. `skill-router` is a flat lookup table by task type. CLAUDE.md's Agent Dispatch Guide is a flat lookup table by situation. Both answer "which skill for this task" but neither answers "what is the order of operations for building a feature from idea to shipped PR."

Surfaced during a conversation with another Claude Code session asked "What order of operations would you follow to build a web app?" The first answer was a defensible synthesis of skill-router + Dispatch Guide rendered as a waterfall. The second answer (with horizontal PM thread, PR-per-task rhythm) was good content but invented on the spot — not in any skill, rule, or doc.

## Why It Would Help

- New work currently relies on the operator (Gavin) holding the pipeline in his head and dispatching skills/agents in the right order
- Without a documented pipeline, sessions waterfall through phases and leave PR/PM/tracking work for the end where it gets dropped
- The pipeline shape is generic — it applies to backend services, CLI tools, agents, web apps, anything. It is not web-app-specific
- Newly-onboarded Claude Code sessions (or other contributors using the system) cannot self-discover the order
- The pipeline shape is also where horizontal threads (project management, git rhythm, validation) belong — they cut across phases and must be embedded in the orchestration

## Proposal

Create `skills/project-orchestration/SKILL.md` (~150 lines, well under the 200-line cap).

Structure:

```markdown
---
name: project-orchestration
description: End-to-end pipeline for building a feature or project — stitches existing skills/agents into a sequence with horizontal PM and git-rhythm threads. Use when starting a feature, project, or major change that will touch multiple skills.
---

# Project Orchestration

## Phases (sequential)

1. Brainstorm — `brainstorming` skill
2. Requirements — `product-manager` agent (PRD)
3. Architecture — `architect` agent + `code-explorer` agents in parallel
4. Threat model (conditional) — `threat-modeler` agent if auth/PII/payments/multi-tenant
5. Design system (conditional) — `uiux-designer` agent if UI work
6. Database schema (conditional) — `database-engineer` agent if data work
7. Scaffolding — `project-scaffolding` skill (CLAUDE.md/CONTEXT.md)
8. Plan — `writing-plans` skill
9. Plan review (conditional, mandatory per rules) — `codex-plan-review` skill
10. Build loop — `subagent-driven-development` skill
11. QA — `qa-engineer` agent
12. DevOps — `devops-engineer` agent
13. Release — `git-workflow` Phase 3 (finishing-a-development-branch)
14. Docs — `doc-writer` agent

## Horizontal threads (run continuously)

### Project management thread
- Started in phase 2 (requirements), maintained through release
- Backed by `docs/TASKS.md` (per the new task-tracking skill)
- Re-dispatch the project-manager agent (or its replacement) at phase boundaries to update status, log blockers, mark tickets in/out of scope

### Git-rhythm thread
- Per task (in phase 10): implement → 2-stage review → commit → push → PR → review → merge → status update → next task
- Stacked PRs when tasks build on each other and review wait would block
- See per-task PR extension to subagent-driven-development

### Validation thread
- `validation-and-verification` skill is invoked at every claim of done — not just at the end
```

## Open questions for review

- Should this be a skill or a rule? Skills are invoked; rules are always-active. A pipeline you walk through feels skill-shaped.
- Should the conditional phases (threat-model, design system, DB schema) be part of the main numbered list with "(conditional)" markers, or split into a separate section? Lean toward inline with markers — easier to spot what was skipped and why.
- This skill should NOT duplicate logic from the underlying skills it points at — only the order, the conditions, and the handoff artifacts. If a phase changes, the underlying skill changes; this one stays small.

## Naming alternatives

- `project-orchestration` (clearest about intent)
- `building-features` (more action-oriented but ambiguous with frontend-engineering)
- `end-to-end-pipeline` (descriptive, less verb-y)
