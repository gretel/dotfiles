function fish_prompt
  set -l code $status
  if test $code -ne 0
    set_color -o red
  else if test -d ".git"
    set_color -o blue
  else
    set_color -o green
  end
  echo (prompt_pwd)" -->> "(set_color normal)
end