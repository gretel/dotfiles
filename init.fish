# Source any $WAHOO_CUSTOM/init.fish and autoload functions in:
#   $WAHOO_CUSTOM/{theme/*,functions,pkg/*,*}
#   $WAHOO_PATH/{theme/*,pkg/*}

set -l user_function_path $fish_function_path[1]
set fish_function_path[1] $WAHOO_PATH/lib

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
autoload "$user_function_path"
source $WAHOO_CUSTOM/init.fish