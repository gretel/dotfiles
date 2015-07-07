function wa_list_installed_themes
  for item in (basename $WAHOO_PATH/themes/*)
    test $item = default; or echo $item
  end
end