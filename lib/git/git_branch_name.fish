function git_branch_name -d "Get current branch name"
  git_is_repo; and begin
    command git symbolic-ref --short HEAD | tr '[:lower:]' '[:upper:]'
  end
end
