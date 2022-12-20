module "k3s" {
  source = "xunleii/k3s/module"

  depends_on = [
    module.k3s_servers,
    module.k3s_agents
  ]

  cluster_domain = "k3s.srus.io"
  k3s_version    = "latest"

  servers = {
    for key, server in var.servers :
    key => {
      name       = key
      ip         = split("/", server.address)[0]
      connection = {
        host        = split("/", server.address)[0]
        user        = "root"
        private_key = file("~/.ssh/id_rsa")
      }
      flags = [
        "--disable traefik"
      ]
    }
  }

  agents = {
    for key, agent in var.agents :
    key => {
      name       = key
      ip         = split("/", agent.address)[0]
      connection = {
        host        = split("/", agent.address)[0]
        user        = "root"
        private_key = file("~/.ssh/id_rsa")
      }
    }
  }
}

resource "local_file" "kube_config" {
  content  = module.k3s.kube_config
  filename = var.kube_config_path
}
