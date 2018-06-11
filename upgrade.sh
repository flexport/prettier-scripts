#!/bin/bash
set -e
script_dir=$(dirname $0)
git checkout master
git pull origin master
yarn add prettier@latest
version=$(yarn --silent prettier --version)
git commit --all --message="⬆️ upgrade prettier to version $version"
git tag pre-prettier
$script_dir/prettify-all.sh
