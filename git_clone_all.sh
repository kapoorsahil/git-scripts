#!/bin/bash
#
# git_clone_all.sh <github-org-or-user>
#
# Clone every repo in a GitHub org or user account into the current
# directory. Skips repos that already exist locally. Uses SSH URLs.
#
# Examples:
#   git_clone_all.sh kapoorsahil
#   git_clone_all.sh my-org

org=${1:-}

if [ -z "$org" ] || [ "$org" = "-h" ] || [ "$org" = "--help" ]; then
    echo "Usage: $(basename "$0") <github-org-or-user>" >&2
    exit 1
fi

if ! command -v gh > /dev/null 2>&1; then
    echo "gh CLI not found. Install from https://cli.github.com/" >&2
    exit 1
fi

if [ -t 1 ] && [ -z "${NO_COLOR-}" ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'
    CYAN=$'\033[36m'; YELLOW=$'\033[33m'; RED=$'\033[31m'; RESET=$'\033[0m'
else
    BOLD=""; DIM=""; GREEN=""; CYAN=""; YELLOW=""; RED=""; RESET=""
fi

echo "${BOLD}Listing repos for $org...${RESET}"

repos=()
while IFS= read -r line; do
    repos+=("$line")
done < <(gh repo list "$org" --limit 1000 --json name,sshUrl --jq '.[] | "\(.name)\t\(.sshUrl)"')

if [ "${#repos[@]}" -eq 0 ]; then
    echo "${YELLOW}No repos found for $org (or no access).${RESET}"
    exit 0
fi

cloned=0
skipped=0
failed=0

for line in "${repos[@]}"; do
    name=$(echo "$line" | cut -f1)
    url=$(echo "$line" | cut -f2)

    echo ""
    echo "${BOLD}${CYAN}━━━━ $name${RESET}"

    if [ -d "$name" ]; then
        echo "${DIM}already cloned, skipping${RESET}"
        skipped=$((skipped + 1))
        continue
    fi

    if git clone "$url" "$name"; then
        cloned=$((cloned + 1))
    else
        echo "${RED}✗  clone failed${RESET}"
        failed=$((failed + 1))
    fi
done

echo ""
echo "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo "${GREEN}cloned: $cloned${RESET}  ${DIM}skipped: $skipped${RESET}  ${RED}failed: $failed${RESET}"
