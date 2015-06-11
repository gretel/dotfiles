function git_is_stashed -d "Check if repo has stashed contents"
  if git_is_repo
    command git rev-parse --verify --quiet refs/stash >/dev/null
  end
end
