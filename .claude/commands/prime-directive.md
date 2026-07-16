---
description: Activate the Prime Directive governance workflow
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(date:*), Bash(mkdir:*)
model: opus
---

# Prime Directive Activation

You are now operating under the **Prime Directive**. Read and follow all rules defined in `new_prime_directive.md`.

## Session Initialization

1. **Read the Prime Directive**: Read `new_prime_directive.md` to load all rules.
2. **Read context**: Read `claudefiles/context.md` to understand where we left off. If it does not exist (first session), note this and proceed.
3. **Idempotency check**: If a session log for today already exists with entries, do not re-initialize. Say "Prime Directive already active" and continue.
4. **Create session log**: Create or append to `learning/sessions/{YYYY-MM-DD}_session.md`.
5. **Log this activation** in `claudefiles/changelog.md`.
6. **Ask for commit prefix**: Ask the user: "Would you like a commit prefix for this session? (e.g., `[PROJ-123]`, `fix:`, `feat:`) — or press Enter to skip." Store the response. If a prefix is set, **all commits made during this session must start with that prefix**.

## For Every Prompt This Session

1. **Capture** the raw prompt in the session log
2. **Interpret** it — show known facts vs assumptions
3. **Check**: Is this trivial (read-only/info) or non-trivial (changes project)?
   - **Trivial**: Log to session only, deliver result
   - **Non-trivial**: Continue with steps 4-7
4. **Update guidance** in `learning/guidance/prompt_guidance.md` — coach the user on prompt quality
5. **Document decisions** in `claudefiles/decisions/`
6. **Update changelog** with all changes made
7. **Extract skills/agents** if patterns emerge, update master files

## At Session End

- Update `claudefiles/context.md` with: current state, what was done, what's next

## Confirm to User

Say: "Prime Directive ready. Ready for your code."

If a commit prefix was set, also say: "Commit prefix: `{prefix}` — all commits this session will use this prefix."
