resource "coder_metadata" "info_node0" {
  resource_id = libvirt_domain.node0.id
  item {
    key = "Password"
    value = random_password.user_node0.result
    sensitive = true
  }
  item {
    key = "SSH"
    value = format("%s%s%s", replace(var.coder_url, "coder", "guacamole"), "/#/client/", replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node0.identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", ""))
  }
}
