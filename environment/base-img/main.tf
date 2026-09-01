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

resource "proxmox_download_file" "debian-13-cloudimg" {
  content_type        = "import"
  datastore_id        = local.default_image_datastore_id
  node_name           = local.default_node_name
  url                 = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
  overwrite_unmanaged = true
}

locals {
  default_node_name          = "psyche"
  default_datastore_id       = "slow"
  default_image_datastore_id = "slow-files"

  vm_templates = {
    debian13-cloudimg-base = { vm_id = 9000, image_file_id = proxmox_download_file.debian-13-cloudimg.id }
  }
}

module "vm_template" {
  source   = "./modules/vm_template"
  for_each = local.vm_templates

  node_name       = try(each.value.node_name, local.default_node_name)
  vm_id           = each.value.vm_id
  datastore_id    = try(each.value.datastore_id, local.default_datastore_id)
  vm_name         = try(each.value.vm_name, each.key)
  image_file_id   = try(each.value.image_file_id, local.default_image_file_id)
  ssh_public_keys = var.init_ssh_public_key
}
