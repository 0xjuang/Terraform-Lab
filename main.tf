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
# ------------------------------------------------------------------------------

# Configure the required provider for this module.
# In this case, we're using a locally sourced version of the Xen Orchestra provider.
# If publishing or sharing, adjust the source to the public registry if needed.
terraform {
  required_providers {
    xenorchestra = {
      source  = "registry.local/local/xenorchestra"  # Local provider source path
      version = "0.31.3"                             # Exact version pin for reproducibility
    }
  }
}

# Provider block for XO API access
provider "xenorchestra" {
  url   = "ws://<XO_SERVER_IP_OR_HOSTNAME>"  # Replace with your XO server's WebSocket URL
  token = var.xo_token         # Secure token from tfvars
}

# Select the default storage repository (SR)
data "xenorchestra_sr" "default" {
  name_label = "Local storage"  # Match this to your actual SR label
}

# Select the base template to clone from
data "xenorchestra_template" "debian" {
  name_label = "Minimal_Template"  # Should be a cloud-init compatible template
}

# Select the network to attach to the VM
data "xenorchestra_network" "default" {
  name_label = "Pool-wide network associated with eth0"  # Use your network label
}

# VM resource declaration
resource "xenorchestra_vm" "devvm" {
  name_label = var.vm_name
  template   = data.xenorchestra_template.debian.id

  # Render and inject cloud-init template
  cloud_config = templatefile("${path.module}/cloudinit.yaml.tpl", {
    hostname      = var.hostname
    username      = var.vm_user
    password_hash = var.user_password_hash
  })

  hvm_boot_firmware = "uefi"  # Enables UEFI boot firmware (required for some OS)

  cpus        = var.cpu
  memory_max  = var.memory_gb * 1024 * 1024 * 1024  # Convert GB to bytes

  # Disk definition
  disk {
    sr_id      = data.xenorchestra_sr.default.id
    name_label = "${var.vm_name}-disk"
    size       = var.disk_gb * 1024 * 1024 * 1024  # Convert GB to bytes
  }

  # Network adapter attachment
  network {
    network_id = data.xenorchestra_network.default.id
  }
}
