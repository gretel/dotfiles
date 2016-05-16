#!/bin/sh
#
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
# update
brew update; brew upgrade
# .Brewfile
cd "$HOME" || exit
brew tap Homebrew/bundle; brew bundle --global
# cask
brew cask cleanup
# tidy
brew cleanup; brew prune; brew linkapps
# services
brew services clean; brew services list


### ruby
printf "\nrubygems:\n"
yes | gem update --system --quiet
yes | gem update --quiet

printf "\nbundler:\n"
gem install bundler --no-document
bundle update

### node.js
printf "\nnpm:\n"
npm update || npm install -g npm@latest

pys="2.7.11 3.5.1"

### python
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
