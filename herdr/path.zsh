# herdr's generated completion lives in the shared cache dir (written by
# herdr/install.sh). path.zsh files load before compinit, so registering
# the dir on fpath here is enough for compinit to pick _herdr up.
fpath=("${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/completions" $fpath)
