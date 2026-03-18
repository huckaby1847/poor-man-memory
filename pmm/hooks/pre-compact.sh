#!/usr/bin/env bash
# PMM pre-compact hook — blocks /compact until memory is saved
set -euo pipefail

PROJECT_HASH=$(pwd | shasum -a 256 | cut -c1-12)
MARKER="/tmp/pmm-compact-ready-$PROJECT_HASH"

# Pass through if PMM not initialised or hook disabled
[ ! -d "memory" ] && exit 0
if [ -f "memory/config.md" ]; then
  MODE=$(grep -oP '(?<=pre_compact: )\S+' memory/config.md 2>/dev/null || echo "on")
  [ "$MODE" = "off" ] && exit 0
fi

# Marker present → save already done, allow compact
if [ -f "$MARKER" ]; then
  rm -f "$MARKER"
  exit 0
fi

# No marker → block compact, signal Claude
cat <<'MSG'
PMM_PRE_COMPACT_SAVE_REQUIRED
Memory has not been saved before this compact.
Run /pmm-save to capture session state, then retry /compact.
MSG
exit 2
