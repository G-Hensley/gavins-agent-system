# MongoDB Patterns

## Schema Design: Embed vs Reference

| Factor | Embed | Reference |
|---|---|---|
| Read together? | Yes — embed | No — reference |
| Update frequency | Rarely changes | Frequently changes |
| Document growth | Bounded | Unbounded |

- **16MB document limit** — embed only bounded sub-documents
- Embed 1:few (address in user). Reference 1:many or many:many
- Denormalize for read performance, accept write cost — document the trade-off

```javascript
// Embedded: { _id: "user123", addresses: [{ street: "123 Main" }] }
// Referenced: { _id: "order456", userId: "user123", total: 99.00 }
```

## Indexes

```javascript
db.scans.createIndex({ customerId: 1, status: 1, createdAt: -1 })  // ESR: Equality, Sort, Range
db.scans.createIndex({ severity: 1 },
  { partialFilterExpression: { status: "active" } })                 // partial index
db.sessions.createIndex({ expiresAt: 1 }, { expireAfterSeconds: 0 }) // TTL auto-delete
db.findings.createIndex({ description: "text", title: "text" })      // full-text
```

- Covered queries: project only indexed fields (`{ status: 1, _id: 0 }`)
- Verify with `explain("executionStats")`. Drop unused indexes
- Avoid indexing low-cardinality fields (booleans, small enums)

## Aggregation Pipeline

```javascript
db.scans.aggregate([
  { $match: { customerId: "123", status: "complete" } },  // FIRST — uses index
  { $project: { findings: 1, createdAt: 1 } },            // reduce early
  { $unwind: "$findings" },
  { $group: { _id: "$findings.severity", count: { $sum: 1 } } },
  { $sort: { count: -1 } }, { $limit: 10 }
])
```

`$match`/`$sort` first to use indexes. `$project` early. Avoid `$lookup` on large collections — denormalize instead.

## Transactions

```javascript
const session = client.startSession();
try {
  session.startTransaction({ readConcern: "majority", writeConcern: { w: "majority" } });
  await scans.updateOne({ _id: scanId }, { $set: { status: "complete" } }, { session });
  await findings.insertMany(newFindings, { session });
  await session.commitTransaction();
} catch (e) { await session.abortTransaction(); throw e; }
finally { session.endSession(); }
```

- Requires replica set. Keep short (60s timeout). Prefer single-document atomicity when possible

## Connection Management

```javascript
const client = new MongoClient(uri, {
  maxPoolSize: 50, minPoolSize: 5, retryWrites: true, retryReads: true,
  readPreference: "secondaryPreferred", w: "majority", connectTimeoutMS: 5000,
});
```

- One client per app — never per-request. `retryWrites` handles transient failures
- `primary` for consistency, `secondaryPreferred` for read scaling
