# Design Anti-Patterns

When to reference: design reviews, audits, refactoring sessions, or whenever something feels off and you can't name it. A catalog of common failure modes across visual, UX, and performance.

## Visual Design Anti-Patterns

### Centered everything
Centering is not a layout strategy. It creates weak visual hierarchy and makes scanning difficult. **Default to left-align**; center sparingly for headlines, hero CTAs, and short marketing blurbs. Centered paragraphs are unreadable — ragged edges on both sides break the eye's flow.

### Inconsistent spacing
Mixing different gaps between similar elements (`mt-3` here, `mt-5` there) reads as accidental. Use a spacing scale and stick to it. If three cards in a grid have different vertical rhythms, the page looks unfinished.

### Too many fonts
Three or more typefaces creates visual noise. Two is the maximum (one for headings, one for body); one is often enough. Don't mix decorative, sans-serif, and serif on the same page.

### Low-contrast text
Light gray on white is the most pervasive contrast failure. Body text needs at least 4.5:1 — about `gray-700` on white. Designers chasing "elegance" with `gray-400` body text fail WCAG AA and lose users with mild visual impairment.

### Decoration without purpose
Gradients, drop shadows, borders, and background patterns that don't serve hierarchy or grouping. Every visual element should answer "what does this help the user do?" If the answer is "it looks fancy," remove it.

### Pixel-perfect rigidity
Obsessing over exact pixel values instead of proportional, flexible layouts that work across viewports. Design in tokens and ratios, not raw pixels. A "perfect" pixel layout breaks at the next breakpoint.

### Stacking visual cues
Cards with both a border and a shadow and a background tint and rounded corners and a hover lift. Pick the lightest combination that works. Stacking cues makes everything feel heavy.

## UX Anti-Patterns

### Mystery meat navigation
Icons without labels, cryptic link text, navigation that requires hovering to understand. The user shouldn't have to guess what each option does. When in doubt, label it.

### Infinite scroll without orientation
No way to know where you are, no way to return to a specific item, no footer access (the footer is unreachable). Provide:
- "Back to top" button
- Pagination as an alternative
- Persistent count or progress indicator
- URL state that can be deep-linked

### Modal abuse
Using modals for content that should be a full page. Stacking modals on modals. Showing modals before the user has engaged with the page (a popup at second 2 of the first visit). Modals interrupt — use them only when the action requires complete focus and is short.

### Confirmation fatigue
Asking "Are you sure?" for every action. Reserve confirmations for **destructive, irreversible** actions only. For everything else, use undo. Repeated confirmations train users to click "Yes" reflexively, defeating the safety purpose.

### Feature parity assumption
Assuming mobile users want the same experience as desktop. Mobile contexts differ: smaller screens, thumb reach, intermittent attention, interruptions. Some features should be *different* on mobile, not crammed in.

### Disappearing labels (placeholder as label)
Placeholders disappear on input, forcing users to remember what the field was for. Use visible labels above inputs; reserve placeholders for **format hints** ("MM/DD/YYYY").

### "Click to learn more" with no context
Generic "Learn more" links with no preview of what's behind them. Users have no reason to click. Tell them what they'll get: "Read the case study (5 min)", "See pricing", "View our security docs."

### Forced-pop-ups before content
Email capture modals on the first visit, before the user has even seen what you offer. Maximally hostile pattern.

## Form Anti-Patterns

(See `form-design.md` for positive patterns.)

- **Multi-column layouts** that slow scanning
- **Asking for too much** ("How did you hear about us?" on a free signup)
- **Validating on every keystroke** — aggressive and distracting
- **Clearing the form on error** — punishment for trying
- **Demanding specific input format** instead of parsing flexibly
- **Disabled submit buttons that don't explain why**
- **Inputs without `autocomplete` attributes** — punishing mobile users
- **Hidden required-field markers** — users only learn after submission

## Performance Anti-Patterns

(See `performance-as-design.md` for positive patterns.)

- **Unoptimized images** — 4000px source for a 400px thumbnail
- **Font FOIT** — invisible text while web fonts load (use `font-display: swap`)
- **Render-blocking JS in `<head>`** without `async` or `defer`
- **Layout shifts from late-loading content** — ads, images, embeds without reserved space
- **Animated GIFs** — 10× the size of equivalent `<video>`
- **Massive client-side bundles** — when server components could ship less JS
- **Spinner instead of skeleton** for content loads — feels slower

## Accessibility Anti-Patterns

(See `accessibility.md` for positive patterns.)

- **`outline: none`** without a replacement focus indicator
- **`<div onClick>`** instead of `<button>`
- **Color-only state indication** (red/green without text or icon)
- **Auto-playing media with sound**
- **Tiny touch targets** (<44×44 CSS px on mobile)
- **Modal that doesn't trap focus or restore it on close**
- **Required fields without visible markers**
- **Carousels with no pause control**

## Trust Anti-Patterns

(See `trust-and-credibility.md` for positive patterns.)

- **Anonymous testimonials** ("Sarah M., happy customer")
- **Stock-photo "team"** that's clearly not your team
- **Hidden pricing** behind "contact us" with no range
- **Pre-checked opt-ins**
- **Confirmshaming** decline buttons
- **Fake urgency** ("Sale ends in 23:47!" that resets on refresh)
- **Hidden fees revealed at final checkout**
- **Cancellation flows harder than signup**

## Microcopy Anti-Patterns

(See `ux-writing.md` for positive patterns.)

- **"Submit" / "OK" / "Continue"** as button labels — vague
- **"Are you sure?"** with "OK" / "Cancel" buttons — make the verb match the action
- **"Error 500"** as the user-facing message
- **Cute tone in serious moments** ("Whoops! 🤡" on a payment failure)
- **Jargon** that only the team uses
- **Placeholder-as-label**

## Quick Anti-Pattern Audit

When something feels wrong but you can't name it, run through:
- Is anything centered that shouldn't be?
- Are spacing and font choices consistent?
- Is contrast sufficient?
- Are there modals doing the work of pages?
- Are confirmations being used for non-destructive actions?
- Are placeholders pretending to be labels?
- Are images, fonts, or third-party embeds causing layout shift?
- Is anything in the trust section that you'd be embarrassed to defend?

If you can name three or more, that's the design debt to pay down first — before adding more delight.
