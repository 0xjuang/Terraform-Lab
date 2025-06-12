# terraform-xo-vm

Provision and manage virtual machines on XCP-ng using Terraform and the Xen Orchestra (XO) API.  
This project provides a repeatable, infrastructure-as-code approach to deploying VMs with cloud-init on a self-hosted hypervisor.

---

## Overview

This repository automates the creation of a virtual machine on an XCP-ng hypervisor via Xen Orchestra. It leverages Terraform and a cloud-init configuration to customize the VM at boot.

Included features:
- XO WebSocket API integration
- cloud-init YAML templating
- Customizable CPU, memory, and disk allocation
- User setup with password hash
- Post-deploy package install and test script execution

---

## Prerequisites

- Terraform v1.3 or later
- A running Xen Orchestra instance
- A cloud-init compatible template in XO (Debian, Ubuntu, etc.)
- XO API token for authentication
- Functional WebSocket access to XO (ws:// or wss://)

---

## Setup Instructions

### 1. Clone the repository

```
git clone https://github.com/0xjuang/terraform-xo-vm.git
cd terraform-xo-vm
```

### 2. Configure your variables

Edit the provided `terraform.tfvars` file:

```
vi terraform.tfvars
```

Replace the placeholder values with your actual:
- `xo_token`: XO API token (from the XO UI)
- `user_password_hash`: SHA-512 hash generated via `openssl passwd -6`
- `xo_url`: Your XO server’s WebSocket URL (e.g. `ws://192.168.1.100`)
- VM parameters: `vm_name`, `vm_user`, `hostname`, `cpu`, `memory_gb`, `disk_gb`

The file already exists in the repo — no need to rename or copy it.

---

## Usage

Initialize Terraform and apply the configuration:

```
terraform init
terraform plan
terraform apply
```

Terraform will create the VM, attach the configured storage and network, and pass in the rendered cloud-init template.

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
terraform-xo-vm/
├── main.tf                 # Terraform logic and VM declaration
├── variables.tf            # Input variables used by Terraform
├── terraform.tfvars        # Default variable values to be customized
├── cloudinit.yaml.tpl      # Cloud-init config template injected at VM creation
├── LICENSE                 # MIT license
├── README.md               # Project documentation
```

---

## License

MIT License  
Copyright (c) 2025 Juan Garcia

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files...

(Full license text is available in the LICENSE file)
