typeset -U path
path=(
  $ZSH/bin
  $HOME/.local/bin
  $path
  /usr/local/bin
  /usr/local/sbin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
)
export PATH
export MANPATH="/usr/local/man:/usr/local/git/man:$MANPATH"
