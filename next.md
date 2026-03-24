# What Comes Next — Prioritized Roadmap

> Ordered by priority. Each item includes effort estimate and dependencies.

---

## Priority 1: Immediate (This Week)

### P1.1 — Upgrade Forge.js to v1.3.0
- **Effort:** 30 min
- **Files:** 3 HTML files
- **Dependencies:** None
- **Risk:** API changes between v0.10.0 and v1.3.0 could break cert tools — test thoroughly
- **Why now:** Known vulnerable dependency should be updated before anything else

### P1.2 — Add SRI Hashes to All CDN Scripts
- **Effort:** 15 min
- **Dependencies:** P1.1 (need final forge.js version first)
- **Why now:** Pairs naturally with the forge upgrade

### P1.3 — Fix Landing Page HTML
- **Effort:** 1 hour
- **Files:** index.html
- **Dependencies:** None
- **Why now:** The current page has broken HTML structure, typos, and dead links

### P1.4 — Add Navigation to All Tools
- **Effort:** 1 hour
- **Files:** All HTML files
- **Dependencies:** None
- **Why now:** Basic UX requirement — users can't navigate between tools

---

## Priority 2: Next Sprint (This Month)

### P2.1 — JWT Decoder Tool
- **Effort:** 4 hours
- **Dependencies:** Shared CSS (P2.4)
- **Why next:** Highest-value new tool for the DevOps audience

### P2.2 — Timestamp Converter (Web)
- **Effort:** 3 hours
- **Dependencies:** Shared CSS (P2.4)
- **Why next:** Logic already exists in helper_functions.sh — just needs a web UI

### P2.3 — Base64 Encode/Decode (Web)
- **Effort:** 2 hours
- **Dependencies:** Shared CSS (P2.4)
- **Why next:** Logic exists in encoder_decoder.sh — web version adds accessibility

### P2.4 — Extract Shared CSS
- **Effort:** 3 hours
- **Files:** All CSS files → one shared.css + per-tool overrides
- **Dependencies:** None
- **Why next:** Reduces duplication and makes future tools consistent

### P2.5 — Complete JSON ↔ CSV Converter
- **Effort:** 2 hours
- **Dependencies:** None
- **Why next:** Already 80% done — minimal effort for a new tool

---

## Priority 3: Near-Term (Next 2-3 Months)

### P3.1 — GitHub Actions CI/CD Pipeline
- **Effort:** Half day
- **Components:**
  - ShellCheck linting for all .sh files
  - HTMLHint / W3C validation for HTML
  - Auto-deploy to GitHub Pages on merge to main
- **Why:** Prevents regressions, automates deployment

### P3.2 — IP/Subnet Calculator
- **Effort:** 4 hours
- **Why:** High-value networking tool, pure JS, no dependencies

### P3.3 — DNS Lookup (Web UI)
- **Effort:** 6 hours
- **Dependencies:** DNS-over-HTTPS API (Google/Cloudflare)
- **Why:** Brings domain_info.sh concepts to the web without needing a terminal

### P3.4 — Dark Mode
- **Effort:** 3 hours
- **Dependencies:** Shared CSS (P2.4)
- **Why:** Matches DevOps audience preferences

### P3.5 — Hash Generator Tool
- **Effort:** 3 hours
- **Why:** Common utility, client-side Web Crypto API

---

## Priority 4: Mid-Term (3-6 Months)

### P4.1 — OpenSSL Cheat Sheet Page
### P4.2 — Password Generator
### P4.3 — HTTP Header Inspector
### P4.4 — Diff Tool
### P4.5 — YAML ↔ JSON Converter
### P4.6 — Replace GA with Plausible/Umami

---

## Priority 5: Long-Term (6-12 Months)

### P5.1 — PWA Support
### P5.2 — Plugin Architecture
### P5.3 — Automated Testing Suite
### P5.4 — API Layer
### P5.5 — Custom Domain

---

## Decision Matrix

| Tool | Impact | Effort | Priority | Audience Need |
|------|--------|--------|----------|---------------|
| Forge.js Upgrade | High | Low | P1 | Security |
| Landing Page Fix | High | Low | P1 | UX |
| JWT Decoder | Very High | Medium | P2 | Daily use |
| Timestamp Converter | High | Low | P2 | Daily use |
| Base64 Web UI | Medium | Low | P2 | Common task |
| Shared CSS | Medium | Medium | P2 | Maintainability |
| IP/Subnet Calc | High | Medium | P3 | Networking |
| GitHub Actions | High | Medium | P3 | Quality |
| Dark Mode | Medium | Low | P3 | Preference |
| Hash Generator | Medium | Low | P3 | Common task |
| Password Generator | Medium | Medium | P4 | Security |
| Diff Tool | Medium | High | P4 | Dev productivity |
| PWA Support | Medium | High | P5 | Offline use |
| API Layer | High | Very High | P5 | Automation |
