locals {
  templates                   = jsondecode(file("${path.root}/../shared/templates.json"))
  debian13_template_id        = local.templates.debian13_template_id
  debian13_golden_template_id = local.templates.debian13_golden_template_id
}

source "proxmox-clone" "debian13" {
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  node                     = var.proxmox_node
  insecure_skip_tls_verify = true

  clone_vm_id = local.debian13_template_id
  vm_id       = local.debian13_golden_template_id
  full_clone  = true

  vm_name              = "debian13-golden"
  template_name        = "debian13-golden"
  template_description = "debian 13 golden template (packer-built from ansible base 9000)"

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  ipconfig {
    ip = "dhcp"
  }
  qemu_agent = true

  cores  = 2
  memory = 2048

  cloud_init              = true
  cloud_init_storage_pool = "slow"

  ssh_username         = var.ssh_user_name
  ssh_private_key_file = var.ssh_private_key_file
  ssh_timeout          = "10m"
}

build {
  sources = ["source.proxmox-clone.debian13"]

  provisioner "shell" {
    inline = [
      "sudo cloud-init status --wait || true",
      "for i in 1 2 3; do sudo apt-get update && break; sleep 5; done",
      "sudo apt-get install fastfetch -y"
      "sudo cloud-init clean",
      "sudo rm -f /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id"
    ]
  }

  post-processor "shell-local" {
    inline = [
      "ssh proxmox qm set ${local.debian13_golden_template_id} --ipconfig0 ip=dhcp --ciuser init --cipassword 20080212"
    ]
  }
}
