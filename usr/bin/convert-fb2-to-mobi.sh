#!/bin/bash

set -eux

path="${1:?Need directory to search in.}"

ncores="$(grep -m1 'cpu cores' /proc/cpuinfo | grep -Po '\d+')"
[[ "$ncores" -ge 1 ]] || ncores=1

find "$path" -name "*.fb2*" -print0 | \
  sort | \
  parallel -j4 -r0 --plus \
    'ebook-convert {} {..}.mobi --mobi-ignore-margins --mobi-keep-original-images'
