function git_is_touched -d "Check if repo has any changes"
  if git_is_repo
    test -n (echo (command git status --porcelain))
  end
end
