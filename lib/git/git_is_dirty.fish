function git_is_dirty -d "Check if there are changes to tracked files"
  if git_is_repo
    not command git diff --no-ext-diff --quiet --exit-code
  end
end
