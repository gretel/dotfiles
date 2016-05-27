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

    set -x RY_RUBIES $HOME/.rubies;

    ### auth
    set -x SSH_KEYS $HOME/.ssh/id_rsa $HOME/.ssh/github;
    set -x GPG_KEYS '640F9BDD';

    ### all platforms
    set -x PAGER 'less';

    set -x LC_ALL 'en_US.UTF-8';
    set -x GCC_COLORS 1;
    set -x CLICOLOR 1;
    set -x LSCOLORS gxBxhxDxfxhxhxhxhxcxcx;

    if test "$PLATFORM" = 'Darwin'
        # osx
        set -x BROWSER 'open';
        set -x EDITOR  'subl -n';
        set -x VISUAL  'joe';

        set -x GPG_TTY (which tty);
    else
        # all other
        set -x EDITOR 'joe';
    end

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
    # eval (command hub alias -s)

    ### thefuck
    command thefuck --alias | tr '\n' ';' | source

    # set -x PATH '/usr/local/Cellar/pyenv-virtualenv/HEAD/shims' $PATH;
    set -x PYENV_VIRTUALENV_INIT 1;

    function pyenv
        set command $argv[1]
        set -e argv[1]

        switch "$command"
            case rehash shell
                source (pyenv "sh-$command" $argv | psub)

            case \*
                command pyenv "$command" $argv
        end
    end

    ### direnv
    command direnv hook fish | source

    ### keychain
    # keychain --nogui --eval --inherit any --confhost --agents ssh,gpg $SSH_KEYS $GPG_KEYS | source
    command keychain --nogui --eval --inherit any --confhost --agents ssh $SSH_KEYS | source
    # source $HOME/.keychain/(hostname)-fish
    # source $HOME/.keychain/(hostname)-fish-gpg
    # set -x SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent

    # FIXME: move, damnit
    function __setup_aliases_osx
        alias "rl"   "rm .config/fish/fishd.* 2>/dev/null; source $HOME/.config/fish/config.fish; command fish -v"

        ### aliases
        alias 'g'    'git'
        alias 'h'    'hub'
        alias 'gs'   'gitsome'
        alias 'sl'   'sublime'
        alias 'pe'   'pyenv'
        alias 'de'   'direnv'
        alias 'j'    'z'
        alias 'jj'   'zz'
        alias 'prj'  'z prj'

        ### exa
        alias 'ls'   'exa'
        alias 'l'    'exa -a -lgmH'
        alias 'lg'   'l --git'

        alias 'la'   'l -@'
        alias 'll'   'l -h'
        alias 'llg'  'll --git'

        alias 'l1'   'exa -1 --group-directories-first'
        alias 'la1'  'l1 -a'

        alias 'le'   'exa -a -lgH -s extension --group-directories-first'
        alias 'leg'  'le --git'

        alias 'lm'   'exa -a -lghH -s modified -m'
        alias 'lmg'  'lm --git'

        alias 'lu'   'exa -a -lghH -s modified -uU'
        alias 'lug'  'lu --git'

        alias 'lt'   'exa -T'
        alias 'llt'  'exa -a -lgHh -R -T'
        alias 'tree' 'llt'

        alias 'lr'   'exa -a -lgHh -R -L 2'
        alias 'lrg'  'exa -a -lgHh -R -L 2 --git'
        alias 'lrr'  "spin 'exa -a -lgHh -R'"
    end
    __setup_aliases_osx

end
