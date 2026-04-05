# Caching Patterns

## When to Cache
- Read-heavy endpoints with acceptable staleness (user profiles, config, catalog data)
- Expensive queries (aggregations, joins, external API calls)
- Don't cache: writes, auth decisions, real-time-critical data

## Cache-Aside (Lazy Loading)
Check cache first, fall back to DB, write result to cache.

```python
# Python (redis-py)
import redis, json

r = redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)

def get_customer(customer_id: str) -> dict:
    key = f"customer:{customer_id}"
    cached = r.get(key)
    if cached:
        return json.loads(cached)
    customer = repo.find_by_id(customer_id)  # DB call
    r.setex(key, 300, json.dumps(customer))  # TTL 5 min
    return customer
```

```typescript
// Node.js (ioredis) — same pattern
const redis = new Redis({ host: process.env.REDIS_HOST });
async function getCustomer(id: string): Promise<Customer> {
  const key = `customer:${id}`;
  const cached = await redis.get(key);
  if (cached) return JSON.parse(cached);
  const customer = await repo.findById(id);
  await redis.setex(key, 300, JSON.stringify(customer));
  return customer;
}
```

## Redis Key Conventions
- Format: `resource:id[:field]` — e.g., `customer:abc123`, `scan:456:status`
- Prefix by service in shared clusters: `apisec:customer:abc123`
- Use `:` as separator, never spaces or special characters

## TTL Strategy
| Data type | TTL | Rationale |
|-----------|-----|-----------|
| Volatile (scan status, session) | 10-60s | Changes frequently |
| Moderate (user profile, config) | 5-15min | Acceptable staleness |
| Stable (reference data, enums) | 1-24hr | Rarely changes |
| Static (computed constants) | No TTL | Never changes, invalidate on deploy |

Always set a TTL. No TTL = unbounded memory growth.
## Cache Invalidation

**Write-through** — update cache on every write. Simple, consistent.
```python
def update_customer(customer_id: str, data: dict) -> dict:
    customer = repo.update(customer_id, data)
    r.setex(f"customer:{customer_id}", 300, json.dumps(customer))
    return customer
```

**Delete on write** — simpler, next read repopulates. Preferred for infrequent writes.
```python
def update_customer(customer_id: str, data: dict) -> dict:
    customer = repo.update(customer_id, data)
    r.delete(f"customer:{customer_id}")
    return customer
```

**Event-based** — publish invalidation events for distributed systems. Use when multiple services cache the same data.

## HTTP Caching
```python
# Cache-Control for stable resources
@app.get("/api/v1/plans")
def list_plans():
    return JSONResponse(service.get_plans(), headers={"Cache-Control": "public, max-age=3600"})

# ETags for conditional requests
@app.get("/api/v1/customers/{id}")
def get_customer(id: str, if_none_match: str = Header(None)):
    customer = service.get_customer(id)
    etag = hashlib.md5(json.dumps(customer).encode()).hexdigest()
    if if_none_match == etag:
        return Response(status_code=304)
    return JSONResponse(customer, headers={"ETag": etag})
```

- `Cache-Control: public, max-age=N` — CDN + browser, public data
- `Cache-Control: private, max-age=N` — browser only, user-specific
- `Cache-Control: no-store` — never cache (auth, sensitive data)
- `ETag` + `If-None-Match` — conditional GET, saves bandwidth

## Common Pitfalls

**Cache stampede** — many requests hit DB simultaneously when cache expires.
Fix: use a lock or staggered TTLs (`TTL + random(0, 30)`).
```python
def get_with_lock(key: str, fetch_fn, ttl: int = 300):
    cached = r.get(key)
    if cached:
        return json.loads(cached)
    lock = r.set(f"lock:{key}", "1", nx=True, ex=5)
    if lock:
        data = fetch_fn()
        r.setex(key, ttl + random.randint(0, 30), json.dumps(data))
        return data
    time.sleep(0.1)  # Wait for lock holder to populate
    return json.loads(r.get(key) or "null")
```

**Caching errors** — don't cache 500s, timeouts, or empty results from transient failures.

**Serialization overhead** — for hot paths, benchmark `json.dumps`/`loads` vs `msgpack`.

**Memory pressure** — set `maxmemory-policy allkeys-lru` in Redis. Monitor eviction rate.

**Stale data after deploy** — prefix keys with a version or flush on deploy when schema changes.
