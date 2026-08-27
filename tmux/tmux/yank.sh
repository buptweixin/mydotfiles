#!/usr/bin/env bash

set -euo pipefail

is_app_installed() {
  type "$1" &>/dev/null
}

# get data either form stdin or from file
buf=$(cat "$@")

copy_backend_remote_tunnel_port=$(tmux show-option -gvq "@copy_backend_remote_tunnel_port")
copy_use_osc52_fallback=$(tmux show-option -gvq "@copy_use_osc52_fallback")
remote_tunnel_port=''

valid_remote_tunnel_port() {
  local port=$1 normalized=$1

  [[ "$port" =~ ^[0-9]+$ ]] || return 1
  while [[ ${#normalized} -gt 1 && "$normalized" == 0* ]]; do
    normalized=${normalized#0}
  done
  [[ "$normalized" != 0 ]] || return 1
  if [[ ${#normalized} -lt 5 ]]; then
    remote_tunnel_port=$normalized
    return 0
  fi
  if [[ ${#normalized} -eq 5 ]] && (( 10#$normalized <= 65535 )); then
    remote_tunnel_port=$normalized
    return 0
  fi
  return 1
}

# Resolve copy backend: pbcopy (OSX), reattach-to-user-namespace (OSX), xclip/xsel (Linux)
copy_backend=""
if is_app_installed pbcopy; then
  copy_backend="pbcopy"
elif is_app_installed reattach-to-user-namespace; then
  copy_backend="reattach"
elif [ -n "${DISPLAY-}" ] && is_app_installed xsel; then
  copy_backend="xsel"
elif [ -n "${DISPLAY-}" ] && is_app_installed xclip; then
  copy_backend="xclip"
elif is_app_installed nc \
    && valid_remote_tunnel_port "${copy_backend_remote_tunnel_port-}" \
    && (netstat -f inet -nl 2>/dev/null || netstat -4 -nl 2>/dev/null) \
      | grep -Eq "[.:]${remote_tunnel_port}([[:space:]]|$)"; then
  copy_backend="nc"
fi

# if copy backend is resolved, copy and exit
if [ -n "$copy_backend" ]; then
  case "$copy_backend" in
    pbcopy)
      printf "%s" "$buf" | pbcopy
      ;;
    reattach)
      printf "%s" "$buf" | reattach-to-user-namespace pbcopy
      ;;
    xsel)
      printf "%s" "$buf" | xsel -i --clipboard
      ;;
    xclip)
      printf "%s" "$buf" | xclip -i -f -selection primary | xclip -i -selection clipboard
      ;;
    nc)
      printf "%s" "$buf" | nc localhost "$remote_tunnel_port"
      ;;
  esac
  exit 0
fi


# If no copy backends were eligible, decide to fallback to OSC 52 escape sequences
# Note, most terminals do not handle OSC
if [ "$copy_use_osc52_fallback" == "off" ]; then
  exit;
fi

# Copy via OSC 52 ANSI escape sequence to controlling terminal
buflen=$( printf %s "$buf" | wc -c )

# https://sunaku.github.io/tmux-yank-osc52.html
# The maximum length of an OSC 52 escape sequence is 100_000 bytes, of which
# 7 bytes are occupied by a "\033]52;c;" header, 1 byte by a "\a" footer, and
# 99_992 bytes by the base64-encoded result of 74_994 bytes of copyable text
maxlen=74994 

# warn if exceeds maxlen
if [ "$buflen" -gt "$maxlen" ]; then
  printf "input is %d bytes too long" "$(( buflen - maxlen ))" >&2
fi

# build up OSC 52 ANSI escape sequence
esc="\033]52;c;$( printf %s "$buf" | head -c $maxlen | base64 | tr -d '\r\n' )\a"
esc="\033Ptmux;\033$esc\033\\"

# resolve target terminal to send escape sequence
# if we are on remote machine, send directly to SSH_TTY to transport escape sequence
# to terminal on local machine, so data lands in clipboard on our local machine
pane_active_tty=$(tmux list-panes -F "#{pane_active} #{pane_tty}" | awk '$1=="1" { print $2 }')
target_tty="${SSH_TTY:-$pane_active_tty}"

if [[ -z "$target_tty" || ! -w "$target_tty" ]]; then
  exit 0
fi

printf '%b' "$esc" > "$target_tty"
