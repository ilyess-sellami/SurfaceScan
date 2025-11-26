#!/bin/bash

HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)
CATEGORY="syslogs"

# Ensure sudo privileges
SUDO_CMD="sudo"

# Collect the last 24 hours of logs (system + user)
# --info includes info-level messages
# --debug includes debug-level messages
logs=$($SUDO_CMD log show --predicate 'eventMessage != ""' --style syslog --info --debug --last 24h 2>/dev/null | \
       tail -n 1000 | awk '{print "{\"raw_message\":\"" $0 "\"}"}' | paste -sd, -)

# Wrap as JSON array
logs_json="[$logs]"

echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"$CATEGORY\",\"logs\":$logs_json}"
