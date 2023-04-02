# Linux Automation With Ansible

Provision your Linux Servers and Desktops with this playbook.

# Setting up a Managed node

1. Configure SSH Key-Based Authentication

2. Select SSH Key in ansible.cfg

# Setting up a Control node

* Modify the variables in inventory/hosts

```
[server]
#Server IP

[workstation]
#Workstation IP
```

* !!! Modify the variables in vars/main.yml

* Ensure that Ansible is installed on your Linux execute the following command:

```
ansible-playbook local.yml
```
