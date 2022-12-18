#!/usr/bin/env bash

set -eu

# Usage:
#
#   convert-for-tg.sh file

src="${1:?"argument missing: path to file required"}"
dst="${src%.*}.mp4"

ss="${2:-}"
to="${3:-}"

echo
echo "Converting '$src' -> '$dst' ..."
echo

opts=(
  -c:v libx264 -b:v 1500k
  -c:a libmp3lame -b:a 128k
)
[[ -z "$ss" ]] || opts+=(-ss "$ss")
[[ -z "$to" ]] || opts+=(-to "$to")

set -x
ffmpeg -i "$src" "${opts[@]}" "$dst"
