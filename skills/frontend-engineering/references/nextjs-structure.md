# Next.js Project Structure (App Router)

## Directory Layout
```
app/                        # App Router — file-based routing
  layout.tsx                # Root layout (server component, wraps all pages)
  page.tsx                  # Home page (/)
  loading.tsx               # Root loading state (Suspense boundary)
  error.tsx                 # Root error boundary
  not-found.tsx             # 404 page
  (auth)/                   # Route group — no URL segment
    login/page.tsx          # /login
    signup/page.tsx         # /signup
    layout.tsx              # Auth-specific layout (centered card, etc.)
  dashboard/
    page.tsx                # /dashboard
    loading.tsx             # Dashboard loading state
    [id]/
      page.tsx              # /dashboard/:id
  api/                      # Route handlers (REST endpoints)
    [resource]/
      route.ts              # GET, POST, PUT, DELETE handlers
components/
  ui/                       # Shared primitives (Button, Input, Modal, Card)
  features/                 # Feature-specific (DashboardChart, ScanTable)
  layouts/                  # Layout components (Sidebar, Header, PageShell)
lib/                        # Utilities, SDK clients, helpers
  api.ts                    # Typed fetch wrapper / API client
  auth.ts                   # Auth helpers (session, token validation)
  utils.ts                  # Pure utility functions
hooks/                      # Custom React hooks (client-side only)
types/                      # Shared TypeScript types and interfaces
middleware.ts               # Root middleware (auth, redirects, headers)
```

## Rules

### Server vs Client
- **Server by default** — never add `'use client'` unless the component needs interactivity
- **Client at the leaves** — interactive bits (forms, dropdowns, search) are leaf components
- Data fetching happens in server components, passed down as props

### File Colocation
- Tests live next to their component: `Button.tsx` / `Button.test.tsx`
- Component-specific styles or utils stay in the same directory
- No top-level `__tests__/` directory mirroring the source tree

### Exports
- Barrel exports (`index.ts`) only at directory level: `components/ui/index.ts`
- Never barrel-export the entire `components/` directory — import from subdirectory
- Page and layout files are never re-exported

### Route Organization
- Use route groups `(name)/` for layout grouping without URL impact
- Use dynamic segments `[param]/` for resource routes
- Use `loading.tsx` and `error.tsx` per route segment that needs them
- API routes go in `app/api/` — one `route.ts` per resource

### Data Flow
- Server components fetch data, client components receive it via props
- Server Actions for mutations (form submissions, writes)
- No `useEffect` for data fetching — that's a server component's job
- Client-side state (Zustand) only for UI state, not server data
