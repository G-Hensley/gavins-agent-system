---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---

# TypeScript Standards

## Compiler Strictness
- Enable `strict: true`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`
- Treat warnings as errors in CI — no suppression comments without justification

## Type Safety
- No `any` — use `unknown` and narrow, generics for flexible types, type guards for runtime checks
- Prefer discriminated unions (`type Result = { kind: 'ok'; data: T } | { kind: 'err'; error: E }`) over type assertions
- Exhaustive switches: use `default: const _: never = val` to catch unhandled branches at compile time
- Use `readonly` arrays and `Readonly<T>` for data passed between functions; `as const` for literals
- Export types from the module that owns them; use `import type {}` for type-only imports
- Barrel files (`index.ts` re-exports) only at module boundaries, not inside modules

## Runtime Validation
- Zod at every system boundary: API inputs, env vars, config, external data
- Infer TypeScript types from Zod schemas (`z.infer<typeof Schema>`) — single source of truth
- Never trust external input — parse, don't validate

## Naming
- `camelCase` for variables/functions, `PascalCase` for types/interfaces/classes/components
- `kebab-case` for files and folders
- Descriptive names: `fetchCustomerScans` not `getData`

## Patterns
- Prefer `const` over `let`. Never `var`
- Optional chaining (`?.`) and nullish coalescing (`??`) over manual null checks
- `async/await` over raw Promises
- Destructure parameters when 3+ args
- Zustand for client state management

## Testing
- Framework: Vitest. TDD: test first, fail, implement, verify
- Co-locate: `foo.test.ts` next to `foo.ts`

## Dependencies
- `npm audit` when adding/updating packages
- Exact versions in `package.json` for production deps
