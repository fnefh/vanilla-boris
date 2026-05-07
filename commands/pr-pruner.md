---
name: pr-pruner
description: Hourly review of your open PRs — flag stale, conflicted, or abandoned ones. Reconstruction of /loop 1h /pr-pruner from Boris's tweet.
allowed-tools: Bash(gh pr list *) Bash(gh pr view *)
arguments:
  - days_stale
argument-hint: "[days_stale=7]"
---

> **Reconstruction notice.** Boris referenced `/loop 1h /pr-pruner`
> without contents. Reconstructed from the name and cadence.

## Open PRs
!`gh pr list --author "@me" --state open --json number,title,updatedAt,mergeable,reviewDecision,isDraft`

## Instructions

For each open PR, classify as one of:

- **Healthy** — updated within 48h, mergeable, has at least one approval
  or no reviewer assigned yet.
- **Stale** — no update in >`$days_stale` days (default 7). Suggest closing or "ping reviewer".
- **Conflicted** — `mergeable: CONFLICTING`. Suggest running `/babysit`.
- **Blocked-by-review** — `reviewDecision: CHANGES_REQUESTED`. Suggest
  running `/babysit`.
- **Abandoned-draft** — draft, no update in >14 days. Suggest closing.

Output a short table. Take **no destructive action** (do not close, do not
push). This command is purely advisory.
