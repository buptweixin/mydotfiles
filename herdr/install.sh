#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"

# shellcheck source=script/lib/link.sh
source "$SCRIPT_DIR/../script/lib/link.sh"

HERDR_CONFIG_SOURCE="$SCRIPT_DIR/config.toml"
HERDR_CONFIG_TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/herdr/config.toml"
HERDR_DETECTION_REMOTE="$HOME/.local/state/herdr/agent-detection/remote/claude.toml"
HERDR_DETECTION_SNIPPET="$SCRIPT_DIR/starfactory-detection-additions.toml"
HERDR_DETECTION_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/herdr/agent-detection"
HERDR_DETECTION_TARGET="$HERDR_DETECTION_DIR/claude.toml"
COMPLETIONS_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/completions"

if ! command -v herdr >/dev/null 2>&1; then
	echo "herdr is not installed; run script/bootstrap (the Brewfile installs it)." >&2
	exit 1
fi

sync_starfactory_detection() {
	# StarFactory (the `star` internal Claude Code fork) is recognized via
	# herdr's claude manifest + HERDR_AGENT=claude (see zsh/aliases.zsh).
	# The zh-CN UI needs extra blocked-state rules, kept in the snippet.
	# This regenerates the local override from whatever upstream claude
	# manifest is currently cached, so English rules keep tracking herdr
	# releases. Upstream update path: herdr server update-agent-manifests,
	# then rerun this installer.
	local staged

	if [[ ! -f "$HERDR_DETECTION_SNIPPET" ]]; then
		return 0
	fi

	if [[ ! -f "$HERDR_DETECTION_REMOTE" ]]; then
		echo "No cached claude detection manifest; start herdr once so it fetches one, then rerun this installer to install the StarFactory overlay."
		return 0
	fi

	mkdir -p "$HERDR_DETECTION_DIR"
	staged="$(mktemp "${TMPDIR:-/tmp}/herdr-claude-detect.XXXXXX")"
	cat "$HERDR_DETECTION_REMOTE" "$HERDR_DETECTION_SNIPPET" >| "$staged"

	if cmp -s "$staged" "$HERDR_DETECTION_TARGET"; then
		rm -f "$staged"
		echo "StarFactory detection override already up to date."
	else
		mv "$staged" "$HERDR_DETECTION_TARGET"
		echo "Installed StarFactory detection overlay at ${HERDR_DETECTION_TARGET}"
	fi

	if [[ -S "${XDG_CONFIG_HOME:-$HOME/.config}/herdr/herdr.sock" ]]; then
		herdr server reload-agent-manifests >/dev/null 2>&1 || true
	fi
}

generate_completion() {
	mkdir -p "$COMPLETIONS_DIR"
	herdr completion zsh >| "$COMPLETIONS_DIR/_herdr"
	echo "Generated herdr completion to ${COMPLETIONS_DIR}/_herdr"
}

link_managed "$HERDR_CONFIG_SOURCE" "$HERDR_CONFIG_TARGET"
sync_starfactory_detection
generate_completion
