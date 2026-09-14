# shellcheck shell=bash
#
# Shared symlink management for topic installers. Source this file, then:
#
#   link_managed <src> <dst>
#
# - No-op when $dst is already a symlink to $src.
# - Otherwise backs up an existing $dst (file, directory, or symlink
#   pointing elsewhere) to $dst.bak.<timestamp>, then links $src into place.
# - Sets LINK_MANAGED_BACKUP to the backup path when a backup was made
#   (empty otherwise), so callers can adopt/migrate old content.

link_managed() {
	local src=$1 dst=$2

	LINK_MANAGED_BACKUP=''

	if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
		echo "Already linked: $dst"
		return 0
	fi

	mkdir -p "$(dirname "$dst")"

	if [[ -e "$dst" || -L "$dst" ]]; then
		LINK_MANAGED_BACKUP="$dst.bak.$(date +%Y%m%d%H%M%S)"
		echo "Backing up $dst to $LINK_MANAGED_BACKUP"
		mv "$dst" "$LINK_MANAGED_BACKUP"
	fi

	ln -s "$src" "$dst"
	echo "Linked $dst -> $src"
}
