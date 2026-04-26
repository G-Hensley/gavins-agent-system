# Form Design

When to reference: any form — signup, checkout, settings, search, contact. Forms are where most abandonment happens. Good form design reduces friction, prevents errors, and respects time.

## Layout

- **One column.** Multi-column forms slow users down — the eye has to track both horizontally and vertically. Baymard Institute's testing consistently shows single-column outperforms.
- **Labels above inputs.** Faster completion than left-of-input labels. Top-aligned creates a clean vertical scan.
- **Group related fields visually.** Shipping address together, payment together, with clear gaps between groups. Use `<fieldset>` with `<legend>` for accessible grouping.
- **Logical tab order matches visual order.** Never make users tab around the form.
- **One primary action.** Submit/Save is the only filled button. Cancel is a text link or outlined button — never of equal weight.

## Validation

- **Inline, on blur** — validate when the user leaves a field, not on every keystroke. Per-keystroke is aggressive and distracting.
- **Show success too** — green checkmark on valid fields gives positive reinforcement, not just red on errors.
- **Errors next to the field**, never only at the top. Users shouldn't scroll to find what's wrong.
- **Don't clear the form on error.** The user just spent time. Preserve input; highlight only what needs fixing.
- **Be forgiving with input.** Phone numbers in any format (spaces, dashes, parens). Dates in multiple formats. Strip leading/trailing whitespace silently. Parse what they give you.

## Reducing Fields

Every field you remove increases completion rate.

- **Ask only what you need.** No fax numbers in 2026. No "how did you hear about us" on signup.
- **Smart defaults.** Pre-fill country from IP. Default to the most common option. Auto-detect card type from number.
- **Combine where possible.** "Full name" instead of separate first/last (unless you genuinely need them separated).
- **Defer optional fields.** Collect the minimum to complete the action; ask for more later, in context.

## Multi-step Forms

For forms over ~7 fields, consider stepping:

- **Progress indicator** — "Step 2 of 4" or labeled bar
- **Logical groups per step** — not arbitrary splits
- **Back without data loss** — never punish navigation
- **Review/summary step** before submit
- **Save & resume** for long flows

See `progressive-disclosure.md` for the wizard pattern in detail.

## Input Types and Mobile Keyboards

The HTML input type drives the mobile keyboard. Get this right or you frustrate every mobile user:

| Input | Keyboard |
|---|---|
| `type="email"` | Shows `@` and `.com` |
| `type="tel"` | Number pad |
| `type="url"` | Shows `/` and `.com` |
| `type="number"` + `inputmode="numeric"` | Number pad without spinners |
| `type="search"` | "Go" / "Search" action key |
| `type="date"` | Native date picker |

## Autocomplete

`autocomplete` lets the browser fill saved data. Users have name, email, address, and card data saved — they expect it to fill.

Common values:
```html
<input autocomplete="given-name">
<input autocomplete="family-name">
<input autocomplete="email">
<input autocomplete="tel">
<input autocomplete="street-address">
<input autocomplete="postal-code">
<input autocomplete="cc-number">
<input autocomplete="cc-exp">
<input autocomplete="cc-csc">
<input autocomplete="one-time-code">  <!-- SMS OTP autofill -->
<input autocomplete="new-password">  <!-- triggers password generation -->
<input autocomplete="current-password">
```

Without these, mobile users will rage-type long forms by hand.

## Required vs. Optional

Mark whichever is *less* common. If most fields are required, mark optional ones. If most are optional, mark required. Don't redundantly mark every required field with an asterisk if they all are.

If asterisks are used, include a legend ("* required") above the form.

## Error Messaging in Forms

Per `ux-writing.md` — what / why / how-to-fix.

- "This doesn't look like an email. Try `name@example.com`."
- "Password must be at least 8 characters."
- "We don't recognize that card number. Check it and try again."

Place errors **below the field**, in red, with an icon for non-color users. Use `aria-invalid="true"` and link to the message via `aria-describedby` for screen readers.

## Submit Behavior

- **Disable the submit button** while the request is in flight. Show a spinner inside it. This prevents double-submit.
- **Don't disable it before submission** based on perceived "completeness" — let the user submit, then validate. Disabled buttons don't tell users *what* is wrong.
- **Show a clear success state** on completion. Don't just clear the form.
- **Preserve form data on submission failure** — never lose input on a network error.

## Accessibility Essentials

- Every input has an associated `<label>` (via `for`/`id` or wrapping)
- Required fields use `required` attribute *and* visible indicator
- Error messages use `role="alert"` or `aria-live="polite"`
- Focus moves to the first error field on submit failure
- Visible focus rings on all inputs (`focus:ring-2 focus:ring-interactive`)
- Touch target ≥44×44px on mobile (use `min-h-11` on inputs)

## Quick Form Audit

For any form ask:
- [ ] Is every field genuinely needed?
- [ ] Are labels above inputs, single-column?
- [ ] Are inputs typed correctly for mobile keyboards?
- [ ] Are autocomplete attributes set?
- [ ] Does inline validation fire on blur?
- [ ] Is the submit button labeled with the action?
- [ ] Does it preserve input on error?
- [ ] Does it announce errors to screen readers?
