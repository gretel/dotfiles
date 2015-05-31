function wa_submit -a name
  set -l ext ""
  switch $name
    case \*.pkg
      set ext .pkg
    case \*.theme
      case ext .theme
    case "*"
      echo (bold)(line)(err)"Missing extension .pkg or .theme"(off) 1^&2
      return $WAHOO_INVALID_ARG
  end
  set name (basename $name $ext)

  set -l url (git config --get remote.origin.url)
  if test -z "$url"
    echo (bold)(line)(err)"$name remote URL not found"(off) 1^&2
    echo "Try: git remote add <URL> or see Docs > Submitting" 1^&2
    return $WAHOO_INVALID_ARG
  end

  switch "$url"
    case \*bucaran/wahoo\*
      echo (bold)(line)(err)"$url is not a valid package directory"(off) 1^&2
      return $WAHOO_INVALID_ARG
  end

  set -l user (git config github.user)
  if test -z "$user"
    echo (bold)(line)(err)"GitHub user configuration not available"(off) 1^&2
    echo "Try: git config github.user "(line)"username"(off) 1^&2
    return $WAHOO_INVALID_ARG
  end

  if not wa_util_valid_package $name
    echo (bold)(line)(err)"$pkg is not a valid package/theme name"(off) 1^&2
    return $WAHOO_INVALID_ARG
  end

  if test -e $WAHOO_PATH/db/$name$ext
    echo (bold)(line)(err)"$name already exists in the registry"(off) 1^&2
    echo "See: "(line)(cat $WAHOO_PATH/db/$name$ext)(off)" for more info." 1^&2
    return $WAHOO_INVALID_ARG
  end

  pushd $WAHOO_PATH

  if not git remote show remote >/dev/null ^&1
    wa_util_fork_repo "$user" "bucaran/wahoo"
    git remote rm origin >/dev/null ^&1
    git remote add origin   "https://github.com"/$user/wahoo    >/dev/null ^&1
    git remote add upstream "https://github.com"/bucaran/wahoo  >/dev/null ^&1
  end

  git checkout -b add-$name

  echo "$url" > $WAHOO_PATH/db/$name$ext
  echo (em)"$name added to the registry."(off)

  git add -A >/dev/null ^&1
  git commit -m "Adding $name to registry." >/dev/null ^&1
  git pull --rebase upstream >/dev/null ^&1
  git push origin add-$name

  popd
  open "https://github.com"/$user/wahoo
end