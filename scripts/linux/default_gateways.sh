#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)
CATEGORY="default_gateways"

gateways=$(ip route show default | awk '
{
    iface = $5
    gw = $3
    cmd = "cat /sys/class/net/" iface "/address"
    cmd | getline mac
    close(cmd)
    printf("{\"interface\":\"%s\",\"gateway\":\"%s\",\"mac_address\":\"%s\"},\n", iface, gw, mac)
}' | sed '$ s/,$//')

echo "{
  \"host\": \"$HOSTNAME\",
  \"collected_at\": \"$COLLECTED_AT\",
  \"category\": \"$CATEGORY\",
  \"gateways\": [
    $gateways
  ]
}"
