# https://gist.github.com/gretel/e4ccef1e415a356461c24591af314ebb/

function -d "call all update function" update
    ### sanity: non-superuser with homedir only
    test -n (id -u); or exit
    cd "$HOME"; or exit

    printf "updating. please wait...\n"

    __update_gpg_keys
    __update_fisher
    __update_mas
    __update_xcode_select
    __update_homebrew
    __update_npm
    __update_gem
    __update_bundler
    __update_pip
    __update_peru

    ### notification
    begin command --search terminal-notifier >/dev/null
        command terminal-notifier -message 'done dating up' -title 'update.sh' -subtitle "$0" -sound Morse
    end
end

### fisher
function __update_fisher
    begin source $HOME/.config/fish/functions/fisher.fish 2>/dev/null
        printf "\nfisher:\n"
        fisher up
    end
end

### apple store
function __update_mas
    begin command --search mas >/dev/null
        # test if logged in
        if test -n (mas account)
            printf "\nappstore:\n"
            command mas upgrade
        end
    end
end

### xcode command line tools
function __update_xcode_select
    begin command --search xcode-select >/dev/null
        printf "\nxcode-select:\n"
        command xcode-select --install
    end
end

### homebrew osx
function __update_homebrew
    begin command --search brew >/dev/null
        printf "\nhomebrew:\n"
        command brew analytics off # https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
        command brew update; brew upgrade
        # # brew-bundle
        # brew tap Homebrew/bundle; brew bundle; brew bundle --cleanup
        # brew-file
        command brew install -q rcmdnk/file/brew-file mas 2>/dev/null; printf "\n"
        command brew file --verbose 0 --preupdate --no_appstore update cask_upgrade
        command brew cleanup; command brew prune; command brew cask cleanup; command brew linkapps; printf "\n"
        printf "\n"; command brew services clean; command brew services list
    end
end

### gpg keys
function __update_gpg_keys
    begin command --search gpg2 >/dev/null
        printf "\ngnupg2:\n"
        command gpg2 --refresh-keys --keyserver hkps://pgp.mit.edu
    end
end

### node npm
function __update_npm
    begin command --search npm >/dev/null
        printf "\nnpm:\n"
        command npm update; or command npm install -g npm@latest
    end
end

### ruby gems
function __update_gem
    begin command --search gem >/dev/null
        if set -l rb_which (which ruby)
            printf "\nrubygems:\n"
            # FIXME: improve check for portability
            if test "$rb_which" = "/usr/bin/ruby"
                printf "not updating rubygems for $rb_which.\n"
            else
                command gem update --system --no-document --env-shebang --prerelease --quiet
                command gem update --no-document --env-shebang --prerelease --quiet
                command gem install bundler --no-document --env-shebang --prerelease --quiet
            end
        end
    end
end

### ruby bundler
function __update_bundler
    # TODO: show existing config and wait a few secs to confirm
    begin command --search bundler >/dev/null
        printf "\nbundler:\n"
        set -l rb_which (which ruby 2>/dev/null)
        if test "$rb_which" = "/usr/bin/ruby"
            printf "not calling bundler for system ruby at $rb_which.\n"
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
    begin command --search pip >/dev/null
        command pip install -q -U setuptools pip
        command pip list --outdated | sed 's/(.*//g' | xargs pip install -q -U
        set -l req "requirements.txt"
        begin test -f $reg
            command pip install -q -U -r $req
        end
    end
end

function __update_peru
    if command --search peru >/dev/null
        printf "\nperu:\n"
        command peru -v sync -f
    end
end
