#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/opencode-remote"
TARGET="$BIN_DIR/opencode-remote"
REPO_SLUG="${OPENCODE_REMOTE_REPO_SLUG:-badfun/opencode-remote}"
REPO_REF="${OPENCODE_REMOTE_REPO_REF:-main}"

is_stdin_install() {
  case "${BASH_SOURCE[0]:-}" in
    /dev/stdin|/dev/fd/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

write_env_template() {
  if [[ ! -f "$CONFIG_DIR/env" ]]; then
    cat >"$CONFIG_DIR/env" <<'EOF'
# Copy to ~/.config/opencode-remote/env and set real values.

# Required
OPENCODE_SERVER_PASSWORD="replace-with-strong-password"
OPENCHAMBER_UI_PASSWORD="replace-with-strong-password"

# Optional
# OPENCODE_HOST="http://127.0.0.1:4096"
# OPENCHAMBER_HOST="0.0.0.0"
# OPENCHAMBER_PORT="3000"

# Legacy compatibility (if you still use old env files)
# WATCHER_ENV_FILE="$HOME/.config/opencode-watcher/env"
# OPENCHAMBER_ENV_FILE="$HOME/.config/openchamber/env"
EOF
    chmod 600 "$CONFIG_DIR/env"
    printf 'Created %s from template. Fill in passwords before use.\n' "$CONFIG_DIR/env"
  fi
}

mkdir -p "$BIN_DIR" "$CONFIG_DIR"

if is_stdin_install; then
  REMOTE_BASE="https://raw.githubusercontent.com/${REPO_SLUG}/${REPO_REF}"
  curl -fsSL "${REMOTE_BASE}/bin/opencode-remote" -o "$TARGET"
  chmod +x "$TARGET"
  write_env_template
  printf 'Installed %s from %s\n' "$TARGET" "$REMOTE_BASE"
else
  ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  ln -sfn "$ROOT_DIR/bin/opencode-remote" "$TARGET"
  chmod +x "$ROOT_DIR/bin/opencode-remote"
  if [[ ! -f "$CONFIG_DIR/env" ]]; then
    cp "$ROOT_DIR/env.example" "$CONFIG_DIR/env"
    chmod 600 "$CONFIG_DIR/env"
    printf 'Created %s from template. Fill in passwords before use.\n' "$CONFIG_DIR/env"
  fi
  printf 'Installed %s -> %s\n' "$TARGET" "$ROOT_DIR/bin/opencode-remote"
fi

printf 'Run: opencode-remote --help\n'
