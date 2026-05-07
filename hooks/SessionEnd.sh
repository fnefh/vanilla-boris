#!/usr/bin/env bash
# Prints a one-line summary at session end. Pairs with SessionStart.sh.
# Per howborisusesclaudecode.com — closes the verify-loop expectation
# Stop.sh started.
set -euo pipefail

edits="${CLAUDE_SESSION_EDIT_COUNT:-0}"
verified="${CLAUDE_SESSION_VERIFY_INVOKED:-0}"
sid="${CLAUDE_CODE_SESSION_ID:-?}"

echo "[vanilla-boris] session end ($sid)"
echo "  edits: $edits  ·  /verify invoked: $verified"
if [[ "$edits" -gt 0 ]] && [[ "$verified" -eq 0 ]]; then
  echo "  reminder: edits without /verify. Boris's #1 principle says verify."
fi
