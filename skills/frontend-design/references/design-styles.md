# Design Styles & Aesthetics

When to reference: choosing a visual direction for a project, or when the user asks for a specific aesthetic.

## Minimalist
Clean, simple, content-focused. Heavy whitespace, limited color palette (2-3 colors), sans-serif typography, flat design with no gradients or shadows.
- **When**: SaaS dashboards, portfolios, documentation sites, developer tools
- **Tailwind**: `bg-white text-gray-900`, generous `p-8 md:p-16`, `max-w-3xl mx-auto`
- **Key**: every element must earn its place — if it doesn't serve hierarchy or function, remove it

## Glassmorphism
Frosted glass effect with transparency, blur, and subtle borders. Layers content over vibrant backgrounds.
- **When**: Modern apps, music players, dashboard overlays, hero sections
- **CSS**: `backdrop-filter: blur(12px)`, semi-transparent backgrounds `bg-white/20`, subtle `border border-white/30`
- **Tailwind**: `bg-white/10 backdrop-blur-lg border border-white/20 rounded-2xl shadow-xl`
- **Tips**: needs a colorful or gradient background behind it to be effective. Ensure text contrast — white text on frosted panels needs enough opacity. Don't overuse — 1-2 glass panels per viewport.

## Neumorphism (Soft UI)
Soft, extruded elements that appear to push out of or sink into the background. Uses subtle shadows on matching background colors.
- **When**: Calculator UIs, settings panels, IoT dashboards, music controls
- **CSS**: dual box-shadow — one light, one dark — on a matching background color
- **Tailwind**: custom shadows in config: `shadow-[8px_8px_16px_#d1d1d1,-8px_-8px_16px_#ffffff]` on `bg-gray-200`
- **Pitfalls**: poor accessibility — low contrast between elements and background. Always add focus rings and clear interactive states. Not suitable for text-heavy interfaces.

## Claymorphism
3D clay/plasticine aesthetic with rounded shapes, inner shadows, and pastel backgrounds. Playful and tactile.
- **When**: Children's products, creative apps, onboarding flows, marketing landing pages
- **CSS**: `border-radius: 24px+`, inner shadow + outer shadow, pastel color palette
- **Tailwind**: `rounded-3xl bg-gradient-to-br from-pink-200 to-purple-200 shadow-xl` + custom inner shadow
- **Tips**: works best with illustration, not photography. Keep text simple and large.

## Brutalism
Raw, unpolished, anti-design aesthetic. Bold typography, harsh borders, stark colors, intentional "broken" layouts.
- **When**: Creative portfolios, art galleries, counter-culture brands, experimental sites
- **CSS**: thick `border-4 border-black`, monospace fonts, no border-radius, bright clashing colors
- **Tailwind**: `border-4 border-black font-mono bg-yellow-300 text-black uppercase tracking-widest`
- **Tips**: looks intentional only when every "rough" choice is deliberate. Random roughness looks like bugs.

## Material Design
Google's design language — elevation via shadows, bold colors, ripple animations, card-based layouts.
- **When**: Android-adjacent apps, productivity tools, admin panels
- **Key elements**: consistent shadow scale (elevation 1-5), 8dp grid, FAB buttons, drawer navigation
- **Tailwind**: `shadow-sm` through `shadow-2xl` for elevation, `rounded-lg`, `transition-shadow hover:shadow-lg`

## Corporate / Enterprise
Professional, trustworthy, information-dense. Navy/gray palettes, data tables, sidebar navigation.
- **When**: B2B SaaS, financial dashboards, healthcare portals, admin systems
- **Key**: readability over flash. High information density but clear grouping. Consistent iconography.
- **Tailwind**: `bg-slate-50 text-slate-800`, compact spacing `p-3 gap-2`, clear borders and dividers

## Dark Mode Design
Not just inverting colors — requires its own design decisions.
- **Background**: never pure black (`#000`). Use `gray-900` or `gray-950` for main, `gray-800` for elevated surfaces
- **Text**: never pure white for body. Use `gray-100` for headings, `gray-300` for body, `gray-500` for muted
- **Elevation**: lighter = higher (reverse of light mode). Elevated cards are `gray-800` on `gray-900` background
- **Accents**: reduce saturation slightly — vivid colors vibrate against dark backgrounds
- **Tailwind**: use `dark:` prefix systematically. Define dark palette in config.

## Choosing a Style
Match the aesthetic to the audience and purpose:
- **Trust & authority**: corporate, material, minimalist
- **Innovation & creativity**: glassmorphism, brutalism, asymmetric
- **Playfulness & warmth**: claymorphism, bold colors, rounded shapes
- **Technical & developer**: minimalist, dark mode, monospace accents
- **Luxury & premium**: minimalist + dark mode, generous whitespace, serif headings

Don't mix styles. Pick one direction and commit — inconsistency reads as unfinished, not creative.
