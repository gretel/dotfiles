# https://gist.github.com/gretel/0bb5f77cdc54182c15dd

### disable greeting
set -e fish_greeting


### basic
set -x SHELL (which fish);
set -x PLATFORM (uname);

### local prefixes
set -x PREFIX /usr/local;
set -x XDG_CACHE_HOME $HOME/.cache;

if status --is-interactive

    if not test -d $HOME/.local/share/fish/generated_completions/
        echo "Updating completions..."
        fish_update_completions
    end

    if test (tput colors) -le 255
        set_color yellow
        echo "> TERM '$TERM' lacks colors, overriding to xterm-256color."
        set_color normal
        set -x TERM xterm-256color
    end

    # FIXME: move me somewhere nice
    function tm
        # must not already be inside tmux
        test ! $TMUX; or return
        # detach any other clients
        # attach or make new if there isn't one
        command tmux attach -d; or command tmux
    end

    ### hub
    # eval (hub alias -s)

    ### thefuck
    thefuck --alias | tr '\n' ';' | source

    ### pyenv
    source (pyenv init -|psub)
    source (pyenv virtualenv-init -|psub)

    ### direnv
    direnv hook fish | source

    ### keychain
    # eval (keychain --eval --inherit any --confhost --agents gpg,ssh $GPG_KEYS $SSH_KEYS)
    keychain --nogui --eval --inherit any --confhost --agents ssh,gpg $SSH_KEYS $GPG_KEYS | source
    # source $HOME/.keychain/(hostname)-fish
    # source $HOME/.keychain/(hostname)-fish-gpg
    # set -x SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent

    # FIXME: move, damnit
    function __setup_aliases_osx
        alias "rl"   "rm -f .config/fish/fishd.*; source $HOME/.config/fish/config.fish; command fish -v"

        ### aliases
        alias 'g'    'command git'
        alias 'h'    'command hub'
        alias 'gs'   'command gitsome'
        alias 'sl'   'command sublime'
        alias 'pe'   'command pyenv'
        alias 'de'   'command direnv'
        alias 'j'    'z'
        alias 'jj'   'zz'
        alias 'prj'  'z prj'

        ### exa
        alias 'ls'   'command exa'
        alias 'l'    'command exa -a -lgmH'
        alias 'lg'   'l --git'

        alias 'la'   'l -@'
        alias 'll'   'l -h'
        alias 'llg'  'll --git'

        alias 'l1'   'command exa -1 --group-directories-first'
        alias 'la1'  'l1 -a'

        alias 'le'   'command exa -a -lgH -s extension --group-directories-first'
        alias 'leg'  'le --git'

        alias 'lm'   'command exa -a -lghH -s modified -m'
        alias 'lmg'  'lm --git'

        alias 'lu'   'command exa -a -lghH -s modified -uU'
        alias 'lug'  'lu --git'

        alias 'lt'   'command exa -T'
        alias 'llt'  'command exa -a -lgHh -R -T'
        alias 'tree' 'llt'

        alias 'lr'   'command exa -a -lgHh -R -L 2'
        alias 'lrg'  'command exa -a -lgHh -R -L 2 --git'
        alias 'lrr'  "spin 'command exa -a -lgHh -R'"
    end

    set -x RY_RUBIES $HOME/.rubies;

    ### auth
    set -x SSH_KEYS $HOME/.ssh/id_rsa $HOME/.ssh/github;
    set -x GPG_KEYS '640F9BDD';

    ### all platforms
    set -x PAGER 'command less';

    set -x LC_ALL 'en_US.UTF-8';
    set -x GCC_COLORS 1;
    set -x CLICOLOR 1;
    set -x LSCOLORS gxBxhxDxfxhxhxhxhxcxcx;

    if test "$PLATFORM" = 'Darwin'
        # osx
        set -x BROWSER 'command open';
        set -x EDITOR  'command subl -n';
        set -x VISUAL  'command subl -n';

        set -x GPG_TTY (which tty);
        set -x HOMEBREW_GITHUB_API_TOKEN '0ee60b785c82f7554b15a19bcdaaa370effbe7c6';

        __setup_aliases_osx
    else
        # all other
        set -x EDITOR 'command joe';
    end

end
