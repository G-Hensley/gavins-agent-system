# API Versioning and Documentation

## Versioning Strategies

### URL Path Versioning (recommended default)
- `/api/v1/users` — simplest to implement, test, and debug (visible in URLs, logs, curl)
- Route different versions to different handlers or modules
- Drawback: version baked into every URL, clients must update paths

### Header Versioning
- `Accept: application/vnd.myapi+json;version=1` or `X-API-Version: 2`
- Cleaner URLs, content negotiation friendly
- Harder to test (can't paste in browser), harder to cache

## When to Version
**Breaking changes require a new version:**
- Field removed or renamed
- Field type changed (string to int)
- Required field added to request body
- Response structure changed
- Endpoint behavior changed (same input, different output)

**Additive changes do NOT need a new version:**
- New optional field in response
- New endpoint added
- New optional query parameter
- New enum value in response

## Semver for APIs
| Bump | Trigger | Example |
|------|---------|---------|
| MAJOR (v1 -> v2) | Breaking change | Removed `name` field |
| MINOR (v1.1 -> v1.2) | New feature, backwards compatible | Added `GET /tags` |
| PATCH (v1.1.0 -> v1.1.1) | Bug fix, no behavior change | Fixed date format |

- Maintain a `CHANGELOG.md` with every version
- Tag releases in git matching the version

## Deprecation
```http
Deprecation: true
Sunset: Sat, 01 Nov 2025 00:00:00 GMT
Link: <https://docs.api.com/migration/v2>; rel="successor-version"
```
- Minimum 6-month window between deprecation notice and sunset
- Return `Deprecation` and `Sunset` headers on deprecated endpoints
- Log usage of deprecated endpoints to track migration progress
- Publish a migration guide before announcing deprecation

## OpenAPI Spec (Design-First)
1. Write the OpenAPI 3.1 spec before writing code
2. Use spec to generate server stubs, client SDKs, and docs
3. Validate requests/responses against spec in tests

## Generating Spec from Code

### Zod-to-OpenAPI (TypeScript)
```typescript
import { extendZodWithOpenApi } from '@asteasolutions/zod-to-openapi';
extendZodWithOpenApi(z);

const UserSchema = z.object({
  id: z.string().uuid().openapi({ example: '123e4567-e89b' }),
  name: z.string().openapi({ example: 'Jane' }),
}).openapi('User');
```
- Single source of truth: Zod validates at runtime AND generates spec
- Register schemas and routes with `OpenAPIRegistry`, generate with `OpenApiGeneratorV31`

### FastAPI (Python)
- Pydantic models auto-generate OpenAPI schema
- Swagger UI at `/docs`, ReDoc at `/redoc` out of the box
- Add `Field(description=..., example=...)` to Pydantic fields

### Express
- `swagger-jsdoc` — annotate routes with JSDoc comments, generate spec
- Or maintain `openapi.yaml` manually and serve with `swagger-ui-express`

## Spec Hosting
| Tool | Best For |
|------|----------|
| Swagger UI | Interactive try-it-out testing |
| Redoc | Clean, readable reference docs |
| Stoplight Elements | Embeddable, customizable |

Serve docs at `/docs` or `/api-docs` — always accessible in non-prod environments.

## CI Validation
- `npx @stoplight/spectral-cli lint openapi.yaml` — enforce style and consistency on every PR
- `npx openapi-diff old-spec.yaml new-spec.yaml` — detect breaking changes before merge
- Block merges that introduce undocumented breaking changes
