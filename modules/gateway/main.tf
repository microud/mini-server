module "gateway" {
  name    = "gateway"
  source  = "../vm"
  count   = var.enable ? 1 : 0
  size    = var.size
  network = {
    address    = var.address
    gateway    = var.gateway
    nameserver = var.nameserver
  }
  template = var.template
}

resource "null_resource" "provisioner" {
  depends_on = [
    module.gateway
  ]

  connection {
    host        = split("/", var.address)[0]
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source      = "${path.module}/clash.service"
    destination = "/etc/systemd/system/clash.service"
  }

  provisioner "local-exec" {
    working_dir = ".terraform"
    command = "mkdir -p tmp && wget ${var.clash_premium_url} -O tmp/clash-linux-amd64.gz"
  }

  provisioner "file" {
    source      = ".terraform/tmp/clash-linux-amd64.gz"
    destination = "/tmp/clash-linux-amd64.gz"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /etc/clash/",
    ]
  }

  provisioner "file" {
    source      = var.config_path
    destination = "/etc/clash/config.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"net.ipv4.ip_forward=1\" >> /etc/sysctl.conf",
      "sysctl -p",
      "cd /tmp/",
      "gzip -d clash-linux-amd64.gz",
      "mv clash-linux-amd64 /usr/local/bin/clash",
      "chmod +x /usr/local/bin/clash",
      "restorecon -rv /usr/local/bin/",
      "systemctl daemon-reload",
      "systemctl enable clash --now"
    ]
  }

  provisioner "local-exec" {
    working_dir = ".terraform"
    command = "rm -rf tmp"
  }
}

