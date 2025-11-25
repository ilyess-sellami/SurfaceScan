#!/bin/bash

OUTPUT=""

# Detect users with sudo privileges
sudo_users=$(grep -E '^[^#].*ALL=\(ALL\) ALL' /etc/sudoers /etc/sudoers.d/* 2>/dev/null | \
    awk '{print $1}' | sort -u)

# Detect users in sudo group
group_sudo=$(getent group sudo | awk -F: '{print $4}' | tr ',' '\n')

# Merge both lists and remove duplicates
all_admins=$(printf "%s\n%s\n" "$sudo_users" "$group_sudo" | sort -u | sed '/^$/d')

host=$(hostname)
collected_at=$(date -Iseconds)

admins_json="["
first=true
for user in $all_admins; do
    uid=$(id -u "$user" 2>/dev/null)
    [[ -z "$uid" ]] && uid=""
    [[ "$first" == true ]] && first=false || admins_json+=","
    admins_json+="{\"username\":\"$user\",\"uid\":\"$uid\",\"privilege\":\"sudo\"}"
done
admins_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"privileges\", \"admins\": $admins_json }"
