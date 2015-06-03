function wa_get_package
  for search in $argv
    if test -e $WAHOO_PATH/db/pkg/$search
      set target pkg/$search
    else if test -e $WAHOO_PATH/db/themes/$search
      set target themes/$search
    else
      echo (bold)(line)(err)"$search is not a valid package/theme"(off) 1^&2
      continue
    end

    if test -e $WAHOO_PATH/$target
      echo (bold)"Updating $search..."(off)
      pushd $WAHOO_PATH/$target
      wa_util_sync "origin" >/dev/null ^&1
      popd
      echo (em)"✔ $search up to date."(off)
    else
      echo (bold)"Installing $search..."(off)
      git clone (cat $WAHOO_PATH/db/$target) $WAHOO_PATH/$target >/dev/null ^&1
        and echo (em)"✔ $search succesfully installed."(off)
    end
  end
  refresh
end