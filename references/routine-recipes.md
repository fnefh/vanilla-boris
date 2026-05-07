# Routine recipes (cloud /schedule)

Source: howborisusesclaudecode.com §"Long-Running Tasks & Automation"
(Routines, research preview).

Routines are cloud-side scheduled jobs. Unlike `/loop`, they run with the
laptop closed.

## Triggers

- **Cron schedule** — `0 9 * * 1-5` etc.
- **GitHub events** — PR opened/merged/closed, release published, issue
  filed/closed.
- **API webhooks** — your own services post a payload, the routine fires.

## Sample recipes

- **Auto-resolve CI failures.** Trigger: GitHub `check_run` failed for a
  PR you authored. Action: dispatch `babysit`-style logic; if it
  resolves, push; if not, comment on the PR.
- **Weekly CLAUDE.md review.** Trigger: cron Friday 16:00. Action: run
  `north-star`; if it diffs CLAUDE.md, open a PR for the team to review.
- **Daily PR triage.** Trigger: cron 09:00. Action: run `pr-pruner`; post
  the summary to a Slack channel.
- **Deploy-on-merge canary.** Trigger: PR merged to main. Action: kick
  off the deploy, watch logs for 10 minutes, comment on the PR with the
  outcome.

## Connectors

Per howborisusesclaudecode.com, the bundled connector set is broader
than the four we listed in v0.2.0:

- **GitHub** — PR/issue/release/check_run events.
- **Linear** — issue lifecycle, project events.
- **Slack** — channel posts, search results, mentions.
- **WhatsApp** — message-driven triggers.
- **Asana** — task-state changes.
- **Google Drive** — file-event triggers.
- **dbt** — model-run events for analytics-engineering routines.
- **Grafana** — alert webhooks.
- **Custom API endpoints** — any service that can POST a JSON payload.

Connector tokens live in your account, not in this repo.

## When to use Routines vs /loop

- **`/loop`**: laptop open, ≤ 1 week, low setup cost.
- **Routines**: laptop closed, indefinite, requires connector setup.

This plugin documents Routines; it does not install or schedule any.
