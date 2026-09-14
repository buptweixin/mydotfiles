#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"

# shellcheck source=script/lib/link.sh
source "$SCRIPT_DIR/../script/lib/link.sh"

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
# Link the config directory; a pre-existing one is backed up by
# link_managed, and on the first machine we adopt its contents into the
# repo (the backup may itself be a symlink to another checkout — the -f
# checks resolve through it).
adopt_backup_config() {
	local backup=$1

	[[ -n "$backup" ]] || return 0

	if [[ ! -f "$KARABINER_SOURCE/karabiner.json" && -f "$backup/karabiner.json" ]]; then
		cp "$backup/karabiner.json" "$KARABINER_SOURCE/karabiner.json"
		if [[ -d "$backup/assets" ]]; then
			cp -R "$backup/assets" "$KARABINER_SOURCE/"
		fi
	fi
}

ensure_karabiner_installed
link_managed "$KARABINER_SOURCE" "$KARABINER_CONFIG_DIR"
adopt_backup_config "$LINK_MANAGED_BACKUP"

# Karabiner keeps karabiner.json at 0600 (it may contain a machine
# identifier); a fresh git clone restores it as 0644.
chmod 600 "$KARABINER_SOURCE/karabiner.json"
