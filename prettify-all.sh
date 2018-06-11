#!/bin/bash
set -e
script_dir=$(dirname $0)
git ls-files | xargs -n 100 $script_dir/prettier.sh
yarn jest -u
