# SYNOPSIS
#   Completions for Wahoo CLI

function __wa_is_single_opt
  test (count (commandline -opc)) -le 1
end

function __wa_opt_is
  set -l cmd (commandline -opc)
  test (count $cmd) -gt 1; and contains -- $cmd[2] $argv
end

complete --no-files -c wa -d "Wahoo"

complete -c wa -n "__wa_opt_is q query"      -a (printf "%s " (set | awk '{ printf $1"\n"; }'))
complete -c wa -n "__wa_opt_is r rm remove"  -a (printf "%s " (wa_list_local_packages) (wa_list_installed_themes))
complete -c wa -n "__wa_opt_is g get"        -a (printf "%s " (wa_list_db_packages))
complete -c wa -n "__wa_opt_is u use"        -a (printf "%s " (wa_list_themes))

complete -c wa -a list    -n "__wa_is_single_opt" -d "List local packages"
complete -c wa -a get     -n "__wa_is_single_opt" -d "Install one or more packages"
complete -c wa -a use     -n "__wa_is_single_opt" -d "List / Apply themes"
complete -c wa -a remove  -n "__wa_is_single_opt" -d "Remove a theme or package"
complete -c wa -a update  -n "__wa_is_single_opt" -d "Update Wahoo"
complete -c wa -a new     -n "__wa_is_single_opt" -d "Create a new package from a template"
complete -c wa -a submit  -n "__wa_is_single_opt" -d "Submit a package to the registry"
complete -c wa -a query   -n "__wa_is_single_opt" -d "Query environment variables"
complete -c wa -a help    -n "__wa_is_single_opt" -d "Display this help"
complete -c wa -a version -n "__wa_is_single_opt" -d "Display version"
complete -c wa -a destroy -n "__wa_is_single_opt" -d "Remove Wahoo"
