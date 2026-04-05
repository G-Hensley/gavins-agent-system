# Error Handling

## Error Layers
- **Domain errors** — business rule violations (insufficient funds, duplicate email, expired token)
- **Application errors** — validation failures, resource not found, unauthorized access
- **Infrastructure errors** — database timeouts, network failures, third-party API errors

Each layer catches its own errors and translates up. Infrastructure errors never leak to clients.

## Python Patterns

```python
class AppError(Exception):
    def __init__(self, message: str, code: str, status: int = 500):
        self.message, self.code, self.status = message, code, status

class NotFoundError(AppError):
    def __init__(self, resource: str, id: str):
        super().__init__(f"{resource} {id} not found", "NOT_FOUND", 404)

class ValidationError(AppError):
    def __init__(self, details: list[dict]):
        super().__init__("Validation failed", "VALIDATION_ERROR", 422)
        self.details = details
```

Rules:
- Use `raise ... from e` to chain exceptions — preserves the original traceback
- Catch specific exceptions, never bare `except:`
- Log with context: `logger.error("payment failed", extra={"user_id": uid, "amount": amount})`
- Never swallow exceptions — at minimum log and re-raise
- Use Pydantic for input validation at API boundaries

## Node.js Patterns

```typescript
class AppError extends Error {
  constructor(public message: string, public code: string, public status: number = 500) {
    super(message);
    this.name = this.constructor.name;
  }
}
```

Express error middleware (must be last, must have 4 params):
```typescript
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  if (err instanceof AppError) {
    res.status(err.status).json({ error: { code: err.code, message: err.message } });
  } else {
    logger.error('unhandled error', { err, requestId: req.id, path: req.path });
    res.status(500).json({ error: { code: 'INTERNAL', message: 'Something went wrong' } });
  }
});
```

- **Operational errors** (bad input, timeout) — handle gracefully, return error response
- **Programmer errors** (null ref, type error) — crash and restart, fix the bug
- Always `await` async calls in try-catch — unhandled rejections crash Node

## Java Patterns

```java
public class AppException extends RuntimeException {
    private final String code;
    private final int status;
    public AppException(String message, String code, int status) {
        super(message); this.code = code; this.status = status;
    }
}
// Use unchecked exceptions for domain/app errors — checked for recoverable I/O
```

- Use `try-with-resources` for all `AutoCloseable` (connections, streams, readers)
- Never catch `Throwable` or `Error` — let JVM errors propagate
- `@ControllerAdvice` + `@ExceptionHandler` for centralized Spring error handling
- Log cause chains: `logger.error("operation failed", exception)`

## HTTP Error Response Format

Consistent body for all error responses:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email format is invalid",
    "details": [{ "field": "email", "issue": "must be a valid email address" }]
  }
}
```

| Status | When |
|--------|------|
| 400 | Malformed request (bad JSON, wrong type) |
| 401 | Missing or invalid authentication |
| 403 | Authenticated but not authorized |
| 404 | Resource does not exist |
| 409 | Conflict (duplicate, state violation) |
| 422 | Validation failed (correct format, invalid values) |
| 429 | Rate limited |
| 500 | Unhandled server error — never expose internals |

Never include stack traces, SQL errors, or internal paths in production responses.

## Retries and Resilience

**Exponential backoff** for transient failures (network, 429, 503):
```python
for attempt in range(max_retries):
    try:
        return await make_request()
    except TransientError:
        if attempt == max_retries - 1:
            raise
        await asyncio.sleep(min(2 ** attempt + random.uniform(0, 1), 30))
```

**Circuit breaker** — stop calling a failing dependency after N consecutive failures. Half-open after cooldown to test recovery. Libraries: `pybreaker` (Python), `opossum` (Node), `resilience4j` (Java).

**Idempotency keys** — for non-idempotent operations (payments, creates), require a client-provided idempotency key. Store the response and return it on retry instead of re-executing.
