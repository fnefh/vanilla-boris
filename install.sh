#!/usr/bin/env bash
# vanilla-boris installer.
# Idempotent. Does NOT modify ~/.zshrc or ~/.bashrc without explicit
# confirmation. Does NOT install MCP credentials. Does NOT enable
# --dangerously-skip-permissions, Auto Mode, sandbox, or the @claude bot.
set -euo pipefail

SCOPE="${1:-project}"   # project | personal
case "$SCOPE" in
  project)  TARGET=".claude" ;;
  personal) TARGET="$HOME/.claude" ;;
  *) echo "usage: install.sh [project|personal]"; exit 2 ;;
esac

echo "vanilla-boris → $TARGET"
mkdir -p "$TARGET/skills" "$TARGET/commands" "$TARGET/agents" "$TARGET/hooks"

cp -R skills/*    "$TARGET/skills/"
cp -R commands/*  "$TARGET/commands/"
cp -R agents/*    "$TARGET/agents/"
cp -R hooks/*     "$TARGET/hooks/"
chmod +x "$TARGET/hooks/"*.sh

# v0.4.0: bin/, output-styles/, monitors/ — copy if present.
if [[ -d bin ]]; then
  mkdir -p "$TARGET/bin"
  cp -R bin/* "$TARGET/bin/"
  chmod +x "$TARGET/bin/"*
fi
if [[ -d output-styles ]]; then
  mkdir -p "$TARGET/output-styles"
  cp -R output-styles/* "$TARGET/output-styles/"
fi
if [[ -d monitors ]]; then
  mkdir -p "$TARGET/monitors"
  cp -R monitors/* "$TARGET/monitors/"
fi
# Plugin-level settings (.claude-plugin/settings.json) is the
# Anthropic-documented home for plugin-shipped defaults. We DO NOT
# overwrite the user's personal settings.json here; the file ships
# alongside the plugin and Claude Code reads it when the plugin is
# enabled. See code.claude.com/docs/en/plugins.

# Default settings.local.json template — only written if absent.
# Per PRD §14: never overwrite user's existing settings.
if [[ ! -f "$TARGET/settings.local.json" ]]; then
  cat > "$TARGET/settings.local.json" <<'JSON'
{
  "_comment": "Tune this list with /fewer-permission-prompts. Pair with Auto Mode (skills/auto-mode-onboarding) for fewer prompts on safe operations.",
  "permissions": {
    "defaultMode": "ask",
    "allow": [
      "Read",
      "Grep",
      "Glob",
      "Bash(git status *)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(gh pr view *)",
      "Bash(gh pr list *)",
      "Bash(bun run format *)",
      "Bash(bun run typecheck *)",
      "Bash(bun run test *)",
      "Bash(bun run build:*)",
      "Bash(bun run test:*)",
      "Bash(cc:*)",
      "Bash(bq query *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force *)",
      "Bash(gh pr merge *)",
      "Skill(deploy *)"
    ]
  },
  "cleanupPeriodDays": 30
}
JSON
  echo "  wrote $TARGET/settings.local.json (defaults; tune with /permissions)"
fi

# Per howborisusesclaudecode.com Part 10, tip #4 — verbatim:
#
#   # 400k is Thariq's recommended compromise
#   $ CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude
#
# We do NOT silently edit the user's shell profile. We print the line and
# ask.
cat <<'EOF'

──────────────────────────────────────────────────────────────────
Recommended (per howborisusesclaudecode.com Part 10, tip #4):

    # 400k is Thariq's recommended compromise
    $ CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude

This forces auto-compaction *before* the 300–400k token "context rot"
zone on the 1M-context model. We will NOT add it to your shell profile
without permission.
──────────────────────────────────────────────────────────────────
EOF

read -r -p "Append the export to ~/.zshrc / ~/.bashrc now? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [[ -f "$rc" ]] || continue
    if ! grep -q 'CLAUDE_CODE_AUTO_COMPACT_WINDOW' "$rc"; then
      printf '\n# vanilla-boris: 400k autocompact (Thariq)\nexport CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000\n' >> "$rc"
      echo "  appended to $rc"
    else
      echo "  $rc already sets CLAUDE_CODE_AUTO_COMPACT_WINDOW — left alone"
    fi
  done
else
  echo "  skipped — run \`CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude\` manually."
fi

echo
echo "Installed. Open Claude Code and run:"
echo "    /skills    — verify the 13 skills loaded"
echo "    /commands  — verify the 5 commands"
echo "    /agents    — verify the 3 agents"
echo "    /output-style boris-productivity — try the opt-in voice"
echo "    bun run wizard.ts  — walk through the optional steps"
echo
echo "Bin scripts (vb-verify, vb-snapshot) installed at $TARGET/bin/."
echo "Add it to PATH to use directly:  export PATH=\"$TARGET/bin:\$PATH\""
echo
echo "PermissionRequest.sh ships disabled by default (silent no-op until"
echo "you set VANILLA_BORIS_PERMREQ_ROUTE). See hooks/PermissionRequest.sh."
echo
echo "marketplace.json ships at the repo root. Once published, install via:"
echo "    /plugin marketplace add <git-url>  &&  /plugin install vanilla-boris"
