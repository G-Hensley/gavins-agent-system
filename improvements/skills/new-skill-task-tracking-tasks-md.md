# New skill: task-tracking via docs/TASKS.md

## What I Observed

There is no documented pattern for ongoing task tracking across a project's lifetime. The pieces that exist:

- `TodoWrite` tool — session-scoped, in-flight work only, lost when the session ends
- `product-manager` agent — writes a one-shot PRD, no lifecycle/status mechanics
- This repo's own `docs/IMPROVEMENTS.md` and `docs/STATUS.md` — markdown files Gavin maintains by hand

Gavin's stated preference (this conversation): keep tracking in a local file, version-controlled with the code, no Notion/GitHub Projects/Asana for personal projects. Markdown is the default substrate.

## Why It Would Help

- Cross-session continuity: Claude can reload TASKS.md at the start of every session and know where work stands
- Free PR diff of "what shipped" — every TASKS.md change appears in a PR diff
- Zero setup overhead — no DB, no API keys, no MCP server required
- Consistent with existing in-repo markdown patterns (`IMPROVEMENTS.md`, `STATUS.md`, eval rubrics)
- Pairs cleanly with `TodoWrite` for in-session sub-step tracking — two layers, different lifetimes

## Proposal

Create `skills/task-tracking/SKILL.md` (~120 lines).

### Substrate decision (recorded in the skill, not negotiated each time)

| Store | When | Why |
|---|---|---|
| `docs/TASKS.md` | Default — any project under ~600 lines of tasks | Free, native to Claude's tools, version-controlled, diff-friendly |
| `docs/tasks.db` (SQLite) | Only when TASKS.md exceeds ~600 lines AND queries become the bottleneck | Real queries on large data; opt-in escape hatch |
| Vector DB | Never for this | Tasks are structured; semantic search is solving a problem you don't have |

### TASKS.md format

```markdown
# Tasks

## In Progress
- [ ] [TASK-12] Update lint-on-save to JSON channel
  - assignee: claude
  - PR: #9
  - depends-on: [TASK-11]

## Backlog
- [ ] [TASK-13] ...

## Done (last 30 days)
- [x] [TASK-11] Hook surfacing investigation — closed via #9 (2026-04-25)
```

### Skill behaviors

- `task-tracking:bootstrap` — create `docs/TASKS.md` with template; called by `project-scaffolding` once per new project
- `task-tracking:next-task-id` — scan TASKS.md for the highest TASK-N, return N+1
- `task-tracking:move-status` — move a task between sections (Backlog → In Progress → Done)
- `task-tracking:archive` — when "Done" section exceeds N entries, append-and-truncate to `docs/TASKS.archive.md`

### Pairing with TodoWrite

- TASKS.md = canonical persistent state across sessions
- TodoWrite = in-session sub-steps under the current TASK-N
- The skill says to "load TASKS.md at session start and pin the in-progress task IDs," then dispatch TodoWrite for sub-steps as needed

## Open questions for review

- Should TASK IDs be repo-scoped (`TASK-12`) or project-scoped (`gavins-agent-system-12`)? Repo-scoped is simpler and never collides because a project is its own repo
- Where does archive truncation happen — in the skill explicitly (Claude runs the command) or via a hook on Edit of TASKS.md? Lean explicit; hooks should not silently rewrite operator files
- Do we want a `tasks.json` companion for machine-readable status (for hooks/scripts), or stay markdown-only? Stay markdown-only until a real scriptability need surfaces — YAGNI
