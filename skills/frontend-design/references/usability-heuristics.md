# Nielsen's 10 Usability Heuristics

When to reference: design reviews, usability audits, evaluating any interface for fundamental issues. Jakob Nielsen's heuristics (1994) are the gold standard — worth memorizing and applying every time.

## 1. Visibility of System Status

Keep users informed about what's going on, through appropriate feedback within reasonable time.

**In practice:**
- Loading indicators when data is fetching
- Active states on the current nav item / current step
- Selection feedback (highlighted row, checked box, focus ring)
- Progress bars for multi-step or long-running operations
- "Saved" / "Saving..." indicators in autosave flows

**Failure mode:** the user clicks a button and nothing visibly happens. Did it work? They click again. Now it's submitted twice.

## 2. Match Between System and the Real World

Use language and concepts familiar to users — not system-oriented jargon. Follow real-world conventions where they fit.

**In practice:**
- Calendar metaphors for scheduling (not "temporal range objects")
- Folder metaphors for organization
- "Cart" / "checkout" for e-commerce — not "user inventory" / "transaction confirmation"
- Match the user's vocabulary (see `ux-writing.md`)

**Failure mode:** a date input labeled "ISO-8601 timestamp." Users think you're talking down to them or you're disconnected from how they think.

## 3. User Control and Freedom

Support undo and redo. Provide "emergency exits" — cancel buttons, back navigation, escape from unwanted states. Let users leave without extended dialogue.

**In practice:**
- Undo for destructive actions (delete, archive, send)
- "Cancel" available throughout multi-step flows
- Clear back navigation
- Closing modals via Escape, click outside, or X
- Don't trap users in flows they didn't ask for

**Failure mode:** "Are you sure you want to leave? You'll lose all your progress!" — preserving progress automatically would have prevented this.

## 4. Consistency and Standards

Follow platform conventions. Don't make users wonder whether different words, situations, or actions mean the same thing.

**In practice:**
- Same button styles for the same role across pages
- Same vocabulary throughout (don't switch "delete" / "remove" / "trash")
- Use platform conventions (top-right close button, hamburger for mobile menu, common keyboard shortcuts)
- Components that look the same should behave the same

**Failure mode:** "Save" on one page and "Update" on another for the same action. Or worse: "Save" is destructive in one context and additive in another.

## 5. Error Prevention

Even better than good error messages: prevent the error from happening.

**In practice:**
- Disable buttons that aren't valid yet (or, better — let users click and explain why it didn't work; see form-design.md)
- Use constraints — date pickers instead of free-text date fields
- Confirm destructive actions ("Delete 12 photos?")
- Validate inline so users can fix issues as they go
- Prevent invalid input where possible (phone field accepts only digits)

**Failure mode:** a free-text "country" field instead of a dropdown — users type "USA," "U.S.A.," "United States," "US." Now your data is dirty *and* the user is annoyed.

## 6. Recognition Rather Than Recall

Make options visible. Show recent items, suggestions, labels. Don't rely on memory across screens.

**In practice:**
- Show field labels — don't rely on placeholders alone
- Show recently-used items at the top of pickers
- Show keyboard shortcuts in tooltips and menus
- Autocomplete on form fields
- Breadcrumbs so users see where they are

**Failure mode:** a settings page where every option is named with an acronym requiring you to look up the docs.

## 7. Flexibility and Efficiency of Use

Provide shortcuts for expert users without cluttering the interface for beginners.

**In practice:**
- Keyboard shortcuts (J/K to navigate, ⌘K for search)
- Bulk actions for power users (select all, multi-edit)
- Customizable dashboards
- Saved views / saved searches
- Templates for repeated workflows

**Failure mode:** every interaction takes the same number of clicks regardless of expertise. Power users grind their teeth.

## 8. Aesthetic and Minimalist Design

Every extra element competes with the relevant ones and diminishes their visibility. Remove what doesn't serve the user's task.

**In practice:**
- One primary action per screen
- Hide advanced options behind disclosure (see `progressive-disclosure.md`)
- Generous whitespace
- Restrict color and font palette
- Cut decorative elements that don't serve hierarchy or grouping

**Failure mode:** every section has a primary CTA, three accent colors, and a background pattern. The user has no idea what to do first.

## 9. Help Users Recognize, Diagnose, and Recover from Errors

Errors must be in plain language, precisely indicate the problem, and suggest a solution. (See `ux-writing.md`.)

**In practice:**
- Three parts: what / why / how-to-fix
- Place errors next to the cause, not at the top
- Use plain language, never error codes alone
- Offer the fix as a button or link where possible ("Connect again", "Update payment method")

**Failure mode:** "Error 500" on a checkout page. The user has no idea whether they were charged.

## 10. Help and Documentation

Even though a system should be usable without docs, sometimes help is necessary. Make it searchable, task-focused, and concise.

**In practice:**
- Searchable docs / help center
- Task-based help ("How do I export?") not feature-based ("The Export module")
- Inline help when context-relevant (a "?" icon next to a confusing setting)
- Onboarding tutorials that can be skipped or replayed
- Empty states that teach (see `state-design.md`)

**Failure mode:** help is a 200-page PDF named `manual_v3_FINAL.pdf` linked from the footer.

## Using Heuristics for Design Reviews

Walk through any screen and grade against all 10:
1. **Status** — does the user know what's happening?
2. **Real world** — is the language right?
3. **Control** — can they undo / cancel / go back?
4. **Consistency** — does it match other parts of the app?
5. **Prevention** — could common errors be designed out?
6. **Recognition** — are options visible or do they require memory?
7. **Efficiency** — are there shortcuts for repeat users?
8. **Minimalism** — is anything redundant or distracting?
9. **Errors** — are messages clear and actionable?
10. **Help** — can the user get unstuck?

A design that scores well on most of these will feel solid even before delight is layered on. A design failing on three or more is in usability debt no matter how pretty it is.
