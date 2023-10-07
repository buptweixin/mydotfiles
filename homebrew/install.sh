#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew); then
	echo "  Installing Homebrew for you."
	# Install homebrew for macos and linux
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	if test "$(uname)" = "Linux"; then
		(
			echo
			echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
		) >>$HOME/.profile
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
fi
