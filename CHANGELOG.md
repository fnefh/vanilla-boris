# Changelog

## 0.4.2 — 2026-05-07

Revert: `marketplace.json` source form returned to `{source: "github", repo:
"fnefh/vanilla-boris"}` after `/plugin install` failed with *"This plugin
uses a source type your Claude Code version does not support. Update
Claude Code and try again."* on the `git+url` form.

The earlier v0.4.1 entry's claim that `git+url` "resolved cleanly" was based
on `/plugin marketplace add` succeeding — but that command doesn't exercise
the source-type install path. `/plugin install` was never actually verified
end-to-end on `git+url`. The `{source: "github", repo: ...}` form is the
documented primary form and is supported across all current Claude Code
versions; the `git`-source type is newer and not yet in every release.

- `.claude-plugin/marketplace.json`: revert source object to the github
  form. Same `ref: "v0.4.0"` pin.
- No CHANGELOG-worthy plugin behavior change; this is purely the install
  resolution path.

## 0.4.1 — 2026-05-07

Fix: `marketplace.json` now matches the official Anthropic schema so
`/plugin marketplace add fnefh/vanilla-boris` and `/plugin install
vanilla-boris@vanilla-boris-marketplace` resolve cleanly.

- **Path**: `marketplace.json` → `.claude-plugin/marketplace.json` (per
  code.claude.com/docs/en/plugin-marketplaces).
- **`owner`**: `"fnefh"` (string) → `{"name": "fnefh", "url": "..."}` (object).
- **`source`**: `"https://github.com/..."` (string URL) →
  `{"source": "git", "url": "https://github.com/fnefh/vanilla-boris.git", "ref": "v0.4.0"}`
  (object pinned to git tag). Confirmed working end-to-end via
  `/plugin marketplace add fnefh/vanilla-boris` (returns
  "Successfully added marketplace: vanilla-boris-marketplace") and
  `/plugin install vanilla-boris@vanilla-boris-marketplace`. The
  `{source: "github", repo: ...}` form is also accepted by the docs;
  the `git+url` form is more portable and was the one that resolved
  cleanly here.
- Pinned to git tag `v0.4.0` (created in this release).
- README quickstart now leads with the marketplace install path; manual
  `git clone` + `./install.sh` is option B.
- README troubleshooting documents the `GITHUB_TOKEN`/`GH_TOKEN` gotcha
  for background auto-updates on a private repo (manual install works
  with `gh auth` credentials; background refresh needs an explicit token).
- Tests assert the new schema (`owner.name`, `source.source`, `source.repo`).

No functional plugin changes; this is purely the install/distribution path.

## 0.4.0 — 2026-05-07

Driven by a third research pass: deep-dive into code.claude.com/docs +
@bcherny content beyond howborisusesclaudecode.com (InfoQ "Inside the
Development Workflow of Claude Code's Creator", Pragmatic Engineer
interview, Mar 30 2026 hidden-features thread transcribed at
shanraisshan/claude-code-best-practice). v0.4.0 expands the plugin's
Anthropic-supported surface area and adds a small reconstruction.

Added (top-level surfaces):
- `marketplace.json` — local-path stub. Once the repo has a public git
  URL, plugin becomes installable via `/plugin marketplace add <url>` +
  `/plugin install vanilla-boris`.
- `.claude-plugin/settings.json` — plugin-level defaults (status line,
  permission allowlist with Boris's actual `bun run build:*`,
  `bun run test:*`, `cc:*` patterns from InfoQ, spinner verbs,
  `permissions.defaultMode: "ask"`).
- `bin/vb-verify`, `bin/vb-snapshot` — bundled helpers added to the
  Bash tool's PATH while the plugin is enabled.
- `output-styles/boris-productivity.md` — opt-in voice (verification-
  first, terse, plan-then-go, bun/typecheck/squash-merge defaults).
  Activated via `/output-style boris-productivity`. Never auto-applied.
- `monitors/monitors.json` — example background monitors (build-log,
  ci-watch, verify-stream); all entries disabled by default.

Added (skills):
- `skills/learn-codebase/SKILL.md` — reconstruction of Boris's HTML-
  presentation pattern for explaining unfamiliar code (cited from the
  Mar 30 2026 thread).

Added (hooks):
- `hooks/PreCompact.sh` — 9th hook. Saves a hand-rolled session note to
  `.claude/session-notes/<sid>.md` BEFORE LLM compaction (counterpart
  to `PostCompact`).

Skill/agent capabilities now used:
- `skills/verify/SKILL.md` — `context: fork` + `agent: verifier`.
- `skills/challenge-me/SKILL.md` — `context: fork` + `model: opus`.
- `skills/full-brief/SKILL.md` — `effort: xhigh`.
- `commands/pr-pruner.md` + `commands/babysit.md` — `arguments` and
  `argument-hint`.

Hook extensions:
- `hooks/PreToolUse.sh` — narrowed nudges. Was nudging on every Bash /
  Edit / Write; now only flags actually-risky patterns (`rm -rf`,
  `git push --force`, `gh pr merge`, `sudo`, edits to `/etc`/`/usr`/
  shell-rc).
- `hooks/PostToolUse.sh` — tool-duration guardian. Hints when any tool
  call took > 5,000ms (per `CLAUDE_TOOL_DURATION_MS` from release
  notes 2.1.x).
- `hooks/Stop.sh` — Slack notification now fire-and-forget
  (backgrounded), so session-end never blocks on slow Slack DNS/TLS.

References (NEW):
- `references/cowork-dispatch.md` — Boris's daily-catch-up usage.
- `references/parallel-worktrees-vs-checkouts.md` — Boris's isolation
  trade-off note (worktrees vs full checkouts; from InfoQ).

References (EXTENDED):
- `references/shell-aliases.md` — corrected from `za/zb/zc` to Boris's
  actual `2a/2b/2c` form (per InfoQ).
- `references/recommended-mcps.md` — elevated Chrome extension over
  MCP-based browser alternatives ("more reliable" per Mar 30 thread).
- `references/loop-recipes.md` — added `/batch` scale note ("dozens,
  hundreds, or thousands" of worktree agents).

Skills extended:
- `skills/north-star/SKILL.md` — cap is now "≤ 80 lines OR ≤ 2,500
  tokens" (Boris's actual CLAUDE.md size, per InfoQ).
- `skills/plan-first/SKILL.md` — added the "10–20% of sessions
  abandoned" framing from InfoQ; re-plan over course-correct.

Default permissions extended (in `install.sh` template):
- Added `Bash(bun run build:*)`, `Bash(bun run test:*)`, `Bash(cc:*)`
  matching Boris's actual `/permissions` allowlist (per InfoQ).

Tests:
- Hook count expectation 8 → 9.
- New checks: `marketplace.json` parses, `.claude-plugin/settings.json`
  valid, `bin/` scripts executable, `output-styles/`, `monitors/`
  installed, `plugin.json.version == "0.4.0"`.
- New synthetic event in `hooks-fire.test.sh`: PreCompact writes a
  session-notes file.
- PreToolUse tests updated for the narrowed-nudge contract.

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
