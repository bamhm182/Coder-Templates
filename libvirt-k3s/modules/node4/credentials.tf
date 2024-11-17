resource "random_integer" "password_length_node4" {
  min = 40
  max = 64
}

resource "random_password" "user_node4" {
  length = random_integer.password_length_node4.result
}

resource "random_password" "user_salt_node4" {
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node4" {
  password = random_password.user_node4.result
  salt = random_password.user_salt_node4.result
}

resource "tls_private_key" "ssh_key_node4" {
  algorithm = "ED25519"
}
