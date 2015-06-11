function git_is_staged -d "Check if repo has staged changes"
  if git_is_repo
    not command git diff --cached --no-ext-diff --quiet --exit-code
  end
end
