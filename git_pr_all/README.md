# git_pr_all.sh

List open pull requests across every GitHub repo under the current directory using the `gh` CLI. Replaces tab-hunting in the GitHub UI every morning.

## Usage

```
./git_pr_all.sh                # all open PRs
./git_pr_all.sh --mine         # PRs you authored
./git_pr_all.sh --reviewing    # PRs requesting your review
./git_pr_all.sh --draft        # only drafts
```

Output: `#NUMBER TITLE - AUTHOR [draft]` per PR, grouped by repo.

## Notes

- Requires the `gh` CLI authenticated. Check with `gh auth status`.
- Repos without a `github.com` origin are skipped.
- The script makes one API call per repo, so very large folders (50+ repos) may take a few seconds.

## Install

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts
ln -s ~/git-scripts/git_pr_all/git_pr_all.sh /usr/local/bin/git-pr-all
```
