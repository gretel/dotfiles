# osx-specific fish shell configuration https://gist.github.com/gretel/0bb5f77cdc54182c15dd

### local configuration (not in git)
source "$HOME/.config/fish/local.fish"

### pyenv
# source (pyenv init - | psub)
# source (pyenv virtualenv-init - | psub)

####
eval (direnv hook fish)
eval (direnv stdlib)

if status --is-interactive

  ### fzf
  source /usr/local/Cellar/fzf/**/shell/key-bindings.fish

  ### hub
  # eval (hub alias -s)

  ### thefuck
  eval (thefuck --alias | tr '\n' ';')

  ### keychain
  eval (keychain --eval --quick --dir $HOME/.keychain --inherit any --agents gpg,ssh $SSH_KEYS $GPG_KEYS)
  set -x SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent

end
