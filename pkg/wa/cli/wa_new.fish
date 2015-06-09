function wa_new -a option name
  switch $option
    case "p" "pkg" "pack" "packg" "package"
      set pkg "pkg"
    case "t" "th" "thm" "theme"
      set pkg "themes"
    case "*"
      echo (wa::err)"$option is not a valid option."(wa::off) 1^&2
      return $WAHOO_INVALID_ARG
  end

  if not wa_util_valid_package "$name"
    echo (wa::err)"$name is not a valid package/theme name"(wa::off) 1^&2
    return $WAHOO_INVALID_ARG
  end

  if set -l dir (wa_util_mkdir "$pkg/$name")
    cd $dir
    if test $pkg = "pkg"
      echo "function $name"\n"end"\n > "$dir/$name.fish"
    else
      cp "$WAHOO_PATH/themes/default/fish_prompt.fish" "$dir/fish_prompt.fish"
    end
    echo "# $name"\n > "$dir/README.md"
    echo (wa::em)"Directory changed to $dir"(wa::off)
  else
    echo (wa::err)"\$WAHOO_CUSTOM and \$WAHOO_PATH undefined."(wa::off) 1^&2
    exit $WAHOO_UNKNOWN_ERR
  end
end