#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

# shellcheck source=script/lib/link.sh
source "$SCRIPT_DIR/../script/lib/link.sh"

SSH_DIR="$HOME/.ssh"
SSH_CONFIG="$SSH_DIR/config"
SSH_CONFIG_D_DIR="$SSH_DIR/config.d"
SSH_CONTROLMASTERS_DIR="$SSH_DIR/controlmasters"
SSH_LOCAL_CONFIG="$SSH_DIR/config.local"

SOURCE_SHARED_CONFIG="$SCRIPT_DIR/config.d/50-dotfiles.conf"
TARGET_SHARED_CONFIG="$SSH_CONFIG_D_DIR/50-dotfiles.conf"
SOURCE_LOCAL_TEMPLATE="$SCRIPT_DIR/config.local.example"

ensure_include_line() {
  local config_file=$1
  local include_line=$2
  local temp_file

  if grep -Fqx "$include_line" "$config_file" 2>/dev/null; then
    return
  fi

  temp_file="$(mktemp)"
  {
    printf '%s\n' "$include_line"
    cat "$config_file"
  } >"$temp_file"
  mv "$temp_file" "$config_file"
}

mkdir -p "$SSH_DIR" "$SSH_CONFIG_D_DIR" "$SSH_CONTROLMASTERS_DIR"
chmod 700 "$SSH_DIR" "$SSH_CONTROLMASTERS_DIR"

link_managed "$SOURCE_SHARED_CONFIG" "$TARGET_SHARED_CONFIG"

if [[ ! -e "$SSH_CONFIG" ]]; then
  cat >"$SSH_CONFIG" <<'EOF'
Include ~/.ssh/config.d/*.conf
Include ~/.ssh/config.local

# Add host-specific entries here or in ~/.ssh/config.local.
EOF
  chmod 600 "$SSH_CONFIG"
  echo "Created ${SSH_CONFIG}"
else
  ensure_include_line "$SSH_CONFIG" "Include ~/.ssh/config.local"
  ensure_include_line "$SSH_CONFIG" "Include ~/.ssh/config.d/*.conf"
  chmod 600 "$SSH_CONFIG" 2>/dev/null || true
  echo "Ensured include directives in ${SSH_CONFIG}"
fi

if [[ ! -e "$SSH_LOCAL_CONFIG" ]]; then
  cp "$SOURCE_LOCAL_TEMPLATE" "$SSH_LOCAL_CONFIG"
  chmod 600 "$SSH_LOCAL_CONFIG"
  echo "Created ${SSH_LOCAL_CONFIG} from template"
fi
