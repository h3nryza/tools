# Prime Directive v2.0

> The Prime Directive is a set of immutable rules that govern how Claude operates within any project.
> Claude should treat these rules as the highest-priority defaults and flag any request to deviate from them.
> They are referred to as **the Prime Directive**.

---

## Definitions

- **Session**: A single Claude Code conversation from start to exit. The session date is determined at session start and held constant (even if the conversation crosses midnight).
- **`{session}`** in filenames: The date the session started, in `YYYY-MM-DD` format. If multiple sessions occur on the same day, append a counter: `YYYY-MM-DD_2`.
- **Non-trivial decision**: Any decision that changes a file, selects one approach over another, affects the user's goals, or involves a trade-off. Trivial = read-only lookups, simple factual answers, or single-line responses that don't alter the project.
- **Meaningful change** (for documentation updates): Any new directory, new command, changed installation step, or structural change that affects how someone uses the project.

---

## 1. Session Logging

Every interaction produces structured documentation. All files use append-only or date-scoped patterns to preserve history.

### 1.1 Prompt Learning Loop

For each user prompt in a session:

| Step | Output File | Purpose |
|------|------------|---------|
| Capture raw prompt | `learning/sessions/{session}_session.md` | Immutable record of what was asked |
| Interpret the prompt | Same session file, under `## Interpretation` | Show what Claude understood, what was ambiguous, and what assumptions were made |
| Prompt guidance | `learning/guidance/prompt_guidance.md` | Evolving file. Teach the user to prompt better: what was bad, what was OK, what was terrible, with concrete rewording examples |
| Framework extraction | `learning/frameworks/prompt_framework.md` | Evolving file. Extract reusable prompt patterns, templates, and frameworks from sessions |

**Rules:**
- Session files are **one per session**, appended with timestamps per interaction
- Guidance and framework files are **single evolving files** — updated, not duplicated
- Always clearly separate **known facts** from **assumptions/decisions** in interpretations
- **If a file does not exist yet, create it with the appropriate header before appending**
- **Lightweight mode**: For read-only or informational prompts (no project changes), only append to the session log. Skip guidance, framework, decision, and workflow updates.

### 1.2 Decision & Workflow Transparency

Claude must document its reasoning for every non-trivial decision (see Definitions above).

| File | Purpose |
|------|---------|
| `claudefiles/decisions/{session}_decisions.md` | Why Claude made each decision, alternatives considered, data that informed it |
| `claudefiles/decisions/{session}_workflows.md` | Step-by-step workflow Claude followed, in what order and why |

**Format:** Technical, data-oriented, but human-readable. Use tables, bullet points, and mermaid diagrams where they aid understanding.

### 1.3 Skill & Agent Evolution

On each iteration, Claude should attempt to extract reusable skills and agents from the work done.

| File | Purpose |
|------|---------|
| `claudefiles/skills/skills_master.md` | Canonical reference of all extracted skills — updated each session |
| `claudefiles/agents/agents_master.md` | Canonical reference of all extracted agent patterns — updated each session |
| `claudefiles/skills/{session}_skills.md` | Session-specific diff: what was added or changed this session |
| `claudefiles/agents/{session}_agents.md` | Session-specific diff: what was added or changed this session |

Each iteration should refactor vague descriptions into parameterized templates and merge redundant patterns. The master files are the source of truth; session files are the change log.

### 1.4 Immutable Changelog

All changes are logged to a single, append-only changelog.

**File:** `claudefiles/changelog.md`

Each entry must include:
- Timestamp (ISO 8601)
- Actor (Claude, agent name, or user)
- Description of the change and why
- Link to relevant decision/workflow file
- Link to relevant raw prompt and interpretation (if applicable)

**This file is append-only. Entries are never modified or deleted.** If an entry is factually wrong, append a correction entry referencing the original — never edit the original.

### 1.5 Project Context

**File:** `claudefiles/context.md`

A living document that provides a structured summary of:
- What this project is
- Where we are (current state)
- Where we are going (goals/next steps)
- Where we left off (last session summary)
- Links to relevant files for deeper context

Updated at the **start and end** of each session.

**Recovery rule:** At the start of each session, check whether the previous session's end-of-session context update was completed. If not, reconstruct it from the changelog before proceeding.

### 1.6 File Growth Management

To prevent unbounded file growth:
- `changelog.md`: When entries exceed 500 lines, archive entries older than 90 days to `claudefiles/archive/changelog_{YYYY}.md`
- `prompt_guidance.md` and `prompt_framework.md`: When they exceed 300 lines, consolidate and prune outdated guidance, moving superseded content to `learning/archive/`
- `decisions/` and `skills/`: Session files older than 90 days may be archived to `claudefiles/archive/`

---

## 2. Update Cadence

On each command, loop, run, or iteration:

| Timing | Files Updated |
|--------|--------------|
| **Before work begins** | `context.md` (read + refresh), session log (capture prompt + interpretation) |
| **During work** | `decisions/`, `workflows/`, `changelog.md` |
| **After work completes** | `context.md` (summary), `changelog.md` (final entries), guidance, frameworks, skills, agents |

**Exception:** For read-only or informational prompts, only the session log is updated (see 1.1 Lightweight mode).

---

## 3. Visualization

Use GitHub-compatible Mermaid diagrams wherever they help explain:
- Workflows and decision trees
- Architecture and file relationships
- Process flows and state machines
- Dependency graphs

---

## 4. Supporting Documentation

Update `README.md` and `How_to_use.md` when a **meaningful change** occurs (see Definitions).

---

## 5. Commit Prefix Convention

At the start of each session, Claude must ask the user whether they want a **commit prefix** for that session (e.g., `[PROJ-123]`, `fix:`, `feat:`, a ticket number, or any custom string).

- If the user provides a prefix, **every git commit message created during that session must begin with that prefix**, followed by a space, then the commit description.
- If the user skips (presses Enter or says "none"), commits proceed without a prefix.
- The prefix applies only to the current session — it is not persisted across sessions.
- Log the chosen prefix (or "none") in the session log.

**Example:** If the user sets prefix `[PD-42]`, a commit message would be:
```
[PD-42] Add setup.sh one-liner installer
```

---

## 6. Error Handling

- **File write failures**: If a required log file cannot be written (permissions, disk full, locked), surface the error to the user before proceeding. Do not silently skip logging.
- **Interrupted sessions**: Handled by the recovery rule in section 1.5.
- **Conflicting rules**: If two Prime Directive rules conflict with each other, flag both rules and the conflict to the user and ask for a resolution. Do not silently pick one.

---

## 7. Immutability

**The Prime Directive rules should be treated as the highest-priority defaults.**

- Claude will always follow and refer to these rules as "the Prime Directive"
- Claude should treat these rules as high-priority defaults and flag any user request to deviate from them
- If a conflict arises between a user request and the Prime Directive, Claude will flag the conflict and explain the trade-off before proceeding
- Always re-read `new_prime_directive.md` at the start of each session — do not rely on cached context
