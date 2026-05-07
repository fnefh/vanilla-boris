#!/usr/bin/env bash
# Smoke test: Claude Code lists our agents.
set -euo pipefail

if [[ "${SKIP_CLAUDE_SMOKE:-0}" == "1" ]]; then
  echo "agents-load.test.sh SKIPPED (SKIP_CLAUDE_SMOKE=1)"
  exit 0
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "agents-load.test.sh SKIPPED (claude not on PATH)"
  exit 0
fi

out=$(claude --print "/agents" 2>&1 || true)
for a in code-reviewer verifier simplifier; do
  echo "$out" | grep -q "$a" || { echo "FAIL: agent not listed: $a"; exit 1; }
done
echo "agents-load.test.sh OK"
