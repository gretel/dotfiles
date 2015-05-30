# SYNOPSIS
#   Initialize Wahoo.
#
# ENV
#   WAHOO_PATH    Set in ~/.config/fish/config.fish
#   WAHOO_CUSTOM  Same as WAHOO_PATH. ~/.dotfiles by default.
#   RESET_PATH    Original PATH. To preseve across Wahoo reloads.
#
# OVERVIEW
#   Autoloads Wahoo's packages, themes and custom path (in that order),
#   loading any <package>.fish files if available. If this succeeds,
#   emits and init_<package> event.
#
#   Autoloads functions directory and sources init.fish under
#   the custom path if available.

set -q RESET_PATH
  and set PATH $RESET_PATH
  or set --export RESET_PATH $PATH

set -l user_function_path $fish_function_path[1]
set fish_function_path[1] $WAHOO_PATH/lib
set fish_complete_path    $WAHOO_PATH/lib/completions

set -l theme  {$WAHOO_PATH,$WAHOO_CUSTOM}/themes/(cat $HOME/.config/wahoo/theme)
set -l paths  $WAHOO_PATH/pkg/*
set -l custom $WAHOO_CUSTOM/pkg/*

for path in $paths
  set custom $WAHOO_CUSTOM/(basename $path) $custom
end

for path in $paths $theme $custom
  autoload $path $path/completions
  source $path/(basename $path).fish
    and emit init_(basename $path) $path
end

autoload $WAHOO_CUSTOM/functions
autoload $user_function_path
source $WAHOO_CUSTOM/init.fish
