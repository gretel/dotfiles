#!/bin/sh
#

echo "brew:"
#cd $(brew --prefix)
#git fetch origin
#git reset --hard origin/master

cd $(brew --repository)
git reset --hard FETCH_HEAD
cd $(brew --repository)/Library
git clean -fd
cd ~
brew update; brew upgrade
#brew tap Homebrew/bundle;
brew bundle
brew cleanup; brew cask cleanup; brew prune; brew linkapps

# TODO: abstraction
for p in 2.7.11 3.5.1
do
  echo "\npip for ${p}:"
  pyenv local $p
  pip install -U setuptools
  pip install -U pip
  pip list --outdated | sed 's/(.*//g' | xargs pip install -U
done

echo "\nrubygems:"
yes | gem update --system --quiet
yes | gem update --quiet

echo "\nbundler:"
gem install bundler
bundle update

echo "\nnpm:"
npm update -g

echo "\nperu:"
# TODO: abstraction
pyenv local 3.5.1
peru -v sync

echo "\nsyncthing:"
launchctl unload /usr/local/opt/syncthing/homebrew.mxcl.syncthing.plist
launchctl load /usr/local/opt/syncthing/homebrew.mxcl.syncthing.plist

terminal-notifier -message 'update done yo' -title 'toolchain' -subtitle $0 -sound Morse

sync
