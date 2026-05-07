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
