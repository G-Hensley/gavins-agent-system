# Performance as Design

When to reference: anytime perceived speed matters — which is everywhere. A beautiful site that loads in 8 seconds loses to a workmanlike site that loads in 2.

Performance is a **design decision**, not a tech-only concern. Many of the worst perf problems start in design.

## Perceived vs. Actual Performance

The user's experience of speed matters more than the stopwatch. Two pages with identical load times can feel completely different depending on what shows up first and how the wait is presented.

### Tools for perceived performance

- **Skeleton screens** over spinners. The user sees structure immediately, with gray placeholders where content will fill in. Feels much faster than a blank screen with a spinner — even when actual load time is identical.
- **Optimistic updates** — show the result immediately, confirm with the server in the background. See `state-design.md`.
- **Progressive loading** — above-the-fold first. Images load lazy. Below-fold content loads as the user scrolls.
- **Instant feedback on click** — the button must respond within ~50ms (color change, press animation). The actual operation can take longer; the *acknowledgment* must be instant. Without it, users click again, doubting that the click registered.
- **Meaningful loading states** — instead of a generic spinner, show what's happening: "Loading your dashboard..." → "Fetching revenue data..." → "Almost there..."
- **Stagger animations on entry** — elements appearing in sequence (50–100ms apart) feels like the page is "constructing itself" rather than "fighting to load."

## Core Web Vitals — the UX-quality metrics

Google's Core Web Vitals directly measure UX quality. They're also a Google ranking factor. Each has a design implication.

### LCP — Largest Contentful Paint

**What:** how fast the main content (largest image or text block above the fold) appears.
**Target:** < 2.5s.
**Design impact:**
- Hero images must be optimized (WebP/AVIF, correctly sized, `loading="eager"` for above-fold)
- Use `font-display: swap` so text renders in fallback while web fonts load
- Inline critical CSS for above-fold styles
- Don't put video as the LCP element — videos load slowly

### INP — Interaction to Next Paint

**What:** how fast the page responds to user interaction (replaced FID in 2024).
**Target:** < 200ms.
**Design impact:**
- Avoid heavy animations triggered on click
- Debounce expensive operations (search-as-you-type)
- Don't block the main thread with synchronous JS work
- Limit DOM size — huge DOMs make every interaction slower

### CLS — Cumulative Layout Shift

**What:** how much the page jumps around during load.
**Target:** < 0.1.
**Design impact:**
- **Always set explicit `width` and `height` on images and video** — otherwise they reserve no space and content jumps when they load
- Reserve space for ads, embeds, and dynamic content (`min-height` on containers)
- Don't insert content above the fold after page load (e.g., late-loading banners)
- Beware web fonts changing text size mid-load — use `size-adjust` and matching fallbacks

CLS is the most common design-caused performance problem. Most layout shift is preventable in CSS.

## Image Performance Patterns

```html
<!-- Above-fold hero: explicit size, eager load, modern format with fallback -->
<picture>
  <source srcset="hero.avif" type="image/avif">
  <source srcset="hero.webp" type="image/webp">
  <img
    src="hero.jpg"
    width="1600"
    height="900"
    alt="..."
    fetchpriority="high"
    loading="eager"
  >
</picture>

<!-- Below-fold: lazy load -->
<img
  src="card.webp"
  width="400"
  height="300"
  alt="..."
  loading="lazy"
  decoding="async"
>

<!-- Responsive -->
<img
  srcset="card-400.webp 400w, card-800.webp 800w, card-1200.webp 1200w"
  sizes="(min-width: 1024px) 33vw, 100vw"
  src="card-800.webp"
  width="800"
  height="600"
  alt="..."
>
```

## Font Performance

```html
<!-- Preload critical font, inline its declaration -->
<link rel="preload" href="/fonts/Inter-Regular.woff2" as="font" type="font/woff2" crossorigin>

<style>
  @font-face {
    font-family: 'Inter';
    src: url('/fonts/Inter-Regular.woff2') format('woff2');
    font-display: swap;  /* show fallback immediately */
    size-adjust: 100%;   /* match metrics to fallback to reduce shift */
  }
</style>
```

Limit web fonts to **1–2 families and 2–3 weights total**. Each weight is a separate file.

## When to Show What

| Wait | Show |
|---|---|
| 0–100ms | Nothing — feels instant |
| 100–500ms | Click feedback only (button press state) |
| 500ms–2s | Spinner or skeleton |
| 2s–10s | Progress indicator with messaging |
| 10s+ | Progress + "this can take a moment" + cancel option + send-to-background |

Above 10 seconds, give the user something else to do or a way to bail.

## Anti-Patterns That Tank Performance

- **Unoptimized images** — serving a 4000px photo for a 400px thumbnail
- **Font FOIT** (invisible text while fonts load) — use `font-display: swap`
- **Blocking JS in `<head>`** without `async` or `defer`
- **Layout shifts from late-loading ads, images, embeds**
- **Animated GIFs** — use `<video autoplay muted loop playsinline>` instead, much smaller
- **Render-blocking third-party scripts** — analytics, chat widgets loaded synchronously
- **Massive client-side JS bundles** — hydration cost. Use server components, ship less JS.
- **Re-running heavy effects on every render** — missing `useMemo` / `useCallback` dependencies

## Quick Performance Audit

Open the page in Chrome DevTools → Lighthouse → Performance:
- [ ] LCP < 2.5s
- [ ] INP < 200ms
- [ ] CLS < 0.1
- [ ] Images optimized (modern formats, correct sizes, lazy below fold)
- [ ] Fonts use `font-display: swap`
- [ ] No render-blocking resources
- [ ] Click feedback within 50ms
- [ ] Skeletons (not spinners) for content waits
