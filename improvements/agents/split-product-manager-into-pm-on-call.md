# Split product-manager agent: keep PRD-author, add ongoing project-manager

## What I Observed

`agents/product-manager.md` is named "Product and project manager" and the description claims it covers "tracking milestones, scoping projects." In practice the system prompt is exclusively PRD-author mode:

- Writes problem statement, target users, success metrics
- MoSCoW feature breakdown
- User stories with acceptance criteria
- User flows
- Outputs to `docs/prd/YYYY-MM-DD-<project>-prd.md`

There are zero instructions for:

- Maintaining a task board / `docs/TASKS.md`
- Updating status as work progresses
- Logging blockers and re-prioritizing
- Coordinating release notes
- Re-dispatching at phase boundaries

The agent is a one-shot. There is no "on-call PM" agent anywhere.

## Why It Would Help

The earlier-Claude conversation (referenced in `improvements/skills/new-skill-project-orchestration.md`) surfaced that project management belongs as a horizontal thread running through every phase of a project — not a one-shot at the start. Without an on-call PM, status drifts:

- Tasks get implemented without TASKS.md being updated
- Blockers stay in conversation history instead of moving to a tracked location
- Release notes are written from `git log` at the end, missing the "why"
- Re-prioritization conversations happen but never get persisted

## Proposal

Two options. Lean toward Option A.

### Option A — Split into two agents

- Keep `product-manager.md` for the PRD-author one-shot at project kickoff. Rename neither file nor the agent's `name` frontmatter — preserve dispatch compatibility.
- Add `agents/project-manager.md` for ongoing PM. Loads:
  - `task-tracking` skill (when built)
  - `product-management` skill (already exists; may need a "ongoing operations" reference file)
  - `git-workflow` skill (so it can read PR state)
- Dispatch conditions: at every phase boundary in `project-orchestration`, after each PR merges, when a blocker surfaces, or when the operator says "where are we."

### Option B — Extend product-manager scope

- Add an "Ongoing Operations" section to `agents/product-manager.md` covering TASKS.md maintenance, status updates, blocker logging
- Dispatch the same agent for both PRD-write and on-call operations

### Why Option A

- Different cadences (one-shot vs. on-call) call for different system prompts and tool sets
- Memory boundaries stay clean — PRD-author memory shouldn't leak operator gripes about week-3 slippage
- Cheaper — on-call PM doesn't need Opus; could use Sonnet or Haiku for status updates
- Clearer dispatch semantics — `Task(product-manager)` for PRD, `Task(project-manager)` for status

## Open questions for review

- Should the on-call agent's model be Haiku for cost? Status updates and TASKS.md maintenance are not Opus-grade reasoning
- Does the on-call agent need Bash tool? Yes for `gh pr list`, `gh pr view`, reading TASKS.md state, but it should NOT have permission to merge/close/push
- Naming: `project-manager` is the obvious choice but conflicts conceptually with the existing agent. Alternatives: `pm-on-call`, `project-operator`, `delivery-manager`. `project-manager` is still cleanest if Option A goes forward
