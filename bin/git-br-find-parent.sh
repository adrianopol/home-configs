#!/usr/bin/env bash

set -eu

# branch="$( git rev-parse --abbrev-ref HEAD )"
# git show-branch -a 2>/dev/null | \
#   grep '\*' | \
#   grep -v "$branch" | \
#   head -1 | \
#   sed 's/.*\[\(.*\)\].*/\1/' | \
#   sed 's/[\^~].*//'

git show-branch -a 2>/dev/null | \
  grep '\*' | \
  grep -v "$( git rev-parse --abbrev-ref HEAD )" | \
  head -1 | \
  perl -ple 's/\[[A-Za-z]+-\d+\][^\]]+$//; s/^.*\[([^~^\]]+).*$/$1/'
