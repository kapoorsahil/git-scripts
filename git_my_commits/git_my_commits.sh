#!/bin/bash
#
# git_my_commits.sh [days]
#
# Aggregate the commits you authored across every repo under the current
# directory in the last N days (default 7). Useful for standup notes and
# weekly reports.

days=${1:-7}

if [ -t 1 ] && [ -z "${NO_COLOR-}" ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'
    CYAN=$'\033[36m'; YELLOW=$'\033[33m'; RESET=$'\033[0m'
else
    BOLD=""; DIM=""; GREEN=""; CYAN=""; YELLOW=""; RESET=""
fi

email=$(git config --global user.email 2>/dev/null)
if [ -z "$email" ]; then
    echo "git config user.email is not set; cannot identify your commits." >&2
    exit 1
fi

echo "${BOLD}Commits by $email in the last $days days${RESET}"

total=0
repos_with_commits=0
BASEDIR=$(pwd)

while IFS= read -r git_dir; do
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")

    log=$(git -C "$repo_dir" log --author="$email" --since="$days days ago" \
        --pretty=format:"  ${DIM}%h${RESET} %s ${YELLOW}(%ar)${RESET}" 2>/dev/null)

    if [ -n "$log" ]; then
        count=$(echo "$log" | wc -l | tr -d ' ')
        total=$((total + count))
        repos_with_commits=$((repos_with_commits + 1))
        echo ""
        echo "${BOLD}${CYAN}━━━━ $repo_name${RESET} ${DIM}($count commits)${RESET}"
        echo "$log"
    fi
done < <(find "$BASEDIR" -type d -name ".git")

echo ""
echo "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
if [ "$total" -eq 0 ]; then
    echo "${YELLOW}No commits found in the last $days days.${RESET}"
else
    echo "${GREEN}${BOLD}Total: $total commits across $repos_with_commits repos${RESET}"
fi
