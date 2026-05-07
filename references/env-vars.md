# CLAUDE_* environment variables

Source: code.claude.com/docs (cross-checked 2026-05-07). Boris's site
mentions "84 environment variables"; the docs list **102+**. This is the
high-value subset, grouped by purpose. The full list lives in the
official docs.

## Context & compaction

| Var | Purpose |
|---|---|
| `CLAUDE_CODE_AUTO_COMPACT_WINDOW` | Force compaction at this token threshold (Boris recommends `400000`). |
| `CLAUDE_CODE_AUTOCOMPACT_PCT_OVERRIDE` | Override the percentage-of-window default. |
| `CLAUDE_CODE_MAX_CONTEXT_TOKENS` | Hard cap on context window. |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Hard cap on per-turn output. |
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | Cap on Read tool output. |

## Effort & thinking

| Var | Purpose |
|---|---|
| `CLAUDE_CODE_EFFORT_LEVEL` | `low` / `medium` / `high` / `xhigh` / `max`. |
| `CLAUDE_CODE_DISABLE_THINKING` | Turn off thinking entirely. |
| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` | Force fixed (non-adaptive) thinking, Opus 4.7. |
| `CLAUDE_CODE_DISABLE_FAST_MODE` | Disable fast mode for Opus 4.6+. |

## Subagents

| Var | Purpose |
|---|---|
| `CLAUDE_CODE_SUBAGENT_MODEL` | Override the model used for spawned subagents. |
| `CLAUDE_CODE_FORK_SUBAGENT` | Toggle the fork-subagent feature. |

## Hooks (used by our hooks/*.sh)

| Var | Source | Purpose |
|---|---|---|
| `CLAUDE_USER_PROMPT` | UserPromptSubmit | The user's most recent prompt. |
| `CLAUDE_TOOL_NAME` | PreToolUse / PostToolUse | The tool about to run / that just ran. |
| `CLAUDE_PERMISSION_PROMPT` | PermissionRequest | The prompt text describing why permission is needed. |
| `CLAUDE_SESSION_EDIT_COUNT` | Stop / SessionEnd | Number of file edits in the session. |
| `CLAUDE_SESSION_VERIFY_INVOKED` | Stop / SessionEnd | `1` if `/verify` was invoked, else `0`. |
| `CLAUDE_CODE_SESSION_ID` | All | Stable session identifier. |
| `CLAUDE_CODE_REMOTE_SESSION_ID` | All | Set when running under remote-control. |
| `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` | settings | Per-hook timeout for SessionEnd. |

## Worktrees

| Var | Purpose |
|---|---|
| `CLAUDE_WORKTREE_NAME` | Auto-set when running under `--worktree`. |
| `CLAUDE_WORKTREE_REV` | Worktree revision. |
| `CLAUDE_WORKTREE_PATH` | Absolute path to the worktree. |

## Plugin / skill data

| Var | Purpose |
|---|---|
| `CLAUDE_SKILL_DIR` | Set inside skill execution; absolute path of the skill. |
| `CLAUDE_PLUGIN_DATA` | Per-plugin persistent storage directory (survives upgrades). |

## Logging

| Var | Purpose |
|---|---|
| `CLAUDE_CODE_DEBUG_LOGS_DIR` | Where to write debug logs. |
| `CLAUDE_CODE_DEBUG_LOG_LEVEL` | `error` / `warn` / `info` / `debug`. |

## Glob & file walk

| Var | Purpose |
|---|---|
| `CLAUDE_CODE_GLOB_HIDDEN` | Include dot-files in glob results. |
| `CLAUDE_CODE_GLOB_NO_IGNORE` | Don't honor `.gitignore` during glob. |
| `CLAUDE_CODE_GLOB_TIMEOUT_SECONDS` | Cap glob walk time. |

## Shell

| Var | Purpose |
|---|---|
| `CLAUDE_CODE_SHELL` | Override the shell used for Bash tool. |
| `CLAUDE_CODE_SHELL_PREFIX` | Prepend to every shell command. |
| `CLAUDE_CODE_USE_POWERSHELL_TOOL` | Windows: route to PowerShell. |

## Plugin-defined (vanilla-boris)

These are *ours*, not Anthropic's. Documented here so users know what
the hooks read.

| Var | Used by | Purpose |
|---|---|---|
| `VANILLA_BORIS_NOTIFY_SOUND` | `hooks/Stop.sh` | Set to `1` to play a sound when Stop fires with un-verified edits. |
| `VANILLA_BORIS_NOTIFY_SLACK` | `hooks/Stop.sh` | A Slack webhook URL to ping with stop summaries. |
| `VANILLA_BORIS_PERMREQ_ROUTE` | `hooks/PermissionRequest.sh` | `slack` / `opus` / `whatsapp` to route permission prompts. |
| `VANILLA_BORIS_PERMREQ_SLACK_WEBHOOK` | `hooks/PermissionRequest.sh` | Webhook for `slack` route. |

For the full official list (auth helpers, OTel, Bedrock/Vertex, IDE
flags, network/cert vars, etc.) see code.claude.com/docs.
