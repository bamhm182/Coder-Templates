resource "random_integer" "network" {
  count = 2
  min = 0
  max = 254
}

resource "libvirt_network" "internal" {
  name      = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-internal")
  count     = data.coder_workspace.me.start_count
  mode      = "none"
  addresses = [ "127.${random_integer.network[0].result}.${random_integer.network[1].result}.0/24" ]
}

module "node0" {
  source = "./modules/node"
  #source = "git::https://github.com/bamhm182/Coder-Templates.git//libvirt-k3s/modules/node?ref=wip-k3s"
  count  = data.coder_workspace.me.start_count

  coder_url  = data.coder_workspace.me.access_url
  cpu        = data.coder_parameter.cpu_count.value
  network_id = libvirt_network.internal[0].id
  owner      = data.coder_workspace.me.name
  ram        = (data.coder_parameter.ram_amount.value * 1024)
  type       = "server"
  ws_name    = data.coder_workspace.me.name
  ws_number  = 0
}
