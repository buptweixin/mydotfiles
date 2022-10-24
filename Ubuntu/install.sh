#!/bin/bash
if test "$(uname)" = "Linux"; then
    if hash apt 2>/dev/null; then
        sudo apt install software-properties-common -y
        sudo add-apt-repository ppa:neovim-ppa/stable -y
        echo 'deb [trusted=yes] https://apt.fury.io/ascii-image-converter/ /' | sudo tee /etc/apt/sources.list.d/ascii-image-converter.list
        sudo apt-get update
        sudo apt install neovim -y
        sudo apt install npm lua5.3 -y
        sudo apt install -y ascii-image-converter
        curl -sL install-node.vercel.app/lts | bash # nodejs
        sudo npm i -g pyright
    fi
fi

