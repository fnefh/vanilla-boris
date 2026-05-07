#!/usr/bin/env bash
# Runs when Claude believes it is done. If the session edited code but
# did not invoke /verify or run the project's verify command, nudge.
# Never blocks — the user can ignore. Per howborisusesclaudecode.com #1.
#
# Optional notifications, gated on env vars (silent by default):
#   VANILLA_BORIS_NOTIFY_SOUND=1            # macOS: play a sound
#   VANILLA_BORIS_NOTIFY_SLACK=<webhook>    # POST a one-line summary
set -euo pipefail

# CLAUDE_SESSION_EDIT_COUNT and CLAUDE_SESSION_VERIFY_INVOKED are set by
# the runtime; default to safe values if absent.
edits="${CLAUDE_SESSION_EDIT_COUNT:-0}"
verified="${CLAUDE_SESSION_VERIFY_INVOKED:-0}"

needs_nudge=0
if [[ "$edits" -gt 0 ]] && [[ "$verified" -eq 0 ]]; then
  needs_nudge=1
  echo "[vanilla-boris] you edited $edits files but did not run /verify."
  echo "  Boris's #1 principle: give Claude a way to verify its work."
  echo "  Run /verify or the project's verify command before declaring done."
fi

# Optional: macOS sound on stop.
if [[ "${VANILLA_BORIS_NOTIFY_SOUND:-0}" == "1" ]] && command -v afplay >/dev/null 2>&1; then
  afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &
fi

# Optional: Slack ping on stop (fire-and-forget; backgrounded so the
# session-stop sequence doesn't block on slow Slack DNS/TLS).
# code.claude.com/docs/en/hooks documents `async: true` for config-
# level hooks; this shell-hook variant uses `&` for the same effect.
if [[ -n "${VANILLA_BORIS_NOTIFY_SLACK:-}" ]] && [[ "$needs_nudge" -eq 1 ]]; then
  payload="{\"text\":\":warning: Claude Code session stopped with $edits edits but no /verify.\"}"
  (curl -fsS -X POST -H 'Content-Type: application/json' \
        -d "$payload" "$VANILLA_BORIS_NOTIFY_SLACK" >/dev/null 2>&1 || true) &
  disown 2>/dev/null || true
fi
