#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)
CATEGORY="startup_items"

# Systemd services enabled at startup
services=$(systemctl list-unit-files --type=service | awk '$2=="enabled"{print $1}' | while read svc; do
    printf '{"source":"systemd","name":"%s","path":"/etc/systemd/system/%s"},\n' "$svc" "$svc"
done | sed '$ s/,$//')

# User crontab entries
cron_items=$(crontab -l 2>/dev/null | grep -v '^#' | while read line; do
    job=$(echo "$line" | awk '{print $6}') # take first command
    printf '{"source":"crontab","name":"%s","path":"%s"},\n' "cron_job" "$job"
done | sed '$ s/,$//')

all_items=$(echo -e "$services\n$cron_items" | sed '/^$/d')

echo "{
  \"host\": \"$HOSTNAME\",
  \"collected_at\": \"$COLLECTED_AT\",
  \"category\": \"$CATEGORY\",
  \"items\": [
    $all_items
  ]
}"
