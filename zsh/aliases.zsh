alias reload!='. ~/.zshrc'

alias cls='clear' # Good 'ol Clear Screen command
alias v='nvim'
alias rl='realpath'
alias sz='source ~/.zshrc'

# StarFactory is an internal Claude Code fork launched as `star`, but herdr
# only bundles screen-detection manifests for upstream agents. Tag each
# launch so herdr classifies it with the claude manifest (HERDR_AGENT binds
# per foreground process; see herdr docs "agents"). Inert outside herdr.
star() { HERDR_AGENT=claude command star "$@" }
