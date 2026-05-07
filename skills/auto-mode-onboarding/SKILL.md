---
name: auto-mode-onboarding
description: Explain Auto Mode (Claude Code's classifier-based safe-action approval), help the user decide whether to enable it, and pair it with /fewer-permission-prompts. Use when the user asks "should I use Auto Mode" or is tired of permission prompts.
disable-model-invocation: true
allowed-tools: Read
---

Per howborisusesclaudecode.com §"Permissions & Safety": Auto Mode is a
model-based classifier that auto-approves obviously-safe operations
(reads, tests, narrowly-scoped edits) while still flagging risky ones
(deletions, force-push, destructive Bash).

It is **not** the same as `--dangerously-skip-permissions`. The classifier
runs per-action; risky actions still prompt.

Trade-offs:

- **Pro.** Fewer prompts → fewer interruptions → faster work.
- **Con.** Classifier is good, not perfect. Treat Auto Mode as a
  productivity feature, not a safety guarantee. Keep the autonomy ladder
  in mind.

Recommended setup, per the site:

1. Run `/fewer-permission-prompts` first — it scans your transcripts and
   suggests a curated allowlist for `.claude/settings.json`. Apply the
   list (after reading it).
2. Enable Auto Mode with `--enable-auto-mode` on next launch, or toggle
   it mid-session with `shift+tab`.
3. Pair with `/sandbox` for risky work. Sandbox isolates filesystem and
   network; Auto Mode handles the prompts. See `references/sandbox.md`.
4. When in doubt — disable Auto Mode for an unfamiliar repo, run a few
   tasks manually, then re-enable.

This skill does not flip Auto Mode for you. The wizard explains it; the
flip is yours.
