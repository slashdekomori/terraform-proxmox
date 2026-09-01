source "proxmox-clone" "debian13" {
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  node                     = var.proxmox_node
  insecure_skip_tls_verify = true


  clone_vm_id = 9000
  full_clone  = true

  vm_id                = 8000
  vm_name              = "debian13-template"
  template_name        = "debian13-template"
  template_description = "Debian 13"

  qemu_agent = true

  cores  = 2
  memory = 2048

  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  ssh_username         = "packer"
  ssh_private_key_file = var.ssh_private_key_file
  ssh_timeout          = "10m"

  disks {
    disk_size    = "20G"
    storage_pool = var.storage_pool
    type         = "scsi"
  }
}

build {
  sources = ["source.proxmox-clone.debian13"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y qemu-guest-agent",
      "sudo systemctl enable qemu-guest-agent",
      "sudo cloud-init clean",
      "sudo rm -f /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id"
    ]
  }
}
