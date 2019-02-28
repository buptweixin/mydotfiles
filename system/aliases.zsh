# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`

if [ -x "$(command -v bat)" ]; then
    alias cat="bat"
fi

alias ll="ls -l"

if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"
