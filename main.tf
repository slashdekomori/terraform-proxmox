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
}

module "vms" {
  source         = "./vms"
  vm_password    = var.vm_password
  ssh_keys       = var.ssh_keys
  debian13-image = var.debian13-image
}
