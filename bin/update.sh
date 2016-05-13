#!/bin/sh
#
echo "xcode:"
xcode-select --install

echo "\nhomebrew:"
# cd $(brew --repository)
# git reset --hard FETCH_HEAD
# cd $(brew --repository)/Library
# git clean -fd
brew analytics off
brew update; brew upgrade
cd ~; brew tap Homebrew/bundle; brew bundle --global
brew cleanup; brew cask cleanup; brew prune; brew linkapps

brew services list

echo "\nmas:"
# mas install 443126292
mas upgrade

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
npm update -g || npm install -g npm@latest

echo "\nperu:"
pyenv local 3.5.1
peru -v sync

terminal-notifier -message 'done dating up' -title 'update.sh' -subtitle $0 -sound Morse

sync
