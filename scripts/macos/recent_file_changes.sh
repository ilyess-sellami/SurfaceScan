#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)

# Directory to scan (adjust as needed)
SCAN_DIR="/"

files_array=()

# Find files modified in last 24 hours
while IFS= read -r file; do
    modified=$(stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%S%z" "$file" 2>/dev/null)
    files_array+=("{\"path\":\"$file\",\"modified_at\":\"$modified\"}")
done < <(find "$SCAN_DIR" -type f -mtime -1 2>/dev/null | head -n 1000)

files_json=$(IFS=, ; echo "${files_array[*]}")

echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"recent_file_changes\",\"files\":[$files_json]}"
