# Compounding Engineering

Source: howborisusesclaudecode.com §"CLAUDE.md & Institutional Learning".

The pattern Boris's team practices:

1. A reviewer leaves a comment on a PR.
2. The author tags `@claude` in the comment thread: "nit: use string
   literal, not enum. @claude add to CLAUDE.md."
3. The GitHub Action (see `github-bot.md`) opens a tiny PR adding the
   convention to CLAUDE.md.
4. Future Claude sessions inherit the convention automatically.

The team contributes to CLAUDE.md "multiple times weekly". The result:
the same mistake never gets made twice. Engineering compounds.

This is a cultural pattern, not a feature this plugin installs. The
ingredients are:

- A team-shared CLAUDE.md (the `north-star` skill).
- The `@claude` GitHub bot (`/install-github-action`, see
  `github-bot.md`).
- A discipline of *adding* rather than *correcting* — when Claude makes
  the same mistake twice, that's a CLAUDE.md gap, not a Claude bug.
