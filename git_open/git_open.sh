#!/bin/bash
#
# git_open.sh [path[:line]]
#
# Open the current repo on GitHub in your browser. With a path
# argument, opens the file at that path on the current branch; append
# ":LINE" to focus a specific line.
#
# Examples:
#   git_open.sh
#   git_open.sh src/main.ts
#   git_open.sh src/main.ts:42

target=${1:-}

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Not in a git repo." >&2
    exit 1
fi

remote=$(git remote get-url origin 2>/dev/null)
if [ -z "$remote" ]; then
    echo "No 'origin' remote configured." >&2
    exit 1
fi

# Normalize remote URL to https://github.com/owner/repo
url=$(echo "$remote" | sed -E '
    s|^git@github.com:|https://github.com/|;
    s|\.git$||;
')

if [ -z "$target" ]; then
    open_url="$url"
else
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$branch" ]; then
        branch=$(git rev-parse HEAD)
    fi

    if [[ "$target" == *:* ]]; then
        path="${target%:*}"
        line="${target##*:}"
        open_url="$url/blob/$branch/$path#L$line"
    else
        open_url="$url/blob/$branch/$target"
    fi
fi

echo "$open_url"

if command -v open > /dev/null 2>&1; then
    open "$open_url"
elif command -v xdg-open > /dev/null 2>&1; then
    xdg-open "$open_url"
else
    echo "(no 'open' or 'xdg-open' found; URL printed above)" >&2
fi
