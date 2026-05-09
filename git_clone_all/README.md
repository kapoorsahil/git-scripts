# git_clone_all.sh

Clone every repo in a GitHub org or user account into the current directory. Skips repos that are already cloned. Uses SSH URLs.

## Usage

```
mkdir ~/my-org && cd ~/my-org
git_clone_all.sh my-org
```

```
mkdir ~/personal && cd ~/personal
git_clone_all.sh kapoorsahil
```

The first argument can be either a GitHub org name or a username. The script lists every repo accessible to the authenticated `gh` user and clones each into the current directory.

## Notes

- Requires the `gh` CLI authenticated.
- Limited to 1000 repos via `gh repo list --limit 1000`. Edit the script if you need more.
- Existing folders with the same name as a repo are left alone (no overwrite).
- Summary at the end: cloned / skipped / failed counts.

## Install

```
git clone git@github.com:kapoorsahil/git-scripts.git ~/git-scripts
ln -s ~/git-scripts/git_clone_all/git_clone_all.sh /usr/local/bin/git-clone-all
```
