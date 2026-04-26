# Emotional Design

When to reference: defining brand tone, evaluating visual feel, deciding when to add delight vs. when to stay quiet.

## Don Norman's Three Levels

Every design triggers three levels of emotional processing simultaneously (Norman, 2004). Designing for one without the others creates lopsided experiences.

### 1. Visceral — Immediate, Subconscious

Triggered before the user reads a word. In milliseconds, the visual answers: Is it beautiful? Threatening? Trustworthy?

**Drivers in web design:**
- First-load impression (hero treatment, loading polish)
- Color warmth and palette discipline
- Typography elegance and pairing
- Whitespace generosity
- Image quality and authenticity
- Layout balance

A cluttered page with aggressive colors triggers visceral rejection before the user processes any content. You won't get a second chance — first-impression studies (Lindgaard et al., 2006) show users form trust judgments in 50ms.

### 2. Behavioral — The Experience of Use

The level of doing. Does it work? Is it easy? Does it match expectation?

**Drivers:**
- Page load and response speed
- Form completion ease
- Navigation clarity
- Error recovery
- Micro-interaction polish (slider feel, dropdown smoothness)
- Predictability — buttons act like buttons

A beautiful site that's hard to use fails here. A workmanlike site that does the job feels good even if it's not gorgeous.

### 3. Reflective — Conscious Evaluation

The level of meaning. What does using this product say about me? Would I recommend it? Do I feel good about having used it?

**Drivers:**
- Brand identity and story
- Pride in using a well-made tool
- Embarrassment at sharing something ugly
- Sense of being "cared for" by thoughtful touches
- Social and tribal signals

Reflective design is where brand loyalty forms. Apple's product pages excel here — they make you feel that owning the product makes you a better version of yourself. Stripe makes you feel like a serious developer for choosing it. Notion makes you feel organized. None of that is accident.

## Practical Application

### Delight is earned, not injected

You cannot make a frustrating product delightful by adding confetti. Delight is the *last* layer:

1. Make it work (functional)
2. Make it work well (behavioral)
3. Make it beautiful (visceral)
4. *Then* add moments of delight (reflective)

Skipping steps backfires. A confetti animation on a slow, broken form is condescending.

### Match emotion to context

A banking app should feel **trustworthy and calm** — not playful and exciting. A children's game should feel **fun and energetic** — not corporate and subdued. The brief is "appropriate emotion," not "maximum emotion."

| Context | Emotional target |
|---|---|
| Banking, healthcare, legal | Calm, trustworthy, precise |
| Children's apps, games | Energetic, playful, warm |
| Productivity tools | Confident, fast, quiet |
| Creative tools | Expressive, generous, personal |
| E-commerce | Aspirational, easy, safe |
| Developer tools | Technical, precise, witty (sparingly) |

### Personality through consistency

Brand personality is not a logo — it's the **same voice, interaction patterns, and visual language** applied everywhere. Mailchimp's chimp, Slack's casual tone, Stripe's technical precision, Linear's restraint. None are random; all are systematic.

If your delight moments contradict your default behavior, you're confusing the user. A serious financial app suddenly using comic-sans easter eggs reads as careless.

## Designing for Emotional State, Not Just Brand

Tone shifts with the user's situation. Same brand, different moments:

- **Success** — celebratory but not smug ("Saved!" not "Way to be a saver!")
- **Error** — calm and helpful ("We couldn't save. Your draft is preserved." not "Oops! Something broke!")
- **Loading** — confident and brief ("Loading your dashboard..." not a 30-second motivational quote)
- **Empty** — warm and educational ("No projects yet — let's create your first one")
- **Destructive confirmation** — serious ("Delete 12 photos permanently?" not "Are you sure? 😬")

Frustrated users do not want playful copy. Excited users do not want bureaucratic copy. Read the room.

## Anti-Patterns

- **Forced personality** — comic-relief microcopy in a serious flow ("Whoops!" on a payment failure)
- **Inconsistent tone** — playful onboarding, corporate settings, sarcastic errors
- **Decoration as emotion** — drop shadows and gradients pretending to be polish
- **Smug success states** — "You did it!" with three exclamation marks for routine actions
- **Performative concern** — "We're sorry you're seeing this 😢" without any actual help

## Quick Audit

Pull up any screen of a product and ask:
1. **Visceral**: would a stranger trust this in 50ms?
2. **Behavioral**: can they complete the primary task without thinking?
3. **Reflective**: does using this make them feel competent / proud / cared-for?

A "no" at any level is design debt.
