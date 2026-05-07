#!/usr/bin/env bash
# Smoke test: Claude Code lists our commands.
set -euo pipefail

if [[ "${SKIP_CLAUDE_SMOKE:-0}" == "1" ]]; then
  echo "commands-load.test.sh SKIPPED (SKIP_CLAUDE_SMOKE=1)"
  exit 0
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "commands-load.test.sh SKIPPED (claude not on PATH)"
  exit 0
fi

out=$(claude --print "/commands" 2>&1 || true)
for c in babysit post-merge-sweeper pr-pruner slack-feedback north-star-refresh; do
  echo "$out" | grep -q "$c" || { echo "FAIL: command not listed: $c"; exit 1; }
done
echo "commands-load.test.sh OK"
