#!/bin/bash

# Collect hostname and timestamp
HOSTNAME=$(hostname)
COLLECTED_AT=$(date -Iseconds)

# --------------------------
# Collect systemd timers
# --------------------------
systemd_tasks=$(systemctl list-timers --all --no-pager --no-legend | awk '{print $1}' | while read timer; do
    [[ -z "$timer" ]] && continue
    service=$(systemctl show -p Unit "$timer" | cut -d= -f2)
    echo "{\"source\":\"systemd_timer\",\"name\":\"$timer\",\"path\":\"$service\"}"
done | paste -sd "," -)

# --------------------------
# Collect cron jobs for current user
# --------------------------
cron_tasks=$(crontab -l 2>/dev/null | grep -v '^#' | awk '{print "{\"source\":\"cron\",\"name\":\"cronjob\",\"path\":\""$0"\"}"}' | paste -sd "," -)

# --------------------------
# Combine all tasks
# --------------------------
all_tasks=""

if [[ -n "$systemd_tasks" ]]; then
    all_tasks="$systemd_tasks"
fi

if [[ -n "$cron_tasks" ]]; then
    if [[ -n "$all_tasks" ]]; then
        all_tasks="$all_tasks,$cron_tasks"
    else
        all_tasks="$cron_tasks"
    fi
fi

# --------------------------
# Output JSON
# --------------------------
echo "{\"host\":\"$HOSTNAME\",\"collected_at\":\"$COLLECTED_AT\",\"category\":\"scheduled_tasks\",\"tasks\":[$all_tasks]}"
