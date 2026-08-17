variable "cloud_image_url" {
  description = "Cloud image url"
  type        = string
}
variable "node_name" { type = string }
variable "datastore_id" { type = string }
variable "vm_name" { type = string }
variable "vm_id" { type = number }
variable "disk_size" {
  type    = number
  default = 20
}
variable "cores" {
  type    = number
  default = 1
}
variable "socket" {
  type    = number
  default = 1
}
variable "memory" {
  type    = number
  default = 1024
}
variable "user_data_file_id" {
  type = string
}
