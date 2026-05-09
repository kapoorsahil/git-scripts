# git_open.sh

Open the current repo on GitHub in your default browser. With a path argument, opens that file on the current branch. Append `:LINE` to focus a specific line.

## Usage

```
./git_open.sh                              # repo home
./git_open.sh src/main.ts                  # file at HEAD branch
./git_open.sh src/main.ts:42               # file at line 42
./git_open.sh README.md:10                 # README at line 10
```

## Notes

- Works for `github.com` remotes (both SSH and HTTPS). Other hosts (GitLab, Bitbucket) need URL conversion adjustments.
- Uses `open` on macOS, `xdg-open` on Linux. The URL is also printed so you can copy it manually.
- Branch is taken from `git symbolic-ref HEAD`. Falls back to commit SHA on detached HEAD.

## Install

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts
ln -s ~/git-scripts/git_open/git_open.sh /usr/local/bin/git-open
```
