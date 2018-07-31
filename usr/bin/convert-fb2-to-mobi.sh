#!/bin/bash

set -eux

path="${1:?Need directory to search in.}"

find "$path" -name "*.fb2*" -print0 | \
  sort | \
  parallel -j4 -r0 --plus \
    'ebook-convert {} {..}.mobi --mobi-ignore-margins --mobi-keep-original-images'
