#!/bin/bash

# macOS: List users in admin group
host=$(scutil --get LocalHostName)
collected_at=$(date -Iseconds)

admins=$(dscl . read /Groups/admin GroupMembership 2>/dev/null | sed 's/GroupMembership://;s/ /,/g')
admins_array=$(echo "$admins" | tr ',' '\n' | sed '/^$/d')

admins_json="["
first=true
for user in $admins_array; do
    uid=$(dscl . -read /Users/"$user" UniqueID 2>/dev/null | awk '{print $2}')
    [[ -z "$uid" ]] && uid=""
    [[ "$first" == true ]] && first=false || admins_json+=","
    admins_json+="{\"username\":\"$user\",\"uid\":\"$uid\",\"privilege\":\"admin\"}"
done
admins_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"privileges\", \"admins\": $admins_json }"
