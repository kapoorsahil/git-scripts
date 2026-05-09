#!/bin/bash
#
# git_pr_all.sh [filter]
#
# List open pull requests across every GitHub repo under the current
# directory using the gh CLI.
#
# Filters:
#   --mine        Only PRs you authored
#   --reviewing   Only PRs requesting review from you
#   --draft       Only draft PRs
#   (none)        All open PRs

filter=${1:-}

if ! command -v gh > /dev/null 2>&1; then
    echo "gh CLI not found. Install from https://cli.github.com/" >&2
    exit 1
fi

if [ -t 1 ] && [ -z "${NO_COLOR-}" ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'
    CYAN=$'\033[36m'; YELLOW=$'\033[33m'; RESET=$'\033[0m'
else
    BOLD=""; DIM=""; GREEN=""; CYAN=""; YELLOW=""; RESET=""
fi

case "$filter" in
    --mine)
        gh_args=(--author "@me")
        label="your open PRs"
        ;;
    --reviewing)
        gh_args=(--search "review-requested:@me state:open")
        label="PRs requesting your review"
        ;;
    --draft)
        gh_args=(--draft)
        label="open draft PRs"
        ;;
    "")
        gh_args=()
        label="all open PRs"
        ;;
    -h|--help)
        sed -n '3,12p' "$0" | sed 's/^# \{0,1\}//'
        exit 0
        ;;
    *)
        echo "Unknown filter: $filter (use --mine, --reviewing, --draft, or omit)" >&2
        exit 1
        ;;
esac

echo "${BOLD}Listing $label across every repo${RESET}"

total=0
BASEDIR=$(pwd)

while IFS= read -r git_dir; do
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")

    if ! git -C "$repo_dir" remote get-url origin 2>/dev/null | grep -q "github.com"; then
        continue
    fi

    prs=$(cd "$repo_dir" && gh pr list "${gh_args[@]}" \
        --json number,title,author,isDraft \
        --jq '.[] | "  #\(.number) \(.title) — \(.author.login)\(if .isDraft then " [draft]" else "" end)"' \
        2>/dev/null)

    if [ -n "$prs" ]; then
        count=$(echo "$prs" | wc -l | tr -d ' ')
        total=$((total + count))
        echo ""
        echo "${BOLD}${CYAN}━━━━ $repo_name${RESET} ${DIM}($count PRs)${RESET}"
        echo "$prs"
    fi
done < <(find "$BASEDIR" -type d -name ".git")

echo ""
echo "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
if [ "$total" -eq 0 ]; then
    echo "${YELLOW}No matching PRs found.${RESET}"
else
    echo "${GREEN}${BOLD}Total: $total PRs${RESET}"
fi
