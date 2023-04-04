#!/bin/bash
if test "$(uname)" = "Linux"; then
    if hash apt 2>/dev/null; then
        sudo apt install software-properties-common -y
        sudo add-apt-repository ppa:neovim-ppa/stable yarn -y
        sudo apt-get update
        sudo apt install npm lua5.3 -y
        sudo apt-get install python3-neovim -y
        proxychains4 curl -sL install-node.vercel.app/lts | sudo bash # nodejs
        proxychains4 sudo npm i -g pyright
    fi
fi

