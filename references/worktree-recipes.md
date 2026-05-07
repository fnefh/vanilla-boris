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
