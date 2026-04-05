# PostgreSQL Patterns

## Schema Design

```sql
CREATE TABLE scans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    status scan_status NOT NULL DEFAULT 'pending',
    severity TEXT CHECK (severity IN ('critical', 'high', 'medium', 'low')),
    target_url TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TYPE scan_status AS ENUM ('pending', 'running', 'complete', 'failed');
```

- Normalize to 3NF by default, denormalize with justification
- Foreign keys always. `NOT NULL` unless genuinely optional
- `TIMESTAMPTZ` for all timestamps. JSONB only for truly flexible data

## Indexes

```sql
CREATE INDEX idx_scans_customer ON scans (customer_id);                          -- B-tree
CREATE INDEX idx_scans_cust_status ON scans (customer_id, status, created_at DESC); -- composite
CREATE INDEX idx_scans_active ON scans (customer_id, created_at)
    WHERE status IN ('pending', 'running');                                       -- partial
CREATE INDEX idx_scans_cover ON scans (customer_id) INCLUDE (status, target_url); -- covering
CREATE INDEX idx_data ON findings USING GIN (metadata);                          -- GIN for JSONB
CREATE INDEX CONCURRENTLY idx_created ON scans (created_at);                     -- no lock
```

Always `CREATE INDEX CONCURRENTLY` in production. Composite index order: equality columns first, then sort, then range.

## Query Patterns

```sql
-- CTE for readability
WITH active AS (
    SELECT id, customer_id FROM scans
    WHERE status = 'running' AND created_at > now() - interval '24 hours'
)
SELECT c.name, count(s.id) FROM customers c
JOIN active s ON s.customer_id = c.id GROUP BY c.name;

-- Window functions
SELECT customer_id, target_url,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY finding_count DESC) as rank
FROM scans WHERE status = 'complete';

-- Always verify with EXPLAIN
EXPLAIN (ANALYZE, BUFFERS) SELECT id, status FROM scans WHERE customer_id = $1 LIMIT 20;
```

Avoid N+1: use JOINs or `WHERE id IN (...)`. Force eager loading in ORMs.

## Zero-Downtime Migrations

```sql
-- Deploy 1: Add nullable column, dual-write
ALTER TABLE scans ADD COLUMN severity_v2 INTEGER;
-- Deploy 2: Backfill in batches (repeat until done)
UPDATE scans SET severity_v2 = map(severity) WHERE severity_v2 IS NULL AND id > $last LIMIT 1000;
-- Deploy 3: Enforce, drop old
ALTER TABLE scans ADD CONSTRAINT chk CHECK (severity_v2 IS NOT NULL) NOT VALID;
ALTER TABLE scans VALIDATE CONSTRAINT chk;  -- no write lock
ALTER TABLE scans DROP COLUMN severity;
```

- `ADD COLUMN` (nullable / with default PG 11+) does NOT lock
- `SET NOT NULL` takes ACCESS EXCLUSIVE lock — use CHECK + VALIDATE instead
- `CREATE INDEX CONCURRENTLY` does NOT lock

## Connection Pooling

Use PgBouncer in **transaction mode** (release connection after each transaction). Session mode only for prepared statements or LISTEN/NOTIFY.

- Postgres default `max_connections = 100` — pooler essential at scale
- Typical: `max_client_conn = 1000`, `default_pool_size = 20`. Monitor via `pg_stat_activity`
