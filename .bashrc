#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

export HOMEBREW_GITHUB_API_TOKEN="090ccbff9bd0f0275deb95f4ad472f23dacee05c"
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

# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && source /usr/local/etc/profile.d/autojump.sh

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# thefuck
eval "$(thefuck --alias)"

# direnv
eval "$(direnv hook bash)"
