# XO API token used to authenticate with the Xen Orchestra server
# Marked sensitive to avoid exposing in CLI or logs
variable "xo_token" {
  type      = string
  sensitive = true
}

# SHA-512 hashed password for the VM user created via cloud-init
# Example: generated using `openssl passwd -6`
variable "user_password_hash" {
  description = "SHA512-hashed user password for cloudadmin"
  type        = string
  sensitive   = true
}

# Web socket for Xen Orchestra server
variable "xo_url" {
    description = "Web socket URL"
    type        = string
}

# Name or UUID of the Xen Orchestra template to use
variable "xo_template" {
  description = "Name or UUID of the template VM in XO to use as a base"
  type        = string
}

# Optional description to assign to the virtual machine.
# This appears in XO/XCP-ng as the VM's description field.
# You can override this via tfvars, or leave the default.
variable "vm_description" {
  description = "Optional description of the VM"
  type        = string
  default     = "Provisioned by Terraform via XO"
}

variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
  default     = 1  # Safe default; can be overridden in terraform.tfvars
}

# The name of the virtual machine as it will appear in XO/XCP-ng
variable "vm_name" {
  description = "Name of the VM to create"
  type        = string
  default     = "dev-vm"
}

# Username to be created on the VM using cloud-init
# This user typically has sudo access
variable "vm_user" {
  description = "Username for the cloud-init user"
  type        = string
  default     = "cloudadmin"
}

# Hostname to assign to the VM (used by cloud-init and system configuration)
variable "hostname" {
  description = "Hostname of the VM"
  type        = string
}

# Number of virtual CPUs to allocate to the VM
variable "cpu" {
  description = "Number of vCPUs"
  type        = number
  default     = 1
}

# Amount of RAM to allocate, in gigabytes
variable "memory_gb" {
  description = "RAM in GB"
  type        = number
  default     = 2
}

# Size of the VM's disk in gigabytes
variable "disk_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 16
}

