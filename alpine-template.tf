resource "proxmox_virtual_environment_vm" "alpine_template" {
  name        = "alpine-template"
  node_name   = "psyche"
  template    = true
  started     = false
  description = "Managed by Terraform"

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
  }

  vga {
    type = "qxl"
    memory = 32
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = "fast"
    import_from  = "local:import/nocloud_alpine-3.23.4-x86_64-bios-cloudinit-r0.qcow2"
    interface    = "scsi0"
    size         = 1
    ssd          = true
    discard      = "on"
    iothread     = true
  }

  initialization {
    datastore_id = "slow"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}
