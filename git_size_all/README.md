# git_size_all.sh

List every repo under the current directory with its working tree size and `.git` size, sorted by total descending. Useful for finding bloated checkouts (errant `node_modules`, model checkpoints, leftover build artifacts).

## Usage

```
./git_size_all.sh
```

Output looks like:

```
REPO                                            TOTAL          .git
some-frontend                                   842M          124M
some-backend                                    310M           42M
small-utility                                    18M          2.1M

Total: 1.2G
```

## Notes

- Sorted by total size descending, so the worst offenders surface first.
- Both columns use `du -sk` and format to K / M / G.
- Slow on directories with very large `node_modules`. Budget a few seconds per repo.

## Install

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts
ln -s ~/git-scripts/git_size_all/git_size_all.sh /usr/local/bin/git-size-all
```
