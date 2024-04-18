# Linux Automation With Ansible

Provision your Linux Servers and Desktops with this playbook.

## Pre-commit Commands

```
pre-commit install
pre-commit run -a -c .config/.pre-commit-config.yaml
```

## Setting SSH Key-Based Authentication

1. Generate an ssh key

```
ssh-keygen -t ed25519 -C "Default key"
```

2. Copy the ssh key to the server(s)

```
ssh-copy-id -i ~/.ssh/id_ed25519.pub <IP Address>
```

3. Generate an ssh key that’s going to be specifically used for Ansible

```
ssh-keygen -t ed25519 -C "ansible"
```

4. Copy the ssh key to the server(s)

```
ssh-copy-id -i ~/.ssh/ansible.pub <IP Address>
```

## Export Env Variables

- Export Environment Variables

```
export CUSTOM_USER=
```

- OR Modify the variables in `roles/pre-configure/vars/main.yml`

## Create Vault Pass

- Create `.vault_pass` file with password to decrypt Telegram Bot Tokens to use
  Telegram Alerts

## Run Ansible Playbooks

- Ensure that Ansible is installed on your Linux execute the following commands:

```
ansible-galaxy install -r requirements.yml &&
ansible-playbook local.yml
```
