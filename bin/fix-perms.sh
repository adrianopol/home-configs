#!/bin/bash

set -eu -o pipefail

exit 1
# TODO: fix!!!

find_f_cmd="find . -type f ! -perm 0644 ! -name *.sh"
find_d_cmd="find . -type d ! -perm 0755"

files=("$( $find_f_cmd )")
dirs=("$( $find_d_cmd )")

if [[ -n $files ]]; then
  echo '-------- FILES --------'
  #set -f
  echo "${files[@]}"
  #set +f
fi
if [[ -n $dirs ]]; then
  echo '----- DIRECTORIES -----'
  #set -f
  echo "${dirs[@]}"
  #set +f
fi
if [[ -n "$files" || -n "$dirs" ]]; then
  echo '-----------------------'
  echo
else
  echo "Nothing to do."
  exit
fi

read -r -p "Fix permissions (f:644, d:755)? (Y/n) -> " ok
if [[ "$ok" == n || "$ok" == N ]]; then
  exit
fi

set -xf
$find_f_cmd -exec chmod 644 '{}' \+
$find_d_cmd -exec chmod 755 '{}' \+
set +xf
