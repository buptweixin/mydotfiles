#!/bin/bash

echo "install zgen"
# download zgen
echo "Install zgen..."
if [ -d ${HOME}/.zgen ]; then
  echo "zgen has been installed."
else
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

if [ -d ~/.fzf ]; then
  echo "Fzf has been installed."
else
  echo "Install fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

