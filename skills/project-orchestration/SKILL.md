---
name: project-orchestration
description: End-to-end pipeline for building a feature or project — stitches existing skills/agents into a sequence with horizontal PM, git rhythm, and validation threads. Use when starting a feature, project, or major change that will touch multiple skills, when the user says "build me X", or when transitioning from "we have an idea" to "we have it shipped". Generic across stacks — not web-app-specific.
last_verified: 2026-04-26
---

# Project Orchestration

Master pipeline that stitches the existing skills and agents into an end-to-end flow. Generic — works for backend services, CLI tools, agents, web apps, anything.

This skill is the conductor, not the orchestra. It points at the underlying skills/agents at each phase rather than duplicating their logic. If a phase changes, the underlying skill changes; this one stays small.

## Pipeline

Sequential phases. Conditional phases are marked — skip them when their gating condition doesn't fire.

1. **Brainstorm** → `brainstorming` skill. Explore intent, constraints, must-haves vs. nice-to-haves. No code, no agents.
2. **Requirements** → `product-manager` agent. Writes PRD (`docs/prd/YYYY-MM-DD-<project>-prd.md`). Skip if the work is a small feature on an existing product — go straight to architecture.
3. **Architecture** → `architect` agent + `code-explorer` agents in parallel for existing codebases. Produces design doc.
4. **Threat model** *(conditional)* → `threat-modeler` agent. Fires when the design touches auth, PII, payments, multi-tenant boundaries, or external integrations. Can run in parallel with architecture review.
5. **Design system** *(conditional)* → `uiux-designer` agent. Fires when the project has a UI surface. Produces the design system BEFORE any frontend code (colors, typography, spacing, component specs).
6. **Database schema** *(conditional)* → `database-engineer` agent. Fires when the project owns persistent data. Schema, indexes, migration strategy.
7. **Scaffolding** → `project-scaffolding` skill. Creates the project's `CLAUDE.md`, `CONTEXT.md`, and bootstraps `docs/TASKS.md` via the `task-tracking` skill.
8. **Plan** → `writing-plans` skill. Multi-task implementation plan from the architecture, sized so each task = one PR.
9. **Plan review** *(conditional, mandatory per rules)* → `codex-plan-review` skill. Fires when the plan touches auth, DB schema, API contracts, infrastructure, data migrations, or irreversible one-shots. See `rules/codex-plan-review.md`.
10. **Build loop** → `subagent-driven-development` skill. One PR per task by default (per its built-in per-task PR rhythm). The orchestrator dispatches `implementer`, `spec-reviewer`, `code-quality-reviewer` per task, then commits/pushes/PRs.
11. **QA** *(conditional)* → `qa-engineer` agent. Fires when E2E coverage, load testing, or test data strategy needs attention beyond per-task unit tests. Can be folded into the build loop or done as a final pass.
12. **DevOps** *(conditional)* → `devops-engineer` agent. Fires when the project ships infrastructure (Dockerfile, CI/CD, AWS CDK, monitoring). Often parallel with build loop.
13. **Release** → `git-workflow` skill, Phase 3. For per-task-PR mode (the default), most work is already shipped by the time you reach this step — release is mostly version tagging and announcement. For Single-PR mode, this is where the final merge happens.
14. **Documentation** → `doc-writer` agent. README, ADRs, runbooks, API docs. Often catches up at release time.

## Horizontal Threads

These run continuously across phases — they are not phases of their own.

### Project management thread

- Started in phase 2 (requirements). Maintained through release.
- `docs/TASKS.md` is the canonical state (per the `task-tracking` skill).
- Re-dispatch the `project-manager` agent at phase boundaries (after each major phase finishes), after each PR merges, when a blocker surfaces, or when the operator says "where are we" / "what's next".
- The `product-manager` agent is one-shot at phase 2; the `project-manager` agent is on-call after that.

### Git-rhythm thread

- Per task in phase 10: implement → 2-stage review → commit → push → PR → review → merge → status update → next task.
- Stack PRs when tasks build on each other and review-wait would block.
- Single-PR mode is opt-in, requested up front, justified in the PR description. Default is per-task.
- See `subagent-driven-development` Phase 2e for the mechanics.

### Validation thread

- `validation-and-verification` skill is invoked at every claim of "done" — not just at the end of the pipeline.
- Each phase produces evidence: PRD, design doc, plan, passing tests, merged PRs. The next phase reads the evidence; do not accept verbal "I think it works."

## When to Skip Phases

| Phase | Skip when |
|---|---|
| 2. Requirements (PRD) | Small feature on an existing product. Go straight to architecture |
| 4. Threat model | No auth, PII, payments, multi-tenant, or external integrations |
| 5. Design system | No UI surface |
| 6. Database schema | No persistent data ownership |
| 9. Plan review | Plan does not touch the categories in `rules/codex-plan-review.md` |
| 11. QA | Per-task tests cover the surface; no E2E or load needs |
| 12. DevOps | No new infrastructure or deployment changes |

Skipping is a deliberate decision. Note skipped phases in the project's `docs/TASKS.md` so future sessions know what was intentionally not done.

## What NOT to Do

- Do not duplicate logic from the underlying skills here. If a phase needs more detail, edit the underlying skill, not this one
- Do not reorder phases without an explicit reason. The order encodes review and handoff dependencies
- Do not run phases purely sequentially when parallelism is safe — architecture + threat model can overlap, build + DevOps often do
- Do not skip the conditional phases by default — check the gating condition; if it fires, run the phase
- Do not defer all git work to the end (Single-PR mode is opt-in, not the default — see `subagent-driven-development`)
- Do not let the project-management thread go silent for more than ~5 PRs without a status sweep
- Do not reach phase 14 (Docs) and discover that no one updated TASKS.md across the build — the on-call PM thread prevents this

## References

This skill points at, but does not duplicate:

- `brainstorming` skill (phase 1)
- `product-manager` agent (phase 2 — one-shot PRD)
- `project-manager` agent (PM thread — on-call coordinator)
- `architect` + `code-explorer` agents (phase 3)
- `threat-modeler` agent (phase 4)
- `uiux-designer` agent (phase 5)
- `database-engineer` agent (phase 6)
- `project-scaffolding` skill (phase 7) — bootstraps `docs/TASKS.md` via `task-tracking`
- `task-tracking` skill (PM thread substrate)
- `writing-plans` skill (phase 8)
- `codex-plan-review` skill (phase 9, conditional, per `rules/codex-plan-review.md`)
- `subagent-driven-development` skill (phase 10) — owns per-task PR rhythm
- `qa-engineer` agent (phase 11)
- `devops-engineer` agent (phase 12)
- `git-workflow` skill (phase 13 + git-rhythm thread)
- `doc-writer` agent (phase 14)
- `validation-and-verification` skill (validation thread — every "done" claim)

The `/plan` command implements phases 1, 2, 3, and 8 as a guided front half. This skill is the full pipeline including execution and delivery.
