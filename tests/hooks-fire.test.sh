#!/usr/bin/env bash
# Synthetic-event tests for each hook. No Claude Code session needed.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

# UserPromptSubmit — non-trivial prompt should nudge.
export CLAUDE_USER_PROMPT="please refactor the entire authentication layer"
out=$(./hooks/UserPromptSubmit.sh)
echo "$out" | grep -q "non-trivial" \
  || { echo "FAIL: UserPromptSubmit didn't nudge"; exit 1; }

# UserPromptSubmit — short trivial prompt should NOT nudge.
export CLAUDE_USER_PROMPT="hi"
out=$(./hooks/UserPromptSubmit.sh)
[[ -z "$out" ]] \
  || { echo "FAIL: UserPromptSubmit nudged on trivial prompt: $out"; exit 1; }

# PreToolUse — Bash should warn rung 4.
export CLAUDE_TOOL_NAME=Bash
out=$(./hooks/PreToolUse.sh)
echo "$out" | grep -q "rung 4" \
  || { echo "FAIL: PreToolUse didn't warn for Bash"; exit 1; }

# PreToolUse — Edit should warn rung 3.
export CLAUDE_TOOL_NAME=Edit
out=$(./hooks/PreToolUse.sh)
echo "$out" | grep -q "rung 3" \
  || { echo "FAIL: PreToolUse didn't warn for Edit"; exit 1; }

# PreToolUse — Read should be silent.
export CLAUDE_TOOL_NAME=Read
out=$(./hooks/PreToolUse.sh)
[[ -z "$out" ]] \
  || { echo "FAIL: PreToolUse warned on Read: $out"; exit 1; }
unset CLAUDE_TOOL_NAME

# PostToolUse — no package.json means silent no-op.
tmp=$(mktemp -d); trap "rm -rf $tmp" EXIT
pushd "$tmp" >/dev/null
export CLAUDE_TOOL_NAME=Edit
"$REPO/hooks/PostToolUse.sh" >/dev/null 2>&1 \
  || { echo "FAIL: PostToolUse failed in repo without package.json"; exit 1; }
unset CLAUDE_TOOL_NAME
popd >/dev/null

# SessionStart — should print summary.
out=$(./hooks/SessionStart.sh)
echo "$out" | grep -q "session start" \
  || { echo "FAIL: SessionStart didn't print summary"; exit 1; }

# Stop — should nudge when edits>0 and verify=0.
export CLAUDE_SESSION_EDIT_COUNT=3
export CLAUDE_SESSION_VERIFY_INVOKED=0
out=$(./hooks/Stop.sh)
echo "$out" | grep -q "did not run /verify" \
  || { echo "FAIL: Stop didn't nudge"; exit 1; }

# Stop — should be silent when verify=1.
export CLAUDE_SESSION_EDIT_COUNT=3
export CLAUDE_SESSION_VERIFY_INVOKED=1
out=$(./hooks/Stop.sh)
[[ -z "$out" ]] \
  || { echo "FAIL: Stop nudged despite verify=1: $out"; exit 1; }

# Stop — should be silent when no edits.
export CLAUDE_SESSION_EDIT_COUNT=0
export CLAUDE_SESSION_VERIFY_INVOKED=0
out=$(./hooks/Stop.sh)
[[ -z "$out" ]] \
  || { echo "FAIL: Stop nudged despite zero edits: $out"; exit 1; }
unset CLAUDE_SESSION_EDIT_COUNT CLAUDE_SESSION_VERIFY_INVOKED

# PostCompact — should print reminder.
out=$(./hooks/PostCompact.sh)
echo "$out" | grep -q "Compaction done" \
  || { echo "FAIL: PostCompact didn't print reminder"; exit 1; }

echo "hooks-fire.test.sh OK"
