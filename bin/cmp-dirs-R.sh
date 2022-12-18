#!/usr/bin/env bash

set -eu

ldir="${1:?}"
rdir="${2:?}"

if ! [[ -d "$ldir" && -d "$rdir" ]]; then
  echo "Usage: $0 <from_dir> <to_dir>"
  exit 1
fi

for path in "$ldir"/* "$ldir"/.* ; do
  f="${path#$ldir/}"
  lf="$ldir/$f"
  rf="$rdir/$f"
  [[ "$f" == '.' || "$f" == '..' ]] && continue

  echo "'$f'"
  if [[ ! -f "$lf" || ( -f "$lf" && $(diff -q "$lf" "$rf" >/dev/null) ) ]] ; then
    meld "$lf" "$rf"
  fi
done
