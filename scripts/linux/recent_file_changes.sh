#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)

SCAN_DIR="/"

files_array=()

while IFS= read -r file; do
    modified=$(stat -c "%y" "$file" 2>/dev/null)
    files_array+=("{\"path\":\"$file\",\"modified_at\":\"$modified\"}")
done < <(find "$SCAN_DIR" -type f -mtime -1 2>/dev/null | head -n 1000)

files_json=$(IFS=, ; echo "${files_array[*]}")

echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"recent_file_changes\",\"files\":[$files_json]}"
