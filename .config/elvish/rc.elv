use epm
use path

epm:install &silent-if-installed=$true ^
  github.com/zzamboni/elvish-modules

use github.com/zzamboni/elvish-modules/alias
use github.com/zzamboni/elvish-modules/long-running-notifications

set long-running-notifications:never-notify = [ bash bat less subl tail tmux tspin vi zellij ]
set long-running-notifications:threshold = 30

set edit:max-height = 30
set edit:-prompt-eagerness = 10
# delete small-word
set edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~
# move your cursor around
set edit:insert:binding[Alt-Left] = $edit:move-dot-left-word~
set edit:insert:binding[Alt-Right] = $edit:move-dot-right-word~

fn history {
  tmp E:SHELL = 'elvish'
  var key line @ignored = (str:split "\x00" (
    edit:command-history &dedup &newest-first |
    each {|cmd| printf "%s %s\x00" $cmd[id] $cmd[cmd] } |
    try {
      fzf --no-multi --no-sort --read0 --print0 --info-command="print History" ^
      --scheme=history --expect=tab,ctrl-d --border=rounded --exact ^
      --bind 'down:transform:if (<= $E:FZF_POS 1) { print abort } else { print down }' ^
      --query=$edit:current-command | slurp
    } catch {
      edit:redraw &full=$true
      return
    }
  ))
  edit:redraw &full=$true
  var id command = (str:split &max=2 ' ' $line)
  if (eq $key 'ctrl-d') {
    store:del-cmd $id
    edit:notify 'Deleted '$id
  } else {
    edit:replace-input $command

    if (not-eq $key 'tab') {
      edit:return-line
    }
  }
}

fn have-external { |prog|
  put ?(which $prog >/dev/null 2>&1)
}
fn only-when-external { |prog lambda|
  if (have-external $prog) { $lambda }
}

# local environment
set E:EDITOR = "subl -w"
set E:GOPATH = $E:HOME/go
set E:LC_ALL = "en_US.UTF-8"
set E:LESS = "-i -R"
set E:VIRTUAL_ENV_DISABLE_PROMPT = "yes"
set E:XDG_CACHE_HOME = $E:HOME/.cache

# local "exports"
var optpaths = [
  $E:GOPATH/bin
  $E:HOME/bin
  $E:HOME/.cargo/bin
  $E:HOME/.kelp/bin  # macos
  /opt/homebrew/bin  # macos
  /opt/homebrew/sbin # macos
]
var optpaths-filtered = [(each {|p|
    if (path:is-dir $p) { put $p }
} $optpaths)]
set paths = [
  $@optpaths-filtered
  /usr/local/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  /usr/bin
  /bin
]

only-when-external bat {
  set E:BAT_CONFIG_PATH = $E:HOME/.batcfg
  set E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
  alias:new cat  bat
  alias:new more bat --paging always
}

only-when-external carapace {
  set-env CARAPACE_BRIDGES 'bash'
  eval (carapace _carapace | slurp)
}

only-when-external lsd {
  #alias:new ls  lsd
  alias:new l   lsd -a
  alias:new ll  lsd -al
  alias:new lt  lsd -a --tree --depth 3
  alias:new ltd lsd -a --tree
}

only-when-external rg {
  alias:new grep rg
}

only-when-external trash {
  alias:new rm  trash
  alias:new rmm rm
}

only-when-external tspin {
  alias:new tail tspin
}

only-when-external wezterm {
  eval (wezterm shell-completion --shell elvish|slurp)
  alias:new wez    wezterm
  alias:new wezssh wezterm ssh
  alias:new wezser wezterm serial
  alias:new wezcon wezterm connect
  alias:new wezrec wezterm record
  alias:new wezls  wezterm cli list
  alias:new wezadd wezterm cli spawn --
}

only-when-external zellij {
  eval (zellij setup --generate-completion elvish|slurp)
  alias:new zj   zellij
  alias:new zja  zellij action
  alias:new zje  zellij edit             
  alias:new zjef zellij edit --floating
  alias:new zjr  zellij run --
  alias:new zjrf zellij run --floating --
}

eval (zoxide init elvish | slurp)

# https://mise.jdx.dev/installing-mise.html#elvish
var mise: = (ns [&])
eval (mise activate elvish | slurp) &ns=$mise: &on-end={|ns| set mise: = $ns }
mise:activate
edit:add-var mise~ {|@args| mise:mise $@args }

# https://direnv.net/docs/hook.html#elvish-012
use direnv

# starship or chains
if (have-external starship) {
  set E:STARSHIP_CACHE = $E:HOME/.starship/cache
  eval (starship init elvish --print-full-init | slurp)
} else {
  use github.com/zzamboni/elvish-themes/chain
  set edit:prompt-stale-transform = {|x| styled $x "bright-black" }
  chain:init
}

# https://www.funtoo.org/Funtoo:Keychain
# only-when-external keychain {
#   keychain --quiet --nogui --ssh-allow-forwarded --quick $E:HOME/.ssh/id_ed25519
# }
