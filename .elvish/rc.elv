use epm
use re
use str

use github.com/zzamboni/elvish-completions/builtins
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/comp
use github.com/zzamboni/elvish-completions/ssh

epm:install &silent-if-installed=$true   ^
  github.com/zzamboni/elvish-modules     ^
  github.com/zzamboni/elvish-completions ^
  github.com/xiaq/edit.elv               ^
  github.com/iwoloschin/elvish-packages

use github.com/zzamboni/elvish-modules/bang-bang
use github.com/zzamboni/elvish-modules/dir
use github.com/zzamboni/elvish-modules/long-running-notifications
use github.com/zzamboni/elvish-modules/util

use github.com/xiaq/edit.elv/smart-matcher
smart-matcher:apply

use github.com/zzamboni/elvish-completions/git git-completions
# git-completions:git-command = hub
git-completions:init

# TODO: enable when fixed
use direnv

# python virtualenv
use github.com/iwoloschin/elvish-packages/python
set python:virtualenv-directory = $E:HOME/.virtualenvs
edit:add-var activate~ $python:activate~
edit:add-var deactivate~ $python:deactivate~
set edit:completion:arg-completer[activate] = $edit:completion:arg-completer[python:activate]
set E:VIRTUAL_ENV_DISABLE_PROMPT = "yes"

use github.com/zzamboni/elvish-modules/alias

alias:new grep rg

alias:new cat  bat
alias:new more bat --paging always
set E:BAT_CONFIG_PATH = ~/.batcfg
set E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"

alias:new rm   trash
alias:new rmm  rm

alias:new ls   lsd
alias:new l    lsd -a
alias:new ll   lsd -al
alias:new lt   lsd -a --tree --depth 3
alias:new ltd  lsd -a --tree

alias:new cd &use=[github.com/zzamboni/elvish-modules/dir] dir:cd

# delete words
set edit:insert:binding[Alt-Backspace] = { edit:kill-small-word-left }

# move your cursor around
set edit:insert:binding[Alt-Left] = { edit:move-dot-left-word }
set edit:insert:binding[Alt-Right] = { edit:move-dot-right-word }

# fuzzy-find
fn get_history_elvish {
  var h = [&]
  edit:command-history |
  each {|cmd|
    if (not (has-key $h $cmd[cmd])) {
      print $cmd[cmd]"\000"
      set h[$cmd[cmd]] = $true
    }
  }
}

fn fzf-select {
  fzf --no-sort --tac --read0 --info=hidden --query=$edit:current-command
}

fn history {|&hist_fn=$get_history_elvish~|
  var err = ?(set edit:current-command = ($hist_fn | fzf-select))
}

# history
set edit:insert:binding[Ctrl-t] = { history &hist_fn=$get_history_elvish~ </dev/tty >/dev/tty 2>&1 }

set edit:insert:binding[Ctrl-r] = {
  edit:histlist:start
  edit:histlist:toggle-case-sensitivity
}

fn is_readline_empty { 
  # Readline buffer contains only whitespace.
  re:match '^\s*$' $edit:current-command 
} 

set edit:insert:binding[Enter] = { 
  if (is_readline_empty) { 
    # If I hit Enter with an empty readline, it launches fzf with command history
    set edit:current-command = ' history'
    edit:smart-enter 
    # But you can do other things, e.g. ignore the keypress, or delete the unneeded whitespace from readline buffer
  } else {
    # If readline buffer contains non-whitespace character, accept the command. 
    edit:smart-enter 
  } 
}

# zoxide
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

set E:EDITOR = "subl -w"
set E:LC_ALL = "en_US.UTF-8"
set E:LESS = "-i -R"
set E:XDG_CACHE_HOME = "~/.cache"

set paths = [/opt/homebrew/bin $@paths]

keychain --quiet --nogui --inherit any-once --agents ssh --quick ~/.ssh/id_ed25519

set E:STARSHIP_CACHE = ~/.starship/cache
eval (starship init elvish) 2> /dev/null
