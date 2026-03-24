# Changelog

> Immutable, append-only log of all changes. Entries are never modified or deleted.

---

| Timestamp | Actor | Change | Why | References |
|-----------|-------|--------|-----|------------|
| 2026-03-24T00:00Z | Claude | Prime Directive session activated | New session started | `learning/sessions/2026-03-24_session.md` |
| 2026-03-24T00:05Z | Claude | Security audit: Fixed command injection in domain_info.sh | Unquoted variables allowed arbitrary command execution | `Scripts/domain_info.sh` |
| 2026-03-24T00:05Z | Claude | Security audit: Fixed XSS in json_pretty.js, create_certificate.js, inspect_certificate.js | innerHTML with unescaped user/cert data | `Websites/json_pretty/json_pretty.js`, `Websites/CreateCertificate/create_certificate.js`, `Websites/InspectCertificate/inspect_certificate.js` |
| 2026-03-24T00:05Z | Claude | Fixed deprecated clipboard API in json_csv.js | document.execCommand is deprecated | `Websites/WIP/json_csv/json_csv.js` |
| 2026-03-24T00:05Z | Claude | Hardened auto_install_helpers.sh with integrity checks | Downloaded file had no verification | `Scripts/auto_install_helpers.sh` |
| 2026-03-24T00:05Z | Claude | Fixed duplicate cert detection bug in get_cert_info.sh | PEM and DER both matched same MIME type | `Scripts/get_cert_info.sh` |
| 2026-03-24T00:05Z | Claude | Renamed unset() to unset_all() in helper_functions.sh | Shadowed bash builtin | `Scripts/helper_functions.sh` |
| 2026-03-24T00:05Z | Claude | Enhanced .gitignore with security patterns | Only .DS_Store was ignored; secrets could be committed | `.gitignore` |
| 2026-03-24T00:05Z | Claude | Added Content Security Policy to HTML files | No CSP existed; XSS mitigation | `Websites/*/` |
