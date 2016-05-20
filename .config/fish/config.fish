# https://gist.github.com/gretel/0bb5f77cdc54182c15dd

### local configuration (not in git)
source $HOME/.config/fish/local.fish

### disable greeting
set -e fish_greeting

### pyenv
# source (pyenv init - | psub)
# source (pyenv virtualenv-init - | psub)

if status --is-interactive

  ### fzf
  source /usr/local/Cellar/fzf/**/shell/key-bindings.fish

  ### hub
  # eval (hub alias -s)

  ### thefuck
  eval (thefuck --alias | tr '\n' ';')

  ### keychain
  keychain --quick --quiet --timeout 3600 --inherit any --confhost --agents ssh,gpg $SSH_KEYS $GPG_KEYS
  source $HOME/.keychain/(hostname)-fish
  source $HOME/.keychain/(hostname)-fish-gpg
  # set -x SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent

end

### direnv
eval (direnv hook fish)
