# Extend subagent-driven-development with per-task PR rhythm

## What I Observed

`skills/subagent-driven-development/SKILL.md` runs each task through:

1. Implementer agent
2. Spec-reviewer agent
3. Code-quality-reviewer agent

Then proceeds to the next task. ALL git work — commit, push, PR creation — is deferred until the entire plan is done, via `finishing-a-development-branch`.

This is the wrong default for any plan with more than 2 or 3 tasks. By the time you finish a 30-task plan, you have one giant PR that:

- Cannot be reviewed in isolation (changes are entangled)
- Blocks all of the work on a single approval gate
- Loses the ability to roll back one task without rolling back the whole batch
- Defeats the "small, focused PRs" preference stated in global CLAUDE.md ("Commits: small and frequent. One logical change per commit.")

## Why It Would Help

- Per-task PRs let security review, Copilot review, and human review run in parallel with the next task's implementation
- Bisect/rollback granularity stays at task level instead of plan level
- Failed tasks fail their PR, not the whole plan
- The git rhythm Gavin actually uses in real work (PR #4–11 in this repo were all small, focused PRs) is not codified anywhere — it lives in Gavin's head

## Proposal

Extend `skills/subagent-driven-development/SKILL.md` (currently the file is small — verify under 200 lines after edit).

Add after the per-task review steps:

```markdown
### Phase 4: Per-task git rhythm (default)

After both reviewers approve, before moving to the next task:

1. Stage only files touched by this task
2. Commit with `type: description` per CLAUDE.md format
3. Push to the task's branch (one branch per task by default)
4. Open a PR via `gh pr create` (uses `git-workflow` Phase 3 templates)
5. Update the project's `docs/TASKS.md` to move the task from "In Progress" to "In Review"
6. Move on to the next task — do NOT wait for review unless the next task depends on this one

Stack-PRs mode (opt-in): if task N+1 depends on task N's branch, base N+1 on N's branch and note the stack in the PR description.

Single-PR mode (opt-in): for a tightly-coupled refactor where task-level review adds no value, the operator can request "single PR" up front. Default is per-task.
```

Also update the existing "## What NOT to Do" section to include:

- Do not batch all tasks into one PR by default — that is now the explicit opt-in mode
- Do not skip updating TASKS.md between tasks; the canonical state is the file, not the agent's memory

## Open questions for review

- Where does `docs/TASKS.md` come from in a new project? The new task-tracking skill (`new-skill-task-tracking-tasks-md.md`) handles bootstrap. Both skills depend on it existing.
- Should the per-task PR be opened by the implementer agent or a separate dispatch? Probably implementer — it just finished the work and has the context. But that means the implementer agent's tools must include git/gh permissions.
- How does this interact with worktrees (from `git-workflow` Phase 1)? The skill should default to one worktree per plan, with the implementer creating per-task branches inside it.
