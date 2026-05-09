# git_pr_review.sh

Given a GitHub PR URL, find the matching local clone and check out the PR branch using `gh pr checkout`. Saves the cd-and-checkout dance every code review.

## Usage

```
./git_pr_review.sh https://github.com/owner/repo/pull/123
```

The script searches the current directory and `~/Developer/` for a clone whose `origin` matches `owner/repo`, then runs `gh pr checkout 123` inside that clone.

## Configure

Override the search paths with `GIT_REVIEW_SEARCH_PATHS`, a colon-separated list:

```
GIT_REVIEW_SEARCH_PATHS=~/work:~/oss git_pr_review.sh <pr-url>
```

## Notes

- Requires the `gh` CLI authenticated.
- Uses `find -maxdepth 4` so deeply nested repos may not be found. Either move them shallower or extend the depth in the script.
- If you have multiple clones of the same repo, the first match wins.

## Install

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts
ln -s ~/git-scripts/git_pr_review/git_pr_review.sh /usr/local/bin/git-pr-review
```
