#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)

# Check if ufw or iptables is used
if command -v ufw &>/dev/null; then
    FW="ufw"
    RULES=$(ufw status numbered | tail -n +2)
elif command -v iptables &>/dev/null; then
    FW="iptables"
    RULES=$(iptables -L -n -v --line-numbers)
else
    FW="none"
    RULES="No firewall detected"
fi

# Format rules as JSON array
rules_json=$(echo "$RULES" | awk -v fw="$FW" '{gsub(/"/,"\\\""); if(NF>0) print "{\"source\":\""fw"\",\"name\":\"rule\",\"path\":\""$0"\"}"}' | paste -sd "," -)

echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"firewall_status\",\"rules\":[$rules_json]}"
