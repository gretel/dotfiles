function wa_use
  if not test -e $WAHOO_CUSTOM/themes/$argv[1]
    if not test -e $WAHOO_PATH/themes/$argv[1]
      set -l theme $WAHOO_PATH/db/themes/$argv[1]
      if test -e $theme
        echo (wa::em)"Downloading $argv[1] theme..."(wa::off)
        git clone (cat $theme) $WAHOO_PATH/themes/$argv[1] >/dev/null ^&1
          and echo (wa::em)"$argv[1] theme downloaded."(wa::off)
          or return $WAHOO_UNKNOWN_ERR
      else
        echo (wa::err)"$argv[1] is not a valid theme"(wa::off) 1^&2
        return $WAHOO_INVALID_ARG
      end
    end
  end
  echo "$argv[1]" > $WAHOO_CONFIG/theme
  refresh
end
