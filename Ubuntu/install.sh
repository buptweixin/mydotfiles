#!/bin/bash
if test "$(uname)" = "Linux"; then
    if hash apt 2>/dev/null; then
        sudo apt-get update

    fi
fi

