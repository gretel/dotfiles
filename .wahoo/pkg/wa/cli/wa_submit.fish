# SYNOPSIS
#   Submit a package to the registry
#
# OPTIONS
#   name  Name of the package.
#   bare  No PR add new entry under db/

function wa_submit -a name bare -d "Submit a package to the registry"
  switch (dirname $name)
    case pkg
    case themes
    case "*"
      echo (wa::err)"Missing directory name pkg/ or themes/"(wa::off) 1^&2
      return $WAHOO_INVALID_ARG
  end

  set -l pkg (basename $name)

  if not wa_util_valid_package $pkg
    echo (wa::err)"$pkg is not a valid package/theme name"(wa::off) 1^&2
    return $WAHOO_INVALID_ARG
  end

  if test -n "$bare"
    if test -e "$WAHOO_PATH/db/$name"
      echo (wa::err)"Error: $pkg already exists in the registry"(wa::off) 1^&2
      return $WAHOO_INVALID_ARG
    else
      echo "$bare" > $WAHOO_PATH/db/$name
      echo (wa::em)"$pkg added to the "(dirname $name)" registry."(wa::off)
      return 0
    end
  end

  set -l url (git config --get remote.origin.url)
  if test -z "$url"
    echo (wa::err)"$pkg remote URL not found"(wa::off) 1^&2
    echo "Try: git remote add <URL> or see Docs > Submitting" 1^&2
    return $WAHOO_INVALID_ARG
  end

  set -l author "bucaran"
  switch "$url"
    case \*$author/wahoo\*
      echo (wa::err)"$url is not a valid package directory"(wa::off) 1^&2
      return $WAHOO_INVALID_ARG
  end

  set -l user (git config github.user)
  if test -z "$user"
    echo (wa::err)"GitHub user configuration unavailable"(wa::off) 1^&2
    echo "Try: git config github.user "(wa::em)"username"(wa::off) 1^&2
    return $WAHOO_INVALID_ARG
  end

  if test -e $WAHOO_PATH/db/$name
    echo (wa::err)"Error: $pkg already exists in the registry"(wa::off) 1^&2
    echo "See: "(line)(cat $WAHOO_PATH/db/$name)(wa::off)" for more info." 1^&2
    return $WAHOO_INVALID_ARG
  end

  pushd $WAHOO_PATH

  if not git remote show remote >/dev/null ^&1
    wa_util_fork_repo "$user" "$author/wahoo"
    git remote rm origin >/dev/null ^&1
    git remote add origin   "https://github.com"/$user/wahoo    >/dev/null ^&1
    git remote add upstream "https://github.com"/$author/wahoo  >/dev/null ^&1
  end

  git checkout -b add-$name

  echo "$url" > $WAHOO_PATH/db/$name
  echo (wa::em)"$name added to the registry."(wa::off)

  git add -A >/dev/null ^&1
  git commit -m "Adding $name to registry." >/dev/null ^&1
  git pull --rebase upstream >/dev/null ^&1
  git push origin add-$name

  popd
  open "https://github.com"/$user/wahoo
end