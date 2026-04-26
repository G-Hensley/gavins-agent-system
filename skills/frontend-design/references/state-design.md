# State Design

When to reference: building any screen that fetches, displays, or mutates data. Designing only the "happy path" is the most common gap in UI work.

## The Five States Every Screen Has

Every UI element exists in five states. Design all of them — not just the populated one.

### 1. Ideal state
Fully populated, everything working. What mockups usually show. The least interesting design problem. Don't stop here.

### 2. Empty state
No data exists yet. The first impression for first-time users. Never show a blank screen. An empty state must do three things:

1. **Explain what would be here** — "No projects yet"
2. **Say why it's empty** — first-time user, or a search returned nothing
3. **Provide a clear action** — "Create your first project" with a prominent button

Empty states are an opportunity to educate, set tone, and onboard. Slack's first-channel message, Dropbox's first-upload prompt, Asana's task celebration — all empty-state design.

### 3. Loading state
Use the right tool:

- **Skeleton screens** — gray placeholder shapes mirroring the eventual layout. Best for feeds, dashboards, lists. The user sees structure before data; perceived wait drops dramatically.
- **Progress bars** — for known-duration operations (uploads, exports, installs). Show determinate progress.
- **Spinners** — for short, indeterminate waits (form submit, tab switch). Keep under 2 seconds. If longer, switch to a skeleton or progress bar.

Never show inaccurate placeholder content (e.g., "No records" while loading, then replacing with records). It destroys trust.

### 4. Error state
Answer three questions:

1. **What happened?** — "We couldn't save your changes" (not "Error 500")
2. **Why?** — "Your connection dropped" or "File exceeds 10MB"
3. **What can they do?** — "Try again" / "Go back" / "Contact support"

Be human, specific, actionable. Never blame the user. Never use jargon. Never leave a dead end.

### 5. Partial / degraded state
Some data loaded, some didn't. A dashboard where 3 of 5 widgets resolved and 2 failed. Show what you have, mark what's missing, offer retry on the failed parts. Don't block the entire page on a single failed call.

## Offline States (PWAs / Mobile)

Design for intermittent connectivity:

- **Persistent, non-intrusive banner** — "You're offline. Changes will sync when you reconnect."
- **Continue working with cached data** where possible (optimistic UI)
- **Queue actions** for later sync
- **Confirm quietly on reconnect** — sync the queue, surface conflicts only when needed

Google Docs is the gold standard: keep typing offline, changes sync when you're back.

## Optimistic UI

Show the result of an action *before* the server confirms it. The heart fills the moment the user taps it; the API call happens in the background. If it fails, revert with a clear message.

Use it for:
- Likes, favorites, follows
- Toggles, simple edits
- Adding items to lists

Don't use it for:
- Payments, charges
- Deletions (unless reversible / soft-delete with undo)
- Sending messages, emails, posts (use a "sending..." indicator instead)

The line: **low-risk, high-frequency** = optimistic. **High-risk, infrequent** = pessimistic.

## Implementation Patterns

```tsx
// React: handle every state, always
function ProjectList() {
  const { data, isLoading, error } = useProjects();

  if (isLoading) return <ProjectListSkeleton />;
  if (error) return <ErrorState onRetry={refetch} message={error.message} />;
  if (!data?.length) return <EmptyState onCreate={openCreateModal} />;
  return <ProjectGrid projects={data} />;
}
```

Naming convention: `<Feature>Skeleton`, `<Feature>EmptyState`, `<Feature>ErrorState` as siblings to the populated component. Keeps state design visible in the file tree.

## Design Review Checklist

For every screen, ask:
- [ ] Is the empty state designed and useful?
- [ ] Does the loading state preserve layout (skeleton over spinner)?
- [ ] Does the error state explain what, why, and how to recover?
- [ ] What happens if half the data loads?
- [ ] What happens offline?
- [ ] Are optimistic updates safe to revert if the server rejects?

If any answer is "we didn't design that," design it before shipping.
