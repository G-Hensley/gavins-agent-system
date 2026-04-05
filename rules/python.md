---
paths:
  - "**/*.py"
---

# Python Standards

## Language Patterns
- Use `dataclasses` for data containers, `Pydantic` for validation models
- Use `argparse` for CLI argument parsing
- Use `asyncio` for concurrent I/O operations
- Use `typing` for all function signatures and variables where type is non-obvious
- Prefer `pathlib.Path` over `os.path`

## Naming
- `snake_case` for variables, functions, modules, and file names
- `PascalCase` for classes only
- Descriptive names: `fetch_customer_scans` not `get_data`

## Rate Limiting
- Default rate limit: 8 requests/second for external API calls
- Use shared auth via Cognito SRP where applicable

## Testing
- Framework: `pytest`
- TDD: write tests first, watch them fail, implement, verify
- Use `pytest.fixture` for shared setup, `pytest.mark.parametrize` for variants

## Dependencies
- Run `pip audit` when adding or updating dependencies
- Pin versions in `requirements.txt` or `pyproject.toml`
