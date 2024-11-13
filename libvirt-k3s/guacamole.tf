resource "guacamole_connection_kubernetes" "node" {
  name = "${data.coder_workspace.me.name} K3s Kubernetes Terminal (${data.coder_workspace_owner.me.name})"
  count  = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.node[0].network_interface.0.addresses.0
    port = 6443
    use_ssl = true
    ca_cert = tls_self_signed_cert.ca_cert.cert_pem
    client_cert = tls_locally_signed_cert.internal.cert_pem
    client_key = tls_private_key.internal.private_key_pem
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

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

# ----------------------

resource "coder_metadata" "guacamole_connection_kubernetes_node0" {
  resource_id = guacamole_connection_kubernetes.node[0].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (Kubernetes)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_kubernetes.node[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

resource "coder_metadata" "guacamole_connection_ssh_node0" {
  resource_id = guacamole_connection_ssh.node[0].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (SSH)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

resource "coder_metadata" "guacamole_connection_ssh_node1" {
  resource_id = guacamole_connection_ssh.node[1].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (SSH)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[1].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

resource "coder_metadata" "guacamole_connection_ssh_node2" {
  resource_id = guacamole_connection_ssh.node[2].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (SSH)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[2].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

resource "coder_metadata" "guacamole_connection_ssh_node3" {
  resource_id = guacamole_connection_ssh.node[3].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (SSH)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[3].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

resource "coder_metadata" "guacamole_connection_ssh_node4" {
  resource_id = guacamole_connection_ssh.node[4].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (SSH)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node[4].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

# ----------------------

resource "coder_app" "guacamole_kubernetes_node0" {
  agent_id = local.coder_agents[0].id
  count = data.coder_workspace.me.start_count
  display_name = "Kubernetes Terminal"
  slug = "guack8snode0"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_kubernetes.node[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
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
