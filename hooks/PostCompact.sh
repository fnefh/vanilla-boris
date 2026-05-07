#!/usr/bin/env bash
# Auto-compaction already preserves invoked skills. We only print a
# reminder so the user knows which skills survived and which did not.
set -euo pipefail
echo "[vanilla-boris] Compaction done. Claude Code keeps the most recently"
echo "  invoked skills (5k tokens each, 25k cap). If north-star/plan-first"
echo "  feel less sharp, re-invoke them once and they'll fully reload."
