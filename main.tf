terraform {
  required_version = ">=1.15.1"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.80.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure

  ssh {
    agent    = true
    username = "root"
    password = var.proxmox_password
  }
}

module "debian13_template" {
  source = "./modules/vm-template"

  node_name       = "psyche"
  vm_id           = 9100
  datastore_id    = "slow"
  vm_name         = "debian13-template"
  cloud_image_url = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
}
