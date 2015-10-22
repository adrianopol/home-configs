#!/bin/sh
# shellcheck shell=bash

set -eu -o pipefail

# Resolve domains to IPs and show the routing interface for each.
# Compatible with Bash 4+ and Zsh 5+.
#
# Usage: ./resolve_routes.sh domain1 [domain2 ...]

if [[ "$#" -eq 0 ]]; then
  echo >&2 "Usage: $0 domain1 [domain2 ...]"
  exit 1
fi

for domain in "$@"; do
  echo "==> $domain"

  # Resolve all A/AAAA records; skip if none found.
  # Use a while-read loop instead of mapfile/readarray for Zsh compatibility.
  ips=()
  while IFS= read -r ip_line; do
    [[ -n "$ip_line" ]] && ips+=("$ip_line")
  done < <(
    dig +short A "$domain" 2>/dev/null | grep -E '^[0-9a-fA-F:.]+$'
    #~dig +short A "$domain" AAAA "$domain" 2>/dev/null | grep -E '^[0-9a-fA-F:.]+$'
  )

  if [[ "${#ips[@]}" -eq 0 ]]; then
    echo "    [!] No IP addresses resolved for '${domain}'" >&2
    continue
  fi

  for ip in "${ips[@]}"; do
    echo -n "  IP: $ip"
    # `ip route get` prints the route + interface; extract the interface name
    route_info=$(ip route get "$ip" 2>/dev/null) || {
      echo >&2 "    [!] Could not get route for $ip"
      echo
      continue
    }
    # The output format is: ... dev <iface> ...
    iface=$(echo "$route_info" | grep -oP '(?<=\bdev\s)\S+' | head -n1)
    src=$(echo "$route_info"   | grep -oP '(?<=\bsrc\s)\S+' | head -n1)
    echo "    dev: ${iface:-unknown}  src: ${src:-unknown}"
  done

  echo
done
