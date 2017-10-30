#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

export PREFIX="/usr/local"
export RY_RUBIES="$HOME/.rubies"
export XDG_CACHE_HOME="$HOME/.cache"

export BROWSER="open"
export CLICOLOR=1
export EDITOR="nano"
export GCC_COLORS=1
export LC_ALL="en_US.UTF-8"
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"
export PAGER="less"
export VISUAL="nano"

# prompt
if [ -f "$(brew --prefix pragmaprompt)/share/pragmaprompt.sh" ]; then
	source "$(brew --prefix pragmaprompt)/share/pragmaprompt.sh"
fi

# postgres 9.6
if [ -d "$(brew --prefix postgresql@9.6)/bin" ]; then
	export PATH="$(brew --prefix postgresql@9.6)/bin:$PATH"
fi

# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && source /usr/local/etc/profile.d/autojump.sh

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# thefuck
eval "$(thefuck --alias)"

# hub
eval "$(hub alias -s)"

# direnv
eval "$(direnv hook bash)"

# keychain
eval "$(keychain --quiet --eval --agents ssh --inherit any-once --nogui --quick .ssh/id_rsa .ssh/github .ssh/audibene)"
