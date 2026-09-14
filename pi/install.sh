#!/usr/bin/env bash
#
# pi topic installer.
#
# - Ensures the pi coding agent itself is installed (npm global).
# - Installs every extension listed in packages.txt via `pi install` (idempotent
#   — pi skips already-installed packages, so re-running is safe).
# - Symlinks the read-only per-extension configs (pi-lsp.json, pi-fff.json,
#   rtk-optimizer.json) into ~/.pi/agent/. settings.json is deliberately NOT
#   linked: pi rewrites it at runtime (lastChangelogVersion, package list), so
#   a symlink would let pi mutate this repo. The package set is the source of
#   truth instead (packages.txt + `pi install`).
# - Installs external language servers the configs depend on (ty, ruff via uv;
#   bash-language-server via npm). rtk is installed via the Brewfile instead.

set -euo pipefail

SCRIPT_DIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"

# shellcheck source=script/lib/link.sh
source "$SCRIPT_DIR/../script/lib/link.sh"

PI_AGENT_DIR="$HOME/.pi/agent"
PI_RTK_DIR="$PI_AGENT_DIR/extensions/pi-rtk-optimizer"

ensure_pi_installed() {
	if command -v pi >/dev/null 2>&1; then
		echo "pi is already installed ($(pi --version 2>/dev/null || echo unknown))."
		return
	fi

	if ! command -v npm >/dev/null 2>&1; then
		echo "pi installer: npm is not installed; run script/bootstrap first (the Brewfile installs node/npm)." >&2
		exit 1
	fi

	echo "Installing pi coding agent…"
	npm install -g @earendil-works/pi-coding-agent
}

install_extensions() {
	local packages_file="$SCRIPT_DIR/packages.txt"
	if [[ ! -f "$packages_file" ]]; then
		echo "pi installer: missing $packages_file" >&2
		exit 1
	fi

	# Read installed sources straight from pi's settings.json — the authoritative
	# package list. `pi list` would also work but its output is multi-line per
	# entry; settings.json is a simple grep. `pi install` reruns npm even when a
	# package is already present, so skipping installed ones avoids ~1s each.
	local settings_file="$PI_AGENT_DIR/settings.json"
	local installed
	installed="$(grep -oE '"npm:[^"]+"' "$settings_file" 2>/dev/null | tr -d '"' || true)"

	local count=0
	local total
	total="$(grep -cvE '^[[:space:]]*(#|$)' "$packages_file" || true)"

	while IFS= read -r pkg; do
		# trim, skip blanks and comments
		pkg="${pkg%%#*}"
		pkg="$(echo "$pkg" | tr -d '[:space:]')"
		[[ -z "$pkg" ]] && continue

		if echo "$installed" | grep -qxF "$pkg"; then
			echo "pi: already installed — $pkg"
			continue
		fi

		count=$((count + 1))
		echo "pi install $pkg"
		pi install "$pkg"
	done < "$packages_file"

	if (( count == 0 )); then
		echo "pi: all $total extensions already installed."
	fi
}

link_configs() {
	link_managed "$SCRIPT_DIR/pi-lsp.json"        "$PI_AGENT_DIR/pi-lsp.json"
	link_managed "$SCRIPT_DIR/pi-fff.json"        "$PI_AGENT_DIR/pi-fff.json"
	link_managed "$SCRIPT_DIR/rtk-optimizer.json" "$PI_RTK_DIR/config.json"
}

install_lsp_deps() {
	# ty + ruff (Astral's Python type-checker and linter, used by pi-lsp.json)
	if command -v uv >/dev/null 2>&1; then
		for tool in ty ruff; do
			if command -v "$tool" >/dev/null 2>&1; then
				echo "pi: $tool already installed ($(uv tool list 2>/dev/null | grep -q "^$tool " && echo via-uv || echo on-PATH))"
			else
				echo "uv tool install $tool"
				uv tool install "$tool"
			fi
		done
	else
		echo "pi installer: uv not found; skipping ty/ruff. Install uv (https://docs.astral.sh/uv/) then re-run, or run: pipx install ty ruff" >&2
	fi

	# bash-language-server (shell diagnostics for .sh/.bash/.zsh)
	if command -v bash-language-server >/dev/null 2>&1; then
		echo "pi: bash-language-server already installed."
	elif command -v npm >/dev/null 2>&1; then
		echo "npm install -g bash-language-server"
		npm install -g bash-language-server
	else
		echo "pi installer: npm not found; skipping bash-language-server. Run script/bootstrap first." >&2
	fi
}

ensure_pi_installed
install_extensions
link_configs
install_lsp_deps

echo
echo "pi topic done."
echo "Next: set your provider/model and API keys — these are NOT versioned."
echo "  - edit ~/.pi/agent/settings.json: defaultProvider, defaultModel, theme"
echo "  - pi auth   # add providers/API keys"
echo "  - ~/.pi/agent/auth.json and models.json hold secrets and are gitignored"
