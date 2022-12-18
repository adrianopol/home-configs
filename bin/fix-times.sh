#!/usr/bin/env bash

for f in "$@"; do
  timestamp="$( \
    echo "$( basename "$f" )" | \
    sed -re 's,[^0-9]*([0-9]{4})([0-9]{2})([0-9]{2})_([0-9]{2})([0-9]{2})([0-9]{2})\..*,\1-\2-\3 \4:\5:\6,' \
  )"
  set -x
  touch -am --date="$timestamp +0300" "$f"
  set +x
done
