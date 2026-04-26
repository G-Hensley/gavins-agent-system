# Accessibility

When to reference: every UI you build. Accessibility is not a checklist to pass at the end — it's a design philosophy applied throughout.

## Compliance Reality (2025–2026)

WCAG 2.2 Level AA compliance is now a **legal requirement** under:
- **ADA** (United States) — long-established case law treats websites as places of public accommodation
- **European Accessibility Act** (EU) — became enforceable on **June 28, 2025**

This is no longer optional for commercial products. The exposure is real (lawsuits, fines, market access in EU).

## POUR — The Four Principles

WCAG organizes around four principles:

- **Perceivable** — information must be presentable in ways users can perceive
  - Text alternatives for images (`alt` attributes)
  - Captions and transcripts for audio/video
  - Sufficient color contrast
  - Content adaptable to different presentations

- **Operable** — UI must be operable by all users
  - Keyboard accessible
  - No time limits (or controllable ones)
  - No seizure-inducing content (avoid flashing > 3Hz)
  - Navigable structure (skip links, landmarks)

- **Understandable** — information and operation must be understandable
  - Readable text (language declared, defined jargon)
  - Predictable behavior (no surprises)
  - Input assistance (clear errors, labels)

- **Robust** — content must work across diverse user agents and assistive tech
  - Valid, semantic HTML
  - Standard ARIA usage when needed
  - Compatible with current and future tools

## Beyond the Checklist — Practical Principles

### Don't use color alone

Roughly 8% of men have red-green color deficiency. A red/green status indicator is invisible to them. Always pair color with:
- An **icon** (✓ ✗ ⚠)
- A **label** ("Failed" / "Passed")
- A **pattern** (in charts: stripes, dots, shapes)

### Semantic HTML first

Before reaching for ARIA, use the right element:

| Use | Not |
|---|---|
| `<button>` | `<div onClick>` |
| `<a>` | `<span>` styled like a link |
| `<nav>` | `<div class="nav">` |
| `<main>`, `<section>`, `<article>`, `<aside>` | nested `<div>`s |
| `<label>` with `for` | placeholder-as-label |
| `<table>` for tabular data | CSS grid faking a table |

Semantic elements come with focus management, keyboard handling, and screen-reader semantics for free. ARIA is a fallback when no native element fits — not a default.

### Focus management

- **Visible focus rings** on all interactive elements. Tailwind: `focus-visible:ring-2 focus-visible:ring-interactive focus-visible:ring-offset-2`. Never `outline: none` without a replacement.
- **Modal opens** → focus moves to the modal (usually the close button or first input).
- **Modal closes** → focus returns to the trigger that opened it.
- **Dynamic content loads** → announce to screen readers via `aria-live="polite"` regions.
- **Tab order** matches visual order. Use DOM order; avoid `tabindex` other than `0` and `-1`.

### Skip links

A hidden link at the very top of every page, visible on focus, that lets keyboard users skip past repeated navigation:

```html
<a href="#main" class="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 ...">
  Skip to main content
</a>
```

### Touch target size

- **iOS guideline:** 44×44pt minimum
- **Material Design:** 48×48dp minimum
- **WCAG 2.2:** 24×24 CSS px (Level AA), 44×44 (AAA)

These are **minimums**. With ≥8px spacing between adjacent targets to prevent mis-taps. Tailwind: `min-h-11 min-w-11` on touch-priority elements.

### Reduced motion

Always honor `prefers-reduced-motion`. See `interaction-and-motion.md` for the full block. Provide static alternatives to motion-heavy content.

### Contrast

Text contrast minimums (WCAG AA):
- **Normal text:** 4.5:1
- **Large text** (18pt+ or 14pt+ bold): 3:1
- **UI components & graphical objects:** 3:1

Light gray on white is the most pervasive failure. Body text needs ~`gray-700` on white. Tools: WebAIM Contrast Checker, browser DevTools accessibility panel.

### Form accessibility

(See `form-design.md` for the full picture.)

- Every input has an associated `<label>`
- Required fields use the `required` attribute *and* a visible indicator
- Errors use `role="alert"` or `aria-live`
- Errors linked to their input via `aria-describedby`
- Focus moves to the first error on submit failure

## Screen Reader Essentials

- **Announce dynamic content** with `aria-live="polite"` (or `"assertive"` for urgent updates only)
- **Hide decorative imagery** from screen readers with `aria-hidden="true"` or `alt=""` (empty alt = decorative)
- **Provide alt text** that conveys meaning, not just description ("Submit" button, not "blue circle")
- **Label icon-only buttons** with `aria-label` ("Close", "Search")
- **Don't trap focus** outside of modals (and inside modals, *do* trap it)

## ARIA — Use Sparingly, Use Correctly

The first rule of ARIA: don't use ARIA. Use semantic HTML instead. When you must:

- **Roles** — only when no native element fits (`role="dialog"`, `role="alert"`)
- **States** — `aria-expanded`, `aria-selected`, `aria-checked`, `aria-disabled`
- **Properties** — `aria-label`, `aria-labelledby`, `aria-describedby`

Don't:
- Add `role="button"` to a `<div>` instead of using `<button>`
- Re-label things that have implicit labels
- Hide critical content with `aria-hidden`
- Use ARIA roles you don't actually understand

## Testing

- **Keyboard-only navigation** — unplug your mouse and try the page. Can you reach and operate every element? Is the focus order logical?
- **Screen reader spot-check** — VoiceOver (macOS/iOS), NVDA (Windows), TalkBack (Android)
- **Automated tools** — axe DevTools, Lighthouse accessibility audit, eslint-plugin-jsx-a11y
- **Real users** — automated tests catch ~30%; user testing catches the rest

## Quick Accessibility Audit

For any new screen:
- [ ] All interactive elements reachable by keyboard
- [ ] Visible focus indicators on every interactive element
- [ ] Color contrast meets 4.5:1 (normal text), 3:1 (large/UI)
- [ ] Information not conveyed by color alone
- [ ] All images have meaningful or empty alt text
- [ ] All form inputs have associated labels
- [ ] Touch targets ≥44px on mobile
- [ ] `prefers-reduced-motion` honored
- [ ] Skip-to-content link present
- [ ] Page passes axe DevTools with no critical issues
