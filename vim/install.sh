#!/bin/bash

if test "$(uname)" = "Darwin"
then
    brew install nvim
elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
then # ubuntu
    sudo apt install software-properties-common -y
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt-get update
    sudo apt install neovim -y
fi

pip3 install --user autoflake
pip3 install --user isort
pip3 install -U pycodestyle --user
pip3 install -U neovim --upgrade --user
pip3 install python-language-server --user

git clone --depth 1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ln -sf ${SCRIPT_DIR}/nvim ${HOME}/.config/nvim
