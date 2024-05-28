#!/usr/bin/env bash

set -eu

ldir="${1:?}"
rdir="${2:?}"

if ! [[ -d "$ldir" && -d "$rdir" ]]; then
  echo "Usage: $0 <from_dir> <to_dir>"
  exit 1
fi

files="$( find -maxdepth 1 -mindepth 1 -printf '%P\n' | sort )"

while read f ; do
  echo "$f"
  lf="$ldir/$f"
  rf="$rdir/$f"

  if [[ -f "$lf" ]] && diff -q "$lf" "$rf" >/dev/null ; then
    echo ">>> $lf == $rf"
    continue
  fi

  echo ">>> $lf <-> $rf ..."
  meld "$lf" "$rf" || true
done <<< "$files"
