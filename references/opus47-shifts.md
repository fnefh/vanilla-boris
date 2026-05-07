# Opus 4.7 behavioral shifts

Source: howborisusesclaudecode.com §"Key Behavioral Shifts for Opus 4.7".

## Delegation over hand-holding

Treat Claude like an engineer you delegate to, not a pair programmer:

- Write a crisp brief upfront (see `skills/full-brief`).
- Launch and return when done.
- Fewer interruptions → fewer context pollution events.
- A complete brief reduces clarifying questions.

## Less auto-tool usage

Opus 4.7 reasons more before calling tools. Two implications:

- **Don't optimize for "Claude calls many tools" as a productivity
  metric.** Fewer, better calls is the new norm.
- **Provide explicit guidance on when/why to use tools.** "Use Grep when
  you need to find Y" beats trust-the-defaults.

## Calibrated response length

- Shorter answers for simple queries.
- Longer for open-ended.
- Don't ask Opus 4.7 to "be brief" reflexively — it's already calibrated.

## Selective subagent spawning

- Don't spawn agents for single-function refactors.
- Request parallel agents explicitly for 40+ file refactors.
- Phrase: "use 5 subagents to explore in parallel".
