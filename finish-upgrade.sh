#!/bin/bash
set -e
set -a
script_dir=$(dirname $0)
GIT_COMMITTER_NAME="prettier" GIT_COMMITTER_EMAIL="prettier@flexport.com" \
  git commit --author="prettier <prettier@flexport.com>" \
             --all --message="✨ prettier!" --no-verify
git tag post-prettier
git push origin pre-prettier post-prettier master
$script_dir/get-branches.sh | xargs -n 100 $script_dir/upgrade-branches.sh
