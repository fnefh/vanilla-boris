#!/usr/bin/env bash
# Auto-format on Edit/Write when the project declares a formatter. Never
# blocks; failures are logged and ignored. Per howborisusesclaudecode.com
# §"Hooks & Lifecycle Logic" example: "bun run format || true".
set -euo pipefail

tool="${CLAUDE_TOOL_NAME:-}"
case "$tool" in
  Edit|Write) ;;
  *) exit 0 ;;
esac

# Prefer project-declared format script. If absent, do nothing.
if [[ -f package.json ]] && jq -e '.scripts.format' package.json >/dev/null 2>&1; then
  if command -v bun >/dev/null 2>&1; then
    bun run format || true
  elif command -v pnpm >/dev/null 2>&1; then
    pnpm run format || true
  else
    npm run format || true
  fi
fi
