terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.104.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.virtual_environment_endpoint
  api_token = var.virtual_environment_token
  insecure = true

  ssh {
    agent       = false
    username    = "root"
    private_key = file("~/.ssh/keys/terraform")  # Path to your specific key
  }
}
