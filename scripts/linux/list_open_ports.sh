#!/bin/bash

host=$(hostname)
collected_at=$(date -Iseconds)

ports_json="["
first=true

# Only TCP/UDP LISTEN ports
while IFS= read -r line; do
    proto=$(echo "$line" | awk '{print $1}')
    local_field=$(echo "$line" | awk '{print $4}')
    pid=$(echo "$line" | awk '{print $7}' | cut -d'/' -f1)
    state=$(echo "$line" | awk '{print $6}')

    [[ "$state" != "LISTEN" ]] && continue

    local_address=$(echo "$local_field" | awk -F: '{print $1}')
    local_port=$(echo "$local_field" | awk -F: '{print $NF}')

    [[ "$first" == true ]] && first=false || ports_json+=","
    ports_json+="{\"protocol\":\"$proto\",\"local_address\":\"$local_address\",\"local_port\":\"$local_port\",\"pid\":\"$pid\",\"state\":\"$state\"}"
done < <(ss -tulnp | tail -n +2)

ports_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"open_ports\", \"ports\": $ports_json }"
