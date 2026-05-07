---
name: three-loop
description: Reference content describing the edit / test / PR three-loop cadence. Loads automatically when the user is talking about workflow, code review cadence, or "how should I structure this work".
user-invocable: false
---

The three loops, per howborisusesclaudecode.com Part 2:

- **Edit loop** — seconds. Make the smallest change that compiles. Run the
  type-checker. Repeat. Don't open the test runner.
- **Test loop** — minutes. Run the targeted tests for the file you touched.
  If they pass, run the next ring out. Don't run the whole suite yet.
- **PR loop** — tens of minutes. Whole suite, lint, format, then open PR.
  This is the loop where you stop and read your own diff.

Implication for Claude: prefer narrowing before widening. When asked to
"fix the bug", stay in the edit loop until type-check passes; only then
escalate to the test loop; only then to the PR loop.
