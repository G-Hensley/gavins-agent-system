# Security Rules (Always Active)

These rules apply to ALL code, regardless of language or framework.

## Secrets
- Never commit `.env`, credentials, API keys, tokens, or secrets
- Never hardcode secrets in source code -- use environment variables or a secrets manager
- Add sensitive file patterns to `.gitignore` before first commit

## Input Validation
- Validate all input at system boundaries: API requests, CLI args, file uploads, env vars
- Use allowlists over denylists for input validation
- Sanitize output to prevent injection (XSS, SQL, command)

## Queries and Commands
- Parameterized queries only -- never string concatenation for SQL or NoSQL
- Use ORMs or query builders that parameterize by default
- Never pass unsanitized user input to shell commands or `eval`

## Authentication and Authorization
- Least-privilege IAM -- no wildcards on actions or resources
- Validate JWTs server-side on every request, not just at login
- Use short-lived tokens with refresh rotation

## Dependencies
- Run `npm audit` / `pip audit` when adding or updating dependencies
- Pin dependency versions to prevent supply chain attacks
- Review changelogs before major version bumps

## Dispatch
- When touching auth, APIs, or infrastructure, dispatch the appropriate security specialist agent for review
