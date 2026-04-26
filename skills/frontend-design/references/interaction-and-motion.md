# Interaction & Motion

When to reference: adding animation, micro-interactions, transitions, hover states, or any movement to an interface.

## What Motion Is For

Motion serves four jobs: **feedback** (responding to action), **continuity** (maintaining context across a transition), **focus** (directing attention), and **personality** (expressing brand). If an animation doesn't do one of those, remove it. "It looks cool" is not a reason.

## Micro-interactions (Saffer Model)

Every micro-interaction has four parts. Design each deliberately:

- **Trigger** — what starts it. User-initiated (click, hover, swipe, scroll) or system-initiated (timer, condition met, data arrived).
- **Rules** — the logic. What state changes, what is validated, what request fires.
- **Feedback** — the visible response. The button color, the checkmark, the slide, the toast.
- **Loops & Modes** — does it repeat? Onboarding tooltip (once), notification badge (until cleared), spinner (until done).

### Where they matter most

- **Button states**: default → hover → active → loading → success/error. Every state must look distinct. A button without a hover response feels dead.
- **Form validation**: inline, on blur, smooth red border + message — never page reload.
- **Toggles**: position + color both communicate state.
- **Loading**: skeletons for content, spinners for actions, progress bars for known-duration operations.
- **Notifications**: slide in, persist, fade out. Animate badge count changes.

## Duration Guidelines

| Interaction | Duration |
|---|---|
| Micro (hover, toggle, button press) | 100–200ms |
| UI (modal, drawer, dropdown) | 200–300ms |
| Page transitions | 300–500ms |
| Choreographed sequences | up to 800ms total — no single element over 500ms |

Under 100ms feels instant. Over 400ms feels sluggish (Doherty Threshold). When in doubt, go shorter.

## Easing — The Most Important Part

Pick easing by **direction of motion**, not by aesthetic preference:

- **`ease-out`** (fast start, slow finish) — for elements **entering** the screen. Modals opening, dropdowns appearing, toasts sliding in. Feels respectful: "I'm here, settling in."
- **`ease-in`** (slow start, fast finish) — for elements **exiting**. Modals closing, toasts dismissing. Feels efficient: "getting out of your way."
- **`ease-in-out`** (slow → fast → slow) — for elements **moving within** the viewport. Position changes, reorderings, accordion panels. Feels balanced.
- **`linear`** — almost never appropriate. Only for progress bars, spinners, or anything where steady speed communicates steady progress.

Mnemonic: arrive composed (out), leave promptly (in), travel naturally (in-out).

```css
/* Entering */
.modal-enter { transition: transform 0.25s cubic-bezier(0, 0, 0.58, 1); }

/* Exiting */
.modal-exit { transition: transform 0.2s cubic-bezier(0.42, 0, 1, 1); }

/* Moving within viewport */
.element-move { transition: transform 0.3s cubic-bezier(0.42, 0, 0.58, 1); }
```

Tailwind: `transition-transform duration-200 ease-out` for entrances, `ease-in` for exits.

## Performance — Animate Compositor Properties Only

Only `transform` and `opacity` animate without triggering layout or paint. Everything else is expensive.

- **Cheap**: `transform: translate/scale/rotate`, `opacity`
- **Expensive**: `width`, `height`, `top`, `left`, `padding`, `margin`, `border`, `font-size`

Replace `left: 100px → left: 0` with `transform: translateX(100px) → translateX(0)`. Replace `width: 0 → width: 100%` with `transform: scaleX(0) → scaleX(1)` (and an inverse on the child if needed).

Use `will-change: transform` only on elements about to animate, then remove it. Permanent `will-change` wastes GPU memory.

## Accessibility — `prefers-reduced-motion`

This is non-negotiable. Some users get vestibular nausea from screen motion. Always respect their preference:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Worst offenders: parallax scrolling, large-scale zoom effects, autoplay video, infinite carousels. Provide static alternatives or off-switches.

## What NOT to Animate

- Text that the user is reading
- Anything blocking the user from completing their task
- More than 3–4 elements at once (overwhelming)
- Anything longer than 500ms in a transactional flow
- Continuous attention-grabbing motion (looping wiggles, pulsing CTAs) outside of clearly indeterminate progress
