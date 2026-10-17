variable "image_file_id" { type = string }
variable "node_name" { type = string }
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
variable "template_id" {
  type    = number
  default = null
}

variable "disk_datastore_id" { type = string }
variable "snippet_datastore_id" { type = string }


variable "ipv4_address" {
  type    = string
  default = null
}
variable "ipv4_gateway" {
  type    = string
  default = null
}
variable "vlan_id" {
  type    = string
  default = null
}

variable "user_name" { type = string }
variable "user_password" { type = string }
variable "ssh_public_keys" { type = list(string) }
variable "timezone" {
  type = string
}
