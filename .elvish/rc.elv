use epm
use re
use str

epm:install &silent-if-installed         ^
  github.com/zzamboni/elvish-modules     ^
  github.com/zzamboni/elvish-completions ^
  github.com/zzamboni/elvish-themes      ^
  github.com/xiaq/edit.elv               ^
  github.com/iwoloschin/elvish-packages

use github.com/zzamboni/elvish-modules/alias
use github.com/zzamboni/elvish-modules/bang-bang
use github.com/zzamboni/elvish-modules/dir
use github.com/zzamboni/elvish-modules/long-running-notifications
use github.com/zzamboni/elvish-modules/util

use github.com/zzamboni/elvish-completions/builtins
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/comp
use github.com/zzamboni/elvish-completions/ssh

use github.com/zzamboni/elvish-completions/git git-completions
#git-completions:git-command = hub
git-completions:init

alias:new cat bat
alias:new cd "use github.com/zzamboni/elvish-modules/dir; dir:cd"
alias:new cdb "use github.com/zzamboni/elvish-modules/dir; dir:cdb"
alias:new grep rg
alias:new ll "exa -alsnew"
alias:new ls exa
alias:new more "bat --paging always"

use github.com/iwoloschin/elvish-packages/python
python:virtualenv-directory = $E:HOME/.virtualenvs
edit:add-var activate~ $python:activate~
edit:add-var deactivate~ $python:deactivate~
edit:completion:arg-completer[activate] = $edit:completion:arg-completer[python:activate]

edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~
edit:insert:binding[Ctrl-Backspace] = $edit:kill-small-word-right~

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

use direnv

E:BAT_CONFIG_PATH = "$E:HOME/.batcfg"
E:DG_CACHE_HOME = "$E:HOME/.cache"
E:EDITOR = "subl -w"
E:LC_ALL = "en_US.UTF-8"
E:LESS = "-i -R"
E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
E:VIRTUAL_ENV_DISABLE_PROMPT = "yes"

keychain --quiet --nogui --inherit any-once --agents ssh --quick $E:HOME/.ssh/id_ed25519

eval (starship init elvish)
