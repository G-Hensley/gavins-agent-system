# Navigation Patterns

When to reference: choosing a navigation structure, building headers/sidebars/mobile nav, designing breadcrumbs, picking between hamburger and visible links.

For information architecture (the underlying structure), see `progressive-disclosure.md`.

## Top Navigation Bar

The default web pattern. Logo left, links center or right, CTAs far right.

**When to use:** sites with 3–7 top-level sections. Most marketing sites and content sites.

**Treatments:**
- **Sticky on scroll** — most common. Always available.
- **Hide on scroll-down, show on scroll-up** — gives content more room while keeping nav reachable. Good for long-read content.
- **Compress on scroll** — full-size at top of page, condensed (smaller logo, fewer items) once scrolled.

Don't auto-hide top nav on apps where users frequently switch sections — they'll fight to summon it back.

## Side Navigation (Sidebar)

Vertical, persistent or collapsible.

**When to use:** complex applications with many sections — admin panels, dashboards, documentation, IDEs.

**Treatments:**
- **Persistent expanded** — labels always visible. Best for desktop with screen room.
- **Collapsible to icons** — toggle between full-width and icon-only. Tooltips on hover for icon mode. Saves room without losing nav.
- **Off-canvas (mobile)** — slides in from the side via hamburger trigger.

Group related items with subheadings. Show active state on the current item. Indent sub-items.

## Bottom Navigation (Mobile)

3–5 icons at the bottom of the screen, within thumb reach. The primary mobile pattern for apps.

**Rules:**
- **Never more than 5 items.** With 5, the middle one is sometimes a primary action ("+ Add").
- **Use labels with icons**, not icons alone. Icon-only navigation is mystery meat (see anti-patterns).
- **Highlight active state clearly.** Filled icon + colored label, plus a top indicator.
- **Don't replicate desktop top-nav verbatim** — mobile users have different priorities (browse, search, notifications, profile, more).

## Hamburger Menu

The ☰ icon hiding the navigation behind a tap.

**Reality check:** hamburger menus reduce discoverability. Users explore less when nav is hidden. Studies have shown 1.5–2× less engagement with hidden vs. visible navigation.

**When acceptable:**
- Mobile, where space is genuinely scarce
- Secondary or tertiary navigation that doesn't need to be discoverable

**When questionable:**
- Desktop, where visible nav fits — hiding it just makes users hunt
- Mobile when bottom nav would serve the primary actions better

If using hamburger, animate the icon (lines transform into ✕ when open). Make the whole menu region tappable, not just the icon.

## Breadcrumbs

Show the user's location in a hierarchy.

**When to use:** deep sites — e-commerce, documentation, knowledge bases, file systems. Sites with shallow hierarchies don't need them.

**Rules:**
- Use `>` or `/` as separators (`Home > Electronics > Laptops > MacBook Pro`)
- The current page is **not a link** (it's where you are)
- Each level above is clickable
- Don't replace primary navigation — supplement it

Tailwind: `<nav aria-label="Breadcrumb">` with semantic markup so screen readers announce it as breadcrumbs.

## Mega Menus

Large dropdown panels showing multiple columns of links, often with imagery.

**When to use:** sites with extensive categorization — e-commerce with many product categories, news sites, large enterprise sites.

**Rules:**
- Top-level item itself should be clickable (lands on a category overview page) — don't make hovering the *only* way to access content
- Open on hover with a delay (~200ms), close on mouse-leave with another delay (~300ms) to forgive accidental cursor exits
- Provide a way to open via keyboard and tap (focus + Enter, or click)
- Group columns with headers; don't dump 40 unsorted links in a panel
- Close on Escape

## Search

For content-heavy sites, search must be visible and usable.

- **Visible input** — full-width search bar in the header is best for content/e-commerce
- **Search icon expanding to input** — acceptable compromise when nav real estate is tight
- **Buried in a menu** — bad. If users need to hunt for search, you've lost them.

For app search, consider command-K (Ctrl/Cmd+K) modal search — Linear, Notion, GitHub all use this pattern. Always keep a visible icon trigger so non-power users can find it.

## Navigation Principles

- **Current location must be obvious.** Active state on the nav item. Breadcrumbs showing hierarchy. Page title matching the nav label.
- **Consistent across pages.** Nav structure is the same on every page. Moving items around or changing labels is disorienting.
- **Label with the user's language.** "Pricing" not "Plans and Billing." "Help" not "Knowledge Center." Match what users actually say.
- **Don't overload (Hick's Law).** More options = more decision time. 5–7 top-level items is the sweet spot. If you have more, group them.
- **Consistent placement of CTAs.** "Sign in" and "Get started" should always be in the same place (typically far right of the top nav).

## Footer Navigation

Footers are the secondary nav layer — sitemap, legal, social, contact.

**Standard footer columns:**
- Product (features, pricing, integrations, changelog)
- Resources (docs, blog, guides, help)
- Company (about, careers, contact, press)
- Legal (privacy, terms, security, accessibility)
- Social icons + newsletter signup

Don't bury critical pages (login, signup, support) in the footer alone — they should be in primary nav.

## Quick Navigation Audit

- [ ] Can a first-time visitor find the primary action in 3 seconds?
- [ ] Does the active state make it obvious where I am?
- [ ] Is search visible (or one obvious tap away)?
- [ ] On mobile, does the primary action sit within thumb reach?
- [ ] Do hover-only menus also work via tap and keyboard?
- [ ] Are nav labels in user language?
- [ ] Is there a max of 5 items in mobile bottom nav?
