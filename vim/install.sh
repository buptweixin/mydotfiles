mkdir -p $HOME/.config
if [ -d $HOME/.config/nvim ]; then
	echo "Backup old nvim config"
	mv $HOME/.config/nvim $HOME/.config/nvim.bak
fi
ln -sf nvim $HOME/.config/nvim
