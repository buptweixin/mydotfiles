#!/bin/bash

if [ ! -d "$HOME/.pip" ]; then
	mkdir ${HOME}/.pip
fi

echo -e "[global]\n\
index-url=https://pypi.tuna.tsinghua.edu.cn/simple/" > ${HOME}/.pip/pip.conf

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --user autoflake
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --user isort
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ --user neovim
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ -U pycodestyle --user
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ python-language-server --user

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
