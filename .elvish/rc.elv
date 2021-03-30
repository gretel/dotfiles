use epm
use re
use str

use github.com/zzamboni/elvish-completions/builtins
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/comp
use github.com/zzamboni/elvish-completions/ssh

epm:install &silent-if-installed         ^
  github.com/zzamboni/elvish-modules     ^
  github.com/zzamboni/elvish-completions ^
  github.com/xiaq/edit.elv               ^
  github.com/iwoloschin/elvish-packages

use github.com/zzamboni/elvish-modules/bang-bang
use github.com/zzamboni/elvish-modules/dir
use github.com/zzamboni/elvish-modules/long-running-notifications
use github.com/zzamboni/elvish-modules/util
util:electric-delimiters

use github.com/xiaq/edit.elv/smart-matcher
smart-matcher:apply

use github.com/zzamboni/elvish-completions/git git-completions
# git-completions:git-command = hub
git-completions:init

use direnv

# python virtualenv
use github.com/iwoloschin/elvish-packages/python
python:virtualenv-directory = $E:HOME/.virtualenvs
edit:add-var activate~ $python:activate~
edit:add-var deactivate~ $python:deactivate~
edit:completion:arg-completer[activate] = $edit:completion:arg-completer[python:activate]

use github.com/zzamboni/elvish-modules/alias

alias:new cd   'use github.com/zzamboni/elvish-modules/dir; dir:cd'
alias:new cdb  'use github.com/zzamboni/elvish-modules/dir; dir:cdb'

alias:new grep 'rg'

alias:new cat  'bat'
alias:new more 'bat --paging always'

alias:new rm   'trash -v'
alias:new rmm  'rm'

alias:new ls   'lsd'
alias:new l    'lsd -a'
alias:new ll   'lsd -al'
alias:new lt   'lsd -a --tree --depth 3'
alias:new ltd  'lsd -a --tree'

alias:new brew 'arch -arm64 brew'

# delete words
edit:insert:binding[Alt-Backspace] = { edit:kill-small-word-left }

# move your cursor around
edit:insert:binding[Alt-Left] = { edit:move-dot-left-word }
edit:insert:binding[Alt-Right] = { edit:move-dot-right-word }

# fuzzy-find
fn get_history_elvish {
  h = [&]
  edit:command-history |
  each [cmd]{
    if (not (has-key $h $cmd[cmd])) {
      print $cmd[cmd]"\000"
      h[$cmd[cmd]] = $true
    }
  }
}

fn fzf-select {
  fzf --no-sort --tac --read0 --info=hidden --query=$edit:current-command
}

fn history [&hist_fn=$get_history_elvish~]{
  err = ?(edit:current-command = ($hist_fn | fzf-select))
}

# history
edit:insert:binding[Ctrl-t] = { history &hist_fn=$get_history_elvish~ </dev/tty >/dev/tty 2>&1 }

edit:insert:binding[Ctrl-r] = {
  edit:histlist:start
  edit:histlist:toggle-case-sensitivity
}

# zoxide
after-chdir = [[dir]{ zoxide add (pwd -L) }]

fn _z_cd [directory]{
  cd $directory
}

fn zi [@a]{
  _z_cd (zoxide query -i -- $@a)
}

fn za [@a]{ zoxide add $@a }
fn zq [@a]{ zoxide query $@a }
fn zqi [@a]{ zoxide query -i $@a }
fn zr [@a]{ zoxide remove $@a }
fn zri [@a]{
  zoxide remove (zoxide query -i -- $@a)
}

fn z [@a]{
  if (is [] $@a) {
    _z_cd ~
  } else {
    # ok `z -` is not supported
    _z_cd (zoxide query -- $@a)
  }
}

E:BAT_CONFIG_PATH = ~/.batcfg
E:EDITOR = "subl -w"
E:LC_ALL = "en_US.UTF-8"
E:LESS = "-i -R"
E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
E:STARSHIP_CACHE = ~/.starship/cache
E:VIRTUAL_ENV_DISABLE_PROMPT = "yes"
E:XDG_CACHE_HOME = ~/.cache

keychain --quiet --nogui --inherit any-once --agents ssh --quick ~/.ssh/id_ed25519

eval (starship init elvish)
