#!/bin/bash

set -eu -o pipefail

find_args_files=". -type f ! -perm 0644 ! -name *.sh"
find_args_dirs=". -type d ! -perm 0755"

echo '----- FILES -----'
set -f
find $find_args_files
echo '----- DIRECTORIES -----'
find $find_args_dirs
set +f
echo '-----'
echo

echo 'WARNING!!!'
read -r -p "Fix permissions? [y/N] -> " ok
[[ $ok != 'y' ]] && exit

set -xf
find $find_args_files -exec chmod 644 '{}' \+
find $find_args_dirs -exec chmod 755 '{}' \+
set +xf
