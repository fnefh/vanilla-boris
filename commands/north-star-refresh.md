---
name: north-star-refresh
description: Re-run the north-star skill against this repo — useful as a periodic /loop or after a major refactor that may have invalidated the existing CLAUDE.md.
---

Invoke the `north-star` skill end-to-end. Treat the existing CLAUDE.md as
input; the skill will diff and ask before writing.

This command exists so a `/loop 1d /north-star-refresh` schedule resolves
cleanly — skills aren't natively schedulable through `/loop`.
