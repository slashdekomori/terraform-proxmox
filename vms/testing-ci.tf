resource "proxmox_virtual_environment_file" "testing-ci-cloud-init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = templatefile("${path.module}/cloud-init/user-data.yaml.tftpl", {
      hostname = "testing-ci"
      username = "dekomori"
      passwd   = var.vm_password
      ssh_keys = var.ssh_keys
    })
  }

  file_name = "testing-ci-cloud-init.yaml"
}

resource "proxmox_virtual_environment_vm" "testing-ci" {
  name      = "testing-ci"
  node_name = "psyche"
  vm_id     = 4100

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

    user_data_file_id = proxmox_virtual_environment_file.cloud-init-test-cloud-init.id

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

