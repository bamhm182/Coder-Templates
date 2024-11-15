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

module "node0" {
  source   = "./modules/node"

  agent_id      = coder_agent.node0.id
  agent_token   = coder_agent.node0.token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.internal.id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "server"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 0
}

module "node1" {
  source   = "./modules/node"

  agent_id      = coder_agent.node1.id
  agent_token   = coder_agent.node1.token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.internal.id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 1
}

module "node2" {
  source   = "./modules/node"

  agent_id      = coder_agent.node2.id
  agent_token   = coder_agent.node2.token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.internal.id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 2
}

module "node3" {
  source   = "./modules/node"

  agent_id      = coder_agent.node3.id
  agent_token   = coder_agent.node3.token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.internal.id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 3
}

module "node4" {
  source   = "./modules/node"

  agent_id      = coder_agent.node4.id
  agent_token   = coder_agent.node4.token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.internal.id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 4
}
