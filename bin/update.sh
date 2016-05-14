#!/bin/sh
#
echo "updating. please wait!\n"

gpg2 --refresh-keys --keyserver hkps://pgp.mit.edu

echo "\nxcode:"
xcode-select --install

echo "\nhomebrew:"
# # repair
# cd $(brew --repository)
# git reset --hard FETCH_HEAD
# cd $(brew --repository)/Library
# git clean -fd

brew analytics off
# update
brew update; brew upgrade
# .Brewfile
cd ~; brew tap Homebrew/bundle; brew bundle --global
# cask
brew cask cleanup
# tidy
brew cleanup; brew prune; brew linkapps
# services
echo "\n"; brew services list

echo "\appstore:"
# mas install 443126292
mas upgrade

echo "\nrubygems:"
yes | gem update --system --quiet
yes | gem update --quiet

echo "\nbundler:"
gem install bundler --no-document
bundle update

echo "\nnpm:"
npm update -g || npm install -g npm@latest

# pip
for p in 2.7.11 3.5.1
do
  echo "\npip for ${p}:"
  pyenv local $p
  pip install -q -U setuptools pip
  pip list --outdated | sed 's/(.*//g' | xargs pip install -U
done

# peru
echo "\nperu:"
pyenv local 3.5.1
pip install -U -r req_py3.txt
peru -v sync -f

# done
terminal-notifier -message 'done dating up' -title 'update.sh' -subtitle $0 -sound Morse
