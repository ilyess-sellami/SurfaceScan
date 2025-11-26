#!/bin/bash

OUTPUT=""

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -o|--output) OUTPUT="$2"; shift ;;
  esac
  shift
done

HOSTNAME=$(scutil --get LocalHostName)
NOW=$(date -Iseconds)

OS_NAME=$(sw_vers -productName)
OS_VERSION=$(sw_vers -productVersion)
ARCH=$(uname -m)
KERNEL=$(uname -r)
UPTIME_SEC=$(sysctl -n kern.boottime | awk -F'}' '{print $1}' | awk -F'=' '{print $2}')
UPTIME_SEC=$(($(date +%s) - $UPTIME_SEC))

CPU_MODEL=$(sysctl -n machdep.cpu.brand_string)
CPU_CORES=$(sysctl -n machdep.cpu.core_count)
MEM_TOTAL_MB=$(sysctl -n hw.memsize | awk '{printf "%.2f", $1/1024/1024}')

JSON=$(cat <<EOF
{
  "host": "$HOSTNAME",
  "collected_at": "$NOW",
  "category": "system",
  "data": {
    "os": "$OS_NAME",
    "os_version": "$OS_VERSION",
    "architecture": "$ARCH",
    "kernel_version": "$KERNEL",
    "hostname": "$HOSTNAME",
    "uptime_seconds": $UPTIME_SEC,
    "cpu": "$CPU_MODEL",
    "cpu_cores": "$CPU_CORES",
    "memory_total_mb": "$MEM_TOTAL_MB"
  }
}
EOF
)

if [[ -n "$OUTPUT" ]]; then
  echo "$JSON" > "$OUTPUT"
else
  echo "$JSON"
fi
