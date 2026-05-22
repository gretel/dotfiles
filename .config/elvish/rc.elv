# jitter (code@jitter.eu) - based on https://github.com/zzamboni/dot-elvish/blob/master/rc.org

use epm
use path

epm:install &silent-if-installed=$true ^
	github.com/zzamboni/elvish-completions ^
	github.com/zzamboni/elvish-modules

use github.com/zzamboni/elvish-modules/alias
use github.com/zzamboni/elvish-modules/terminal-title
use github.com/zzamboni/elvish-modules/tty

use github.com/zzamboni/elvish-modules/dir
alias:new cd &use=[github.com/zzamboni/elvish-modules/dir] dir:cd
alias:new cdb &use=[github.com/zzamboni/elvish-modules/dir] dir:cdb

use github.com/zzamboni/elvish-modules/long-running-notifications
set long-running-notifications:never-notify = [ bash bat fzf less pi ssh subl tail tmux tspin vi zellij ]
set long-running-notifications:threshold = 30

use github.com/zzamboni/elvish-modules/git-summary gs
set gs:stop-gitstatusd-after-use = $true

use github.com/zzamboni/elvish-modules/util-edit
util-edit:electric-delimiters

set edit:max-height = 30
set edit:-prompt-eagerness = 10
set edit:prompt-stale-transform = {|x| styled $x "bright-black" }

# delete small-word
set edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~

# move your cursor around
set edit:insert:binding[Alt-Left] = $edit:move-dot-left-word~
set edit:insert:binding[Alt-Right] = $edit:move-dot-right-word~
set edit:insert:binding[Alt-b] = $dir:left-small-word-or-prev-dir~
set edit:insert:binding[Alt-f] = $dir:right-small-word-or-next-dir~

fn have-external { |prog|
	put ?(which $prog >/dev/null 2>&1)
}

fn only-when-external { |prog lambda|
	if (have-external $prog) { $lambda }
}

# # Convert POSIX env assignments to Elvish
# fn read-posix-envvars {
# 	each {|l|
# 		var _ key val = (re:split &max=3 '[ =]' $l)
# 		set val = (re:replace '^"' '' (re:replace '"$' '' $val))
# 		set-env $key $val
# 	}
# }

# Filter the command history through the fzf program. This is normally bound
# to Ctrl-R.
fn fzf_history {
	var new-cmd = (
		edit:command-history &dedup &newest-first &cmd-only |
		to-terminated "\x00" |
		try {
			fzf --no-sort --read0 --info=hidden --exact ^
			--query=$edit:current-command
		} catch {
			# If the user presses [Escape] to cancel the fzf operation it will exit
			# with a non-zero status. Ignore that we ran this function in that case.
			return
		}
	)
	set edit:current-command = $new-cmd
}

only-when-external fzf {
	set edit:insert:binding[Ctrl-R] = { fzf_history >/dev/tty 2>&1 }
}

# local environment
set E:SHELL = "elvish"
set E:EDITOR = "subl -w"
set E:LC_ALL = "en_US.UTF-8"
set E:LESS = "-i -R"
set E:SSH_AUTH_SOCK = $E:HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
set E:VIRTUAL_ENV_DISABLE_PROMPT = "yes"
set E:XDG_CONFIG_HOME = $E:HOME/.config
set E:XDG_CACHE_HOME = $E:HOME/.cache

# local "exports"
var optpaths = [
	$E:HOME/bin
	$E:HOME/.local/bin
	$E:HOME/.cargo/bin
	$E:PNPM_HOME/bin
	/opt/homebrew/bin  # macos
	/opt/homebrew/sbin # macos
]
var optpaths-filtered = [(each {|p|
	if (path:is-dir $p) { put $p }
} $optpaths)]

set paths = [
	$@optpaths-filtered
	/usr/local/bin
	/usr/sbin
	/sbin
	/usr/bin
	/bin
]

each {|p|
	if (not (path:is-dir &follow-symlink $p)) {
		echo (styled "Warning: directory "$p" in $paths no longer exists." red)
	}
} $paths

only-when-external bat {
	set E:BAT_CONFIG_PATH = $E:HOME/.batcfg
	set E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
	alias:new cat  bat
	alias:new more bat --paging always
}

only-when-external batcat {
	alias:new cat batcat
	alias:new more batcat --paging always
	#set E:MANPAGER = "sh -c 'col -bx | batcat -l man -p'"
}

only-when-external fd {
	set E:FZF_DEFAULT_COMMAND = 'fd --color=always --type file --strip-cwd-prefix --follow --hidden --exclude .git'
	set E:FZF_DEFAULT_OPTS = '--ansi'
	alias:new find fd
}

only-when-external lsd {
	alias:new ls  lsd
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

only-when-external zoxide {
	eval (zoxide init elvish | slurp)	
}

# Enable the universal command completer if available.
# See https://github.com/rsteube/carapace-bin
only-when-external carapace {
	eval (carapace _carapace elvish | slurp)
}

# https://mise.jdx.dev/installing-mise.html#elvish
var mise: = (ns [&])
eval (mise activate elvish | slurp) &ns=$mise: &on-end={|ns| set mise: = $ns }
mise:activate
edit:add-var mise~ {|@args| mise:mise $@args }

# https://direnv.net/docs/hook.html#elvish-012
use direnv

use github.com/zzamboni/elvish-themes/chain
chain:init

# if (have-external starship) {
#   set E:STARSHIP_CACHE = $E:HOME/.starship/cache
#   eval (starship init elvish --print-full-init | slurp)
# }

# # https://www.funtoo.org/Funtoo:Keychain
# only-when-external keychain {
# 	keychain --quiet --nogui --ssh-allow-forwarded --quick $E:HOME/.ssh/id_ed25519
# }
