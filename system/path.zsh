typeset -U path
path=(
  $ZSH/bin
  $HOME/.local/bin
  $path
  /opt/homebrew/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
)
export PATH

# man pages from Homebrew and local installs
typeset -U manpath
manpath=(
  /opt/homebrew/share/man
  /usr/local/share/man
  /usr/share/man
  $manpath
)
export MANPATH
