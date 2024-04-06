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
      break  # Exit the loop after successful installation
    else
      echo "Package $sshpass_package already exists."
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

read -p "Enter the username for the server (default: root): " username
read -p "Enter the password for the server: " password
read -p "Enter the server IP address: " ip_address
username=${username:-root}  # Set default username to root if none provided

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

  if [[ "$key_exists_status" == "true" ]]; then
    echo "Key '$key_file.pub' already authorized."
  else
    echo "Copying '$key_file.pub'..."
    echo "$password" | sshpass ssh-copy-id -i "/home/jokerwrld/.ssh/$key_file.pub" $username@$ip_address &> /dev/null
  fi
done

echo "SSH key setup completed!"