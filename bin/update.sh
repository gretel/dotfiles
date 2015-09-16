#!/bin/sh
#

#echo "homebrew fix:"
#cd `brew --prefix`
#git remote add origin https://github.com/mxcl/homebrew.git
#git fetch origin
#git reset --hard origin/master

echo "brew:"
brew update; brew upgrade
brew cleanup; brew prune; brew linkapps

echo "brew cask:"
#rm /Library/Caches/Homebrew/chromium-latest
#brew cask install chromium --force
brew cask cleanup

echo "\nrubygems:"
#brew link --force --overwrite ruby
yes | gem update --system --quiet
yes | gem update --quiet
cd ~; bundle update

echo "\npip:";
#brew link python --force --overwrite
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

terminal-notifier -message 'update done yo' -title 'toolchain' -subtitle $0 -sound Morse

sync
