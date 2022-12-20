terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.5"
    }
  }
}

resource "proxmox_vm_qemu" "virtual_machine" {
  count = 1
  name  = var.name
  desc  = "virtual machine ${var.name}"

  target_node = "pve"

  clone = var.template

  agent    = 0
  os_type  = "cloud-init"
  onboot   = true
  cores    = var.size.cpu
  sockets  = 1
  cpu      = "host"
  memory   = var.size.memory * 1024
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot     = 0
    size     = "${var.size.disk}G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 0
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  ipconfig0  = "ip=${var.network.address},gw=${var.network.gateway}"
  nameserver = join(" ", var.network.nameserver)

  ciuser  = "root"
  sshkeys = file("~/.ssh/id_rsa.pub")
}
