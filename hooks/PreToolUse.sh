#!/usr/bin/env bash
# Reminds the user (in their terminal, not in-context) when Claude is
# about to do something at the higher rungs of the autonomy ladder.
set -euo pipefail

tool="${CLAUDE_TOOL_NAME:-}"
case "$tool" in
  Bash) echo "[vanilla-boris] Bash about to run — see autonomy-ladder rung 4." ;;
  Edit|Write) echo "[vanilla-boris] Edit/Write — autonomy-ladder rung 3." ;;
esac
