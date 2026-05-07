---
name: plan-first
description: For any non-trivial change (more than one file, or any change to schemas, configs, public APIs, or auth), produce a plan before editing. Use when the user describes a feature, refactor, migration, or anything ambiguous.
---

For non-trivial work, produce a plan **before** editing files. The plan is:

1. **Goal** — one sentence.
2. **Files I will touch** — bullet list with one-line reason each.
3. **Files I will read but not touch.**
4. **Risks** — at least one. "None" is rarely true.
5. **Tests** — what passes proves this is done. Cite the verify command.
6. **Verification path** — see `skills/verify`. If unknown, ask.

Show the plan, ask "go?", and only proceed on an affirmative answer.

For genuinely hard reasoning (algorithm choice, cross-cutting refactors,
"why is this slow"), include the literal token `ultrathink` somewhere in
your reply — per the official skills docs, this requests deeper reasoning.

Trivial changes that skip this skill: typo fixes, single-file <10-line
edits, comment-only changes, dependency bumps already in `package.json`.

Per howborisusesclaudecode.com Part 3: re-plan when reality diverges from
the plan, rather than course-correcting one step at a time. Boris's
own ratio is **10–20% of sessions abandoned** when a plan turns out to
be wrong (per the Jan 2026 InfoQ interview "Inside the Development
Workflow of Claude Code's Creator") — that's normal, not a failure.
