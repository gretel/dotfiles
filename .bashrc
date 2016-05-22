#

set -o posix
set -b

### fasd
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" ] || [ ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
# shellcheck source=/dev/null
source "$fasd_cache"
unset fasd_cache

### prompt
# shellcheck source=/dev/null
source "$HOME/.bash_prompt"

### pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

### direnv
eval "$(direnv hook bash)"

### aliases
alias "j=z"
alias "jj=zz"
alias "ls=exa"
alias "l=exa -a -lgmH"
alias "la=l -@"
alias "ll=l -h"
