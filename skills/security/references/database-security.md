# Database Security

Source: OWASP SQL Injection Prevention Cheat Sheet, OWASP Query Parameterization Cheat Sheet

## SQL Injection Prevention (CWE-89)

**Defense 1 — Prepared Statements (Primary)**
Separate SQL code from data. The query structure is fixed; user input is always treated as data, never as SQL.

```typescript
// Node.js (pg)
const result = await pool.query('SELECT * FROM users WHERE id = $1', [userId])
```

```python
# Python (asyncpg)
row = await conn.fetchrow('SELECT * FROM users WHERE id = $1', user_id)
```

```java
// Java (JDBC)
PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
ps.setString(1, userId);
ResultSet rs = ps.executeQuery();
```

```typescript
// Prisma (parameterized by default)
const user = await prisma.user.findUnique({ where: { id: userId } })
```

**Defense 2 — Stored Procedures**
Pre-compiled SQL in the database. Equivalent to prepared statements when properly parameterized. Don't build dynamic SQL inside procedures.

```java
CallableStatement cs = conn.prepareCall("{call sp_getUser(?)}");
cs.setString(1, userId);
```

**Defense 3 — Allowlist Input Validation**
For identifiers (table names, column names, sort direction) that can't be parameterized:
```typescript
// Map user input to pre-approved values
const SORT_COLUMNS = { name: 'name', date: 'created_at', price: 'price' }
const column = SORT_COLUMNS[userInput] ?? 'created_at'
const direction = userInput === 'desc' ? 'DESC' : 'ASC'
```
Never concatenate user input for identifiers — map to known values.

**Defense 4 — Escaping (LAST RESORT)**
Strongly discouraged. Database-specific, fragile, and can't guarantee protection. Only use if none of the above are possible.

## NoSQL Injection Prevention

MongoDB operator injection — attacker sends `{ "$gt": "" }` instead of a string:
```typescript
// BAD: allows operator injection
db.collection.find({ username: req.body.username })

// GOOD: validate type before query
const username = typeof req.body.username === 'string' ? req.body.username : ''
db.collection.find({ username })
```

DynamoDB: use `ExpressionAttributeValues` with typed placeholders — never concatenate into `FilterExpression`.

## Access Control (Least Privilege)

- Application DB user: SELECT, INSERT, UPDATE, DELETE only on application tables
- No DDL permissions (CREATE, DROP, ALTER) for application users
- No GRANT permission — app can't escalate its own access
- Separate read-only and read-write connection pools for read-heavy workloads
- Never use root/admin credentials in application code
- Different DB users per service in microservice architectures

## Encryption

**In transit**: TLS for all database connections — mandatory for cross-network, strongly recommended even on private networks. Verify server certificates.

**At rest**: Enable disk-level encryption (RDS encryption, DynamoDB default encryption). For sensitive columns (PII, financial, health), add application-level encryption (AES-256-GCM) with key management via AWS KMS or equivalent.

**Backups**: same security as live data. Encrypted at rest, access-controlled, retention policies enforced.

## Data Handling

- Never `SELECT *` — explicit column lists prevent leaking sensitive fields
- Never log full query results with PII — mask in logs: `user_***@***.com`
- Return only the fields the API consumer needs (DTOs/view models, not raw rows)
- Implement soft deletes for audit trails; hard deletes for GDPR/CCPA compliance
- Set data retention policies — don't store data longer than needed

## Connection Security

- Connection pooling with max connection limits (prevent DoS via connection exhaustion)
- Connection timeouts — don't let slow queries hold connections indefinitely
- Prepared statement caching — reuse parsed query plans
- SSL mode `verify-full` in PostgreSQL, `ssl: { rejectUnauthorized: true }` in Node drivers

## Common Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| String concatenation in queries | Parameterized queries / prepared statements |
| Storing passwords in plaintext | Argon2id/bcrypt hashing |
| `SELECT *` returning sensitive columns | Explicit column selection |
| App running as DB admin | Least-privilege DB user with specific grants |
| Unencrypted backups | Encrypt at rest + access control |
| No connection pooling limits | Set max pool size + timeouts |
| Trusting NoSQL input types | Validate types before query construction |
| Dynamic table/column names from user input | Allowlist mapping to known identifiers |
