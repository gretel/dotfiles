function wa_list_themes
  set -l seen ""
  for theme in (basename $WAHOO_PATH/db/themes/*) \
  (basename {$WAHOO_PATH,$WAHOO_CUSTOM}/themes/*)
    contains $theme $seen; or echo $theme
    set seen $seen $theme
  end
end
