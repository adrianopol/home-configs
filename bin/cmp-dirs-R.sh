#!/usr/bin/env bash

set -eu

ldir="${1:?}"
rdir="${2:?}"

log() {
  echo ">>> $*"
}

if ! [[ -d "$ldir" && -d "$rdir" ]]; then
  echo "Usage: $0 <from_dir> <to_dir>"
  exit 1
fi

files="$( find "$ldir" -maxdepth 1 -mindepth 1 -printf '%P\n' | sort )"

while read -r f ; do
  log "comparing $f ..."
  lf="$ldir/$f"
  rf="$rdir/$f"

  if [[ "$lf" =~ _history$ ]]; then
    log "ignoring $lf"
    continue
  fi

  # FIXME: diff -r takes too long on large directories
  #if [[ -d "$lf" && -d "$rf" ]] && diff -rq "$lf" "$rf" >/dev/null ; then
  #  log "$lf == $rf"
  #  continue
  #fi
  if [[ -f "$lf" ]] && diff -q "$lf" "$rf" >/dev/null ; then
    log "$lf == $rf"
    continue
  fi

  log "$lf <-> $rf ..."
  meld "$lf" "$rf" || true
done <<< "$files"
