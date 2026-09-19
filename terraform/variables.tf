variable "proxmox_endpoint" {
  description = "Proxmox VE API endpoint"
  type        = string
}
variable "proxmox_api_token" {
  description = "Proxmox VE API token"
  type        = string
  sensitive   = true
}
variable "proxmox_password" {
  description = "Proxmox VE password"
  type        = string
  sensitive   = true
}
variable "proxmox_insecure" {
  description = "Skip TLS verification for Proxmox API"
  type        = bool
  default     = true
}

variable "default_node_name" {
  type    = string
  default = "psyche"
}
variable "default_datastore_id" {
  type    = string
  default = "slow"
}
variable "default_image_datastore_id" {
  type    = string
  default = "slow-files"
}

variable "default_user_name" {
  type    = string
  default = "dekomori"
}
variable "default_user_password" {
  type      = string
  sensitive = true
}
variable "ssh_public_keys" {
  type = list(string)
}
variable "default_timezone" {
  type    = string
  default = "Europe/Moscow"
}

variable "init_user_name" {
  type    = string
  default = "init"
}
variable "init_user_password" {
  type      = string
  sensitive = true
}
variable "init_ssh_public_keys" {
  type      = list(string)
  sensitive = true
}
