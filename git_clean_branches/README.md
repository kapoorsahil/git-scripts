# git_clean_branches.sh

Interactively clean up local branches whose upstream was deleted: the squash-merged PR ghosts that `git_fetch_all.sh` flags as `[gone]`. Shows the last commit for each candidate and asks before deleting.

## Usage

```
./git_clean_branches.sh
```

For each `[gone]` branch in each repo, the script prints the branch name and last commit, then asks:

```
delete this branch? [y/N]
```

Press `y` to delete, anything else (or just Enter) to keep.

## Notes

- Default answer is "no" (Enter keeps the branch). Safe to run on a tired Monday.
- Uses `git branch -D` so it works on squash-merged commits that are not reachable from the active branch.
- Runs `git fetch --prune origin` first so the `[gone]` flags reflect the current remote state.
- Summary at the end shows total deleted and kept counts.

## Install

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts
ln -s ~/git-scripts/git_clean_branches/git_clean_branches.sh /usr/local/bin/git-clean-branches
```
