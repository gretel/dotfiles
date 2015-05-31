function __wa_single_option
  test (count (commandline -opc)) -le 1
end

function __wa_option
  set -l cmd (commandline -opc)
  test (count $cmd) -gt 1; and contains -- $cmd[2] $argv
end

complete --no-files -c wa -d "Wahoo"

complete -c wa -a (printf "%s " (wa_list_local_packages)) -n "__wa_option r rm remove"
complete -c wa -a (printf "%s " (wa_list_db_packages))    -n "__wa_option g get"
complete -c wa -a (printf "%s " (wa_list_themes))         -n "__wa_option u use"

complete -c wa -a list    -n "__wa_single_option" -d "List local packages"
complete -c wa -a get     -n "__wa_single_option" -d "Install one or more packages"
complete -c wa -a use     -n "__wa_single_option" -d "List / Apply themes"
complete -c wa -a remove  -n "__wa_single_option" -d "Remove a theme or package"
complete -c wa -a update  -n "__wa_single_option" -d "Update Wahoo"
complete -c wa -a new     -n "__wa_single_option" -d "Create a new package from a template"
complete -c wa -a submit  -n "__wa_single_option" -d "Submit a package to the registry"
complete -c wa -a help    -n "__wa_single_option" -d "Display this help"
complete -c wa -a version -n "__wa_single_option" -d "Display version"
complete -c wa -a destroy -n "__wa_single_option" -d "Remove Wahoo"



