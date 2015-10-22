#!/usr/bin/env bash

set -eu -o pipefail

err() {
  echo "Error: $*"
  exit 1
}

degrees="$1"
shift
[[ "$degrees" =~ [0-9]+ ]] || err "Bad <degrees> argument."

for f in "$@"; do
  echo "rotating ${f} $degrees degrees..."
  tmp=$(mktemp rotate.XXXXXX)
  convert -rotate "$degrees" "$f" "$tmp"
  mv "$tmp" "$f"
done
