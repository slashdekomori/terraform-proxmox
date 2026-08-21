resource "proxmox_virtual_environment_file" "user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name

  source_raw {
    file_name = "user-data-${var.vm_name}.yaml"
    data = templatefile("${path.module}/templates/cloud_init.yaml.tftpl", {
      vm_name         = var.vm_name
      user_name       = var.user_name
      user_password   = var.user_password
      ssh_public_keys = var.ssh_public_keys
      timezone        = var.timezone
    })
  }
}

resource "proxmox_virtual_environment_vm" "this-template" {
  name      = var.vm_name
  node_name = var.node_name
  vm_id     = var.vm_id

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
    # TODO: convert to var
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    datastore_id      = var.datastore_id
    user_data_file_id = proxmox_virtual_environment_file.user_data.id
  }

  disk {
    datastore_id = var.datastore_id
    import_from  = var.cloud_image_id
    interface    = "virtio0"
    iothread     = true
    backup       = false
    discard      = "on"
    size         = var.disk_size
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
  template        = false
  started         = true
  stop_on_destroy = true
}

