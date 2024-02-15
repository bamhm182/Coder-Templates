resource "guacamole_connection_rdp" "main" {
  name = "${data.coder_workspace.me.name} Desktop (${data.coder_workspace.me.owner})"
  count  = contains(["nixos-base"], data.coder_parameter.baseline_image.value) ? 0 : data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.main[0].network_interface.0.addresses.0
    port = 3389
    username = "user"
    password = random_password.user[0].result
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
    resize_method = "reconnect"
    ignore_cert = "true"
  }
}

resource "coder_metadata" "guacamole_connection_rdp_main" {
  resource_id = guacamole_connection_rdp.main[0].id
  count  = contains(["nixos-base"], data.coder_parameter.baseline_image.value) ? 0 : data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (RDP)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_rdp.main[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

# ---

resource "guacamole_connection_ssh" "main" {
  name = "${data.coder_workspace.me.name} Terminal (${data.coder_workspace.me.owner})"
  count  = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname = libvirt_domain.main[0].network_interface.0.addresses.0
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key[0].private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_metadata" "guacamole_connection_ssh_main" {
  resource_id = guacamole_connection_ssh.main[0].id
  count  = data.coder_workspace.me.start_count
  item {
    key = "Guacamole URL (SSH)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.main[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

# ---

resource "guacamole_user_group" "main" {
  identifier = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-group"
  count  = data.coder_workspace.me.start_count
  connections = concat(
    length(guacamole_connection_ssh.main) > 0 ? [guacamole_connection_ssh.main[0].identifier] : [],
    length(guacamole_connection_rdp.main) > 0 ? [guacamole_connection_rdp.main[0].identifier] : []
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
