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
  count    = length(local.agents)

  agent_id      = local.agents[count.index].id
  agent_token   = local.agents[count.index].token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.internal.id
  owner         = data.coder_workspace.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = count.index == 0 ? "server" : "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = count.index
}
