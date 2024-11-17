resource "random_integer" "password_length_node1" {
  min = 40
  max = 64
}

resource "random_password" "user_node1" {
  length = random_integer.password_length_node1.result
}

resource "random_password" "user_salt_node1" {
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node1" {
  password = random_password.user_node1.result
  salt = random_password.user_salt_node1.result
}

resource "tls_private_key" "ssh_key_node1" {
  algorithm = "ED25519"
}
