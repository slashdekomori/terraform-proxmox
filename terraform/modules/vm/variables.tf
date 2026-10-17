variable "node_name" { type = string }
variable "vm_name" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$", var.vm_name))
    error_message = "vm_name must be a valid lowercase hostname."
  }
}
variable "vm_id" {
  type    = number
  default = null
}

variable "image_file_id" {
  type    = string
  default = null
}
variable "template_id" {
  type    = number
  default = null
  validation {
    condition     = (var.template_id == null) != (var.image_file_id == null)
    error_message = "Set exactly one of template_id or image_file_id."
  }
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
variable "disk_size" {
  type    = number
  default = 20
}

variable "disk_datastore_id" { type = string }
variable "snippet_datastore_id" { type = string }

variable "ipv4_address" {
  type    = string
  default = null
  validation {
    condition     = var.ipv4_address == null || can(cidrhost(var.ipv4_address, 0))
    error_message = "ipv4_address must be CIDR notation, e.g. 10.0.0.50/24."
  }
}
variable "ipv4_gateway" {
  type    = string
  default = null
  validation {
    condition     = var.ipv4_address == null || var.ipv4_gateway != null
    error_message = "ipv4_gateway is required when ipv4_address is set."
  }
}
variable "vlan_id" {
  type    = number
  default = null
}

variable "user_name" { type = string }
variable "user_password" {
  type      = string
  default   = null
  sensitive = true
}
variable "ssh_public_keys" { type = list(string) }
variable "timezone" {
  type    = string
  default = "UTC"
}
