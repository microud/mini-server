module "gateway" {
  source = "./modules/gateway"

  enable = true
  nameserver = ["114.114.114.114"]
  address = "192.168.5.2/24"
  gateway = "192.168.5.1"
}

module "cluster" {
  depends_on = [module.gateway]
  source = "./modules/cluster"
  gateway = "192.168.5.2"
  nameserver = ["192.168.5.2", "114.114.114.114"]
  servers = {
    server1 = {
      cpu     = 4
      memory  = 8
      disk    = 100
      address = "192.168.5.201/24"
    }
  }

  agents = {
    agent1 = {
      cpu     = 4
      memory  = 16
      disk    = 100
      address = "192.168.5.202/24"
    }

    agent2 = {
      cpu     = 4
      memory  = 16
      disk    = 100
      address = "192.168.5.203/24"
    }
  }
}