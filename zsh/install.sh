#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
LOCKFILE="$SCRIPT_DIR/plugins.lock"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles"
PLUGIN_DIR="$DATA_DIR/zsh/plugins"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
FZF_CACHE="$CACHE_DIR/fzf.zsh"

if [[ ! -f "$LOCKFILE" ]]; then
  printf 'zsh installer: missing lockfile: %s\n' "$LOCKFILE" >&2
  exit 1
fi

mkdir -p "$PLUGIN_DIR" "$CACHE_DIR"

while read -r name repo sha extra; do
  [[ -z "${name:-}" || "$name" == \#* ]] && continue
  if [[ -n "${extra:-}" || ! "$sha" =~ ^[0-9a-f]{40}$ ]]; then
    printf 'zsh installer: invalid lock entry for %s\n' "$name" >&2
    exit 1
  fi

  target="$PLUGIN_DIR/$name"
  if [[ -e "$target" && ! -d "$target/.git" ]]; then
    printf 'zsh installer: refusing non-git plugin path: %s\n' "$target" >&2
    exit 1
  fi

  if [[ ! -e "$target" ]]; then
    git clone "https://github.com/$repo.git" "$target"
  fi

  git -C "$target" fetch --quiet origin "$sha"
  git -C "$target" checkout --quiet --detach "$sha"
  actual=$(git -C "$target" rev-parse HEAD)
  if [[ "$actual" != "$sha" ]]; then
    printf 'zsh installer: HEAD verification failed for %s (got %s)\n' "$name" "$actual" >&2
    exit 1
  fi
  printf 'zsh installer: %s at %s\n' "$name" "$actual"
done < "$LOCKFILE"

if command -v fzf >/dev/null 2>&1; then
  tmp_fzf=$(mktemp "$CACHE_DIR/.fzf.zsh.XXXXXX")
  trap 'rm -f -- "$tmp_fzf"' EXIT
  fzf --zsh > "$tmp_fzf"
  mv -f -- "$tmp_fzf" "$FZF_CACHE"
  trap - EXIT
else
  printf 'zsh installer: fzf is not installed; skipped %s\n' "$FZF_CACHE" >&2
fi
