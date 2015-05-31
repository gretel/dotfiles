function wa_new -a option name
  switch $option
    case "p" "pkg" "pack" "packg" "package"
      set pkg "pkg"
    case "t" "th" "thm" "theme"
      set pkg "themes"
    case "*"
      echo (bold)(line)(err)"$option is not a valid option."(off) 1^&2
      return $WAHOO_INVALID_ARG
  end

  if not wa_util_valid_package "$name"
    echo (bold)(line)(err)"$name is not a valid package/theme name"(off) 1^&2
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
    echo (em)"Directory changed to "(line)"$dir"(off)
  else
    echo (bold)(line)(err)"\$WAHOO_CUSTOM and \$WAHOO_PATH undefined."(off) 1^&2
    exit $WAHOO_UNKNOWN_ERR
  end
end