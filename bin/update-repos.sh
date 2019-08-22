#!/bin/bash

set -eu
set -o pipefail

all_repos="$( find -mindepth 2 -maxdepth 2 -type d -name .git -printf "%P\n" | sort | sed -re 's,/.*$,,' )"
repos="${@:-$all_repos}"
failed_repos=

echo
echo "Updating the following repos:"
echo
echo "$repos"
echo

for repo in $repos ; do
  pushd $repo
    if ! git pull --rebase ; then
      failed_repos="$failed_repos $repo"
      popd
      continue
    fi
    if ! git submodule update --init --recursive ; then #--rebase
      failed_repos="$failed_repos $repo"
      popd
      continue
    fi
    #git remote prune origin
    git-clean-merged-branches.sh -y
    git submodule foreach git remote prune origin
    git submodule foreach git-clean-merged-branches.sh -y
    git gc

    make tags || true
  popd
done

if [[ -n "$failed_repos" ]]; then
  echo ""
  echo "Unabled to update the following repositories:"
  echo ""
  echo "  $failed_repos"
else
  echo "OK"
fi
