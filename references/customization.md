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
