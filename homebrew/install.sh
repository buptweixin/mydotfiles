#!/usr/bin/env bash
#
# Homebrew
#
# Installs Homebrew and applies the default TUNA mirror configuration.

set -euo pipefail

readonly TUNA_HOMEBREW_GIT_BASE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew"
readonly TUNA_HOMEBREW_BOTTLE_BASE="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
readonly TUNA_PYPI_SIMPLE_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

info() {
	printf "  %s\n" "$1"
}

tuna_homebrew_enabled() {
	[[ "${DOTFILES_DISABLE_TUNA_HOMEBREW:-0}" != "1" ]]
}

set_default_mirror_env() {
	if ! tuna_homebrew_enabled; then
		return
	fi

	export HOMEBREW_BREW_GIT_REMOTE="${HOMEBREW_BREW_GIT_REMOTE:-$TUNA_HOMEBREW_GIT_BASE/brew.git}"
	export HOMEBREW_CORE_GIT_REMOTE="${HOMEBREW_CORE_GIT_REMOTE:-$TUNA_HOMEBREW_GIT_BASE/homebrew-core.git}"
	export HOMEBREW_API_DOMAIN="${HOMEBREW_API_DOMAIN:-$TUNA_HOMEBREW_BOTTLE_BASE/api}"
	export HOMEBREW_BOTTLE_DOMAIN="${HOMEBREW_BOTTLE_DOMAIN:-$TUNA_HOMEBREW_BOTTLE_BASE}"
	export HOMEBREW_PIP_INDEX_URL="${HOMEBREW_PIP_INDEX_URL:-$TUNA_PYPI_SIMPLE_URL}"
	export HOMEBREW_INSTALL_FROM_API="${HOMEBREW_INSTALL_FROM_API:-1}"
}

find_brew_binary() {
	local candidates=()
	local candidate
	local brew_from_path

	brew_from_path="$(command -v brew 2>/dev/null || true)"
	if [[ -n "$brew_from_path" ]]; then
		candidates+=("$brew_from_path")
	fi

	candidates+=(
		/opt/homebrew/bin/brew
		/usr/local/bin/brew
		"$HOME/.linuxbrew/bin/brew"
		/home/linuxbrew/.linuxbrew/bin/brew
	)

	for candidate in "${candidates[@]}"; do
		if [[ -x "$candidate" ]]; then
			printf '%s\n' "$candidate"
			return 0
		fi
	done

	return 1
}

load_brew_shellenv() {
	local brew_bin

	brew_bin="$(find_brew_binary || true)"
	if [[ -n "$brew_bin" ]]; then
		eval "$("$brew_bin" shellenv)"
	fi
}

install_homebrew() {
	local install_dir

	if command -v brew >/dev/null 2>&1; then
		return
	fi

	info "Installing Homebrew"

	if tuna_homebrew_enabled; then
		install_dir="$(mktemp -d "${TMPDIR:-/tmp}/brew-install.XXXXXX")"
		git clone --depth=1 "$TUNA_HOMEBREW_GIT_BASE/install.git" "$install_dir"
		/bin/bash "$install_dir/install.sh"
		rm -rf "$install_dir"
	else
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
}

retarget_brew_remote() {
	local tap_name=$1
	local remote_url=$2
	local taps

	taps="$(brew tap 2>/dev/null || true)"
	if printf '%s\n' "$taps" | grep -qx "$tap_name"; then
		brew tap --custom-remote "$tap_name" "$remote_url"
	fi
}

untap_if_present() {
	local tap_name=$1
	local taps

	taps="$(brew tap 2>/dev/null || true)"
	if printf '%s\n' "$taps" | grep -qx "$tap_name"; then
		info "Removing deprecated tap ${tap_name}"
		brew untap "$tap_name"
	fi
}

retarget_homebrew_remotes() {
	if ! tuna_homebrew_enabled || ! command -v brew >/dev/null 2>&1; then
		return
	fi

	untap_if_present "homebrew/command-not-found"
	untap_if_present "homebrew/bundle"
	untap_if_present "homebrew/services"

	git -C "$(brew --repo)" remote set-url origin "$HOMEBREW_BREW_GIT_REMOTE"
	retarget_brew_remote "homebrew/core" "$HOMEBREW_CORE_GIT_REMOTE"
	retarget_brew_remote "homebrew/cask" "$TUNA_HOMEBREW_GIT_BASE/homebrew-cask.git"
}

set_default_mirror_env
load_brew_shellenv
install_homebrew
load_brew_shellenv

if ! command -v brew >/dev/null 2>&1; then
	echo 'Homebrew installation failed: brew is not available' >&2
	exit 1
fi

retarget_homebrew_remotes
