function __wa_single_option
  test (count (commandline -opc)) -le 1
end

function __wa_option_is
  set -l cmd (commandline -opc)
  test (count $cmd) -gt 1; and contains -- $cmd[2] $argv
end

function __wa_complete -a option description
  complete -c wa -n "__wa_single_option" -d $description -a $option
end

complete --no-files -c wa -d "Wahoo"

__wa_complete list    "List local packages"
__wa_complete get     "Install one or more packages"
__wa_complete use     "List / Apply themes"
__wa_complete remove  "Remove a theme or package"
__wa_complete update  "Update Wahoo"
__wa_complete new     "Create a new package from a template"
__wa_complete submit  "Submit a package to the registry"
__wa_complete help    "Display this help"
__wa_complete version "Display version"
__wa_complete destroy "Remove Wahoo"

complete -c wa -n "__wa_option_is r rm remove"  -a \
  (printf "%s " (WAHOO::util::list_installed))
complete -c wa -n "__wa_option_is g get" -a \
  (printf "%s " (WAHOO::util::list_available))
complete -c wa -n "__wa_option_is u use" -a \
  (printf "%s " (WAHOO::util::list_themes))

