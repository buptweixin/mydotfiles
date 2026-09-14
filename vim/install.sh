#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"

# shellcheck source=script/lib/link.sh
source "$SCRIPT_DIR/../script/lib/link.sh"

NVIM_CONFIG_SOURCE="$SCRIPT_DIR/nvim"
NVIM_CONFIG_TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

link_managed "$NVIM_CONFIG_SOURCE" "$NVIM_CONFIG_TARGET"
