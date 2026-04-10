# Application Security

Source: OWASP Top 10 (2025), CWE Top 25

## OWASP Top 10 (2025)

**A01:2025 — Broken Access Control** (40 CWEs incl. CWE-200, CWE-284, CWE-862, CWE-918)
Users act outside intended permissions — privilege escalation, unauthorized data access, IDOR, CSRF.
- Deny by default for non-public resources
- Server-side access control — never rely on client-side checks
- Enforce record ownership, not just authentication
- Log and alert on access control failures
- Invalidate sessions on logout; short-lived JWTs

**A02:2025 — Security Misconfiguration** (16 CWEs incl. CWE-16, CWE-611)
Default credentials, debug enabled, verbose errors, missing headers, unnecessary features. 100% of apps tested were vulnerable.
- Automate hardening — identical config across dev/staging/prod
- Remove unused features, sample apps, default accounts
- Security headers on every response
- Short-lived credentials, no hardcoded secrets

**A03:2025 — Software Supply Chain Failures** (CWE-1035, CWE-1104, CWE-1357)
Vulnerable, unmaintained, or compromised third-party dependencies. Real-world: SolarWinds, Log4Shell, npm worms.
- Maintain SBOM (Software Bill of Materials) for all dependencies
- Continuous monitoring against CVE/NVD/OSV databases
- `pnpm audit` / `uv pip audit` in CI — fail the build on high/critical
- Source from trusted registries, verify package signatures
- Pin versions, review lockfile changes in PRs

**A04:2025 — Cryptographic Failures**
Sensitive data exposed through weak crypto, missing encryption, or improper key management.
- TLS 1.2+ for all data in transit. HSTS header.
- Encrypt sensitive data at rest (AES-256-GCM)
- Argon2id/bcrypt for passwords — never MD5/SHA for password hashing
- Don't roll your own crypto — use vetted libraries

**A05:2025 — Injection** (37 CWEs incl. CWE-79 XSS, CWE-89 SQLi, CWE-78 OS Command)
Untrusted input interpreted as commands. SQL, XSS, OS command, LDAP, NoSQL, EL injection. 100% of apps tested vulnerable.
- Parameterized queries / prepared statements — never concatenate
- Context-aware output encoding (HTML entity, JS unicode, URL percent)
- Server-side input validation (allowlists over denylists)
- Use ORMs that parameterize by default
- SAST/DAST in CI/CD pipeline

**A06:2025 — Insecure Design** (39 CWEs incl. CWE-269, CWE-434, CWE-522)
Missing or ineffective security controls at the design level — can't be fixed by better implementation.
- Threat model during design phase (before coding)
- Security requirements in user stories
- Plausibility checks at every tier (can this user really buy 10,000 units?)
- Design patterns: separation of duties, defense in depth, least privilege

**A07:2025 — Authentication Failures**
Broken auth allows credential stuffing, brute force, session hijacking.
- MFA on all sensitive operations
- Rate limit login attempts with exponential backoff
- Check passwords against breach databases
- Generic error messages ("Invalid credentials" not "User not found")
- Session invalidation on password change

**A08:2025 — Software or Data Integrity Failures**
Code and infrastructure lacking integrity verification — insecure CI/CD, unsigned updates, deserialization.
- Verify digital signatures on all software and updates
- Secure CI/CD pipeline (signed commits, protected branches, reviewed PRs)
- Never deserialize untrusted data without validation
- Dependency integrity checks (SRI for CDN scripts, lockfile hashes)

**A09:2025 — Security Logging and Alerting Failures**
Insufficient logging or monitoring — breaches go undetected.
- Log all auth events (login, logout, failure, MFA), access control failures, input validation failures
- Structured logging with correlation IDs
- Alert on anomalous patterns (spike in 403s, unusual geolocations)
- Tamper-proof log storage (append-only, separate from application)

**A10:2025 — Mishandling of Exceptional Conditions**
Error handling reveals internals or fails insecurely.
- Fail closed — deny access on error, don't fail open
- Generic error messages to clients; detailed logs server-side
- Never expose stack traces, file paths, SQL errors, or internal service names
- Test error paths — fuzzing, chaos engineering

## Security Implementation Patterns

**Authentication**: Use proven libraries (NextAuth, Passport, AWS Cognito SDK). Proper token lifecycle: issue → validate → refresh → revoke. Constant-time comparison for secrets.

**Sessions**: Cryptographically random session IDs. Invalidate on logout, password change, privilege escalation. Idle + absolute timeouts. Server-side session state.

**Secrets**: Never log secrets, tokens, or passwords — even in debug. Environment variables or secret managers, never config files in VCS. Rotate on team departure or suspected compromise.

**Logging sensitive data**: Never log passwords, tokens, card numbers, SSNs, full API keys. Mask PII: `user_***@***.com`, `card_****1234`. Access-controlled, encrypted log storage.

## Common Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| Rolling own auth/crypto | Use proven libraries |
| Logging full request bodies | Redact sensitive fields |
| Secrets in code/config files | Env vars or secret manager |
| Generic catch-all exposing details | Log internally, return generic message |
| No session invalidation on logout | Invalidate server-side on logout |
| Failing open on errors | Fail closed — deny access on exception |
| No SBOM or dependency tracking | Maintain SBOM, audit in CI |
