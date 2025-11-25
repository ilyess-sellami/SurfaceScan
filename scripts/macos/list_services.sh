#!/bin/bash

host=$(scutil --get LocalHostName)
collected_at=$(date -Iseconds)

services_json="["

first=true
while IFS= read -r line; do
    label=$(echo "$line" | awk '{print $1}')
    pid=$(echo "$line" | awk '{print $2}')
    status=$(if [ "$pid" != "-" ]; then echo "running"; else echo "stopped"; fi)

    [[ "$first" == true ]] && first=false || services_json+=","
    services_json+="{\"label\":\"$label\",\"pid\":\"$pid\",\"status\":\"$status\"}"
done < <(launchctl list | tail -n +2)

services_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"services\", \"services\": $services_json }"
