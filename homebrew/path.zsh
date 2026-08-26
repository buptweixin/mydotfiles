if [[ "${DOTFILES_DISABLE_TUNA_HOMEBREW:-0}" != "1" ]]; then
  export HOMEBREW_BREW_GIT_REMOTE="${HOMEBREW_BREW_GIT_REMOTE:-https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git}"
  export HOMEBREW_CORE_GIT_REMOTE="${HOMEBREW_CORE_GIT_REMOTE:-https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git}"
  export HOMEBREW_API_DOMAIN="${HOMEBREW_API_DOMAIN:-https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api}"
  export HOMEBREW_BOTTLE_DOMAIN="${HOMEBREW_BOTTLE_DOMAIN:-https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles}"
  export HOMEBREW_PIP_INDEX_URL="${HOMEBREW_PIP_INDEX_URL:-https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple}"
  export HOMEBREW_INSTALL_FROM_API="${HOMEBREW_INSTALL_FROM_API:-1}"
fi

# `brew shellenv` forks brew on every shell; cache its output and only
# regenerate when the brew binary is newer than the cache (i.e. upgraded).
_brew_shellenv_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/brew-shellenv.zsh"

for brew_bin in \
  /opt/homebrew/bin/brew \
  /usr/local/bin/brew \
  "$HOME/.linuxbrew/bin/brew" \
  /home/linuxbrew/.linuxbrew/bin/brew
do
  if [[ -x "$brew_bin" ]]; then
    if [[ -s "$_brew_shellenv_cache" && ! "$brew_bin" -nt "$_brew_shellenv_cache" ]]; then
      source "$_brew_shellenv_cache"
    else
      _brew_env="$("$brew_bin" shellenv)"
      eval "$_brew_env"
      command mkdir -p "${_brew_shellenv_cache:h}"
      print -r -- "$_brew_env" >| "$_brew_shellenv_cache"
      zcompile -Uz "$_brew_shellenv_cache" 2>/dev/null
    fi
    break
  fi
done

unset brew_bin _brew_env _brew_shellenv_cache
