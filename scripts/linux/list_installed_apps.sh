#!/bin/bash

host=$(hostname)
collected_at=$(date -Iseconds)
apps_json="["
first=true

append_app() {
    [[ "$first" == true ]] && first=false || apps_json+=","
    apps_json+="{\"name\":\"$1\",\"version\":\"$2\",\"type\":\"$3\"}"
}

# --- APT Packages (Debian/Ubuntu) ---
if command -v dpkg >/dev/null 2>&1; then
    dpkg -l | awk '/^ii/ {print $2, $3}' | while read name version; do
        append_app "$name" "$version" "apt"
    done
fi

# --- RPM Packages (RHEL/CentOS/Fedora) ---
if command -v rpm >/dev/null 2>&1; then
    rpm -qa --queryformat "%{NAME} %{VERSION}\n" | while read name version; do
        append_app "$name" "$version" "rpm"
    done
fi

# --- Snap packages ---
if command -v snap >/dev/null 2>&1; then
    snap list | tail -n +2 | while read name version rest; do
        append_app "$name" "$version" "snap"
    done
fi

# --- Flatpak packages ---
if command -v flatpak >/dev/null 2>&1; then
    flatpak list --app | while read line; do
        name=$(echo "$line" | awk '{print $1}')
        version=$(echo "$line" | awk '{print $NF}')
        append_app "$name" "$version" "flatpak"
    done
fi

# --- Python pip packages (optional) ---
if command -v pip3 >/dev/null 2>&1; then
    pip3 list --format=columns | tail -n +3 | while read name version rest; do
        append_app "$name" "$version" "pip"
    done
fi

apps_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"installed_apps\", \"apps\": $apps_json }"
