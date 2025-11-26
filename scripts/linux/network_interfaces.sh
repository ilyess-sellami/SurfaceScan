#!/bin/bash

host=$(hostname)
collected_at=$(date -Iseconds)

interfaces_json="["
first=true

append_if() {
    [[ "$first" == true ]] && first=false || interfaces_json+=","
    interfaces_json+="{\"name\":\"$1\",\"mac\":\"$2\",\"ipv4\":\"$3\",\"ipv6\":\"$4\",\"mtu\":\"$5\",\"status\":\"$6\"}"
}

for iface in /sys/class/net/*; do
    name=$(basename "$iface")
    mac=$(cat "$iface/address" 2>/dev/null)
    mtu=$(cat "$iface/mtu" 2>/dev/null)
    status=$(cat "$iface/operstate" 2>/dev/null)

    ipv4=$(ip -4 addr show "$name" | awk '/inet /{print $2}' | cut -d/ -f1)
    ipv6=$(ip -6 addr show "$name" | awk '/inet6/{print $2}' | head -n1 | cut -d/ -f1)

    append_if "$name" "$mac" "$ipv4" "$ipv6" "$mtu" "$status"
done

interfaces_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"network_interfaces\", \"interfaces\": $interfaces_json }"
