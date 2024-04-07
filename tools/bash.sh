#!/bin/bash

declare -A server_info

while IFS= read -r line; do
  ip_address=$(echo "$line" | awk '{print $1}')
  username=$(echo "$line" | awk '{print $2}' | cut -d "=" -f2)
  username=${username:-root}

  if [[ ! $ip_address =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
    continue
  fi

  server_info["$ip_address"]="$username"
done < ./inventory/hosts

for server in "${!server_info[@]}"; do
  ip_address="${server}"
  username="${server_info[$server]}"

  echo "  Username: $username"
  echo "  IP Address: $ip_address"
  echo
done
