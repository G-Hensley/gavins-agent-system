# Python API Project Structure

## Directory Layout
```
src/
  app/
    __init__.py
    main.py                 # Entry point (FastAPI app, Lambda handler)
    config.py               # Pydantic BaseSettings — all config from env vars
    routes/                 # Route handlers — thin, delegate to services
      __init__.py
      health.py             # Health check endpoint
      scans.py              # /scans routes
      customers.py          # /customers routes
    services/               # Business logic — no framework dependencies
      __init__.py
      scan_service.py
      customer_service.py
    repositories/           # Data access — DB queries, API clients
      __init__.py
      scan_repository.py
      customer_repository.py
    models/                 # Pydantic models and dataclasses
      __init__.py
      scan.py               # ScanRequest, ScanResponse, ScanConfig
      customer.py           # CustomerCreate, CustomerResponse
    middleware/              # Auth, logging, error handling
      __init__.py
      auth.py               # Token validation, user context
      error_handler.py      # Global exception handler
      logging.py            # Request/response logging
tests/
  conftest.py               # Shared fixtures (test client, DB setup, mocks)
  test_routes/
    test_scans.py
    test_customers.py
  test_services/
    test_scan_service.py
    test_customer_service.py
```

## Rules

### Layer Responsibilities
- **Routes**: parse request, validate input (Pydantic), call service, return response
- **Services**: business logic, orchestration, validation rules — no HTTP awareness
- **Repositories**: data access only — SQL queries, DynamoDB calls, external API clients
- **Models**: plain data — no behavior, no methods that call services or repositories

### Boundaries
- Routes depend on services, never on repositories directly
- Services depend on repositories, never on routes or framework objects
- Repositories depend on models, never on services
- Each layer validates at its boundary — don't trust upstream validation alone

### Naming
- One module per resource per layer: `routes/scans.py`, `services/scan_service.py`
- Models named by purpose: `ScanRequest`, `ScanResponse`, `ScanConfig`
- Repository methods read like data operations: `get_by_id`, `list_active`, `create`
- Service methods read like business operations: `start_scan`, `cancel_scan`

### Testing
- Tests mirror source structure: `test_routes/`, `test_services/`
- Shared fixtures in `conftest.py` — test client, database setup, mock factories
- Services tested with mocked repositories
- Routes tested via test client with mocked services
- Repositories tested against real database (integration tests)

### Configuration
- All config via `pydantic.BaseSettings` — reads from env vars
- No hardcoded URLs, secrets, or connection strings
- Separate config classes per concern: `DatabaseConfig`, `AuthConfig`, `AppConfig`
