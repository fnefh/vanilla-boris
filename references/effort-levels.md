# Effort levels

Source: howborisusesclaudecode.com §"Model & Effort Selection".

Five levels:

| Level   | When to use                                                  |
|---------|--------------------------------------------------------------|
| low     | Trivial edits, status checks, file reads                     |
| medium  | Routine implementation                                       |
| high    | Cross-file refactors, "real" features                        |
| **xhigh** | **Default for Opus 4.7.** Hard reasoning, long sessions    |
| max     | The hardest tasks. Session-scoped, does not persist.         |

Set per-session: `/effort max` (or `/effort xhigh`).

`/effort` is Anthropic-bundled; we don't ship it.

Pair with `skills/full-brief` — high-effort levels reward longer briefs.
