#!/usr/bin/env bash
# PreCompact — fires BEFORE LLM compaction, while full context still
# exists. Counterpart to PostCompact (which runs after; only sees the
# summary). We use PreCompact to write a hand-rolled session note to
# disk so the lossy summarization doesn't erase it forever.
#
# Per code.claude.com/docs/en/hooks-reference.
set -euo pipefail

sid="${CLAUDE_CODE_SESSION_ID:-unknown}"
notes_dir=".claude/session-notes"
mkdir -p "$notes_dir"
note="$notes_dir/$sid.md"

# Append rather than overwrite — multiple compactions per session.
{
  echo
  echo "## $(date '+%Y-%m-%d %H:%M:%S') — pre-compact note"
  echo
  echo "- session: $sid"
  echo "- edits so far: ${CLAUDE_SESSION_EDIT_COUNT:-0}"
  echo "- /verify invoked: ${CLAUDE_SESSION_VERIFY_INVOKED:-0}"
  echo "- worktree: ${CLAUDE_WORKTREE_NAME:-(none)}"
  echo
  echo "(Anything important that compaction might lose — manually note here"
  echo " or extend this hook to capture more.)"
} >> "$note"

echo "[vanilla-boris] PreCompact: appended session note to $note"
