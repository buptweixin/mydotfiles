#!/bin/bash
if test "$(uname)" = "Linux"; then
	if hash apt 2>/dev/null; then
		sudo apt install software-properties-common -y
	fi
fi
