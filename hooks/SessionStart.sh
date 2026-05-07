#!/usr/bin/env bash
# Prints a one-screen summary of what's loaded so the user sees the
# active surface at session start. No auto-loading; informational only.
set -euo pipefail

echo "[vanilla-boris] session start"
echo "  skills:    $(ls -1 .claude/skills 2>/dev/null | wc -l | tr -d ' ') installed"
echo "  commands:  $(ls -1 .claude/commands 2>/dev/null | wc -l | tr -d ' ') installed"
echo "  agents:    $(ls -1 .claude/agents 2>/dev/null | wc -l | tr -d ' ') installed"
echo "  hooks:     $(ls -1 .claude/hooks 2>/dev/null | wc -l | tr -d ' ') installed"
if [[ -f CLAUDE.md ]]; then
  echo "  CLAUDE.md: $(wc -l < CLAUDE.md | tr -d ' ') lines"
else
  echo "  CLAUDE.md: (none — consider /north-star)"
fi
