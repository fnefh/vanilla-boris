#!/usr/bin/env bash
# Tests install.sh + uninstall.sh end-to-end in a temp copy of the repo.
# Project scope only.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
tmp=$(mktemp -d)
trap "rm -rf $tmp" EXIT

cp -R "$REPO"/. "$tmp/repo"
pushd "$tmp/repo" >/dev/null

# Non-interactive install (auto-decline shell edits).
# `printf` (one-shot) instead of `yes` (infinite stream) — `yes` triggers
# SIGPIPE under `set -o pipefail` once install.sh exits.
printf 'n\n' | ./install.sh project >/dev/null

expected_skills=13
expected_commands=5
expected_agents=3
expected_hooks=9

# Skills
got_skills=$(ls -1 .claude/skills 2>/dev/null | wc -l | tr -d ' ')
[[ "$got_skills" == "$expected_skills" ]] || { echo "FAIL: skills $got_skills/$expected_skills"; exit 1; }

# Commands
got_commands=$(ls -1 .claude/commands 2>/dev/null | wc -l | tr -d ' ')
[[ "$got_commands" == "$expected_commands" ]] || { echo "FAIL: commands $got_commands/$expected_commands"; exit 1; }

# Agents
got_agents=$(ls -1 .claude/agents 2>/dev/null | wc -l | tr -d ' ')
[[ "$got_agents" == "$expected_agents" ]] || { echo "FAIL: agents $got_agents/$expected_agents"; exit 1; }

# Hooks (count + executable bit)
got_hooks=$(ls -1 .claude/hooks 2>/dev/null | wc -l | tr -d ' ')
[[ "$got_hooks" == "$expected_hooks" ]] || { echo "FAIL: hooks $got_hooks/$expected_hooks"; exit 1; }
for h in UserPromptSubmit.sh PreToolUse.sh PostToolUse.sh \
         SessionStart.sh SessionEnd.sh Stop.sh PreCompact.sh \
         PostCompact.sh PermissionRequest.sh; do
  test -x ".claude/hooks/$h" || { echo "FAIL: not executable: $h"; exit 1; }
done

# v0.3.0 — settings.local.json written on first install
test -f .claude/settings.local.json || { echo "FAIL: settings.local.json not written"; exit 1; }
jq -e '.permissions.defaultMode == "ask"' .claude/settings.local.json >/dev/null \
  || { echo "FAIL: settings.local.json missing permissions.defaultMode"; exit 1; }

# v0.3.0 — plugin.json carries status line + spinner verbs
jq -e '.settings.subagentStatusLine | length > 0' plugin.json >/dev/null \
  || { echo "FAIL: plugin.json missing settings.subagentStatusLine"; exit 1; }
jq -e '.settings.spinnerVerbs | length == 12' plugin.json >/dev/null \
  || { echo "FAIL: plugin.json spinnerVerbs count != 12"; exit 1; }

# v0.4.0 — marketplace.json + .claude-plugin/settings.json + new bins/styles/monitors.
jq -e '.plugins[0].name == "vanilla-boris"' marketplace.json >/dev/null \
  || { echo "FAIL: marketplace.json[0].name != vanilla-boris"; exit 1; }
jq -e '.permissions.defaultMode == "ask"' .claude-plugin/settings.json >/dev/null \
  || { echo "FAIL: .claude-plugin/settings.json missing permissions.defaultMode"; exit 1; }
test -x ".claude/bin/vb-verify"   || { echo "FAIL: bin/vb-verify not installed"; exit 1; }
test -x ".claude/bin/vb-snapshot" || { echo "FAIL: bin/vb-snapshot not installed"; exit 1; }
test -f ".claude/output-styles/boris-productivity.md" \
  || { echo "FAIL: output-styles/boris-productivity.md not installed"; exit 1; }
test -f ".claude/monitors/monitors.json" \
  || { echo "FAIL: monitors/monitors.json not installed"; exit 1; }
jq -e '.monitors | length >= 1' monitors/monitors.json >/dev/null \
  || { echo "FAIL: monitors/monitors.json has no entries"; exit 1; }
jq -e '.version == "0.4.0"' plugin.json >/dev/null \
  || { echo "FAIL: plugin.json version != 0.4.0"; exit 1; }

# Each named skill present
for s in north-star three-loop plan-first go verify parallel-worktrees \
         full-brief challenge-me autonomy-ladder mcp-audit \
         auto-mode-onboarding skill-author learn-codebase; do
  test -f ".claude/skills/$s/SKILL.md" || { echo "FAIL: missing skill: $s"; exit 1; }
done

# Each named command present
for c in babysit post-merge-sweeper pr-pruner slack-feedback north-star-refresh; do
  test -f ".claude/commands/$c.md" || { echo "FAIL: missing command: $c"; exit 1; }
done

# Each named agent present
for a in code-reviewer verifier simplifier; do
  test -f ".claude/agents/$a.md" || { echo "FAIL: missing agent: $a"; exit 1; }
done

# Idempotency — run install again, counts must match
printf 'n\n' | ./install.sh project >/dev/null
[[ "$(ls -1 .claude/skills | wc -l | tr -d ' ')" == "$expected_skills" ]] || { echo "FAIL: not idempotent"; exit 1; }

# Acceptance criterion 17: --dangerously-skip-permissions not invoked in
# the installed surface. Defensive prose mentions (e.g. "we do NOT enable
# --dangerously-skip-permissions") are allowed; actual invocations
# (which would look like `claude ... --dangerously-skip-permissions ...`
# with no preceding "not"/"NOT"/"never") are not. We grep for the flag
# in shell-script context only.
if grep -rE '^[^#]*\bclaude[^|&;]*--dangerously-skip-permissions' \
        .claude/hooks 2>/dev/null; then
  echo "FAIL: --dangerously-skip-permissions invoked in installed hooks"
  exit 1
fi

# Uninstall — must remove our copies, leave hooks/ dir if other files exist
./uninstall.sh project >/dev/null
for s in north-star three-loop plan-first go verify parallel-worktrees \
         full-brief challenge-me autonomy-ladder mcp-audit \
         auto-mode-onboarding skill-author; do
  test ! -d ".claude/skills/$s" || { echo "FAIL: skill not removed: $s"; exit 1; }
done
for c in babysit post-merge-sweeper pr-pruner slack-feedback north-star-refresh; do
  test ! -f ".claude/commands/$c.md" || { echo "FAIL: command not removed: $c"; exit 1; }
done
for a in code-reviewer verifier simplifier; do
  test ! -f ".claude/agents/$a.md" || { echo "FAIL: agent not removed: $a"; exit 1; }
done

# Shell profile NOT modified (we passed `yes n`)
for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
  [[ -f "$rc" ]] || continue
  if grep -q "vanilla-boris: 400k autocompact" "$rc"; then
    echo "FAIL: shell profile $rc was modified despite 'n' answer"
    exit 1
  fi
done

popd >/dev/null
echo "install.test.sh OK"
