# Personal Ansible Desktop Configs

I use Ansible to configure all of my desktops, laptops, and servers. I use the Ansible Pull method. It's fully automated, and scripts everything from system services to desktop environment settings.

## How does it work?
As mentioned above, it uses Ansible pull, so some familiarity with that is required. I use Ansible in "pull-mode" because it handles the dynamic nature of laptops and desktops better.

The folder structure breaks down like this:

**local.yml**: This is the Playbook that Ansible expects to find by default in pull-mode, think of it as an "index" of sorts that pulls other Playbooks in.

**ansible.cfg**: Configuration settings for Ansible goes here.

**inventory**: This is the inventory file. Even in pull-mode, an inventory file can be used. This is how Ansible knows what group to put a machine in.

**playbooks**: Additional playbooks that I may want to run, or have triggered.

**roles/**: This directory contains my base, workstation, and server roles. Every host gets the base role. Then either 'workstation' or 'server', depending on what it is.

**roles/base**: This role is for every host, regardles of the type of device it is. This role contains things that are intended to be on every host, such as default configs, users, etc.

**roles/workstation**: After the base role runs on a host, this role runs only on hosts that are designated to be workstations. GUI-specific things, such as GUI apps (Firefox, etc), Flatpaks, wallpaper, etc. Has a folder for the KDE desktop.

**roles/server**: After the base role runs on a host, this role runs only on hosts designated as servers. Monitoring plugins, unattended-updates, server firewall rules, and other server-related things are configured here.

After it's run for the first time manually, this Ansible config creates its own Cronjob for itself on that machine so you never have to run it manually again going forward, and it will track all future commits and run them against all your machines as soon as you commit a change. You can find the playbook for Cron in the base role.

## How do I run it?

ansible-pull -U https://github.com/jokerwrld999/ultimate-ansible.git
