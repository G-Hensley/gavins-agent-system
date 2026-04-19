---
name: codex-plan-review
description: Run an adversarial Codex review on a drafted plan to catch load-bearing flaws before implementation. Use when a plan touches auth, DB schema, API contracts, infrastructure, data migrations, or irreversible one-shots — triggers defined in rules/codex-plan-review.md.
last_verified: 2026-04-18
---

# Codex Plan Review

Adversarial second-opinion on drafted plans where rework is expensive.

**Announce at start:** "I'm using the codex-plan-review skill to review this plan with Codex."

## Process

### 1. Check triggers

Scan the drafted plan for any of these (full detail in `rules/codex-plan-review.md`):

1. Auth / authorization / session logic
2. Database schema changes
3. API contract changes
4. Infrastructure changes (IaC, Lambda config, VPC, S3, secrets)
5. Data migrations / backfills touching prod data
6. Irreversible one-shots (mass emails, package publishes, release tags, external side effects)

**No match → exit silently.** The plan continues unchanged. Note which triggers you considered so the user can see your reasoning if asked.

**Match →** note which triggers fired. Proceed to step 2.

### 2. Construct the Codex prompt

Build a prompt that includes the full plan document text, the structured six-section checklist, and adversarial framing.

Template:

    You are reviewing a drafted implementation plan. Assume it will go wrong in production. Find the strongest reasons this plan should not ship as-is.

    Answer each section concretely. Push back hard where the plan is wrong. No style feedback. No filler.

    **Rollback.** If this plan ships and breaks, how do we undo it? Is the rollback path tested or documented?

    **Blast radius.** What user-facing surfaces, data, or systems does this touch if it goes wrong?

    **Missing tests.** What behavior is not covered by the tests in this plan?

    **Wrong assumptions.** What does the plan assume that might not hold?

    **Cheapest failure.** What is the single most likely thing to go wrong, and how would we catch it?

    **Alternatives.** Is there a materially better approach? If yes, describe it concretely.

    ---

    PLAN DOCUMENT:

    <paste plan text here>

### 3. Invoke Codex

Run the shared companion in read-only mode (no `--write`):

    node "${CLAUDE_PLUGIN_ROOT}/scripts/codex-companion.mjs" task "<prompt>"

For large plans (>500 lines or >10 tasks), run in background:

    node "${CLAUDE_PLUGIN_ROOT}/scripts/codex-companion.mjs" task --background "<prompt>"

If Codex fails or is unavailable, proceed to step 5 with `Codex review attempted but failed` noted in the appendix. Do NOT block the plan.

### 4. Resolve findings

For each of Codex's six sections:
- **Accept** and revise the plan, OR
- **Push back** with concrete reasoning (Codex missed context, wrong assumption about the codebase, alternative is worse for reasons X/Y).

Do not rubber-stamp. Do not blindly reject. Use judgment.

### 5. Append review to the plan `.md`

Add a `## Codex Review` section at the bottom:

    ## Codex Review

    **Triggers matched:** <list>
    **Codex effort:** default
    **Reviewed:** YYYY-MM-DD

    ### Codex findings

    <Codex's raw response>

    ### Claude's resolution

    - **Rollback finding:** Accepted — <summary of plan change>
    - **Blast radius finding:** Pushed back — <reasoning>
    - **Missing tests finding:** Accepted — <summary of plan change>
    - **Wrong assumptions finding:** Accepted — <summary of plan change>
    - **Cheapest failure finding:** Accepted — <summary of plan change>
    - **Alternatives finding:** Considered and rejected — <reasoning>

    ### Summary

    <One paragraph: what changed in the plan and why.>

### 6. Present to the user

Show:
- (a) the revised plan, and
- (b) a one-paragraph "what changed and why" summary.

User approves or requests further changes.

## Composition

- Called from `writing-plans` after plan draft, before handoff to execution.
- Called from `subagent-driven-development` if plans are drafted mid-flow.
- Callable ad-hoc by the user: "review this plan with Codex".

## Constraints

- Keep this file under 200 lines.
- Read-only — never add `--write` to the Codex invocation.
- Never skip the review silently when a trigger matches — exit only on no-match.
- Fail open on Codex unavailability — log it in the appendix, do not block the plan.
