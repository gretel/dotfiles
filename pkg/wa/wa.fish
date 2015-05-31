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

# set_color Helpers
function em    ;  set_color cyan    ; end
function dim   ;  set_color 555     ; end
function off   ;  set_color normal  ; end
function err   ;  set_color red     ; end
function line  ;  set_color -u      ; end
function bold  ;  set_color -o      ; end

function wa -d "Wahoo"
  if test (count $argv) -eq 0
    wa_help; and return 0
  end

  switch $argv[1]
    case "v" "ver" "version"
      wa_version

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

        wa_list_themes | column | sed -E "s/$regex/"(line)(bold)(em)"\1"(off)"/"
        set_color normal

      else if test (count $argv) -eq 2
        wa_use $argv[2]
      else
        echo (bold)(line)(err)"Invalid number of arguments"(off) 1^&2
        echo "Usage: $_ "(em)"$argv[1]"(off)" [<theme name>]" 1^&2
        return $WAHOO_INVALID_ARG
      end

    case "r" "rm" "remove" "uninstall"
      if test (count $argv) -ne 2
        echo (bold)(line)(err)"Invalid number of arguments"(off) 1^&2
        echo "Usage: $_ "(em)"$argv[1]"(off)" <[package|theme] name>" 1^&2
        return $WAHOO_INVALID_ARG
      end
      wa_remove_package $argv[2..-1]

    case "p" "up" "upd" "update"
      pushd $WAHOO_PATH
      echo (bold)"Updating Wahoo..."(off)
      if wa_update
        echo (em)"Wahoo is up to date."(off)
      else
        echo (line)"Wahoo failed to update."(off)
        echo "Please open a new issue here → "(line)"git.io/wahoo-issues"(off)
      end
      popd
      reload

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
          echo (bold)(line)(err)"Argument missing"(off) 1^&2
          echo "Usage: $_ "(em)"$argv[1]"(off)" <package/theme name>" 1^&2
          return $WAHOO_MISSING_ARG
      end

    case "n" "nw" "new"
      if test (count $argv) -ne 3
        echo (bold)(line)(err)"Package type or name missing"(off) 1^&2
        echo "Usage: $_ "(em)"$argv[1]"(off)" "(bold)"pkg|theme"(off)" <name>" 1^&2
        return $WAHOO_MISSING_ARG
      end
      wa_new $argv[2..-1]

    case "destroy"
      wa_destroy

    case "*"
      echo (bold)(line)(err)"$argv[1] option not recognized"(off) 1^&2
      return $WAHOO_UNKNOWN_OPT
  end
end




