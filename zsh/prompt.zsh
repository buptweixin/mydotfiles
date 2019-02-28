function _user_host() {
    if [[ -n $SSH_CONNECTION ]]; then
        me="%n@%m"
    elif [[ $LOGNAME != $USER ]]; then
        me="%n"
    fi
    if [[ -n $me ]]; then
        echo "%{$fg[cyan]%}$me%{$reset_color%} "
    fi
}

if [[ $USER == "root" ]]; then
    CARETCOLOR="red"
else
    CARETCOLOR="white"
fi

local _user='$(_user_host)'
local _wd="%{$fg[blue]%}%8~%{$reset_color%} "

local _jobs="%{$fg[cyan]%}%(1j. ⚙ %j.)%{$reset_color%}"
local _return="%{$fg[red]%}%(?..↵ %?)%{$reset_color%}"

PROMPT="╭─${_user}${_wd}%{$reset_color%}
╰─▶ "
PROMPT2="  ▶ "
RPROMPT="${_return}${_jobs}"

