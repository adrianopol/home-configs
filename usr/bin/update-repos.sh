#!/bin/bash

set -eu -o pipefail

usage() {
  : #TODO
}

WD="$( readlink -f "${1:-.}" )"

max_depth=${2:-3}

repos="$( find $WD -maxdepth $max_depth \( \
  -name .git -o \
  -name .hg -o \
  -name .svn \) \
  -printf '  %P\n' | sort )"

echo -en ">>> Update the following repos:\n\n$repos\n\n? (y/[n]) -> "
read answer
if [[ $answer != y ]]; then
  exit
fi

while read repo; do
  rep="${repo%/*}"
  echo
  echo ">>> Updating $rep ..."
  echo

  pushd "$WD/$rep"
    case "$repo" in
    (*/.git)  set -x; git pull --rebase && \
                      git submodule update --init --recursive && \
                      git gc; set +x ;;
    (*/.hg)   set -x; hg pull; set +x ;;
    (*/.svn)  set -x; svn up; set +x ;;
    (*)       echo ">>> Unknown repository type: $repo" ;;
    esac
  popd
done <<< "$repos"
