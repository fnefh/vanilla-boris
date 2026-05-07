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

## CLI flags

For a quick reference of useful Claude CLI flags (`--worktree`,
`--bare`, `--resume`, `--fork-session`, `-w`, `--name`,
`--enable-auto-mode`, `--permission-mode=dontAsk`,
`--output-format=stream-json`, `--add-dir`), see
[`cli-flags.md`](./cli-flags.md).

## Worktree shell aliases

Boris recommends one-keystroke worktree switching via short aliases
(`za`, `zb`, `zc`). See [`shell-aliases.md`](./shell-aliases.md) for an
idempotent setup script.

## Status line and spinner verbs (shipped)

Unlike the other items in this file, the status line template and
spinner verbs are **shipped** by this plugin via `plugin.json`'s
`settings` block:

- **Status line** — `vanilla-boris ▸ {model} ▸ {context_pct}% ▸ {git_branch} ▸ {cost}`
- **Spinner verbs** — verifying / checking / auditing / inspecting /
  tracing / validating / scrutinizing / weighing / probing / testing /
  rehearsing / double-checking

Both are subagent-scoped (apply when our agents spawn) and do **not**
override your session-wide settings. To set a session-wide status line
or your own spinner verbs, use `/statusline` and `settings.json` →
`spinnerVerbs` directly.

The wizard's step 10 lets you preview both before they take effect.
