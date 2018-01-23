#!/bin/bash

set -eu -o pipefail

br_exclude="(\*|master|develop)"

brs="$( git branch --merged | grep -Pv "$br_exclude" )"

echo -en "Really remove branches\n\n$brs\n\n? (y/[n]) -> "
yn=
read yn
if [[ $yn != y ]] ; then
  exit
fi

br=
while read br; do
  set -x
  git branch -d "$br"
  set +x
done <<< "$brs"
