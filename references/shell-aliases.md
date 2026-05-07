# Worktree shell aliases

Source: howborisusesclaudecode.com §"Workspace Management".

Boris's site recommends one-keystroke worktree switching via short shell
aliases (`za`, `zb`, `zc`, …). The pattern: each alias `cd`s into a
named worktree directory and starts a Claude session there.

## Example (zsh)

```sh
# .claude/worktrees/<name> conventions Boris uses on his site.
# Each alias: switch into the worktree and start Claude.
alias za='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/a" && claude --worktree a'
alias zb='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/b" && claude --worktree b'
alias zc='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/c" && claude --worktree c'
```

## Setup script (idempotent)

```sh
#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
mkdir -p "$root/.claude/worktrees"
for letter in a b c; do
  wt="$root/.claude/worktrees/$letter"
  [[ -d "$wt" ]] && continue
  git worktree add "$wt" -b "wt/$letter" 2>/dev/null \
    || git worktree add "$wt" "wt/$letter"
done
echo "Worktrees ready. Add aliases (zsh):"
cat <<'ZSH'
alias za='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/a" && claude --worktree a'
alias zb='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/b" && claude --worktree b'
alias zc='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/c" && claude --worktree c'
ZSH
```

## Why this matters

- **Speed** — switching worktrees is a 2-key gesture (`za`-Enter) instead
  of a multi-line `cd && claude --worktree` typed each time.
- **Visibility** — color-coding the terminal tab per worktree (`/color`,
  see `customization.md`) plus aliases makes 5 parallel Claudes
  visually distinguishable.
- **Discipline** — fixed alias names force a discipline of "feature A
  always lives in `a`" instead of ad-hoc directory names.

This plugin documents the pattern; the wizard (`bun run wizard.ts`)
prints the snippet on request but does **not** modify your shell
profile silently.
