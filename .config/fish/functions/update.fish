# https://gist.github.com/gretel/e4ccef1e415a356461c24591af314ebb/

### when 'update' is called without arguments these are the defaults:
if not set -q update_funcs
    set -x update_funcs \
        gpg_keys \
        fisher \
        mas \
        xcode_select \
        homebrew \
        npm \
        gem \
        bundler \
        pip \
        peru
end

### fisher
function __update_fisher
    if source $HOME/.config/fish/functions/fisher.fish 2>/dev/null
        fisher up
        fish_update_completions
    end
end

### apple store
function __update_mas
    if command --search mas >/dev/null
        # test if logged in
        if test -n (mas account)
            command mas upgrade
        end
    end
end

### xcode command line tools
function __update_xcode_select
    if command --search xcode-select >/dev/null
        command xcode-select --install
    end
end

### homebrew osx
function __update_homebrew
    if command --search brew >/dev/null
        command brew install -q rcmdnk/file/brew-file mas 2>/dev/null
        command brew file --preupdate --no_appstore update cask_upgrade
        command brew prune>/dev/null; command brew linkapps >/dev/null
        command brew cask cleanup >/dev/null;
        command brew services cleanup >/dev/null; command brew services list
    end
end

### gpg keys
function __update_gpg_keys
    if command --search gpg2 >/dev/null
        command gpg2 --refresh-keys --keyserver hkps://pgp.mit.edu
    end
end

### node npm
function __update_npm
    if command --search npm >/dev/null
        command npm update; or command npm install -g npm@latest
    end
end

### ruby gems
function __update_gem
    if command --search gem >/dev/null
        if set -l rb_which (which ruby)
            # FIXME: improve check for portability
            if test "$rb_which" = "/usr/bin/ruby"
                set_color --bold yellow; printf "not calling gem for system ruby $rb_which.\n"; set_color normal
                return 3
            else
                command gem update --system --no-document --env-shebang --wrappers --quiet
                command gem update --no-document --env-shebang --wrappers --quiet
                command gem install bundler
            end
        end
    end
end

### ruby bundler
function __update_bundler
    # TODO: show existing config and wait a few secs to confirm
    if command --search bundler >/dev/null
        set -l rb_which (which ruby 2>/dev/null)
        if test "$rb_which" = "/usr/bin/ruby"
            set_color --bold yellow; printf "not calling bundler for system ruby at $rb_which.\n"; set_color normal
            return 3
        else
            if test -f ".bundle/config"
                command bundler
            else
                command bundler update --jobs 4 --retry 1 --clean --path vendor/cache
            end
        end
    end
end

### python pip
function __update_pip
    if command --search pip >/dev/null
        command pip install -q -U setuptools pip
        command pip list --outdated | sed 's/(.*//g' | xargs pip install -q -U
        set -l req "requirements.txt"
        if test -f "$reg"
            command pip install -q -U -r "$req"
        end
    end
end

### peru
function __update_peru
    if command --search peru >/dev/null
        command peru -v sync -f
    end
end

### main
function -d "keep your development tools up to date" update
    ### sanity: non-superuser with homedir only
    test -n (id -u); or return 1
    cd "$HOME"; or return 1

    if test -n "$argv"
        set list $argv
    else
        set list $update_funcs
    end
    for f in $list
        set -l func "__update_$f"
        if functions -q "$func"
            set_color --bold white; printf "==== %s\n" "$f"; set_color normal
            eval "$func"
        else
            set_color --bold red; printf "function %s is not declared!\n" "$func"; set_color normal
            return 2
        end
    end

    ### notification
    emit send_notification Fish Update "$list" Bing
end
