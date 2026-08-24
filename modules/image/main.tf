resource "proxmox_download_file" "image" {
  content_type        = import
  datastore_id        = var.datastore_id
  node_name           = var.node_name
  url                 = var.url
  overwrite_unmanaged = var.overwrite_unmanaged
}
output "file_id" { value = proxmox_download_file.image.id }
