# Design Laws & Ratios

When to reference: making layout decisions, sizing interactive elements, or applying mathematical proportion to design.

## Golden Ratio (1.618)

A mathematical proportion found throughout nature and classical art. The ratio of the larger segment to the smaller equals the ratio of the whole to the larger (approximately 1.618:1).

**Applications in web design**:
- **Layout proportions**: sidebar 38.2% + main content 61.8% of the viewport
- **Typography scale**: next heading size = current size × 1.618 (16px → 26px → 42px → 68px)
- **Spacing rhythm**: padding ratios that follow 1:1.618 feel naturally balanced
- **Image cropping**: golden rectangle proportions for hero images and cards
- **Logo design**: proportions based on golden spirals and rectangles

**CSS implementation**: `grid-template-columns: 1fr 1.618fr` for golden-ratio two-column layouts. For spacing: if base padding is 16px, generous padding is 26px (16 × 1.618).

**When NOT to use**: not everything needs the golden ratio. It's a tool, not a religion. Consistent spacing scales (4/8/16/32) are more practical for UI components. Reserve golden ratio for proportional decisions like layout splits and hero sections.

## Rule of Thirds

Divide the canvas into a 3×3 grid. Place key elements at the intersections or along the lines.

**Web application**: hero images with subject at a third intersection. Headlines positioned at the upper third. CTAs at bottom-right intersection. Works especially well for landing pages and image-heavy layouts.

**Tailwind**: `grid grid-cols-3 grid-rows-3` for explicit rule-of-thirds placement. More commonly applied as a mental model rather than literal grid.

## Gestalt Principles

How humans perceive visual groups and patterns:

**Proximity** — elements near each other are perceived as related. Spacing between items within a group should be smaller than spacing between groups. This is the single most important grouping principle in UI.

**Similarity** — elements that look similar (same color, shape, size) are perceived as a group. Use consistent styling for related actions (all primary buttons look the same). Break similarity intentionally to draw attention.

**Closure** — the brain completes incomplete shapes. Progress bars, loading indicators, and partial circles work because of closure. Also why icon design with gaps still reads as complete shapes.

**Continuity** — elements aligned along a line or curve are perceived as continuing in that direction. Use alignment and visual lines to guide the eye through content. Breadcrumbs, progress steps, and timelines leverage continuity.

**Figure/Ground** — the brain separates foreground from background. Cards floating on a page, modals over dimmed backgrounds, text over images with overlays. Ensure sufficient contrast between figure and ground — ambiguity creates confusion.

**Common region** — elements within a shared boundary are perceived as grouped. Cards, bordered sections, and colored backgrounds create regions. More explicit than proximity alone.

## Fitts's Law

**Time to reach a target = f(distance, size).** Larger targets closer to the cursor/finger are faster to interact with.

**Applications**:
- Primary CTAs should be large and prominently positioned — not tiny links in corners
- Navigation items in corners and edges of the screen are fast to hit (infinite edge on desktop)
- Mobile: bottom navigation is faster than top (thumb zone). FABs in the bottom-right are in the natural thumb arc
- Spacing between destructive actions (Delete) and common actions (Save) — don't put them adjacent
- Form submit buttons should be full-width on mobile for maximum touch target

**Minimum touch targets**: 44×44px (Apple HIG), 48×48dp (Material). With at least 8px spacing between targets.

## Hick's Law

**Decision time increases logarithmically with the number of choices.**

**Applications**:
- Navigation: 5-7 top-level items maximum. More? Use dropdowns or categorize
- Settings: progressive disclosure — show basic options first, advanced behind a toggle
- Forms: break long forms into steps (wizard pattern) rather than one overwhelming page
- CTAs: one primary action per screen. Multiple equal-weight buttons = decision paralysis
- Menus: categorize and group options rather than presenting a flat list

**The takeaway**: reduce choices at each decision point. Guide the user toward the one thing you want them to do.

## Miller's Law

**Working memory holds ~7 (±2) items at once.** Chunk information into groups of 5-9.

**Applications**: navigation groups of 5-7 items, phone numbers grouped as 3-3-4, credit card numbers as 4-4-4-4, list items grouped into categories of ~5.

## Jakob's Law

**Users spend most of their time on OTHER sites.** They expect your site to work like the ones they already know.

**Applications**: don't reinvent standard UI patterns. Shopping carts in the top-right. Logo links home. Underlined text is clickable. Search bars are at the top. Innovation should happen in content and value — not in basic navigation patterns.

## Doherty Threshold

**Productivity soars when response time is under 400ms.** Users perceive anything under 100ms as instant.

**Applications**: UI transitions should be 150-300ms. Show loading states immediately for anything >100ms. Use skeleton screens instead of spinners for content loading. Optimistic UI updates (show the result before the server confirms) for common actions.

## Pareto Principle (80/20)

**80% of effects come from 20% of causes.** In design: 80% of user activity happens with 20% of features.

**Applications**: identify the core flows (the 20%) and optimize them relentlessly. Don't give equal visual weight to rarely-used features. Analytics-driven design — track what users actually click, then prioritize accordingly.
