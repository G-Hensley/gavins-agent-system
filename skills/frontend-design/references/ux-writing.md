# UX Writing & Microcopy

When to reference: writing button labels, form placeholders, error messages, empty states, tooltips, confirmation dialogs, onboarding text — any text inside the UI.

Microcopy is the most undervalued design element. Visual polish gets noticed; bad microcopy gets people stuck.

## Core Principles

- **Clarity over cleverness.** "Save changes" beats "Let's lock this in!" Users scan; they don't read for pleasure.
- **Active voice.** "We couldn't save your file." not "The file could not be saved."
- **Front-load the important word.** "Delete this project permanently?" not "Are you sure you want to permanently delete this project?" — the user should see "Delete" first.
- **Match the user's vocabulary.** If users say "folder," don't write "directory" or "collection."
- **Be specific.** "Upload failed: file exceeds 10MB" not "Upload failed."
- **Cut every word that doesn't earn its place.** Half the length, twice the clarity.

## Button Labels

The most important microcopy in the product. A label should describe **what will happen when clicked** — not a vague action.

| Bad | Good |
|---|---|
| Submit | Send invitation |
| Save | Save draft |
| Continue | Delete account permanently |
| OK | Got it / Apply changes |
| Cancel | Keep editing |

For destructive actions, **the button label IS the answer**. Replace generic OK/Cancel with action-specific verbs:

- "Delete 12 photos?" with "Delete photos" / "Keep photos"
- "Discard unsaved changes?" with "Discard" / "Keep editing"
- "Sign out of all sessions?" with "Sign out everywhere" / "Stay signed in"

This eliminates the "wait, which button does what?" hesitation that destroys confidence in destructive flows.

## Error Messages — The Three-Part Formula

1. **What went wrong** — in human language
2. **Why** — if the cause is useful context
3. **How to fix it** — a specific, actionable next step

| Level | Email field example |
|---|---|
| Bad | "Invalid input" |
| Better | "Please enter a valid email address" |
| Best | "This doesn't look like an email address. Try `name@example.com`." |

| Level | Permission example |
|---|---|
| Bad | "Error 403" |
| Better | "You don't have permission to view this page" |
| Best | "You don't have permission to view this page. Ask your workspace admin to invite you." |

Never:
- Blame the user ("You entered the wrong password")
- Show stack traces or error codes alone
- Leave the user without a next step
- Use the word "invalid" when you can be specific

## Voice and Tone

**Voice is consistent.** It's the brand's personality across every interaction. Slack is casual and witty. Stripe is precise and technical. Notion is warm and structured. Voice doesn't change.

**Tone adapts to context.** Same brand, different moments:

- Success → confident, brief
- Error → calm, helpful, no jokes
- Confirmation of destructive action → serious, exact
- Onboarding → warm, encouraging
- Routine → quiet, get out of the way

A common failure: playful tone bleeding into errors and destructive confirmations. If a user is stressed, they don't want a winking emoji.

## Placeholder Text

- **Do** use placeholders to **show format**: `MM/DD/YYYY`, `name@company.com`
- **Don't** use placeholders as **labels** — they disappear on input, forcing the user to remember what the field was for
- **Don't** start with "Enter your..." — redundant. Show the format or an example instead

Tip: combine a *visible label* with a *format hint placeholder* for any non-obvious field.

## Empty States, Tooltips, Confirmations

**Empty states** — see `state-design.md`. Three jobs: explain, contextualize, prompt action. Set tone here.

**Tooltips** — for shortcuts and clarification, not primary instructions. Keep under 10 words. Never put a critical action behind a tooltip (it's invisible to keyboard users and most touch users).

**Confirmation dialogs** — only for destructive or irreversible actions. The dialog must:
- Name the specific thing affected ("Delete 12 photos" not "Delete items")
- Make the destructive button labeled with the verb ("Delete photos")
- Make the safe button equally labeled ("Keep photos" not just "Cancel")
- Optionally, require typing a confirmation for catastrophic actions ("Type DELETE to confirm")

## Quick Phrasing Checks

Before shipping any string, ask:
- [ ] Is the most important word at the start?
- [ ] Could a first-time user understand it?
- [ ] If something goes wrong, can the user recover?
- [ ] Is there a verb in the button label?
- [ ] Did I use jargon that only the team uses?
- [ ] Could this be half as long?

## Numbers, Dates, and Units

- Spell out one through nine in prose; numerals for 10+. Always numerals in UI ("3 items", not "three items").
- Use the user's locale (date format, currency, units). Show "Mar 14, 2026" in US, "14 Mar 2026" in EU.
- Singular/plural matters: "1 item", "2 items" — don't write "1 item(s)".
- Relative time for recent ("3 minutes ago", "yesterday"); absolute for older ("Mar 14").

## Localization Readiness

If the product will be translated:
- Avoid concatenating sentences from variables ("You have " + n + " items"). Use full templates.
- Leave 30% layout slack for languages that expand (German, Russian).
- Don't put critical meaning in icons alone.
- Avoid culture-specific idioms in microcopy.
