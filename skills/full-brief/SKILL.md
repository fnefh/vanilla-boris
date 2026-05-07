---
name: full-brief
description: Write a full-context brief before delegating to Claude — goal, constraints, acceptance criteria, verification path. Reconstruction of the Opus 4.7 delegation pattern Boris describes ("treat Claude like an engineer you delegate to, not a pair programmer"). Use when the user is about to start a non-trivial task or said "delegate this".
disable-model-invocation: true
---

> **Reconstruction notice.** howborisusesclaudecode.com §"Key Behavioral
> Shifts for Opus 4.7" describes the pattern but does not publish a skill.

Opus 4.7 reasons more before calling tools and is more judicious about
spawning subagents. The corresponding shift for the user: write a crisp
brief upfront and launch, instead of pair-programming step-by-step.

A full brief is:

1. **Goal** — one sentence. What "done" looks like.
2. **Constraints** — non-goals, untouched files, contracts, performance
   ceilings, "don't change the schema".
3. **Acceptance criteria** — verifiable. Cite the verify command (see
   `skills/verify`).
4. **Inputs** — paths, fixtures, sample data.
5. **Output format** — diff, PR, file list.
6. **Effort level** — `xhigh` (default for Opus 4.7) or `max` for the
   hardest tasks. See `references/effort-levels.md`.
7. **Subagent budget** — "use up to N subagents" or "don't spawn
   subagents for this". Opus 4.7 will not spawn agents for trivial work
   unless asked.

Workflow:

- If the user gave a one-liner, ask one round of clarifying questions
  before writing the brief. After that, stop asking and write.
- Show the brief, ask "go?", and proceed on yes.
- During execution, do not interrupt for routine decisions — make them
  and surface them in the final report. Reserve interruptions for
  irrecoverable forks (deleting data, modifying schemas, mass file
  moves).

This skill composes with `plan-first`: brief is the *what*, plan is the
*how*.
