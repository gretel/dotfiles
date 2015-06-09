function wa_list_local_packages
  for item in (basename {$WAHOO_PATH,$WAHOO_CUSTOM}/pkg/*)
    test $item = wa; or echo $item
  end
end