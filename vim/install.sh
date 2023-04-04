#!/bin/bash

if test "$(uname)" = "Darwin"
then
    brew install nvim
elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
then # ubuntu
    sudo apt remove neovim -y
    proxychains4 curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract
    sudo mv squashfs-root /
    sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
    sudo rm -rf squashfs-root nvim.appimage
fi




pip3 install --user autoflake
pip3 install --user isort
pip3 install -U pycodestyle --user
pip3 install -U neovim --upgrade --user
pip3 install python-language-server --user

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mkdir -p ${HOME}/.config/nvim
ln -sf ${SCRIPT_DIR}/vimrc.symlink ${HOME}/.config/nvim/init.vim
ln -sf ${SCRIPT_DIR}/vimrc.bundles.symlink ${HOME}/.config/nvim/vimrc.bundles

