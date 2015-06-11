function git_untracked -d "Print list of untracked files"
  if git_is_repo
    command git ls-files --other --exclude-standard
  end
end
