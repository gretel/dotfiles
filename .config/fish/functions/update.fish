function -S update
    cd "$HOME"; or exit

    printf "updating. please wait!\n\n"
    
    fisher up

    if command --search mas >/dev/null
        ### apple
        printf "\nappstore:\n"
        # mas install 443126292
        mas upgrade
        printf "\nxcode:\n"
        xcode-select --install
    end

    if command --search brew >/dev/null
        printf "\nhomebrew:\n"
        # # repair
        # cd $(brew --repository)
        # git reset --hard FETCH_HEAD
        # cd $(brew --repository)/Library
        # git clean -fd
        brew analytics off
        #brew update; brew upgrade
        # printf "\n"; brew tap Homebrew/bundle; brew bundle; brew bundle --cleanup
        brew install -q rcmdnk/file/brew-file mas
        printf "\n"; brew file --preupdate --no_appstore update cask_upgrade
        printf "\n"; brew cleanup; brew prune; brew cask cleanup; brew linkapps
        printf "\n"; brew services clean; brew services list
    end

    ### gpg
    command --search pgp >/dev/null; and gpg2 --refresh-keys --keyserver hkps://pgp.mit.edu

    if command --search gem >/dev/null
        ### ruby
        printf "\nrubygems:\n"
        gem update --system --quiet
        gem update --quiet

        printf "\nbundler:\n"
        gem install bundler --no-document --quiet
        bundle update --jobs 4
    end

    if command --search npp >/dev/null
        ### node.js
        printf "\nnpm:\n"
        npm update; or npm install -g npm@latest
    end

    set -l py_versions "2.7.11 3.5.1"
    if test -n "$py_versions"
        ### python
        for p in $pys
            printf "\npip for %s:\n" "$p"
            pyenv local "$p"
            pip install -q -U setuptools pip
            pip list --outdated | sed 's/(.*//g' | xargs pip install -U
            switch $p
                case 2\*
                    pip install -U -r req_py2.txt
                case 3\*
                    pip install -U -r req_py3.txt
                    printf "\nperu:\n"
                    peru -v sync -f
                end
        end
    end

    if command --search terminal-notifier >/dev/null
        terminal-notifier -message 'done dating up' -title 'update.sh' -subtitle "$0" -sound Morse
    end
end