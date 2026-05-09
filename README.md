# git-scripts

Bash utilities for working across many local git repos at once. Each script lives in its own folder with a dedicated README and usage examples.

## Scripts

| Script | What it does |
|---|---|
| [`git_fetch_all/`](./git_fetch_all/) | Sync every repo. Stash, fetch with prune, fast-forward every relevant branch, restore. The morning sync command. |
| [`git_my_commits/`](./git_my_commits/) | Aggregate your commits across every repo over the last N days. Standup helper. |
| [`git_pr_all/`](./git_pr_all/) | List open PRs across every GitHub repo. Filters for yours, ones awaiting your review, drafts. |
| [`git_clone_all/`](./git_clone_all/) | Bulk-clone every repo in a GitHub org or user account. New-machine setup. |
| [`git_clean_branches/`](./git_clean_branches/) | Interactive cleanup of `[gone]` branches (squash-merged PR ghosts). |
| [`git_size_all/`](./git_size_all/) | List every repo by working tree + `.git` size, sorted descending. Find what's eating your SSD. |
| [`git_pr_review/`](./git_pr_review/) | Given a PR URL, find the local clone and check the PR branch out for review. |
| [`git_open/`](./git_open/) | Open the current repo (or a file and line) on GitHub in your browser. |

## Setup

Clone the repo, then symlink each script you want into your `PATH`:

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts

ln -s ~/git-scripts/git_fetch_all/git_fetch_all.sh        /usr/local/bin/git-fetch-all
ln -s ~/git-scripts/git_my_commits/git_my_commits.sh      /usr/local/bin/git-my-commits
ln -s ~/git-scripts/git_pr_all/git_pr_all.sh              /usr/local/bin/git-pr-all
ln -s ~/git-scripts/git_clone_all/git_clone_all.sh        /usr/local/bin/git-clone-all
ln -s ~/git-scripts/git_clean_branches/git_clean_branches.sh /usr/local/bin/git-clean-branches
ln -s ~/git-scripts/git_size_all/git_size_all.sh          /usr/local/bin/git-size-all
ln -s ~/git-scripts/git_pr_review/git_pr_review.sh        /usr/local/bin/git-pr-review
ln -s ~/git-scripts/git_open/git_open.sh                  /usr/local/bin/git-open
```

See each subfolder's README for script-specific docs and configuration knobs.

## Notes

- All scripts target macOS (zsh / bash 3.2) and Linux.
- Color output auto-disables when stdout is not a TTY, or set `NO_COLOR=1`.
- Several scripts require the `gh` CLI authenticated (`gh auth status`).

## Planned

Companions I plan to add to this repo:

- `git_status_all/` - read-only health dashboard (branch, dirty/clean, ahead/behind across every repo).
- `git_run_all/` - run an arbitrary shell command in each repo (`npm install`, `npm run lint`, etc.).

## Contributing

If you have a script you want to add, or an improvement to an existing one, open a PR. New scripts should follow the same conventions as the existing ones: each in its own folder with a README, color output that auto-disables off-TTY, and a `find . -type d -name .git` sweep for multi-repo operations.
