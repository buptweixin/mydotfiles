#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  # Install homebrew for macos and linux
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if test "$(uname)" = "Darwin"
then
    brew install TheZoraiz/ascii-image-converter/ascii-image-converter
    brew install ncdu yarn nvim the_silver_searcher
fi

exit 0
