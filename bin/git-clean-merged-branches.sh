#!/bin/sh
# shellcheck shell=bash

set -eu -o pipefail

case "${1:-}" in
(-y) assume_yes=y ;;
(*)  assume_yes=n ;;
esac

br_exclude="(\*|master|main|develop)"

brs="$( git branch --merged | grep -Pv "$br_exclude" || true )"

if [[ -z $brs ]]; then
  exit 0
fi

if [[ $assume_yes == n ]]; then
  echo -en "Really remove branches\n\n$brs\n\n? (y/[n]) -> "
  yn=
  read -r yn
  [[ $yn == y ]] || exit
fi

br=
while read -r br; do
  set -x
  git branch -d "$br"
  set +x
done <<< "$brs"
