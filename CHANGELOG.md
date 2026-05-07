# Changelog

## 0.3.0 — 2026-05-07

Site re-audit revision tracked: howborisusesclaudecode.com as of
2026-05-07 (full bullet-by-bullet inventory, ~500 distinct items),
cross-referenced with code.claude.com/docs.

Added (configurable knobs, was docs-only):
- `plugin.json` `settings.subagentStatusLine` — vanilla-boris status line.
- `plugin.json` `settings.spinnerVerbs` — 12 verification-themed verbs.
- `plugin.json` `author` and `license` metadata.

Added (hooks):
- `hooks/SessionEnd.sh` — 7th hook. One-line summary at session end.
- `hooks/PermissionRequest.sh` — opt-in (silent no-op until env var set).
  Routes permission prompts to Slack/WhatsApp/Opus.
- `hooks/Stop.sh` — extended with optional sound and Slack notification
  gates (`VANILLA_BORIS_NOTIFY_SOUND`, `VANILLA_BORIS_NOTIFY_SLACK`).

Added (skill capabilities):
- `skills/verify/SKILL.md` — `paths:` glob auto-activation
  (`*.test.*`, `*.spec.*`, `tests/**`, `__tests__/**`, `spec/**`).
- `skills/verify/SKILL.md` — `hooks:` field with session-scoped `Stop`
  hook (the on-demand hooks pattern from skill best practices).

Added (agent capabilities):
- `agents/verifier.md` — `preloadSkills: [verify]` so the verify
  context is loaded when the agent spawns.
- `agents/verifier.md` — `defaultPermissionMode: ask` to keep the
  verify gate at autonomy-ladder rung 2 even under session-wide Auto Mode.

Added (references):
- `references/env-vars.md` — high-value subset of the 102+ CLAUDE_*
  env vars.
- `references/shell-aliases.md` — Boris's `za`/`zb`/`zc` worktree-switch
  trick + idempotent setup script.
- `references/boris-named-skills.md` — attribution of skills/agents
  Boris named on his site that we did **not** ship.
- `references/cli-flags.md` — useful CLI flags (`--bare`, `--resume`,
  `--fork-session`, `-w`, `--name`, `--enable-auto-mode`, etc.).

Extended (references):
- `references/routine-recipes.md` — full connector list (GitHub, Linear,
  Slack, WhatsApp, Asana, GDrive, dbt, Grafana).
- `references/sandbox.md` — 4-layer permission mechanism (prompt-injection
  detection + static analysis + sandboxing + oversight). Auto Mode is a
  fast-path on layer 4; the other three layers are not weakened.
- `references/customization.md` — pointers to the new CLI-flag and
  shell-aliases references; documentation that status line + spinner
  verbs are now actually shipped.

Added (defaults):
- `install.sh` now writes `.claude/settings.local.json` from a template
  on first install (never overwrites). Includes
  `permissions.defaultMode: "ask"` and `cleanupPeriodDays: 30`.

Wizard: 9 steps → 12 steps. New: status line/spinner preview, shell
aliases snippet, env-vars cheatsheet pointer.

PRD §2 non-goals: extended to declare we don't shadow `/init`, `/review`,
`/security-review`, `/skills`, `/agents`, `/upgrade`, `/help`, `/desktop`,
`/add-dir`, `/remote-control`, or `/agent-teams`. `/review` and
`/security-review` are explicitly **complementary** to our
`code-reviewer` agent, not shadowed.

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
