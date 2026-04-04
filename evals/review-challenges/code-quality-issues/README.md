# Code Quality Review Challenge

Seeded-defect evaluation for the `code-quality-reviewer` agent.

## What This Is

A Node.js user management service (`src/userService.js`) and utility module (`src/utils.js`) with intentionally planted code quality issues at varying severity levels. The code is syntactically correct and functionally working -- all issues are purely about maintainability, readability, and software craftsmanship.

## What the Reviewer Should Find

| File | Issue | Category | Expected Severity |
|---|---|---|---|
| `userService.js` | `findUserByEmail` and `findUserByUsername` are near-duplicates | DRY violation / Duplication | High |
| `userService.js` | `registerUser` is 50+ lines doing validation, hashing, DB insert, email, and logging | God function | High |
| `userService.js` | `86400000`, `3`, `1024 * 1024 * 5` used inline without named constants | Magic numbers | Medium |
| `userService.js` | `registerUser` catch block swallows errors with `console.log(err)` | Poor error handling | Medium |
| `userService.js` | `exportUserReport` is exported but unused, has 6-month-old TODO | Dead code | Low |
| `utils.js` | Mixed `camelCase` and `snake_case` naming | Inconsistent naming | Low |
| `utils.js` | Deeply nested ternary for permission resolution | Overly complex conditional | Medium |
| `userService.js` | `getUserById` follows single responsibility (control) | N/A | None |

## Scoring

| Result | Points |
|---|---|
| Correctly identifies High finding (duplication) | +3 |
| Correctly identifies High finding (god function) | +3 |
| Correctly identifies Medium finding (magic numbers) | +2 |
| Correctly identifies Medium finding (error handling) | +2 |
| Correctly identifies Medium finding (complex conditional) | +2 |
| Correctly identifies Low finding (naming) | +1 |
| Correctly identifies Low finding (dead code) | +1 |
| Does NOT flag `getUserById` | +2 |
| False positive on `getUserById` | -2 |
| Missed High | -3 per miss |
| Missed Medium | -2 per miss |

**Max score: 16**

- 14-16: Excellent -- agent catches subtle quality issues and respects clean code
- 10-13: Good -- catches obvious problems, may miss nuance
- 6-9: Needs improvement -- missing significant quality issues
- <6: Failing -- not suitable for quality review

## How to Run

```bash
cd evals/review-challenges/code-quality-issues
```

Then dispatch the reviewer using the prompt in `eval-prompt.md` and compare output against `expected-findings.md`.
