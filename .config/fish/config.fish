# https://gist.github.com/gretel/0bb5f77cdc54182c15dd

set -x HOMEBREW_GITHUB_API_TOKEN "090ccbff9bd0f0275deb95f4ad472f23dacee05c"

### disable greeting
set -e fish_greeting

# store name of system/architecture
set -x PLATFORM (command uname -s)

# ensure set
set -x SHELL (command which fish)


# prefix for user installations
set -x PREFIX /usr/local

# freedesktop style cache location
set -x XDG_CACHE_HOME $HOME/.cache


# python version manager
set -x PYENV_ROOT $HOME/.pyenv
# prevent pyenv from ever changing the prompt
set -x PYENV_VIRTUALENV_DISABLE_PROMPT 1

# ruby version manager
set -x RY_RUBIES $HOME/.rubies

# long process done
set -U __done_min_cmd_duration 10000
set -U __done_exclude 'git (?!push|pull)'

if status --is-interactive

    ### auth
    set -x SSH_KEYS $HOME/.ssh/id_rsa $HOME/.ssh/github
    #set -x GPG_KEYS '640F9BDD'

    ### cosmetical
    # set -x LSCOLORS gxBxhxDxfxhxhxhxhxcxcx
    set -x CLICOLOR 1
    set -x GCC_COLORS 1
    set -x LC_ALL en_US.UTF-8

    ### switch according to platform
    if test "$PLATFORM" = "Darwin" # osx
        # number of physical cores (not hyperthreads)
        set -l core_count (sysctl -n hw.physicalcpu)
        set -x MAKEFLAGS "-j$core_count"

        set -x BROWSER open
        set -x EDITOR  'nano'
        set -x PAGER   less
        set -x VISUAL  vi
    else
        # all other
        set -x EDITOR  vi
    end

    # ### support colors
    # if test (tput colors) -le 255
    #     set -x TERM xterm-256color
    # else
    # 	set -x TERM xterm-color
    # end

    ### gnupg2
    if command --search gpg2 >/dev/null
        # ensure gpg will have tty
        set -x GPG_TTY (which tty)
    end

    ### thefuck
    if command --search thefuck >/dev/null
        command thefuck --alias | tr '\n' ';' | source
    end

    ### keychain
    if command --search keychain >/dev/null
        # command keychain --quiet --nogui --eval --inherit any --confhost --agents ssh,gpg $SSH_KEYS $GPG_KEYS | source
        command keychain --quiet --nogui --eval --inherit any --confhost --agents ssh $SSH_KEYS | source
    end

    ### autojump
    [ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

    ### trash
    if command --search trash >/dev/null
        #set -l trash_cnt (string trim (trash -l | wc -l))
        #test "$trash_cnt" -gt 25; and echo "please consider emptying your trash of $trash_cnt items (type 'rme')."
        alias 'rmm'  'command rm'
        alias 'rm'   'command trash -v'
        alias 'rml'  'command trash -l -v'
        alias 'rme'  'command trash -e -v'
        alias 'rms'  'command trash -s -v'
    end

    ### update auto completions if not exist
    if not test -d $HOME/.local/share/fish/generated_completions
        fish_update_completions
    end

    ### shared Makefile
    alias 'mmake' 'make -f ~/Makefile'
end

# ### curl
# set -x PATH $PREFIX/opt/curl/bin $PATH

### pyenv
if command --search pyenv >/dev/null
    function pyenv
        set cmd $argv[1]
        set -e argv[1]
        switch "$cmd"
            case rehash shell
                source (pyenv "sh-$cmd" $argv | psub)
            case \*
                command pyenv "$cmd" $argv
        end
    end
    set -x PATH $PYENV_ROOT/shims $PATH
    set -x PYENV_SHELL fish
    # command pyenv rehash 2>/dev/null
end

# ### ry
# if command --search ry >/dev/null
#     set -x PATH $PREFIX/lib/ry/current/bin $PATH
# end

### lastly, direnv
if command --search direnv >/dev/null
    command direnv hook fish | source
end
