#!/usr/bin/env bash
# Runs when Claude believes it is done. If the session edited code but
# did not invoke /verify or run the project's verify command, nudge.
# Never blocks — the user can ignore. Per howborisusesclaudecode.com #1.
set -euo pipefail

# CLAUDE_SESSION_EDIT_COUNT and CLAUDE_SESSION_VERIFY_INVOKED are set by
# the runtime; default to safe values if absent.
edits="${CLAUDE_SESSION_EDIT_COUNT:-0}"
verified="${CLAUDE_SESSION_VERIFY_INVOKED:-0}"

if [[ "$edits" -gt 0 ]] && [[ "$verified" -eq 0 ]]; then
  echo "[vanilla-boris] you edited $edits files but did not run /verify."
  echo "  Boris's #1 principle: give Claude a way to verify its work."
  echo "  Run /verify or the project's verify command before declaring done."
fi
