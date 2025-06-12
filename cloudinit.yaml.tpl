#cloud-config
# ------------------------------------------------------------------------------
# File: cloudinit.yaml.tpl
# Description: Cloud-init template used by Terraform to provision and configure
#              a VM on XCP-ng via Xen Orchestra (XO).
# 
# Template Engine: Terraform's templatefile() function
# Template Variables:
#   - ${hostname}: The hostname and FQDN of the VM
#   - ${username}: The name of the user to create
#   - ${password_hash}: The hashed password for the user (SHA-512)
#
# Author: Juan J Garcia (0x1G)
# Created: 2025-06-12
# License: MIT
# ------------------------------------------------------------------------------
# Note: This file must begin with '#cloud-config' for cloud-init to process it.
#       Make sure the rendered template passes indentation checks (YAML strict).
# ------------------------------------------------------------------------------

# Set the system hostname and control whether it's preserved
preserve_hostname: false
hostname: ${hostname}         # Sets the short hostname
fqdn: ${hostname}             # Sets the full hostname (e.g., hostname.local)
manage_etc_hosts: true        # Ensures /etc/hosts is updated with hostname

# Define a user with sudo privileges and shell access
users:
  - name: ${username}
    groups: sudo
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: false
    passwd: "${password_hash}"  # SHA-512 password hash generated via openssl

# Enable SSH password authentication for this user
ssh_pwauth: true
disable_root: true            # Disables root login to enforce user use

# Do not expire the user's password on first login
chpasswd:
  expire: false

# Update package index and install essential packages
package_update: true
packages:
  - curl
  - git
  - vim
  - zsh
  - python3
  - python3-pip
  - python3-venv
  - most                 # Terminal pager alternative to less
  - bat                  # A cat clone with syntax highlighting

# Run a basic initialization script to test Python and log output
runcmd:
  - cd /home/${username}
  - git clone https://github.com/0xjuang/gtop.git
  - cd /home/${username}/gtop
  - python3 -m venv venv
  - ./venv/bin/pip install psutil prettytable
  - chmod +x gtop.py
  - ./venv/bin/python gtop.py > /home/${username}/snapshot.log 2>&1
  - chown -R ${username}:${username} /home/${username}
  - batcat /home/${username}/snapshot.log

# Final log message shown after cloud-init finishes
final_message: "cloud-init completed at $TIMESTAMP"
