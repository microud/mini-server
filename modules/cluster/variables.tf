variable "template" {
  type    = string
  default = "rocky-9.1-20221130-cloudinit-template"
}

variable "gateway" {
  type = string
}

variable "nameserver" {
  type = list(string)
}

variable "servers" {
  type = map(object({
    cpu     = number
    memory  = number
    disk    = number
    address = string
  }))
}

variable "agents" {
  type = map(object({
    cpu     = number
    memory  = number
    disk    = number
    address = string
  }))
}

variable "kube_config_path" {
  type = string
  default = ".kube/config"
}