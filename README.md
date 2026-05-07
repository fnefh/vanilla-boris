# vanilla-boris

A Claude Code plugin that bakes in the working habits described on
[howborisusesclaudecode.com](https://howborisusesclaudecode.com/) and in
[@bcherny](https://x.com/bcherny)'s public threads. It packages those habits
as **skills**, **commands**, **agents**, **hooks**, and one **wizard** so a
new repo can opt in with a single command.

The full spec lives in [`PRD.md`](./PRD.md). This README is just the
quickstart.

## Quickstart

```bash
# Project scope — writes to ./.claude/ inside this repo
./install.sh project

# Personal scope — writes to ~/.claude/
./install.sh personal

# Then run the optional 9-step wizard
bun run wizard.ts
```

The installer is idempotent. It will not modify your shell profile, install
MCP credentials, or enable `--dangerously-skip-permissions`, Auto Mode,
sandboxing, or the `@claude` GitHub bot without explicit confirmation.

## Uninstall

```bash
./uninstall.sh project          # or: personal
./uninstall.sh project --shell  # also removes the autocompact export
```

## What you get (v0.2.0)

| Surface | Count | Highlights |
|---|---|---|
| Skills | 12 | `north-star`, `plan-first`, `verify` (Boris's #1), `parallel-worktrees`, `full-brief` (Opus 4.7 delegation), `challenge-me`, `autonomy-ladder`, `mcp-audit`, `auto-mode-onboarding`, `skill-author`, plus reconstructions of `/go` |
| Commands | 5 | `/babysit`, `/post-merge-sweeper`, `/pr-pruner`, `/slack-feedback`, `/north-star-refresh` (the four loop targets per Boris's tweet) |
| Agents | 3 | `code-reviewer`, `verifier`, `simplifier` |
| Hooks | 6 | `SessionStart`, `UserPromptSubmit`, `PreToolUse`, `PostToolUse` (auto-format), `Stop` (verification nudge), `PostCompact` |
| References | 14 | All Boris's named patterns: loop recipes, routines, MCPs, the @claude bot, effort levels, Opus 4.7 shifts, sandbox, customization, etc. |

## File tree

```
vanilla-boris/
├── PRD.md                  # full spec, source of truth
├── plugin.json             # 0.2.0 manifest
├── install.sh / uninstall.sh
├── wizard.ts               # 9-step interactive setup (bun run)
├── skills/                 # 12 SKILL.md files
├── commands/               # 5 reconstructed loop targets + helper
├── agents/                 # 3 sample agents
├── hooks/                  # 6 lifecycle hooks
├── references/             # 14 reference docs
└── tests/                  # smoke tests
```

## Honesty matrix

Per [PRD §0](./PRD.md), every claim in the plugin is tagged:

- ✅ **verbatim** — from howborisusesclaudecode.com or its linked official docs.
- 🟡 **reconstruction** — Boris named the surface but didn't publish the
  contents. Reconstructions open with a "Reconstruction notice" block and
  cite their source line.
- 🟡 **ours** — team-derived defaults (hooks, wizard, tests, permissions).

We don't claim authorship of anything Boris wrote, and we don't ship his
private files.

## Troubleshooting

- **`claude --print "/skills"` doesn't list our skills.** Restart your
  Claude Code session — skills are loaded at session start.
- **Hooks don't fire.** Check `chmod +x hooks/*.sh` (`install.sh` does this
  automatically, but a manual copy might not).
- **Auto-compaction at the wrong threshold.** Set
  `CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000` in your shell profile (the
  installer offers this; you can also do it manually).
- **`/babysit` etc. don't resolve.** They live under `commands/`, not
  `skills/`, in v0.2.0 — verify with `claude --print "/commands"`.

## License

MIT for the plugin's reconstructions and team defaults. The verbatim
@bcherny excerpt in `references/boris-claude-md.txt` is quoted under fair
use, attributed inline. See [`LICENSE`](./LICENSE).
