#!/bin/sh
# shellcheck shell=bash

set -eu

# Usage:
#
#   convert-for-tg.sh input-file output.mp4

src="${1:?"arg 1 missing: path to file required"}"
dst="${2:?"arg 2 missing: some mp4 filename"}"

ss="${3:-}"
to="${4:-}"

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
