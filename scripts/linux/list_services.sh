#!/bin/bash

host=$(hostname)
collected_at=$(date -Iseconds)

services_json="["

first=true
while IFS= read -r line; do
    name=$(echo "$line" | awk '{print $1}')
    load_state=$(echo "$line" | awk '{print $2}')
    active_state=$(echo "$line" | awk '{print $3}')
    sub_state=$(echo "$line" | awk '{print $4}')
    description=$(echo "$line" | cut -d ' ' -f5-)

    [[ "$first" == true ]] && first=false || services_json+=","

    services_json+="{\"name\":\"$name\", \"load_state\":\"$load_state\", \"active_state\":\"$active_state\", \"sub_state\":\"$sub_state\", \"description\":\"$description\"}"

done < <(systemctl list-units --type=service --all --no-legend)

services_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"services\", \"services\": $services_json }"
