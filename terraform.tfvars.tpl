# Template file: terraform.tfvars.tpl
# Copy this to terraform.tfvars and fill in the required values before running:
#   cp terraform.tfvars.tpl terraform.tfvars

# Xen Orchestra (XO) API token
# Generate this in the XO web UI under your account settings.
xo_token = "INSERT_YOUR_XO_API_TOKEN_HERE"

# User password hash (SHA-512)
# Generate using:
# $ openssl passwd -6
user_password_hash = "INSERT_YOUR_SHA512_PASSWORD_HASH_HERE"

# Xen Orchestra (XO) web socket
xo_url = "INSERT_YOUR_XO_WEB_SOCKET"

# XO template name used for VM creation
# Must match a cloud-init enabled template VM in Xen Orchestra
xo_template = "INSERT_YOU_XO_TEMPLATE_NAME"

# XO Storage Repository (SR) to attach the virtual disk to
# Must match the name_label of an existing SR in XO (e.g., "Local storage")
xo_storage  = "INSERT_YOUR_XO_SR_NAME"

# XO virtual network to attach to the VM's NIC
# Must match the name_label of a network in XO (e.g., tied to eth0)
xo_network  = "INSERT_YOUR_XO_NETWORK_NAME"

# Description shown in XO for the VM (optional)
vm_description = "Provisioned by Terraform via XO"

# VM Configuration
vm_count = 1                            # Number of VMs to be created
vm_name  = "INSERT_YOUR_VM_NAME"        # Name of the VM in XO/XCP-ng
vm_user  = "INSERT_YOUR_VM_USERNAME"    # The main user account created via cloud-init
hostname = "INSERT_YOUR_VM_HOSTNAME"    # Internal VM hostname

# VM Resources
cpu        = INSERT_YOUR_CPU_COUNT    # Number of vCPUs
memory_gb  = INSERT_YOUR_RAM_SIZE     # RAM in GB
disk_gb    = INSERT_YOUR_DISK_SIZE    # Disk size in GB
