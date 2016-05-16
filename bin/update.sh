#!/bin/sh
#
cd "$HOME" || exit

printf "updating. please wait!\n\n"

### gpg
gpg2 --refresh-keys --keyserver hkps://pgp.mit.edu

### apple
printf "\nappstore:\n"
# mas install 443126292
mas upgrade
printf "\nxcode:\n"
xcode-select --install

printf "\nhomebrew:\n"
# # repair
# cd $(brew --repository)
# git reset --hard FETCH_HEAD
# cd $(brew --repository)/Library
# git clean -fd
brew analytics off
#brew update; brew upgrade
# printf "\n"; brew tap Homebrew/bundle; brew bundle; brew bundle --cleanup
printf "\n"; brew install -q rcmdnk/file/brew-file
brew file --preupdate --no_appstore update cask_upgrade

printf "\n"; brew cleanup; brew prune; brew cask cleanup; brew linkapps
brew services clean; brew services list

### fisher
printf "\nfisherman:\n"
# fish -c 'fisher up'
fisher up

### ruby
printf "\nrubygems:\n"
gem update --system --quiet
gem update --quiet

printf "\nbundler:\n"
gem install bundler --no-document --quiet
bundle update --jobs 4

### node.js
printf "\nnpm:\n"
npm update || npm install -g npm@latest

### python
pys="2.7.11 3.5.1"
for p in $pys
do
  printf "\npip for %s:\n" "$p"
  pyenv local "$p"
  pip install -q -U setuptools pip
  pip list --outdated | sed 's/(.*//g' | xargs pip install -U
  case "$p" in
    2.*.*)
      pip install -U -r req_py2.txt
      ;;
    3.*.*)
      pip install -U -r req_py3.txt
      printf "\nperu:\n"
      peru -v sync -f
      ;;
   esac
done

### done
terminal-notifier -message 'done dating up' -title 'update.sh' -subtitle "$0" -sound Morse
