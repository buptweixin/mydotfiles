#!/bin/bash
if test "$(uname)" = "Linux"; then
    if hash apt 2>/dev/null; then
        if hash sudo 2>/dev/null; then
            basedir=$(cd "$(dirname "$0")";pwd)
            sudo cp ${basedir}/sources.list /etc/apt/sources.list
            curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
            echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
            curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
                sudo apt-get update && sudo apt-get install -y \
                silversearcher-ag \
                nodejs \
                yarn \
                zsh
            sudo apt-get install software-properties-common -y
            sudo add-apt-repository ppa:neovim-ppa/unstable -y
            sudo apt-get update -y
            sudo apt-get install neovim -y
            sudo locale-gen zh_CN.UTF-8
	    else
            basedir=$(cd "$(dirname "$0")";pwd)
            sudo cp ${basedir}/sources.list /etc/apt/sources.list
            cp sources.list /etc/apt/sources.list
	        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
	        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
	        curl -sL https://deb.nodesource.com/setup_12.x | bash -
                apt-get update && apt-get install -y \
	            silversearcher-ag \
                nodejs \
	            yarn \
                zsh \
                software-properties-common
            add-apt-repository ppa:neovim-ppa/unstable -y
            apt-get update -y
            apt-get install neovim -y
            locale-gen zh_CN.UTF-8
	    fi
    fi
fi

