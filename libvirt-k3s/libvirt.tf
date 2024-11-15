resource "random_integer" "network" {
  count = 2
  min = 0
  max = 254
}

resource "libvirt_network" "internal" {
  name      = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-internal")
  mode      = "none"
  addresses = [ "127.${random_integer.network[0].result}.${random_integer.network[1].result}.0/24" ]
}

module "node" {
  source   = "./modules/node"
  count    = data.coder_workspace.me.start_count

  agent_id      = coder_agent.Kubernetes.id
  agent_token   = count.index == 0 ? coder_agent.Kubernetes.token : "xxxxxxxxxx"
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.internal.id
  owner         = data.coder_workspace.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = count.index == 0 ? "server" : "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = count.index
}
