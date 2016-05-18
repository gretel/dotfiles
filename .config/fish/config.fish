# osx-specific fish shell configuration https://gist.github.com/gretel/0bb5f77cdc54182c15dd
# $ brew update; brew install chruby chruby-fish direnv hub fasd fzf keychain pyenv thefuck

# my personal ssh keys on the chain
set ssh_keys $HOME/.ssh/id_rsa $HOME/.ssh/github;
set gpg_keys 640F9BDD;

set -x BROWSER 'open';
# set -x EDITOR 'atom -n';
set -x EDITOR 'subl -w -n';
set -x VISUAL 'subl -n';

set -x PIP_DOWNLOAD_CACHE $HOME/.cache/pip;
# set -x PIP_REQUIRE_VIRTUALENV 1;
set -x PYENV_ROOT $HOME/.pyenv;
set -x PYENV_SHELL fish;
set -x PYENV_VIRTUALENV_CACHE_PATH $HOME/.cache/pyenv;
set -x VIRTUALENV_DISTRIBUTE 1;
set -x WORKON_HOME $HOME/.pyenv;

# set -x PATH $PATH $PYENV_ROOT/bin;

source (pyenv init - | psub)
source (pyenv virtualenv-init - | psub)

# # fried ruby, hmm
# source /usr/local/opt/fry/share/fry/fry.fish

# direnv last so chruby and pyenv will have stuff set
eval (direnv hook fish)

# automation does need no userland fooshizzle
if status --is-interactive

  # fzf for history fuzzines
  source /usr/local/Cellar/fzf/**/shell/key-bindings.fish

  # hub for git
  eval (hub alias -s)

  # thefuck for the mess we type
  eval (thefuck --alias | tr '\n' ';')

  # keychain for ssh and gpg2
  eval (keychain --eval --dir $HOME/.keychain --inherit any-once --agents gpg,ssh $ssh_keys $gpg_keys)
  set -x SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent

  function j
    cd (command fasd -d -e 'printf %s' "$argv")
  end

  alias "l"  "exa -a -lgHhm"
  alias "le" "exa -a -lgHhm -s extension"
  alias "ll" "l"
  alias "lm" "exa -a -lgHh -s modified -uUm"
  alias "lr" "exa -a -lgHm -R -L 2"
  alias "ls" "exa"
  alias "lt" "exa -a -lgHm -R -T -L 2"
  alias "tree" "exa -a -lgHm -R -T"

end
