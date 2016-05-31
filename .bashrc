#!/usr/bin/env bash
#

# reports the termination status of background jobs immediately
set -o notify


export PREFIX
PREFIX="/usr/local"

# homebrew prefix
export BREW_PREFIX
BREW_PREFIX="$(brew --prefix)"

export XDG_CACHE_HOME
XDG_CACHE_HOME="$HOME/.cache"

export PLATFORM
PLATFORM="$(uname)"

export SHELL
SHELL="$(command -v bash)"


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

    ### history
    shopt -s histappend
    # PROMPT_COMMAND="$(history -a)"
    export HISTCONTROL=ignoreboth
    export HISTFILE="${HOME}/.bash_history"
    export HISTFILESIZE=100000
    export HISTIGNORE='git*--amend*:ls:cd:*password*:*keygen*:gpg*'
    export HISTSIZE=1000

    ### switch according to platform
    if [ "$PLATFORM" == 'Darwin' ]; then
        # export LSCOLORS='gxBxhxDxfxhxhxhxhxcxcx'
        export BROWSER='open'
        export CLICOLOR=1
        export GCC_COLORS=1
        export LC_ALL='en_US.UTF-8'
        export PAGER='less'
    fi

    # replace current shell with a fresh one
    alias 'reload=exec /usr/bin/env bash'

    ### fasd
    fasd_cache="$HOME/.fasd-init-bash"
    if [ "$(command -v fasd)" -nt "$fasd_cache" ] || [ ! -s "$fasd_cache" ]; then
        fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
    fi
    # shellcheck source=/dev/null
    source "$fasd_cache"; unset fasd_cache
    alias 'j=z'; alias 'jj=zz'; _fasd_bash_hook_cmd_complete j jj

    ### gnupg2
    if command -v gpg2 >/dev/null; then
        # ensure gpg will have tty
        export GPG_TTY
        GPG_TTY="$(which tty)"
    fi

    ### grc
    if command -v grc >/dev/null; then
        # shellcheck source=/dev/null
        source "${BREW_PREFIX}/etc/grc.bashrc"
    fi

    ### homebrew
    if command -v brew >/dev/null; then
        ### homebrew completions
        if [ -f "${BREW_PREFIX}/etc/bash_completion" ]; then
            # shellcheck source=/dev/null
            source "${BREW_PREFIX}/etc/bash_completion"
        fi
    fi

    ### pip
    if command -v pip >/dev/null; then
        # shellcheck source=/dev/null
        eval "$(pip completion --bash)"
    fi

    ### sublime text
    if command -v subl >/dev/null; then
        export EDITOR='subl -n'
    fi

    ### thefuck
    if command -v thefuck >/dev/null; then
        eval "$(thefuck --alias)"
    fi

    ### tmux wrapper
    if command -v tmux >/dev/null; then
        # TODO: add configuration
        function tm() {
            # not already be inside tmux
            test -z "$TMUX" || return 1
            # detach any other clients, attach or make new if there isn't one
            command tmux attach -d || command tmux new bash
        }
    fi

    ### trash
    if command -v trash >/dev/null; then
        alias 'rm=trash -v'
        alias 'rml=trash -l -v'
        alias 'rme=trash -e -v'
        alias 'rms=trash -s -v'
        trash_cnt="$(trash -l | wc -l)"
        if [ "$trash_cnt" -gt 25 ]; then
            echo "please consider disposing your trash (type 'rme')."
        fi
    fi

    ### bash profile
    if [ -f "$HOME/.bash_profile" ]; then
        # shellcheck source=/dev/null
        source "$HOME/.bash_profile"
    fi

    ### bash prompt
    # shameless promotion: https://github.com/gretel/pragmaprompt
    if [ -f "$HOME/.bash_prompt" ]; then
        # shellcheck source=/dev/null
        source "$HOME/.bash_prompt"
    fi

fi # interactive session

### pyenv
if command -v pyenv >/dev/null; then
    eval "$(pyenv init -)"
    alias 'pe=pyenv'
else
    echo 'pyenv not installed?'
fi

### ry
if command -v ry >/dev/null; then
    eval "$(ry setup)"
else
    echo 'ry not installed?'
fi

### direnv
if command -v direnv >/dev/null; then
    eval "$(direnv hook bash)"
    alias 'de=direnv'
else
    echo 'direnv not installed?'
fi
