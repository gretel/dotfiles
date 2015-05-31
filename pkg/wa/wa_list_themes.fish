function wa_list_themes
  set -l seen ""
  for theme in \
  (basename {$WAHOO_PATH,$WAHOO_CUSTOM}/themes/*) \
  (basename -s .theme $WAHOO_PATH/db/*.theme)
    contains $theme $seen; or echo $theme
    set seen $seen $theme
  end
end
