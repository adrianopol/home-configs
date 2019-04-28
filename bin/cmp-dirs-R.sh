#!/bin/bash

set -eu -o pipefail

left_dir="${1:-}"
right_dir="${2:-}"

for path in "$left_dir"/* "$left_dir"/.* ; do
  f="${path#$left_dir/}"
  lf="$left_dir/$f"
  rf="$right_dir/$f"
  [[ "$f" == '.' || "$f" == '..' ]] && continue

  echo "'$f'"
  if [[ ! -f "$lf" || ( -f "$lf" && $(diff -q "$lf" "$rf" >/dev/null) ) ]] ; then
    meld "$lf" "$rf"
  fi
done
