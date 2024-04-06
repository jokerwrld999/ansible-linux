#!/bin/bash

function key_exists() {
  local username="$1"
  local ip_address="$2"
  local key_file="$3"
  ssh -o ConnectTimeout=5 -q $username@$ip_address "grep \"$(cat ~/.ssh/$key_file)\" ~/.ssh/authorized_keys" &> /dev/null
  if [[ $? -eq 0 ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# 1. Generate the default SSH key
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "Default key"
fi

read -p "Enter the username for the server (default: root): " username
read -p "Enter the server IP address: " ip_address
username=${username:-root}  # Set default username to root if none provided

for key_file in "id_ed25519.pub" "ansible.pub"; do
  key_exists_status=$(key_exists "$username" "$ip_address" "$key_file")

  if [[ "$key_exists_status" == "true" ]]; then
    echo "Key '$key_file' already authorized."
  else
    echo "Copying '$key_file'"
    ssh-copy-id -i ~/.ssh/"$key_file" "$username@$ip_address"
  fi
done

echo "SSH key setup completed!"