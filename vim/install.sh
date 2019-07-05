#!/bin/bash

pip3 install --user autoflake
pip3 install --user isort
pip3 install -U pycodestyle==2.3.1 --user
pip3 install -U neovim --upgrade --user
pip3 install python-language-server --user

# curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
#         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
