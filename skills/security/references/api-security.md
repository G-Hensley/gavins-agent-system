# API Security

Source: OWASP API Security Top 10 (2023), OWASP REST Security Cheat Sheet, OWASP Authentication Cheat Sheet

## OWASP API Security Top 10 (2023)

**API1:2023 — Broken Object Level Authorization (BOLA)**
Attacker manipulates object IDs to access other users' resources. The #1 API vulnerability.
- Check ownership on every data-access function: `WHERE id = :id AND owner_id = :userId`
- Never rely on client-supplied IDs without server-side authorization
- Use unpredictable IDs (UUIDs) — sequential IDs are trivially enumerable

**API2:2023 — Broken Authentication**
Flawed token generation, storage, or validation lets attackers hijack sessions.
- Use proven auth libraries (never roll your own)
- Short-lived JWTs (15min access, 7d refresh with rotation)
- Hash passwords with Argon2id or bcrypt (never SHA/MD5)
- Rate limit auth endpoints: 5 failures → exponential backoff → temporary lockout
- MFA on sensitive operations

**API3:2023 — Broken Object Property Level Authorization**
API returns too many fields or allows writing to restricted properties (mass assignment).
- Whitelist returnable fields per endpoint — never dump full DB objects
- Whitelist writable fields — reject unknown properties in request bodies
- Use DTOs/view models, not raw database entities in responses

**API4:2023 — Unrestricted Resource Consumption**
No limits on requests, payload size, or expensive operations → DoS or cost explosion.
- Per-user and per-endpoint rate limits with `429 Too Many Requests` + `Retry-After`
- Max request body size, max page size, max query complexity
- Monitor and alert on cost-bearing operations (SMS, email, AI API calls)

**API5:2023 — Broken Function Level Authorization**
Attacker accesses admin functions by guessing endpoint paths or changing HTTP methods.
- Deny by default — every endpoint requires explicit permission grant
- Centralize authorization logic (middleware/decorator), don't scatter checks
- Separate admin and user API routes: `/api/admin/` vs `/api/`

**API6:2023 — Unrestricted Access to Sensitive Business Flows**
Automated abuse of legitimate features (bulk purchasing, spam comments, credential stuffing).
- CAPTCHA on sensitive flows after threshold
- Device fingerprinting, behavioral analysis
- Business-logic rate limits (max 5 purchases/minute, not just API rate limits)

**API7:2023 — Server Side Request Forgery (SSRF)**
API fetches user-supplied URLs without validation — attacker forces internal network requests.
- Allowlist permitted domains/IPs for outbound requests
- Block requests to internal IP ranges (10.x, 172.16-31.x, 192.168.x, 169.254.x)
- Disable unnecessary URL schemes (file://, gopher://, dict://)

**API8:2023 — Security Misconfiguration**
Default credentials, debug endpoints, verbose errors, missing security headers in production.
- Automate hardening: disable debug, remove defaults, set security headers
- Identical security config across dev/staging/prod
- Disable unnecessary HTTP methods (TRACE, OPTIONS if unused)

**API9:2023 — Improper Inventory Management**
Forgotten old API versions, debug endpoints, undocumented routes remain accessible.
- Maintain a live API inventory — every endpoint documented in OpenAPI spec
- Deprecate and remove old API versions with sunset dates
- Monitor for shadow/rogue endpoints via traffic analysis

**API10:2023 — Unsafe Consumption of APIs**
Trusting third-party API data more than user input — weaker validation on external data.
- Treat third-party API responses as untrusted input — validate and sanitize
- Set timeouts and circuit breakers on external calls
- Monitor third-party integrations for anomalies

## REST API Security Controls

Source: OWASP REST Security Cheat Sheet

**Transport**: HTTPS only. HSTS header. Consider mutual TLS for high-privilege service-to-service.

**Authentication**: Validate JWTs server-side on every request (issuer, audience, expiration, not-before). Never trust unsigned JWTs. Implement token denylist for explicit session termination.

**Input validation**: Validate type, length, format, range on every input. Use schema validation (Zod, Pydantic) at the API boundary. Reject oversized requests with `413`. Log validation failures.

**Output**: Never copy Accept header to Content-Type. Return explicit MIME types. Generic error messages — no stack traces, internal paths, or SQL errors.

**Security headers**: `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Strict-Transport-Security`, `Cache-Control: no-store` for sensitive data, `Content-Security-Policy: frame-ancestors 'none'`.

**CORS**: Disable unless cross-domain required. Specific origin allowlist — never `*` with credentials.

## Authentication Implementation

Source: OWASP Authentication Cheat Sheet

**Password storage**: Argon2id preferred, bcrypt acceptable (cost factor 12+). Never SHA-256/MD5. Unique salt per password.

**Password policy**: Minimum 8 chars (15+ without MFA). Maximum 64+ chars. Check against breach databases (Have I Been Pwned API). No composition rules (uppercase/special char requirements are counterproductive).

**Brute force protection**: Account-based lockout after N failures in time window. Exponential backoff. CAPTCHA after threshold. Generic error messages ("Invalid credentials" not "User not found").

**Session management**: Short-lived tokens. Refresh with rotation (old refresh token invalidated on use). Invalidate all sessions on password change. Re-authenticate for sensitive operations (password change, payment, role change).
