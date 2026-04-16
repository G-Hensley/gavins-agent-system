# Node.js Backend Patterns

Source: Express.js 5.x docs (expressjs.com), Fastify docs (fastify.dev)

## Project Structure
```
src/
├── routes/         # Route handlers
├── services/       # Business logic
├── repositories/   # Data access, API clients
├── models/         # TypeScript types/interfaces
├── middleware/      # Auth, validation, error handling
├── utils/          # Shared utilities
└── config.ts       # Configuration from env vars
```

Handlers → services → repositories. Keep framework code in handlers, business logic in services.

## Express Middleware

Middleware executes in order of `app.use()`. Each gets `(req, res, next)`. Call `next()` to pass control or `next(err)` to skip to error handler.

```typescript
// Application-level middleware
app.use(express.json({ limit: '100kb' }))
app.use(cors({ origin: allowedOrigins, credentials: true }))

// Route-level middleware
app.get('/admin', requireAuth, requireRole('admin'), adminHandler)

// Router-scoped middleware
const router = express.Router()
router.use(requireAuth) // applies to all routes on this router
router.get('/profile', getProfile)
router.put('/profile', updateProfile)
app.use('/api/users', router)
```

**`router.route()`** — chain handlers for a single path:
```typescript
router.route('/users/:id')
  .get(getUser)
  .put(validateBody(updateSchema), updateUser)
  .delete(requireRole('admin'), deleteUser)
```

## Express Error Handling

Error middleware has **4 arguments** `(err, req, res, next)` — the 4-arg signature is how Express identifies it as an error handler. Register it **last**.

```typescript
class AppError extends Error {
  constructor(
    public message: string,
    public code: string,
    public status: number = 500
  ) { super(message) }
}

// Async wrapper (Express 4) — Express 5 handles async natively
const asyncHandler = (fn: Function) =>
  (req: Request, res: Response, next: NextFunction) =>
    Promise.resolve(fn(req, res, next)).catch(next)

// Error handler (must be 4 args)
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  if (err instanceof AppError) {
    return res.status(err.status).json({ error: err.code, message: err.message })
  }
  logger.error('Unexpected error', { error: err, requestId: req.id })
  res.status(500).json({ error: 'internal', message: 'Internal error' })
})
```

**Express 5**: async route handlers that throw or reject automatically forward to error middleware — no wrapper needed.

## Fastify Validation (JSON Schema)

Fastify validates request/response with JSON Schema via AJV — no extra library needed. Validation happens before the handler runs.

```typescript
fastify.post('/users', {
  schema: {
    body: {
      type: 'object',
      required: ['name', 'email'],
      properties: {
        name: { type: 'string', minLength: 1, maxLength: 100 },
        email: { type: 'string', format: 'email' }
      },
      additionalProperties: false
    },
    response: {
      201: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          name: { type: 'string' },
          email: { type: 'string' }
        }
      }
    }
  }
}, async (request, reply) => {
  const user = await userService.create(request.body)
  reply.code(201).send(user)
})
```

**Response serialization**: Fastify uses response schemas for fast serialization (2-3x faster than `JSON.stringify`) and to strip undeclared fields — preventing accidental data leaks.

**Shared schemas with `$ref`**:
```typescript
fastify.addSchema({
  $id: 'User',
  type: 'object',
  properties: {
    id: { type: 'string', format: 'uuid' },
    name: { type: 'string' },
    email: { type: 'string', format: 'email' }
  }
})

// Reference in route schemas
schema: { response: { 200: { $ref: 'User#' } } }
```

**TypeBox integration**: use `@sinclair/typebox` for TypeScript-first schemas that compile to JSON Schema — `Type.Object({ name: Type.String() })` gives both the type and the schema.

## Fastify Hooks

Hooks run at specific lifecycle points. Use for auth, logging, transforms:

```typescript
// preValidation — runs before schema validation
fastify.addHook('preValidation', async (request, reply) => {
  // e.g., decompress body, normalize fields
})

// preHandler — runs after validation, before handler (most common for auth)
fastify.addHook('preHandler', async (request, reply) => {
  const token = request.headers.authorization?.replace('Bearer ', '')
  if (!token) { reply.code(401).send({ error: 'unauthorized' }); return }
  request.user = await verifyToken(token)
})

// onSend — modify response before sending (also: onResponse, onError, onTimeout)
```

**Route-level hooks**:
```typescript
fastify.get('/admin', {
  preHandler: [requireAuth, requireRole('admin')]
}, adminHandler)
```

## Fastify Plugin Encapsulation

Plugins create isolated contexts. A plugin's decorators, hooks, and schemas don't leak to siblings — only to children.

```typescript
import fp from 'fastify-plugin'

// Encapsulated plugin (default) — isolated scope
async function userRoutes(fastify: FastifyInstance) {
  fastify.get('/users', listUsers)
  fastify.post('/users', createUser)
}

// Shared plugin — breaks encapsulation, decorates parent
export default fp(async function dbPlugin(fastify) {
  const pool = await createPool(fastify.config.DATABASE_URL)
  fastify.decorate('db', pool)
}, { name: 'db' })
```

Use `fp()` (fastify-plugin) only for cross-cutting concerns (db, auth, config). Keep route plugins encapsulated.

## Async Patterns

```typescript
// Parallel with concurrency limit
async function processInBatches<T>(items: T[], fn: (item: T) => Promise<void>, concurrency = 5) {
  for (let i = 0; i < items.length; i += concurrency) {
    await Promise.all(items.slice(i, i + concurrency).map(fn))
  }
}

// Graceful shutdown
process.on('SIGTERM', async () => {
  await server.close()
  await pool.end()
  process.exit(0)
})
```
