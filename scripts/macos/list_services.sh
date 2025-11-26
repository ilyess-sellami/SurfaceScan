#!/bin/bash

host=$(scutil --get LocalHostName)
collected_at=$(date -Iseconds)

services_json="["

first=true
while IFS= read -r line; do
    pid=$(echo "$line" | awk '{print $1}')
    status_code=$(echo "$line" | awk '{print $2}')
    label=$(echo "$line" | awk '{print $3}')

    # Determine service running state
    if [[ "$pid" == "-" ]]; then
        status="stopped"
        pid=0
    else
        status="running"
    fi

    # Add comma after first element
    [[ "$first" == true ]] && first=false || services_json+=","

    # Add JSON object
    services_json+="{\"label\":\"$label\",\"pid\":$pid,\"status\":\"$status\"}"

done < <(launchctl list | tail -n +2)

services_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"services\", \"services\": $services_json }"
