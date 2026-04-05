---
paths:
  - "**/*.py"
---

# Python Standards

## Project Layout
- Use `src/` layout with `__init__.py` in every package
- `pyproject.toml` over `setup.py`; `requirements.txt` for pinned production deps
- Prefer `pathlib.Path` over `os.path`

## Naming
- `snake_case` for variables, functions, modules, files; `PascalCase` for classes only
- Descriptive: `fetch_customer_scans` not `get_data`

## Type Hints
- Every function signature: params and return type. Annotate dataclass fields.
- `from __future__ import annotations` at top of every module for forward refs

## Data Modeling
- `dataclasses` for internal data containers
- `Pydantic` for external boundaries: API input/output, config, env vars
- `argparse` for CLI argument parsing

## Error Handling
- Specific exception types only — never bare `except:`
- Custom exception classes for domain errors; inherit from a base app exception
- Log with context, return generic messages to clients

## Async Patterns
- `asyncio.gather` for concurrent I/O; `async with` for resource cleanup
- Rate limit external API calls at 8 req/s. Shared auth via Cognito SRP.

## Imports
- Order: stdlib, third-party, local — separated by blank lines
- Absolute imports preferred. No wildcard imports (`from x import *`)

## Testing
- Framework: `pytest`. TDD: write tests first, watch them fail, implement.
- `pytest.fixture` + `conftest.py` for shared setup; `parametrize` for variants
- `tmp_path` for file operations; avoid mocking what you can test directly

## Dependencies
- Run `pip audit` when adding or updating packages
- Pin versions in `requirements.txt` or `pyproject.toml`
