#!/usr/bin/env bash

set -euo pipefail

is_app_installed() {
	type "$1" &>/dev/null
}

die() {
	printf 'ERROR: %s\n' "$1" >&2
	exit 1
}

REPODIR="$(
	cd "$(dirname "$0")"
	pwd -P
)"
PLUGIN_ROOT="$HOME/.tmux/plugins"
LOCKFILE="$REPODIR/plugins.lock"
cd "$REPODIR"

if ! is_app_installed tmux; then
	printf 'WARNING: "tmux" command is not found. Install it first\n' >&2
	exit 1
fi

[[ -f "$LOCKFILE" ]] || die "Cannot find plugin lockfile: $LOCKFILE"
mkdir -p "$HOME/.tmux" "$PLUGIN_ROOT"

install_locked_plugin() {
	local plugin_name=$1
	local plugin_repo=$2
	local plugin_commit=$3
	local plugin_path="$PLUGIN_ROOT/$plugin_name"
	local repo_url="https://github.com/$plugin_repo.git"
	local actual_head

	if [[ "$plugin_name" == */* || "$plugin_name" == '.' || "$plugin_name" == '..' ]]; then
		die "Invalid plugin name in lockfile: $plugin_name"
	fi
	[[ "$plugin_repo" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || \
		die "Invalid plugin repository in lockfile: $plugin_repo"
	[[ "$plugin_commit" =~ ^[0-9a-f]{40}$ ]] || \
		die "Invalid plugin commit in lockfile: $plugin_commit"

	if [[ -e "$plugin_path" && ! -d "$plugin_path" ]]; then
		die "Plugin path is not a directory: $plugin_path"
	fi

	if [[ ! -d "$plugin_path/.git" ]]; then
		[[ ! -e "$plugin_path" ]] || die "Plugin path is not a Git checkout: $plugin_path"
		printf 'Cloning %s\n' "$plugin_repo"
		git clone "$repo_url" "$plugin_path"
	else
		if git -C "$plugin_path" remote get-url origin >/dev/null 2>&1; then
			git -C "$plugin_path" remote set-url origin "$repo_url"
		else
			git -C "$plugin_path" remote add origin "$repo_url"
		fi
	fi

	printf 'Fetching %s at %s\n' "$plugin_name" "$plugin_commit"
	git -C "$plugin_path" fetch --force origin "$plugin_commit"
	git -C "$plugin_path" checkout --detach "$plugin_commit"
	actual_head="$(git -C "$plugin_path" rev-parse HEAD)"
	[[ "$actual_head" == "$plugin_commit" ]] || \
		die "Unexpected HEAD for $plugin_name: $actual_head"
}

while IFS=' ' read -r plugin_name plugin_repo plugin_commit extra; do
	[[ -z "$plugin_name" ]] && continue
	[[ "$plugin_name" == \#* ]] && continue
	[[ -z "$extra" && -n "$plugin_repo" && -n "$plugin_commit" ]] || \
		die "Malformed lockfile entry: $plugin_name $plugin_repo $plugin_commit $extra"
	install_locked_plugin "$plugin_name" "$plugin_repo" "$plugin_commit"
done < "$LOCKFILE"

if [[ -e "$HOME/.tmux.conf" || -L "$HOME/.tmux.conf" ]]; then
	backup="$HOME/.tmux.conf.bak.$(date +%Y%m%d%H%M%S)"
	if [[ -e "$backup" || -L "$backup" ]]; then
		backup="$backup.$$"
	fi
	printf 'Found existing .tmux.conf. Creating backup at %s\n' "$backup"
	cp -p "$HOME/.tmux.conf" "$backup"
fi

cp -a "$REPODIR/tmux/." "$HOME/.tmux/"

printf 'OK: Completed\n'
