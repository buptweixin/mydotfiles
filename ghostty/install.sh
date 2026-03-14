#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"

GHOSTTY_CONFIG_SOURCE="$SCRIPT_DIR/config.ghostty"

if [[ "$(uname -s)" == "Darwin" ]]; then
	GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
	GHOSTTY_CONFIG_TARGET="$GHOSTTY_CONFIG_DIR/config.ghostty"
else
	GHOSTTY_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
	GHOSTTY_CONFIG_TARGET="$GHOSTTY_CONFIG_DIR/config"
fi

ghostty_installed() {
	if command -v ghostty >/dev/null 2>&1; then
		return 0
	fi

	brew list --cask ghostty >/dev/null 2>&1
}

ensure_ghostty_installed() {
	if ghostty_installed; then
		echo "Ghostty is already installed."
		return
	fi

	echo "Install Ghostty..."
	brew install --cask ghostty
}

link_ghostty_config() {
	local current_src backup_target

	mkdir -p "$GHOSTTY_CONFIG_DIR"

	if [[ -L "$GHOSTTY_CONFIG_TARGET" ]]; then
		current_src="$(readlink "$GHOSTTY_CONFIG_TARGET")"
		if [[ "$current_src" == "$GHOSTTY_CONFIG_SOURCE" ]]; then
			echo "Ghostty config is already linked."
			return
		fi
	fi

	if [[ -e "$GHOSTTY_CONFIG_TARGET" || -L "$GHOSTTY_CONFIG_TARGET" ]]; then
		backup_target="${GHOSTTY_CONFIG_TARGET}.bak.$(date +%Y%m%d%H%M%S)"
		echo "Backup existing Ghostty config to ${backup_target}"
		mv "$GHOSTTY_CONFIG_TARGET" "$backup_target"
	fi

	ln -s "$GHOSTTY_CONFIG_SOURCE" "$GHOSTTY_CONFIG_TARGET"
	echo "Linked Ghostty config to ${GHOSTTY_CONFIG_TARGET}"
}

ensure_ghostty_installed
link_ghostty_config
