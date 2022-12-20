variable "name" {
  type = string
}

variable "size" {
  type = object({
    cpu = number
    memory = number
    disk = number
  })
}

variable "template" {
  type = string
}

variable "network" {
  type = object({
    address = string
    gateway = string
    nameserver = list(string)
  })
}