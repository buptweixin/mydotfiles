# Register Homebrew's zsh git completion before compinit runs.
completion_dir="$(brew --prefix)/share/zsh/site-functions"

if test -d $completion_dir
then
  typeset -U fpath
  fpath=($completion_dir $fpath)
fi

gi () {
        curl -L -s https://www.gitignore.io/api/$@
}
