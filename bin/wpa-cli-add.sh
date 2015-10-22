#!/usr/bin/env bash

set -eu

iface=wlp0s20f3

ssid="${1:?arg1: SSID}"
pass="${2:?arg2: password}"

set -x

net_num="$(wpa_cli -i "$iface" add_network)"
wpa_cli -i "$iface" set_network "$net_num" ssid "\"$ssid\""
wpa_cli -i "$iface" set_network "$net_num" psk "\"$pass\""
wpa_cli -i "$iface" enable_network "$net_num"
