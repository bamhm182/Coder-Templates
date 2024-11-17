resource "random_integer" "password_length_node2" {
  min = 40
  max = 64
}

resource "random_password" "user_node2" {
  length = random_integer.password_length_node2.result
}

resource "random_password" "user_salt_node2" {
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node2" {
  password = random_password.user_node2.result
  salt = random_password.user_salt_node2.result
}

resource "tls_private_key" "ssh_key_node2" {
  algorithm = "ED25519"
}
