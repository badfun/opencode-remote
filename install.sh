#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/opencode-remote"
TARGET="$BIN_DIR/opencode-remote"

mkdir -p "$BIN_DIR" "$CONFIG_DIR"

ln -sfn "$ROOT_DIR/bin/opencode-remote" "$TARGET"
chmod +x "$ROOT_DIR/bin/opencode-remote"

if [[ ! -f "$CONFIG_DIR/env" ]]; then
  cp "$ROOT_DIR/env.example" "$CONFIG_DIR/env"
  chmod 600 "$CONFIG_DIR/env"
  printf 'Created %s from template. Fill in passwords before use.\n' "$CONFIG_DIR/env"
fi

printf 'Installed %s -> %s\n' "$TARGET" "$ROOT_DIR/bin/opencode-remote"
printf 'Run: opencode-remote --help\n'
