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
echo "    /skills    — verify the 11 skills loaded"
echo "    /commands  — verify the 5 commands"
echo "    /agents    — verify the 3 agents"
echo "    bun run wizard.ts  — walk through the optional steps"
