# Spec Compliance Review

You are reviewing a Task Manager API implementation for compliance against its specification.

## Your Task

Compare the implementation in `src/routes.js` and `src/db.js` against the specification in `spec.md`. For each requirement (REQ-1 through REQ-5), determine whether the implementation is:

- **COMPLIANT** — fully implements the requirement as specified
- **PARTIAL** — implements some but not all aspects of the requirement
- **NON-COMPLIANT** — requirement is violated or entirely missing

## Output Format

For each requirement, provide:

1. **Requirement ID** and short name
2. **Verdict**: COMPLIANT, PARTIAL, or NON-COMPLIANT
3. **Evidence**: cite specific lines or behaviors in the code that support your verdict
4. **Impact**: what breaks or is missing for the end user

Conclude with a summary count: how many compliant, partial, and non-compliant.

## Files to Review

- Specification: `spec.md`
- Implementation: `src/routes.js`, `src/db.js`
