# Typography

When to reference: choosing fonts, setting up type scales, improving text readability.

## Font Categories & When to Use

**Serif** (Times New Roman, Georgia, Playfair Display) — classic, formal, authoritative. Use for law firms, financial services, editorial content, luxury brands. Strong for headings paired with sans-serif body.

**Sans-Serif** (Inter, Roboto, Helvetica, Open Sans) — modern, clean, neutral. Default choice for web interfaces, SaaS, tech brands. Best readability on screens at all sizes.

**Monospace** (JetBrains Mono, Fira Code, IBM Plex Mono) — technical, precise. Use for code blocks, terminal UIs, developer tools. Can work as a design accent in tech-forward brands.

**Display** (Bebas Neue, Impact, Anton) — bold, attention-grabbing. Headlines and banners only — never body text. Large sizes where visual impact matters.

**Script** (Dancing Script, Pacifico) — elegant, decorative. Sparingly for logos, invitations, luxury headings. Avoid for body text — poor readability at small sizes.

**Handwritten** (Caveat, Patrick Hand) — casual, personal, authentic. Social media, lifestyle blogs, creative projects. Use for personality, not professionalism.

## Font Pairing Rules

Stick to **2 fonts maximum** (one heading, one body). Three is the hard ceiling.

**Proven pairings**:
- Serif heading + Sans-serif body (Playfair Display + Inter)
- Sans-serif heading + Sans-serif body, different weights (Inter Bold + Inter Regular)
- Monospace heading + Sans-serif body (JetBrains Mono + Inter) — dev/tech aesthetic

**What contrasts well**: serif with sans-serif, geometric with humanist, heavy with light. What clashes: two serifs, two decorative fonts, fonts with similar x-heights and weights.

## Type Scale & Hierarchy

Use a **consistent ratio** between sizes. Common ratios:
- **1.25 (Major Third)**: subtle, compact — dashboards, dense UIs
- **1.333 (Perfect Fourth)**: balanced — most web apps
- **1.5 (Perfect Fifth)**: dramatic — landing pages, editorial

Example scale (base 16px, ratio 1.333):
- `text-xs`: 12px — captions, labels
- `text-sm`: 14px — secondary text, metadata
- `text-base`: 16px — body text
- `text-lg`: 18px — lead paragraphs
- `text-xl`: 21px — H4
- `text-2xl`: 28px — H3
- `text-3xl`: 38px — H2
- `text-4xl`: 50px — H1, hero headlines

**Weight hierarchy**: bold/semibold for headings, regular for body, light/medium for secondary. Don't use more than 3 weights.

## Readability

**Font size**: 16-18px minimum for body text on web. 14px only for secondary/metadata text.

**Line height**: 1.5 for body text (`leading-relaxed`), 1.2-1.3 for headings (`leading-tight`). Tighter for large text, looser for small text.

**Line length**: 50-75 characters per line including spaces. Tailwind: `max-w-prose` (65ch). Too long = eyes lose tracking. Too short = breaks reading flow.

**Letter spacing**: default for body. Slightly increased tracking (`tracking-wide`) for uppercase text, small caps, or labels. Fine-tune kerning for logos and headlines.

## Alignment

**Left-aligned**: default for body text in LTR languages. Easiest to read.
**Center-aligned**: headlines, logos, short CTAs. Never for paragraphs — ragged edges on both sides destroy readability.
**Right-aligned**: labels in forms, metadata, prices. Situational.
**Justified**: clean edges but uneven word spacing. Avoid on web unless combined with hyphenation.

Rule: don't mix alignments on the same page unless serving a clear purpose.

## Responsive Typography

Use relative units (`rem`, `em`) not fixed `px` for scalability. Tailwind handles this — use the built-in scale.

For hero text that needs to scale dramatically: `text-3xl md:text-5xl lg:text-7xl`. Heading sizes should reduce on mobile but body text stays at 16px+.

## Web Font Performance

- Load only the weights you use (typically 400 + 600 or 700)
- Use `font-display: swap` to prevent invisible text during load
- Prefer variable fonts when available — one file, all weights
- Google Fonts and Adobe Fonts are optimized for web. Self-host for privacy or performance control.
- Every additional font adds ~20-50KB. Two fonts with two weights each = 4 files = ~100-200KB.

## Accessibility

- Never convey meaning through font style alone (italic, color) — add icons or labels
- Minimum contrast: 4.5:1 for body text, 3:1 for large text (WCAG AA)
- Don't disable zoom — users with vision impairments need to scale text
- Avoid all-caps for long text — harder to read for users with dyslexia
