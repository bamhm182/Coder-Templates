resource "coder_metadata" "info_node4" {
  resource_id = libvirt_domain.node4.id
  item {
    key = "Password"
    value = random_password.user_node4.result
    sensitive = true
  }
  item {
    key = "SSH"
    value = format("%s%s%s", replace(var.coder_url, "coder", "guacamole"), "/#/client/", replace(base64encode(format("%s%s%s%s%s", guacamole_connection_ssh.node4.identifier, base64decode("AA=="), "c", base64decode("AA=="), "postgresql")), "=", ""))
  }
}
