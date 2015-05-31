function reload -d "Reload the fishshell session."
  exec fish < /dev/tty >/dev/null
end