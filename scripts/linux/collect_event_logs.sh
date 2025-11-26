#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)
CATEGORY="syslogs"

# Limit logs to last 24 hours (systemd journal)
if command -v journalctl &> /dev/null; then
    logs=$(journalctl --since "24 hours ago" --no-pager | tail -n 1000 | \
           awk '{print "{\"raw_message\":\"" $0 "\"}"}' | paste -sd, -)
else
    # fallback to /var/log/syslog or /var/log/messages
    LOG_FILE=""
    if [ -f /var/log/syslog ]; then
        LOG_FILE="/var/log/syslog"
    elif [ -f /var/log/messages ]; then
        LOG_FILE="/var/log/messages"
    fi

    if [ -n "$LOG_FILE" ]; then
        logs=$(tail -n 1000 "$LOG_FILE" | awk '{print "{\"raw_message\":\"" $0 "\"}"}' | paste -sd, -)
    else
        logs=""
    fi
fi

logs_json="[$logs]"

echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"$CATEGORY\",\"logs\":$logs_json}"
