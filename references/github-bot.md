# The @claude GitHub bot

Source: howborisusesclaudecode.com §"PR Integration" + §"CLAUDE.md &
Institutional Learning".

Boris's team uses a GitHub Action that responds to `@claude` mentions in
PR comments. Common patterns:

- **"`@claude` add to CLAUDE.md"** — capture the lesson from a review
  comment into the team's CLAUDE.md immediately. Prevents the same
  mistake recurring.
- **"`@claude` review this"** — dispatch the `code-reviewer` agent on the
  PR diff.
- **"`@claude` fix lint"** — apply the bundled `/simplify` or
  `/techdebt`.

Install: `/install-github-action` from inside Claude Code. The wizard
documents this; it does not run it.

Boris calls this loop **"Compounding Engineering"** — every review
comment becomes a permanent change, so the team gets faster over time.
See `compounding-engineering.md`.
