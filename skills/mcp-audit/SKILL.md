---
name: mcp-audit
description: Walk through every MCP server installed in this Claude Code session and decide whether to keep it, scope it down, or remove it. Use before trusting a new repo, after installing anything from a tutorial, or when the user says "what does Claude have access to".
disable-model-invocation: true
allowed-tools: Bash(claude mcp list)
---

## Installed MCP servers
!`claude mcp list 2>/dev/null || echo "(claude mcp list not available — check ~/.claude/mcp.json manually)"`

## Instructions

For each server above, ask the user:

1. **What does it do?** (One sentence. If unknown, look it up — don't
   guess.)
2. **What's the smallest scope it needs?** (Read-only? One repo? One
   directory?)
3. **Where do its credentials come from?** (Env var the user controls, or
   a file Claude can read?)
4. **Keep / scope-down / remove?**

Do not add, modify, or remove MCP credentials yourself. Print the exact
commands the user should run.

For the canonical "MCPs Boris uses daily" list (Slack, BigQuery, Sentry,
Chrome extension, Desktop app web servers, iMessage), see
`${CLAUDE_SKILL_DIR}/../../references/recommended-mcps.md`.

Reference: howborisusesclaudecode.com Part 8 + §"Tool Integrations & MCPs".
