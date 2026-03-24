# Questions for the Human

> Things I need your input on before making decisions. Grouped by urgency.

---

## Blocking Questions (Need Answers Before Next Steps)

### Q1: What's the primary audience?
Is this just for you personally, your immediate team, or do you want this to be a public-facing developer tool? This changes everything about priorities:
- **Personal:** Optimize for your workflow, skip polish
- **Team:** Add cheat sheets, runbooks, onboarding material
- **Public:** Invest in UX, branding, SEO, accessibility

### Q2: Are you hosting this on GitHub Pages?
The tools reference `https://github.com/h3nryza/landingzone/Scripts` in the sidebar but the repo is `h3nryza/tools`. Is there a live deployment? Where?

### Q3: Google Analytics — keep, replace, or remove?
The GA tracking ID `G-2Z62LEVC4T` is in every HTML file. Options:
- **Keep:** It works, you get usage data
- **Replace:** Plausible or Umami for privacy (self-hosted or cloud)
- **Remove:** Simplest, no tracking at all
Which matters most to you?

### Q4: Should certificate tools generate keys in the browser?
Currently, the Create Certificate tool generates RSA keys **entirely in the browser** using forge.js. This is convenient but:
- Browser key generation is slower than OpenSSL
- Forge.js v0.10.0 is outdated
- Some security teams argue keys should only be generated in controlled environments

Do you want to keep browser-based key generation, or make it display-only (showing the OpenSSL command to run locally)?

---

## Important Questions (Affect Priorities)

### Q5: Which new tool would help your team the most?
Pick your top 3 from this list:
1. JWT Decoder
2. Base64 Encode/Decode (web)
3. URL Encode/Decode
4. Regex Tester
5. DNS Lookup (web)
6. IP/Subnet Calculator
7. HTTP Header Inspector
8. UUID Generator
9. Hash Generator
10. Timestamp Converter
11. YAML ↔ JSON Converter
12. Diff Tool
13. Password Generator
14. SSH Key Generator

### Q6: Do you want cheat sheets / runbooks?
Would pages like "OpenSSL Cheat Sheet" or "Incident Response Template" be useful alongside the tools? Or keep it tools-only?

### Q7: Dark mode priority?
Is dark mode a must-have or nice-to-have? It affects CSS architecture decisions.

### Q8: What's your deployment process?
Do you:
- Push to main and GitHub Pages auto-deploys?
- Manual deployment?
- Something else?

This determines whether to set up GitHub Actions.

### Q9: Custom domain?
Do you have or plan to get a custom domain (e.g., tools.h3nryza.com)?

---

## Architecture Questions (Can Decide Later)

### Q10: Shared CSS — what's the design direction?
The current tools each have their own CSS with slightly different styles. Should I:
- Create a minimal shared stylesheet and leave tool-specific styles?
- Build a small design system (colors, typography, spacing, buttons)?
- Use a lightweight CSS framework (e.g., Pico CSS, Water.css)?

### Q11: How do you feel about vanilla JS vs. a build step?
Currently everything is vanilla HTML/CSS/JS with no build tools. This is great for simplicity but means:
- No TypeScript
- No bundling/minification
- No import statements
- Manual script tag management

Are you happy keeping it this way, or open to a minimal build tool (e.g., Vite)?

### Q12: Should tools work offline?
PWA support would let tools like chmod, cron, and converters work without internet. Worth the complexity?

### Q13: API endpoints — interested?
Would you use (or want your team to use) these tools programmatically? e.g., `curl https://tools.h3nryza.com/api/jwt/decode -d '{"token": "..."}'`

---

## Cosmetic Questions (Low Urgency)

### Q14: What should the landing page look like?
Options:
- **A)** Clean card grid (like the current layout but polished)
- **B)** Dashboard-style with categories and icons
- **C)** Single-column list (minimal, fast)
- **D)** Something else — describe your ideal

### Q15: Favicon / Logo?
The current avatar (`myAvatar_suit.png`) works for personal branding. Do you want:
- Keep the avatar
- A tools/wrench icon
- A custom logo
- No logo, text only

### Q16: Medium articles?
You have a Medium link in the sidebar. Do you write about these tools there? If so, we could add "Read the blog post" links to relevant tools.

---

## Meta Questions

### Q17: How much time do you want to invest?
This ranges from "a few hours to polish what exists" to "a multi-month platform build." Where are you on that spectrum?

### Q18: Do you want me to implement or just plan?
I can either:
- **A)** Build the tools directly (you review PRs)
- **B)** Write detailed specs for you to build
- **C)** Mix: I build the foundations, you customize

### Q19: Anything I'm missing?
Are there tools you use daily that aren't in the collection and aren't on any list above? Pain points in your workflow that a simple web tool could solve?
