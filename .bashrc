#

set -o posix
set -b

if [ -n "$PS1" ]; then

    # don't put duplicate lines or lines starting with space in the history.
    # See bash(1) for more options
    HISTCONTROL=ignoreboth
    # append to the history file, don't overwrite it
    shopt -s histappend
    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=2000

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    fasd_cache="$HOME/.fasd-init-bash"
    if [ "$(command -v fasd)" -nt "$fasd_cache" ] || [ ! -s "$fasd_cache" ]; then
        fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
    fi
    # shellcheck source=/dev/null
    source "$fasd_cache"
    unset fasd_cache

    if [ "$(which pyenv)" ]; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi

    if [ "$(which direnv)" ]; then
        eval "$(direnv hook bash)"
    fi

    if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
        # shellcheck source=/dev/null
        source "$(brew --prefix)/etc/bash_completion"
    fi

    if [ -f "$HOME/.bash_prompt" ]; then
        # shellcheck source=/dev/null
        source "$HOME/.bash_prompt"
    fi

    alias "j=z"
    alias "jj=zz"
    alias "ls=exa"
    alias "l=exa -a -lgmH"
    alias "la=l -@"
    alias "ll=l -h"

fi
