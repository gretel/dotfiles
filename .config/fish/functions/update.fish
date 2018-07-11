# https://gist.github.com/gretel/e6cd59fba3d31fe5a4e9a1feea985375

### when 'update' is called without arguments these are the defaults:
if not set -q update_funcs
    set -x update_funcs \
        xcode_select \
        peru \
        homebrew \
        homebrew_cask \
        apm \
        fisher \
        gem \
        gpg_keys \
        # homebrew_head \
        mas \
        npm \
        pip \
        completions
end

### fisher
function __update_fisher
    # TODO: abstraction
    if source $HOME/.config/fish/functions/fisher.fish 2>/dev/null
        fisher up
    end
end

### fish
function __update_completions
    fish_update_completions
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

### github atom
function __update_apm
    if command --search apm >/dev/null
        command apm upgrade -c false; command apm update -c false
    end
    if command --search apm-beta >/dev/null
        command apm-beta upgrade -c false; command apm-beta update -c false
    end

end

### homebrew osx
function __update_homebrew
    if command --search brew >/dev/null
    	command brew update
        command brew upgrade
        command brew prune
        command brew cask cleanup >/dev/null;
        command brew services cleanup >/dev/null
        command brew services list
        command brew list --versions | grep -i head | awk '{print $1}' | xargs brew list
    end
end

### homebrew osx
function __update_homebrew_head
    if command --search brew >/dev/null
        command brew list --versions | grep -i head | awk '{print $1}' | xargs brew reinstall --HEAD
    end
end

### homebrew cash
function __update_homebrew_cask
    if command --search brew >/dev/null
        command brew cu -y -q --cleanup
    end
end

### gpg keys
function __update_gpg_keys
    if command --search gpg >/dev/null
        command gpg --refresh-keys --keyserver hkps://pgp.mit.edu
    end
end

### node npm
function __update_npm
    if command --search npm >/dev/null
        command npm install -g npm
        command npm update
    end
end

### ruby gems
function __update_gem
    if command --search ry >/dev/null
        set -l versions (ry ls)
        if test $versions = '*'
            echo 'no ruby'
            return 1
        end
        for v in $versions
            echo "ruby $v"
           	#command ry exec $v gem update --system --no-document --env-shebang --wrappers
            command ry exec $v gem update --no-document --env-shebang --wrappers
        		command ry exec $v gem install bundler
            if test -f '.bundle/config'
                command ry exec $v bundler
            else
                command ry exec $v bundler update --jobs 4 --retry 1
            end
        end
    end
end

### python pip
function __update_pip
    if command --search pyenv >/dev/null
        set -l versions (pyenv versions --bare)
        for v in $versions
            echo "python $v"
            pyenv shell $v
            pyenv exec pip install -q -U setuptools pip
            pyenv exec pip list --outdated | sed 's/(.*//g' | xargs pip install -U --pre
            set -l req 'requirements.txt'
            if test -f "$reg"
                pyenv exec pip install -q -U --pre -r "$req"
            end
            pyenv shell --unset
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
function update
    # sanity: non-superuser with homedir only
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
    emit send_notification Fish Update "$list"
end
