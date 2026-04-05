# DynamoDB Patterns

## Access Patterns First
Define every query before touching the schema. Each GSI must serve a specific, documented access pattern. If you can't name the query, don't create the index.

## Single-Table Design
Store multiple entity types in one table. Use entity prefixes on keys to separate concerns.

```
PK                    SK                      Entity
CUSTOMER#123          META                    Customer metadata
CUSTOMER#123          SCAN#2024-01-15#abc     Scan record
CUSTOMER#123          PROFILE#auth-basic      Auth profile
SCAN#abc              META                    Scan metadata
SCAN#abc              FINDING#001             Finding within scan
```

**Rules:**
- PK: `ENTITY#id` — high cardinality, even distribution
- SK: `METADATA` for the entity itself, `RELATED#id` for children
- Composite SK for range queries: `STATUS#timestamp` enables `begins_with(SK, "ACTIVE#")`
- Store entity type as an attribute (`entityType: "Customer"`) for filtering

## GSI Overloading
Reuse GSI attributes across entity types to serve different access patterns with one index.

```
GSI1PK              GSI1SK              Use case
ORG#456             CUSTOMER#123        Get all customers in org
SCAN#abc            2024-01-15T10:00    Get scan items by time
STATUS#active       2024-01-15          Get all active entities by date
```

**Sparse GSIs:** Only items with the GSI attributes appear in the index. Use this to create filtered views (e.g., only items with `GSI2PK` set appear in GSI2).

## Key Design Patterns

| Pattern | PK | SK | Use |
|---|---|---|---|
| 1:1 lookup | `USER#123` | `META` | Get user by ID |
| 1:many | `USER#123` | `ORDER#ts` | Get user's orders |
| Many:many | `USER#123` / `GROUP#abc` | `GROUP#abc` / `USER#123` | Both directions via GSI |
| Time series | `SENSOR#id` | `2024-01-15T10:00:00` | Range queries on time |
| Hierarchical | `ORG#456` | `DEPT#eng#TEAM#platform` | `begins_with` at any level |

## Capacity Planning
- **On-demand**: unpredictable traffic, new tables, dev/staging — pay per request
- **Provisioned + auto-scaling**: predictable patterns — set base + scaling policy
- **Reserved capacity**: steady-state production — commit for cost savings
- Switch modes at most once per 24 hours

## Transactions
```python
client.transact_write_items(
    TransactItems=[
        {"Put": {"TableName": "T", "Item": item1}},
        {"Update": {"TableName": "T", "Key": key2, "UpdateExpression": "SET #s = :v",
                     "ExpressionAttributeNames": {"#s": "status"},
                     "ExpressionAttributeValues": {":v": {"S": "complete"}}}},
        {"ConditionCheck": {"TableName": "T", "Key": key3,
                            "ConditionExpression": "attribute_exists(PK)"}},
    ],
    ClientRequestToken="idempotency-token-uuid"  # prevents duplicate writes on retry
)
```

- Max 100 items per transaction, 4MB total
- All items must be in same region
- 2x WCU cost vs standard writes
- Use `ClientRequestToken` for idempotency on retries

## DynamoDB Streams
- Enable streams for event-driven processing (Lambda triggers)
- Stream record types: `KEYS_ONLY`, `NEW_IMAGE`, `OLD_IMAGE`, `NEW_AND_OLD_IMAGES`
- Use event source mapping filters to process only relevant changes
- Records retained for 24 hours in the stream
- Use for: cross-region replication, materialized views, audit logs, notifications

## TTL
- Set a numeric attribute (epoch seconds) as the TTL attribute
- DynamoDB deletes expired items within ~48 hours (not instant)
- Expired items still appear in queries until physically deleted — filter them
- Use for: sessions, temporary tokens, cache entries, soft-delete with auto-cleanup

```python
# Set TTL on item
import time
item["ttl"] = int(time.time()) + 3600  # expires in 1 hour
```

## Common Pitfalls

| Pitfall | Fix |
|---|---|
| Hot partitions | Distribute writes across partitions; add randomized suffix if needed |
| Using Scan instead of Query | Design keys/GSIs so every access pattern uses Query |
| Missing pagination | Always handle `LastEvaluatedKey` — results are paginated at 1MB |
| Unbounded queries | Set `Limit` parameter; paginate with cursor |
| FilterExpression for heavy lifting | Filters run AFTER read — design keys to narrow results BEFORE filtering |
| Large items (>400KB) | Store large blobs in S3, keep pointer in DynamoDB |
| Over-indexing with GSIs | Each GSI duplicates data and costs WCU — justify every GSI |
| Not using condition expressions | Use `ConditionExpression` for optimistic locking and idempotent writes |
