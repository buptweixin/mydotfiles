#!/bin/bash

pip install --user autoflake
pip install --user isort
pip install -U pycodestyle==2.3.1 --user
pip install -U neovim --upgrade --user
pip3 install python-language-server --user

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
