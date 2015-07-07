set -g WAHOO_PATH $HOME/.wahoo
set -g WAHOO_CUSTOM $HOME/.dotfiles
source $WAHOO_PATH/init.fish

set -Ux DOMAIN (hostname -s)
set -Ux HOSTNAME (hostname)
set -gx UID (id -u $USER)
