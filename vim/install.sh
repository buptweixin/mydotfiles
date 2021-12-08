#!/bin/bash

pip3 install --user autoflake
pip3 install --user isort
pip3 install -U pycodestyle --user
pip3 install -U neovim --upgrade --user
pip3 install python-language-server --user

# curl 无法下载的话需要配置 proxy ， 方法是新建一个 $HOME/.curlrc 文件， 里面写上 --proxy [protocal]://[url]:[port] 例如 --proxy http:example:8080
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
