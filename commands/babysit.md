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
