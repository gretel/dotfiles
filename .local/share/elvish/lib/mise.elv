var hook-enabled = $false

fn hook-env {
  if $hook-enabled {
    eval (/opt/homebrew/bin/mise hook-env -s elvish | slurp)
  }
}

set after-chdir = (conj $after-chdir {|_| hook-env })
set edit:before-readline = (conj $edit:before-readline $hook-env~)

fn activate {
  set-env MISE_SHELL elvish
  set hook-enabled = $true
  hook-env
}

fn deactivate {
  set hook-enabled = $false
  eval (/opt/homebrew/bin/mise deactivate | slurp)
}

fn mise {|@a|
  if (== (count $a) 0) {
    /opt/homebrew/bin/mise
    return
  }

  if (not (or (has-value $a -h) (has-value $a --help))) {
    var command = $a[0]
    if (==s $command shell) {
      try { eval (/opt/homebrew/bin/mise $@a) } catch { }
      return
    } elif (==s $command deactivate) {
      deactivate
      return
    } elif (==s $command activate) {
      activate
      return
    }
  }
  /opt/homebrew/bin/mise $@a
}
