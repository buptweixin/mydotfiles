#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"

KARABINER_SOURCE="$SCRIPT_DIR/karabiner"
KARABINER_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/karabiner"

# Karabiner-Elements is macOS-only.
if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "Karabiner-Elements is macOS-only; skipping."
	exit 0
fi

karabiner_installed() {
	[[ -d "/Applications/Karabiner-Elements.app" ]]
}

ensure_karabiner_installed() {
	if karabiner_installed; then
		echo "Karabiner-Elements is already installed."
		return
	fi

	echo "Install Karabiner-Elements..."
	brew install --cask karabiner-elements
}

# Link the whole config DIRECTORY, not karabiner.json itself: Karabiner saves
# via temp file + rename (json_writer::save_to_file), and rename(2) over a
# symlinked file replaces the symlink, silently breaking the dotfiles sync.
# With a directory symlink the tmp file is created and renamed inside the
# real directory, so GUI edits land directly in the repo.
link_karabiner_config() {
	local current_src backup_target

	if [[ -L "$KARABINER_CONFIG_DIR" ]]; then
		current_src="$(readlink "$KARABINER_CONFIG_DIR")"
		if [[ "$current_src" == "$KARABINER_SOURCE" ]]; then
			echo "Karabiner config is already linked."
			return
		fi
		# A symlink pointing elsewhere (e.g. another dotfiles checkout):
		# remove it so we can link ours.
		rm "$KARABINER_CONFIG_DIR"
	fi

	if [[ -d "$KARABINER_CONFIG_DIR" ]]; then
		backup_target="${KARABINER_CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
		echo "Backup existing Karabiner config to ${backup_target}"
		mv "$KARABINER_CONFIG_DIR" "$backup_target"

		# First machine: adopt the existing config into the repo.
		if [[ ! -f "$KARABINER_SOURCE/karabiner.json" && -f "$backup_target/karabiner.json" ]]; then
			cp "$backup_target/karabiner.json" "$KARABINER_SOURCE/karabiner.json"
			if [[ -d "$backup_target/assets" ]]; then
				cp -R "$backup_target/assets" "$KARABINER_SOURCE/"
			fi
		fi
	fi

	mkdir -p "$(dirname "$KARABINER_CONFIG_DIR")"
	ln -s "$KARABINER_SOURCE" "$KARABINER_CONFIG_DIR"
	echo "Linked Karabiner config to ${KARABINER_CONFIG_DIR}"
}

ensure_karabiner_installed
link_karabiner_config

# Karabiner keeps karabiner.json at 0600 (it may contain a machine
# identifier); a fresh git clone restores it as 0644.
chmod 600 "$KARABINER_SOURCE/karabiner.json"
