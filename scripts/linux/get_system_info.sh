#!/bin/bash

OUTPUT=""

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -o|--output) OUTPUT="$2"; shift ;;
  esac
  shift
done

HOSTNAME=$(hostname)
NOW=$(date -Iseconds)

OS_NAME=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2- | tr -d '"')
ARCH=$(uname -m)
KERNEL=$(uname -r)
UPTIME_SEC=$(awk '{print $1}' /proc/uptime)
CPU_MODEL=$(awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo)
CPU_CORES=$(nproc)
MEM_TOTAL_MB=$(awk '/MemTotal/ {printf "%.2f", $2/1024}' /proc/meminfo)

JSON=$(cat <<EOF
{
  "host": "$HOSTNAME",
  "collected_at": "$NOW",
  "category": "system",
  "data": {
    "os": "$OS_NAME",
    "os_version": "",
    "architecture": "$ARCH",
    "kernel_version": "$KERNEL",
    "hostname": "$HOSTNAME",
    "uptime_seconds": $UPTIME_SEC,
    "cpu": "$CPU_MODEL",
    "cpu_cores": $CPU_CORES,
    "memory_total_mb": $MEM_TOTAL_MB
  }
}
EOF
)

if [[ -n "$OUTPUT" ]]; then
  echo "$JSON" > "$OUTPUT"
else
  echo "$JSON"
fi
