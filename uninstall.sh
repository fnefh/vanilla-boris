#!/usr/bin/env bash
# Removes only what install.sh added. Leaves CLAUDE.md, user MCP config,
# and the user's shell profile alone unless they pass --shell.
set -euo pipefail

SCOPE="${1:-project}"
case "$SCOPE" in
  project)  TARGET=".claude" ;;
  personal) TARGET="$HOME/.claude" ;;
  *) echo "usage: uninstall.sh [project|personal] [--shell]"; exit 2 ;;
esac

# Skills
for s in north-star three-loop plan-first go verify parallel-worktrees \
         full-brief challenge-me autonomy-ladder mcp-audit \
         auto-mode-onboarding skill-author; do
  rm -rf "$TARGET/skills/$s"
done

# Commands
for c in babysit post-merge-sweeper pr-pruner slack-feedback \
         north-star-refresh; do
  rm -f "$TARGET/commands/$c.md"
done

# Agents
for a in code-reviewer verifier simplifier; do
  rm -f "$TARGET/agents/$a.md"
done

# Hooks (only remove if it's our copy — compare against the repo's version)
for h in UserPromptSubmit.sh PreToolUse.sh PostToolUse.sh \
         SessionStart.sh SessionEnd.sh Stop.sh PostCompact.sh \
         PermissionRequest.sh; do
  if [[ -f "$TARGET/hooks/$h" ]] && cmp -s "hooks/$h" "$TARGET/hooks/$h"; then
    rm -f "$TARGET/hooks/$h"
  fi
done

if [[ "${2:-}" == "--shell" ]]; then
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [[ -f "$rc" ]] || continue
    sed -i.bak '/# vanilla-boris: 400k autocompact/,+1d' "$rc"
  done
fi

echo "vanilla-boris uninstalled from $TARGET."
echo "CLAUDE.md, MCP config, Auto Mode, sandbox, the @claude bot, and"
echo "other settings were not touched."
