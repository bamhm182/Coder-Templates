resource "guacamole_connection_ssh" "node0" {
  depends_on = [libvirt_domain.node0]
  name = "${var.ws_name} ${title(var.type)} ${var.ws_number} Terminal (${var.owner})"
  parent_identifier = "ROOT"
  parameters {
    hostname = flatten([for nic in libvirt_domain.node0.network_interface :
                   [for addr in nic.addresses : addr if can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", addr))]])[0]
    port = 22
    username = "user"
    private_key = tls_private_key.ssh_key_node0.private_key_openssh
    recording_path = "$${HISTORY_PATH}/$${HISTORY_UUID}"
    recording_auto_create_path = "true"
  }
}

resource "coder_app" "guacamole_ssh_node0" {
  agent_id = var.agent_id
  display_name = "${title(var.type)} ${var.ws_number} (SSH)"
  slug = "guacsshnode${var.ws_number}"
  icon = "/icon/apache-guacamole.svg"
  external = true

  url = format(
    "%s%s%s",
    replace(var.coder_url, "coder", "guacamole"),
    "/#/client/",
    replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node0.identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", "")
  )
}
