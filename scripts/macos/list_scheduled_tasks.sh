#!/bin/bash
HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)
dirs=("/Library/LaunchAgents" "/Library/LaunchDaemons" "$HOME/Library/LaunchAgents")
tasks=""

for dir in "${dirs[@]}"; do
  for file in "$dir"/*.plist; do
    [[ -f "$file" ]] || continue
    name=$(basename "$file")
    tasks+="{\"source\":\"plist\",\"name\":\"$name\",\"path\":\"$file\"},"
  done
done

# remove trailing comma
tasks=${tasks%,}

echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"scheduled_tasks\",\"tasks\":[$tasks]}"
