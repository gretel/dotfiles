use epm
use re
use str

epm:install &silent-if-installed         ^
  github.com/zzamboni/elvish-modules     ^
  github.com/zzamboni/elvish-completions ^
  github.com/zzamboni/elvish-themes      ^
  github.com/xiaq/edit.elv               ^
  github.com/iwoloschin/elvish-packages

use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/ssh
use github.com/zzamboni/elvish-completions/builtins

use github.com/zzamboni/elvish-completions/git git-completions
#git-completions:git-command = hub
git-completions:init

use github.com/zzamboni/elvish-modules/util
use github.com/zzamboni/elvish-modules/dir
use github.com/zzamboni/elvish-modules/long-running-notifications
use github.com/zzamboni/elvish-modules/bang-bang

use github.com/iwoloschin/elvish-packages/python

# TODO
python:virtualenv-directory = ./minibig_venv

use github.com/zzamboni/elvish-themes/chain
chain:bold-prompt = $false

chain:segment-style = [
  &dir=          session
  &chain=        session
  &arrow=        session
  &git-combined= session
  &git-repo=     bright-blue
]

chain:glyph[arrow]  = "|>"
chain:show-last-chain = $false

# TODO
fn ls [@_args]{
  use github.com/zzamboni/elvish-modules/util
  e:exa --color-scale --git --group-directories-first (each [o]{
      util:cond [
        { eq $o "-lrt" }  "-lsnew"
        { eq $o "-lrta" } "-alsnew"
        :else $o
      ]
  } $_args)
}

use github.com/zzamboni/elvish-modules/alias

alias:new cd "use github.com/zzamboni/elvish-modules/dir; dir:cd"
alias:new cdb "use github.com/zzamboni/elvish-modules/dir; dir:cdb"
alias:new cat bat
alias:new ls exa
alias:new ll "exa -alsnew"
alias:new more "bat --paging always"

edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~
#edit:insert:binding[Shift-Backspace] = $edit:kill-small-word-right~

use github.com/zzamboni/elvish-modules/dir

edit:insert:binding[Alt-b] = $dir:left-word-or-prev-dir~
edit:insert:binding[Alt-f] = $dir:right-word-or-next-dir~
edit:insert:binding[Alt-i] = $dir:history-chooser~

edit:insert:binding[Ctrl-R] = {
  edit:histlist:start
  edit:histlist:toggle-case-sensitivity
}

util:electric-delimiters

use github.com/iwoloschin/elvish-packages/update
update:curl-timeout = 3
update:check-commit &verbose

E:LESS = "-i -R"

E:EDITOR = "subl -w"

E:LC_ALL = "en_US.UTF-8"
