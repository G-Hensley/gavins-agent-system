# Frontend Security

Source: OWASP XSS Prevention Cheat Sheet, OWASP CSP Cheat Sheet, MDN Web Security

## XSS Prevention by Context

Source: OWASP XSS Prevention Cheat Sheet (CWE-79)

**HTML Body** (`<div>UNTRUSTED</div>`):
- Encode: `&` → `&amp;`, `<` → `&lt;`, `>` → `&gt;`, `"` → `&quot;`, `'` → `&#x27;`
- Safe sink: `.textContent`, `.createTextNode()`
- React: JSX auto-escapes by default — safe for this context

**HTML Attributes** (`<input value="UNTRUSTED">`):
- Aggressive encoding: all non-alphanumeric chars → `&#xHH;`
- Always quote attribute values — unquoted attributes can break out trivially
- Safe sink: `.setAttribute()` with quoted values

**JavaScript** (`var x = 'UNTRUSTED'`):
- Encode using `\uXXXX` Unicode escaping
- Only safe inside quoted strings — never insert directly into script blocks
- Safe sink: JSON.parse() for structured data from server

**CSS** (`color: UNTRUSTED`):
- Hex encode: `\XX` format. Safer: set via `element.style.property = value`
- Never allow user input in `url()`, `expression()`, or `@import`

**URL Parameters** (`href="/page?q=UNTRUSTED"`):
- `encodeURIComponent()` for URL parameters
- When URL appears in HTML attribute: URL encode first, then HTML attribute encode
- Validate URL scheme: allow only `https://` — block `javascript:`, `data:`, `vbscript:`

**Dangerous contexts — avoid entirely**:
- Directly inside `<script>` tags
- Inside HTML comments
- JavaScript event handlers (`onclick`, `onerror`, `onmouseover`)
- `eval()`, `setTimeout(string)`, `setInterval(string)`, `new Function(string)`

## Content Security Policy (CSP)

Source: OWASP CSP Cheat Sheet

**Strict nonce-based CSP** (recommended for dynamic apps):
```
Content-Security-Policy:
  script-src 'nonce-{RANDOM}' 'strict-dynamic';
  object-src 'none';
  base-uri 'none';
```
Generate a new random nonce per request. Add `nonce="{RANDOM}"` to every `<script>` tag. `strict-dynamic` allows trusted scripts to load their dependencies.

**Hash-based CSP** (for static content):
```
Content-Security-Policy:
  script-src 'sha256-{HASH}' 'strict-dynamic';
  object-src 'none';
  base-uri 'none';
```

**Basic fallback** (when strict CSP isn't feasible):
```
Content-Security-Policy:
  default-src 'self';
  script-src 'self';
  style-src 'self';
  img-src 'self' data:;
  connect-src 'self';
  frame-ancestors 'none';
  form-action 'self';
```

**Deployment**: Use `Content-Security-Policy-Report-Only` first to test. Fix violations. Then switch to enforcement. Deliver via HTTP header, not `<meta>` tag.

**Never use**: `unsafe-inline` (defeats XSS protection), `unsafe-eval` (allows eval/Function). Refactor inline scripts to external files with nonces.

## CSRF Protection

**Cookie settings**: `SameSite=Strict` (or `Lax` if cross-site GET needed), `Secure`, `HttpOnly`.

**Anti-CSRF tokens**: synchronizer token pattern or double-submit cookie. Validate on every state-changing request.

**Origin validation**: check `Origin` and `Referer` headers on sensitive endpoints. Reject requests with missing or mismatched origin.

## Secure Cookie Configuration

```
Set-Cookie: session=abc123;
  HttpOnly;        /* no JavaScript access */
  Secure;          /* HTTPS only */
  SameSite=Strict; /* no cross-site sending */
  Path=/;
  Max-Age=3600;    /* 1 hour */
```

Never store tokens in `localStorage` — accessible to any XSS. Use HttpOnly cookies.

## Security Headers

Every response should include:
```
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

## Subresource Integrity (SRI)

For any script/stylesheet loaded from a CDN:
```html
<script src="https://cdn.example.com/lib.js"
  integrity="sha384-{HASH}"
  crossorigin="anonymous"></script>
```
Prevents CDN compromises from injecting malicious code. Generate hashes with `shasum -b -a 384 file.js | xxd -r -p | base64`.

## Common Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| `innerHTML` with user input | `.textContent` or DOMPurify |
| `dangerouslySetInnerHTML` without sanitization | Sanitize with DOMPurify first |
| Tokens in localStorage | HttpOnly cookies |
| `eval()` or `new Function()` with user data | JSON.parse, structured logic |
| URL params rendered without encoding | `encodeURIComponent()` + validate scheme |
| Inline event handlers (`onclick="..."`) | `addEventListener()` + CSP nonce |
| `unsafe-inline` in CSP | Nonce-based or hash-based CSP |
| Missing SRI on CDN scripts | Add integrity attribute |
