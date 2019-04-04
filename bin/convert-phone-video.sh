#!/bin/bash

set -eu

# Usage:
#
#   convert-phone-video.sh [ result_path ] file1 ...

dest_prefix=
if [[ -d "${1:-}" ]]; then
  dest_prefix="$1"
  shift
fi

for path in "$@"; do
  file="$(basename "$path")"
  ext=webm
  out_path="${path%.*}.$ext"
  if [[ -n "$dest_prefix" ]]; then
    out_path="$dest_prefix/${file%.*}.$ext"
  fi
  set -x
  time ffmpeg -i "$path" \
    -vf scale=w=1000:h=1000:force_original_aspect_ratio=decrease \
    -c:v libvpx-vp9 -b:v 2000k \
    -c:a libvorbis -b:a 64k \
    -threads 4 \
    "$out_path"
  set +x
  echo
  echo
done
