function wa_remove_package
  for pkg in $argv
    if not wa_util_valid_package $pkg
      if test $pkg = "wa"
        echo (bold)(line)(err)"You can't remove wa"(off) 1^&2
      else
        echo (bold)(line)(err)"$pkg is not a valid package/theme name"(off) 1^&2
      end
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