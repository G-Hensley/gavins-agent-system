---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/next.config.*"
---

# React / Next.js Standards

## Components
- Function components only -- no class components
- Props interface on every component: `interface FooProps { ... }`
- Hooks for all state and side effects
- Keep components small -- if it needs a scroll, split it

## Server vs Client
- Server components are the default -- no `"use client"` unless required
- Server components handle data fetching and heavy logic
- Client components pushed to leaf nodes for interactivity only
- Never fetch data in client components if a server component parent can pass it as props

## Next.js
- Use App Router (`app/` directory)
- Use `loading.tsx` and `error.tsx` for route-level states
- Use Server Actions for mutations when appropriate
- Metadata via `generateMetadata` or static `metadata` export

## Styling
- Tailwind CSS with design system values from config
- No arbitrary values (`text-[13px]`) -- define in tailwind config if needed
- Use `cn()` utility for conditional class merging
- Responsive: mobile-first with `sm:`, `md:`, `lg:` breakpoints

## State Management
- Zustand for global client state
- React state (`useState`) for local component state
- URL search params for shareable UI state
