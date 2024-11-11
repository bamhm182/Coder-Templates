resource "guacamole_connection_ssh" "server" {
  name = "${data.coder_workspace.me.name} K3s Server Terminal (${data.coder_workspace.me.owner})"
  count  = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.server[0].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key[0].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_metadata" "guacamole_connection_ssh_server" {
  resource_id = guacamole_connection_ssh.server[0].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (SSH)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.server[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

resource "guacamole_connection_ssh" "agent0" {
  name = "${data.coder_workspace.me.name} K3s Agent-0 Terminal (${data.coder_workspace.me.owner})"
  count  = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.agent0[0].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key[1].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_metadata" "guacamole_connection_ssh_agent0" {
  resource_id = guacamole_connection_ssh.agent0[0].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (SSH)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.agent0[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}
resource "guacamole_connection_ssh" "agent1" {
  name = "${data.coder_workspace.me.name} K3s Agent-1 Terminal (${data.coder_workspace.me.owner})"
  count  = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.agent1[0].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key[2].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_metadata" "guacamole_connection_ssh_agent1" {
  resource_id = guacamole_connection_ssh.agent1[0].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (SSH)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.agent1[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}
# ---

resource "guacamole_user_group" "main" {
  identifier = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-group"
  count  = data.coder_workspace.me.start_count
  connections = concat(
    length(guacamole_connection_ssh.server) > 0 ? [guacamole_connection_ssh.server[0].identifier] : [],
    length(guacamole_connection_ssh.agent0) > 0 ? [guacamole_connection_ssh.agent0[0].identifier] : [],
    length(guacamole_connection_ssh.agent1) > 0 ? [guacamole_connection_ssh.agent1[0].identifier] : [],
  )
  member_users = [
    data.coder_workspace.me.owner
  ]
}

resource "coder_metadata" "guacamole_user_group_main" {
  resource_id = guacamole_user_group.main[0].id
  count  = data.coder_workspace.me.start_count
  hide = true
}
