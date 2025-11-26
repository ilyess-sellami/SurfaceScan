#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)

disks_array=()

# Parse df output
while read -r filesystem size used avail mount; do
    # Skip pseudo filesystems
    if [[ "$filesystem" != "tmpfs" && "$filesystem" != "devtmpfs" && "$filesystem" != "overlay" ]]; then
        disk="{\"source\":\"linux\",\"name\":\"$filesystem\",\"path\":\"$mount\",\"used\":$used,\"free\":$avail,\"total\":$size}"
        disks_array+=("$disk")
    fi
done < <(df -kP | tail -n +2 | awk '{print $1, $2, $3, $4, $6}')

disks_json=$(IFS=, ; echo "${disks_array[*]}")

echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"disk_usage\",\"disks\":[$disks_json]}"
