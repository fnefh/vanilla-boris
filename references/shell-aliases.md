# Worktree shell aliases

Source: howborisusesclaudecode.com §"Workspace Management" + InfoQ
"Inside the Development Workflow of Claude Code's Creator" (Jan 2026,
Boris Cherny interview).

Boris uses one-keystroke worktree switching via short shell aliases
**`2a`, `2b`, `2c`** (the InfoQ piece quotes this letter form
verbatim). The pattern: each alias `cd`s into a named worktree
directory and starts a Claude session there.

## Example (zsh / bash)

```sh
# Boris-style (per InfoQ):
alias 2a='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/a" && claude --worktree a'
alias 2b='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/b" && claude --worktree b'
alias 2c='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/c" && claude --worktree c'
```

The `2`-prefix is type-friendly on a number row; you hit `2`-`a`-Enter
in three keystrokes and you're in worktree A with Claude running.

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
alias 2a='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/a" && claude --worktree a'
alias 2b='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/b" && claude --worktree b'
alias 2c='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/c" && claude --worktree c'
ZSH
```

## Why this matters

- **Speed** — switching worktrees is a 3-key gesture (`2a`-Enter)
  instead of a multi-line `cd && claude --worktree` typed each time.
- **Visibility** — color-coding the terminal tab per worktree (`/color`,
  see `customization.md`) plus aliases makes 5 parallel Claudes
  visually distinguishable.
- **Discipline** — fixed alias names force a discipline of "feature A
  always lives in `a`" instead of ad-hoc directory names.

## When to use full checkouts instead

For the most isolated parallel sessions (heavy git surgery,
independent hooks, disposable sandboxes), Boris occasionally uses
**separate checkouts** rather than worktrees. See
[`parallel-worktrees-vs-checkouts.md`](./parallel-worktrees-vs-checkouts.md)
for the trade-off.

This plugin documents the pattern; the wizard (`bun run wizard.ts`)
prints the snippet on request but does **not** modify your shell
profile silently.
