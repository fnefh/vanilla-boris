---
name: autonomy-ladder
description: Reference content for the four-rung autonomy ladder (read-only → suggest → apply → commit). Loaded automatically when the user discusses permissions, automation, or "what should Claude be allowed to do".
user-invocable: false
---

Per howborisusesclaudecode.com Part 7, autonomy is a ladder, not a switch:

1. **Read-only.** Default for unfamiliar repos. Claude reads, summarizes,
   proposes diffs in chat. The user applies them.
2. **Suggest.** Claude proposes Edits and waits for approval per call.
3. **Apply.** Claude edits files autonomously but does not run shell
   commands beyond `allowed-tools` rules.
4. **Commit.** Claude can run `git commit` (but not `push`, not `gh pr
   merge`, not `rm -rf`).

Rules:
- Never auto-promote. Promotion is always an explicit user decision.
- `--dangerously-skip-permissions` belongs nowhere in this plugin.
- New MCP servers default to read-only. See `mcp-audit`.
- **Auto Mode** (see `skills/auto-mode-onboarding`) sits *alongside* the
  ladder, not above it. It approves the obviously-safe; the ladder
  governs everything else.
