function wa_use
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
  echo $argv[1] > $WAHOO_CONFIG/theme
  reload
end
