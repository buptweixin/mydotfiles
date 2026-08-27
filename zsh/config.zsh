export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

typeset -U fpath
fpath=($ZSH/functions $fpath)

# autoload user functions; `_`-prefixed files are completion scripts and get
# picked up from fpath by compinit instead of being autoloaded here.
for _fn in $ZSH/functions/*(N:t); do
  [[ "$_fn" == _* ]] && continue
  autoload -Uz "$_fn"
done
unset _fn

HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=10000

setopt BANG_HIST # Treat the '!' character specially during expansion.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing non-existent history.

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

unsetopt INC_APPEND_HISTORY INC_APPEND_HISTORY_TIME APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char
