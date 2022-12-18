#!/usr/bin/env bash

# TODO!

set -eu -o pipefail

src="${1:?src needed}"
dst_dir="${2:?dst dir needed}"
compress="${3:-}"
encrypt="${4:-}"

# remove trailing slashes
src="$( echo "$src" | sed -re 's,/+$,,' )"

filter1=cat
filter2=cat

dst_file="$src.tar"
if [[ "$compress" == y ]]; then
  filter1="gzip -c"
  dst_file="$dst_file.gz"
fi

if [[ "$encrypt" == y ]]; then
  read -rs -p "password: " pass
  filter2="openssl aes-256-cbc -salt -md md5 -pass pass:$pass"
  dst_file="$dst_file.ssl"
fi

tar pcf - "$src" \
  | pv -s "$(du -sb "$src" | cut -f1)" \
  | $filter1 \
  | $filter2 \
  > "$dst_dir/$dst_file"
