function wa_query_env
  function __wa_print_pretty_path -a path
    printf "%s\n" $path   \
    | sed "s|$HOME|"(wa::em)"~"(wa::off)"|g" \
    | sed "s|/|"(wa::em)"/"(wa::off)"|g"
  end
  if not set -q argv[1]
    for var in (set)
      echo (wa::dim)(echo $var | awk '{ printf $1"\n"; }')(wa::off)
      echo (wa::em)(__wa_print_pretty_path (echo $var | awk '{$1=""; print $0}'))(wa::off)
    end
  else
    for key in $$argv[1]
      __wa_print_pretty_path $key
    end
  end
end
