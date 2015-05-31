function fish_prompt
  set -e fish_greeting
  set -l code $status
  set -l prompt (prompt_pwd)
  echo "$prompt "(begin
    if test $code -ne 0
      set_color -o red
    else if test -d ".git"
      set_color -o blue
    else
      set_color -o green
    end
  end)"$color -->> "(set_color normal)
end