# Recommendations

> Actionable recommendations organized by impact and effort. Updated across iterations.

---

## HIGH Impact, LOW Effort (Do First)

### 1. Upgrade Forge.js to v1.3.0
**Why:** The current v0.10.0 is 3+ years old and may have known vulnerabilities. A single version bump across 3 HTML files.
**How:** Update CDN URLs in CreateCertificate, InspectCertificate, and InspectCSR HTML files. Add SRI hashes.

### 2. Add SRI (Subresource Integrity) Hashes to CDN Scripts
**Why:** If the CDN is compromised, SRI prevents tampered scripts from running.
**How:** Generate sha384 hash of forge.min.js, add `integrity` and `crossorigin` attributes to script tags.

### 3. Add a Shared Navigation Header
**Why:** Users currently have no way to get back to the home page from any tool. Each tool is an island.
**How:** Create a simple shared `nav.html` or JS include with a home link and tool list.

### 4. Add "Back to Home" Link to Every Tool
**Why:** Basic UX — users get stranded on tool pages.
**How:** Single line of HTML at top of each tool page.

### 5. Fix the Landing Page Structure
**Why:** The current `index.html` has commented-out HTML blocks, bare `<a>` tags without card structure, and typos.
**How:** Clean up the HTML, use consistent card layout, fix "Enginner" → "Engineer" typo.

---

## HIGH Impact, MEDIUM Effort

### 6. Add JWT Decoder Tool
**Why:** JWT inspection is a daily task for DevOps/platform engineers. Currently requires third-party tools like jwt.io. This is the #1 most-requested DevOps utility missing from the collection.
**How:** Pure client-side JS — split token on `.`, base64-decode header and payload, display claims.

### 7. Add IP/Subnet Calculator
**Why:** Network teams constantly need CIDR calculations. Having it in-house avoids sending network info to third parties.
**How:** Pure JavaScript bitwise operations — no dependencies needed.

### 8. Set Up GitHub Actions CI/CD
**Why:** Currently no automated quality checks. Scripts could break silently.
**How:** Simple workflow: ShellCheck for .sh files, HTMLHint for HTML, deploy to GitHub Pages on merge.

### 9. Replace Google Analytics with Privacy-Respecting Alternative
**Why:** GA tracking ID is exposed in a public repo and sends user data to Google. Plausible or Umami are self-hostable, GDPR-compliant, and lightweight.
**How:** Swap GA script tags for Plausible snippet (single line) or self-host Umami.

### 10. Complete the JSON ↔ CSV Converter
**Why:** It's already 80% done sitting in WIP. Finishing it adds value with minimal effort.
**How:** Test edge cases, fix remaining bugs, move out of WIP directory.

---

## MEDIUM Impact, MEDIUM Effort

### 11. Add Dark Mode
**Why:** Most DevOps engineers work in dark terminals. A dark mode toggle makes the tools feel native to their workflow.
**How:** CSS custom properties + a toggle button. Store preference in localStorage.

### 12. Create OpenSSL Cheat Sheet Page
**Why:** Certificate operations are the core of this tool collection. A cheat sheet complements the tools and drives repeat visits.
**How:** Static HTML/Markdown page with common OpenSSL commands, organized by task.

### 13. Add Timestamp Converter Web Tool
**Why:** The shell helper functions already have epoch conversion — a web UI makes it accessible without terminal access.
**How:** Port the logic from helper_functions.sh to a simple JS page.

### 14. PWA (Progressive Web App) Support
**Why:** Allows offline use and install-to-homescreen on mobile. Tools like chmod and cron calculators are useful even without internet.
**How:** Add manifest.json + service worker to cache static assets.

### 15. Add Keyboard Shortcuts
**Why:** Power users (the target audience) prefer keyboard-driven workflows.
**How:** Listen for Ctrl+Enter to submit, Ctrl+Shift+C to copy output, etc.

---

## MEDIUM Impact, HIGH Effort

### 16. Automated Testing
**Why:** No tests exist. Changes can silently break tools.
**How:** Jest for JS unit tests, BATS for shell tests, Playwright for E2E web tests.

### 17. Plugin Architecture
**Why:** Adding a new tool currently requires editing index.html and creating 3 files. A manifest-based system auto-discovers tools.
**How:** Each tool gets a `manifest.json` with metadata. Landing page is generated dynamically.

### 18. API Layer (Serverless)
**Why:** Enables programmatic access to tools from CI/CD pipelines, scripts, and other tools.
**How:** AWS Lambda or Cloudflare Workers wrapping the core logic.

---

## LOW Priority (Nice to Have)

### 19. Color Picker / Converter
Useful but not core to the DevOps audience.

### 20. QR Code Generator
Fun addition but low daily usage for platform engineers.

### 21. Markdown Preview Tool
Many good alternatives exist (VS Code, StackEdit). Lower differentiation value.

---

## Anti-Recommendations (Don't Do)

1. **Don't add a database** — Keep everything static and client-side. The simplicity is a feature.
2. **Don't add user accounts/auth** — Adds complexity with no clear benefit for utility tools.
3. **Don't add server-side processing** — All crypto/encoding should remain client-side for privacy.
4. **Don't over-brand** — The tools are the product. Keep branding minimal.
5. **Don't add ads** — Destroys trust for a tool collection that handles certificates and sensitive data.
