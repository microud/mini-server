variable "enable" {
  type = bool
  description = "Enable clash gateway or not."
}

variable "gateway" {
  type = string
  description = "The gateway of clash gateway vm network should use."
}

variable "address" {
  type = string
  description = "The IP address with network mask in cidr format"
}

variable "nameserver" {
  type = list(string)
  default = []
}

variable "size" {
  type = object({
    cpu = number
    memory = number
    disk = number
  })

  default = {
    cpu    = 1
    memory = 1
    disk   = 10
  }
}

variable "template" {
  type = string
  description = "The os template name."
  default = "rocky-9.1-20221130-cloudinit-template"
}

variable "config_path" {
  type = string
  default = "~/.config/clash/gateway.yaml"
}

variable "clash_premium_url" {
  type = string
  default = "https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-amd64-2022.11.25.gz"
}