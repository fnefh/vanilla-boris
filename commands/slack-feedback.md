---
name: slack-feedback
description: Every 30m, scan for Slack-style feedback the user has dropped into a designated file (default ./feedback.md) and act on the actionable items. Reconstruction of /loop 30m /slack-feedback.
allowed-tools: Read Edit
---

> **Reconstruction notice.** Boris referenced `/loop 30m /slack-feedback`
> without details. We assume a local file rather than touching Slack
> credentials, since auto-installing MCP creds is explicitly out of scope.
> Users who already have the Slack MCP installed (see
> `references/recommended-mcps.md`) can adapt this command to read from
> Slack directly.

## Inbox
- Feedback file: !`test -f feedback.md && cat feedback.md || echo "(no feedback.md — create one and paste Slack snippets into it)"`

## Instructions

Treat each unchecked bullet (`- [ ]`) in `feedback.md` as a request. For
each:

- If it's a small, in-scope code change — apply it, then mark the bullet
  `- [x]` with the commit SHA appended.
- If it's a question — answer it inline as a sub-bullet, leave the box
  unchecked.
- If it's out of scope or unclear — leave the box unchecked and add a
  sub-bullet starting with `> needs clarification:`.

Never delete bullets. The user owns the file.
