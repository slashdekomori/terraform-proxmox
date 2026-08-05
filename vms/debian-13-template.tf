resource "proxmox_virtual_environment_vm" "debian-13-template" {
  name      = "debian-13-template"
  node_name = "psyche"
  vm_id     = 9100

  cpu {
    cores   = 1
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 1024
    floating  = 1024
  }

  initialization {
    datastore_id = "slow"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "dekomori"
      password = var.vm_password
      keys     = var.ssh_keys
    }
  }

  disk {
    datastore_id = "slow"
    import_from  = var.debian13-image
    interface    = "virtio0"
    iothread     = true
    backup       = false
    discard      = "on"
    size         = 15
  }

  serial_device {
    device = "socket"
  }

  vga {
    type = "serial0"
  }

  machine = "q35"
  bios    = "ovmf"

  operating_system {
    type = "l26"
  }

  efi_disk {
    datastore_id = "slow"
    type         = "4m"
  }

  agent {
    enabled = true
    wait_for_ip {
      disabled = true
    }
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  template        = true
  started         = false
  stop_on_destroy = true
}

