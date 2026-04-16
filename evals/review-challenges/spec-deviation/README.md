# Spec Deviation Review Challenge

Seeded-defect evaluation for the `spec-reviewer` agent.

## What This Is

A Task Manager API specification (`spec.md`) and its Express.js implementation (`src/routes.js`, `src/db.js`). The implementation has four intentionally planted deviations from the spec across different categories: missing fields, incomplete filtering, violated business rules, and missing guards. One requirement is correctly implemented as a false-positive control.

## What the Reviewer Should Find

| Requirement | Deviation Type | Difficulty | Description |
|---|---|---|---|
| REQ-1 (CRUD endpoints) | None (control) | N/A | All four endpoints exist and work correctly |
| REQ-2 (Task fields) | Missing field | Easy | `priority` field is completely absent from the schema |
| REQ-3 (Filtering) | Partial implementation | Medium | Status filtering works, priority filtering is missing |
| REQ-4 (Status transitions) | Violated business rule | Hard | No transition validation -- any status can be set to any other |
| REQ-5 (Delete guard) | Missing guard | Medium | Delete succeeds on in-progress tasks instead of returning 409 |

## Scoring

| Result | Points |
|---|---|
| Correctly identifies REQ-2 missing field | +2 |
| Correctly identifies REQ-3 partial filtering | +2 |
| Correctly identifies REQ-4 broken transitions | +3 |
| Correctly identifies REQ-5 missing guard | +2 |
| Does NOT flag REQ-1 as non-compliant | +1 |
| False positive on REQ-1 | -2 |
| Missed REQ-4 (most critical business rule) | -3 |
| Missed any other deviation | -1 each |

**Max score: 10**

- 9-10: Excellent -- catches subtle spec deviations including business logic gaps
- 6-8: Good -- catches field/feature omissions, may miss logic violations
- 3-5: Needs improvement -- only finding obvious missing features
- <3: Failing -- not suitable for spec review

## How to Run

```bash
cd evals/review-challenges/spec-deviation
pnpm install
node src/routes.js
```

Then dispatch the reviewer using the prompt in `eval-prompt.md` and compare output against `expected-findings.md`.
