variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_node" {
  type    = string
  default = "psyche"
}

variable "debian13_vm_id" {
  type    = number
  default = 9000
}

variable "ssh_private_key_file" {
  type = string
}
