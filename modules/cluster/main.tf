module "k3s_servers" {
  source = "../vm"

  for_each = var.servers

  name     = each.key
  template = var.template
  size     = {
    cpu = each.value.cpu
    memory = each.value.memory
    disk = each.value.disk
  }
  network  = {
    address = each.value.address
    gateway = var.gateway
    nameserver = var.nameserver
  }
}

module "k3s_agents" {
  source = "../vm"

  for_each = var.agents

  name     = each.key
  template = var.template
  size     = {
    cpu = each.value.cpu
    memory = each.value.memory
    disk = each.value.disk
  }
  network  = {
    address = each.value.address
    gateway = var.gateway
    nameserver = var.nameserver
  }
}