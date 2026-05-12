#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/.local/bin/opencode-remote"

if [[ -L "$TARGET" || -f "$TARGET" ]]; then
  rm -f "$TARGET"
  printf 'Removed %s\n' "$TARGET"
else
  printf 'No install found at %s\n' "$TARGET"
fi
