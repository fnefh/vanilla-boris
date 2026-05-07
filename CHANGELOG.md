# Changelog

## 0.2.0 — 2026-05-07

Site revision tracked: howborisusesclaudecode.com as of 2026-05-07.

Added (skills): verify, parallel-worktrees, full-brief, challenge-me,
auto-mode-onboarding.

Added (surfaces): commands/, agents/.

Added (hooks): SessionStart.sh, PostToolUse.sh, Stop.sh.

Added (references): routine-recipes.md, recommended-mcps.md,
skill-types-and-practices.md, context-commands.md, effort-levels.md,
opus47-shifts.md, sandbox.md, github-bot.md,
compounding-engineering.md, customization.md, worktree-recipes.md.

Moved: babysit, post-merge-sweeper, pr-pruner, slack-feedback —
relocated from skills/ to commands/ to match Boris's tweet phrasing
(`/loop 5m /babysit`).

Wizard: 5 steps → 9 steps. New: verification path, Auto Mode, @claude
bot, Routines.

Default permissions: added `Bash(bun run format *)`,
`Bash(bun run typecheck *)`, `Bash(bun run test *)`, `Bash(bq query *)`.

## 0.1.0 — initial release

The 11-habit version of the site. See git history for the v2 PRD.
