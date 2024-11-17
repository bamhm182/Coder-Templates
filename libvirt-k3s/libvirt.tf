resource "libvirt_network" "private" {
  count = data.coder_workspace.me.start_count
  name  = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-private")
  mode  = "none"
}

module "node0" {
  count = data.coder_workspace.me.start_count
  source   = "./modules/node0"

  agent_id      = coder_agent.node0[0].id
  agent_token   = coder_agent.node0[0].token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.private[0].id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "server"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 0
}

module "node1" {
  count = data.coder_workspace.me.start_count
  source   = "./modules/node1"

  agent_id      = coder_agent.node1[0].id
  agent_token   = coder_agent.node1[0].token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.private[0].id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 1
}

module "node2" {
  count = data.coder_workspace.me.start_count
  source   = "./modules/node2"

  agent_id      = coder_agent.node2[0].id
  agent_token   = coder_agent.node2[0].token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.private[0].id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 2
}

module "node3" {
  count = data.coder_workspace.me.start_count
  source   = "./modules/node3"

  agent_id      = coder_agent.node3[0].id
  agent_token   = coder_agent.node3[0].token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.private[0].id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 3
}

module "node4" {
  count = data.coder_workspace.me.start_count
  source   = "./modules/node4"

  agent_id      = coder_agent.node4[0].id
  agent_token   = coder_agent.node4[0].token
  coder_url     = data.coder_workspace.me.access_url
  cpu           = data.coder_parameter.cpu_count.value
  network_id    = libvirt_network.private[0].id
  owner         = data.coder_workspace_owner.me.name
  ram           = (data.coder_parameter.ram_amount.value * 1024)
  type          = "agent"
  ws_name       = data.coder_workspace.me.name
  ws_number     = 4
}
