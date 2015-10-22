#!/usr/bin/env bash

set -eux

# Usage:
#
#   convert-phone-video.sh [ result_path ] file1 ...

scale=y

dest_prefix=.
if [[ -d "${1:-}" ]]; then
  dest_prefix="$1"
  shift
fi

for path in "$@"; do
  file="$(basename "$path")"
  ext=webm
  if [[ -n "$dest_prefix" ]]; then
    out_path="$dest_prefix/${file%.*}.$ext"
  else
    out_path="$dest_prefix/${path%.*}.$ext"
  fi
  args=(
    -i "$path"
    -c:v libvpx -b:v 3000k
    -c:a libvorbis -b:a 128k
    -threads 4
  )
  if [[ "$scale" == y ]]; then
    #TODO: perofrm scaling only when dimensions are too large
    args+=(
      -vf scale=w=1400:h=1200:force_original_aspect_ratio=decrease
    )
  fi
  args+=(
    "$out_path"
  )
  set -x
  time ffmpeg "${args[@]}"
  set +x
  echo
  echo
done
