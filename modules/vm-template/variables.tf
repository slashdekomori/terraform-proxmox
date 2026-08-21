variable "cloud_image_id" { type = string }
variable "node_name" { type = string }
variable "datastore_id" { type = string }
variable "vm_name" { type = string }
# TODO: Make optional, so if not specified will use any free id
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

variable "user_name" { type = string }
variable "user_password" { type = string }
variable "ssh_public_keys" { type = list(string) }
variable "timezone" {
  type = string
}
