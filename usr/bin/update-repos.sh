#!/bin/bash

set -eu -o pipefail

WD="$( readlink -f "${1:-.}" )"

repos="$( find -maxdepth 3 \( \
  -name .git -o \
  -name .hg -o \
  -name .svn \) )"

echo -e ">>> Update the following repos:\n\n$repos\n\n?"

while read repo; do
  rep="${repo%/*}"
  echo
  echo ">>> Updating $rep ..."
  echo

  pushd "$rep"
    case "$repo" in
    (*/.git)  set -x; git pull --rebase &&\
                      git submodule update --recursive --remote && \
                      git gc; set +x ;;
    (*/.hg)   set -x; hg pull; set +x ;;
    (*/.svn)  set -x; svn up; set +x ;;
    (*)       echo ">>> Unknown repository type: $repo" ;;
    esac
  popd
done <<< "$repos"
