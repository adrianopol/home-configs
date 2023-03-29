#!/usr/bin/env bash

set -eu
set -o pipefail

all_repos="$( find -mindepth 1 -type d -name .git -printf "./%P\n" | sort | sed -re 's,/.git$,,' )"
repos="${@:-$all_repos}"
if [[ -d .git ]]; then # update current repo
  repos=.
fi
failed_repos=

echo
echo "Updating the following repos:"
echo
echo "$repos"
echo

for repo in $repos ; do
  pushd $repo
    # get rid of "would clobber existing tag"
    if ! git fetch --tags -f ; then
      popd
      continue
    fi

    if ! git pull --rebase --tags ; then
      failed_repos="$failed_repos $repo"
      popd
      continue
    fi

    if ! git submodule update --init --recursive ; then #--rebase
      failed_repos="$failed_repos $repo"
      popd
      continue
    fi

    git remote prune origin
    git-clean-merged-branches.sh -y
    git submodule foreach git remote prune origin
    git submodule foreach git-clean-merged-branches.sh -y
    #~git gc

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
