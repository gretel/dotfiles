# https://gist.github.com/gretel/facabae8f9c02d569155158f5016d5ae

### disable greeting
set -e fish_greeting

# store name of system/architecture
set -x PLATFORM (command uname -s)

# ensure set
set -x SHELL (command -v fish)

# prefix for user installations
set -x PREFIX /usr/local

# freedesktop style cache location
set -x XDG_CACHE_HOME $HOME/.cache

# hail international
set -x LC_ALL en_US.UTF-8

# long process done
set -U __done_min_cmd_duration 10000
set -U __done_exclude 'git (?!push|pull)'

if status --is-interactive
    ### update auto completions if not exist
    if not test -d $HOME/.local/share/fish/generated_completions
        fish_update_completions
    end

    ### cosmetical
    set -x LSCOLORS gxBxhxDxfxhxhxhxhxcxcx
    set -x CLICOLOR 1
    set -x GCC_COLORS 1

    ### switch according to platform
    if test "$PLATFORM" = "Darwin" # osx
        # number of physical cores (not hyperthreads)
        set -l core_count (sysctl -n hw.physicalcpu)
        set -x MAKEFLAGS "-j$core_count"

        set -x BROWSER 'open'
        set -x EDITOR  'nano'
    else
        # all other
        set -x EDITOR  'vi'
    end

    ### workaround "for fish_update_completions"
    set -x MANPATH /usr/share/man $PREFIX/share/man $MANPATH

    ### python virtualenv 'activate.fish' shall not oerride the prompt
    set -x VIRTUAL_ENV_DISABLE_PROMPT yes

    ### tail file
    alias 'ff' 'less +F'

    ### bat
    if command --search bat >/dev/null
        alias 'cat' 'bat'
        alias 'less' 'bat'
        set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
        set -x BAT_CONFIG_PATH "$HOME/.batcfg"
    end

    ### curl
    if test -d $PREFIX/opt/curl/bin
        set -x fish_user_paths $PREFIX/opt/curl/bin $fish_user_paths
    end

    ### thefuck
    if command --search thefuck >/dev/null
        command thefuck --alias | tr '\n' ';' | source
    end

    ### exa
    if command --search exa >/dev/null
        alias 'l'  'command exa -g -1 -a -s extension -F -U'
        alias 't'  'command exa -g -G -a -s extension -F -U -T -L 2'
        alias 'lw' 'command exa -g -G -a -s extension -F -U'
        alias 'll' 'command exa -g -l -a -s extension -F -U'
        alias 'lt' 'command exa -g -l -a -s extension -F -U -T -L 2'
        alias 'ltd' 'command exa -g -l -a -s extension -F -U -T'
    end

    ### trash
    if command --search trash >/dev/null
        #set -l trash_cnt (string trim (trash -l | wc -l))
        #test "$trash_cnt" -gt 25; and echo "please consider emptying your trash of $trash_cnt items (type 'rme')."
        alias 'rmm' 'command rm'
        alias 'rm'  'command trash -v'
        alias 'rml' 'command trash -l -v'
        alias 'rme' 'command trash -e -v'
        alias 'rms' 'command trash -s -v'
    end

    # ### postgres
    # if test -d $PREFIX/opt/postgresql/bin
    #     set -x fish_user_paths $PREFIX/opt/postgresql/bin $fish_user_paths
    # end

    # ### rubygems
    # if command --search ruby >/dev/null
    #     set -x fish_user_paths $HOME/.gem/ruby/2.3.0/bin $fish_user_paths
    # end

    ### cargo
    if command --search cargo >/dev/null
        set -x fish_user_paths $HOME/.cargo/bin $fish_user_paths
    end

    ### node (10)
    set -x _NODE_BIN "$PREFIX/opt/node@10/bin"
    if test -d $_NODE_BIN
        set -g fish_user_paths $_NODE_BIN $fish_user_paths
    end

    ### python 3.8 first
    set -x _PTYHON_BIN "$PREFIX/opt/python@3.8/bin"
    if test -d $_PTYHON_BIN
        set -g fish_user_paths $_PTYHON_BIN $fish_user_paths
    end
 
    ### kitty
    if command --search kitty >/dev/null
        command kitty + complete setup fish | source
        alias 'd' 'kitty +kitten diff'
    end
    
    ### auth
    set -x SSH_KEYS $HOME/.ssh/id_rsa $HOME/.ssh/github $HOME/.ssh/id_ed25519
    #set -x GPG_KEYS '64236423'

    ### gnupg
    if command --search gpg >/dev/null
        # ensure gpg will have tty
        set -x GPG_TTY (which tty)
    end

    ### keychain
    if command --search keychain >/dev/null
        command keychain --quiet --nogui --inherit any-once --agents ssh --quick $SSH_KEYS

        if test -f ~/.keychain/(hostname)-gpg-fish
            source ~/.keychain/(hostname)-gpg-fish
        end

        if test -f ~/.keychain/(hostname)-fish
            source ~/.keychain/(hostname)-fish
        end
    end

    ### lastly, direnv
    if command --search direnv >/dev/null
        command direnv hook fish | source
    end

    function fish_prompt
        set duration (math -s6 "$CMD_DURATION / 1000")
        eval "powerline-go -shell bare -duration $duration -error $status -cwd-max-depth 3 -max-width 50 -modules duration,venv,ssh,cwd,git,jobs,exit,root"
    end
end
