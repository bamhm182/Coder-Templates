resource "guacamole_connection_ssh" "main" {
  name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-SSH"
  count       = data.coder_workspace.me.start_count
  parent_identifier = "ROOT"
  parameters {
    hostname = linode_instance.instance[0].ip_address
    port = 22
    username = data.coder_workspace.me.owner
    private_key = tls_private_key.ssh_key.private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_metadata" "connection" {
  resource_id = guacamole_connection_ssh.main[0].id
  count       = data.coder_workspace.me.start_count
  hide = true
  item {
    key = "Guacamole"
    value = format(
      "%s%s%s",
      replace(data.coder_workspace.me.access_url, "coder", "guacamole"),
      "/#/client/",
      base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.main[0].identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql"))
    )
  }
}

# ---

resource "guacamole_user_group" "user_group" {
  identifier = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-group"
  count       = data.coder_workspace.me.start_count
  connections = [
    guacamole_connection_ssh.main[0].identifier
  ]
  member_users = [
    data.coder_workspace.me.owner_email
  ]
}

resource "coder_metadata" "hide_user_group" {
  resource_id = guacamole_user_group.user_group[0].id
  count       = data.coder_workspace.me.start_count
  hide = true
}
