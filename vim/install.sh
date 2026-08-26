#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"

NVIM_CONFIG_SOURCE="$SCRIPT_DIR/nvim"
NVIM_CONFIG_TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

mkdir -p "$(dirname "$NVIM_CONFIG_TARGET")"

if [[ -L "$NVIM_CONFIG_TARGET" ]]; then
	current_src="$(readlink "$NVIM_CONFIG_TARGET")"
	if [[ "$current_src" == "$NVIM_CONFIG_SOURCE" ]]; then
		echo "Neovim config is already linked."
		exit 0
	fi
fi

if [[ -e "$NVIM_CONFIG_TARGET" || -L "$NVIM_CONFIG_TARGET" ]]; then
	backup_target="${NVIM_CONFIG_TARGET}.bak.$(date +%Y%m%d%H%M%S)"
	echo "Backup existing nvim config to ${backup_target}"
	mv "$NVIM_CONFIG_TARGET" "$backup_target"
fi

ln -s "$NVIM_CONFIG_SOURCE" "$NVIM_CONFIG_TARGET"
echo "Linked Neovim config to ${NVIM_CONFIG_TARGET}"
