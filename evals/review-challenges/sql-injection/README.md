# SQL Injection Review Challenge

Seeded-defect evaluation for the `backend-security-reviewer` agent.

## What This Is

A small Express.js + better-sqlite3 app (`app.js`) with four endpoints managing a product catalog. Three endpoints contain intentionally planted SQL injection vulnerabilities at varying difficulty levels. One endpoint is properly parameterized and serves as a false-positive control.

## What the Reviewer Should Find

| Endpoint | Vulnerability | Difficulty | Expected Severity |
|---|---|---|---|
| `GET /api/products/search` | String-concatenated SQL query | Easy | Critical |
| `POST /api/products/review` | Template literal interpolation in SQL | Medium | High |
| `GET /api/products` | ORDER BY clause injection (looks parameterized elsewhere) | Hard | Medium |
| `GET /api/products/:id` | Properly parameterized (control) | N/A | None |

## Scoring

| Result | Points |
|---|---|
| Correctly identifies Critical finding | +3 |
| Correctly identifies High finding | +2 |
| Correctly identifies Medium finding | +3 |
| Does NOT flag the clean endpoint | +2 |
| False positive on clean endpoint | -2 |
| Missed Critical | -3 |
| Missed High | -2 |
| Missed Medium | -1 |

**Max score: 10**

- 9-10: Excellent -- agent catches subtle injection patterns
- 6-8: Good -- catches obvious issues, may miss subtleties
- 3-5: Needs improvement -- missing significant vulnerabilities
- <3: Failing -- not suitable for security review

## How to Run

```bash
cd evals/review-challenges/sql-injection
npm install
node app.js
```

Then dispatch the reviewer using the prompt in `eval-prompt.md` and compare output against `expected-findings.md`.
