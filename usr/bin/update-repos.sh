#!/bin/bash

set -eu -o pipefail

usage() {
  : #TODO
}

max_depth=3

all_repos="$( find . -maxdepth $max_depth \( \
  -name .git -o \
  -name .hg -o \
  -name .svn \) \
  -printf '  %P\n' | sort )"

repos="${@:-$all_repos}"

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

  pushd "$rep"
    case "$repo" in
    (*/.git)
      set -x
      git pull --rebase
      git submodule update --init --recursive
      git remote prune origin
      git-clean-merged-branches.sh
      git submodule foreach git remote prune origin
      git submodule foreach git-clean-merged-branches.sh
      git gc
      set +x ;;
    (*/.hg)
      set -x
      hg pull
      set +x ;;
    (*/.svn)
      set -x
      svn up
      set +x ;;
    (*)
      echo ">>> Unknown repository type: $repo" ;;
    esac
  popd
done <<< "$repos"
