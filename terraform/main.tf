locals {
  templates            = jsondecode(file("${path.root}/../shared/templates.json"))
  debian13_template_id = local.templates.debian13_template_id
  default_template_id  = local.debian13_template_id

  vms = {
    mega-test-vm1 = {}
  }
}

module "vm" {
  source   = "./modules/vm"
  for_each = local.vms

  node_name     = try(each.value.node_name, var.default_node_name)
  vm_id         = try(each.value.vm_id, null)
  datastore_id  = try(each.value.datastore_id, var.default_datastore_id)
  vm_name       = try(each.value.vm_name, each.key)
  image_file_id = try(each.value.image_file_id, null)
  template_id   = try(each.value.image_file_id, local.default_template_id, null)


  user_name       = try(each.value.user_name, var.default_user_name)
  user_password   = try(each.value.user_password, var.default_user_password)
  ssh_public_keys = var.ssh_public_keys
  timezone        = try(each.value.timezone, var.default_timezone)
}

# module "vm_template" {
#   source   = "./modules/vm_template"
#   for_each = local.vm_templates
#
#   node_name    = try(each.value.node_name, var.default_node_name)
#   vm_id        = try(each.value.vm_id, null)
#   datastore_id = try(each.value.datastore_id, var.default_datastore_id)
#   vm_name      = try(each.value.vm_name, each.key)
#   image_file_id   = try(each.value.image_file_id, null)
#   template_id     = try(each.value.image_file_id, local.default_template_id, null)
#   user_name       = try(each.value.user_name, var.init_user_name)
#   user_password   = try(each.value.user_password, var.init_user_password)
#   ssh_public_keys = var.init_ssh_public_keys
# }


