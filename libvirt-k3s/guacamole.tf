resource "guacamole_connection_ssh" "server" {
  name = "${data.coder_workspace.me.name} K3s Server Terminal (${data.coder_workspace_owner.me.name})"
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

resource "coder_app" "guacamole_ssh_server" {
  agent_id = coder_agent.server.id
  count = length(guacamole_connection_ssh.server)
  display_name = "SSH Terminal"
  slug = "guacsshserver"
  icon = "/icons/guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.server[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

resource "guacamole_connection_kubernetes" "server" {
  name = "${data.coder_workspace.me.name} K3s Kubernetes Terminal (${data.coder_workspace_owner.me.name})"
  count  = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.server[0].network_interface.0.addresses.0
    port = 6433
    ignore_cert = true
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_metadata" "guacamole_connection_kubernetes_server" {
  resource_id = guacamole_connection_kubernetes.server[0].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (Kubernetes)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_kubernetes.server[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

resource "coder_app" "guacamole_kubernetes_server" {
  agent_id = coder_agent.server.id
  count = length(guacamole_connection_kubernetes.server)
  display_name = "Kubernetes Terminal"
  slug = "guack8sserver"
  icon = "/icons/guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_kubernetes.server[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

resource "guacamole_connection_ssh" "agent0" {
  name = "${data.coder_workspace.me.name} K3s Agent-0 Terminal (${data.coder_workspace_owner.me.name})"
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

resource "coder_app" "guacamole_ssh_agent0" {
  agent_id = coder_agent.agent0.id
  count = length(guacamole_connection_ssh.agent0)
  display_name = "SSH Terminal"
  slug = "guacsshagent0"
  icon = "/icons/guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.agent0[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

resource "guacamole_connection_ssh" "agent1" {
  name = "${data.coder_workspace.me.name} K3s Agent-1 Terminal (${data.coder_workspace_owner.me.name})"
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

resource "coder_app" "guacamole_ssh_agent1" {
  agent_id = coder_agent.agent1.id
  count = length(guacamole_connection_ssh.agent1)
  display_name = "SSH Terminal"
  slug = "guacsshagent1"
  icon = "/icons/guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.agent1[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

# ---

resource "guacamole_user_group" "main" {
  identifier = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-group"
  count  = data.coder_workspace.me.start_count
  connections = concat(
    length(guacamole_connection_ssh.server) > 0 ? [guacamole_connection_ssh.server[0].identifier] : [],
    length(guacamole_connection_ssh.agent0) > 0 ? [guacamole_connection_ssh.agent0[0].identifier] : [],
    length(guacamole_connection_ssh.agent1) > 0 ? [guacamole_connection_ssh.agent1[0].identifier] : [],
  )
  member_users = [
    data.coder_workspace_owner.me.name
  ]
}

resource "coder_metadata" "guacamole_user_group_main" {
  resource_id = guacamole_user_group.main[0].id
  count  = data.coder_workspace.me.start_count
  hide = true
}
