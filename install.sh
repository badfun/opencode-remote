#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/opencode-remote"
TARGET="$BIN_DIR/opencode-remote"
REPO_SLUG="${OPENCODE_REMOTE_REPO_SLUG:-badfun/opencode-remote}"
REPO_REF="${OPENCODE_REMOTE_REPO_REF:-main}"

is_stdin_install() {
  [[ "${BASH_SOURCE[0]:-}" == "bash" ]] && return 0
  [[ "${BASH_SOURCE[0]:-}" == "main" ]] && return 0
  [[ -z "${BASH_SOURCE[0]:-}" ]] && return 0
  case "${BASH_SOURCE[0]}" in /dev/stdin|/dev/fd/*) return 0 ;; esac
  return 1
}

ensure_path_in_shell_config() {
  case ":$PATH:" in
    *":$BIN_DIR:"*) return 0 ;;
  esac

  local rc_files=()
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    rc_files=("$HOME/.zshrc")
  elif [[ -n "${BASH_VERSION:-}" ]]; then
    rc_files=("$HOME/.bashrc")
  else
    rc_files=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile")
  fi

  for rc in "${rc_files[@]}"; do
    if [[ -f "$rc" ]]; then
      printf '\n# added by opencode-remote install.sh\n' >> "$rc"
      printf 'export PATH="%s:$PATH"\n' "$BIN_DIR" >> "$rc"
      printf 'Added %s to PATH in %s\n' "$BIN_DIR" "$rc"
      printf 'Restart your shell or run: source %s\n' "$rc"
      return 0
    fi
  done

  printf 'Warning: %s is not on PATH and no shell config was found.\n' "$BIN_DIR"
  printf 'Add this line to your shell config:\n  export PATH="%s:$PATH"\n' "$BIN_DIR"
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
  curl -fsSL "${REMOTE_BASE}/bin/opencode-remote" -o "$TARGET" || exit 1
  chmod +x "$TARGET"
  write_env_template
  printf 'Installed %s from %s\n' "$TARGET" "$REMOTE_BASE"
else
  ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
  ln -sfn "$ROOT_DIR/bin/opencode-remote" "$TARGET"
  chmod +x "$ROOT_DIR/bin/opencode-remote"
  if [[ ! -f "$CONFIG_DIR/env" ]]; then
    cp "$ROOT_DIR/env.example" "$CONFIG_DIR/env"
    chmod 600 "$CONFIG_DIR/env"
    printf 'Created %s from template. Fill in passwords before use.\n' "$CONFIG_DIR/env"
  fi
  printf 'Installed %s -> %s\n' "$TARGET" "$ROOT_DIR/bin/opencode-remote"
fi

ensure_path_in_shell_config

printf 'Run: opencode-remote --help\n'
