# Eval Prompt

Give the code-quality-reviewer agent this prompt:

---

Review the code at `evals/review-challenges/code-quality-issues/src/` for code quality issues. Focus on maintainability, readability, and software craftsmanship -- not correctness or security. Check for DRY violations, magic numbers, overly complex functions, error handling patterns, dead code, and naming consistency. Rate each finding by severity (high, medium, low).

---

## Expected Agent Behavior

The agent should:

1. Read both `src/userService.js` and `src/utils.js`
2. Identify maintainability issues with severity ratings and concrete refactoring suggestions
3. NOT flag well-structured code that follows single responsibility
4. Distinguish between high-impact issues (duplication, god functions) and low-impact ones (naming, dead code)
