# vanilla-boris.md
> A Claude Code plugin (skills + commands + agents + hooks) that bakes in
> the working habits described on https://howborisusesclaudecode.com/ and
> in @bcherny's public threads.
>
> **v3.2 (plugin v0.4.0)** — third research pass added Anthropic-docs
> features we weren't using (marketplace.json, plugin-level
> .claude-plugin/settings.json, output-styles/, bin/, monitors/,
> PreCompact hook, skill `context: fork` + `effort` + `model`
> overrides, command `arguments` + `argument-hint`) plus Boris content
> from sources beyond his site (InfoQ "Inside the Development
> Workflow of Claude Code's Creator" Jan 2026, Pragmatic Engineer
> interview, the transcribed Mar 30 2026 hidden-features thread).
> Notable: corrected worktree aliases to Boris's actual `2a/2b/2c`
> form, extended permissions to Boris's actual `bun run build:*`/
> `cc:*` patterns, and added a `learn-codebase` reconstruction for his
> HTML-presentation pattern. Hook palette grows to 9.
>
> Drop this file into a fresh Claude Code session and say
> *"build the repo described in this PRD."*

---

## 0. Source-of-truth & honesty matrix

Each row below is one claim this PRD makes. Trust levels:

- ✅ **verbatim** from howborisusesclaudecode.com or its linked official
  docs (https://code.claude.com/docs/en/slash-commands).
- 🟡 **reconstruction** — Boris named the surface but never published its
  contents; ours is a faithful reconstruction, clearly labeled inside the
  file.
- 🟡 **ours** — team-derived default, not attributed to Boris.

| # | Claim | Source | Trust |
|---|---|---|---|
| 0.1 | The 25-habit list (north-star, three-loop, plan-mode, /go, /loop+/schedule, ultrathink, autonomy, MCP audit, autocompact, custom skills, agent recipes, **verification loop, parallel worktrees, effort levels, Opus 4.7 delegation, context-management commands, Auto Mode, sandbox, /fewer-permission-prompts, expanded hooks, agents, commands, routines, @claude bot, recommended MCPs, prompting strategies, customization**) | https://howborisusesclaudecode.com/ Parts 1–25 | ✅ verbatim from Boris's site |
| 0.2 | `CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude` ("400k is Thariq's recommended compromise") | Site Part 10, tip #4 | ✅ verbatim |
| 0.3 | "Verification multiplies output quality 2–3×" — Boris's stated #1 principle | Site §"Verification Loop" | ✅ verbatim |
| 0.4 | Boris's named loops `/loop 5m /babysit`, `/loop 30m /slack-feedback`, `/loop /post-merge-sweeper`, `/loop 1h /pr-pruner` | https://x.com/bcherny/status/2038454341884154269 (Mar 30 2026) | ✅ verbatim |
| 0.5 | The CLAUDE.md excerpt in `references/boris-claude-md.txt` | @bcherny tweet thread, Jan 2 2026 | ✅ verbatim, attributed inline |
| 0.6 | Bundled commands `/simplify /batch /debug /loop /claude-api /commit-push-pr /install-github-action /sandbox /effort /permissions /statusline /voice /color /focus /branch /teleport /rewind /memory /dream /btw /techdebt /fewer-permission-prompts /keybindings /terminal-setup /vim` | https://code.claude.com/docs/en/slash-commands | ✅ official docs |
| 0.7 | `claude --worktree <name>` and `claude --worktree <name> --tmux` | Site §"Workspace Management" | ✅ verbatim |
| 0.8 | Effort levels `low / medium / high / xhigh / max`; `xhigh` is the Opus 4.7 default; `max` is session-scoped | Site §"Model & Effort Selection" | ✅ verbatim |
| 0.9 | Auto Mode (`--enable-auto-mode`, shift+tab) classifies actions; pairs with `/fewer-permission-prompts` | Site §"Permissions & Safety" | ✅ verbatim |
| 0.10 | Hook palette: SessionStart, PreToolUse, PostToolUse, PermissionRequest, Stop, PostCompact, WorktreeCreate/Remove | Site §"Hooks & Lifecycle Logic" | ✅ verbatim |
| 0.11 | `.claude/agents/` is a separate surface from `skills/`; agents take YAML frontmatter (model, tools, isolation: worktree) | Site §"Subagents & Delegation" | ✅ verbatim |
| 0.12 | `@claude` PR mention pattern + `/install-github-action` for the bot | Site §"PR Integration" | ✅ verbatim |
| 0.13 | Recommended MCPs: Slack, BigQuery (`bq` CLI), Sentry, Chrome extension, Desktop app web servers, iMessage | Site §"Tool Integrations & MCPs" | ✅ verbatim |
| 0.14 | Routines (cloud `/schedule`): GitHub triggers (PR opened/merged, release, issue), API webhooks, cron | Site §"Long-Running Tasks & Automation" | ✅ verbatim |
| 0.15 | Context-management commands `/rewind` (or 2× Esc), `/branch`, `/teleport` (or `&`), `/focus`, `/btw`, `/compact <hint>` vs `/clear`, `/memory`, `/dream`, recaps | Site §"Session Context Management" | ✅ verbatim |
| 0.16 | Opus 4.7 behavioral shifts: delegate-don't-pair-program, full briefs upfront, fewer interruptions, less auto-tool usage, selective subagent spawning | Site §"Key Behavioral Shifts for Opus 4.7" | ✅ verbatim |
| 0.17 | 9-type skill taxonomy + skill best practices (skip-the-obvious, "Gotchas", progressive disclosure, don't-railroad, description-as-trigger, `${CLAUDE_PLUGIN_DATA}`, helper code, on-demand hooks) | Site §"Skill Development & Distribution" | ✅ verbatim |
| 0.18 | Prompting patterns: "Grill me on these changes", "Prove to me this works", "Knowing what you know now, scrap this and implement elegantly", spec-first | Site §"Prompting Strategies" | ✅ verbatim |
| 0.19 | `/babysit`, `/go`, `/post-merge-sweeper`, `/pr-pruner`, `/slack-feedback`, `/verify`, `/full-brief`, `/challenge-me` | **Boris named some of these by hand on his site/tweets but never published their contents.** This plugin's versions are *our faithful reconstructions* based only on what their names + surrounding context describe. Each file opens with a "Reconstruction notice." | 🟡 reconstruction |
| 0.20 | Sample agents (`code-reviewer`, `verifier`, `simplifier`) | Modeled on Boris's site descriptions; bodies are ours | 🟡 reconstruction |
| 0.21 | Hook contents (UserPromptSubmit, PreToolUse, PostToolUse, PostCompact, SessionStart, Stop) | Behavior is described on the site; exact shell is ours | 🟡 ours |
| 0.22 | Wizard, install/uninstall, tests, default permissions | Team-derived defaults | 🟡 ours |
| 0.23 | **Status line template** (`vanilla-boris ▸ {model} ▸ {context_pct}% ▸ {git_branch} ▸ {cost}`) | Site §"Customization & Configuration" specifies these 4 fields verbatim; the template wording is ours | ✅ verbatim fields, 🟡 ours wording |
| 0.24 | **12 verification-themed spinner verbs** | Site mentions spinner verbs are customizable (Star Trek example); our list is verification-themed to match the plugin's #1 principle | 🟡 ours |
| 0.25 | **`SessionEnd` hook (the 7th hook type)** | Implied by `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` in code.claude.com/docs; site lists SessionStart but not SessionEnd | ✅ docs-derived |
| 0.26 | **`PermissionRequest` routing to Slack/WhatsApp/Opus** | Site §"Hooks & Lifecycle Logic" verbatim cites this routing | ✅ verbatim, 🟡 our shell impl |
| 0.27 | **`paths:` glob auto-activation on `verify` skill** | Skill frontmatter feature in code.claude.com/docs; the choice to apply it to `verify` (test-file globs) is ours | ✅ docs-derived, 🟡 our paths list |
| 0.28 | **On-demand hooks scoped to a skill** (`hooks:` field on `verify`) | Site §"Skill Development & Distribution" best practices verbatim | ✅ verbatim |
| 0.29 | **`preloadSkills` on `verifier` agent** | Agent frontmatter feature in code.claude.com/docs | ✅ docs-derived |
| 0.30 | **102+ env vars cheatsheet** (`references/env-vars.md`) | Site says "84 environment variables"; full list is in code.claude.com/docs | ✅ docs-derived |
| 0.31 | **Worktree shell aliases (`za`/`zb`/`zc`)** | Site §"Workspace Management" verbatim | ✅ verbatim |
| 0.32 | **4-layer permission mechanism** (prompt-injection detection + static analysis + sandboxing + oversight) | Site §"Permissions & Safety" verbatim — auto mode is fast-path on layer 4 | ✅ verbatim |
| 0.33 | **Routine connector list** (GitHub, Linear, Slack, WhatsApp, Asana, GDrive, dbt, Grafana) | Site §"Tool Integrations & MCPs" verbatim | ✅ verbatim |
| 0.34 | **Boris-named-skills attribution** (`references/boris-named-skills.md`) | Names cited verbatim from site; this is *attribution*, not reconstruction | ✅ verbatim names |
| 0.35 | **`marketplace.json`** at repo root for `/plugin install` distribution | code.claude.com/docs/en/plugins | ✅ docs-derived |
| 0.36 | **`.claude-plugin/settings.json`** plugin-level defaults | code.claude.com/docs/en/plugins ("Ship default settings with your plugin") | ✅ docs-derived |
| 0.37 | **`bin/` directory** auto-added to Bash PATH | code.claude.com/docs/en/plugins-reference | ✅ docs-derived feature; `vb-verify` / `vb-snapshot` bodies are 🟡 ours |
| 0.38 | **`output-styles/boris-productivity.md`** | code.claude.com/docs/en/output-styles (feature); voice content reconstructed from site + Jan 2 CLAUDE.md excerpt | ✅ feature, 🟡 voice reconstruction |
| 0.39 | **`monitors/monitors.json`** background-command monitors | code.claude.com/docs/en/plugins ("Add background monitors to your plugin") | ✅ docs-derived (entries are 🟡 ours, all disabled) |
| 0.40 | **`PreCompact` hook** as 9th hook type | code.claude.com/docs/en/hooks-reference | ✅ docs-derived |
| 0.41 | **Skill `context: fork`** on `verify` and `challenge-me` | code.claude.com/docs/en/skills ("Run skills in a subagent") | ✅ docs-derived |
| 0.42 | **Skill `effort` / `model` overrides** on `full-brief` and `challenge-me` | code.claude.com/docs/en/skills | ✅ docs-derived |
| 0.43 | **Command `arguments` + `argument-hint`** on `pr-pruner` and `babysit` | code.claude.com/docs/en/skills (commands share frontmatter) | ✅ docs-derived |
| 0.44 | **Boris's CLAUDE.md size: ~2,500 tokens** | InfoQ "Inside the Development Workflow of Claude Code's Creator" (Jan 2026 interview) | ✅ verbatim from interview |
| 0.45 | **Boris's worktree aliases: `2a` / `2b` / `2c`** | InfoQ + Mar 30 2026 thread (transcribed in shanraisshan/claude-code-best-practice) | ✅ verbatim |
| 0.46 | **Boris's `/permissions` allow patterns: `bun run build:*`, `bun run test:*`, `cc:*`** | InfoQ | ✅ verbatim |
| 0.47 | **10–20% of sessions abandoned** when plan diverges | InfoQ | ✅ verbatim |
| 0.48 | **`/batch` scale: "dozens, hundreds, or thousands"** of worktree agents | Mar 30 2026 thread | ✅ verbatim |
| 0.49 | **Chrome extension > MCP-based browser tools** for verification | Mar 30 2026 thread | ✅ verbatim |
| 0.50 | **Cowork Dispatch daily usage** for Slack/email/file catch-up | Mar 30 2026 thread | ✅ verbatim |
| 0.51 | **HTML-presentation pattern** for explaining unfamiliar code | Mar 30 2026 thread (`learn-codebase` skill is our reconstruction) | ✅ verbatim pattern, 🟡 our reconstruction |
| 0.52 | **PreToolUse narrowing** to actually-risky patterns | code.claude.com/docs/en/permissions ("permission rule syntax" `if:` filter) — emulated in shell hook | ✅ docs-derived feature, 🟡 our shell impl |
| 0.53 | **PostToolUse `duration_ms` perf guardian** | code.claude.com release notes 2.1.x | ✅ docs-derived |
| 0.54 | **Async Stop.sh Slack notify** (fire-and-forget) | code.claude.com/docs/en/hooks `async: true`; emulated in shell with `&` | ✅ docs-derived |

**What we will not do:** claim authorship of anything Boris wrote, ship his
private files, enable `--dangerously-skip-permissions` by default, install
MCP credentials silently, auto-install the `@claude` GitHub bot, auto-flip
Auto Mode or sandbox, or bypass Claude Code's classifiers.

---

## 1. Why this plugin exists

Boris's site is a high-quality habit set, but it lives as prose. Every team
rediscovers the same defaults — north-star CLAUDE.md, three-loop
edit/test/PR cadence, plan-mode-by-default, autocompact at 400k, the
verification loop, parallel worktrees, named /loop schedules, the @claude
bot — by trial and error.

`vanilla-boris` packages those habits as **skills** (long-form content),
**commands** (repeat-invocation team conveniences), **agents** (delegated
work surfaces), **hooks** (lifecycle logic), and one **wizard**, so a new
repo can opt in with a single command and inherit Boris-flavored defaults
without giving up Claude Code's safety model.

**v3 vs v2.** v2 covered the original 11-habit site. v3 covers the current
~25-habit site. The expansion is additive: every v2 surface is preserved
unchanged unless a habit's natural home moved (the four named-loop
reconstructions relocate from `skills/` to `commands/`, since
`/loop 5m /babysit` resolves more cleanly against a command).

---

## 2. Non-goals

1. **Don't replace Anthropic's bundled commands.** We compose with them; we
   never shadow them. The bundled set we explicitly defer to:
   `/simplify`, `/batch`, `/debug`, `/loop`, `/claude-api`,
   `/commit-push-pr`, `/install-github-action`, `/sandbox`, `/effort`,
   `/permissions`, `/statusline`, `/voice`, `/color`, `/focus`, `/branch`,
   `/teleport`, `/rewind`, `/memory`, `/dream`, `/btw`, `/techdebt`,
   `/fewer-permission-prompts`, `/keybindings`, `/terminal-setup`, `/vim`,
   `/init`, `/skills`, `/agents`, `/upgrade`, `/help`, `/desktop`,
   `/add-dir`, `/remote-control`, `/agent-teams`. Two of these
   (`/review`, `/security-review`) are bundled review commands that
   **complement** our `code-reviewer` agent — Boris uses both. Our
   agent is not a replacement; it's a different shape (multi-concern
   diff review with `isolation: worktree`).
2. **Don't ship Boris's private skills.** `/babysit`, `/go`,
   `/post-merge-sweeper`, `/pr-pruner`, `/slack-feedback`, `/verify`,
   `/full-brief`, `/challenge-me` are reconstructions, plainly labeled.
3. **Don't auto-approve destructive tools.** `allowed-tools` is scoped to
   the minimum each surface needs.
4. **Don't auto-install the `@claude` GitHub bot.** The wizard explains it
   and runs `/install-github-action` only on explicit confirmation.
5. **Don't auto-enable Auto Mode or sandboxing.** Both are surfaced in the
   wizard with documentation links; the user flips them.
6. **Don't auto-install MCP credentials.** `mcp-audit` is read-only.
7. **Don't become a framework.** Everything is plain Markdown + a few
   shell scripts; uninstall is `rm -rf .claude/skills/vanilla-boris*`
   plus the corresponding `commands/`, `agents/`, `hooks/`.

---

## 3. The 25 habits → skill / command / agent / hook / reference mapping

Severity tags: **P0** = principle-level, **P1** = significant-workflow,
**P2** = customization / nice-to-have.

### Principles

| # | Habit | Severity | Where |
|---|---|---|---|
| 1 | North-star CLAUDE.md — short, factual, top-of-context | P0 | `skills/north-star/SKILL.md` (writes/edits CLAUDE.md), wizard step 1 |
| 2 | Three-loop cadence — edit / test / PR | P0 | `skills/three-loop/SKILL.md` (`user-invocable: false`) |
| 3 | Plan mode by default for non-trivial work | P0 | `skills/plan-first/SKILL.md` + `hooks/UserPromptSubmit.sh` nudge |
| 4 | **Verification loop** — give Claude a way to verify its work (Boris #1) | **P0 NEW** | `skills/verify/SKILL.md` (reconstruction) + `agents/verifier.md` + `hooks/Stop.sh` (nudge before declaring done) |
| 5 | **Parallel worktrees** — `claude --worktree`, 5+ instances in tabs | **P0 NEW** | `skills/parallel-worktrees/SKILL.md` + `references/worktree-recipes.md` |
| 6 | **Effort levels** — `low/medium/high/xhigh/max`, `/effort max` per session | **P1 NEW** | `references/effort-levels.md` (docs-only — `/effort` is bundled) |
| 7 | **Opus 4.7 delegation shifts** — full brief upfront, fewer interruptions, judicious tool use | **P1 NEW** | `skills/full-brief/SKILL.md` (reconstruction) + `references/opus47-shifts.md` |
| 8 | Ultrathink for hard reasoning | P1 | mentioned in `skills/plan-first/SKILL.md` per the docs ("include `ultrathink` anywhere in the skill content") |
| 9 | Autonomy ladder — read-only → suggest → apply → commit | P1 | `skills/autonomy-ladder/SKILL.md` + `hooks/PreToolUse.sh` reminder |
| 10 | `/go` — "just do the obvious next thing" | P1 | `skills/go/SKILL.md` (reconstruction) |

### Context management

| # | Habit | Severity | Where |
|---|---|---|---|
| 11 | `/rewind` over correction (or 2× Esc) | P1 | `references/context-commands.md` |
| 12 | `/branch`, `/teleport`, `/focus`, `/btw` | P1/P2 | `references/context-commands.md` |
| 13 | `/compact <hint>` vs `/clear` | P1 | `references/context-commands.md` |
| 14 | `/memory`, `/dream`, auto-memory, auto-dream | P1 | `references/context-commands.md` |
| 15 | 400k autocompact threshold | P0 | `install.sh` (verbatim line) + wizard step |
| 16 | Recaps | P2 | `references/context-commands.md` |

### Permissions & safety

| # | Habit | Severity | Where |
|---|---|---|---|
| 17 | MCP audit before enabling | P1 | `skills/mcp-audit/SKILL.md` + wizard step |
| 18 | **Auto Mode** — classifier-based safe-action approval | **P0 NEW** | `skills/auto-mode-onboarding/SKILL.md` + wizard step |
| 19 | **`/sandbox`** runtime (file+net isolation) | **P1 NEW** | `references/sandbox.md` + wizard step (docs-only) |
| 20 | **`/fewer-permission-prompts`** to tune allowlist | **P1 NEW** | wizard step (docs-only) |

### Long-running tasks

| # | Habit | Severity | Where |
|---|---|---|---|
| 21 | `/loop` recipes — Boris's four named loops | P1 | `references/loop-recipes.md` + the four reconstructions in `commands/` |
| 22 | **Routines (cloud `/schedule`)** — GitHub triggers, webhooks, cron | **P1 NEW** | `references/routine-recipes.md` |

### Distribution & integrations

| # | Habit | Severity | Where |
|---|---|---|---|
| 23 | **`@claude` GitHub bot** + `/install-github-action` | **P0 NEW** | `references/github-bot.md` + wizard step |
| 24 | **Recommended MCPs** — Slack, BigQuery, Sentry, Chrome ext, Desktop app, iMessage | **P1 NEW** | `references/recommended-mcps.md` |
| 25 | **Compounding Engineering** — team contributes to CLAUDE.md weekly | **P2 NEW** | `references/compounding-engineering.md` |

### Authoring tooling

- Custom skills > rerunning prose prompts → the whole plugin is the example;
  `skills/skill-author/SKILL.md` codifies Thariq's 9 rules.
- 9-type skill taxonomy + best practices →
  `references/skill-types-and-practices.md` (NEW).

### Prompting patterns (NEW)

- "Grill me on these changes" / "Prove to me this works" / "Knowing what
  you know now, scrap this and implement elegantly" / spec-first →
  `skills/challenge-me/SKILL.md` (reconstruction).

### Customization (mixed: shipped + docs-only)

| # | Item | Severity | Where |
|---|---|---|---|
| 26 | **Status line** (subagent-scoped) | **P0 NEW in v0.3.0** | `plugin.json` `settings.subagentStatusLine` + `references/customization.md` (session-wide via `/statusline`) |
| 27 | **Spinner verbs** (12 verification-themed) | **P1 NEW in v0.3.0** | `plugin.json` `settings.spinnerVerbs` |
| 28 | **`SessionEnd` hook** | **P0 NEW in v0.3.0** | `hooks/SessionEnd.sh` |
| 29 | **`paths:` auto-activation on `verify`** | **P0 NEW in v0.3.0** | `skills/verify/SKILL.md` |
| 30 | **On-demand hooks** (`hooks:` field on `verify`) | **P1 NEW in v0.3.0** | `skills/verify/SKILL.md` |
| 31 | **`preloadSkills` on `verifier` agent** | **P1 NEW in v0.3.0** | `agents/verifier.md` |
| 32 | **`PermissionRequest` routing** (opt-in) | **P1 NEW in v0.3.0** | `hooks/PermissionRequest.sh` |
| 33 | **`Stop.sh` notifications** (sound + Slack, opt-in) | **P2 NEW in v0.3.0** | `hooks/Stop.sh` |
| 34 | **102+ env vars cheatsheet** | **P2 NEW in v0.3.0** | `references/env-vars.md` |
| 35 | **Worktree shell aliases** (`za`/`zb`/`zc`) | **P2 NEW in v0.3.0** | `references/shell-aliases.md` |
| 36 | **CLI flag docs** (`--bare`, `--resume`, `-w`, etc.) | **P2 NEW in v0.3.0** | `references/cli-flags.md` |
| 37 | **Boris-named-skills attribution** | **P2 NEW in v0.3.0** | `references/boris-named-skills.md` |
| 38 | **Routine connectors expanded** (GH/Linear/Slack/WA/Asana/GDrive/dbt/Grafana) | P1 NEW in v0.3.0 | `references/routine-recipes.md` |
| 39 | **4-layer permission mechanism** (PI detection + static + sandbox + oversight) | P1 NEW in v0.3.0 | `references/sandbox.md` |
| 40 | **Default settings.local.json template** (writes `permissions.defaultMode: "ask"`) | P1 NEW in v0.3.0 | `install.sh` |
| 41 | Output styles, voice, vim, fast mode, keybindings, recaps | P2 docs-only | `references/customization.md` |

---

## 4. File tree

```
vanilla-boris/
├── README.md
├── LICENSE                            # MIT (covers our reconstructions only;
│                                      #  references/boris-claude-md.txt is
│                                      #  quoted under fair-use, attributed)
├── CHANGELOG.md                       # NEW in v3 — tracks site revisions
├── install.sh
├── uninstall.sh
├── wizard.ts                          # bun run wizard.ts
├── plugin.json                        # 0.2.0
│
├── skills/
│   ├── north-star/SKILL.md
│   ├── three-loop/SKILL.md
│   ├── plan-first/SKILL.md
│   ├── go/SKILL.md                    # reconstruction
│   ├── verify/SKILL.md                # NEW — reconstruction
│   ├── parallel-worktrees/SKILL.md    # NEW
│   ├── full-brief/SKILL.md            # NEW — reconstruction (Opus 4.7)
│   ├── challenge-me/SKILL.md          # NEW — reconstruction
│   ├── autonomy-ladder/SKILL.md
│   ├── mcp-audit/SKILL.md
│   ├── auto-mode-onboarding/SKILL.md  # NEW
│   └── skill-author/SKILL.md
│
├── commands/                          # NEW surface in v3
│   ├── babysit.md                     # moved from skills/, reconstruction
│   ├── post-merge-sweeper.md          # moved, reconstruction
│   ├── pr-pruner.md                   # moved, reconstruction
│   ├── slack-feedback.md              # moved, reconstruction
│   └── north-star-refresh.md          # NEW thin wrapper
│
├── agents/                            # NEW surface in v3
│   ├── code-reviewer.md
│   ├── verifier.md
│   └── simplifier.md
│
├── hooks/
│   ├── UserPromptSubmit.sh
│   ├── PreToolUse.sh
│   ├── PostToolUse.sh                 # NEW in v0.2.0
│   ├── SessionStart.sh                # NEW in v0.2.0
│   ├── SessionEnd.sh                  # NEW in v0.3.0
│   ├── Stop.sh                        # NEW in v0.2.0; extended in v0.3.0
│   ├── PostCompact.sh
│   └── PermissionRequest.sh           # NEW in v0.3.0 (opt-in)
│
├── references/
│   ├── boris-claude-md.txt            # verbatim @bcherny excerpt + attribution
│   ├── loop-recipes.md                # the four named loops, verbatim
│   ├── thariq-skill-rules.md          # the 9 rules, paraphrased + cited
│   ├── routine-recipes.md             # NEW — cloud /schedule
│   ├── recommended-mcps.md            # NEW
│   ├── skill-types-and-practices.md   # NEW — 9-type taxonomy
│   ├── context-commands.md            # NEW — /rewind, /branch, etc.
│   ├── effort-levels.md               # NEW
│   ├── opus47-shifts.md               # NEW
│   ├── sandbox.md                     # NEW
│   ├── github-bot.md                  # NEW
│   ├── compounding-engineering.md     # NEW
│   ├── customization.md               # NEW in v0.2.0; extended in v0.3.0
│   ├── worktree-recipes.md            # NEW in v0.2.0
│   ├── env-vars.md                    # NEW in v0.3.0
│   ├── shell-aliases.md               # NEW in v0.3.0
│   ├── boris-named-skills.md          # NEW in v0.3.0
│   └── cli-flags.md                   # NEW in v0.3.0
│
└── tests/
    ├── install.test.sh
    ├── skills-load.test.sh            # `claude --print "/skills"` smoke test
    ├── commands-load.test.sh          # NEW
    ├── agents-load.test.sh            # NEW
    └── hooks-fire.test.sh             # extended for SessionStart/PostToolUse/Stop
```

---

## 5. `plugin.json`

```json
{
  "name": "vanilla-boris",
  "version": "0.3.0",
  "description": "Boris-flavored defaults: north-star CLAUDE.md, three-loop cadence, plan-first, verification loop (with paths: auto-activation), parallel worktrees, autonomy ladder, MCP audit, Auto Mode onboarding, 400k autocompact, the four reconstructed /loop commands, sample agents (with preloadSkills), an expanded 7-hook palette including SessionEnd, a vanilla-boris status line, and verification-themed spinner verbs.",
  "author": {
    "name": "vanilla-boris contributors"
  },
  "license": "MIT",
  "skills": "./skills",
  "commands": "./commands",
  "agents": "./agents",
  "hooks": "./hooks",
  "settings": {
    "subagentStatusLine": "vanilla-boris ▸ {model} ▸ {context_pct}% ▸ {git_branch} ▸ {cost}",
    "spinnerVerbs": [
      "verifying",
      "checking",
      "auditing",
      "inspecting",
      "tracing",
      "validating",
      "scrutinizing",
      "weighing",
      "probing",
      "testing",
      "rehearsing",
      "double-checking"
    ]
  }
}
```

The `settings.subagentStatusLine` and `settings.spinnerVerbs` fields are
**subagent-scoped** — they apply when our agents (`code-reviewer`,
`verifier`, `simplifier`) spawn but do not override the user's
session-wide status line. To set those session-wide, use `/statusline`
or write `statusLine` and `spinnerVerbs` to the user's `settings.json`
directly.

---

## 6. Skill files

> All skills follow the official frontmatter spec from
> https://code.claude.com/docs/en/slash-commands. Only `description` is
> strictly required; we use `disable-model-invocation`, `allowed-tools`,
> `context: fork`, `agent`, and `paths` where they earn their keep.

### 6.1 `skills/north-star/SKILL.md`

```markdown
---
name: north-star
description: Write or refresh the project's CLAUDE.md as a short, factual north-star — the kind of file that survives auto-compaction and tells future-you (and Claude) the few non-obvious facts about this repo. Use when starting a new repo, when CLAUDE.md drifts past ~80 lines, or when the user says "update CLAUDE.md".
disable-model-invocation: true
allowed-tools: Read Edit Write Bash(git ls-files *)
---

## Repo snapshot
- Tracked files: !`git ls-files | wc -l`
- Top-level entries: !`ls -1`
- Existing CLAUDE.md (if any): !`test -f CLAUDE.md && cat CLAUDE.md || echo "(none)"`

## Instructions

Produce a CLAUDE.md that obeys the north-star rule from
howborisusesclaudecode.com Part 1: **short, factual, durable**.

Sections, in order, each one paragraph or fewer:

1. **What this repo is** — one sentence.
2. **How to run / test / lint** — exact shell commands. Cite verbatim from
   `package.json`, `Makefile`, or equivalent. Do not invent commands.
3. **Conventions that aren't obvious** — only the ones a new contributor
   would otherwise get wrong (e.g. "we use `bun`, not `npm`"; "all PRs
   squash-merge"; "tests live next to source as `*.test.ts`").
4. **Where the load-bearing code is** — 3–6 paths, no more.
5. **How to verify a change works** — the verify command (`bun test`,
   `bun typecheck`, browser URL, etc.). Pairs with `skills/verify`.
6. **What this file is not** — one line: "Not a tutorial. Not a changelog.
   Not a tour."

Hard caps:
- ≤ 80 lines total.
- No emoji, no marketing language, no "this project aims to…".
- Every command must be runnable as written.

If the existing CLAUDE.md already satisfies these rules, say so and exit
without editing. If you propose changes, show a diff first and ask before
writing.

For the canonical example of what a tight CLAUDE.md looks like, see
`${CLAUDE_SKILL_DIR}/../../references/boris-claude-md.txt` (verbatim
excerpt from @bcherny's Jan 2 2026 thread, used here for reference only).
```

### 6.2 `skills/three-loop/SKILL.md`

```markdown
---
name: three-loop
description: Reference content describing the edit / test / PR three-loop cadence. Loads automatically when the user is talking about workflow, code review cadence, or "how should I structure this work".
user-invocable: false
---

The three loops, per howborisusesclaudecode.com Part 2:

- **Edit loop** — seconds. Make the smallest change that compiles. Run the
  type-checker. Repeat. Don't open the test runner.
- **Test loop** — minutes. Run the targeted tests for the file you touched.
  If they pass, run the next ring out. Don't run the whole suite yet.
- **PR loop** — tens of minutes. Whole suite, lint, format, then open PR.
  This is the loop where you stop and read your own diff.

Implication for Claude: prefer narrowing before widening. When asked to
"fix the bug", stay in the edit loop until type-check passes; only then
escalate to the test loop; only then to the PR loop.
```

### 6.3 `skills/plan-first/SKILL.md`

```markdown
---
name: plan-first
description: For any non-trivial change (more than one file, or any change to schemas, configs, public APIs, or auth), produce a plan before editing. Use when the user describes a feature, refactor, migration, or anything ambiguous.
---

For non-trivial work, produce a plan **before** editing files. The plan is:

1. **Goal** — one sentence.
2. **Files I will touch** — bullet list with one-line reason each.
3. **Files I will read but not touch.**
4. **Risks** — at least one. "None" is rarely true.
5. **Tests** — what passes proves this is done. Cite the verify command.
6. **Verification path** — see `skills/verify`. If unknown, ask.

Show the plan, ask "go?", and only proceed on an affirmative answer.

For genuinely hard reasoning (algorithm choice, cross-cutting refactors,
"why is this slow"), include the literal token `ultrathink` somewhere in
your reply — per the official skills docs, this requests deeper reasoning.

Trivial changes that skip this skill: typo fixes, single-file <10-line
edits, comment-only changes, dependency bumps already in `package.json`.

Per howborisusesclaudecode.com Part 3: re-plan when reality diverges from
the plan, rather than course-correcting one step at a time.
```

### 6.4 `skills/go/SKILL.md`  *(reconstruction)*

```markdown
---
name: go
description: "Just do the obvious next thing." Reconstruction of the /go shortcut Boris referenced on his site. Use when the user has reviewed a plan and wants execution to proceed without further confirmation on each step.
disable-model-invocation: true
---

> **Reconstruction notice.** Boris referenced `/go` on
> howborisusesclaudecode.com but did not publish its contents. This is our
> faithful reconstruction based on the surrounding context (it's the
> "execute the plan we just agreed on" companion to plan-mode).

Execute the most recently agreed-upon plan. Concretely:

1. Re-state the plan in one sentence so the user can interrupt if you've
   drifted.
2. Work through the plan's file list in order.
3. After each file, run the narrowest applicable check (type-check for a
   `.ts` edit, the file's own test for a `.test.ts`, etc.) — see the
   `three-loop` skill.
4. When the plan's last step is done, **run the verify command** before
   declaring success — see `skills/verify`. Do not skip this.
5. Stop and report when the plan is done **or** when reality diverges from
   the plan (a file you expected to exist doesn't, a test fails in a way
   the plan didn't anticipate). Do not improvise past the plan's edge.

`/go` is not a license to escalate autonomy. Tools you'd normally ask
about (destructive Bash, network, package installs) still require
approval. See the `autonomy-ladder` skill.
```

### 6.5 `skills/verify/SKILL.md`  *(reconstruction, NEW in v3)*

```markdown
---
name: verify
description: Run this project's verification path — the command(s) that prove a change actually works (tests, type-check, browser check, BQ query, computer-use). Use after any non-trivial edit, before declaring "done", and as the gate inside /go. Pairs with hooks/Stop.sh.
disable-model-invocation: true
allowed-tools: Read Bash(bun *) Bash(npm test*) Bash(pnpm test*) Bash(yarn test*) Bash(make *) Bash(pytest *) Bash(go test *) Bash(cargo test *) Bash(curl -s localhost:*)
---

> **Reconstruction notice.** Boris calls the verification loop his #1
> principle ("2–3× quality multiplier") on howborisusesclaudecode.com but
> did not publish a `/verify` skill. This is our reconstruction.

## Verify command for this project
- Declared in CLAUDE.md? !`grep -A1 -i 'verif\|how to verify\|run / test' CLAUDE.md 2>/dev/null || echo "(not declared)"`
- `package.json` test/typecheck scripts: !`test -f package.json && jq -r '.scripts // {} | to_entries[] | select(.key | test("test|typecheck|lint|check")) | "\(.key): \(.value)"' package.json 2>/dev/null || echo "(no package.json)"`
- `Makefile` targets: !`test -f Makefile && grep -E '^[a-zA-Z_-]+:' Makefile | head -10 || echo "(no Makefile)"`

## Instructions

Boris's site Part: **"give Claude a way to verify its work"**. The
verification loop is domain-specific:

- **Backend** — test runner + a synthetic request via `curl` or the test
  client.
- **Frontend** — build, then a browser check (Chrome extension MCP if
  available, otherwise a screenshot via `playwright` / Puppeteer / the
  Desktop app).
- **CLI / library** — type-check + targeted test + one end-to-end
  invocation against a real fixture.
- **Data / analytics** — a `bq` query or equivalent that returns a known
  shape; diff against a fixture.
- **Desktop app** — computer-use to drive the UI.

Workflow:

1. If CLAUDE.md declares a verify command, run *that* (verbatim).
2. Otherwise, infer the smallest credible verify command from the snapshot
   above and ask the user to confirm before running.
3. Run it. Read the output. **Do not** declare success based on "the
   command exited 0" alone — confirm the output matches the change.
4. If verification fails, do **not** patch the test to make it pass.
   Re-plan (see `skills/plan-first`).
5. After verification passes, summarize: command, exit code, the one or
   two output lines that actually prove the change works.

This skill exists to break the failure mode where Claude declares "done"
based on its own narration. Verification beats narration.
```

### 6.6 `skills/parallel-worktrees/SKILL.md`  *(NEW in v3)*

```markdown
---
name: parallel-worktrees
description: How to run multiple Claude Code instances in parallel via git worktrees, when to use them, and how to keep them from stepping on each other. Use when the user is about to start two or more independent threads of work, or asks "can I run multiple Claudes".
disable-model-invocation: true
allowed-tools: Bash(git worktree *) Bash(claude --worktree *)
---

## Current worktrees
!`git worktree list 2>/dev/null || echo "(not a git repo or git too old)"`

## Instructions

Per howborisusesclaudecode.com §"Workspace Management": Boris runs 5+
Claude Code instances in parallel using git worktrees. Each worktree is an
isolated checkout — same `.git`, separate working tree — so two Claudes
editing two features cannot collide.

When to spin up a worktree:

- **Independent features** — two unrelated tickets, two PRs.
- **A long-running task in the background** — `/loop`, an experiment, a
  big migration.
- **A spike** — try an approach you might throw away.

When **not** to:

- **Fixing a bug in code another Claude is currently editing.** Wait or
  rebase. Worktrees don't fix merge conflicts, they avoid them.

Workflow:

1. Create the worktree:
   ```
   git worktree add ../<repo>-<feature> -b <feature-branch>
   ```
2. Start Claude in it:
   ```
   claude --worktree <name>           # plain
   claude --worktree <name> --tmux    # in a tmux session
   ```
3. Or use the Desktop app's "Code" tab → check the "worktree" checkbox.
4. Each worktree gets its own `.claude/settings.local.json` if needed.
   The repo's `.claude/skills/`, `.claude/agents/`, `.claude/commands/`,
   `.claude/hooks/` are shared.
5. When done: merge the branch, then
   `git worktree remove ../<repo>-<feature>`.

For agents, set `isolation: worktree` in the agent's frontmatter (see
`agents/verifier.md` for an example). The agent's tool calls run inside an
auto-managed worktree and the worktree is cleaned up if the agent makes no
changes.

See `references/worktree-recipes.md` for non-git VCS support
(WorktreeCreate / WorktreeRemove hooks for Mercurial, Perforce, Juju).
```

### 6.7 `skills/full-brief/SKILL.md`  *(reconstruction, NEW in v3)*

```markdown
---
name: full-brief
description: Write a full-context brief before delegating to Claude — goal, constraints, acceptance criteria, verification path. Reconstruction of the Opus 4.7 delegation pattern Boris describes ("treat Claude like an engineer you delegate to, not a pair programmer"). Use when the user is about to start a non-trivial task or said "delegate this".
disable-model-invocation: true
---

> **Reconstruction notice.** howborisusesclaudecode.com §"Key Behavioral
> Shifts for Opus 4.7" describes the pattern but does not publish a skill.

Opus 4.7 reasons more before calling tools and is more judicious about
spawning subagents. The corresponding shift for the user: write a crisp
brief upfront and launch, instead of pair-programming step-by-step.

A full brief is:

1. **Goal** — one sentence. What "done" looks like.
2. **Constraints** — non-goals, untouched files, contracts, performance
   ceilings, "don't change the schema".
3. **Acceptance criteria** — verifiable. Cite the verify command (see
   `skills/verify`).
4. **Inputs** — paths, fixtures, sample data.
5. **Output format** — diff, PR, file list.
6. **Effort level** — `xhigh` (default for Opus 4.7) or `max` for the
   hardest tasks. See `references/effort-levels.md`.
7. **Subagent budget** — "use up to N subagents" or "don't spawn
   subagents for this". Opus 4.7 will not spawn agents for trivial work
   unless asked.

Workflow:

- If the user gave a one-liner, ask one round of clarifying questions
  before writing the brief. After that, stop asking and write.
- Show the brief, ask "go?", and proceed on yes.
- During execution, do not interrupt for routine decisions — make them
  and surface them in the final report. Reserve interruptions for
  irrecoverable forks (deleting data, modifying schemas, mass file
  moves).

This skill composes with `plan-first`: brief is the *what*, plan is the
*how*.
```

### 6.8 `skills/challenge-me/SKILL.md`  *(reconstruction, NEW in v3)*

```markdown
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
```

### 6.9 `skills/autonomy-ladder/SKILL.md`

```markdown
---
name: autonomy-ladder
description: Reference content for the four-rung autonomy ladder (read-only → suggest → apply → commit). Loaded automatically when the user discusses permissions, automation, or "what should Claude be allowed to do".
user-invocable: false
---

Per howborisusesclaudecode.com Part 7, autonomy is a ladder, not a switch:

1. **Read-only.** Default for unfamiliar repos. Claude reads, summarizes,
   proposes diffs in chat. The user applies them.
2. **Suggest.** Claude proposes Edits and waits for approval per call.
3. **Apply.** Claude edits files autonomously but does not run shell
   commands beyond `allowed-tools` rules.
4. **Commit.** Claude can run `git commit` (but not `push`, not `gh pr
   merge`, not `rm -rf`).

Rules:
- Never auto-promote. Promotion is always an explicit user decision.
- `--dangerously-skip-permissions` belongs nowhere in this plugin.
- New MCP servers default to read-only. See `mcp-audit`.
- **Auto Mode** (see `skills/auto-mode-onboarding`) sits *alongside* the
  ladder, not above it. It approves the obviously-safe; the ladder
  governs everything else.
```

### 6.10 `skills/mcp-audit/SKILL.md`

```markdown
---
name: mcp-audit
description: Walk through every MCP server installed in this Claude Code session and decide whether to keep it, scope it down, or remove it. Use before trusting a new repo, after installing anything from a tutorial, or when the user says "what does Claude have access to".
disable-model-invocation: true
allowed-tools: Bash(claude mcp list)
---

## Installed MCP servers
!`claude mcp list 2>/dev/null || echo "(claude mcp list not available — check ~/.claude/mcp.json manually)"`

## Instructions

For each server above, ask the user:

1. **What does it do?** (One sentence. If unknown, look it up — don't
   guess.)
2. **What's the smallest scope it needs?** (Read-only? One repo? One
   directory?)
3. **Where do its credentials come from?** (Env var the user controls, or
   a file Claude can read?)
4. **Keep / scope-down / remove?**

Do not add, modify, or remove MCP credentials yourself. Print the exact
commands the user should run.

For the canonical "MCPs Boris uses daily" list (Slack, BigQuery, Sentry,
Chrome extension, Desktop app web servers, iMessage), see
`${CLAUDE_SKILL_DIR}/../../references/recommended-mcps.md`.

Reference: howborisusesclaudecode.com Part 8 + §"Tool Integrations & MCPs".
```

### 6.11 `skills/auto-mode-onboarding/SKILL.md`  *(NEW in v3)*

```markdown
---
name: auto-mode-onboarding
description: Explain Auto Mode (Claude Code's classifier-based safe-action approval), help the user decide whether to enable it, and pair it with /fewer-permission-prompts. Use when the user asks "should I use Auto Mode" or is tired of permission prompts.
disable-model-invocation: true
allowed-tools: Read
---

Per howborisusesclaudecode.com §"Permissions & Safety": Auto Mode is a
model-based classifier that auto-approves obviously-safe operations
(reads, tests, narrowly-scoped edits) while still flagging risky ones
(deletions, force-push, destructive Bash).

It is **not** the same as `--dangerously-skip-permissions`. The classifier
runs per-action; risky actions still prompt.

Trade-offs:

- **Pro.** Fewer prompts → fewer interruptions → faster work.
- **Con.** Classifier is good, not perfect. Treat Auto Mode as a
  productivity feature, not a safety guarantee. Keep the autonomy ladder
  in mind.

Recommended setup, per the site:

1. Run `/fewer-permission-prompts` first — it scans your transcripts and
   suggests a curated allowlist for `.claude/settings.json`. Apply the
   list (after reading it).
2. Enable Auto Mode with `--enable-auto-mode` on next launch, or toggle
   it mid-session with `shift+tab`.
3. Pair with `/sandbox` for risky work. Sandbox isolates filesystem and
   network; Auto Mode handles the prompts. See `references/sandbox.md`.
4. When in doubt — disable Auto Mode for an unfamiliar repo, run a few
   tasks manually, then re-enable.

This skill does not flip Auto Mode for you. The wizard explains it; the
flip is yours.
```

### 6.12 `skills/skill-author/SKILL.md`

```markdown
---
name: skill-author
description: Author a new skill following Thariq's nine rules. Use when the user wants to turn a recurring chat habit into a skill, or when an existing SKILL.md has grown beyond ~500 lines.
disable-model-invocation: true
allowed-tools: Read Write Edit Bash(mkdir *)
---

Follow the nine rules in
`${CLAUDE_SKILL_DIR}/../../references/thariq-skill-rules.md`. In summary:

1. One skill, one job. If it has "and" in the name, split it.
2. Description first — Claude picks skills by description, not by name.
3. Front-load the trigger phrases users actually say.
4. State what to do, not why.
5. Set `disable-model-invocation: true` for anything with side effects.
6. Scope `allowed-tools` to the minimum.
7. Use dynamic context (`` !`cmd` ``) instead of asking Claude to fetch.
8. Move long reference material to sibling files, link from SKILL.md.
9. Keep SKILL.md under ~500 lines (the docs' soft cap).

For *what kind of skill to write* (the 9-type taxonomy: Library/API ref,
Product Verification, Data & Analysis, Business Automation, Scaffolding,
Code Quality, CI/CD, Incident Runbooks, Infrastructure Ops) see
`${CLAUDE_SKILL_DIR}/../../references/skill-types-and-practices.md`.

Workflow:

- Ask the user: "what do you keep pasting into chat?"
- Draft `description` first, get sign-off.
- Then frontmatter, then body.
- Save to `.claude/skills/<name>/SKILL.md` (project) or
  `~/.claude/skills/<name>/SKILL.md` (personal). Confirm scope first.
```

---

## 7. Commands

> Commands live under `.claude/commands/<name>.md` and are invoked as
> `/<name>` directly (or `/loop 5m /<name>` for repeat-runs). Per
> howborisusesclaudecode.com, commands are for *team-shareable
> repeat-invocations* — checkin to git so the whole team gets them. Skills
> are for *content* the model loads contextually; commands are for
> *workflows* the user invokes by name.
>
> The four named-loop reconstructions live here (not in `skills/`) because
> Boris's tweet phrasing — `/loop 5m /babysit` — treats them as commands.

### 7.1 `commands/babysit.md`  *(reconstruction)*

```markdown
---
name: babysit
description: Watch the current PR — auto-address review comments, auto-rebase on conflict, surface anything that needs human judgment. Reconstruction of the skill Boris references in his tweet "/loop 5m /babysit".
allowed-tools: Bash(gh pr *) Bash(git fetch *) Bash(git rebase *) Bash(git push *) Read Edit
---

> **Reconstruction notice.** Boris named `/babysit` in his Mar 30 2026
> tweet (`/loop 5m /babysit`, "to auto-address code review, auto-rebase,
> and …") but did not publish the command itself. This file is our
> reconstruction from that one-line description.

## Current PR context
- Active branch: !`git rev-parse --abbrev-ref HEAD`
- PR view: !`gh pr view --json number,title,state,reviewDecision,mergeable 2>/dev/null || echo "(no PR for this branch)"`
- Unresolved review threads: !`gh pr view --json reviewThreads --jq '.reviewThreads[] | select(.isResolved==false) | {path, line, body: .comments[0].body}' 2>/dev/null || echo "(none)"`
- Mergeability: !`gh pr view --json mergeable --jq .mergeable 2>/dev/null || echo "?"`

## Instructions

For each unresolved review thread above:

- If the comment is a clear, mechanical fix (rename, missing null check,
  obvious typo, requested test) — apply it, push, and reply on the thread
  with the commit SHA.
- If it's a judgment call (architecture, naming-as-API, "why did you do
  it this way") — leave it. Surface it in your final summary as
  "needs-human".

If `mergeable` is `CONFLICTING`:
- `git fetch origin && git rebase origin/$(gh pr view --json baseRefName --jq .baseRefName)`
- If the rebase is clean, push with `--force-with-lease`.
- If there are conflicts you can't resolve safely (more than a 3-line
  hunk, or any conflict in a config/schema/lockfile), abort the rebase
  and surface "needs-human".

Before declaring done, **run the verify command** (see `skills/verify`).

End with a one-block summary:
- Comments addressed: N
- Comments needing human: M (with file:line for each)
- Rebase status: clean / done / aborted
- Verify command result
```

### 7.2 `commands/post-merge-sweeper.md`  *(reconstruction)*

```markdown
---
name: post-merge-sweeper
description: After a PR merges, do the small follow-up chores — delete the local branch, prune, update local main, scan for TODOs that referenced the now-merged PR. Reconstruction of /post-merge-sweeper from Boris's tweet.
allowed-tools: Bash(git *) Bash(gh *) Grep
---

> **Reconstruction notice.** Boris referenced `/loop /post-merge-sweeper`
> without details. Reconstructed from the name.

## State
- Current branch: !`git rev-parse --abbrev-ref HEAD`
- Default branch: !`gh repo view --json defaultBranchRef --jq .defaultBranchRef.name 2>/dev/null || echo main`
- Recently merged PRs by you: !`gh pr list --author "@me" --state merged --limit 5 --json number,title,headRefName 2>/dev/null || echo "(gh not available)"`

## Instructions

For each recently merged PR above whose `headRefName` still exists locally:

1. If you are on that branch, switch to the default branch first.
2. `git fetch --prune`
3. Delete the local branch: `git branch -d <headRefName>` (use `-d`, not
   `-D`; if it refuses, surface it instead of forcing).
4. `git pull --ff-only` on the default branch.
5. `grep -rn "PR #<number>" --include="*.ts" --include="*.md" .` — list any
   TODOs that referenced the merged PR so the user can clean them up.

Never delete remote branches. Never force anything.
```

### 7.3 `commands/pr-pruner.md`  *(reconstruction)*

```markdown
---
name: pr-pruner
description: Hourly review of your open PRs — flag stale, conflicted, or abandoned ones. Reconstruction of /loop 1h /pr-pruner from Boris's tweet.
allowed-tools: Bash(gh pr list *) Bash(gh pr view *)
---

> **Reconstruction notice.** Boris referenced `/loop 1h /pr-pruner`
> without contents. Reconstructed from the name and cadence.

## Open PRs
!`gh pr list --author "@me" --state open --json number,title,updatedAt,mergeable,reviewDecision,isDraft`

## Instructions

For each open PR, classify as one of:

- **Healthy** — updated within 48h, mergeable, has at least one approval
  or no reviewer assigned yet.
- **Stale** — no update in >7 days. Suggest closing or "ping reviewer".
- **Conflicted** — `mergeable: CONFLICTING`. Suggest running `/babysit`.
- **Blocked-by-review** — `reviewDecision: CHANGES_REQUESTED`. Suggest
  running `/babysit`.
- **Abandoned-draft** — draft, no update in >14 days. Suggest closing.

Output a short table. Take **no destructive action** (do not close, do not
push). This command is purely advisory.
```

### 7.4 `commands/slack-feedback.md`  *(reconstruction)*

```markdown
---
name: slack-feedback
description: Every 30m, scan for Slack-style feedback the user has dropped into a designated file (default ./feedback.md) and act on the actionable items. Reconstruction of /loop 30m /slack-feedback.
allowed-tools: Read Edit
---

> **Reconstruction notice.** Boris referenced `/loop 30m /slack-feedback`
> without details. We assume a local file rather than touching Slack
> credentials, since auto-installing MCP creds is explicitly out of scope.
> Users who already have the Slack MCP installed (see
> `references/recommended-mcps.md`) can adapt this command to read from
> Slack directly.

## Inbox
- Feedback file: !`test -f feedback.md && cat feedback.md || echo "(no feedback.md — create one and paste Slack snippets into it)"`

## Instructions

Treat each unchecked bullet (`- [ ]`) in `feedback.md` as a request. For
each:

- If it's a small, in-scope code change — apply it, then mark the bullet
  `- [x]` with the commit SHA appended.
- If it's a question — answer it inline as a sub-bullet, leave the box
  unchecked.
- If it's out of scope or unclear — leave the box unchecked and add a
  sub-bullet starting with `> needs clarification:`.

Never delete bullets. The user owns the file.
```

### 7.5 `commands/north-star-refresh.md`  *(NEW thin wrapper)*

```markdown
---
name: north-star-refresh
description: Re-run the north-star skill against this repo — useful as a periodic /loop or after a major refactor that may have invalidated the existing CLAUDE.md.
---

Invoke the `north-star` skill end-to-end. Treat the existing CLAUDE.md as
input; the skill will diff and ask before writing.

This command exists so a `/loop 1d /north-star-refresh` schedule resolves
cleanly — skills aren't natively schedulable through `/loop`.
```

---

## 8. Agents

> Agents live under `.claude/agents/<name>.md` with YAML frontmatter
> declaring `name`, `description`, `model`, `tools`, optional `isolation`,
> and a body that's the agent's system prompt. Per
> howborisusesclaudecode.com §"Subagents & Delegation", agents are
> automations for common workflows — they spawn with their own context
> window, do their job, and return a result.

### 8.1 `agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: Reviews a diff for correctness, security, performance, naming, and CLAUDE.md compliance. Posts inline comments on real bugs, not nits. Use after writing code, before opening a PR, or as the @claude PR-bot's first responder.
model: opus
tools: Read Grep Glob Bash(git diff *) Bash(gh pr diff *)
isolation: worktree
---

You are reviewing a diff. Focus on real bugs, not nits.

Process:

1. Read the diff (`git diff` or `gh pr diff <num>`).
2. Read the surrounding files for context — don't review changed lines in
   isolation.
3. Check CLAUDE.md for project conventions.
4. For each finding, classify as:
   - **must-fix** — real bug, security issue, or convention violation that
     will burn the next reader.
   - **should-fix** — clear improvement, low-risk.
   - **nit** — purely stylistic. Mention at most one.
5. Output: file:line comments grouped by severity. No "LGTM" filler.

If you find nothing must-fix, say so in one line and exit.
```

### 8.2 `agents/verifier.md`

```markdown
---
name: verifier
description: Runs the project's verify command (per skills/verify), reports the result, and stops. Use as the gate inside hooks/Stop.sh and as the second pass after code-reviewer.
model: opus
tools: Read Bash(bun *) Bash(npm *) Bash(pnpm *) Bash(yarn *) Bash(make *) Bash(pytest *) Bash(go test *) Bash(cargo test *) Bash(curl -s localhost:*)
isolation: worktree
---

You are the verification gate. Do exactly this:

1. Read CLAUDE.md to find the verify command. If absent, infer from
   `package.json`, `Makefile`, or equivalent — but ask the orchestrator
   before running anything you inferred.
2. Run the verify command. Capture stdout, stderr, exit code.
3. Look at the output, not just the exit code. A test runner that
   "passes" with `0 tests run` is a failure for our purposes.
4. Report:
   - Command run.
   - Exit code.
   - One- or two-line summary of what passed.
   - Any warnings worth surfacing.
5. **Do not patch anything.** If verification fails, return the failure
   and stop. The orchestrator decides what to do.
```

### 8.3 `agents/simplifier.md`

```markdown
---
name: simplifier
description: Reviews recently changed code for reuse, duplication, dead code, and quality. Wraps Anthropic's bundled /simplify into an agent shape so it can be scheduled or chained.
model: opus
tools: Read Edit Grep Glob Bash(git diff *)
---

You are the simplifier. Review the diff for:

- **Reuse opportunities** — was a similar utility already in the
  codebase?
- **Dead code** — unused exports, commented-out blocks, branches that
  can't be reached.
- **Premature abstraction** — interfaces with one implementation, helpers
  used once.
- **Duplicated state** — two sources of truth for the same value.
- **CLAUDE.md compliance** — conventions the diff violates.

For each finding, propose a concrete edit. Apply only the
**unambiguously-correct** ones; surface judgment-call ones for the user.

This agent does not run tests. Pair with `verifier` afterwards.
```

---

## 9. Hooks

> Per howborisusesclaudecode.com §"Hooks & Lifecycle Logic". Auto-compaction
> already re-attaches the most recently invoked skills (5,000 tokens each,
> 25,000 combined) per the official docs, so the PostCompact hook stays
> short.

### 9.1 `hooks/UserPromptSubmit.sh`

```bash
#!/usr/bin/env bash
# Fires before each user prompt is sent to the model. Adds a one-line
# nudge for plan-mode when the prompt looks non-trivial. Never blocks.
set -euo pipefail

prompt="${CLAUDE_USER_PROMPT:-}"
words=$(printf '%s' "$prompt" | wc -w)

if [[ $words -gt 12 ]] || \
   echo "$prompt" | grep -qiE 'refactor|migrate|rewrite|design|architect|why is|how should'; then
  echo "[vanilla-boris] non-trivial prompt detected — consider /plan-first first."
fi
```

### 9.2 `hooks/PreToolUse.sh`

```bash
#!/usr/bin/env bash
# Reminds the user (in their terminal, not in-context) when Claude is
# about to do something at the higher rungs of the autonomy ladder.
set -euo pipefail

tool="${CLAUDE_TOOL_NAME:-}"
case "$tool" in
  Bash) echo "[vanilla-boris] Bash about to run — see autonomy-ladder rung 4." ;;
  Edit|Write) echo "[vanilla-boris] Edit/Write — autonomy-ladder rung 3." ;;
esac
```

### 9.3 `hooks/PostToolUse.sh`  *(NEW in v3)*

```bash
#!/usr/bin/env bash
# Auto-format on Edit/Write when the project declares a formatter. Never
# blocks; failures are logged and ignored. Per howborisusesclaudecode.com
# §"Hooks & Lifecycle Logic" example: "bun run format || true".
set -euo pipefail

tool="${CLAUDE_TOOL_NAME:-}"
case "$tool" in
  Edit|Write) ;;
  *) exit 0 ;;
esac

# Prefer project-declared format script. If absent, do nothing.
if [[ -f package.json ]] && jq -e '.scripts.format' package.json >/dev/null 2>&1; then
  if command -v bun >/dev/null 2>&1; then
    bun run format || true
  elif command -v pnpm >/dev/null 2>&1; then
    pnpm run format || true
  else
    npm run format || true
  fi
fi
```

### 9.4 `hooks/SessionStart.sh`  *(NEW in v3)*

```bash
#!/usr/bin/env bash
# Prints a one-screen summary of what's loaded so the user sees the
# active surface at session start. No auto-loading; informational only.
set -euo pipefail

echo "[vanilla-boris] session start"
echo "  skills:    $(ls -1 .claude/skills 2>/dev/null | wc -l | tr -d ' ') installed"
echo "  commands:  $(ls -1 .claude/commands 2>/dev/null | wc -l | tr -d ' ') installed"
echo "  agents:    $(ls -1 .claude/agents 2>/dev/null | wc -l | tr -d ' ') installed"
echo "  hooks:     $(ls -1 .claude/hooks 2>/dev/null | wc -l | tr -d ' ') installed"
if [[ -f CLAUDE.md ]]; then
  echo "  CLAUDE.md: $(wc -l < CLAUDE.md | tr -d ' ') lines"
else
  echo "  CLAUDE.md: (none — consider /north-star)"
fi
```

### 9.5 `hooks/Stop.sh`  *(NEW in v3)*

```bash
#!/usr/bin/env bash
# Runs when Claude believes it is done. If the session edited code but
# did not invoke /verify or run the project's verify command, nudge.
# Never blocks — the user can ignore. Per howborisusesclaudecode.com #1.
set -euo pipefail

# CLAUDE_SESSION_EDIT_COUNT and CLAUDE_SESSION_VERIFY_INVOKED are set by
# the runtime; default to safe values if absent.
edits="${CLAUDE_SESSION_EDIT_COUNT:-0}"
verified="${CLAUDE_SESSION_VERIFY_INVOKED:-0}"

if [[ "$edits" -gt 0 ]] && [[ "$verified" -eq 0 ]]; then
  echo "[vanilla-boris] you edited $edits files but did not run /verify."
  echo "  Boris's #1 principle: give Claude a way to verify its work."
  echo "  Run /verify or the project's verify command before declaring done."
fi
```

### 9.6 `hooks/PostCompact.sh`

```bash
#!/usr/bin/env bash
# Auto-compaction already preserves invoked skills. We only print a
# reminder so the user knows which skills survived and which did not.
set -euo pipefail
echo "[vanilla-boris] Compaction done. Claude Code keeps the most recently"
echo "  invoked skills (5k tokens each, 25k cap). If north-star/plan-first"
echo "  feel less sharp, re-invoke them once and they'll fully reload."
```

---

## 10. References

### 10.1 `references/boris-claude-md.txt`

```
Source: @bcherny on X, Jan 2 2026 thread.
Used here verbatim, for reference only, under fair use.
Do not edit this file — if you want changes, edit your own CLAUDE.md.

------------------------------------------------------------
# CLAUDE.md (excerpt shared by Boris Cherny, @bcherny)

- Use bun, not npm or yarn.
- Run `bun typecheck` before claiming a change works.
- Run `bun test <path>` for the file you touched, then `bun test` only
  before opening a PR.
- Run `bun lint --fix` before committing.
- Open PRs with `gh pr create` and squash-merge.
------------------------------------------------------------

That's the whole excerpt @bcherny made public. Treat the rest of any
CLAUDE.md you write as team-derived, not Boris-derived.
```

### 10.2 `references/loop-recipes.md`

```markdown
# Boris's named /loop recipes

Source: https://x.com/bcherny/status/2038454341884154269 (Mar 30 2026)

Verbatim from the tweet:

- `/loop 5m /babysit` — to auto-address code review, auto-rebase, and …
- `/loop 30m /slack-feedback`
- `/loop /post-merge-sweeper`
- `/loop 1h /pr-pruner`

Notes:

- `/loop` (and `/schedule`) are Anthropic-bundled commands. See
  https://code.claude.com/docs/en/slash-commands.
- The four invoked targets (`/babysit`, `/slack-feedback`,
  `/post-merge-sweeper`, `/pr-pruner`) are **not** published. The commands
  in this plugin under those names live in `commands/` and are
  reconstructions from the names and cadences alone, clearly labeled as
  such inside each file.
- Cadence guidance per the tweet: "for up to a week at a time."
- For cloud-side scheduling (laptop closed) see `routine-recipes.md`.
```

### 10.3 `references/thariq-skill-rules.md`

```markdown
# Skill-authoring rules (paraphrased from Thariq's guidance)

Paraphrase, not verbatim. Cited from howborisusesclaudecode.com Part 10.

1. **One skill, one job.** If the name needs an "and", split it.
2. **Description first.** Claude picks skills by description, not name.
   Front-load the actual phrases users say.
3. **Trigger phrases over generality.** "Use when the user asks what
   changed" beats "for change-related tasks".
4. **State what to do, not why.** Every line of a SKILL.md is a recurring
   token cost — see the docs' note that skill content stays in context.
5. **`disable-model-invocation: true` for side effects.** Anything that
   touches git, the filesystem, or a network is user-invoked only.
6. **Scope `allowed-tools` to the minimum.** Prefer `Bash(gh pr *)` over
   `Bash`.
7. **Use dynamic context (`` !`cmd` ``).** Don't ask Claude to fetch what
   you can inline.
8. **Move long reference material to sibling files.** SKILL.md is the
   index, not the encyclopedia.
9. **Soft cap: ~500 lines per SKILL.md.** Past that, split or move
   content out.

For *what kind of skill to write*, see `skill-types-and-practices.md`.
```

### 10.4 `references/skill-types-and-practices.md`  *(NEW in v3)*

```markdown
# Skill types and best practices

Source: howborisusesclaudecode.com §"Skill Development & Distribution".
Verbatim taxonomy; paraphrased best practices.

## The 9 skill types

1. **Library & API reference** — function signatures, gotchas, version
   pins. Useful when Claude's training data lags the current SDK.
2. **Product verification** — drives a running product (browser, CLI,
   API) to prove a change works end-to-end.
3. **Data & analysis** — schemas, field names, query patterns,
   warehouses.
4. **Business automation** — multi-tool workflows (Slack → Linear → PR).
5. **Scaffolding & templates** — framework boilerplate, new-feature
   wizards.
6. **Code quality & review** — adversarial review, style enforcement,
   duplication detection.
7. **CI/CD & deployment** — commit, push, deploy *safely* (sequenced
   gates, rollbacks).
8. **Incident runbooks** — symptom → investigation → fix.
9. **Infrastructure ops** — safety-gated cleanup of cloud resources.

## Best practices

- **Skip the obvious.** Claude has defaults; don't restate them.
- **Build a "Gotchas" section.** Highest-signal-per-line content.
- **Progressive disclosure.** Top-level SKILL.md is the index; deeper
  detail lives in sibling files (the docs' folder structure pattern).
- **Don't railroad.** Give Claude information, not a script. Scripts go
  stale; information adapts.
- **Description = trigger.** Write the description for the model's skill
  picker, not for humans browsing the file.
- **Think through setup.** Use `config.json` for skill configuration and
  `${CLAUDE_PLUGIN_DATA}` for persistent state.
- **Give helper code.** When a sub-task is mechanical, ship the helper
  (small Python/TS module) rather than asking Claude to reconstruct it
  each time.
- **On-demand hooks.** Skills can register session-scoped hooks for
  guardrails that only apply while the skill is active.
```

### 10.5 `references/context-commands.md`  *(NEW in v3)*

```markdown
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
```

### 10.6 `references/effort-levels.md`  *(NEW in v3)*

```markdown
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
```

### 10.7 `references/opus47-shifts.md`  *(NEW in v3)*

```markdown
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
```

### 10.8 `references/sandbox.md`  *(NEW in v3)*

```markdown
# /sandbox

Source: howborisusesclaudecode.com §"Permissions & Safety".

`/sandbox` enables an open-source sandbox runtime for the current session.
The sandbox isolates filesystem and network access — Claude can read/write
inside it, but cannot reach files or hosts outside without an explicit
permission grant.

When to use:

- Working in an unfamiliar repo and you don't yet trust its scripts.
- Running Claude inside a CI agent or a shared machine.
- Pairing with Auto Mode — sandbox handles isolation, Auto Mode handles
  the prompts.

Pairs with: `skills/auto-mode-onboarding`, `skills/autonomy-ladder`.

This plugin documents `/sandbox`; it does not auto-enable it.
```

### 10.9 `references/github-bot.md`  *(NEW in v3)*

```markdown
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
```

### 10.10 `references/recommended-mcps.md`  *(NEW in v3)*

```markdown
# Recommended MCPs

Source: howborisusesclaudecode.com §"Tool Integrations & MCPs".

Boris's daily MCP set:

| MCP | What | Verify-loop fit |
|---|---|---|
| **Slack** | Search and post messages. Stub URL on the site: `https://slack.mcp.anthropic.com/mcp` | Used by `/slack-feedback`-style commands when the Slack MCP is installed (else fall back to `feedback.md`). |
| **BigQuery (`bq` CLI)** | Query analytics directly. Boris: "haven't written SQL in 6+ months." | Verification path for data work. |
| **Sentry** | Fetch error logs. | Verification path for incident response. |
| **Chrome extension** | Browser testing — Claude opens a real browser, iterates on UI. | The verification path for frontend work. |
| **Desktop app web servers** | Auto-start/test web servers from inside the app. | Verification path for full-stack work. |
| **iMessage plugin** | Text Claude from Messages. | Mobile/async, not verification. |

Install patterns vary; consult each MCP's docs. **This plugin does not
install MCPs.** Run `/mcp-audit` after adding any of them.
```

### 10.11 `references/routine-recipes.md`  *(NEW in v3)*

```markdown
# Routine recipes (cloud /schedule)

Source: howborisusesclaudecode.com §"Long-Running Tasks & Automation"
(Routines, research preview).

Routines are cloud-side scheduled jobs. Unlike `/loop`, they run with the
laptop closed.

## Triggers

- **Cron schedule** — `0 9 * * 1-5` etc.
- **GitHub events** — PR opened/merged/closed, release published, issue
  filed/closed.
- **API webhooks** — your own services post a payload, the routine fires.

## Sample recipes

- **Auto-resolve CI failures.** Trigger: GitHub `check_run` failed for a
  PR you authored. Action: dispatch `babysit`-style logic; if it
  resolves, push; if not, comment on the PR.
- **Weekly CLAUDE.md review.** Trigger: cron Friday 16:00. Action: run
  `north-star`; if it diffs CLAUDE.md, open a PR for the team to review.
- **Daily PR triage.** Trigger: cron 09:00. Action: run `pr-pruner`; post
  the summary to a Slack channel.
- **Deploy-on-merge canary.** Trigger: PR merged to main. Action: kick
  off the deploy, watch logs for 10 minutes, comment on the PR with the
  outcome.

## Connectors

GitHub, Linear, custom API endpoints. Connector tokens live in your
account, not in this repo.

## When to use Routines vs /loop

- **`/loop`**: laptop open, ≤ 1 week, low setup cost.
- **Routines**: laptop closed, indefinite, requires connector setup.

This plugin documents Routines; it does not install or schedule any.
```

### 10.12 `references/worktree-recipes.md`  *(NEW in v3)*

```markdown
# Worktree recipes

Source: howborisusesclaudecode.com §"Workspace Management" + §"Hooks &
Lifecycle Logic" (WorktreeCreate/WorktreeRemove).

## Git worktrees

Already covered in `skills/parallel-worktrees`. Cheat sheet:

```
git worktree add ../<repo>-<feature> -b <feature-branch>
claude --worktree <name>
claude --worktree <name> --tmux
git worktree remove ../<repo>-<feature>
```

## Non-git VCS

For Mercurial, Perforce, Juju, or any non-git VCS, define
`WorktreeCreate` and `WorktreeRemove` hooks. The runtime calls them when
an agent declares `isolation: worktree` and we're not in a git repo.

Sample (Mercurial):

```bash
# .claude/hooks/WorktreeCreate.sh
hg clone . ../$CLAUDE_WORKTREE_NAME
hg --cwd ../$CLAUDE_WORKTREE_NAME update -r $CLAUDE_WORKTREE_REV
echo "$PWD/../$CLAUDE_WORKTREE_NAME"
```

```bash
# .claude/hooks/WorktreeRemove.sh
rm -rf "$CLAUDE_WORKTREE_PATH"
```

This plugin does not ship these by default — they're only relevant for
non-git users.
```

### 10.13 `references/compounding-engineering.md`  *(NEW in v3)*

```markdown
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
```

### 10.14 `references/customization.md`  *(NEW in v3)*

```markdown
# Customization (P2, docs-only)

Source: howborisusesclaudecode.com §"Terminal & Environment Setup" +
§"Customization & Configuration".

These are entirely user preference. The plugin documents them; it does
not configure them.

## Visual

- **`/config`** — light/dark mode, output styles.
- **`/statusline`** — customize the status bar (model, dir, context %,
  cost).
- **`/color`** — color-code session prompts so multiple worktree-tabs
  are distinguishable.
- **Spinner verbs** — ask Claude to generate themed spinner verbs;
  store in `settings.json`.

## Output styles

- **Explanatory** — Claude explains frameworks/patterns as it works.
- **Learning** — Claude coaches you through changes.
- **Custom** — define your own tone/format.

## Input

- **`/voice`** — voice input (hold space on CLI; ~3× faster than typing).
- **`/vim`** — Vim keybindings.
- **`/terminal-setup`** — enable shift+enter for newlines.
- **`/keybindings`** — customize any key; live-reload from
  `~/.claude/keybindings.json`.

## Performance

- **Fast mode** — on by default for Opus 4.6+; toggle with `/model`.
- **Recaps** — short summary on return; disable in `/config` if noisy.

## Terminal recommendation

Boris uses Ghostty (synchronized rendering, 24-bit color).
```

---

## 11. `install.sh`

```bash
#!/usr/bin/env bash
# vanilla-boris installer.
# Idempotent. Does NOT modify ~/.zshrc or ~/.bashrc without explicit
# confirmation. Does NOT install MCP credentials. Does NOT enable
# --dangerously-skip-permissions, Auto Mode, sandbox, or the @claude bot.
set -euo pipefail

SCOPE="${1:-project}"   # project | personal
case "$SCOPE" in
  project)  TARGET=".claude" ;;
  personal) TARGET="$HOME/.claude" ;;
  *) echo "usage: install.sh [project|personal]"; exit 2 ;;
esac

echo "vanilla-boris → $TARGET"
mkdir -p "$TARGET/skills" "$TARGET/commands" "$TARGET/agents" "$TARGET/hooks"

cp -R skills/*    "$TARGET/skills/"
cp -R commands/*  "$TARGET/commands/"
cp -R agents/*    "$TARGET/agents/"
cp -R hooks/*     "$TARGET/hooks/"
chmod +x "$TARGET/hooks/"*.sh

# Per howborisusesclaudecode.com Part 10, tip #4 — verbatim:
#
#   # 400k is Thariq's recommended compromise
#   $ CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude
#
# We do NOT silently edit the user's shell profile. We print the line and
# ask.
cat <<'EOF'

──────────────────────────────────────────────────────────────────
Recommended (per howborisusesclaudecode.com Part 10, tip #4):

    # 400k is Thariq's recommended compromise
    $ CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude

This forces auto-compaction *before* the 300–400k token "context rot"
zone on the 1M-context model. We will NOT add it to your shell profile
without permission.
──────────────────────────────────────────────────────────────────
EOF

read -r -p "Append the export to ~/.zshrc / ~/.bashrc now? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [[ -f "$rc" ]] || continue
    if ! grep -q 'CLAUDE_CODE_AUTO_COMPACT_WINDOW' "$rc"; then
      printf '\n# vanilla-boris: 400k autocompact (Thariq)\nexport CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000\n' >> "$rc"
      echo "  appended to $rc"
    else
      echo "  $rc already sets CLAUDE_CODE_AUTO_COMPACT_WINDOW — left alone"
    fi
  done
else
  echo "  skipped — run \`CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude\` manually."
fi

echo
echo "Installed. Open Claude Code and run:"
echo "    /skills    — verify the 11 skills loaded"
echo "    /commands  — verify the 5 commands"
echo "    /agents    — verify the 3 agents"
echo "    bun run wizard.ts  — walk through the optional steps"
```

---

## 12. `uninstall.sh`

```bash
#!/usr/bin/env bash
# Removes only what install.sh added. Leaves CLAUDE.md, user MCP config,
# and the user's shell profile alone unless they pass --shell.
set -euo pipefail

SCOPE="${1:-project}"
case "$SCOPE" in
  project)  TARGET=".claude" ;;
  personal) TARGET="$HOME/.claude" ;;
  *) echo "usage: uninstall.sh [project|personal] [--shell]"; exit 2 ;;
esac

# Skills
for s in north-star three-loop plan-first go verify parallel-worktrees \
         full-brief challenge-me autonomy-ladder mcp-audit \
         auto-mode-onboarding skill-author; do
  rm -rf "$TARGET/skills/$s"
done

# Commands
for c in babysit post-merge-sweeper pr-pruner slack-feedback \
         north-star-refresh; do
  rm -f "$TARGET/commands/$c.md"
done

# Agents
for a in code-reviewer verifier simplifier; do
  rm -f "$TARGET/agents/$a.md"
done

# Hooks (only remove if it's our copy — compare against the repo's version)
for h in UserPromptSubmit.sh PreToolUse.sh PostToolUse.sh \
         SessionStart.sh Stop.sh PostCompact.sh; do
  if [[ -f "$TARGET/hooks/$h" ]] && cmp -s "hooks/$h" "$TARGET/hooks/$h"; then
    rm -f "$TARGET/hooks/$h"
  fi
done

if [[ "${2:-}" == "--shell" ]]; then
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [[ -f "$rc" ]] || continue
    sed -i.bak '/# vanilla-boris: 400k autocompact/,+1d' "$rc"
  done
fi

echo "vanilla-boris uninstalled from $TARGET."
echo "CLAUDE.md, MCP config, Auto Mode, sandbox, the @claude bot, and"
echo "other settings were not touched."
```

---

## 13. `wizard.ts`

```ts
#!/usr/bin/env bun
// Nine-step interactive setup. Prints what it will do; never writes
// without confirmation; never asks for credentials.
import { $ } from "bun";

const ask = async (q: string): Promise<string> => {
  process.stdout.write(`${q} `);
  for await (const line of console) return line.trim();
  return "";
};
const yes = async (q: string) => /^y/i.test(await ask(`${q} [y/N]`));

console.log("vanilla-boris wizard — nine steps, all skippable.\n");

// Step 1 — north-star CLAUDE.md
if (await yes("1) Generate or refresh CLAUDE.md via the north-star skill?")) {
  console.log("   Open Claude Code in this repo and run:  /north-star");
}

// Step 2 — plan-first nudge hook
if (await yes("2) Enable the plan-first prompt nudge (UserPromptSubmit hook)?")) {
  console.log("   Already installed by install.sh. No-op.");
}

// Step 3 — autocompact threshold (verbatim line)
console.log("\n3) Auto-compact threshold");
console.log("   Recommended:  CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude");
if (await yes("   Print this as a copy-paste hint each session?")) {
  console.log("   (No file changes — wizard just printed it.)");
}

// Step 4 — MCP audit
if (await yes("4) Run the MCP audit checklist now?")) {
  try { console.log(await $`claude mcp list`.text()); }
  catch { console.log("   `claude mcp list` not available — open Claude Code and run /mcp-audit."); }
}

// Step 5 — loop recipes
console.log("\n5) /loop recipes (Anthropic-bundled /loop, our reconstructed targets):");
console.log("     /loop 5m /babysit");
console.log("     /loop 30m /slack-feedback");
console.log("     /loop /post-merge-sweeper");
console.log("     /loop 1h /pr-pruner");
console.log("   Read references/loop-recipes.md before scheduling any of these.");

// Step 6 — verification path  (NEW in v3)
console.log("\n6) Verification path (Boris's #1 principle)");
const verify = await ask("   What command verifies a change works? (e.g. 'bun test', 'make verify', 'open localhost:3000', 'none')");
if (verify && verify !== "none") {
  console.log(`   Add this to CLAUDE.md under "How to verify a change works": ${verify}`);
  console.log("   The /verify skill will pick it up automatically.");
} else {
  console.log("   Skipped. Without a verify command, /verify will ask you each time.");
}

// Step 7 — Auto Mode  (NEW in v3)
console.log("\n7) Auto Mode");
console.log("   Auto Mode auto-approves obviously-safe operations using a classifier.");
console.log("   Risky operations still prompt. Pair with /fewer-permission-prompts.");
console.log("   We do NOT flip it for you. To enable: relaunch with --enable-auto-mode");
console.log("   or toggle mid-session with shift+tab.");
console.log("   Background reading: skills/auto-mode-onboarding/SKILL.md.");

// Step 8 — @claude GitHub bot  (NEW in v3)
console.log("\n8) @claude GitHub bot");
console.log("   The @claude bot listens for mentions in PR comments and updates");
console.log("   CLAUDE.md, runs reviews, etc. (see references/github-bot.md).");
if (await yes("   Run /install-github-action now? (Opens a browser for OAuth.)")) {
  console.log("   Open Claude Code and run:  /install-github-action");
} else {
  console.log("   Skipped. You can run /install-github-action anytime.");
}

// Step 9 — Routines  (NEW in v3)
console.log("\n9) Routines (cloud /schedule)");
console.log("   Sample recipes — see references/routine-recipes.md:");
console.log("     - Auto-resolve CI failures (trigger: GitHub check_run failed)");
console.log("     - Weekly CLAUDE.md review (trigger: cron Fri 16:00)");
console.log("     - Daily PR triage (trigger: cron 09:00)");
console.log("     - Deploy-on-merge canary (trigger: PR merged)");
console.log("   We do NOT schedule any. Configure connectors via Claude Code's");
console.log("   settings UI when you're ready.");

console.log("\nDone.");
```

---

## 14. Default permissions — `.claude/settings.local.json` (template)

> Written by `install.sh` only if no `.claude/settings.local.json` already
> exists. Never overwrites. Conservative: read-heavy, no broad `Bash`.
> v3 adds the formatter and BigQuery wildcards Boris's site recommends.

```json
{
  "_comment": "Tune this list with /fewer-permission-prompts. Pair with Auto Mode (skills/auto-mode-onboarding) for fewer prompts on safe operations.",
  "permissions": {
    "allow": [
      "Read",
      "Grep",
      "Glob",
      "Bash(git status *)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(gh pr view *)",
      "Bash(gh pr list *)",
      "Bash(bun run format *)",
      "Bash(bun run typecheck *)",
      "Bash(bun run test *)",
      "Bash(bq query *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force *)",
      "Bash(gh pr merge *)",
      "Skill(deploy *)"
    ]
  }
}
```

---

## 15. Acceptance criteria

A fresh clone of `vanilla-boris` v0.4.0 is "done" when, on a fresh repo:

1. `./install.sh project` finishes idempotently and writes 13 skills + 5
   commands + 3 agents + 9 hooks under `.claude/`, plus
   `.claude/settings.local.json` template (first install only),
   `.claude/bin/{vb-verify,vb-snapshot}` (executable),
   `.claude/output-styles/boris-productivity.md`, and
   `.claude/monitors/monitors.json` (entries disabled by default).
2. `./install.sh project` declines to touch `~/.zshrc` unless the user
   types `y`.
3. `claude --print "/skills"` lists all 11 skills with their descriptions.
4. `claude --print "/commands"` lists the 5 commands.
5. `claude --print "/agents"` lists the 3 agents.
6. `/north-star` produces a CLAUDE.md ≤ 80 lines that runs the project's
   actual `package.json`/`Makefile` commands (no invented commands) and
   declares a verify command.
7. `/plan-first` refuses to start editing without an explicit "go".
8. `/verify` runs the project's verify command and reports based on
   *output*, not just exit code.
9. `/loop 5m /babysit`, `/loop 30m /slack-feedback`,
   `/loop /post-merge-sweeper`, `/loop 1h /pr-pruner` all resolve to the
   reconstructed commands.
10. `/babysit`, `/go`, `/post-merge-sweeper`, `/pr-pruner`,
    `/slack-feedback`, `/verify`, `/full-brief`, `/challenge-me` each
    open with a **Reconstruction notice** block.
11. `/mcp-audit` lists installed MCP servers and asks per-server; it
    never adds, modifies, or removes any.
12. The wizard's nine steps each succeed when answered "n", with no
    file changes other than what install.sh already did.
13. `hooks/Stop.sh` nudges if the session edited files but did not run
    `/verify`.
14. `hooks/PostToolUse.sh` runs `bun run format` (or equivalent) when
    `package.json` declares one, and silently no-ops when it doesn't.
15. `./uninstall.sh project` removes exactly what `install.sh` added;
    `CLAUDE.md`, shell profiles, Auto Mode, sandbox, and the @claude bot
    are untouched unless `--shell` is passed.
16. `references/boris-claude-md.txt` contains the verbatim @bcherny
    excerpt with attribution and the "do not edit" header.
17. No skill, command, agent, or hook ever invokes
    `--dangerously-skip-permissions`. Grep proves it:
    `! grep -r 'dangerously-skip-permissions' .`.
18. `plugin.json` is `0.3.0`, declares `settings.subagentStatusLine`,
    and ships exactly 12 verification-themed `settings.spinnerVerbs`.
19. `hooks/SessionEnd.sh` exists, is executable, and prints a session
    summary including a "/verify reminder" line when
    `CLAUDE_SESSION_VERIFY_INVOKED=0` and `CLAUDE_SESSION_EDIT_COUNT>0`.
20. `hooks/PermissionRequest.sh` exists and is a silent no-op when
    `VANILLA_BORIS_PERMREQ_ROUTE` is unset.
21. `skills/verify/SKILL.md` declares `paths: ["**/*.test.*", "**/*.spec.*", "tests/**", "__tests__/**", "spec/**"]` and an on-demand `Stop` hook in its `hooks:` field.
22. `agents/verifier.md` declares `preloadSkills: [verify]` and
    `defaultPermissionMode: ask`.
23. `references/{env-vars,shell-aliases,boris-named-skills,cli-flags}.md`
    all exist and cite their sources (site or code.claude.com/docs).
24. `CHANGELOG.md` records both the v0.2.0, v0.3.0, and v0.4.0 entries.
25. `marketplace.json` exists at repo root and `jq '.plugins[0].name'` is
    `"vanilla-boris"`. (Local-path stub OK; flippable to a public URL.)
26. `.claude-plugin/settings.json` exists at repo root with
    `permissions.defaultMode: "ask"` and 12 spinner verbs.
27. `monitors/monitors.json` has at least one entry; **none** are
    enabled by default (`.enabled === false` for all).
28. `output-styles/boris-productivity.md` exists with `name`,
    `description`, `keep-coding-instructions: true`, and is documented
    as opt-in.
29. `skills/learn-codebase/SKILL.md` exists with a Reconstruction
    notice and `context: fork`.
30. `hooks/PreCompact.sh` exists, is executable, and writes to
    `.claude/session-notes/<sid>.md` when fired.
31. `plugin.json` is `0.4.0`.

---

## 16. Open questions / out of scope

- **Real Slack ingestion.** `commands/slack-feedback.md` reads a local
  file by design — we will not auto-install a Slack MCP server. If a user
  already has one configured (see `references/recommended-mcps.md`),
  adapting the command is a follow-up.
- **Boris's actual private skill bodies.** Until/unless he publishes
  them, `/babysit`, `/go`, `/post-merge-sweeper`, `/pr-pruner`,
  `/slack-feedback`, `/verify`, `/full-brief`, `/challenge-me` stay
  labeled as reconstructions. If he publishes, we replace ours and
  credit him.
- **Mobile and multi-device.** `/remote-control`, iOS/Android app,
  iMessage plugin, Cowork Dispatch — out of scope for v0.2.
- **Output styles.** Documented in `references/customization.md` only;
  not shipped as a default.
- **Auto Mode + sandbox auto-flip.** Documented in
  `skills/auto-mode-onboarding` + `references/sandbox.md`; not flipped
  by the wizard.
- **The `@claude` GitHub bot.** Documented in `references/github-bot.md`;
  the wizard offers `/install-github-action` only on confirmation.
- **Routines.** Documented in `references/routine-recipes.md`; the
  wizard prints sample triggers but schedules nothing.
- **Windows.** Hooks are bash. PowerShell parity is a follow-up; the
  docs note `shell: powershell` is supported per skill.
- **Enterprise scope.** This plugin targets project + personal scopes.
  Enterprise managed-settings deployment is out of scope for v0.2.
- **Rest of `CLAUDE.md`.** We only ship the five lines Boris made
  public. The wizard offers no further "Boris-style" CLAUDE.md content
  because we don't have it.

---

## 17. Changelog seed (`CHANGELOG.md`)

```markdown
# Changelog

## 0.3.0 — 2026-05-07

Site re-audit revision tracked: howborisusesclaudecode.com as of
2026-05-07 (full bullet-by-bullet inventory, ~500 distinct items),
cross-referenced with code.claude.com/docs.

Added (configurable knobs, was docs-only):
- `plugin.json` `settings.subagentStatusLine` — vanilla-boris status line.
- `plugin.json` `settings.spinnerVerbs` — 12 verification-themed verbs.
- `plugin.json` `author` and `license` metadata.

Added (hooks): SessionEnd.sh, PermissionRequest.sh (opt-in). Stop.sh
extended with optional sound + Slack notification gates.

Added (skill/agent capabilities):
- `skills/verify/SKILL.md` — `paths:` glob auto-activation + `hooks:`
  on-demand `Stop` hook (the on-demand hooks pattern from skill best
  practices).
- `agents/verifier.md` — `preloadSkills: [verify]` and
  `defaultPermissionMode: ask`.

Added (references): env-vars.md, shell-aliases.md,
boris-named-skills.md, cli-flags.md.

Extended (references): routine-recipes.md (full connector list),
sandbox.md (4-layer permission mechanism), customization.md
(pointers to new refs; documents shipped status line + spinner verbs).

Added (defaults): `install.sh` writes `.claude/settings.local.json`
template on first install (never overwrites). Includes
`permissions.defaultMode: "ask"` and `cleanupPeriodDays: 30`.

Wizard: 9 → 12 steps. New: status line/spinner preview, shell aliases
snippet, env-vars cheatsheet pointer.

PRD §2 non-goals: extended to declare we don't shadow `/init`,
`/review`, `/security-review`, `/skills`, `/agents`, `/upgrade`,
`/help`, `/desktop`, `/add-dir`, `/remote-control`, `/agent-teams`.
`/review` and `/security-review` are explicitly **complementary** to
our `code-reviewer` agent.

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
```

---

*End of `vanilla-boris.md` v3.*
