if [[ "${DOTFILES_DISABLE_TUNA_HOMEBREW:-0}" != "1" ]]; then
  export HOMEBREW_BREW_GIT_REMOTE="${HOMEBREW_BREW_GIT_REMOTE:-https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git}"
  export HOMEBREW_CORE_GIT_REMOTE="${HOMEBREW_CORE_GIT_REMOTE:-https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git}"
  export HOMEBREW_API_DOMAIN="${HOMEBREW_API_DOMAIN:-https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api}"
  export HOMEBREW_BOTTLE_DOMAIN="${HOMEBREW_BOTTLE_DOMAIN:-https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles}"
  export HOMEBREW_PIP_INDEX_URL="${HOMEBREW_PIP_INDEX_URL:-https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple}"
  export HOMEBREW_INSTALL_FROM_API="${HOMEBREW_INSTALL_FROM_API:-1}"
fi

for brew_bin in \
  /opt/homebrew/bin/brew \
  /usr/local/bin/brew \
  "$HOME/.linuxbrew/bin/brew" \
  /home/linuxbrew/.linuxbrew/bin/brew
do
  if [[ -x "$brew_bin" ]]; then
    eval "$("$brew_bin" shellenv)"
    break
  fi
done
