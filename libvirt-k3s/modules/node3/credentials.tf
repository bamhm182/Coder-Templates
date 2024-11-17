resource "random_integer" "password_length_node3" {
  min = 40
  max = 64
}

resource "random_password" "user_node3" {
  length = random_integer.password_length_node3.result
}

resource "random_password" "user_salt_node3" {
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node3" {
  password = random_password.user_node3.result
  salt = random_password.user_salt_node3.result
}

resource "tls_private_key" "ssh_key_node3" {
  algorithm = "ED25519"
}
