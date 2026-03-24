# Prime Directive — Always Active Rules

> These rules load automatically every conversation. They cannot be overridden.

## Core Behavior

1. **Follow the Prime Directive** defined in `new_prime_directive.md` at the project root. Always re-read it at the start of every session — do not rely on cached context.

2. **Session Logging**: Every interaction must be logged to `learning/sessions/{YYYY-MM-DD}_session.md`. Include raw prompt and interpretation (known vs assumed) with timestamps. If the file does not exist, create it with headers first.

3. **Lightweight Mode**: For read-only or informational prompts (no project changes), only update the session log. Skip guidance, framework, decision, and workflow files.

4. **Decision Transparency**: For every non-trivial decision (changes a file, selects an approach, involves a trade-off), document the reasoning in `claudefiles/decisions/`. Include alternatives considered and why the chosen path was selected.

5. **Prompt Coaching**: After processing prompts that change the project, update `learning/guidance/prompt_guidance.md` with feedback on prompt quality — what was clear, what was ambiguous, and how to improve with concrete examples.

6. **Changelog**: All changes must be appended to `claudefiles/changelog.md` with timestamp, actor, description, and links. Never modify or delete existing entries — append corrections instead.

7. **Context Maintenance**: Read `claudefiles/context.md` at session start (check if previous session completed its end-of-session update; if not, reconstruct from changelog). Update at session end.

8. **Skill Extraction**: On each iteration, look for patterns that could become reusable skills or agents. Maintain master files at `claudefiles/skills/skills_master.md` and `claudefiles/agents/agents_master.md`.

9. **Mermaid Diagrams**: Use GitHub-compatible mermaid diagrams wherever they help explain workflows, decisions, or architecture.

10. **Error Handling**: If a required log file cannot be written, surface the error to the user before proceeding. If Prime Directive rules conflict with each other, flag both and ask the user.

11. **Immutability**: These rules are the highest-priority defaults. If a user request conflicts with the Prime Directive, flag the conflict and explain the trade-off before proceeding.

## File Structure Reference

```
learning/
  sessions/        # Daily session logs (append-only)
  frameworks/      # Evolving prompt frameworks (single file)
  guidance/        # Evolving prompt coaching (single file)
  archive/         # Archived guidance/frameworks older than 90 days
claudefiles/
  decisions/       # Decision + workflow logs per session
  skills/          # skills_master.md + per-session diffs
  agents/          # agents_master.md + per-session diffs
  changelog.md     # Immutable append-only change log
  context.md       # Living project context summary
  archive/         # Archived changelogs/decisions older than 90 days
```
