# https://gist.github.com/gretel/facabae8f9c02d569155158f5016d5ae

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

# ruby version manager
set -x RY_RUBIES $HOME/.rubies

# long process done
set -U __done_min_cmd_duration 10000
set -U __done_exclude 'git (?!push|pull)'

if status --is-interactive
    ### auth
    set -x SSH_KEYS $HOME/.ssh/id_rsa $HOME/.ssh/github $HOME/.ssh/id_ed25519
    #set -x GPG_KEYS '64236423'

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

    ### gnupg
    if command --search gpg >/dev/null
        # ensure gpg will have tty
        set -x GPG_TTY (which tty)
    end

    # ### thefuck
    # if command --search thefuck >/dev/null
    #     command thefuck --alias | tr '\n' ';' | source
    # end

    ### keychain
    if command --search keychain >/dev/null
        command keychain --quiet --nogui --eval --inherit any-once --agents ssh --quick $SSH_KEYS | source
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

    ### shared Makefile
    # TODO: revamp
    alias 'mmake' 'make -f ~/Makefile'

    ### tail file
    alias 'ff' 'less +F'

    ### workaround "for fish_update_completions"
    set -x MANPATH /usr/share/man /usr/local/share/man $MANPATH

    ### update auto completions if not exist
    if not test -d $HOME/.local/share/fish/generated_completions
        fish_update_completions
    end
end

## curl
if test -d $PREFIX/opt/curl/bin
    set -x PATH $PREFIX/opt/curl/bin $PATH
end

### postgres
if test -d $PREFIX/opt/postgresql/bin
    set -x PATH $PREFIX/opt/postgresql/bin $PATH
end

# ### rubygems
# if command --search ruby >/dev/null
#     set -x PATH $HOME/.gem/ruby/2.3.0/bin $PATH
# end

### node (10)
set -x PATH "/usr/local/opt/node@10/bin" $PATH

### cargo
if command --search cargo >/dev/null
    set -x PATH $HOME/.cargo/bin $PATH
end

### lastly, direnv
if command --search direnv >/dev/null
    command direnv hook fish | source
end

function fish_prompt
    eval "$HOME/.go/bin/powerline-go -error $status -shell bare -cwd-max-depth 3 -max-width 50 -modules aws,docker,venv,ssh,cwd,gitlite,jobs,exit,root -path-aliases \~/.go/src/github.com=@gopath_gh,\~/Sync/prjcts=@src,\~/Sync/code=@code"
end
