# Decisions — 2026-03-24

## Decision 1: Command Injection Fix Strategy

**Context:** domain_info.sh passes user-supplied domain names unquoted into shell commands (whois, dig, curl, ping, traceroute).

**Alternatives Considered:**
1. Quote all variables only — minimal change
2. Quote variables + add domain validation regex — defense in depth
3. Rewrite to use arrays for all commands — most thorough but high churn

**Chosen:** Option 2 — quoting + validation. Provides two layers of defense without rewriting the entire script structure.

## Decision 2: XSS Fix Approach

**Context:** Multiple JS files use `.innerHTML` with unescaped dynamic content.

**Alternatives Considered:**
1. Switch all to `.textContent` — safest but breaks rainbow bracket formatting
2. Add `escapeHtml()` to all dynamic values — preserves functionality
3. Use DOMPurify library — adds dependency

**Chosen:** Option 2 — escape at the data layer. JSON pretty needs innerHTML for colored spans, so we escape the data characters instead.

## Decision 3: Renaming `unset()` to `unset_all()`

**Context:** helper_functions.sh defined a function called `unset` which shadows the bash builtin.

**Risk:** Users could no longer use `unset VAR` to unset individual variables after sourcing the helpers.

**Chosen:** Rename to `unset_all()` — descriptive, avoids builtin collision, and the list_helpers reference was also updated.

## Decision 4: .gitignore Expansion

**Context:** Only `.DS_Store` was ignored. Private keys (*.pem, *.key, *.pfx), .env files, and credentials could be accidentally committed.

**Chosen:** Added patterns for secrets, keys, editor files, and OS artifacts. This is preventive — no secrets were found in the repo.
