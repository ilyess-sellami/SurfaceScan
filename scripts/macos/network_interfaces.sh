#!/bin/bash

host=$(scutil --get LocalHostName)
collected_at=$(date -Iseconds)

interfaces_json="["
first=true

append_if() {
    [[ "$first" == true ]] && first=false || interfaces_json+=","
    interfaces_json+="{\"name\":\"$1\",\"mac\":\"$2\",\"ipv4\":\"$3\",\"ipv6\":\"$4\",\"mtu\":\"$5\",\"status\":\"$6\"}"
}

while IFS= read -r iface; do
    mac=$(ifconfig "$iface" 2>/dev/null | awk '/ether/{print $2}')
    ipv4=$(ifconfig "$iface" 2>/dev/null | awk '/inet /{print $2}')
    ipv6=$(ifconfig "$iface" 2>/dev/null | awk '/inet6/{print $2}' | head -n1)
    mtu=$(ifconfig "$iface" 2>/dev/null | awk '/mtu/{print $NF}')
    status=$(ifconfig "$iface" 2>/dev/null | awk '/status:/{print $2}')

    append_if "$iface" "$mac" "$ipv4" "$ipv6" "$mtu" "$status"

done < <(networksetup -listallhardwareports | awk '/Device/ {print $2}')

interfaces_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"network_interfaces\", \"interfaces\": $interfaces_json }"
