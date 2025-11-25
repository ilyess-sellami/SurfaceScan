#!/bin/bash

users_json="[]"
groups_json="[]"

# Collect users
users_list=$(cut -d: -f1 /etc/passwd)

users_json=$(printf '['; for user in $users_list; do
    uid=$(id -u "$user" 2>/dev/null)
    shell=$(getent passwd "$user" | cut -d: -f7)
    groups=$(id -Gn "$user" 2>/dev/null | tr ' ' ',')

    printf '{"username":"%s","uid":"%s","shell":"%s","groups":"%s"},' \
        "$user" "$uid" "$shell" "$groups"
done | sed 's/,$//'; printf ']')

# Collect groups
groups_list=$(cut -d: -f1 /etc/group)

groups_json=$(printf '['; for grp in $groups_list; do
    members=$(getent group "$grp" | cut -d: -f4)

    printf '{"group":"%s","members":"%s"},' "$grp" "$members"
done | sed 's/,$//'; printf ']')

# Final JSON output
echo "{ \"users\": $users_json, \"groups\": $groups_json }"
