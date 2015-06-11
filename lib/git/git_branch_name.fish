function git_branch_name -d "Get current branch name"
  if git_is_repo
    command git symbolic-ref --short HEAD | tr '[:lower:]' '[:upper:]'
  end
end
