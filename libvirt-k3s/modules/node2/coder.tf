resource "coder_metadata" "info_node2" {
  resource_id = libvirt_domain.node2.id
  item {
    key = "Password"
    value = random_password.user_node2.result
    sensitive = true
  }
  item {
    key = "SSH"
    value = format("%s%s%s", replace(var.coder_url, "coder", "guacamole"), "/#/client/", replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node2.identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", ""))
  }
}
