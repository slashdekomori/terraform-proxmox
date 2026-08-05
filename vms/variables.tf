variable "vm_password" {
  description = "VM user account password "
  type        = string
  sensitive   = true
}

variable "ssh_keys" {
  description = "List of SSH public keys"
  type        = list(string)
  default     = []
}

variable "debian13-image" {
  description = "Path to debian13-image"
  type        = string
}
