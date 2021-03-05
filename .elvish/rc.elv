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
  github.com/zzamboni/elvish-themes      ^
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

use github.com/iwoloschin/elvish-packages/python

python:virtualenv-directory = $E:HOME/.virtualenvs

edit:add-var activate~ $python:activate~
edit:add-var deactivate~ $python:deactivate~

edit:completion:arg-completer[activate] = $edit:completion:arg-completer[python:activate]

edit:insert:binding[Alt-b] = $dir:left-word-or-prev-dir~
edit:insert:binding[Alt-f] = $dir:right-word-or-next-dir~
edit:insert:binding[Alt-i] = $dir:history-chooser~

edit:insert:binding[Ctrl-r] = {
  edit:histlist:start
  edit:histlist:toggle-case-sensitivity
}

edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~
edit:insert:binding[Ctrl-Backspace] = $edit:kill-small-word-right~

# use direnv

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

# use github.com/zzamboni/elvish-themes/chain
# chain:bold-prompt = $false
# chain:glyph[arrow]  = "|>"
# chain:show-last-chain = $false
# chain:segment-style = [
#   &dir=          session
#   &chain=        session
#   &arrow=        session
#   &git-combined= session
#   &git-repo=     bright-blue
# ]
# edit:prompt-stale-transform = [x]{ styled $x "bright-black" }
# edit:-prompt-eagerness = 10

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
