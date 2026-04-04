# Expected Findings

## High: DRY Violation -- Duplicated Lookup Functions

- **Location**: `userService.js`, `findUserByEmail` (line ~9) and `findUserByUsername` (line ~29)
- **Issue**: These two functions are near-identical. They differ only in the WHERE clause column (`email` vs `username`). Both get a connection, run a SELECT, check for empty results, update `last_seen`, and release the connection.
- **Fix**: Extract a generic `findUserBy(column, value)` function that accepts the lookup field and value. The two exported functions become thin wrappers:
  ```js
  async function findUserByEmail(email) {
    return findUserBy("email", email);
  }
  ```

## High: God Function -- `registerUser`

- **Location**: `userService.js`, `registerUser` (line ~53)
- **Issue**: This function is 50+ lines and handles five distinct responsibilities: input validation, duplicate checking, password hashing, database insertion (user + avatar + preferences), and email sending. Violates single responsibility principle and makes testing, modification, and debugging difficult.
- **Fix**: Extract into focused helpers:
  - `validateRegistrationInput(userData)` -- returns validation errors
  - `hashPassword(password)` -- returns `{ hash, salt }`
  - `createUserRecord(connection, userData, hash, salt)` -- DB insert
  - `sendWelcomeEmail(email, username)` -- email dispatch
  - `registerUser` becomes an orchestrator calling these functions

## Medium: Magic Numbers

- **Location**: `userService.js`, multiple locations
- **Instances**:
  - `1024 * 1024 * 5` (line ~83) -- 5MB avatar size limit
  - `86400000` (line ~117, ~142) -- 24 hours in milliseconds, used for session TTL and expiry check
  - `3` (line ~157) -- max failed login attempts before account lockout
- **Issue**: Numeric literals with no named constant make the code harder to understand and maintain. If the session TTL needs to change, you have to find every `86400000` in the codebase.
- **Fix**: Define named constants at module scope:
  ```js
  const MAX_AVATAR_BYTES = 5 * 1024 * 1024;
  const SESSION_TTL_MS = 24 * 60 * 60 * 1000;
  const MAX_FAILED_LOGIN_ATTEMPTS = 3;
  ```

## Medium: Poor Error Handling in `registerUser`

- **Location**: `userService.js`, `registerUser` catch block (line ~121)
- **Code**: `console.log(err)`
- **Issue**: The catch block swallows all errors with a bare `console.log`. This loses the stack trace in structured logging, provides no request context, and makes production debugging nearly impossible. A database connection failure and a validation edge case are both silently reduced to the same generic response.
- **Fix**: Use the structured logger with context, and consider re-throwing or categorizing errors:
  ```js
  catch (err) {
    logger.error("Registration failed", { error: err.message, stack: err.stack, email: userData.email });
    return { success: false, error: "Registration failed" };
  }
  ```

## Medium: Overly Complex Conditional -- Nested Ternary

- **Location**: `utils.js`, `resolvePermissions` (line ~41)
- **Issue**: Six levels of nested ternary operators make this function very difficult to read, modify, or debug. Adding a new role or permission rule requires understanding the entire nesting structure. Branch coverage in tests is also hard to verify.
- **Fix**: Refactor to a strategy map or early-return pattern:
  ```js
  function resolvePermissions(user, resource) {
    if (user.role === "superadmin") {
      return { read: true, write: true, delete: true, admin: true };
    }
    const isOwner = resource.ownerId === user.id;
    const sameOrg = resource.orgId === user.orgId;
    if (user.role === "admin") { ... }
    if (user.role === "editor") { ... }
    // ...
  }
  ```

## Low: Inconsistent Naming Convention

- **Location**: `utils.js`, throughout
- **Instances**:
  - camelCase: `formatDate`, `sanitizeInput`, `buildSortKey`, `resolvePermissions`
  - snake_case: `get_display_name`, `parse_pagination_params`, `calculate_age_days`
- **Issue**: Mixing naming conventions within a single module reduces readability and signals lack of code standards enforcement. JavaScript convention is camelCase.
- **Fix**: Rename all exported functions to camelCase (`getDisplayName`, `parsePaginationParams`, `calculateAgeDays`). The `per_page` variable inside `parse_pagination_params` should also become `perPage`.

## Low: Dead Code -- `exportUserReport`

- **Location**: `userService.js`, `exportUserReport` (line ~131)
- **Issue**: This function is exported but not imported anywhere. It has a TODO comment dated 2025-10-15 (nearly 6 months old) to "hook this up to the admin dashboard." Stale dead code adds cognitive load and maintenance burden.
- **Fix**: Remove the function and its export. If it is needed in the future, it can be retrieved from version control.

## False Positive Check: Clean Function

- **Location**: `userService.js`, `getUserById` (line ~125)
- **Status**: Well-structured. Validates input, uses a single query with parameterized values, properly releases the connection in a finally block, and has a single clear responsibility.
- **Expected result**: The reviewer should NOT flag this function. If it does, that counts as a false positive (-2 points).
