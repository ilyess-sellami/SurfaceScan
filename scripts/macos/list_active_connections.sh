#!/bin/bash
# list_active_connections.sh
# Lists all active TCP/UDP connections on macOS with proper parsing

hostname=$(scutil --get LocalHostName)
collected_at=$(date -Iseconds)

connections=()

# Parse TCP connections
while IFS= read -r line; do
    proto=$(echo "$line" | awk '{print $1}')
    laddr=$(echo "$line" | awk '{print $9}' | cut -d'>' -f1)
    lport=$(echo "$laddr" | awk -F: '{print $NF}')
    laddr=$(echo "$laddr" | sed "s/:$lport$//")
    raddr=$(echo "$line" | awk '{print $9}' | cut -d'>' -f2)
    rport=$(echo "$raddr" | awk -F: '{print $NF}')
    raddr=$(echo "$raddr" | sed "s/:$rport$//")
    state=$(echo "$line" | awk '{print $10}')
    pid=$(echo "$line" | awk '{print $2}')

    connections+=("{\"protocol\":\"$proto\",\"local_address\":\"$laddr\",\"local_port\":\"$lport\",\"remote_address\":\"$raddr\",\"remote_port\":\"$rport\",\"state\":\"$state\",\"pid\":\"$pid\"}")
done < <(lsof -iTCP -sTCP:ESTABLISHED -n -P | tail -n +2)

# Parse UDP connections (usually no remote)
while IFS= read -r line; do
    proto=$(echo "$line" | awk '{print $1}')
    laddr=$(echo "$line" | awk '{print $9}' | cut -d':' -f1)
    lport=$(echo "$line" | awk '{print $9}' | cut -d':' -f2)
    state="LISTEN"
    pid=$(echo "$line" | awk '{print $2}')

    connections+=("{\"protocol\":\"$proto\",\"local_address\":\"$laddr\",\"local_port\":\"$lport\",\"remote_address\":\"\",\"remote_port\":\"\",\"state\":\"$state\",\"pid\":\"$pid\"}")
done < <(lsof -iUDP -n -P | tail -n +2)

# Output JSON
connections_json=$(IFS=, ; echo "${connections[*]}")

echo "{ \"host\":\"$hostname\", \"collected_at\":\"$collected_at\", \"category\":\"active_connections\", \"connections\": [$connections_json] }"
