#!/bin/sh
#

#echo "homebrew fix:"
#cd `brew --prefix`
#git remote add origin https://github.com/mxcl/homebrew.git
#git fetch origin
#git reset --hard origin/master

echo "brew:"
brew update; brew upgrade
brew tap Homebrew/bundle; brew bundle
brew cleanup; brew cask cleanup; brew prune; brew linkapps

echo "\nrubygems:"
yes | gem update --system --quiet
yes | gem update --quiet

echo "\nbundler:"
cd ~; bundle update

echo "\npip:";
pip install -U setuptools
pip install -U pip
pip list --outdated | sed 's/(.*//g' | xargs pip install -U
pyenv rehash

echo "\nnpm:"
npm update -g

echo "\nperu:"
peru -v sync

echo "\nmaid:"
maid clean --force

echo "\nomf:"
omf update

echo "\nsyncthing:"
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.syncthing.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.syncthing.plist

terminal-notifier -message 'update done yo' -title 'toolchain' -subtitle $0 -sound Morse

sync
