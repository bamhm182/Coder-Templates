resource "guacamole_connection_rdp" "newbie" {
  name              = "${data.coder_workspace.me.name} Newbie Desktop (${data.coder_workspace.me.owner})"
  count             = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname                   = libvirt_domain.netboot[0].network_interface.0.addresses.0
    port                       = 3389
    username                   = "user"
    password                   = "password"
    recording_path             = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
    resize_method              = "reconnect"
    ignore_cert                = "true"
  }
}

resource "coder_metadata" "guacamole_connection_rdp_newbie" {
  resource_id = guacamole_connection_rdp.newbie[0].id
  count       = data.coder_workspace.me.start_count
  item {
    key   = "Guacamole URL (RDP - Newbie)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_rdp.newbie[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

# ---

resource "guacamole_connection_ssh" "newbie" {
  name              = "${data.coder_workspace.me.name} Newbie Terminal (${data.coder_workspace.me.owner})"
  count             = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname                   = libvirt_domain.netboot[0].network_interface.0.addresses.0
    port                       = 2222
    username                   = "user"
    password                   = "password"
    recording_path             = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_metadata" "guacamole_connection_ssh_newbie" {
  resource_id = guacamole_connection_ssh.newbie[0].id
  count       = data.coder_workspace.me.start_count
  item {
    key   = "Guacamole URL (SSH - Newbie)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.newbie[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

resource "guacamole_connection_ssh" "netboot" {
  name              = "${data.coder_workspace.me.name} Netboot Terminal (${data.coder_workspace.me.owner})"
  count             = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname                   = libvirt_domain.netboot[0].network_interface.0.addresses.0
    port                       = 22
    username                   = "user"
    private_key                = tls_private_key.ssh_key[0].private_key_openssh
    recording_path             = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_metadata" "guacamole_connection_ssh_netboot" {
  resource_id = guacamole_connection_ssh.netboot[0].id
  count       = data.coder_workspace.me.start_count
  item {
    key   = "Guacamole URL (SSH - Netboot)"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.netboot[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
    )
  }
}

# ---

resource "guacamole_user_group" "main" {
  identifier  = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-group"
  count       = data.coder_workspace.me.start_count
  connections = concat(
    length(guacamole_connection_ssh.newbie) > 0 ? [guacamole_connection_ssh.newbie[0].identifier] : [],
    length(guacamole_connection_ssh.netboot) > 0 ? [guacamole_connection_ssh.netboot[0].identifier] : [],
    length(guacamole_connection_rdp.newbie) > 0 ? [guacamole_connection_rdp.newbie[0].identifier] : []
  )
  member_users = [
    data.coder_workspace.me.owner
  ]
}

resource "coder_metadata" "guacamole_user_group_main" {
  resource_id = guacamole_user_group.main[0].id
  count       = data.coder_workspace.me.start_count
  hide        = true
}

