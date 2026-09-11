locals {
  default_image_file_id = proxmox_download_file.debian-13-genericcloud-amd64.id

  vms = {
    test-vm1 = {}
  }

  vm_templates = {
    debian13-base = { image_file_id = proxmox_download_file.debian-13-genericcloud-amd64.id }
  }
}

resource "proxmox_download_file" "debian-13-genericcloud-amd64" {
  content_type        = "import"
  datastore_id        = var.default_image_datastore_id
  node_name           = var.default_node_name
  url                 = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
  overwrite_unmanaged = true
}

module "vm_template" {
  source   = "../modules/vm_template"
  for_each = local.vm_templates

  node_name       = try(each.value.node_name, var.default_node_name)
  vm_id           = try(each.value.vm_id, null)
  datastore_id    = try(each.value.datastore_id, var.default_datastore_id)
  vm_name         = try(each.value.vm_name, each.key)
  image_file_id   = try(each.value.image_file_id, local.default_image_file_id)
  ssh_public_keys = var.ssh_public_keys
}

module "vm" {
  source   = "../modules/vm"
  for_each = local.vms

  node_name     = try(each.value.node_name, var.default_node_name)
  vm_id         = try(each.value.vm_id, null)
  datastore_id  = try(each.value.datastore_id, var.default_datastore_id)
  vm_name       = try(each.value.vm_name, each.key)
  image_file_id = try(each.value.image_file_id, local.default_image_file_id)

  user_name       = try(each.value.user_name, var.default_user_name)
  user_password   = try(each.value.user_password, var.default_user_password)
  ssh_public_keys = var.ssh_public_keys
  timezone        = try(each.value.timezone, var.default_timezone)
}
