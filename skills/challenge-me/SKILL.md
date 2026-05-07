---
name: challenge-me
description: Apply Boris's adversarial prompting patterns — "grill me", "prove it works", "scrap it and do it elegantly" — to push past Claude's first acceptable answer. Use when the first solution feels rushed, when the user said "are you sure", or before opening a PR for non-trivial work.
disable-model-invocation: true
---

> **Reconstruction notice.** howborisusesclaudecode.com §"Prompting
> Strategies" lists these phrases verbatim but does not publish them as a
> skill. This is our reconstruction.

Three reusable prompts, in escalating order:

1. **Grill me on these changes — don't open a PR until I pass.**
   Claude generates a list of questions a careful reviewer would ask
   (correctness, edge cases, performance, security, naming, contract
   stability). Claude does not proceed until each question has an
   answer.

2. **Prove to me this works.**
   Claude produces a diff or a before/after comparison **plus** the
   verification output that demonstrates the change works (see
   `skills/verify`). "It compiles" is not a proof.

3. **Knowing what you know now, scrap this and implement elegantly.**
   Claude rewrites from scratch using the lessons of the first attempt.
   Discards the first attempt; does not refactor it.

When to use each:

- Use **(1)** before merging anything you'd be embarrassed to defend.
- Use **(2)** when "tests pass" feels like cargo-cult success.
- Use **(3)** when the current code is correct but ugly, and the cost of
  carrying it forward is higher than the cost of rewriting.

These are user-driven prompts. The skill exists so the user can invoke
them by name (`/challenge-me 1`, etc.) without re-typing.
