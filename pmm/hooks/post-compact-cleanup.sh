#!/usr/bin/env bash
# PMM post-compact cleanup — remove stale marker
PROJECT_HASH=$(pwd | shasum -a 256 | cut -c1-12)
rm -f "/tmp/pmm-compact-ready-$PROJECT_HASH"
exit 0
