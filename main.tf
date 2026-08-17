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

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "psyche"

  source_file {
    path      = "${path.module}/cloud-init/user-data.yaml"
    file_name = "user-data-cloud-config.yaml"
  }
}

# module "vm" {
#   source = "./modules/vm-template"
#
#   # Pass the uploaded snippet ID into the module
#   user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
#
#   # ... other variables
# }

module "debian13_template" {
  source = "./modules/vm-template"

  node_name       = "psyche"
  vm_id           = 9100
  datastore_id    = "slow"
  vm_name         = "debian13-template"
  user_data_file_id = 
  cloud_image_url = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
}
