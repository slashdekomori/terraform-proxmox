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

variable "node_host" {
  type    = string
  default = "10.0.0.100"
}

variable "ssh_user_name" {
  type    = string
  default = "init"
}
variable "ssh_private_key_file" {
  type = string
}
