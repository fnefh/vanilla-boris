# Boris's named /loop recipes

Source: https://x.com/bcherny/status/2038454341884154269 (Mar 30 2026)

Verbatim from the tweet:

- `/loop 5m /babysit` — to auto-address code review, auto-rebase, and …
- `/loop 30m /slack-feedback`
- `/loop /post-merge-sweeper`
- `/loop 1h /pr-pruner`

Notes:

- `/loop` (and `/schedule`) are Anthropic-bundled commands. See
  https://code.claude.com/docs/en/slash-commands.
- The four invoked targets (`/babysit`, `/slack-feedback`,
  `/post-merge-sweeper`, `/pr-pruner`) are **not** published. The commands
  in this plugin under those names live in `commands/` and are
  reconstructions from the names and cadences alone, clearly labeled as
  such inside each file.
- Cadence guidance per the tweet: "for up to a week at a time."
- For cloud-side scheduling (laptop closed) see `routine-recipes.md`.

## `/batch` scale (Boris, Mar 30 2026 thread)

> "`/batch` fans out to **dozens, hundreds, or thousands** of worktree
> agents."

This is much larger than typical `/loop` cadences. `/batch` is the
right tool for repository-wide migrations (rename one symbol across
40+ files, add a license header to every source file, port every test
file to a new framework). Use sparingly and always with a verify
command (see `skills/verify`) — at thousand-agent scale, even a 0.1%
error rate is many bad PRs.
