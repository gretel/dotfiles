function fish_prompt
  set -l code $status
  echo (prompt_pwd)" "(begin
    if test $code -ne 0
      set_color -o red
    else if test -d ".git"
      set_color -o blue
    else
      set_color -o green
    end
  end)"$color»» "(set_color normal)
end