#!/bin/bash
if test "$(uname)" = "Linux"; then
    if hash apt 2>/dev/null; then
        sudo apt install software-properties-common -y
        sudo add-apt-repository ppa:neovim-ppa/stable -y
        sudo apt-get update
        sudo apt install neovim -y
        sudo apt install npm lua5.3 -y
        curl -sL install-node.vercel.app/lts | bash # nodejs
        sudo npm i -g pyright
    fi
fi

