# SYNOPSIS
#   Wahoo CLI
#
# GLOBALS
#   WAHOO_VERSION   Version
#   WAHOO_CONFIG    Wahoo configuration
#
# OVERVIEW
#   Provides options to list, download and remove packages, update
#   the framework, create / submit a new package, etc.

set -g WAHOO_MISSING_ARG   1
set -g WAHOO_UNKNOWN_OPT   2
set -g WAHOO_INVALID_ARG   3
set -g WAHOO_UNKNOWN_ERR   4

set -g WAHOO_VERSION "0.1.0"
set -g WAHOO_CONFIG  "$HOME/.config/wahoo"

function wa::em;  set_color -o yellow ; end
function wa::dim; set_color -o 888    ; end
function wa::err; set_color -o red    ; end
function wa::off; set_color normal    ; end

function init -a path --on-event init_wa
  autoload $path/cli $path/util
end

function wa -d "Wahoo"
  if test (count $argv) -eq 0
    wa_help; and return 0
  end

  switch $argv[1]
    case "v" "ver" "version"
      wa_version

    case "q" "query"
      switch (count $argv)
        case 1
          wa_query_env
        case 2
          wa_query_env "$argv[2]"
        case "*"
          echo (wa::err)"Invalid number of arguments"(wa::off) 1^&2
          echo "Usage: $_ "(wa::em)"$argv[1]"(wa::off)" [<variable name>]" 1^&2
          return $WAHOO_INVALID_ARG
      end

    case "h" "help"
      wa_help

    case "l" "li" "lis" "lst" "list"
      wa_list_local_packages | column

    case "g" "ge" "get" "install"
      if test (count $argv) -eq 1
        wa_list_db_packages | column
      else
        wa_get_package $argv[2..-1]
      end

    case "u" "use"
      if test (count $argv) -eq 1
        set -l theme (cat $WAHOO_CONFIG/theme)
        set -l regex "[[:<:]]($theme)[[:>:]]"
        test (uname) != "Darwin"; and set regex "\b($theme)\b"

        wa_list_themes | column | sed -E "s/$regex/"(wa::em)"\1"(wa::off)"/"
        wa::off

      else if test (count $argv) -eq 2
        wa_use $argv[2]
      else
        echo (wa::err)"Invalid number of arguments"(wa::off) 1^&2
        echo "Usage: $_ "(wa::em)"$argv[1]"(wa::off)" [<theme name>]" 1^&2
        return $WAHOO_INVALID_ARG
      end

    case "r" "rm" "remove" "uninstall"
      if test (count $argv) -ne 2
        echo (wa::err)"Invalid number of arguments"(wa::off) 1^&2
        echo "Usage: $_ "(wa::em)"$argv[1]"(wa::off)" <[package|theme] name>" 1^&2
        return $WAHOO_INVALID_ARG
      end
      wa_remove_package $argv[2..-1]

    case "p" "up" "upd" "update"
      pushd $WAHOO_PATH
      echo (wa::em)"Updating Wahoo..."(wa::off)
      if wa_update
        echo (wa::em)"Wahoo is up to date."(wa::off)
      else
        echo (wa::err)"Wahoo failed to update."(wa::off)
        echo "Please open a new issue here → "(wa::em)"git.io/wahoo-issues"(wa::off)
      end
      popd
      refresh

    case "s" "su" "sub" "submit"
      switch (count $argv)
        case 2 4
          wa_submit $argv[2] (begin
            if set -q argv[3]
              switch $argv[3]
                case "-u" "--url"
                  echo "$argv[4]"
              end
            end
          end)
        case "*"
          echo (wa::err)"Argument missing"(wa::off) 1^&2
          echo "Usage: $_ "(wa::em)"$argv[1]"(wa::off)" "(wa::em)"pkg|themes"(wa::off)"/<name>" 1^&2
          echo "Usage: $_ "(wa::em)"$argv[1]"(wa::off)" "(wa::em)"pkg|themes"(wa::off)"/<name> "(wa::em)"--url"(wa::off)" <url>" 1^&2
          return $WAHOO_MISSING_ARG
      end

    case "n" "nw" "new"
      if test (count $argv) -ne 3
        echo (wa::err)"Package type or name missing"(wa::off) 1^&2
        echo "Usage: $_ "(wa::em)"$argv[1]"(wa::off)" "(wa::em)"pkg|theme"(wa::off)" <name>" 1^&2
        return $WAHOO_MISSING_ARG
      end
      wa_new $argv[2..-1]

    case "destroy"
      wa_destroy

    case "*"
      echo (wa::err)"$argv[1] option not recognized"(wa::off) 1^&2
      return $WAHOO_UNKNOWN_OPT
  end
end




