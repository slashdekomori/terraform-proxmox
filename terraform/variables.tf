# --- environment-wide settings (values go in terraform.tfvars) ---
variable "defaults" {
  type = object({
    node_name            = string
    disk_datastore_id    = string
    snippet_datastore_id = string
    user_name            = string
    user_password        = optional(string)
    ssh_public_keys      = list(string)
    timezone             = string

    cores     = number
    socket    = number
    memory    = number
    disk_size = number
  })
  sensitive = true

  validation {
    condition     = length(var.defaults.ssh_public_keys) > 0
    error_message = "defaults.ssh_public_keys must contain at least one key."
  }
}

# --- the VM inventory ---
variable "vms" {
  type = map(object({
    node_name            = optional(string)
    vm_id                = optional(number)
    disk_datastore_id    = optional(string)
    snippet_datastore_id = optional(string)

    template_id   = optional(number)
    image_file_id = optional(string)

    cores     = optional(number)
    socket    = optional(number)
    memory    = optional(number)
    disk_size = optional(number)

    ipv4_address = optional(string)
    ipv4_gateway = optional(string)
    vlan_id      = optional(number)

    user_name       = optional(string)
    user_password   = optional(string)
    ssh_public_keys = optional(list(string))
    timezone        = optional(string)
  }))

  validation {
    condition = alltrue([
      for k, v in var.vms : can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$", k))
    ])
    error_message = "VM names (map keys) must be valid lowercase hostnames."
  }

  validation {
    condition = alltrue([
      for k, v in var.vms : v.template_id == null || v.image_file_id == null
    ])
    error_message = "Set at most one of template_id or image_file_id per VM."
  }
}

# --- provider ---
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


