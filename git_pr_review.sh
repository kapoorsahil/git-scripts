#!/bin/bash
#
# git_pr_review.sh <pr-url>
#
# Given a GitHub PR URL, find the matching local clone (under the
# current directory or ~/Developer/) and check out the PR branch using
# 'gh pr checkout'. Saves the cd-and-checkout dance for code review.
#
# Override search paths with GIT_REVIEW_SEARCH_PATHS (colon-separated).
# Default: current directory + ~/Developer.
#
# Example:
#   git_pr_review.sh https://github.com/owner/repo/pull/123

url=${1:-}

if [ -z "$url" ] || [ "$url" = "-h" ] || [ "$url" = "--help" ]; then
    echo "Usage: $(basename "$0") <pr-url>" >&2
    echo "Example: $(basename "$0") https://github.com/owner/repo/pull/123" >&2
    exit 1
fi

if ! command -v gh > /dev/null 2>&1; then
    echo "gh CLI not found. Install from https://cli.github.com/" >&2
    exit 1
fi

# Parse URL: https://github.com/<owner>/<repo>/pull/<number>
if [[ ! "$url" =~ github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
    echo "Could not parse PR URL: $url" >&2
    exit 1
fi
owner="${BASH_REMATCH[1]}"
repo="${BASH_REMATCH[2]}"
pr_number="${BASH_REMATCH[3]}"

if [ -t 1 ] && [ -z "${NO_COLOR-}" ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'
    CYAN=$'\033[36m'; RED=$'\033[31m'; RESET=$'\033[0m'
else
    BOLD=""; DIM=""; GREEN=""; CYAN=""; RED=""; RESET=""
fi

search_paths="${GIT_REVIEW_SEARCH_PATHS:-$(pwd):$HOME/Developer}"

found=""
IFS=':' read -ra paths <<< "$search_paths"
for path in "${paths[@]}"; do
    [ -d "$path" ] || continue
    while IFS= read -r git_dir; do
        repo_dir=$(dirname "$git_dir")
        remote=$(git -C "$repo_dir" remote get-url origin 2>/dev/null)
        if echo "$remote" | grep -qE "[:/]${owner}/${repo}(\.git)?$"; then
            found="$repo_dir"
            break 2
        fi
    done < <(find "$path" -maxdepth 4 -type d -name ".git" 2>/dev/null)
done

if [ -z "$found" ]; then
    echo "${RED}Could not find a local clone of $owner/$repo${RESET}" >&2
    echo "Searched: $search_paths" >&2
    exit 1
fi

echo "${BOLD}${CYAN}━━━━ $(basename "$found") ($owner/$repo)${RESET}"
echo "${DIM}local: $found${RESET}"
echo ""

cd "$found" || exit 1
gh pr checkout "$pr_number"
echo ""
echo "${GREEN}Checked out PR #$pr_number for review${RESET}"
