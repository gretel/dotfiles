function wa_list_db_packages
  for item in (basename $WAHOO_PATH/db/pkg/*)
    contains $item (basename {$WAHOO_PATH,$WAHOO_CUSTOM}/pkg/*); or echo $item
  end
end