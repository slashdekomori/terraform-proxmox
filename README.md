# terraform-proxmox

Proxmox VE VM provisioning pipeline. A Debian 13 cloud image is turned into a
bootable base template, baked into a golden template, and then cloned into
working VMs — each stage handled by a dedicated tool.

## How it fits together

```
shared/templates.json          fixed VM IDs shared by all stages
        │
        ▼
ansible/                       download Debian cloud image, customize it
  roles/golden_image           offline with virt-customize, import as a
                               Proxmox template  ──►  template 9000
        │
        ▼
packer/                        clone 9000, boot it, run provisioning,
  debian13.pkr.hcl             reset cloud-init  ──►  golden template 9100
        │
        ▼
terraform/                     clone the golden template and stamp out
  main.tf                      VMs (k3s-master, k3s-worker1/2, ...)
```

Each stage consumes the artifact of the previous one, and VM IDs are kept in
sync through `shared/templates.json` so the tooling never guesses.

## Layout

| Path | Purpose |
| --- | --- |
| `shared/templates.json` | Fixed Proxmox VM IDs (`debian13_template_id`, `debian13_golden_template_id`) read by Ansible, Packer, and Terraform. |
| `ansible/` | Builds the base template from a Debian cloud image. |
| `ansible/roles/golden_image/` | Reusable role: download image, `virt-customize` it offline, import to Proxmox, convert to template. |
| `packer/` | Builds the golden template by cloning the base template and provisioning it. |
| `terraform/` | Declarative VM definitions that clone the golden template. |
| `terraform/modules/vm/` | Module for a cloneable, cloud-init driven VM. |
| `terraform/modules/vm_template/` | Module variant that produces a template instead of a running VM (currently unused). |
| `terraform/modules/image/` | Downloads an image file to a Proxmox datastore for import-style boot. |

## Prerequisites

- A Proxmox VE node reachable over SSH (inventory defaults to `psyche` at `10.0.0.100`).
- Ansible with the `community.general` collection, plus `libguestfs-tools` for `virt-customize`.
- [Packer](https://developer.hashicorp.com/packer) with the `github.com/hashicorp/proxmox` plugin.
- [Terraform](https://developer.hashicorp.com/terraform) `>= 1.15.1` and the [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox) provider.
- An SSH key pair whose public key is injected into the guests.

## Stage 1 — Base template (Ansible)

```sh
cd ansible
ansible-playbook playbooks/debian13.yml
```

The playbook pulls `debian-13-generic-amd64.qcow2`, injects `qemu-guest-agent`
offline, resets `machine-id`/SSH host keys/cloud-init, imports the disk into
the `slow` datastore, and converts the VM to a template. The target VM ID comes
from `debian13_template_id` in `shared/templates.json` (currently `9000`).

Distro-specific values live directly in the playbook (`distro`, `image_url`,
`template_name`, `template_id_key`); everything else has sane defaults in
`roles/golden_image/defaults/main.yml`.

## Stage 2 — Golden template (Packer)

```sh
cd packer
packer init .
packer build -var-file=packer.auto.pkrvars.hcl debian13.pkr.hcl
```

Packer clones template `9000` into `9100`, boots it, waits for cloud-init,
installs extra packages, then cleans cloud-init state and SSH host keys before
converting it back to a template. Supply the Proxmox API URL/token and your
private key path via a `packer.auto.pkrvars.hcl` file (git-ignored).

| Variable | Description |
| --- | --- |
| `proxmox_api_url` | Proxmox API endpoint. |
| `proxmox_api_token_id` / `proxmox_api_token_secret` | API token credentials. |
| `proxmox_node` | Target node (default `psyche`). |
| `ssh_user_name` | Cloud-init user Packer connects as (default `init`). |
| `ssh_private_key_file` | Private key for the build VM. |

## Stage 3 — VMs (Terraform)

```sh
cd terraform
terraform init
terraform plan
terraform apply
```

VMs are declared as a map in `terraform/main.tf`; each key becomes a VM name and
`for_each` expands the map into `module.vm` instances:

```hcl
vms = {
  k3s-master   = { cores = 2, memory = 2048 },
  k3s-worker1  = { cores = 2, memory = 2048 },
  k3s-worker2  = { cores = 2, memory = 2048 },
  test-monitor = { cores = 2, memory = 2048 }
}
```

Each clone boots with a generated cloud-init snippet that sets the hostname,
timezone, user/password, SSH keys, and installs `qemu-guest-agent` and
`docker.io` (see `terraform/modules/vm/templates/cloud_init.yaml.tftpl`).

### Terraform variables

Copy the values below into a git-ignored `terraform.tfvars` and fill in your own.

| Variable | Description | Default |
| --- | --- | --- |
| `proxmox_endpoint` | Proxmox API endpoint. | — |
| `proxmox_api_token` | API token (sensitive). | — |
| `proxmox_password` | SSH password for the provider (sensitive). | — |
| `proxmox_insecure` | Skip TLS verification. | `true` |
| `default_node_name` | Proxmox node. | `psyche` |
| `default_datastore_id` | Datastore for disks/cloud-init. | `slow` |
| `default_user_name` | Guest user. | `dekomori` |
| `default_user_password` | Guest password (sensitive). | — |
| `ssh_public_keys` | Authorized keys for guests. | — |
| `default_timezone` | Guest timezone. | `Europe/Moscow` |
| `init_user_name` / `init_user_password` / `init_ssh_public_keys` | Credentials used by the `vm_template` module. | `init` / — / — |

## Notes

- `shared/templates.json` is the single source of truth for template VM IDs.
- `terraform/terraform.tfvars`, `packer.auto.pkrvars.hcl`, `*.qcow2`, and all
  state/lock files are git-ignored. Never commit credentials or tokens.
- The `terraform` state is local by default; use a remote backend before
  sharing the project or working from multiple machines.
