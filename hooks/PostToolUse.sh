#!/usr/bin/env bash
# Auto-format on Edit/Write when the project declares a formatter. Never
# blocks; failures are logged and ignored. Per howborisusesclaudecode.com
# §"Hooks & Lifecycle Logic" example: "bun run format || true".
#
# v0.4.0: tool-duration guardian. PostToolUse receives CLAUDE_TOOL_DURATION_MS
# (per code.claude.com release notes 2.1.x). We surface a tiny hint when
# any tool call exceeds 5s — useful for catching grep-too-broad,
# bash-spinning, or webfetch-stalled.
set -euo pipefail

tool="${CLAUDE_TOOL_NAME:-}"
dur="${CLAUDE_TOOL_DURATION_MS:-0}"

# Auto-format on Edit/Write.
case "$tool" in
  Edit|Write)
    if [[ -f package.json ]] && jq -e '.scripts.format' package.json >/dev/null 2>&1; then
      if command -v bun >/dev/null 2>&1; then
        bun run format || true
      elif command -v pnpm >/dev/null 2>&1; then
        pnpm run format || true
      else
        npm run format || true
      fi
    fi
    ;;
esac

# Tool-duration guardian: hint when a single tool call took >5s.
if [[ "$dur" -gt 5000 ]]; then
  echo "[vanilla-boris] $tool took ${dur}ms — consider narrowing scope (more specific path/pattern)."
fi
