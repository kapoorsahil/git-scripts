#!/bin/bash
#
# git_size_all.sh
#
# List every repo under the current directory with its working tree size
# and .git size, sorted by total size descending. Useful for finding
# bloated checkouts (errant node_modules, model checkpoints, etc.)

if [ -t 1 ] && [ -z "${NO_COLOR-}" ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'; CYAN=$'\033[36m'; RESET=$'\033[0m'
else
    BOLD=""; DIM=""; CYAN=""; RESET=""
fi

human() {
    awk -v kb="$1" 'BEGIN {
        if (kb >= 1048576)      printf "%.1fG", kb/1048576;
        else if (kb >= 1024)    printf "%.1fM", kb/1024;
        else                    printf "%dK", kb;
    }'
}

BASEDIR=$(pwd)
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

while IFS= read -r git_dir; do
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")

    total_kb=$(du -sk "$repo_dir" 2>/dev/null | awk '{print $1}')
    git_kb=$(du -sk "$git_dir" 2>/dev/null | awk '{print $1}')

    [ -z "$total_kb" ] && total_kb=0
    [ -z "$git_kb" ] && git_kb=0

    printf "%s\t%s\t%s\t%s\n" \
        "$total_kb" "$repo_name" "$(human "$total_kb")" "$(human "$git_kb")" >> "$tmpfile"
done < <(find "$BASEDIR" -type d -name ".git")

if [ ! -s "$tmpfile" ]; then
    echo "No repos found under $BASEDIR."
    exit 0
fi

echo "${BOLD}Repo sizes${RESET}"
printf "${DIM}%-40s %12s %12s${RESET}\n" "REPO" "TOTAL" ".git"

sort -rn -k1,1 "$tmpfile" | while IFS=$'\t' read -r kb name total git; do
    printf "${CYAN}%-40s${RESET} %12s %12s\n" "$name" "$total" "$git"
done

total_kb=$(awk -F$'\t' '{ sum += $1 } END { printf "%d", sum }' "$tmpfile")
echo ""
echo "${BOLD}Total: $(human "$total_kb")${RESET}"
