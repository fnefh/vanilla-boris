# Worktrees vs separate checkouts

Source: InfoQ "Inside the Development Workflow of Claude Code's
Creator" (Jan 2026, Boris Cherny interview).

`skills/parallel-worktrees` covers the standard pattern: `git worktree
add` + `claude --worktree`. But the InfoQ piece quotes Boris saying he
sometimes uses **separate full git checkouts** (i.e., `git clone`-ing
the same repo into a sibling directory) instead of worktrees, for the
most isolated parallel sessions.

## Trade-off

| | Worktree | Separate checkout |
|---|---|---|
| Disk | Single `.git` shared, cheap | Full `.git` per checkout |
| Isolation | Shared `.git` — branch-state visible across worktrees | Fully isolated |
| Stash collisions | Possible (shared stash list) | Impossible |
| Hooks | Shared `.git/hooks/` | Independent |
| Heavy mutations (e.g., `git filter-repo`) | Affects all worktrees | Only affects one |

## When to choose

- **Worktree (default)** — feature work, quick spikes, side branches.
  See `skills/parallel-worktrees`.
- **Separate checkout** — when you need:
  - Heavy git surgery (`filter-repo`, large rebase) without disturbing
    other worktrees.
  - Different `.git/hooks/` (e.g., one checkout configured for a
    pre-commit linter, another not).
  - Truly disposable sandbox where `rm -rf` is a clean reset.

## Setup

```sh
# In a sibling directory:
cd ..
git clone <upstream-or-fork> vanilla-boris-spike
cd vanilla-boris-spike
claude --name "spike"   # no --worktree; this is a full checkout
```

Boris's site uses **worktrees** by default and only mentions checkouts
as the escape hatch. This plugin's `skills/parallel-worktrees` is the
right starting point; this file documents the escape hatch.
