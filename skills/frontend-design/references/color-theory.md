# Color Theory & Palettes

When to reference: choosing a color palette, establishing brand colors, or applying color to a design.

## The 60-30-10 Rule

The foundation of every color scheme:
- **60% dominant** — background, large surfaces (typically neutral: white, gray, dark)
- **30% secondary** — supporting elements: cards, sidebars, headers
- **10% accent** — CTAs, links, highlights, badges, alerts

This creates visual balance and prevents color overload. Start here for every project.

## Color Psychology

**Red**: passion, urgency, danger, energy. Use for action buttons, alerts, sales/promotions. High attention but fatiguing in large areas.

**Blue**: trust, calm, professionalism, stability. Corporate, healthcare, tech, finance. The safest "default" brand color — overused but reliable.

**Yellow**: optimism, energy, warmth, caution. Attention-grabbing for CTAs and highlights. Hard to read as text — use for accents only.

**Green**: nature, health, growth, success. Environmental, finance, wellness brands. Universal semantic: success states, confirmations.

**Orange**: enthusiasm, creativity, excitement, warmth. Promotions, entertainment, food brands. Energetic without the aggression of red.

**Purple**: luxury, creativity, mystery, spirituality. Premium brands, creative industries, beauty. Feels expensive when paired with dark backgrounds.

**Black**: power, elegance, sophistication. Luxury, fashion, modern tech. Use as primary for premium feel with minimal accent colors.

**White**: purity, simplicity, cleanliness. Minimalist design, healthcare, modern tech. Essential for whitespace — not a passive choice.

**Gray**: neutrality, professionalism, balance. Backgrounds, borders, secondary text. The workhorse of any palette — use multiple shades.

**Pink**: warmth, compassion, playfulness. Beauty, wellness, youth-oriented brands. Modern usage is gender-neutral when paired with bold design.

**Brown**: earthiness, reliability, warmth. Outdoor brands, food, organic/natural products. Underused — distinctive when done well.

## Palette Types

**Monochromatic** — one hue, multiple shades/tints. Clean, cohesive, safe. Best for: dashboards, portfolios, documentation. Use 1 base + 3-4 tints/shades.

**Analogous** — adjacent colors on the wheel (blue + teal + green). Harmonious, natural. Best for: wellness, nature, calming interfaces. Use 3-4 colors.

**Complementary** — opposite colors (blue + orange, purple + yellow). High contrast, energetic. Best for: CTAs that pop, marketing pages. Use 2 colors + 1 neutral.

**Triadic** — three equally spaced (red + blue + yellow). Vibrant, playful. Best for: children's brands, entertainment, creative apps. Use 1 dominant + 2 accents.

**Split-complementary** — one base + two colors adjacent to its complement. Contrast with less tension than full complementary. Versatile and balanced.

**Tetradic** — two complementary pairs. Complex but rich when balanced carefully. Best for: fashion, editorial, complex branding. Hard to balance — let one pair dominate.

**Neutral + accent** — grays/blacks/whites with one bold accent color. Professional, elegant, focused. Best for: corporate, luxury, SaaS tools.

## Building a Palette in Practice

1. **Pick one primary color** based on brand personality
2. **Choose 2-3 neutral grays** for backgrounds, borders, text (light, medium, dark)
3. **Add 1-2 secondary colors** — either analogous for harmony or complementary for energy
4. **Define semantic colors** — success (green), error (red), warning (amber), info (blue). Don't override these conventions.
5. **Generate shades** — 50 through 950 for each color (Tailwind convention). Use 100-200 for backgrounds, 500-600 for default, 700-900 for dark/hover.

## Contrast & Accessibility

**WCAG AA minimums**:
- Normal text: 4.5:1 contrast ratio against background
- Large text (18px+ bold or 24px+ regular): 3:1
- UI components and icons: 3:1

**Common violations**: light gray text on white (`text-gray-400` on `bg-white` = ~2.5:1 — fails). Use `text-gray-600` minimum on white backgrounds.

**Dark mode**: reduce saturation of accent colors — vivid hues vibrate against dark backgrounds. Use `gray-100`/`gray-300` for text, not pure white.

**Never rely on color alone** to convey meaning. Always pair with icons, labels, or patterns (colorblind users: ~8% of males).

## Tailwind Color Implementation

- Define brand colors in `tailwind.config.js`, don't use arbitrary hex values
- Use the full shade scale: `primary-50` through `primary-950`
- `bg-primary-500 hover:bg-primary-600 active:bg-primary-700` for interactive states
- Use CSS variables for theming: `--color-primary: 59 130 246` enables opacity modifiers
- Dark mode: `dark:bg-gray-900 dark:text-gray-100` — define the full dark palette upfront
