# SYNOPSIS
#   Initialize Wahoo.
#
# ENV
#   OSTYPE        Operating system.
#   RESET_PATH    Original $PATH preseved across Wahoo refreshes.
#   WAHOO_PATH    Set in ~/.config/fish/config.fish
#   WAHOO_IGNORE  List of packages to ignore.
#   WAHOO_CUSTOM  Same as WAHOO_PATH. ~/.dotfiles by default.
#
# OVERVIEW
#   Autoloads Wahoo's packages, themes and custom path (in that order),
#   loading any <package>.fish files if available. If this succeeds,
#   emits and init_<package> event.
#
#   Autoloads functions directory and sources init.fish under
#   the custom path if available.

if not set -q OSTYPE
  set -g OSTYPE (uname)
end

if set -q RESET_PATH
  set PATH $RESET_PATH
else
  set -gx RESET_PATH $PATH
end

# Save the head of function path and autoload our core library.
set -l user_function_path $fish_function_path[1]
set fish_function_path[1] $WAHOO_PATH/lib

set -l theme  {$WAHOO_PATH,$WAHOO_CUSTOM}/themes/(cat $HOME/.config/wahoo/theme)
set -l paths  $WAHOO_PATH/pkg/*
set -l custom $WAHOO_CUSTOM/pkg/*
set -l ignore $WAHOO_IGNORE

for path in $paths
  set custom $WAHOO_CUSTOM/(basename $path) $custom
end

for path in $WAHOO_PATH/lib $WAHOO_PATH/lib/git $paths $theme $custom
  contains -- (basename $path) $ignore; and continue
  autoload $path $path/completions
  source $path/(basename $path).fish
    and emit init_(basename $path) $path
end

# Optional. Custom function library and shell initialization.
autoload $WAHOO_CUSTOM/functions
autoload $user_function_path
source $WAHOO_CUSTOM/init.fish
