# Progressive Disclosure & Information Architecture

When to reference: designing complex interfaces, settings panels, dashboards, multi-step flows, or anything that risks overwhelming the user with options.

## Progressive Disclosure

Show users only what they need at each moment. Defer complex, advanced, or rarely-used features to secondary screens. (Nielsen, 1995 — still gold-standard.)

**Why it works:** working memory holds ~7±2 simple items, fewer for complex ones (Miller's Law). Hiding advanced options behind a click reduces decisions per step.

## Disclosure Patterns

| Pattern | Use for |
|---|---|
| **Accordion** | FAQs, settings panels, product specs. Heading visible, content hidden until clicked. |
| **Tabs** | Related content in labeled groups. "General / Notifications / Security / Privacy." |
| **"Show more" / "Advanced options"** | A simple default with an escape hatch. Google search vs. Advanced Search. |
| **Multi-step wizard** | A 20-field form becomes 4 steps of 5. Progress indicator + back nav. |
| **Hover/click reveals** | Tooltips, expandable rows, detail-on-demand. |
| **Contextual controls** | Formatting bar appears only when text is selected. Delete only on hover. |

## The Tradeoff: Disclosure vs. Discoverability

Hiding reduces cognitive load **but hurts discoverability**. If users can't find a feature because it's buried, you've over-applied the pattern.

**Rule of thumb:**
- Primary features: visible at all times
- Secondary features: one click away
- Tertiary features: two clicks away (max for anything users need regularly)

Never bury a frequent action three levels deep. The fix isn't always more disclosure — sometimes it's better defaults or removing the feature.

## Information Architecture

IA is the structural design of information environments — how content is organized, labeled, and navigated. Get IA wrong and no amount of UI polish saves you.

### Validation methods

- **Card sorting** — give users content labels and ask them to group them. Reveals their mental model.
  - *Open sort*: users create their own categories
  - *Closed sort*: users sort into your predefined categories
- **Tree testing** — give users a text-only hierarchy + tasks ("Find the return policy"). Tests whether the structure works *before* you build UI around it.
- **First-click testing** — measures whether users start in the right direction. The first click predicts task success better than any other metric.

### Navigation models

| Model | Best for | Example |
|---|---|---|
| **Hub-and-spoke** | Few top-level features, return to center | iOS home screen |
| **Nested doll** | Linear hierarchy, drill down | Settings → Account → Password |
| **Tabbed** | Top-level categories always visible | Gmail's Inbox/Sent/Drafts |
| **Filtered** | Same content, different views | E-commerce listings |
| **Bento box** | Independent dashboard modules | Admin panels |

Most products mix two or three. A web app might use tabs at the top + nested doll within each tab + filtered views in lists.

## The 3-Click "Rule" Is a Myth

Joshua Porter's testing (and many others since) found that **click count doesn't predict satisfaction**. What matters is whether each click feels like progress toward the goal. A 5-click path with clear signposting beats a 2-click path with ambiguous labels.

Optimize for: confidence at each step, clear next action, no dead-ends. Not for click count.

## Wizard / Multi-step Patterns

For forms or flows over ~7 fields, break into steps:

- **Progress indicator** — "Step 2 of 4" or a labeled progress bar
- **Logical groupings** — each step is one conceptual unit (account info, then shipping, then payment), not an arbitrary split
- **Back without data loss** — never punish a user for going back to fix something
- **Review/summary step** — show everything before final submit
- **Save & resume** for long flows — let users come back later

Don't fake progress. If it's really 12 steps, don't tell them it's 4.

## Disclosure for Settings

Settings panels are where progressive disclosure pays the most. Apply this hierarchy:

1. **Most-used settings up front** — what 80% of users will touch (theme, notifications)
2. **Grouped categories** behind tabs or accordions — Account, Privacy, Integrations, Advanced
3. **"Advanced" or "Developer" sections** for rarely-used or risky options
4. **Search** — for any settings page over ~30 items, add search

Apple's System Settings on iOS gets this right; many enterprise admin panels do not.

## Anti-patterns

- **Burying primary CTAs** behind "More" menus
- **Three-deep nesting for routine tasks** ("Settings → Preferences → Notifications → Email" when it could be one screen)
- **Ambiguous labels on disclosure triggers** ("More options" vs. "Advanced filters" — the second tells you what you'll find)
- **Hiding errors or required actions** in collapsed sections
- **Pretending complexity doesn't exist** — if a tool is genuinely complex, don't oversimplify; teach the user instead
