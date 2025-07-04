# Terraform-Lab

Provision and manage virtual machines on XCP-ng using Terraform and the Xen Orchestra (XO) API.  
This project provides a repeatable, infrastructure-as-code approach to deploying VMs with cloud-init on a self-hosted hypervisor.

---

## Overview

This repository automates the creation of virtual machines on an XCP-ng hypervisor via Xen Orchestra. It leverages Terraform and a cloud-init configuration to customize each VM at boot.

Included features:
- XO WebSocket API integration
- cloud-init YAML templating
- Customizable CPU, memory, and disk allocation
- Multi-VM provisioning via `count`
- User setup with password hash
- Post-deploy package install and test script execution

---

## Prerequisites

- Terraform v1.3 or later
- A running Xen Orchestra instance
- A cloud-init compatible template in XO (Debian, Ubuntu, etc.)
- XO API token for authentication
- Functional WebSocket access to XO (`ws://` or `wss://`)

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/0xjuang/terraform-lab.git
cd terraform-xo-vm
```

### 2. Configure your variables

Copy and edit the provided `terraform.tfvars.tpl` file:

```bash
cp terraform.tfvars.tpl terraform.tfvars
vi terraform.tfvars
```

Replace the placeholder values with your actual:
- `xo_token`: XO API token (from the XO UI)
- `user_password_hash`: SHA-512 hash generated via `openssl passwd -6`
- `xo_url`: Your XO server’s WebSocket URL (e.g. `ws://192.168.1.100`)
- `xo_template`: Name or UUID of your XO cloud-init enabled template
- `vm_description`: Optional VM description in XO
- `vm_count`: Number of VMs to create (default is 1)
- `vm_name`, `vm_user`, `hostname`: Naming for the VMs and users
- `cpu`, `memory_gb`, `disk_gb`: VM resource specs

> ⚠️ The `.tpl` file is a safe example — you must copy it to `terraform.tfvars` before applying.  
> Terraform will ignore `.tpl` files by default.

---

## Usage

Initialize Terraform and apply the configuration:

```bash
terraform init
terraform plan
terraform apply
```

Terraform will create one or more VMs, attach the configured storage and network, and pass in the rendered cloud-init template.

---

## ⚠️ Resource Warning

Creating multiple VMs consumes CPU, RAM, and storage on your XCP-ng host.  
Ensure your system has enough free resources before setting `vm_count > 1`.

Example:

```
3 VMs × 2GB RAM = 6GB required (plus OS and hypervisor overhead)
```

To avoid overprovisioning:
- Start with `vm_count = 1`
- Disable `auto_poweron` if testing multiple VMs
- Monitor host resources in Xen Orchestra

---

## Troubleshooting

### Connection refused to XO API

- Ensure XO is running and accessible at the specified WebSocket address.
- Confirm port and protocol (usually `ws://` or `wss://`).
- Check firewalls or network routing.

### Provider error: registry.local/local/xenorchestra

- This configuration uses a local provider source.
- You must have the `xenorchestra` provider installed locally at:
  `~/.terraform.d/plugins/registry.local/local/xenorchestra/<version>/`
- Alternatively, adjust the `source` block to use a public registry provider if available.

### cloud-init did not apply

- Ensure your XO template is configured with cloud-init support.
- Check that no legacy configuration interferes with cloud-init on boot.
- Validate `cloudinit.yaml.tpl` using a YAML linter before applying.

### SSH not working

- Ensure `ssh_pwauth: true` is set in cloud-init.
- Confirm the created user matches `vm_user` and has a valid password hash.
- Verify SSH port access on the network.

---

## File Structure

```
terraform-lab/
├── main.tf                 # Terraform logic and VM declaration
├── variables.tf            # Input variables used by Terraform
├── terraform.tfvars.tpl    # Example tfvars file (copy and edit before applying)
├── cloudinit.yaml.tpl      # Cloud-init config template injected at VM creation
├── LICENSE                 # MIT license
├── README.md               # Project documentation
```

---

## License

MIT License  
© 2025 Juan J Garcia

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files...

(Full license text is available in the LICENSE file)
