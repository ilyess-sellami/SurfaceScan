#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)
CATEGORY="active_connections"

# List TCP and UDP connections in JSON format
connections=$(ss -tunp | tail -n +2 | awk '
{
    # Protocol
    proto = $1
    # Local address and port
    split($5, la, ":")
    local_address = la[1]
    local_port = la[2]
    # Remote address and port
    split($6, ra, ":")
    remote_address = ra[1]
    remote_port = ra[2]
    # State
    state = ($1 == "udp" ? "LISTEN" : $2)
    # PID
    pid = "-"
    if ($7 ~ /pid=/) {
        match($7, /pid=([0-9]+)/, m)
        pid = m[1]
    }
    # Print JSON object
    printf("{\"protocol\":\"%s\",\"local_address\":\"%s\",\"local_port\":\"%s\",\"remote_address\":\"%s\",\"remote_port\":\"%s\",\"state\":\"%s\",\"pid\":\"%s\"},\n", proto, local_address, local_port, remote_address, remote_port, state, pid)
}' | sed '$ s/,$//')

# Wrap everything in JSON
echo "{
  \"host\": \"$HOSTNAME\",
  \"collected_at\": \"$COLLECTED_AT\",
  \"category\": \"$CATEGORY\",
  \"connections\": [
    $connections
  ]
}"
