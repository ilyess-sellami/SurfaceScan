#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)

# Initialize an array to store JSON entries
disks_array=()

# Parse df output
while read -r filesystem size used avail capacity mount; do
    # Skip pseudo filesystems
    if [[ "$filesystem" != "devfs" && "$filesystem" != "map" ]]; then
        # Build JSON object
        disk="{\"source\":\"macos\",\"name\":\"$filesystem\",\"path\":\"$mount\",\"used\":$used,\"free\":$avail,\"total\":$size}"
        disks_array+=("$disk")
    fi
done < <(df -kP | tail -n +2)

# Join array entries with commas
disks_json=$(IFS=, ; echo "${disks_array[*]}")

# Output JSON
echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"disk_usage\",\"disks\":[$disks_json]}"
