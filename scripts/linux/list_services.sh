#!/bin/bash

host=$(hostname)
collected_at=$(date -Iseconds)

services_json="["

first=true
while IFS= read -r line; do
    name=$(echo "$line" | awk '{print $1}')
    status=$(echo "$line" | awk '{print $2}')
    startType=$(echo "$line" | awk '{print $3}')
    description=$(echo "$line" | cut -d' ' -f4-)

    [[ "$first" == true ]] && first=false || services_json+=","
    services_json+="{\"name\":\"$name\",\"status\":\"$status\",\"startType\":\"$startType\",\"description\":\"$description\"}"
done < <(systemctl list-units --type=service --all --no-legend | awk '{print $1,$4,$5,$6,$7,$8,$9,$10,$11,$12}')

services_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"services\", \"services\": $services_json }"
