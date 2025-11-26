#!/bin/bash

host=$(scutil --get LocalHostName)
collected_at=$(date -Iseconds)

apps_json="["
first=true

append_app() {
    [[ "$first" == true ]] && first=false || apps_json+=","
    apps_json+="{\"name\":\"$1\",\"version\":\"$2\",\"path\":\"$3\",\"type\":\"$4\"}"
}

# --- System & User Applications (.app bundles) ---
while IFS= read -r app; do
    name=$(basename "$app" .app)
    version=$(/usr/bin/defaults read "$app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null)

    append_app "$name" "$version" "$app" "application"

done < <(find /Applications /System/Applications -maxdepth 1 -type d -name "*.app" 2>/dev/null)

# --- Homebrew Packages ---
if command -v brew >/dev/null 2>&1; then
    while IFS= read -r line; do
        pkg=$(echo "$line" | awk '{print $1}')
        ver=$(echo "$line" | awk '{print $2}')

        append_app "$pkg" "$ver" "" "brew"

    done < <(brew list --versions 2>/dev/null)
fi

apps_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"installed_apps\", \"apps\": $apps_json }"
