# git_my_commits.sh

Aggregate the commits you authored across every repo under the current directory in the last N days (default 7). Output is grouped by repo with short SHA, subject, and relative age. Useful for standup notes and weekly reports.

Identifies "your" commits using `git config --global user.email`.

## Usage

```
./git_my_commits.sh           # last 7 days (default)
./git_my_commits.sh 14        # last 14 days
./git_my_commits.sh 30        # last month
```

## Notes

- Repos with no commits in the window are skipped silently.
- The total commit count and the number of repos with commits are printed at the end.
- If `git config --global user.email` is unset, the script exits with an error.

## Install

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts
ln -s ~/git-scripts/git_my_commits/git_my_commits.sh /usr/local/bin/git-my-commits
```
