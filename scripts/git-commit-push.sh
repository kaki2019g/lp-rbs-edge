#!/usr/bin/env bash

set -euo pipefail

remote="${1:-origin}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: run this script inside a Git repository." >&2
  exit 1
fi

branch="$(git symbolic-ref --quiet --short HEAD || true)"
if [[ -z "$branch" ]]; then
  echo "Error: cannot push while HEAD is detached." >&2
  exit 1
fi

if ! git remote get-url "$remote" >/dev/null 2>&1; then
  echo "Error: remote '$remote' does not exist." >&2
  exit 1
fi

# Include tracked, untracked, renamed, and deleted files in one commit.
git add --all

if git diff --cached --quiet; then
  echo "Nothing to commit."
  exit 0
fi

added=0
modified=0
deleted=0
renamed=0
other=0
total=0
first_path=""

while IFS=$'\t' read -r status path extra_path; do
  [[ -z "$status" ]] && continue

  total=$((total + 1))
  display_path="${extra_path:-$path}"
  [[ -z "$first_path" ]] && first_path="$display_path"

  case "${status:0:1}" in
    A) added=$((added + 1)) ;;
    M) modified=$((modified + 1)) ;;
    D) deleted=$((deleted + 1)) ;;
    R) renamed=$((renamed + 1)) ;;
    *) other=$((other + 1)) ;;
  esac
done < <(git diff --cached --name-status)

if (( total == 1 )); then
  case "$added:$modified:$deleted:$renamed" in
    1:0:0:0) commit_message="Add $first_path" ;;
    0:1:0:0) commit_message="Update $first_path" ;;
    0:0:1:0) commit_message="Remove $first_path" ;;
    0:0:0:1) commit_message="Rename $first_path" ;;
    *)         commit_message="Update $first_path" ;;
  esac
else
  summary=()
  (( added > 0 )) && summary+=("$added added")
  (( modified > 0 )) && summary+=("$modified modified")
  (( deleted > 0 )) && summary+=("$deleted deleted")
  (( renamed > 0 )) && summary+=("$renamed renamed")
  (( other > 0 )) && summary+=("$other other")

  printf -v details '%s, ' "${summary[@]}"
  details="${details%, }"
  commit_message="Update project files ($details)"
fi

echo "Commit message: $commit_message"
git commit -m "$commit_message"

if git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' >/dev/null 2>&1; then
  git push
else
  git push --set-upstream "$remote" "$branch"
fi

echo "Pushed '$branch' successfully."
