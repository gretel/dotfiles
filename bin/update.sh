#!/bin/sh
#

#echo "homebrew fix:"
#cd `brew --prefix`
#git remote add origin https://github.com/mxcl/homebrew.git
#git fetch origin
#git reset --hard origin/master

echo "brew:"
brew update; brew upgrade
brew cleanup; brew prune

echo "brew cask nightlies:"
rm /Library/Caches/Homebrew/chromium-latest
brew cask install chromium --force
brew cask cleanup

echo "\nfish:"
cd .oh-my-fish; git pull --recurse-submodules

echo "\nrubygems:"
brew link --force --overwrite ruby
yes | gem update --system --quiet
yes | gem update --quiet
cd ~; bundle update

echo "\npip:";
#brew link python --force --overwrite
pip install --upgrade setuptools
pip install --upgrade pip

echo "\nnpm:"
npm update -g > /dev/null

echo "\ntaskpaper:"
~/bin/TaskPaperDaily.rb

terminal-notifier -message 'updated yo' -title 'Toolset Update' -subtitle $0 -sound Morse

sync
