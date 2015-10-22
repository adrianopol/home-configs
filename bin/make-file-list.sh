#!/usr/bin/env bash

for dir in "$@"; do
  find "$dir" -printf '%12s  %p\n' | sort -k2 >"$dir".$( date-suffix )
done
