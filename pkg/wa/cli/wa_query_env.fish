function wa_query_env
  if not set -q argv[1]
    for var in (set)
      echo (wa::dim)(echo $var | awk '{ printf $1"\n"; }')(wa::off)
      echo (wa::em)(echo $var | awk '{$1=""; print $0}')(wa::off)
    end
  else
    set path $argv[1]
    printf "%s\n" $$path   \
    | sed "s|$HOME|"(wa::em)"~"(wa::off)"|g" \
    | sed "s|/|"(wa::em)"/"(wa::off)"|g"
  end
end