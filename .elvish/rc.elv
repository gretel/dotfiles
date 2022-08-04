use epm
use path
use re
use str

epm:install &silent-if-installed=$true   ^
  github.com/zzamboni/elvish-modules     ^
  github.com/zzamboni/elvish-completions ^
  github.com/xiaq/edit.elv               ^
  github.com/iwoloschin/elvish-packages

use github.com/zzamboni/elvish-modules/alias
use github.com/zzamboni/elvish-modules/bang-bang
use github.com/zzamboni/elvish-modules/dir
use github.com/zzamboni/elvish-modules/util

use github.com/zzamboni/elvish-completions/builtins
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/comp

use github.com/zzamboni/elvish-completions/git git-completions
git-completions:init

use github.com/xiaq/edit.elv/smart-matcher
smart-matcher:apply

use github.com/zzamboni/elvish-modules/long-running-notifications
set long-running-notifications:never-notify = [
  bat
  less
  vi
]
set long-running-notifications:threshold = 20

fn have-external { |prog|
  put ?(which $prog >/dev/null 2>&1)
}
fn only-when-external { |prog lambda|
  if (have-external $prog) { $lambda }
}

set E:EDITOR = "subl -w"
set E:GOPATH = ~/go
set E:LC_ALL = "en_US.UTF-8"
set E:LESS = "-i -R"
set E:VIRTUAL_ENV_DISABLE_PROMPT = "yes"
set E:XDG_CACHE_HOME = "~/.cache"

# Optional paths, add only those that exist
var optpaths = [
  $E:GOPATH/bin
  /opt/homebrew/bin
  /Users/tom/.cargo/bin
]
var optpaths-filtered = [(each {|p|
    if (path:is-dir $p) { put $p }
} $optpaths)]

set paths = [
  ~/bin
  $@optpaths-filtered
  /usr/local/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  /usr/bin
  /bin
]

# local module
use direnv

# python virtualenv
use github.com/iwoloschin/elvish-packages/python

set python:virtualenv-directory = $E:HOME/.virtualenvs
edit:add-var activate~ $python:activate~
edit:add-var deactivate~ $python:deactivate~
set edit:completion:arg-completer[activate] = $edit:completion:arg-completer[python:activate]

alias:new ssh kitty +kitten ssh

only-when-external rg {
  alias:new grep rg
}

only-when-external bat {
  set E:BAT_CONFIG_PATH = ~/.batcfg
  set E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
  alias:new cat bat
  alias:new more bat --paging always
}

only-when-external trash {
  alias:new rm  trash
  alias:new rmm rm
}

only-when-external lsd {
  alias:new ls  lsd
  alias:new l   lsd -a
  alias:new ll  lsd -al
  alias:new lt  lsd -a --tree --depth 3
  alias:new ltd lsd -a --tree
}

# dir
set edit:insert:binding[Alt-b] = $dir:left-word-or-prev-dir~
set edit:insert:binding[Alt-f] = $dir:right-word-or-next-dir~
set edit:insert:binding[Alt-i] = $dir:history-chooser~

set edit:max-height = 30
set edit:prompt-stale-transform = {|x| styled $x "bright-black" }
set edit:-prompt-eagerness = 10

# delete small-word
set edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~

# delete the small-word under the cursor
# set edit:insert:binding[Alt-d] = $edit:kill-small-word-right~
# instant preview
# set edit:insert:binding[Alt-m] = $edit:-instant:start~

# move your cursor around
set edit:insert:binding[Alt-Left] = $edit:move-dot-left-word~
set edit:insert:binding[Alt-Right] = $edit:move-dot-right-word~

fn fzf_history {||
  if ( not (has-external "fzf") ) {
    edit:history:start
    return
  }
  var new-cmd = (
    edit:command-history &dedup &newest-first &cmd-only |
    to-terminated "\x00" |
    try {
      fzf --no-multi --height=30% --no-sort --read0 --info=hidden --exact --query=$edit:current-command | slurp
    } catch {
      edit:redraw &full=$true
      return
    }
  )
  edit:redraw &full=$true
  set edit:current-command = (str:trim-space $new-cmd)
}
set edit:insert:binding[Ctrl-t] = {|| fzf_history >/dev/tty 2>&1 }

fn is_readline_empty { 
  re:match '^\s*$' $edit:current-command 
} 

set edit:insert:binding[Enter] = { 
  if (is_readline_empty) { 
    set edit:current-command = 'fzf_history'
    edit:smart-enter 
  } else {
    edit:smart-enter 
  } 
} 

only-when-external carapace {
  eval (carapace _carapace|slurp)
}

set after-chdir = [{|dir| zoxide add (pwd -L) }]

fn _z_cd {|directory|
  cd $directory
}

fn zi {|@a|
  _z_cd (zoxide query -i -- $@a)
}

fn za {|@a| zoxide add $@a }
fn zq {|@a| zoxide query $@a }
fn zqi {|@a| zoxide query -i $@a }
fn zr {|@a| zoxide remove $@a }
fn zri {|@a|
  zoxide remove (zoxide query -i -- $@a)
}

fn z {|@a|
  if (is [] $@a) {
    _z_cd ~
  } else {
    # ok `z -` is not supported
    _z_cd (zoxide query -- $@a)
  }
}

only-when-external keychain {
  keychain --quiet --nogui --inherit any-once --agents ssh --quick ~/.ssh/id_ed25519
}

only-when-external starship {
  set E:STARSHIP_CACHE = ~/.starship/cache
  # eval (starship init elvish | sed 's/except/catch/')
  # Temporary fix for use of except in the output of the Starship init code
  eval (/usr/local/bin/starship init elvish --print-full-init | sed 's/except/catch/' | slurp)
}
