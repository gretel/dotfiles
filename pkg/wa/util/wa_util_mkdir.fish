function wa_util_mkdir -a name
  set -l name "$argv[1]"
  if test -d "$WAHOO_CUSTOM"
    set name "$WAHOO_CUSTOM/$name"
  else if test -d "$WAHOO_PATH"
    set name "$WAHOO_PATH/$name"
  end
  mkdir -p "$name"
  echo $name
end