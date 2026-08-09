resource "proxmox_download_file" "this_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.node_name
  url          = var.cloud_image_url
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
  initialization { datastore_id = var.datastore_id }

  disk {
    datastore_id = var.datastore_id
    import_from  = proxmox_download_file.this_image.id
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

