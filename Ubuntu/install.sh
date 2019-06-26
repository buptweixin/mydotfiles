#!/bin/bash
if test "$(uname)" = "Linux"; then
    if hash apt 2>/dev/null; then
        if hash sudo 2>/dev/null; then
	    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
            sudo apt-get update && apt-get install -y \
	        silversearcher-ag \
		nodejs \
	        yarn \
		zsh
	else
	    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
	    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
	    curl -sL https://deb.nodesource.com/setup_12.x | bash -
            apt-get update && apt-get install -y \
	        silversearcher-ag \
		nodejs \
	        yarn \
		zsh
	fi

    fi
fi

