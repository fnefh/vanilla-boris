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
