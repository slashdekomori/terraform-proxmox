variable "image_file_id" { type = string }
variable "node_name" { type = string }
variable "datastore_id" { type = string }
variable "vm_name" { type = string }
variable "vm_id" {
  type    = number
  default = null
}
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
variable "ssh_public_keys" {
  type = list(string)
}
variable "username" {
  type    = string
  default = "origin"
}
