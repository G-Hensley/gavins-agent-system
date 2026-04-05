---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---

# TypeScript Standards

## Type Safety
- Strict types everywhere. No `any` -- use `unknown` and narrow, or define proper types
- Use Zod for runtime validation at system boundaries (API inputs, env vars, config)
- Use Zustand for client-side state management
- Export interfaces/types from the module that owns them

## Naming
- `camelCase` for variables and functions
- `PascalCase` for types, interfaces, classes, and components
- `kebab-case` for file and folder names
- Descriptive names: `fetchCustomerScans` not `getData`

## Patterns
- Prefer `const` over `let`. Never use `var`
- Use optional chaining (`?.`) and nullish coalescing (`??`) over manual checks
- Prefer `async/await` over raw Promises
- Destructure function parameters when there are 3+ args

## Testing
- Framework: Vitest
- TDD: write tests first, watch them fail, implement, verify
- Co-locate test files: `foo.test.ts` next to `foo.ts`

## Dependencies
- Run `npm audit` when adding or updating packages
- Use exact versions in `package.json` for production deps
