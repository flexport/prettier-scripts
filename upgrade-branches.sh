#!/bin/bash
set -e
script_dir=$(dirname $0)
current_branch=$(git symbolic-ref --short HEAD)
for branch in $@; do
  git checkout $branch
  git pull origin $branch
  $script_dir/upgrade-branch.sh || continue
  git push -f origin $branch-prettier-backup $branch || true
done
git checkout $current_branch
