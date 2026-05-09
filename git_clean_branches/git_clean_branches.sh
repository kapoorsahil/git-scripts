#!/bin/bash
#
# git_clean_branches.sh
#
# Walk every repo under the current directory and interactively review
# branches whose upstream has been deleted (the squash-merged PR ghosts
# that git_fetch_all.sh flags as "[gone]"). Asks before deleting each.
#
# Uses 'git branch -D' so it works even when commits are not reachable
# from the active branch (the typical squash-merge case).

if [ -t 1 ] && [ -z "${NO_COLOR-}" ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'
    CYAN=$'\033[36m'; YELLOW=$'\033[33m'; RED=$'\033[31m'; RESET=$'\033[0m'
else
    BOLD=""; DIM=""; GREEN=""; CYAN=""; YELLOW=""; RED=""; RESET=""
fi

deleted=0
kept=0
BASEDIR=$(pwd)

while IFS= read -r git_dir; do
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")
    cd "$repo_dir" || continue

    # Refresh remote refs so [gone] flags are accurate
    git fetch --prune origin > /dev/null 2>&1

    gone=()
    while IFS=$'\t' read -r br track; do
        if [ "$track" = "[gone]" ]; then
            gone+=("$br")
        fi
    done < <(git for-each-ref --format='%(refname:short)%09%(upstream:track)' refs/heads/)

    if [ "${#gone[@]}" -eq 0 ]; then
        continue
    fi

    echo ""
    echo "${BOLD}${CYAN}━━━━ $repo_name${RESET}"

    for br in "${gone[@]}"; do
        last=$(git log -1 --pretty=format:"%h %s ${DIM}(%ar)${RESET}" "$br" 2>/dev/null)
        echo ""
        echo "${YELLOW}$br${RESET}"
        echo "  $last"
        printf "  delete this branch? [y/N] "
        read -r answer < /dev/tty
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
            if git branch -D "$br" > /dev/null 2>&1; then
                echo "  ${GREEN}deleted${RESET}"
                deleted=$((deleted + 1))
            else
                echo "  ${RED}delete failed${RESET}"
            fi
        else
            echo "  ${DIM}kept${RESET}"
            kept=$((kept + 1))
        fi
    done
done < <(find "$BASEDIR" -type d -name ".git")

echo ""
echo "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
if [ "$deleted" -eq 0 ] && [ "$kept" -eq 0 ]; then
    echo "${GREEN}No stale branches found.${RESET}"
else
    echo "${GREEN}deleted: $deleted${RESET}  ${DIM}kept: $kept${RESET}"
fi
