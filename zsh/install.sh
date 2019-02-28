#!/bin/bash

echo "install antigen"
# download antigen
echo "Install antigen..."
if [ -f ~/.antigen.zsh ]; then
  echo "antigen has been installed."
else
  curl -L git.io/antigen > ~/.antigen.zsh
fi

if [ -d ~/.fzf ]; then
  echo "Fzf has been installed."
else
  echo "Install fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

