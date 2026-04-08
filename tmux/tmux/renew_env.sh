#!/usr/bin/env bash

set -euo pipefail

quote_shell_value() {
  printf '%q' "${1-}"
}

build_export_command() {
  local var_name=$1
  local env_line value

  env_line="$(tmux show-environment -g "$var_name" 2>/dev/null || true)"
  if [[ -z "$env_line" ]]; then
    return
  fi

  if [[ "$env_line" == "-$var_name" ]]; then
    printf 'unset %s' "$var_name"
    return
  fi

  value=${env_line#*=}
  printf 'export %s=%s' "$var_name" "$(quote_shell_value "$value")"
}

renew_pane_environment() {
  local pane_id=$1
  local var_name cmd

  while IFS= read -r var_name; do
    cmd="$(build_export_command "$var_name")"
    if [[ -n "$cmd" ]]; then
      tmux send-keys -t "$pane_id" -l "$cmd"
      tmux send-keys -t "$pane_id" Enter
    fi
  done < <(tmux show-options -gv update-environment)

  tmux send-keys -t "$pane_id" C-l
}

pane_fmt="#{pane_id} #{pane_in_mode} #{pane_input_off} #{pane_dead} #{pane_current_command}"
tmux list-panes -s -F "$pane_fmt" | awk '
  $2 == 0 && $3 == 0 && $4 == 0 && $5 ~ /(bash|zsh|ksh|sh)/ { print $1 }
' | while read -r pane_id; do
  renew_pane_environment "$pane_id"
done
