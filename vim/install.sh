#!/bin/bash
mkdir -p $HOME/.config
if [ -d $HOME/.config/nvim ]; then
	echo "Backup old nvim config"
	mv $HOME/.config/nvim $HOME/.config/nvim.bak
fi
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ln -sf $SCRIPT_DIR/nvim $HOME/.config/nvim
