# Master Plan — Tools by H3nryza

> Living document. Updated iteratively across 10+ brainstorming cycles.
> Each iteration adds depth, refines priorities, and captures new ideas.

---

## Iteration 1: Foundation & Security

### Goal
Establish a secure, well-structured foundation before adding new features.

### Tasks

- [x] **1.1 Security Audit**
  - [x] Fix command injection in domain_info.sh
  - [x] Fix XSS in JSON Pretty, Create Certificate, Inspect Certificate
  - [x] Add CSP headers
  - [x] Expand .gitignore for secrets
  - [x] Fix bash builtin shadowing
  - [x] Harden auto-installer

- [ ] **1.2 Forge.js Upgrade**
  - [ ] Update from v0.10.0 to v1.3.0
  - [ ] Test all three certificate tools (Create, Inspect, InspectCSR)
  - [ ] Consider self-hosting forge.js as fallback

- [ ] **1.3 Shared CSS Framework**
  - [ ] Extract common styles into a shared stylesheet
  - [ ] Each tool imports shared + tool-specific CSS
  - [ ] Consistent color scheme, typography, responsive breakpoints

---

## Iteration 2: New Tool Ideas — DevOps Essentials

### Tasks

- [ ] **2.1 JWT Decoder/Inspector**
  - [ ] Paste a JWT, decode header + payload
  - [ ] Show expiry, issuer, claims
  - [ ] Signature verification (optional, requires key input)
  - [ ] Color-coded sections (header, payload, signature)

- [ ] **2.2 Base64 Encode/Decode (Web UI)**
  - [ ] Port existing shell script to web tool
  - [ ] Support file upload for binary-to-base64
  - [ ] Auto-detect if input is base64

- [ ] **2.3 URL Encode/Decode**
  - [ ] Encode/decode URL components
  - [ ] Bulk mode (multiple URLs)
  - [ ] Show breakdown of encoded characters

- [ ] **2.4 Regex Tester**
  - [ ] Input regex + test string
  - [ ] Live match highlighting
  - [ ] Common regex library (email, IP, URL, etc.)
  - [ ] Explanation of regex components

---

## Iteration 3: Infrastructure & Network Tools

### Tasks

- [ ] **3.1 DNS Lookup (Web UI)**
  - [ ] Port domain_info.sh concepts to web
  - [ ] Query A, AAAA, MX, TXT, NS, SOA, CNAME records
  - [ ] Use public DNS-over-HTTPS APIs (Google, Cloudflare)
  - [ ] Visual record type selector

- [ ] **3.2 IP/Subnet Calculator**
  - [ ] CIDR to IP range
  - [ ] Subnet mask calculator
  - [ ] Network/broadcast address
  - [ ] Supernetting/summarization

- [ ] **3.3 HTTP Header Inspector**
  - [ ] Enter a URL, fetch and display all response headers
  - [ ] Security header grading (HSTS, CSP, X-Frame-Options, etc.)
  - [ ] Recommendations for missing headers

- [ ] **3.4 SSL/TLS Checker (Web-based)**
  - [ ] Enter domain, check certificate chain
  - [ ] Show expiry, issuer, protocol version
  - [ ] Grade the TLS configuration

---

## Iteration 4: Developer Productivity Tools

### Tasks

- [ ] **4.1 UUID/ULID Generator**
  - [ ] Generate v4 UUIDs, v7 UUIDs, ULIDs
  - [ ] Bulk generation (configurable count)
  - [ ] Copy-to-clipboard for each

- [ ] **4.2 Hash Generator**
  - [ ] Input text or file
  - [ ] Generate MD5, SHA-1, SHA-256, SHA-512
  - [ ] Compare two hashes for equality

- [ ] **4.3 Timestamp Converter (Web UI)**
  - [ ] Port existing shell epoch functions to web
  - [ ] Unix timestamp ↔ human-readable
  - [ ] Support multiple date formats
  - [ ] "Now" button for current time
  - [ ] Time zone conversion

- [ ] **4.4 YAML ↔ JSON Converter**
  - [ ] Bidirectional conversion
  - [ ] Syntax validation
  - [ ] Pretty-print both formats

- [ ] **4.5 Diff Tool**
  - [ ] Paste two texts, show diff
  - [ ] Line-by-line and word-by-word modes
  - [ ] Color-coded additions/deletions

---

## Iteration 5: Website & UX Improvements

### Tasks

- [ ] **5.1 Landing Page Redesign**
  - [ ] Card-based layout with icons per tool
  - [ ] Category groupings (Security, Networking, Developer, Text)
  - [ ] Search/filter tools
  - [ ] Dark mode toggle
  - [ ] Mobile-first responsive design

- [ ] **5.2 Navigation System**
  - [ ] Consistent header/footer across all tools
  - [ ] Breadcrumb navigation
  - [ ] "Back to home" link on every tool page
  - [ ] Tool category sidebar

- [ ] **5.3 Accessibility**
  - [ ] ARIA labels on all interactive elements
  - [ ] Keyboard navigation support
  - [ ] High-contrast mode
  - [ ] Screen reader testing

- [ ] **5.4 PWA Support**
  - [ ] Service worker for offline capability
  - [ ] Manifest.json for install-to-homescreen
  - [ ] Cache static assets

---

## Iteration 6: Team Collaboration Features

### Tasks

- [ ] **6.1 Cheat Sheet Pages**
  - [ ] OpenSSL cheat sheet (common commands)
  - [ ] Git cheat sheet
  - [ ] Kubernetes cheat sheet
  - [ ] Terraform cheat sheet
  - [ ] Docker cheat sheet

- [ ] **6.2 Runbook Templates**
  - [ ] Incident response template
  - [ ] Deployment checklist
  - [ ] Certificate renewal playbook
  - [ ] DNS migration playbook

- [ ] **6.3 Team Knowledge Base**
  - [ ] Searchable collection of how-tos
  - [ ] Markdown-based, static site generation
  - [ ] Categories: cloud, security, networking, scripting

---

## Iteration 7: CI/CD & Automation

### Tasks

- [ ] **7.1 GitHub Actions Workflow**
  - [ ] Auto-deploy to GitHub Pages on merge to main
  - [ ] HTML/CSS/JS linting
  - [ ] ShellCheck for all bash scripts
  - [ ] Security scanning (Trivy, Snyk, or similar)

- [ ] **7.2 Dependency Management**
  - [ ] Track forge.js version with renovatebot or dependabot
  - [ ] Automated PR for outdated dependencies
  - [ ] Subresource Integrity (SRI) hashes for CDN scripts

- [ ] **7.3 Testing Framework**
  - [ ] Unit tests for JavaScript tools (Jest or similar)
  - [ ] Shell script tests (BATS)
  - [ ] End-to-end tests for web tools (Playwright)

---

## Iteration 8: Advanced Security Tools

### Tasks

- [ ] **8.1 Password Generator**
  - [ ] Configurable length, complexity, character sets
  - [ ] Passphrase mode (random words)
  - [ ] Strength meter
  - [ ] Never sends passwords over network (client-side only)

- [ ] **8.2 CSP Header Builder**
  - [ ] Visual builder for Content Security Policy
  - [ ] Directive-by-directive configuration
  - [ ] Export as meta tag or HTTP header
  - [ ] Validate against common patterns

- [ ] **8.3 SSH Key Generator (Web)**
  - [ ] Generate RSA/Ed25519 key pairs client-side
  - [ ] Download public/private keys
  - [ ] Show fingerprint
  - [ ] Provide authorized_keys format

- [ ] **8.4 CORS Tester**
  - [ ] Enter origin + target URL
  - [ ] Show preflight request/response
  - [ ] Explain what's allowed/blocked and why

---

## Iteration 9: Data & Format Tools

### Tasks

- [ ] **9.1 Complete JSON ↔ CSV Converter**
  - [ ] Finish the WIP tool
  - [ ] Handle nested JSON properly
  - [ ] Support CSV with headers
  - [ ] Download converted output

- [ ] **9.2 Markdown Preview**
  - [ ] Live markdown editor + preview
  - [ ] Support GFM (tables, task lists, etc.)
  - [ ] Export to HTML or PDF
  - [ ] Mermaid diagram support

- [ ] **9.3 Color Picker / Converter**
  - [ ] HEX ↔ RGB ↔ HSL
  - [ ] Color palette generator
  - [ ] Contrast ratio checker (accessibility)

- [ ] **9.4 QR Code Generator**
  - [ ] Input text/URL → generate QR code
  - [ ] Configurable size and error correction
  - [ ] Download as PNG/SVG

---

## Iteration 10: Platform Evolution

### Tasks

- [ ] **10.1 Plugin Architecture**
  - [ ] Define a standard tool manifest (name, description, category, entry point)
  - [ ] Auto-discover tools from directory structure
  - [ ] Generate landing page dynamically from manifest

- [ ] **10.2 Analytics Dashboard**
  - [ ] Track which tools are most used
  - [ ] Privacy-respecting analytics (Plausible or Umami instead of GA)
  - [ ] Display usage stats on a dashboard

- [ ] **10.3 Custom Domain & Branding**
  - [ ] Set up custom domain for GitHub Pages
  - [ ] Consistent branding (logo, favicon, meta tags)
  - [ ] Open Graph meta tags for social sharing

- [ ] **10.4 API Layer**
  - [ ] Expose key tools as REST endpoints (serverless functions)
  - [ ] JWT decode, base64, hash generation as API
  - [ ] Rate limiting and API key support
  - [ ] Swagger/OpenAPI documentation
