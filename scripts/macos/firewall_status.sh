#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)

rules_json=""

# Check PF firewall rules
if pfctl -s info &>/dev/null; then
    FW_PF="pf"
    RULES_PF=$(sudo pfctl -sr 2>/dev/null)
    rules_pf_json=$(echo "$RULES_PF" | awk -v fw="$FW_PF" '{gsub(/"/,"\\\""); if(NF>0) print "{\"source\":\""fw"\",\"name\":\"rule\",\"path\":\""$0"\"}"}' | paste -sd "," -)
    rules_json=$rules_pf_json
fi

# Check macOS Application Firewall
APP_FIREWALL=$(defaults read /Library/Preferences/com.apple.alf globalstate 2>/dev/null)
if [[ "$APP_FIREWALL" != "" ]]; then
    FW_APP="app_firewall"
    case $APP_FIREWALL in
        0) STATE="Off" ;;
        1) STATE="On for specific services" ;;
        2) STATE="On for essential services" ;;
    esac
    # Add app firewall state as a rule object
    app_fw_json="{\"source\":\"$FW_APP\",\"name\":\"Application Firewall\",\"path\":\"State: $STATE\"}"
    if [[ "$rules_json" != "" ]]; then
        rules_json="$rules_json,$app_fw_json"
    else
        rules_json="$app_fw_json"
    fi
fi

# If still empty, mark none
if [[ "$rules_json" == "" ]]; then
    rules_json="{\"source\":\"none\",\"name\":\"rule\",\"path\":\"No firewall detected\"}"
fi

echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"firewall_status\",\"rules\":[$rules_json]}"
