#!/bin/bash

host=$(scutil --get LocalHostName)
collected_at=$(date -Iseconds)

processes_json="["

first=true
while IFS= read -r line; do
    pid=$(echo $line | awk '{print $1}')
    user=$(echo $line | awk '{print $2}')
    cpu=$(echo $line | awk '{print $3}')
    mem=$(echo $line | awk '{print $4}')
    cmd=$(echo $line | awk '{for(i=5;i<=NF;i++) printf $i " "; print ""}' | sed 's/ $//')

    [[ "$first" == true ]] && first=false || processes_json+=","
    processes_json+="{\"pid\":\"$pid\",\"name\":\"$cmd\",\"cpu\":\"$cpu\",\"memory_mb\":\"$mem\",\"user\":\"$user\"}"
done < <(ps -axo pid,user,%cpu,%mem,comm | tail -n +2)

processes_json+="]"

echo "{ \"host\":\"$host\", \"collected_at\":\"$collected_at\", \"category\":\"processes\", \"processes\": $processes_json }"
