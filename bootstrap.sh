#!/bin/sh
#
# Install dependencies and setup Wahoo.
#
# USAGE
#   ./bootstrap.sh
#   curl git.io/wa | sh
#
# ENV
#   CI          Bootstrap is running in a CI environment.
#   BASE        Install root. $HOME by default.
#   CUSTOM      User custom path. $BASE/.dotfiles by default.
#   PROTOCOL    https by default.
#   HOST        github.com by default.
#   REPO        bucaran/wahoo by default.
#   BRANCH      master by default.
#
# API
#   util_ink
#   util_log
#   util_log_default_success
#   util_log_default_error
#   util_display_success_msg
#   util_env_can
#   util_env_osx
#   util_env_swap_process
#   lib_fish_install
#   lib_fish_set_as_default_shell
#   lib_fish_create_config
#   lib_git_install
#   lib_autoconf_install
#   lib_wahoo_install
#   lib_main_run

util_ink() {
  if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
    echo "Usage: util_ink <color> <text>"
    echo "Colors:"
    echo "  black, white, red, green, yellow, blue, purple, cyan, gray"
    return 1
  fi

  local open="\033["
  local close="${open}0m"
  local black="0;30m"
  local red="1;31m"
  local green="1;32m"
  local yellow="1;33m"
  local blue="1;34m"
  local purple="1;35m"
  local cyan="1;36m"
  local gray="0;37m"
  local white="$close"

  local text="$1"
  local color="$close"

  if [ "$#" -eq 2 ]; then
    text="$2"
    case "$1" in
      black | red | green | yellow | \
      blue | purple | cyan | gray | white)
        eval color="\$$1"
        ;;
    esac
  fi

  printf "${open}${color}${text}${close}"
}

util_log() {
  if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
    echo "Usage: ink <fmt> <msg>"
    echo "Formatting Options:"
    echo "  TITLE, ERROR, WARN, INFO, SUCCESS"
    return 1
  fi

  local color=
  local text="$2"

  case "$1" in
    TITLE)
      color=yellow
      ;;
    ERROR | WARN)
      color=red
      ;;
    INFO)
      color=green
      ;;
    SUCCESS)
      color=green
      ;;
    *)
      text="$1"
  esac

  timestamp() {
    util_ink gray "["
    util_ink purple "$(date +%H:%M:%S)"
    util_ink gray "] "
  }

  timestamp; util_ink "$color" "$text"; echo
}

util_log_default_success() {
  util_log INFO "$1 successfully installed."
}

util_log_default_error() {
  util_log ERROR "You need admin permissions to continue."
}

util_display_success_msg() {
  echo
  util_ink yellow  " __      __        .__                   "; echo
  util_ink cyan    "/  \    /  \_____  |  |__   ____   ____  "; echo
  util_ink yellow  "\   \/\/   /\__  \ |  |  \ /  _ \ /  _ \ "; echo
  util_ink cyan    " \        /  / __ \|   Y  (  <_> |  <_> )"; echo
  util_ink yellow  "  \__/\  /  (____  /___|  /\____/ \____/ "; echo
  util_ink cyan    "       \/        \/     \/   "
  echo;echo
}

util_env_can() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: util_env_can <program>"
    exit 1
  fi
  type "$1" >/dev/null 2>&1
}

util_env_osx() {
  [ "$(uname)" = "Darwin" ]
}

util_env_swap_process() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: util_env_swap_process <process>"
    exit 1
  fi
  exec "$1" < /dev/tty
}

lib_fish_install() {
  local FISH_SOURCE="src/fish"
  local FISH_REMOTE="https://github.com/fish-shell/fish-shell"

  installer_linux_run() {
    if util_env_can "apt-get"; then
      sudo apt-get -y install autoconf build-essential \
        ncurses-dev libncurses5-dev gettext
    elif util_env_can "yum"; then
      sudo yum -y install ncurses-devel
    fi

    mkdir -p "${HOME}/src"
    git clone $FISH_REMOTE "${HOME}/${FISH_SOURCE}"
    cd "${HOME}/${FISH_SOURCE}"
    autoconf
    ./configure --without-xsel
    make
    sudo make install
  }

  installer_darwin_run() {
    git clone $FISH_REMOTE "${HOME}/${FISH_SOURCE}"
    cd "${HOME}/${FISH_SOURCE}"
    sudo xcodebuild install
    ditto /tmp/fish.dst /
  }

  if ! util_env_can git; then
    util_log INFO "Installing git..."
    if lib_git_install; then
      util_log_default_success "git"
    else
      util_log ERROR "You need admin permissions to install git"
      exit 1
    fi
  fi

  if util_env_osx; then
    if util_env_can "brew"; then
      brew install fish
    elif util_env_can "xcodebuild"; then
      if installer_darwin_run; then
        util_log_default_success "fish"
      else
        util_log_default_error
        exit 1
      fi
    else
      util_log ERROR "You need Homebrew or Xcode tools."
      util_log INFO "For Xcode try: xcode-select --install"
      exit 1
    fi
  else
    if ! util_env_can "autoconf"; then
      util_log INFO "Installing autoconf..."
      if lib_autoconf_install; then
        util_log_default_success "autoconf"
      else
        util_log_default_error
        exit 1
      fi
    fi

    if installer_linux_run; then
      util_log_default_success "fish"
    else
      util_log_default_error
      exit 1
    fi
  fi
}

lib_fish_create_config() {
  local FISH_CONFIG="${HOME}/.config/fish"
  mkdir -p "${FISH_CONFIG}"
  touch "${FISH_CONFIG}/config.fish"
}

lib_fish_set_as_default_shell() {
  local BIN="/usr/local/bin"
  echo "${BIN}/fish" | sudo tee -a /etc/shells
  chsh -s "${BIN}/fish"
}

lib_git_install() {
  if util_env_osx; then
    alias git="xcrun git"
  else
    if util_env_can "apt-get"; then
      sudo apt-get -y install git
    elif util_env_can "yum"; then
      sudo yum -y install git
    fi
  fi
}

lib_autoconf_install() {
  if util_env_can "apt-get"; then
    sudo apt-get -y install autoconf
  elif util_env_can "yum"; then
    sudo yum -y install autoconf
  fi
}

lib_wahoo_install() {
  if [ -z ${BASE+_} ]; then
    BASE="${HOME}"
  fi

  util_log INFO "Resolving Wahoo path → ${BASE}/.wahoo"

  if [ -d "${BASE}/.wahoo" ]; then
    util_log ERROR "Wahoo is already installed."
    util_log INFO "If you want to update Wahoo try: 'fish update'"
    exit 1
  fi

  if [ -z ${PROTOCOL+_} ]; then
    PROTOCOL="https"
  fi

  if [ -z ${HOST+_} ]; then
    HOST="github.com"
  fi

  if [ -z ${REPO+_} ]; then
    REPO="bucaran/wahoo"
  fi

  if [ -z ${BRANCH+_} ]; then
    BRANCH="master"
  fi

  URL="${PROTOCOL}://${HOST}/${REPO}.git"

  util_log INFO "Cloning Wahoo from ${URL}"
  if ! git clone -b "${BRANCH}" "${URL}" "${BASE}/.wahoo"; then
    uti_log ERROR "git could not clone the repo ${BASE}/.wahoo:${BRANCH}"
    uti_log INFO "Check your environment and try again"
    exit 1
  fi

  ## CONFIGURATION ##

  if [ -z ${FISH_CONFIG+_} ]; then
    FISH_CONFIG="${HOME}/.config/fish"
  fi

  INIT="init.fish"
  util_log INFO "Looking for a previous fish configuration..."

  if [ -e "${FISH_CONFIG}/config.fish" ]; then
    util_log INFO "Found ${FISH_CONFIG}/config.fish"
    util_log WARN "Backing up to ${FISH_CONFIG}/config.copy"
    cp "${FISH_CONFIG}/config.fish" "${FISH_CONFIG}/config.copy"
  else
    util_log INFO  "Adding default fish configuration."
    lib_fish_create_config
  fi

  util_log WARN "Adding Wahoo bootstrap to ${FISH_CONFIG}/config.fish"

  if [ -z ${CUSTOM+_} ]; then
    CUSTOM="${BASE}/.dotfiles"
  fi

  echo "set -g WAHOO_PATH $(echo "${BASE}/.wahoo" \
  | sed -e "s|$HOME|\$HOME|")" > "${FISH_CONFIG}/config.fish"

  echo "set -g WAHOO_CUSTOM $(echo "${CUSTOM}" \
  | sed -e "s|$HOME|\$HOME|")" >> "${FISH_CONFIG}/config.fish"

  echo "source \$WAHOO_PATH/${INIT}" >> "${FISH_CONFIG}/config.fish"

  WAHOO_CONFIG="${HOME}/.config/wahoo"

  if [ ! -d "${WAHOO_CONFIG}" ]; then
    util_log WARN "Adding Wahoo configuration in ${WAHOO_CONFIG}"
    mkdir -p "${WAHOO_CONFIG}"

    if [ ! -e "${WAHOO_CONFIG}/theme" ]; then
      echo default >> "${WAHOO_CONFIG}/theme"
    fi
  fi
}

lib_main_run() {
  util_log TITLE "== Bootstraping Wahoo =="
  util_log INFO "Installing dependencies..."

  if ! util_env_can "fish"; then
    util_log INFO  "Installing fish..."
    if lib_fish_install; then
      util_log WARN "Setting fish as your default shell."
      lib_fish_set_as_default_shell
    fi
  fi

  if lib_wahoo_install; then
    util_log_default_success "Wahoo"
    util_display_success_msg

    cd $HOME

    if [ -z ${CI+_} ]; then
      util_env_swap_process "fish"
    fi
  else
    util_log ERROR "Alas, Wahoo failed to install correctly."
    util_log INFO "Please open a new issue here → git.io/wahoo-issues"
    exit 1
  fi
}

lib_main_run
