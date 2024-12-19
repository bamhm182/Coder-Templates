# ========== NODE0 ==========

resource "guacamole_connection_ssh" "node0" {
  count = data.coder_workspace.me.start_count
  name = "${data.coder_workspace.me.name} K3s node0 Terminal (${data.coder_workspace_owner.me.name})"
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.node0[0].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key_node0[0].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_app" "guacamole_ssh_node0" {
  agent_id = coder_agent.kubernetes.id
  count = data.coder_workspace.me.start_count
  display_name = "SSH (node0)"
  slug = "guacsshnode0"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node0[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

# ========== NODE1 ==========

resource "guacamole_connection_ssh" "node1" {
  count = data.coder_workspace.me.start_count
  name = "${data.coder_workspace.me.name} K3s node1 Terminal (${data.coder_workspace_owner.me.name})"
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.node1[0].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key_node1[0].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_app" "guacamole_ssh_node1" {
  agent_id = coder_agent.kubernetes.id
  count = data.coder_workspace.me.start_count
  display_name = "SSH (node1)"
  slug = "guacsshnode1"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node1[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

# ========== NODE2 ==========

resource "guacamole_connection_ssh" "node2" {
  count = data.coder_workspace.me.start_count
  name = "${data.coder_workspace.me.name} K3s node2 Terminal (${data.coder_workspace_owner.me.name})"
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.node2[0].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key_node2[0].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_app" "guacamole_ssh_node2" {
  agent_id = coder_agent.kubernetes.id
  count = data.coder_workspace.me.start_count
  display_name = "SSH (node2)"
  slug = "guacsshnode2"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node2[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

# ========== NODE3 ==========

resource "guacamole_connection_ssh" "node3" {
  count = data.coder_workspace.me.start_count
  name = "${data.coder_workspace.me.name} K3s node3 Terminal (${data.coder_workspace_owner.me.name})"
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.node3[0].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key_node3[0].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_app" "guacamole_ssh_node3" {
  agent_id = coder_agent.kubernetes.id
  count = data.coder_workspace.me.start_count
  display_name = "SSH (node3)"
  slug = "guacsshnode3"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node3[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}

# ========== NODE4 ==========

resource "guacamole_connection_ssh" "node4" {
  count = data.coder_workspace.me.start_count
  name = "${data.coder_workspace.me.name} K3s node4 Terminal (${data.coder_workspace_owner.me.name})"
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.node4[0].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key_node4[0].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_app" "guacamole_ssh_node4" {
  agent_id = coder_agent.kubernetes.id
  count = data.coder_workspace.me.start_count
  display_name = "SSH (node4)"
  slug = "guacsshnode4"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node4[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}
