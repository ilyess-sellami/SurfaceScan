#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)
CATEGORY="default_gateways"

gateways=$(netstat -rn | awk '/^default/ { iface=$NF; gw=$2; cmd="ifconfig " iface " | awk \047/ether/ {print $2}\047"; cmd | getline mac; close(cmd); printf("{\"interface\":\"%s\",\"gateway\":\"%s\",\"mac_address\":\"%s\"},\n", iface, gw, mac)}' | sed '$ s/,$//')

echo "{
  \"host\": \"$HOSTNAME\",
  \"collected_at\": \"$COLLECTED_AT\",
  \"category\": \"$CATEGORY\",
  \"gateways\": [
    $gateways
  ]
}"
