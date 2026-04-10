---
name: frontend-design
description: Create production-grade, distinctive frontend interfaces with strong UI/UX principles. Use when building web components, pages, layouts, or applications. Also use when the user says "build a UI", "design this page", "make it look good", "style this", "CSS help", "Tailwind", "responsive design", or when working on any user-facing interface.
last_verified: 2026-04-04
---

# Frontend Design

Build distinctive, polished interfaces that avoid generic AI aesthetics. Focus on hierarchy, whitespace, typography, and intentional design decisions.

## Process

### 1. Understand the Context
- What is the user building? (dashboard, form, landing page, app shell, component)
- What's the existing design system? (Tailwind config, CSS variables, component library)
- What's the target: desktop, mobile, or responsive?

### 2. Establish Design Foundation
Before writing any CSS/markup, define:
- **Visual hierarchy** — what does the user see first, second, third?
- **Spacing system** — consistent whitespace rhythm (4px/8px grid)
- **Color palette** — primary, secondary, neutral, accent, semantic (success/error/warning)
- **Typography scale** — heading sizes, body text, captions with consistent ratio

### 3. Build with Intention
Read `references/design-principles.md` for detailed guidance on each principle. Apply:
- Layout structure first (grid/flex), then content, then polish
- Mobile-first responsive design
- Semantic HTML before adding styling
- Component boundaries that map to visual sections

### 4. Review with Design Agent
Dispatch the `uiux-designer` subagent to create design systems, or use its output as the foundation for frontend engineering.

## What NOT to Do

- Do not use default/generic styling — every element should have intentional spacing, color, and typography
- Do not center everything — use alignment that creates visual flow and hierarchy
- Do not use too many colors — stick to a defined palette
- Do not skip whitespace — cramped UI feels cheap; generous spacing feels professional
- Do not ignore mobile — build responsive from the start
- Do not use arbitrary values in Tailwind — use the spacing/color scale consistently
- Do not add decoration without purpose — every visual element should serve hierarchy or usability

## Reference Files

Read the relevant references before any UI work:

- `references/design-principles.md` — Core principles summary: hierarchy, whitespace, responsive, components, accessibility
- `references/design-styles.md` — Visual aesthetics: minimalist, glassmorphism, neumorphism, claymorphism, brutalism, material, corporate, dark mode
- `references/typography.md` — Font families, pairing rules, type scales, readability, line height, responsive typography
- `references/color-theory.md` — Color psychology, palette types (mono/analogous/complementary/triadic), 60-30-10 rule, contrast, accessibility
- `references/layout-principles.md` — Alignment, grids, proximity, balance, symmetry, repetition, whitespace, responsive patterns
- `references/design-laws.md` — Golden ratio, rule of thirds, Gestalt principles, Fitts's law, Hick's law, Miller's law, Jakob's law

**Subagent:** `uiux-designer` — creates design systems, color palettes, typography, component specs. Located at `~/.claude/agents/uiux-designer.md`.
