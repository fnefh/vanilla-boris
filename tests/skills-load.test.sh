#!/usr/bin/env bash
# Smoke test: Claude Code lists our skills.
# Requires the plugin to be installed (./install.sh project) and `claude`
# on PATH. May be skipped in CI by setting SKIP_CLAUDE_SMOKE=1.
set -euo pipefail

if [[ "${SKIP_CLAUDE_SMOKE:-0}" == "1" ]]; then
  echo "skills-load.test.sh SKIPPED (SKIP_CLAUDE_SMOKE=1)"
  exit 0
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "skills-load.test.sh SKIPPED (claude not on PATH)"
  exit 0
fi

out=$(claude --print "/skills" 2>&1 || true)
for s in north-star plan-first verify parallel-worktrees full-brief \
         challenge-me autonomy-ladder mcp-audit auto-mode-onboarding \
         skill-author go three-loop; do
  echo "$out" | grep -q "$s" || { echo "FAIL: skill not listed: $s"; exit 1; }
done
echo "skills-load.test.sh OK"
