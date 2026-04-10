# Layout Principles

When to reference: structuring page layouts, positioning elements, establishing visual flow.

## Alignment & Grids

**Grid system** — the backbone of every layout. Use a consistent grid and align all elements to it. Tailwind: `grid grid-cols-12 gap-6` for full layouts, `grid-cols-1 md:grid-cols-2 lg:grid-cols-3` for content grids.

**Text alignment**: left-align body text (most readable in LTR). Center-align headlines, logos, and short CTAs sparingly. Never center paragraphs — ragged edges on both sides kill readability. Never justify on web without hyphenation support.

**Stick to one alignment** per section. Mixing left and center-aligned text on the same page looks accidental unless serving a clear design purpose.

**Optical vs. mathematical alignment**: strict grid alignment is the default, but icons and certain shapes may need visual nudging. A play button triangle centered mathematically looks off-center — shift it right by ~2px. Trust your eyes for final polish.

## Positioning for Flow

Users scan in predictable patterns:
- **F-pattern**: text-heavy pages (blogs, articles). Scan top line → down left side → occasional horizontal scans. Place key content top-left.
- **Z-pattern**: minimal content pages (landing pages, marketing). Scan top-left → top-right → diagonal down → bottom-left → bottom-right. Place CTA at bottom-right.

Position critical elements — headlines, CTAs, key visuals — at scan intersections. Don't bury important content below the fold without visual cues to scroll.

## Proximity & Grouping

**Gestalt principle of proximity**: elements close together are perceived as related. Use this intentionally:
- Tighter spacing within a group (`gap-2`, `gap-3`)
- Wider spacing between groups (`gap-8`, `gap-12`, `mt-16`)
- A label directly above an input (4-8px gap) reads as connected. A label 24px away reads as separate.

**Visual grouping cues**: cards (`rounded-lg border shadow-sm`), background color changes, divider lines, and shared borders all reinforce grouping. Use the lightest touch that works — don't stack multiple cues.

**White space for separation**: unrelated sections need breathing room. Sections separated by `py-16 md:py-24` feel intentionally distinct. Sections separated by `py-4` feel cramped and related.

**Consistent spacing**: use the same gap between similar elements throughout. If cards have `gap-6` in one section, they should everywhere. Inconsistent spacing looks accidental.

## Balance & Symmetry

**Symmetrical balance**: mirror elements across a central axis. Creates stability, order, calm. Best for: corporate, formal, institutional designs. Tailwind: centered containers, equal-column grids.

**Asymmetrical balance**: different elements arranged to feel balanced without mirroring. Creates energy, dynamism, interest. Best for: creative, modern, editorial designs. Use a large element on one side balanced by several smaller ones on the other.

**Radial balance**: elements radiate from a center point. Best for: infographics, circular navigation, hero sections with a central focal point.

**Visual weight**: larger, darker, more saturated elements are "heavier." A large image on the left balanced by a text block + CTA on the right. A bold heading balanced by lighter body text below it.

**Tips**:
- Anchor the layout with one dominant element (hero image, large heading) and balance smaller elements around it
- Use whitespace to counterbalance dense content areas
- Step back and squint — if the layout feels heavy on one side, rebalance

## Repetition & Consistency

Repeat visual patterns across the entire site:
- Same button styles, same card patterns, same spacing rhythm
- Same hover effects, focus rings, and interaction patterns on every page
- Same header, footer, navigation structure throughout

**Why**: repetition builds familiarity, reduces cognitive load, and makes the site feel cohesive. Inconsistency (different button styles on different pages, changing spacing) reads as unfinished.

**Style guide approach**: define reusable components for buttons, cards, forms, navigation, typography. Use them everywhere. When a new pattern is needed, add it to the system — don't create one-offs.

## Responsive Layout Patterns

**Stack → side-by-side**: `flex flex-col md:flex-row` — mobile stacks vertically, desktop goes horizontal. The most common responsive pattern.

**Grid reduction**: `grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4` — fewer columns on smaller screens.

**Sidebar collapse**: sidebar visible on desktop, hamburger menu or bottom drawer on mobile. Don't hide critical navigation.

**Content reflow**: hero with side-by-side text + image on desktop becomes stacked on mobile. Image above text (visual first).

**Touch targets**: minimum 44x44px for all interactive elements on mobile. Spacing between tap targets: minimum 8px to prevent mis-taps.

## Whitespace as Design

Whitespace isn't empty — it's a design element. Generous spacing:
- Communicates premium quality (compare luxury brand sites to discount stores)
- Improves readability by reducing visual noise
- Directs attention to the content that matters
- Creates breathing room that makes dense information digestible

**Section spacing**: `py-16 md:py-24` between major sections. `py-8 md:py-12` between subsections.
**Component spacing**: `p-6` inside cards, `gap-6` between cards, `gap-4` between form fields.
**Text spacing**: `space-y-4` between paragraphs, `mb-2` between label and input, `mb-8` between sections.

Under-spacing is the most common amateur mistake. When in doubt, add more space.
