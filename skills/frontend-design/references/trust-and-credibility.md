# Trust & Credibility Design

When to reference: marketing pages, signup/login flows, checkout, e-commerce, financial/health/legal products, anything where the user must decide whether to trust you.

Users make trust judgments about a website in **50 milliseconds** (Lindgaard et al., 2006). Design is the primary trust signal — well before they read your copy.

## Visual Trust Signals

These shape the visceral judgment (see `emotional-design.md`):

- **Professional typography** — well-chosen, well-sized, well-spaced type signals competence. Default browser fonts and inconsistent sizes signal amateur.
- **Consistent visual language** — matching colors, consistent component styles, aligned elements. Inconsistency reads as carelessness.
- **Quality imagery** — high-resolution, relevant, authentic photos. Stock-photo handshakes and "diverse team in a meeting" generic imagery actively erode trust.
- **Generous whitespace** — spacing signals confidence and quality. Cramped layouts signal desperation (the dollar-store effect).
- **No broken elements** — broken images, 404 links, misaligned components, untranslated lorem ipsum. Any of these instantly destroys credibility. Run a link check before launch.
- **Polished interactions** — hover states, smooth transitions, snappy responsiveness. The behavioral level of trust.

## Content Trust Signals

These shape the reflective judgment — what the user concludes about your business:

- **Social proof**
  - Testimonials with **real name + photo + company** (anonymous testimonials are worse than none)
  - Case studies with measurable outcomes
  - Client/customer logos (especially recognizable ones)
  - Review scores with source ("4.8 on G2", "Featured by Apple")
  - User counts ("Trusted by 50,000+ teams")
- **Security indicators**
  - Visible HTTPS lock (browser provides this — don't break it)
  - Payment method logos at checkout (Visa, Mastercard, Amex, Apple Pay)
  - Compliance badges where relevant (SOC 2, GDPR, HIPAA — only if real)
- **Contact information**
  - Visible phone, email, or chat
  - Physical address (especially for finance/legal)
  - Real customer support channels — not just a contact form
- **About page with real people**
  - Team photos with names and roles
  - Founder's story or company mission
  - Press mentions or notable backers
- **Clear policies**
  - Privacy policy
  - Terms of service
  - Refund / return / cancellation
  - Accessibility statement (increasingly expected)
- **Clear pricing** — hidden pricing erodes trust. Show the prices, even if you have a "contact us" tier above them.

## Trust at the Right Moment

Trust signals should be visible *when the user is deciding*. A testimonial below a CTA. Payment logos near the checkout button. "Cancel anytime" next to the signup form. A privacy reassurance under the email field.

Putting trust signals only on the homepage misses the moments they're needed most.

## Anti-Patterns That Destroy Trust

These fail fast and recover slowly:

- **Forced pop-ups before content** — especially email capture modals on first visit. The user hasn't even seen what you offer yet.
- **Dark patterns**:
  - Pre-checked opt-in checkboxes
  - "Confirmshaming" decline buttons ("No thanks, I don't want to save money")
  - Hidden fees revealed only at the final checkout step
  - Cancellation flows that make leaving harder than joining
  - Disguised ads that look like content
- **Excessive advertising** — ads outnumbering content; sticky video players that follow you down the page
- **Autoplay video with sound** — single fastest way to lose a user
- **Fake urgency** — "Only 2 left!" when there are unlimited; "Sale ends in 00:23:47" that resets on refresh
- **Misleading microcopy** — "Free trial" that requires a credit card on file with auto-renewal in fine print
- **Overpromising** — "10x your productivity" without evidence; testimonial actors stating implausible results
- **Inconsistent branding** — different logos, fonts, or colors across pages

## Trust in B2B / Enterprise

- **Compliance pages** prominently linked — SOC 2, ISO, GDPR, HIPAA
- **Customer logos with consent** — only show logos you have permission to use
- **Status page** — public uptime history. `status.<yourdomain>.com` is now expected.
- **Documentation depth** — thorough docs signal a serious product
- **Changelog** — visible product evolution signals an active company
- **Security page** — a dedicated page explaining your security posture for procurement teams

## Trust in Consumer / E-commerce

- **Money-back guarantee** prominently displayed
- **Free returns** if applicable
- **Real photos** — your product, in real use, not just renders
- **Reviews** — with verified purchase badges, sortable, including the negative ones
- **Shipping info upfront** — cost and ETA before checkout, not after
- **Multiple payment methods** — meeting the user where they trust

## Trust in Financial / Health / Legal

The bar is highest here. Required:

- Regulatory disclosures clearly placed (not buried in footers)
- Conservative, calm visual design — avoid playful tones
- Real human contact options — phone, in-person where applicable
- Clear handling of sensitive data (encryption, retention, sharing)
- Identifiable practitioners / advisors if relevant (license numbers, affiliations)

Playful copy or stock-photo "happy doctor" imagery in healthcare trips immediate red flags.

## Quick Trust Audit

Pull up the page and ask:
- [ ] Could a stranger trust this in 50ms?
- [ ] Are there any broken/misaligned/lorem-ipsum elements?
- [ ] Is contact info visible without hunting?
- [ ] Are testimonials specific (name, photo, company), not anonymous?
- [ ] Is pricing clear (or honestly explained)?
- [ ] Are there any dark patterns I'd be embarrassed to defend?
- [ ] Does the trust signal appear at the moment of decision?
