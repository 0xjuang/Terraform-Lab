# Xen Orchestra (XO) API token
# Generate this in the XO web UI under your account settings.
xo_token = "INSERT_YOUR_XO_API_TOKEN_HERE"

# User password hash (SHA-512)
# Generate using:
# $ openssl passwd -6
user_password_hash = "INSERT_YOUR_SHA512_PASSWORD_HASH_HERE"

# VM Configuration
vm_name  = "your-vm-name"          # Name of the VM in XO/XCP-ng
vm_user  = "your-username"         # The main user account created via cloud-init
hostname = "your-vm-hostname"      # Internal VM hostname

# VM Resources
cpu        = 2                     # Number of vCPUs
memory_gb  = 4                     # RAM in GB
disk_gb    = 40                    # Disk size in GB
