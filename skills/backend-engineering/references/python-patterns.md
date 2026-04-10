# Python Backend Patterns

Source: FastAPI docs (fastapi.tiangolo.com), Pydantic V2 docs (docs.pydantic.dev)

## Project Structure
```
src/
├── handlers/       # FastAPI routes, Lambda handlers
├── services/       # Business logic (no framework deps)
├── repositories/   # Data access (DB, API clients)
├── models/         # Pydantic models, dataclasses
├── utils/          # Shared utilities
└── config.py       # Configuration from env vars
```

Handlers → services → repositories. Services have no HTTP/framework awareness.

## Pydantic Models (V2)

```python
from pydantic import BaseModel, Field, ConfigDict, field_validator, model_validator

class CreateUserRequest(BaseModel):
    model_config = ConfigDict(strict=True, frozen=True)

    name: str = Field(min_length=1, max_length=100)
    email: str = Field(pattern=r'^[\w.+-]+@[\w-]+\.[\w.-]+$')
    age: int = Field(ge=0, le=150)

    @field_validator('name')
    @classmethod
    def normalize_name(cls, v: str) -> str:
        return v.strip()

class UserResponse(BaseModel):
    id: str
    name: str
    email: str
    created_at: str
```

**`field_validator` modes**: `mode='before'` runs before type coercion, `mode='after'` (default) runs after. Use `before` for raw input normalization, `after` for validated-type logic.

**`model_validator`** for cross-field validation:
```python
class DateRange(BaseModel):
    start: date
    end: date

    @model_validator(mode='after')
    def end_after_start(self) -> 'DateRange':
        if self.end <= self.start:
            raise ValueError('end must be after start')
        return self
```

**Discriminated unions** — Pydantic picks the right model by a discriminator field:
```python
from typing import Literal, Union, Annotated
from pydantic import Discriminator

class EmailNotification(BaseModel):
    type: Literal['email']
    recipient: str
    subject: str

class SmsNotification(BaseModel):
    type: Literal['sms']
    phone: str
    message: str

Notification = Annotated[
    Union[EmailNotification, SmsNotification],
    Discriminator('type')
]
```

**ConfigDict options**: `strict=True` (no type coercion), `frozen=True` (immutable), `extra='forbid'` (reject unknown fields), `str_strip_whitespace=True`.

**TypeAdapter** for validating non-model types:
```python
from pydantic import TypeAdapter
adapter = TypeAdapter(list[int])
result = adapter.validate_python(['1', '2', '3'])  # [1, 2, 3]
```

## FastAPI Dependency Injection

Use `Annotated[Type, Depends(fn)]` — the modern pattern (not bare `Depends()` in defaults):

```python
from typing import Annotated
from fastapi import Depends, FastAPI

async def get_db():
    db = SessionLocal()
    try:
        yield db  # yield-based = automatic cleanup
    finally:
        db.close()

async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    db: Annotated[Session, Depends(get_db)]
) -> User:
    user = await authenticate(token, db)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid token")
    return user

DbDep = Annotated[Session, Depends(get_db)]
CurrentUser = Annotated[User, Depends(get_current_user)]

@app.get("/users/me")
async def read_me(user: CurrentUser):
    return user
```

Dependencies can depend on other dependencies — FastAPI resolves the full tree. Use `Annotated` type aliases to avoid repetition.

## FastAPI Error Handling

```python
from fastapi import HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse

# Built-in — raise anywhere
raise HTTPException(status_code=404, detail="User not found")

# Custom exception + handler
class AppError(Exception):
    def __init__(self, message: str, code: str, status: int = 500):
        self.message = message
        self.code = code
        self.status = status

@app.exception_handler(AppError)
async def app_error_handler(request: Request, exc: AppError):
    return JSONResponse(
        status_code=exc.status,
        content={"error": exc.code, "message": exc.message}
    )

# Override validation error format
@app.exception_handler(RequestValidationError)
async def validation_handler(request: Request, exc: RequestValidationError):
    return JSONResponse(
        status_code=422,
        content={"errors": exc.errors()}
    )
```

## FastAPI CORS

```python
app.add_middleware(CORSMiddleware,
    allow_origins=["https://myapp.com"],  # never ["*"] in production
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["Authorization", "Content-Type"])
```

**WebSocket**: `@app.websocket("/ws")` supports the same `Depends()` injection as HTTP routes.

## Async Patterns

```python
import asyncio

# Rate-limited concurrent requests
async def fetch_with_rate_limit(urls: list[str], rate: int = 8):
    semaphore = asyncio.Semaphore(rate)
    async def fetch_one(url: str):
        async with semaphore:
            return await http_client.get(url)
    return await asyncio.gather(*[fetch_one(url) for url in urls])
```

## Dataclasses vs Pydantic

Use **dataclasses** for internal structured data that doesn't need validation. Use **Pydantic** for external boundaries (API input/output, config from env).

```python
@dataclass
class ScanConfig:
    customer_id: str
    environment: str
    dry_run: bool = False
```
