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
  description = "Proxmox VE API token"
  type        = string
  sensitive   = true
}
variable "proxmox_insecure" {
  description = "Skip TLS verification for Proxmox API"
  type        = bool
  default     = true
}
variable "ssh_public_keys" {
  type    = list(string)
  default = []
}
