# Context-management commands

Source: howborisusesclaudecode.com §"Session Context Management". All
commands below are Anthropic-bundled.

## Cleanup

- **`/rewind`** (or 2× Esc) — drop the last failed attempt(s) from
  context. The math: correcting an error pollutes context with both the
  error *and* the correction; rewinding keeps only the lesson.
- **`/clear`** — wipe context entirely; write a hand-rolled brief for the
  next task. Use when starting a genuinely new task.
- **`/compact <hint>`** — lossy LLM summary of the current context. Use
  when the next task is related but you need fewer tokens. Hint shapes
  what's preserved: `/compact focus on the auth refactor, drop logging`.

## Forking & moving

- **`/branch`** — fork the current session. New branch starts from
  current state.
- **`/teleport`** (or `&`) — move the session between devices.

## Memory

- **`/memory`** — configure the built-in persistent memory.
- **`/dream`** — trigger memory consolidation (removes outdated
  entries).
- **auto-memory** — saves preferences automatically as Claude infers them.
- **auto-dream** — periodic consolidation, no command needed.

## In-flight

- **`/btw`** — side-chain a question without interrupting the current
  task. The answer comes back; the original task continues.
- **`/focus`** — hide intermediate work, show only the final result.

## Recaps

A short "what I did / what's next" summary printed when you return after
minutes/hours away. Disable in `/config` if you find them noisy.

## Auto-compact threshold

Set the env var that triggers compaction *before* the 300–400k token
"context rot" zone:

```
CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude
```

Per Thariq's recommendation; carried into `install.sh`.
