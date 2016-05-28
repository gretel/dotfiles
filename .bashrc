#!/usr/bin/env bash
#

# reports the termination status of background jobs immediately
set -o notify

export PLATFORM
PLATFORM="$(uname)"

export SHELL
SHELL="$(command -v bash)"

export PREFIX
PREFIX="/usr/local"

export XDG_CACHE_HOME
XDG_CACHE_HOME="$HOME/.cache"


# interactive session?
if [ -n "$PS1" ]; then
    # fix backspace
    stty erase ^?
    # disable flow control
    stty -ixon -ixoff
    # update windows size after each command if necessary,
    shopt -s checkwinsize
    # be forceful about colors
    if test "$(tput colors 2>/dev/null)" -ne 256; then
        export TERM='xterm-256color'
    fi

    # history
    shopt -s histappend
    PROMPT_COMMAND="$(history -a)"
    export HISTCONTROL=ignoreboth
    export HISTFILE="${HOME}/.bash_history"
    export HISTFILESIZE=100000
    export HISTIGNORE='git*--amend*:ls:cd:*password*:*keygen*:gpg*'
    export HISTSIZE=1000

    # platform spec
    if [ "$PLATFORM" == 'Darwin' ]; then
        export CLICOLOR=1
        export LSCOLORS='gxBxhxDxfxhxhxhxhxcxcx'
    fi

    # replace current shell with a freshie
    alias 'reload=exec /usr/bin/env bash'

    # fasd
    fasd_cache="$HOME/.fasd-init-bash"
    if [ "$(command -v fasd)" -nt "$fasd_cache" ] || [ ! -s "$fasd_cache" ]; then
        fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
    fi
    # shellcheck source=/dev/null
    source "$fasd_cache"; unset fasd_cache
    alias 'j=z'; alias 'jj=zz'; _fasd_bash_hook_cmd_complete j jj

    # fuck
    if command -v thefuck >/dev/null; then
        eval "$(thefuck --alias)"
    fi

    # homebrew completions
    brew_prefix="$(brew --prefix)"
    if [ -f "${brew_prefix}/etc/bash_completion" ]; then
        # shellcheck source=/dev/null
        source "${brew_prefix}/etc/bash_completion"
    fi

    # profile
    if [ -f "$HOME/.bash_profile" ]; then
        # shellcheck source=/dev/null
        source "$HOME/.bash_profile"
    fi

    # prompt
    #   shameless promotion :) https://github.com/gretel/pragmaprompt
    if [ -f "$HOME/.bash_prompt" ]; then
        # shellcheck source=/dev/null
        source "$HOME/.bash_prompt"
    fi

    # comfortable tmux
    function tm() {
        # not already be inside tmux
        test -z "$TMUX" || return 1
        # detach any other clients, attach or make new if there isn't one
        command tmux attach -d || command tmux new bash
    }

fi # interactive session

# pyenv
if command -v pyenv >/dev/null; then
    eval "$(pyenv init -)"
    alias 'pe=pyenv'
fi

# direnv
if command -v direnv >/dev/null; then
    eval "$(direnv hook bash)"
    alias 'de=direnv'
fi

#