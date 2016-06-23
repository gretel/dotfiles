#!/usr/bin/env bash
#

# reports the termination status of background jobs immediately
set -o notify

# store name of system/architecture
export PLATFORM
PLATFORM="$(uname -s)"

# ensure set
export SHELL
SHELL="$(command -v bash)"


# prefix for user installations
export PREFIX="/usr/local"

# freedesktop style cache location
export XDG_CACHE_HOME
XDG_CACHE_HOME="$HOME/.cache"


# homebrew prefix
export BREW_PREFIX
BREW_PREFIX="$(brew --prefix)"

# python version manager
export PYENV_ROOT
PYENV_ROOT="$HOME/.pyenv"
# prevent pyenv from ever changing the prompt
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# ruby version manager
export RY_RUBIES
RY_RUBIES="$HOME/.rubies"


# check if this session is interactive
# http://www.tldp.org/LDP/abs/html/intandnonint.html#II2TEST
if [[ -t "0" || -p /dev/stdin ]]; then

    # backspace, not delete
    stty erase ^?
    # disable flow control ('ctrl-s')
    # http://unix.stackexchange.com/q/12107/115980 and
    stty -ixon
    # enable case-insensitive globbing
    shopt -s nocaseglob
    # update windows size after each command, if necessary
    shopt -s checkwinsize
    # always pretend to support 256 colors
    if test "$(tput colors 2>/dev/null)" -ne 256; then
        export TERM='xterm-256color'
    fi

    ### history
    # do not override bash history file (append to it)
    shopt -s histappend
    # turn on confirmation for history expansion (histexpand)
    shopt -s histverify
    # put multi-line commands onto one line of history
    shopt -s cmdhist
    export HISTCONTROL=ignoreboth
    export HISTFILE="${HOME}/.bash_history"
    export HISTFILESIZE=100000
    export HISTIGNORE='@(clear|exit|history|ls|pwd|bg|fg|g)?( )'
    export HISTSIZE=1000
    export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

    ### switch according to platform
    if [ "$PLATFORM" == 'Darwin' ]; then
        # number of physical cores (not hyperthreads)
        core_count=$(sysctl -n hw.physicalcpu)
        export MAKEFLAGS="-j $core_count -O2"

        # export LSCOLORS='gxBxhxDxfxhxhxhxhxcxcx'
        export BROWSER='open'
        export CLICOLOR=1
        export GCC_COLORS=1
        export LC_ALL='en_US.UTF-8'
        export PAGER='less'
    fi

    # jump words with ctrl-arrow
    bind '"\e[1;5D":backward-word'
    bind '"\e[1;5C":forward-word'

    # replace current shell with a fresh one
    alias 'reload=exec /usr/bin/env bash'

    ### editor - sublime text
    if command -v subl >/dev/null; then
        export EDITOR='subl -n'
    fi

    ### fasd
    fasd_cache="$HOME/.fasd-init-bash"
    if [ "$(command -v fasd)" -nt "$fasd_cache" ] || [ ! -s "$fasd_cache" ]; then
        command fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
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

    # ### pip
    # if command -v pip >/dev/null; then
    #     # shellcheck source=/dev/null
    #     eval "$(command pip completion --bash)"
    # fi

    ### thefuck
    if command -v thefuck >/dev/null; then
        eval "$(command thefuck --alias)"
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
        # get
        trash_cnt="$(command trash -l | wc -l | xargs)"
        if [ "$trash_cnt" -gt 25 ]; then
            echo "please consider emptying your trash of $trash_cnt items (type 'rme')."
        fi
    fi

    ### bash profile
    if [ -f "$HOME/.bash_profile" ]; then
        # shellcheck source=/dev/null
        source "$HOME/.bash_profile"
    fi

    if [ -f "$(brew --prefix pragmaprompt)/share/pragmaprompt.sh" ]; then
        # shellcheck source=/dev/null
        source "$(brew --prefix pragmaprompt)/share/pragmaprompt.sh"
    fi

fi # interactive session

### pyenv
if command -v pyenv >/dev/null; then
    eval "$(command pyenv init -)"
    alias 'pe=pyenv'
fi

### ry
if command -v ry >/dev/null; then
    eval "$(command ry setup)"
fi

### direnv
if command -v direnv >/dev/null; then
    eval "$(command direnv hook bash)"
    alias 'de=direnv'
fi
