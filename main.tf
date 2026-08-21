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

resource "proxmox_download_file" "debian-13-genericcloud-amd64" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "psyche"
  url          = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
}

locals {
  default_datastore = "slow"
  default_node_name = "psyche"

  vms = {
    test_vm_1 = { vm_id = 9100 }
    test_vm_2 = { vm_id = 9200 }
  }

  templates = {
    debian13_template_1 = { vm_id = 9100 }
  }
}

module "vm_template" {
  source   = "./modules/vm-template"
  for_each = local.templates

  node_name       = try(each.value.datastore_id, local.default_node_name)
  vm_id           = each.value.vm_id
  datastore_id    = try(each.value.datastore_id, local.default_datastore)
  vm_name         = try(each.value.vm_name, each.key)
  cloud_image_id  = proxmox_download_file.debian-13-genericcloud-amd64.id
  ssh_public_keys = var.ssh_public_keys
  user_password   = var.user_password
  user_name       = var.user_name
  timezone        = var.timezone
}

module "vm" {
  source   = "./modules/vm"
  for_each = local.vms

  node_name       = try(each.value.datastore_id, local.default_node_name)
  vm_id           = each.value.vm_id
  datastore_id    = try(each.value.datastore_id, local.default_datastore)
  vm_name         = try(each.value.vm_name, each.key)
  cloud_image_id  = proxmox_download_file.debian-13-genericcloud-amd64.id
  ssh_public_keys = var.ssh_public_keys
  user_password   = var.user_password
  user_name       = var.user_name
  timezone        = var.timezone
}
