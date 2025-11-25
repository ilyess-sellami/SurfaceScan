#!/bin/bash

# Ensure outputs directory exists
mkdir -p outputs

# Collect users
users_json="["
first_user=true
for user in $(dscl . list /Users); do
    # Skip system users
    [[ "$user" == "_"* ]] && continue
    [[ "$user" == "daemon" || "$user" == "nobody" || "$user" == "root" ]] && continue

    realname=$(dscl . -read /Users/"$user" RealName 2>/dev/null | tail -1)
    [[ -z "$realname" ]] && realname=""

    uid=$(dscl . -read /Users/"$user" UniqueID 2>/dev/null | awk '{print $2}')
    [[ -z "$uid" ]] && uid=""

    groups=$(id -Gn "$user" 2>/dev/null | tr ' ' ',')
    [[ -z "$groups" ]] && groups=""

    [[ "$first_user" == true ]] && first_user=false || users_json+=","
    users_json+="{\"username\":\"$user\",\"realname\":\"$realname\",\"uid\":\"$uid\",\"groups\":\"$groups\"}"
done
users_json+="]"

# Collect groups
groups_json="["
first_group=true
for grp in $(dscl . list /Groups); do
    members=$(dscl . -read /Groups/"$grp" GroupMembership 2>/dev/null | sed 's/GroupMembership://;s/ /,/g')
    [[ -z "$members" ]] && members=""

    [[ "$first_group" == true ]] && first_group=false || groups_json+=","
    groups_json+="{\"group\":\"$grp\",\"members\":\"$members\"}"
done
groups_json+="]"

# Output JSON
echo "{ \"users\": $users_json, \"groups\": $groups_json }"
