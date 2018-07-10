# https://gist.github.com/gretel/0bb5f77cdc54182c15dd

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

# # python version manager
# set -x PYENV_ROOT $HOME/.pyenv
# # prevent pyenv from ever changing the prompt
# set -x PYENV_VIRTUALENV_DISABLE_PROMPT 1

# ruby version manager
set -x RY_RUBIES $HOME/.rubies

# long process done
set -U __done_min_cmd_duration 10000
set -U __done_exclude 'git (?!push|pull)'

if status --is-interactive

    ### auth
    set -x SSH_KEYS $HOME/.ssh/id_rsa $HOME/.ssh/github $HOME/.ssh/bahn
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

        set -x BROWSER 'open'
        set -x EDITOR  'nano'
        set -x PAGER   'less'
        set -x VISUAL  'less'
    else
        # all other
        set -x EDITOR  'vi'
    end

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
        #command keychain --quiet --nogui --eval --inherit any-once --confhost --agents ssh,gpg $SSH_KEYS $GPG_KEYS | source
        command keychain --quiet --nogui --eval --agents ssh --inherit any-once --quick $SSH_KEYS | source
    end

    ### autojump
    [ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

    ### exa
    if command --search exa >/dev/null
        alias 'l'  'command exa -g -1 -a -s extension -F -U'
        alias 't'  'command exa -g -G -a -s extension -F -U -T -L 2'
        alias 'lw' 'command exa -g -G -a -s extension -F -U'
        alias 'll' 'command exa -g -l -a -s extension -F -U'
        alias 'lt' 'command exa -g -l -a -s extension -F -U -T -L 2'
    end

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

    ### tail file
    alias 'ff' 'less +F'

    ### git
    alias 'gcs' 'git clone --depth 1'
    alias 'gp' 'git st and git pull'
    alias 'gcp' 'git commit -a and git push -u origin master'
end

# ### curl
# set -x PATH $PREFIX/opt/curl/bin $PATH

# ### postgres
# if test -d (brew --prefix postgresql)/bin
#     set -x PATH (brew --prefix postgresql)/bin $PATH
# end

### cargo
if command --search cargo >/dev/null
    set -x PATH $HOME/.cargo/bin $PATH
end

# ### pyenv
# if command --search pyenv >/dev/null
#     function pyenv
#         set cmd $argv[1]
#         set -e argv[1]
#         switch "$cmd"
#             case rehash shell
#                 source (pyenv "sh-$cmd" $argv | psub)
#             case \*
#                 command pyenv "$cmd" $argv
#         end
#     end
#     set -x PATH $PYENV_ROOT/shims $PATH
#     set -x PYENV_SHELL fish
#     # command pyenv rehash 2>/dev/null
# end

# ### ry
# if command --search ry >/dev/null
#     set -x PATH $PREFIX/lib/ry/current/bin $PATH
# end

### lastly, direnv
if command --search direnv >/dev/null
    command direnv hook fish | source
end
