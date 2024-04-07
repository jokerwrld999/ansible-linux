#!/bin/bash

declare -A package_managers=(
  [pacman]="sudo pacman -S --noconfirm"
  [apt]="sudo apt install -y"
  [dnf]="sudo dnf install -y"
  [zypper]="sudo zypper -n install"
)

sshpass_package="sshpass"
for package_manager in "${!package_managers[@]}"; do
  if command -v $package_manager >/dev/null 2>&1; then
    if ! command -v $sshpass_package >/dev/null 2>&1; then
      eval "${package_managers[$package_manager]} $sshpass_package"
      echo "Packages installed using $package_manager."
      break
    else
      # echo "Package $sshpass_package already exists."
      break
    fi
  else
    echo "FAILED TO INSTALL PACKAGES: Package manager not found. You must manually install:"
    for config in "${packagesAndConfig[@]}"; do
      eval "echo $config"
    done
  fi
done

function key_exists() {
  local username="$1"
  local password="$2"
  local ip_address="$3"
  local key_file="$4"

  echo "$password" | sshpass ssh -o 'ConnectTimeout=5' -q $username@$ip_address "grep \"$(cat ~/.ssh/$key_file)\" ~/.ssh/authorized_keys" &> /dev/null

  if [[ $? -eq 0 ]]; then
    echo "true"
  else
    echo "false"
  fi
}

declare -A server_info

while IFS= read -r line; do
  ip_address=$(echo "$line" | awk '{print $1}')
  username=$(echo "$line" | awk '{print $2}' | cut -d "=" -f2)
  username=${username:-root}

  if [[ ! $ip_address =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
    continue
  elif ! ping -c1 -W1 $ip_address &> /dev/null; then
    echo "WARNING: Server $ip_address is not reachable. Skipping."
    continue
  fi

  server_info["$ip_address"]="$username"
done < ./inventory/hosts

read -p "Enter the password for the server: " password
echo
for server in "${!server_info[@]}"; do
  ip_address="${server}"
  username="${server_info[$server]}"

  for key_file in "id_ed25519" "ansible"; do
    if [ ! -f ~/.ssh/"$key_file" ]; then
      echo "Generating '$key_file'..."
      if [[ "$key_file" == "ansible.pub" ]]; then
        ssh-keygen -f ~/.ssh/"$key_file" -t ed25519 -C "Ansible" -N '""' -q
      else
        ssh-keygen -f ~/.ssh/"$key_file" -t ed25519 -C "Default key" -N '""' -q
      fi
    fi

    key_exists_status=$(key_exists "$username" "$password" "$ip_address" "$key_file.pub")

    echo "Provisioning server: $ip_address."
    if [[ "$key_exists_status" == "true" ]]; then
      echo "Key '$key_file.pub' already authorized."
    else
      echo "Copying '$key_file.pub'..."
      echo "$password" | sshpass ssh-copy-id -o 'StrictHostKeyChecking=no' -i "/home/jokerwrld/.ssh/$key_file.pub" $username@$ip_address &> /dev/null
    fi
    echo
  done
done

echo "SSH key setup completed!"