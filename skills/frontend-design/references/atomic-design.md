# Atomic Design

When to reference: building a component library, organizing a design system, deciding what should be a component vs. a one-off, or refactoring scattered UI into reusable parts.

Brad Frost's Atomic Design (2013) gives a mental model for **building component systems from the smallest pieces up**. Pairs with `design-tokens.md` (the values) to form a complete design system foundation.

## The Five Levels

### Atoms

The smallest, indivisible UI elements. Can't be broken down without losing meaning.

**Examples:** Button, Input, Label, Heading, Icon, Badge, Avatar, color swatch, single token.

```tsx
<Button>Save</Button>
<Input placeholder="name@example.com" />
<Label>Email address</Label>
```

Atoms are highly reusable. They have minimal logic — they receive props and render. They don't fetch data or know about the rest of the app.

### Molecules

Groups of atoms functioning together as a unit.

**Examples:** Form field (label + input + error message), search bar (input + button + icon), navigation link (icon + text), card header (avatar + name + timestamp).

```tsx
<FormField>
  <Label>Email</Label>
  <Input type="email" />
  <ErrorMessage>Required</ErrorMessage>
</FormField>
```

A molecule does one job. If you find a "molecule" doing several different things, it's probably an organism.

### Organisms

Groups of molecules forming a distinct section of an interface.

**Examples:** Header (logo molecule + nav molecule + search molecule), product card (image + title + price + button), comment section, pricing table, dashboard widget.

```tsx
<SiteHeader>
  <Logo />
  <PrimaryNav />
  <SearchBar />
  <UserMenu />
</SiteHeader>
```

Organisms are where most "I'm building a component" effort lives. They are reusable but more contextual than molecules — usually, you have one or two of each on a page.

### Templates

Page-level layouts composed of organisms, with placeholder content. Define the **structure** of a page type.

**Examples:** Article template (header + sidebar + article body + footer), dashboard template (header + sidebar + main content grid), checkout template (steps + form + summary).

Templates show how organisms are arranged in a layout grid — but with generic content. They answer "how is this kind of page structured?"

### Pages

Templates with **real content** applied. This is where you validate that the design actually works with real data.

**Examples:** the live homepage, a specific blog post, the actual settings page for the current user.

Pages reveal where templates break: long names, missing images, edge-case empty states, oddly long lists. **Always design pages with real-ish content** — not just lorem ipsum — to catch where the abstraction fails.

## Why This Helps

- **Reusability** — atoms compose into molecules into organisms; you don't redesign a button per page.
- **Consistency** — change the button atom, every molecule and organism using it updates.
- **Predictability** — a designer or engineer knows where a "field" lives in the system without searching.
- **Communication** — shared vocabulary between design and engineering ("this is a card organism with a media molecule").
- **Scaling** — large design systems stay coherent because the building blocks are small and well-defined.

## Folder / Component Organization

A common code structure based on atomic design:

```
components/
├── atoms/         # Button, Input, Label, Icon, Badge
├── molecules/     # FormField, SearchBar, NavLink, MediaCard
├── organisms/     # Header, ProductCard, CommentSection, PricingTable
├── templates/     # ArticleLayout, DashboardLayout, CheckoutLayout
└── pages/         # (often live in app/ or pages/ folders directly)
```

In Next.js App Router, "pages" and "templates" map to `app/<route>/page.tsx` and shared `layout.tsx`. The atomic naming applies to the `components/` directory.

Some teams use slightly different names: "primitives" for atoms, "patterns" for molecules+organisms. Stay consistent within your project.

## When Atomic Design Doesn't Fit Cleanly

It's a model, not a law. Common adaptations:

- **Skip "templates" if you use a meta-framework** that handles layout (Next.js layout files do this).
- **Atoms vs. molecules can blur** — a labeled input could be either. Don't agonize; pick a rule and stick with it.
- **Some "organisms" are page-specific** and not reused. That's fine — they still benefit from being a named component, even if used once.
- **Don't force atomic naming** if the team finds it pretentious. The structure matters; the labels are negotiable.

## Anti-Patterns

- **God components** — a single component doing the work of an organism, with hundreds of lines and many concerns. Split into atoms + molecules.
- **Tightly coupled atoms** — a Button that imports the Theme provider context directly, can't be reused elsewhere. Atoms should take props, not reach.
- **Inconsistent naming** — `Button.tsx` in atoms, `Btn.tsx` in molecules. Pick one.
- **One-off components everywhere** — a new "Button" on every page because nobody checks the library. Make the library findable, document each component, and reject duplicates in code review.
- **Atoms with business logic** — a Button atom that knows about your auth system. Atoms should be context-free.

## Pairing with Design Tokens

Atomic design gives you the **structural** vocabulary; design tokens (`design-tokens.md`) give you the **value** vocabulary:

- Atoms reference **component tokens** (`button-bg-primary`, `input-border-default`)
- Component tokens reference **semantic tokens** (`color-interactive`)
- Semantic tokens reference **primitive tokens** (`color-blue-500`)

Together they make a design system that can theme, scale, and refactor without breaking.

## Quick Audit

For an existing component library, ask:
- [ ] Are atoms genuinely reusable (no business logic, no specific context)?
- [ ] Do molecules combine atoms or are they re-implementing them?
- [ ] Do organisms compose molecules or duplicate their styles?
- [ ] Are there hundreds of one-off components that should have been variants of an atom?
- [ ] Is there a single source of truth for each named component?
- [ ] Are tokens used end-to-end, or do components hardcode values?
