#!/usr/bin/env bash

set -eu

PROGNAME="$(readlink -f "$(basename "$0")")"

usage() {
  echo "This script will convert all fb2 files to mobi format using ebook-convert utility"
  echo "from calibre package."
  echo
  echo "Usage:"
  echo
  echo "  $PROGNAME <directory>"
  echo
  echo "where <directory> is a starting point to search .fb2 or .fb2.zip files."
}

path="${1:-}"

if [[ -z "$path" || "$path" == "-h" || "$path" == "--help" ]]; then
  usage
  exit
fi

ncores="$(grep -m1 'cpu cores' /proc/cpuinfo | grep -Po '\d+')"
[[ "$ncores" -ge 1 ]] || ncores=1

set -x
find "$path" \( -name "*.fb2" -o -name '*.fb2.zip' \) -print0 | \
  sort | \
  parallel -j"$ncores" -r0 --plus \
    'ebook-convert {} {..}.mobi --mobi-ignore-margins --mobi-keep-original-images'
