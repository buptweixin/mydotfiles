#!/bin/bash
if [ -d ~/.fzf ]; then
  echo "Fzf has been installed."
else
  echo "Install fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

