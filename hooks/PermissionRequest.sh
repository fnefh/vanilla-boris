#!/usr/bin/env bash
# Optional: route permission requests to Slack / WhatsApp / Opus.
# DISABLED by default. Per howborisusesclaudecode.com §"Hooks &
# Lifecycle Logic", PermissionRequest can route approvals to external
# systems. We ship this file as a reference impl, gated behind env vars
# so it's a no-op until the user opts in by setting:
#
#   VANILLA_BORIS_PERMREQ_ROUTE=slack          # or "opus" or "whatsapp"
#   VANILLA_BORIS_PERMREQ_SLACK_WEBHOOK=https://hooks.slack.com/...
#
# Without the env vars set, this hook exits 0 silently and Claude Code
# falls back to its default in-terminal prompt.
set -euo pipefail

route="${VANILLA_BORIS_PERMREQ_ROUTE:-}"
[[ -z "$route" ]] && exit 0   # silent no-op when not configured

tool="${CLAUDE_TOOL_NAME:-?}"
prompt="${CLAUDE_PERMISSION_PROMPT:-(no prompt context)}"

case "$route" in
  slack)
    webhook="${VANILLA_BORIS_PERMREQ_SLACK_WEBHOOK:-}"
    [[ -z "$webhook" ]] && { echo "[vanilla-boris] route=slack but no webhook"; exit 0; }
    payload=$(jq -nc --arg t "$tool" --arg p "$prompt" \
              '{text: "Claude Code permission request: \($t)\n\($p)"}')
    curl -fsS -X POST -H 'Content-Type: application/json' \
         -d "$payload" "$webhook" >/dev/null 2>&1 || true
    ;;
  opus)
    # Route to a higher-effort model for a yes/no decision. The
    # decision protocol is documented at code.claude.com/docs/en/hooks
    # under "type: prompt" — this shell-hook variant just logs.
    echo "[vanilla-boris] PermissionRequest → opus (configure type:prompt hook for full impl)"
    ;;
  whatsapp)
    echo "[vanilla-boris] PermissionRequest → whatsapp (impl: twilio API; configure VANILLA_BORIS_PERMREQ_TWILIO_*)"
    ;;
  *)
    echo "[vanilla-boris] unknown route: $route (expected slack|opus|whatsapp)"
    ;;
esac

exit 0
