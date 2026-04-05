---
paths:
  - "**/*.test.*"
  - "**/*.spec.*"
  - "**/tests/**"
  - "**/test/**"
---

# Testing Standards

## TDD is Not Optional
1. Write the test first
2. Watch it fail (proves the test actually tests something)
3. Implement the minimum code to pass
4. Refactor with confidence
5. No exceptions without explicit permission

## Frameworks
- Python: `pytest` with fixtures and parametrize
- TypeScript: `Vitest` with `describe`/`it` blocks
- E2E: `Playwright` for browser automation

## Test Structure
- One assertion concept per test -- test one behavior, not five
- Descriptive test names: `test_returns_404_when_customer_not_found`
- Arrange-Act-Assert pattern (Given-When-Then)
- Co-locate unit tests with source: `foo.test.ts` next to `foo.ts`

## What to Test
- Happy path and at least one error path per function
- Edge cases: empty inputs, nulls, boundary values
- Integration points: API calls, database queries, external services
- Do NOT mock the thing you're testing -- mock its dependencies

## What Not to Do
- Do not test implementation details (private methods, internal state)
- Do not write tests that pass regardless of implementation (tautological tests)
- Do not leave test files with skipped/commented-out tests -- delete or fix them
