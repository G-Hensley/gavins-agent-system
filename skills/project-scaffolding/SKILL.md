---
name: project-scaffolding
description: Create project-level CLAUDE.md, CONTEXT.md, and bootstrap docs/TASKS.md before writing any code. Use after brainstorming/planning converges on a direction and before implementation begins — when transitioning from "what to build" to "building it". Also use when starting work in a new repo that lacks these files, or when context has drifted across sessions.
last_verified: 2026-04-26
---

# Project Scaffolding

Before writing any code in a project, ensure it has a CLAUDE.md and CONTEXT.md that ground every future session. These files are the project's persistent memory — they survive context window resets, new sessions, and agent handoffs.

## When to Trigger

- After brainstorming + planning converge on a direction, before first implementation
- When entering a repo that has no CLAUDE.md
- When the existing CLAUDE.md is stale or missing key decisions from recent planning
- When starting a new session and context feels lost

## Process

### 1. Check What Exists

Before creating anything, check the project root:
- Does `CLAUDE.md` exist? Read it. Is it current?
- Does `CONTEXT.md` exist? Read it. Is it current?
- Are there other context files (`docs/`, `README.md`, `ADR/`)?

If both exist and are current, skip creation — just verify they reflect recent planning decisions.

### 2. Create or Update CLAUDE.md

The project CLAUDE.md is **instructions for Claude** — rules, preferences, and constraints specific to this project. It answers: "How should I work in this codebase?"

```markdown
# [Project Name] — Claude Instructions

## Project Purpose
[One sentence: what this project does and who it's for]

## Stack
[Languages, frameworks, key libraries, infrastructure]

## Rules
[Project-specific rules that override or extend global CLAUDE.md]
- Testing approach and commands
- Naming conventions if non-standard
- Architecture constraints
- Deploy/build commands

## Structure
[Key directories and what lives where — enough for an agent to navigate]

## Commands
[How to run, test, build, deploy — exact commands]
```

**Guidelines:**
- Under 200 lines. If it's longer, split reference material into separate files.
- Rules here override global `~/.claude/CLAUDE.md` for this project
- Include exact commands — `uv run pytest`, not "run the tests"
- Include decisions from brainstorming/planning that constrain implementation
- No aspirational content — only what's true *now* or decided *now*

### 3. Create or Update CONTEXT.md

CONTEXT.md is **ambient knowledge** — what a new session or agent needs to understand the project. It answers: "What is this project and where are we?"

```markdown
# [Project Name] — Context

## What This Is
[2-3 sentences: problem, solution, current state]

## Architecture
[High-level architecture — components, data flow, key interfaces]
[Keep to what's decided, not aspirational]

## Current State
[What's built, what's in progress, what's next]
[Update this as implementation progresses]

## Key Decisions
[Decisions from brainstorming/planning that future sessions need]
- Why X over Y
- Constraints that aren't obvious from code
- Trade-offs that were explicitly chosen

## Open Questions
[Unresolved items — things the next session might need to decide]
```

**Guidelines:**
- Under 200 lines
- Update the "Current State" section as work progresses
- Move resolved questions to "Key Decisions" when answered
- This is the file to update at session boundaries when context might be lost

### 4. Bootstrap docs/TASKS.md

Call the `task-tracking` skill (Phase 1: Bootstrap) to create `docs/TASKS.md` from its template. This is not optional and not gated on project complexity — every project gets a TASKS.md from the start, even if it's only seeded with one or two tasks. The file is the cross-session canonical state for all subsequent work.

```bash
mkdir -p docs && cp <agent-system-root>/skills/task-tracking/references/tasks-template.md docs/TASKS.md
```

After bootstrap, seed it with the first task or two from the implementation plan. Don't leave it empty — an empty TASKS.md says nothing about whether the project has been planned.

### 5. Create Supporting Files (If Needed)

For larger projects, CLAUDE.md, CONTEXT.md, and TASKS.md may not be enough:

- **`docs/plans/*.md`** — implementation plans (from `writing-plans` skill)
- **`docs/adr/*.md`** — architecture decision records
- **`.claude/rules/*.md`** — path-scoped rules for specific file types

Only create these when the project's complexity demands it. YAGNI.

### 6. Verify Before Proceeding

Before handing off to implementation:
- [ ] CLAUDE.md has exact build/test/run commands
- [ ] CONTEXT.md reflects the current plan and architecture
- [ ] docs/TASKS.md exists with at least the first task seeded
- [ ] Stack, structure, and constraints are documented
- [ ] A fresh agent session could pick this up without prior conversation context

## Updating Across Sessions

At the end of any session that made significant progress or decisions:
- Update CONTEXT.md "Current State" with what changed
- Move any newly resolved questions to "Key Decisions"
- Add any new constraints or rules to CLAUDE.md

At the start of a session that feels like context is lost:
- Read CLAUDE.md and CONTEXT.md first
- If they're stale, update them before continuing work

## What NOT to Do

- Do not create these files for trivial tasks or one-off scripts
- Do not duplicate global CLAUDE.md rules — only project-specific overrides
- Do not include implementation details that belong in code comments
- Do not write aspirational architecture — only decided architecture
- Do not let these files grow past 200 lines — split into docs/ if needed
- Do not skip this step because "I'll remember" — you won't across sessions
