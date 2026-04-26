# Design Tokens & Systematic Design

When to reference: setting up a design system, theming (light/dark/multi-brand), planning a component library, or auditing inconsistency in a codebase.

## What Tokens Are

Design tokens are the **named, platform-agnostic constants** that store design decisions: colors, spacing, type, radius, shadow, motion duration, breakpoints. Instead of hardcoding `#0052CC` or `16px`, you assign it a name (`color-brand-primary`, `spacing-md`).

The W3C Design Tokens Community Group published the first stable spec (v2025.10) in October 2025, establishing a vendor-neutral JSON format for interoperability between Figma, Penpot, and code.

## Three-Layer Token Architecture

### Layer 1: Primitive tokens (global)

The raw palette. Every possible value, named descriptively — never used directly by components.

```
color-blue-500: #0052CC
color-blue-600: #0747A6
color-gray-100: #F4F5F7
color-gray-900: #1A1A1A
spacing-4: 4px
spacing-8: 8px
spacing-16: 16px
font-size-14: 14px
radius-sm: 4px
radius-md: 8px
shadow-sm: 0 1px 2px rgba(0,0,0,0.05)
```

### Layer 2: Semantic tokens (alias)

Map primitives to **purpose**. Components reference these — never primitives directly.

```
color-brand-primary: {color-blue-500}
color-bg-surface: {color-gray-100}
color-text-default: {color-gray-900}
color-text-muted: {color-gray-600}
color-border-default: {color-gray-300}
color-feedback-success: {color-green-600}
color-feedback-error: {color-red-600}
spacing-inline-sm: {spacing-4}
spacing-stack-lg: {spacing-24}
```

### Layer 3: Component tokens (scoped)

Per-component values that reference semantic tokens.

```
button-bg-primary: {color-brand-primary}
button-bg-primary-hover: {color-blue-600}
button-padding-x: {spacing-16}
button-padding-y: {spacing-8}
button-radius: {radius-md}
card-bg: {color-bg-surface}
card-shadow: {shadow-sm}
```

## Why This Architecture

**Theming.** Switch light → dark or Brand A → Brand B by redefining only the **semantic** layer. Components don't change.

```css
:root {
  --color-bg-surface: #FFFFFF;
  --color-text-default: #1A1A1A;
}
[data-theme="dark"] {
  --color-bg-surface: #1A1A2E;
  --color-text-default: #E8E8E8;
}
```

**Consistency.** Brand color changes? Update one token, propagates everywhere. No hex hunting.

**Communication.** "Use `color-brand-primary`" is unambiguous. "Use that blue" is not. Tokens give designers and engineers a shared vocabulary.

## CSS Custom Properties as the Implementation

```css
:root {
  /* Primitives */
  --color-blue-500: #0052CC;
  --color-blue-600: #0747A6;

  /* Semantic */
  --color-interactive: var(--color-blue-500);
  --color-interactive-hover: var(--color-blue-600);

  /* Component */
  --btn-bg: var(--color-interactive);
  --btn-bg-hover: var(--color-interactive-hover);
  --btn-radius: 6px;
  --btn-padding: 0.5rem 1rem;
}

.button-primary {
  background: var(--btn-bg);
  border-radius: var(--btn-radius);
  padding: var(--btn-padding);
  transition: background 0.15s ease-out;
}
.button-primary:hover { background: var(--btn-bg-hover); }
```

## Tokens with Tailwind

Define primitives + semantics in `tailwind.config.ts`:

```ts
// tailwind.config.ts
export default {
  theme: {
    extend: {
      colors: {
        // Primitives
        blue: { 500: '#0052CC', 600: '#0747A6' },
        // Semantic
        interactive: { DEFAULT: 'var(--color-interactive)', hover: 'var(--color-interactive-hover)' },
        surface: 'var(--color-bg-surface)',
        text: { DEFAULT: 'var(--color-text-default)', muted: 'var(--color-text-muted)' },
      },
      spacing: { /* scale */ },
      borderRadius: { sm: '4px', md: '8px' },
    },
  },
};
```

Components use semantic class names: `bg-interactive hover:bg-interactive-hover text-text-default`. Theme switching via `[data-theme="dark"]` rewrites the CSS variables — no Tailwind dark: modifiers needed.

## Design System Maturity Ladder

| Level | What you have |
|---|---|
| **1. Style guide** | Documented colors, fonts, spacing. Manually referenced. |
| **2. Component library** | Reusable components in code (npm package or workspace). |
| **3. Design system** | Component library + tokens + docs + usage guidelines + governance. |
| **4. Design platform** | Tooling integration: visual regression tests, design-to-code pipelines, token sync between Figma and code. |

Each level requires the previous. Don't try to skip — Level 4 without Level 1's discipline is brittle automation around inconsistency.

## What a Mature Design System Contains

- **Tokens** (primitives + semantic + component)
- **Component library** with documented props, states, variants
- **Pattern library** — how components combine (search + filter + results, form + validation + submit)
- **Content guidelines** — voice, tone, terminology
- **Accessibility guidelines** — per-component ARIA + keyboard behavior
- **Contribution process** — how to propose / review / add components
- **Migration guides** — how to upgrade off deprecated patterns

## Anti-Patterns

- **Hardcoded values in components** — `#0052CC` in a Button file. Use tokens.
- **Skipping the semantic layer** — components referencing primitives directly. You can't theme.
- **Token sprawl** — 47 grays in your palette. Fewer named values, used consistently, beats more values used carelessly.
- **Naming by appearance, not purpose** — `--color-blue-button` ages badly. `--color-interactive` survives a brand refresh.
- **Tokens that only designers know** — must live in code, in docs, and in the design tool. Otherwise drift is guaranteed.
