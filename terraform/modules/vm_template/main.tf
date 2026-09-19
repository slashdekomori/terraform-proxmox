resource "proxmox_virtual_environment_vm" "vm_template" {
  name      = var.vm_name
  node_name = var.node_name
  vm_id     = var.vm_id

  dynamic "clone" {
    for_each = var.template_id != null ? [1] : []

    content {
      vm_id = var.template_id
    }
  }

  dynamic "disk" {
    for_each = var.template_id == null ? [1] : []

    content {
      datastore_id = var.datastore_id
      import_from  = var.image_file_id
      interface    = "virtio0"
      iothread     = true
      backup       = true
      discard      = "on"
      size         = var.disk_size
    }
  }

  cpu {
    cores   = var.cores
    sockets = var.socket
    type    = "host"
  }

  memory {
    dedicated = var.memory
    floating  = var.memory
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      username = var.user_name
      password = var.user_password
      keys     = var.ssh_public_keys
    }
    datastore_id = var.datastore_id
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  operating_system { type = "l26" }
  serial_device { device = "socket" }
  vga { type = "serial0" }

  agent {
    enabled = true
  }

  efi_disk {
    datastore_id = var.datastore_id
    type         = "4m"
  }

  machine         = "q35"
  bios            = "ovmf"
  template        = true
  started         = false
  stop_on_destroy = true
}
