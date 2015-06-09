function wa_remove_package
  for pkg in $argv
    if not wa_util_valid_package $pkg
      if test $pkg = "wa"
        echo (wa::err)"You can't remove wa"(wa::off) 1^&2
      else
        echo (wa::err)"$pkg is not a valid package/theme name"(wa::off) 1^&2
      end
      return $WAHOO_INVALID_ARG
    end

    if test -d $WAHOO_PATH/pkg/$pkg
      emit uninstall_$pkg
      rm -rf $WAHOO_PATH/pkg/$pkg
    else if test -d $WAHOO_PATH/themes/$pkg
      if test $pkg = default
        echo (wa::err)"You can't remove the default theme"(wa::off) 1^&2
        return $WAHOO_INVALID_ARG
      end
      if test $pkg = (cat $WAHOO_CONFIG/theme)
        wa_use "default"
      end
      rm -rf $WAHOO_PATH/themes/$pkg
    end
    if test $status -eq 0
      echo (wa::em)"$pkg succesfully removed."(wa::off)
    else
      echo (wa::err)"$pkg could not be found"(wa::off) 1^&2
    end
  end
  refresh
end