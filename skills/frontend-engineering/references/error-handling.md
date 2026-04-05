# Error Handling

## React Error Boundaries
```typescript
class ErrorBoundary extends React.Component<
  { children: React.ReactNode; fallback: React.ReactNode },
  { hasError: boolean }
> {
  state = { hasError: false };
  static getDerivedStateFromError() { return { hasError: true }; }
  componentDidCatch(error: Error, info: React.ErrorInfo) {
    reportError(error, { componentStack: info.componentStack });
  }
  render() { return this.state.hasError ? this.props.fallback : this.props.children; }
}
```
- Place boundaries around route segments, dashboards, and independent widgets
- Reset error state on navigation: use `key={location.pathname}` on the boundary
- Error boundaries catch render errors only — not event handlers, async code, or SSR

## Async Error Handling
```typescript
async function handleSubmit() {
  try {
    await submitForm(data);
  } catch (err) {
    if (err instanceof ValidationError) setFieldErrors(err.details);
    else toast.error('Submission failed. Please try again.');
  }
}

// AbortController for cancelled requests
useEffect(() => {
  const controller = new AbortController();
  fetchData({ signal: controller.signal }).catch((err) => {
    if (err.name !== 'AbortError') reportError(err);
  });
  return () => controller.abort();
}, [id]);
```
Never ignore promise rejections — always `.catch()` or `try-catch` on `await`.

## User-Facing Error Display
| Error type | Display pattern |
|------------|-----------------|
| Transient (network, save failed) | Toast — auto-dismiss 5s |
| Form validation | Inline under each field |
| Permission / auth | Redirect to login or access denied page |
| Fatal (app crash) | Error boundary fallback with retry button |
| Not found | Dedicated 404 page |

Never show raw error messages or stack traces to users. Provide actionable guidance.

## Network Errors and Resilience
```typescript
async function fetchWithRetry(url: string, opts?: RequestInit, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const res = await fetch(url, opts);
      if (res.ok) return res.json();
      if (res.status >= 500) throw new Error(`Server error: ${res.status}`);
      throw new AppError(await res.json()); // 4xx — don't retry
    } catch (err) {
      if (i === retries - 1 || err instanceof AppError) throw err;
      await new Promise((r) => setTimeout(r, 2 ** i * 1000));
    }
  }
}
```
- Detect offline: `navigator.onLine` + `online`/`offline` events. Show banner, queue mutations.
- Optimistic UI: update state immediately, rollback on failure

## Error Logging
- Use `reportError(error, { route, userId, action })` to send to Sentry/DataDog
- Upload source maps for readable stack traces in production
- Filter noise: `AbortError`, `ResizeObserver` loop errors, browser extensions

## Form Validation
Zod schemas (share with backend when possible):
```typescript
const formSchema = z.object({
  email: z.string().email('Enter a valid email'),
  password: z.string().min(8, 'Must be at least 8 characters'),
});
function handleBlur(field: string) {
  const result = formSchema.shape[field].safeParse(values[field]);
  if (!result.success) setErrors((p) => ({ ...p, [field]: result.error.issues[0].message }));
  else setErrors((p) => ({ ...p, [field]: undefined }));
}
```
- Validate on blur, not keystroke — clear error when user starts correcting
- Disable submit when required fields empty or errors exist
- Re-validate on submit as safety net
