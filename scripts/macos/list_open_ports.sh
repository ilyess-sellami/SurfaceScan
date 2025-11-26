#!/bin/bash

host=$(scutil --get LocalHostName)
collected_at=$(date -Iseconds)

ports_json="["
first=true

# Get only LISTEN TCP/UDP ports
while IFS= read -r line; do
    pid=$(echo "$line" | awk '{print $2}')
    proto=$(echo "$line" | awk '{print $5}' | tr '[:upper:]' '[:lower:]')
    local_field=$(echo "$line" | awk '{print $9}')  # e.g., TCP *:22
    state=$(echo "$line" | awk '{print $10}' | tr -d '()')

    [[ "$state" != "LISTEN" ]] && continue

    local_address=$(echo "$local_field" | awk -F: '{print $1}')
    local_port=$(echo "$local_field" | awk -F: '{print $NF}')

    [[ "$first" == true ]] && first=false || ports_json+=","
    ports_json+="{\"protocol\":\"$proto\",\"local_address\":\"$local_address\",\"local_port\":\"$local_port\",\"pid\":\"$pid\",\"state\":\"$state\"}"
done < <(lsof -i -n -P | tail -n +2)

ports_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"open_ports\", \"ports\": $ports_json }"
