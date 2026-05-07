#!/usr/bin/env bash
# Fires before each user prompt is sent to the model. Adds a one-line
# nudge for plan-mode when the prompt looks non-trivial. Never blocks.
set -euo pipefail

prompt="${CLAUDE_USER_PROMPT:-}"
words=$(printf '%s' "$prompt" | wc -w)

if [[ $words -gt 12 ]] || \
   echo "$prompt" | grep -qiE 'refactor|migrate|rewrite|design|architect|why is|how should'; then
  echo "[vanilla-boris] non-trivial prompt detected — consider /plan-first first."
fi
