#!/usr/bin/env bash

if [ -z "$BASE16_SHELL" ]; then
  if [ -n "$BASH" ]; then
    BASE16_SHELL=${BASH_SOURCE[0]}
  elif [ -n "$ZSH_NAME" ]; then
    BASE16_SHELL=${(%):-%x}
  fi
  BASE16_SHELL=${BASE16_SHELL%/*}
fi

_base16()
{
  local script=$1
  local theme=$2
  [ -f $script ] && . $script
  ln -fs $script ~/.base16_theme
  if [ -e ~/.tmux/plugins/base16-tmux ]; then echo -e "set -g \0100colors-base16 '$theme'" >| ~/.tmux.base16.conf; fi;
  echo -e "if \0041exists('g:colors_name') || g:colors_name != 'base16-$theme'\n  colorscheme base16-$theme\nendif" >| ~/.vimrc_background
  if [ -n ${BASE16_SHELL_HOOKS:+s} ] && [ -d "${BASE16_SHELL_HOOKS}" ]; then
    for hook in $BASE16_SHELL_HOOKS/*; do
      [ -f "$hook" ] && [ -x "$hook" ] && "$hook"
    done
  fi
}

if [ -f ~/.base16_theme ]; then
  . ~/.base16_theme
fi

for script in "$BASE16_SHELL"/scripts/base16*.sh; do
  script_name=${script##*/}
  script_name=${script_name%.sh}
  theme=${script_name#*-}
  func_name="base16_${theme}"
  alias $func_name="_base16 \"${script}\" ${theme}"
done;
