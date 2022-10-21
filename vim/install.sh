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

# curl 无法下载的话需要配置 proxy ， 方法是新建一个 $HOME/.curlrc 文件， 里面写上 --proxy [protocal]://[url]:[port] 例如 --proxy http:example:8080
git clone --depth 1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim
