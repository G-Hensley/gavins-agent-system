# Tasks

Cross-session task state for this project. Update as work moves.

For format, archive policy, and TodoWrite pairing, see the `task-tracking` skill in the agent system.

## In Progress

<!-- Tasks actively being worked on. Add `assignee:` and `PR:` when known. -->

## Backlog

<!-- Tasks queued but not started. Order roughly by priority; top is next. -->

### User-only actions (operator owns)

- [ ] [TASK-1] Dismiss Dependabot alert #21 manually
  - assignee: gavin
  - notes: alert references the pre-rename path `evals/review-challenges/dependency-vuln/requirements.txt`; file no longer exists at that path. Won't auto-close. Resolved in repo state by PR #11.

- [ ] [TASK-2] Live verify install on a fresh machine
  - assignee: gavin
  - notes: carried from PR #8's unchecked test items. Confirms the first-merge install path (no prior `~/.claude/settings.json`) still works end-to-end. Waits for opportunity — fresh box not currently available.

### Buildable

- [ ] [TASK-3] Stranger-fork-readiness — CLAUDE.md split, agent-memory exclusion, README tone
  - notes: multi-PR effort. See `improvements/system/stranger-fork-readiness.md` for the full proposal. Touches CLAUDE.md, README, agent-memory/ tracking, possibly install.sh. Probably 3–4 PRs.

- [ ] [TASK-7] Refresh Tier 4 eval rubric to cover orchestration-era patterns
  - notes: surfaced by TASK-4 audit (2026-04-26). The current `evals/tier-4-full-workflow/task-manager-app/eval-criteria.md` predates PRs #14–22 and doesn't check for: per-task PR rhythm in Stage 7, `docs/TASKS.md` bootstrap+maintenance, `project-manager` dispatching at phase boundaries, `codex-plan-review` invocation when Stage 5 plan touches auth/DB/API, `pr-check` after-merge handoff, or `project-orchestration` as the conductor. Refresh rubric, then mechanical re-run becomes worth ~$30–100+.

## Done

<!-- Most recent at the top. When this section exceeds ~30 entries, archive the oldest to docs/TASKS.archive.md. -->

- [x] [TASK-4] Eval freshness — audit pass complete
  - closed via #23 (2026-04-26)
  - notes: audit-only — no mechanical re-runs (would have cost $50–150 against a rubric that's stale for Tier 4). Tier 2 = pass-by-inspection (LOW regression risk). Tier 4 deferred to TASK-7 (rubric refresh first). See `evals/AUDIT-2026-04-26.md` and `docs/STATUS.md` "Freshness Audit (2026-04-26)" section.

- [x] [TASK-6] `pr-check` skill references `project-orchestration` in its after-merge handoff
  - closed via #22 (2026-04-26)
  - notes: PR #21 originally authored this work but merged into its parent branch (`feat/project-scaffolding-bootstrap-tasks-md`) instead of `main` due to a stacked-PR mishap. Re-landed on `main` via #22.

- [x] [TASK-5] Have `project-scaffolding` call `task-tracking:bootstrap` on new projects
  - closed via #19 (2026-04-26)

> Note: this `docs/TASKS.md` was bootstrapped on 2026-04-26 after PRs #9–#17 shipped. Pre-bootstrap shipped work is captured in `git log` and the PR list (https://github.com/G-Hensley/gavins-agent-system/pulls?q=is%3Apr+is%3Amerged), not here.
