variable "virtual_environment_endpoint" {
  type        = string
  description = "The endpoint for the Proxmox Virtual Environment API (example: https://host:port)"
}

variable "virtual_environment_token" {
  type        = string
  description = "The token for the Proxmox Virtual Environment API"
  sensitive   = true
}

variable "virtual_environment_ssh_username" {
  type        = string
  description = "The token for the Proxmox Virtual Environment API"
  sensitive   = true
}
