#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
export PREFIX="/usr/local"
export XDG_CACHE_HOME="$HOME/.cache"

export BROWSER="open"
export CLICOLOR=1
export EDITOR="nano"
export GCC_COLORS=1
export LC_ALL="en_US.UTF-8"
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"
export PAGER="less"
export VISUAL="nano"

function _update_ps1() {
	PS1="$($GOPATH/bin/powerline-go -duration $PS0 -error $? -shell bash -cwd-max-depth 3 -max-width 50 -modules docker,duration,venv,ssh,cwd,git,jobs,exit,root)"
}

if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# direnv
eval "$(direnv hook bash)"

# keychain
#eval "$(keychain --quiet --eval --agents ssh --inherit any-once --nogui --quick .ssh/id_rsa .ssh/github)"
