# ------------------------------------------------------------------------------
# File: main.tf
# Description: Terraform configuration to provision a virtual machine on XCP-ng
#              via Xen Orchestra (XO) using a cloud-init template.
#
# Author: Juan J Garcia (0x1G)
# Created: 2025-06-12
# License: MIT
# Notes:
#   - Requires Xen Orchestra running and reachable via WebSocket.
#   - Cloud-init config is passed in via templatefile().
#   - Designed for modular reuse with tfvars and automation tools like CI/CD.
# ------------------------------------------------------------------------------

terraform {
  required_providers {
    xenorchestra = {
      source  = "registry.local/local/xenorchestra"    # Custom/local registry path for the XO provider
      version = "0.31.3"                               # Pin version for reproducibility
    }
  }
}

# Configure the Xen Orchestra provider
provider "xenorchestra" {
  url   = var.xo_url      # WebSocket URL for XO API (e.g. ws://xo.local:443)
  token = var.xo_token    # XO API token (set securely via tfvars or env)
}

# Lookup the default Storage Repository (SR) by name
data "xenorchestra_sr" "default" {
  name_label = "Local storage"    # Replace with actual SR label in your environment
}

# Lookup the VM template to clone — must be cloud-init enabled and cleaned
data "xenorchestra_template" "debian" {
  name_label = var.xo_template    # e.g. "Tmpl-Debian12-CloudInit"
}

# Lookup the virtual network by name — usually tied to "eth0"
data "xenorchestra_network" "default" {
  name_label = "Pool-wide network associated with eth0"    # Adjust to match your infra
}

# Main VM resource definition
resource "xenorchestra_vm" "devvm" {
  count             = var.vm_count                                       # Number of VMs to be created
  name_label        = format("%s-%02d", var.vm_name, count.index + 1)    # Name of the deployed VM
  name_description  = var.vm_description                                 # Optional description shown in XO
  template          = data.xenorchestra_template.debian.id               # Clone from selected template

  # Inject rendered cloud-init configuration
  cloud_config = templatefile("${path.module}/cloudinit.yaml.tpl", {
    hostname      = format("%s-%02d", var.hostname, count.index + 1)    # Set VM hostname
    username      = var.vm_user                                         # Default user to create
    password_hash = var.user_password_hash                              # Securely hashed password (SHA-512 recommended)
  })

  hvm_boot_firmware = "uefi"    # Enable UEFI boot (recommended for modern distros)

  cpus       = var.cpu                               # Number of virtual CPUs
  memory_max = var.memory_gb * 1024 * 1024 * 1024    # Memory in bytes (GB to B)

  # Define the root disk for the VM
  disk {
    sr_id      = data.xenorchestra_sr.default.id                         # Storage location
    name_label = format("%s-%02d-disk", var.vm_name, count.index + 1)    # Disk label for visibility in XO
    size       = var.disk_gb * 1024 * 1024 * 1024                        # Disk size in bytes (GB to B)
  }

  # Attach the network interface
  network {
    network_id = data.xenorchestra_network.default.id    # Connect to default network
  }

  # Optional metadata for filtering, visibility, or automation hooks
  tags = ["terraform", "dev", "cloud-init"]
}

