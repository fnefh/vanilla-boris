#!/usr/bin/env bash
# Reminds the user (in their terminal, not in-context) when Claude is
# about to do something at the higher rungs of the autonomy ladder.
#
# v0.4.0: narrowed nudges. Per code.claude.com/docs/en/permissions
# "permission rule syntax", hook configs support an `if:` filter to
# scope hooks to specific tool patterns (`Bash(rm *)` etc.). Shell
# hooks like this one don't have a config-level `if:`; we mimic it by
# matching CLAUDE_TOOL_INPUT for actually-risky patterns.
set -euo pipefail

tool="${CLAUDE_TOOL_NAME:-}"
input="${CLAUDE_TOOL_INPUT:-}"

# Narrow Bash nudge: only the actually-risky patterns.
if [[ "$tool" == "Bash" ]]; then
  case "$input" in
    *"rm -rf "* | *"rm -fr "*)
      echo "[vanilla-boris] destructive rm — autonomy-ladder rung 4." ;;
    *"git push --force"* | *"git push -f"*)
      echo "[vanilla-boris] force-push — autonomy-ladder rung 4." ;;
    *"gh pr merge"*)
      echo "[vanilla-boris] PR merge — autonomy-ladder rung 4." ;;
    *"sudo "*)
      echo "[vanilla-boris] sudo — autonomy-ladder rung 4." ;;
    *)
      # Quiet for the 95% of Bash that's safe (git status, ls, grep, etc.)
      : ;;
  esac
fi

# Edit/Write: only nudge for files outside the worktree (e.g.,
# absolute paths into config directories).
if [[ "$tool" == "Edit" || "$tool" == "Write" ]]; then
  case "$input" in
    /etc/* | /usr/* | /System/* | "$HOME/.zshrc" | "$HOME/.bashrc")
      echo "[vanilla-boris] Edit/Write outside worktree — autonomy-ladder rung 3." ;;
    *)
      : ;;
  esac
fi
