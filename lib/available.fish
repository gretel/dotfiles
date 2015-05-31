function available -a program -d "Check if a program is available."
  type "$program" ^/dev/null >&2
end