resource "guacamole_connection_ssh" "node" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  name = "${data.coder_workspace.me.name} K3s node${count.index} Terminal (${data.coder_workspace_owner.me.name})"
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.node[count.index].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key[count.index].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_app" "guacamole_ssh_node0" {
  agent_id = local.coder_agents[0].id
  count = data.coder_workspace.me.start_count
  display_name = "SSH Terminal"
  slug = "guacsshnode0"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

resource "coder_app" "guacamole_ssh_node1" {
  agent_id = local.coder_agents[1].id
  count = data.coder_workspace.me.start_count
  display_name = "SSH Terminal"
  slug = "guacsshnode1"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[1].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

resource "coder_app" "guacamole_ssh_node2" {
  agent_id = local.coder_agents[2].id
  count = data.coder_workspace.me.start_count
  display_name = "SSH Terminal"
  slug = "guacsshnode2"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[2].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

resource "coder_app" "guacamole_ssh_node3" {
  agent_id = local.coder_agents[3].id
  count = data.coder_workspace.me.start_count
  display_name = "SSH Terminal"
  slug = "guacsshnode3"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[3].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

resource "coder_app" "guacamole_ssh_node4" {
  agent_id = local.coder_agents[4].id
  count = data.coder_workspace.me.start_count
  display_name = "SSH Terminal"
  slug = "guacsshnode4"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[4].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}
