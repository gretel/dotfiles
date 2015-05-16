set -g WAHOO_MISSING_ARG   1
set -g WAHOO_UNKNOWN_OPT   2
set -g WAHOO_INVALID_ARG   3
set -g WAHOO_UNKNOWN_ERR   4

set -g WAHOO_VERSION "0.1.0"
set -g WAHOO_CONFIG  "$HOME/.config/wahoo"

function wa -d "Wahoo"
  function line; set_color -u; end
  function bold; set_color -o; end
  function em; set_color cyan; end
  function off; set_color normal; end
  function err; set_color red; end

  if test (count $argv) -eq 0
    WAHOO::cli::help
    return 0
  end

  switch $argv[1]
    case "v" "ver" "version"
      WAHOO::cli::version

    case "h" "help"
      WAHOO::cli::help

    case "l" "li" "lis" "lst" "list"
      WAHOO::cli::list $WAHOO_PATH/pkg/*

    case "g" "ge" "get" "install"
      test (count $argv) -eq 1
        and WAHOO::cli::list $WAHOO_PATH/db/*.pkg .pkg $WAHOO_PATH/pkg
        or WAHOO::cli::get $argv[2..-1]

    case "u" "use"
      if test (count $argv) -eq 1
        WAHOO::util::list_themes
      else if test (count $argv) -eq 2
        WAHOO::cli::use $argv[2]
      else
        echo (bold)(line)(err)"Invalid number of arguments"(off) 1^&2
        echo "Usage: $_ "(em)"$argv[1]"(off)" [<theme name>]" 1^&2
        return $WAHOO_INVALID_ARG
      end

    case "r" "rm" "remove" "uninstall"
      if test (count $argv) -ne 2
        echo (bold)(line)(err)"Invalid number of arguments"(off) 1^&2
        echo "Usage: $_ "(em)"$argv[1]"(off)" <[package|theme] name>" 1^&2
        return $WAHOO_INVALID_ARG
      end
      WAHOO::cli::remove $argv[2..-1]

    case "p" "up" "upd" "update"
      pushd $WAHOO_PATH
      echo (bold)"Updating Wahoo..."(off)
      if WAHOO::cli::update
        echo (em)"Wahoo is up to date."(off)
      else
        echo (line)"Wahoo failed to update."(off)
        echo "Please open a new issue here → "(line)"git.io/wahoo-issues"(off)
      end
      popd
      reload

    case "s" "su" "sub" "submit"
      if test (count $argv) -ne 2
        echo (bold)(line)(err)"Argument missing"(off) 1^&2
        echo "Usage: $_ "(em)"$argv[1]"(off)" <package/theme name>" 1^&2
        return $WAHOO_MISSING_ARG
      end
      WAHOO::cli::submit $argv[2]

    case "n" "nw" "new"
      if test (count $argv) -ne 3
        echo (bold)(line)(err)"Argument missing"(off) 1^&2
        echo "Usage: $_ "(em)"$argv[1]"(off)" "\
          (bold)"pkg|theme"(off)" <name>" 1^&2
        return $WAHOO_MISSING_ARG
      end
      WAHOO::cli::new $argv[2..-1]

    case "*"
      echo (bold)(line)(err)"$argv[1] option not recognized"(off) 1^&2
      return $WAHOO_UNKNOWN_OPT
  end
end

function WAHOO::cli::version
  echo "Wahoo $WAHOO_VERSION"
end

function WAHOO::cli::help
  echo \n"\
  "(bold)"Wahoo"(off)"
    The Fishshell Framework

  "(bold)"Usage"(off)"
    wa "(line)"action"(off)" [package]

  "(bold)"Actions"(off)"
       "(bold)(line)"l"(off)"ist  List local packages.
        "(bold)(line)"g"(off)"et  Install one or more packages.
        "(bold)(line)"u"(off)"se  List / Apply themes.
     "(bold)(line)"r"(off)"emove  Remove a package.
     u"(bold)(line)"p"(off)"date  Update Wahoo.
        "(bold)(line)"n"(off)"ew  Create a new package from a template.
     "(bold)(line)"s"(off)"ubmit  Submit a package to the registry.
       "(bold)(line)"h"(off)"elp  Display this help.
    "(bold)(line)"v"(off)"ersion  Display version.

  For more information visit → "(bold)(line)"git.io/wahoo-doc"(off)\n
end

function WAHOO::cli::use
  if not test -e $WAHOO_CUSTOM/themes/$argv[1]
    if not test -e $WAHOO_PATH/themes/$argv[1]
      set -l theme $WAHOO_PATH/db/$argv[1].theme
      if test -e $theme
        echo (bold)"Downloading $theme..."(off)
        git clone (cat $theme) \
          $WAHOO_PATH/themes/$argv[1] >/dev/null ^&1
          and echo (em)"$theme theme downloaded."(off)
          or return $WAHOO_UNKNOWN_ERR
      else
        echo (bold)(line)(err)"$argv[1] is not a valid theme"(off) 1^&2
        return $WAHOO_INVALID_ARG
      end
    end
  end
  WAHOO::util::apply_theme $argv[1]
end

function WAHOO::cli::list
  set -l path $argv[1]
  set -l ext ""
  set -l exclude ""
  set -q argv[2]; and set ext $argv[2]
  set -q argv[3]; and set exclude (basename $argv[3]/*)

  for item in (printf "%s\n" $path)
    set item (basename "$item" "$ext")
    if not contains $item $exclude
      echo $item
    end
  end | column
end

function WAHOO::cli::update
  set -l repo "upstream"
  test -z (git config --get remote.upstream.url)
    and set -l repo "origin"

  if WAHOO::git::repo_is_clean
    git pull $repo master >/dev/null ^&1
  else
    git stash >/dev/null ^&1
    if git pull --rebase $repo master >/dev/null ^&1
      git stash apply >/dev/null ^&1
    else
      WAHOO::util::sync_head # Like a boss
    end
  end
end

function WAHOO::cli::get
  for search in $argv
    if test -e $WAHOO_PATH/db/$search.theme
      set target themes/$search
    else if test -e $WAHOO_PATH/db/$search.pkg
      set target pkg/$search
    else
      echo (bold)(line)(err)"$search is not a valid package/theme"(off) 1^&2
      continue
    end
    if test -e $WAHOO_PATH/$target
      echo (bold)"Updating $search..."(off)
      pushd $WAHOO_PATH/$target
      WAHOO::util::sync_head >/dev/null ^&1
      popd
      echo (em)"$search up to date."(off)
    else
      echo (bold)"Installing $search..."(off)
      git clone (cat $WAHOO_PATH/db/$search.*) \
        $WAHOO_PATH/$target >/dev/null ^&1
        and echo (em)"$search succesfully installed."(off)
    end
  end
  reload
end

function WAHOO::cli::remove
  for pkg in $argv
    if not WAHOO::util::validate_package $pkg
      echo (bold)(line)(err)"$pkg is not a valid package/theme name"(off) 1^&2
      return $WAHOO_INVALID_ARG
    end

    if test -d $WAHOO_PATH/pkg/$pkg
      emit uninstall_$pkg
      rm -rf $WAHOO_PATH/pkg/$pkg
    else if test -d $WAHOO_PATH/themes/$pkg
      rm -rf $WAHOO_PATH/themes/$pkg
    end

    if test $status -eq 0
      echo (em)"$pkg succesfully removed."(off)
    else
      echo (bold)(line)(err)"$pkg could not be found"(off) 1^&2
    end
  end
  reload
end

function WAHOO::cli::submit
  set -l name $argv[1]
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

  if not WAHOO::util::validate_package $name
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
    WAHOO::util::fork_github_repo "$user" "bucaran/wahoo"
    git remote rm origin
    git remote add origin "https://github.com"/$user/wahoo
    git remote add upstream "https://github.com"/bucaran/wahoo
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

function WAHOO::cli::new -a option name
  switch $option
    case "p" "pkg" "pack" "packg" "package"
      set pkg "pkg"
    case "t" "th" "thm" "theme"
      set pkg "themes"
    case "*"
      echo (bold)(line)(err)"$option is not a valid option."(off) 1^&2
      return $WAHOO_INVALID_ARG
  end

  if not WAHOO::util::validate_package "$name"
    echo (bold)(line)(err)"$name is not a valid package/theme name"(off) 1^&2
    return $WAHOO_INVALID_ARG
  end

  if set -l dir (WAHOO::util::mkdir "$pkg/$name")
    cd $dir
    if test $pkg = "pkg"
      echo "function $name"\n"end"\n > "$dir/$name.fish"
    else
      cp "$WAHOO_PATH/themes/default/fish_prompt.fish" "$dir/fish_prompt.fish"
    end
    echo "# $name"\n > "$dir/README.md"
    echo (em)"Directory changed to "(line)"$dir"(off)
  else
    WAHOO::util::die $WAHOO_UNKNOWN_ERR \
      (bold)(line)(err)"\$WAHOO_CUSTOM and \$WAHOO_PATH undefined."(off)
  end
end

function WAHOO::util::validate_package
  set -l pkg $argv[1]
  for default in wahoo wa
    if test (echo "$pkg" | tr "[:upper:]" "[:lower:]") = $default
      return 1
    end
  end
  switch $pkg
    case {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}\*
      switch $pkg
        case "*/*" "* *" "*&*" "*\"*" "*!*" "*&*" "*%*" "*#*"
          return 1
      end
    case "*"
      return 1
  end
end

function WAHOO::util::fork_github_repo
  set -l user $argv[1]
  set -l repo $argv[2]

  curl -u "$user" --fail --silent \
    https://api.github.com/repos/$repo/forks \
    -d "{\"user\":\"$user\"}" >/dev/null
end

function WAHOO::util::sync_head
  set -l repo "origin"
  set -q argv[1]; and set repo $argv[1]

  git fetch origin master
  git reset --hard FETCH_HEAD
  git clean -df
end

function WAHOO::util::db
  for db in $WAHOO_PATH/db/*.$argv[1]
    basename $db .$argv[1]
  end
end

function WAHOO::util::list_themes
  set -l seen ""
  set -l theme (cat $WAHOO_CONFIG/theme)
  set -l regex "[[:<:]]($theme)[[:>:]]"
  test (uname) != "Darwin"; and set regex "\b($theme)\b"

  for theme in (basename $WAHOO_PATH/themes/* $WAHOO_CUSTOM/themes/*) \
  (WAHOO::util::db theme)
    contains $theme $seen; or echo $theme
    set seen $seen $theme
  end | column | sed -E "s/$regex/"(line)(bold)(em)"\1"(off)"/"
  set_color normal
end

function WAHOO::util::apply_theme
  echo $argv[1] > $WAHOO_CONFIG/theme
  reload
end

function WAHOO::util::mkdir -a name
  set -l name "$argv[1]"
  if test -d "$WAHOO_CUSTOM"
    set name "$WAHOO_CUSTOM/$name"
  else if test -d "$WAHOO_PATH"
    set name "$WAHOO_PATH/$name"
  end
  mkdir -p "$name"
  echo $name
end

function WAHOO::util::die -a error msg
  echo $msg 1^&2
  exit $error
end

function WAHOO::git::repo_is_clean
  git diff-index --quiet HEAD --
end