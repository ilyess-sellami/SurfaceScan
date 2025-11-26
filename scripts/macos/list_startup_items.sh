#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)
CATEGORY="startup_items"

items=$(find /Library/LaunchAgents /Library/LaunchDaemons ~/Library/LaunchAgents -name "*.plist" 2>/dev/null | while read plist; do
    name=$(basename "$plist")
    printf '{"source":"plist","name":"%s","path":"%s"},\n' "$name" "$plist"
done | sed '$ s/,$//')

echo "{
  \"host\": \"$HOSTNAME\",
  \"collected_at\": \"$COLLECTED_AT\",
  \"category\": \"$CATEGORY\",
  \"items\": [
    $items
  ]
}"
