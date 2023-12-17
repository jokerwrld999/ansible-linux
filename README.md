# Linux Automation With Ansible

Provision your Linux Servers and Desktops with this playbook.

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
ssh-copy-id -i ~/.ssh/ansible.pub
```

## Modify The Variables

- Modify the variables in inventory/hosts

```
[server]
#Server IP

[workstation]
#Workstation IP
```

- !!! Modify the variables in vars/main.yml

- Ensure that Ansible is installed on your Linux execute the following commands:

```
ansible-galaxy collection install -r requirements.yml;
ansible-playbook local.yml
```
