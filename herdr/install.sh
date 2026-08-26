#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"

HERDR_CONFIG_SOURCE="$SCRIPT_DIR/config.toml"
HERDR_CONFIG_TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/herdr/config.toml"
COMPLETIONS_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/completions"

if ! command -v herdr >/dev/null 2>&1; then
	echo "herdr is not installed; run script/bootstrap (the Brewfile installs it)." >&2
	exit 1
fi

link_herdr_config() {
	local current_src backup_target

	mkdir -p "$(dirname "$HERDR_CONFIG_TARGET")"

	if [[ -L "$HERDR_CONFIG_TARGET" ]]; then
		current_src="$(readlink "$HERDR_CONFIG_TARGET")"
		if [[ "$current_src" == "$HERDR_CONFIG_SOURCE" ]]; then
			echo "Herdr config is already linked."
			return
		fi
	fi

	if [[ -e "$HERDR_CONFIG_TARGET" || -L "$HERDR_CONFIG_TARGET" ]]; then
		backup_target="${HERDR_CONFIG_TARGET}.bak.$(date +%Y%m%d%H%M%S)"
		echo "Backup existing Herdr config to ${backup_target}"
		mv "$HERDR_CONFIG_TARGET" "$backup_target"
	fi

	ln -s "$HERDR_CONFIG_SOURCE" "$HERDR_CONFIG_TARGET"
	echo "Linked Herdr config to ${HERDR_CONFIG_TARGET}"
}

generate_completion() {
	mkdir -p "$COMPLETIONS_DIR"
	herdr completion zsh >| "$COMPLETIONS_DIR/_herdr"
	echo "Generated herdr completion to ${COMPLETIONS_DIR}/_herdr"
}

link_herdr_config
generate_completion
