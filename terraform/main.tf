locals {
  templates           = jsondecode(file("${path.root}/../shared/templates.json"))
  default_template_id = local.templates.debian13_template_id
}

module "vm" {
  source   = "./modules/vm"
  for_each = var.vms

  vm_name = each.key
  vm_id   = each.value.vm_id

  node_name            = coalesce(each.value.node_name, var.defaults.node_name)
  disk_datastore_id    = coalesce(each.value.disk_datastore_id, var.defaults.disk_datastore_id)
  snippet_datastore_id = coalesce(each.value.snippet_datastore_id, var.defaults.snippet_datastore_id)

  image_file_id = each.value.image_file_id
  template_id   = each.value.image_file_id != null ? null : coalesce(each.value.template_id, local.default_template_id)

  cores     = each.value.cores
  socket    = each.value.socket
  memory    = each.value.memory
  disk_size = each.value.disk_size

  ipv4_address = each.value.ipv4_address
  ipv4_gateway = each.value.ipv4_gateway
  vlan_id      = each.value.vlan_id

  user_name       = coalesce(each.value.user_name, var.defaults.user_name)
  user_password   = coalesce(each.value.user_password, var.defaults.user_password)
  ssh_public_keys = coalesce(each.value.ssh_public_keys, var.defaults.ssh_public_keys)
  timezone        = coalesce(each.value.timezone, var.defaults.timezone)
}
