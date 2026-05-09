# git_fetch_all.sh

Sync every git repo under the current directory in one command. Stashes uncommitted work, fetches with prune, fast-forwards every relevant branch, and restores the stash. The morning sync command for multi-repo work.

For each `.git` directory it finds, the script:

- Stashes uncommitted changes (with `-u`, so untracked files come along) and restores them at the end.
- Runs a single `git fetch --prune origin`.
- Fast-forwards the active branch.
- Always fast-forwards `development`, `production`, and `staging`, even when they aren't checked out, and creates them locally if they don't exist.
- Sweeps every other local branch with an upstream and fast-forwards it. Diverged branches and `[gone]` upstreams are flagged but never overwritten.
- Deletes local branches already merged into the active branch (excluding the three pinned ones).
- Prints per-repo size and elapsed time.

## Usage

```
./git_fetch_all.sh                   # pull current branch in every repo
./git_fetch_all.sh <branch-name>     # checkout + pull <branch-name> in every repo;
                                     # falls back to development if not on remote
```

Run from the directory that holds your repos. The script descends recursively to find every `.git`.

## Configure

Three knobs at the top of the script:

- `ALWAYS_PULL_BRANCHES` for your long-running branches.
- The detached-HEAD fallback list inside `do_repo_sync` (currently the same three branches).
- The prune-merged exclusion regex inside `prune_merged_branches`.

Set these to whatever your team uses (`main`, `dev`, `qa`) and forget about them.

## Notes

- Color output auto-disables when stdout is not a TTY, or set `NO_COLOR=1`.
- Diverged branches are warned about, never overwritten.
- Local branches whose upstream was pruned (`[gone]`) are flagged but not auto-deleted; use `git_clean_branches` to clean them interactively.

## Install

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts
ln -s ~/git-scripts/git_fetch_all/git_fetch_all.sh /usr/local/bin/git-fetch-all
```
