#!/usr/bin/env bash
export LC_ALL="en_US.UTF-8"
export PREFIX="/usr/local"

export BROWSER="open"
export EDITOR="nano"
export PAGER="bat"

export CLICOLOR=1
export GCC_COLORS=1
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"

function _update_ps1() {
    PS1="$(powerline-go -duration $PS0 -error $? -shell bash -cwd-max-depth 3 -max-width 50 -modules duration,venv,ssh,cwd,git,jobs,exit,root)"
}
PROMPT_COMMAND="_update_ps1; ${PROMPT_COMMAND}"

# direnv
eval "$(direnv hook bash)"
