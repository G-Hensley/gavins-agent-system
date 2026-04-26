# Modern CSS (2025–2026)

When to reference: writing layout CSS, building component-aware UI, animating without JS, choosing between media and container queries, or replacing JS-driven patterns with CSS-native ones.

These are the modern primitives. All have stable cross-browser support as of 2026 (Chrome, Edge, Safari, Firefox). Use them.

## Container Queries

Components that adapt to **their own container's size**, not the viewport. The end of "this card looks broken in the sidebar."

```css
.card-host {
  container-type: inline-size;
  container-name: card;
}

@container card (min-width: 400px) {
  .card { display: flex; flex-direction: row; gap: 1rem; }
}
@container card (max-width: 399px) {
  .card { display: flex; flex-direction: column; gap: 0.5rem; }
}
```

A `<Card>` component placed in a sidebar (narrow) renders vertically; the same component in main content (wide) renders horizontally — without knowing about the page layout. **This is the key shift**: components own their responsive behavior.

When to prefer container queries over media queries:
- Reusable components that appear in multiple contexts
- Layouts where the component's container can change size independently of the viewport
- Design systems building truly portable components

When media queries still win:
- Page-level layout decisions (sidebar visible vs. drawer)
- Global breakpoints tied to the device, not a container

## The `:has()` Selector

The "parent selector" CSS never had — select an element based on what it contains.

```css
/* Style a form group containing an invalid input */
.form-group:has(input:invalid) {
  border-color: red;
  background: rgb(254 226 226 / 0.5);
}

/* Style a card differently when it has an image */
.card:has(img) {
  grid-template-rows: 200px 1fr;
}

/* Hide a placeholder when search has a value */
.search:has(input:not(:placeholder-shown)) .placeholder {
  display: none;
}

/* Highlight a row when its checkbox is checked */
tr:has(input[type="checkbox"]:checked) {
  background: rgb(59 130 246 / 0.1);
}
```

Use cases that previously required JS now solve in 1–2 selectors. Be deliberate — `:has()` does have a perf cost on huge DOMs; profile if you scatter it across thousands of elements.

## CSS Subgrid

Children participate in their parent's grid. The fix for "make all card titles, content, and footers align across a row."

```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}

.card {
  display: grid;
  grid-template-rows: subgrid;
  grid-row: span 3; /* title / content / footer */
}
```

Each card's title, content, and footer align with the same rows in sibling cards — even if the content varies in length. Solves a previously painful layout problem.

## Scroll-Driven Animations

Animations driven by scroll position, no JS, no IntersectionObserver. Native, GPU-accelerated.

```css
@keyframes fade-in-up {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

.section {
  animation: fade-in-up linear both;
  animation-timeline: view();
  animation-range: entry 0% entry 100%;
}
```

`animation-timeline: view()` ties the animation to the element's visibility in the viewport; `animation-range` controls when (entry/cover/exit) the animation maps to scroll. Always pair with `prefers-reduced-motion`.

## View Transitions API

Smooth animated transitions between page states or full-page navigations, with one CSS block.

```css
::view-transition-old(root) { animation: fade-out 0.25s ease-in; }
::view-transition-new(root) { animation: fade-in 0.25s ease-out; }
```

In SPA / app code, wrap a state change to trigger a transition:

```ts
if (document.startViewTransition) {
  document.startViewTransition(() => updateDOM());
} else {
  updateDOM();
}
```

For multi-page (MPA), opt in via:

```html
<meta name="view-transition" content="same-origin">
```

Pair with `view-transition-name: hero` on persistent elements (a hero image that stays through navigation) to morph between routes.

## CSS Nesting

Native nesting (no preprocessor required):

```css
.card {
  background: var(--color-bg-surface);
  padding: var(--spacing-md);

  & > h3 { font-size: 1.25rem; }

  &:hover {
    box-shadow: var(--shadow-md);
  }

  & .footer {
    border-top: 1px solid var(--color-border-default);
    padding-top: var(--spacing-sm);
  }
}
```

Don't over-nest. Two levels deep is plenty; three is a smell.

## `color-mix()`

Compute color blends in CSS — useful for hover states, alpha adjustments, dark/light mode tweaks.

```css
.button {
  background: var(--color-interactive);
}
.button:hover {
  /* 10% darker on hover */
  background: color-mix(in oklch, var(--color-interactive), black 10%);
}
.button:disabled {
  /* faded version of the brand color */
  background: color-mix(in oklch, var(--color-interactive), white 60%);
}
```

## OKLCH Color Space

`oklch(L C H)` — perceptual lightness, chroma, hue. Better than `rgb`/`hsl` for generating accessible palettes and consistent blends:

```css
:root {
  --brand-50:  oklch(97% 0.02 250);
  --brand-500: oklch(60% 0.18 250);
  --brand-900: oklch(20% 0.10 250);
}
```

Same hue and chroma, varying lightness — every shade feels cohesive. Pair with `color-mix(in oklch, ...)` for perceptually uniform hover/disabled states.

## Logical Properties

Direction-agnostic spacing — works in LTR and RTL without rewriting. `margin-inline-start` instead of `margin-left`, `padding-block-end` instead of `padding-bottom`, `inline-size` instead of `width`. Tailwind v4: `ms-*` / `me-*` / `ps-*` / `pe-*`. Use them by default; costs nothing and unblocks RTL.

## Caveats

Email is stuck on ancient CSS support — none of the above. For everything else (modern browsers, evergreen targets), all of these are production-ready in 2026. Verify on `caniuse.com` if you support legacy enterprise IE/old-Edge targets.
