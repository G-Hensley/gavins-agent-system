---
paths:
  - "**/client*.py"
  - "**/client*.ts"
  - "**/sdk/**"
  - "**/integrations/**"
  - "**/mcp/**"
---

# API Integration Rules

## Field Mapping First

Before writing any API client code:
1. Fetch one real sample response from the target API
2. Save it to `fixtures/` or `tests/fixtures/` as JSON
3. Generate a typed model (TypedDict/Pydantic for Python, Zod/interface for TypeScript) from the actual response shape
4. Only then write the client code against the typed model

Never assume field names from documentation alone — verify against a live response.

## Common Pitfalls

- Field name mismatches (`applicationName` vs `name`, `app_id` vs `id`)
- Nested response wrappers (`{ data: { results: [...] } }` vs `{ results: [...] }`)
- Pagination tokens named differently per API (`nextToken`, `cursor`, `offset`)
- Auth headers varying (`Authorization: Bearer` vs `X-API-Key` vs custom)

## Testing

- Mock responses in tests should use the same fixtures saved from real responses
- Pin fixture files in version control — they're the source of truth for field shapes
- When the API changes, update the fixture first, then fix the client
