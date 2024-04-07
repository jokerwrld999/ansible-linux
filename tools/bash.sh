#!/bin/bash

# Define an associative array to store IP and usernames
declare -A server_info

# Loop through each section and extract details
while IFS= read -r line; do
  # Check for section header ([section_name])
    # Extract IP and username (avoiding potential leading spaces)
    ip_address=$(echo "$line" | awk '{print $1}')
    username=$(echo "$line" | awk '{print $2}' | cut -d "=" -f2)  # Get the last field (username)
    username=${username:-root}

    # Validate IP address format (optional)
    if [[ ! $ip_address =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
      # echo "Warning: Invalid IP address found in '$line'" >&2
      continue  # Skip invalid lines
    fi

    # Store details in the associative array
    server_info["$current_section,$ip_address"]="$username"  # Include section in key
done < ./inventory/hosts

# Access the extracted information
for section in "${!server_info[@]}"; do
  # Extract IP and username from the key
  ip_address="${section##*,}"  # Remove section name using parameter expansion
  username="${server_info[$section]}"

  # echo "Section: $section"
  echo "  Username: $username"
  echo "  IP Address: $ip_address"
  echo
done
