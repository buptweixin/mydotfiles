#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"

# shellcheck source=script/lib/link.sh
source "$SCRIPT_DIR/../script/lib/link.sh"

GHOSTTY_CONFIG_SOURCE="$SCRIPT_DIR/config.ghostty"

if [[ "$(uname -s)" == "Darwin" ]]; then
	GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
else
	GHOSTTY_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
fi
# Ghostty's canonical config filename is `config` (no extension); the
# `config.ghostty` alias only exists on newer versions.
GHOSTTY_CONFIG_TARGET="$GHOSTTY_CONFIG_DIR/config"

ghostty_installed() {
	command -v ghostty >/dev/null 2>&1
}

ensure_ghostty_installed() {
	if ghostty_installed; then
		echo "Ghostty is already installed."
		return
	fi

	if [[ "$(uname -s)" == "Darwin" ]]; then
		echo "Install Ghostty..."
		brew install --cask ghostty
	else
		# brew casks are macOS-only; on Linux install via your system
		# package manager (e.g. apt/zypper) before re-running this script.
		echo "Ghostty not found. Install it with your system package manager," >&2
		echo "then re-run this script to link the config." >&2
	fi
}

ensure_ghostty_installed
link_managed "$GHOSTTY_CONFIG_SOURCE" "$GHOSTTY_CONFIG_TARGET"
