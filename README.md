# git-scripts

Bash utilities I use to wrangle many local git repos at once.

## Scripts

### `git_fetch_all.sh`

Walks every `.git` directory under the current working directory and brings each repo up to date. For each repo it:

- Stashes uncommitted changes (with `-u`, so untracked files are kept) and restores them at the end.
- Runs a single `git fetch --prune origin` — pulls every remote ref and removes remote-tracking branches that were deleted upstream.
- Fast-forwards the active branch.
- Always fast-forwards `development`, `production`, and `staging` (creating them locally if they don't exist yet) — even when they aren't checked out.
- Sweeps every other local branch with an upstream and fast-forwards it; flags diverged branches and `[gone]` upstreams.
- Deletes local branches already merged into the active branch (excluding the three pinned ones).
- Prints per-repo size and elapsed time.

#### Usage

```
./git_fetch_all.sh                  # pull current branch in every repo
./git_fetch_all.sh <branch-name>    # checkout + pull <branch-name>;
                                    # falls back to development if not on remote
```

Run from the directory that contains your repos (it descends recursively to find every `.git`).

#### Install

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts
ln -s ~/git-scripts/git_fetch_all.sh /usr/local/bin/git-fetch-all
```

#### Notes

- Tested on macOS (zsh / bash 3.2). Should work on Linux without changes.
- Color output auto-disables when stdout isn't a TTY, or set `NO_COLOR=1`.
- Diverged branches are warned about, never overwritten.
- Local branches whose upstream was pruned (`[gone]`) are flagged but not auto-deleted — squash-merged commits would be unreachable, so you decide.

### `git_my_commits.sh`

Aggregates the commits you authored across every repo under the current directory in the last N days. Output is grouped by repo. Useful for standup notes and weekly reports.

```
./git_my_commits.sh           # last 7 days (default)
./git_my_commits.sh 30        # last 30 days
```

Identifies "your" commits using `git config --global user.email`.

### `git_pr_all.sh`

Lists open pull requests across every GitHub repo under the current directory using `gh pr list`. Replaces tab-hunting in the GitHub UI every morning.

```
./git_pr_all.sh                # all open PRs
./git_pr_all.sh --mine         # PRs you authored
./git_pr_all.sh --reviewing    # PRs requesting your review
./git_pr_all.sh --draft        # only drafts
```

Requires the `gh` CLI authenticated (`gh auth status`).

### `git_clone_all.sh`

Clones every repo in a GitHub org or user account into the current directory. Skips repos that are already cloned. Uses SSH URLs.

```
mkdir ~/my-org && cd ~/my-org
git_clone_all.sh my-org
```

Useful for new-machine setup or onboarding a teammate. Requires `gh` CLI.

### `git_clean_branches.sh`

Walks every repo and interactively reviews branches whose upstream has been deleted (the squash-merged PR ghosts that `git_fetch_all.sh` flags as `[gone]`). Shows the last commit for each candidate and asks before deleting.

```
./git_clean_branches.sh
```

Uses `git branch -D` so it works on squash-merged branches whose commits are not reachable from the active branch. The default answer is "no" if you press Enter, so it is safe to run on a tired Monday morning.

### `git_size_all.sh`

Lists every repo with its working tree size and `.git` size, sorted by total descending. Useful for finding bloated checkouts (errant `node_modules`, model checkpoints, leftover build artifacts).

```
./git_size_all.sh
```

Output looks like:

```
REPO                                            TOTAL          .git
some-frontend                                   842M          124M
some-backend                                    310M           42M
small-utility                                   18M           2.1M

Total: 1.2G
```

### `git_pr_review.sh`

Given a GitHub PR URL, finds the matching local clone, checks out the PR branch with `gh pr checkout`, and lands you ready to review. Saves the cd-and-checkout dance every code review.

```
./git_pr_review.sh https://github.com/owner/repo/pull/123
```

Searches the current directory and `~/Developer/` by default. Override with `GIT_REVIEW_SEARCH_PATHS` (colon-separated paths). Requires `gh` CLI.

### `git_open.sh`

Opens the current repo on GitHub in your default browser. With a path argument, opens that file on the current branch; append `:LINE` to focus a specific line.

```
./git_open.sh                          # repo home
./git_open.sh src/main.ts              # file
./git_open.sh src/main.ts:42           # file at line 42
```

Useful for sharing code in Slack or jumping to the GitHub view from your terminal.

## Planned

Companions I plan to add to this repo:

- `git_status_all.sh` - read-only health dashboard: branch, dirty/clean, ahead/behind across every repo.
- `git_run_all.sh <command...>` - run an arbitrary command in each repo (e.g. `npm install`, `npm run lint`).
