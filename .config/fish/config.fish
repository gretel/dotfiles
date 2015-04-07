# Debugging output switch
#
# enable if you have any issues to debug
#
set -e DEBUG # debug output: disabled
#set -gu DEBUG 1 # debug output: enabled
[ $DEBUG ]; and echo "*** loading: config.fish"

# Local system
#
# plugins may depend on these.. so change with case please.
#
set -Ux DOMAIN (hostname -s)
set -Ux HOSTNAME (hostname)
[ $DEBUG ]; and echo "\$HOSTNAME: $HOSTNAME"

# User ID
#
set -gx UID (id -u $USER)
[ $DEBUG ]; and echo "\$UID: $UID"

# This interactive fish?
#
if status --is-interactive

  # Mother of all fish paths
  #
  set fish_path $HOME/.oh-my-fish

  # Plugins to load
  #
  # author's choice:
  set fish_plugins bundler direnv greeting jump keychain osx_manpath peco pyenv screen sublime
  #
  # leighweight defaults:
  # set fish_plugins extract fishmarks greeting osx_manpath

  # Path to your custom folder (default path is $FISH/custom)
  # set fish_custom $HOME/dotfiles/oh-my-fish

  # Theme
  #
  # please initialize submodule once:
  #  $ git pull; git submodule init; git submodule update; git submodule status
  #
  # set fish_theme gianu
  set fish_theme agnoster

  # Load oh-my-fish configuration.
  . $fish_path/oh-my-fish.fish
end
