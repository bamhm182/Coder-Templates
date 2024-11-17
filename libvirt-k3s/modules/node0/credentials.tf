resource "random_integer" "password_length_node0" {
  min = 40
  max = 64
}

resource "random_password" "user_node0" {
  length = random_integer.password_length_node0.result
}

resource "random_password" "user_salt_node0" {
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node0" {
  password = random_password.user_node0.result
  salt = random_password.user_salt_node0.result
}

resource "tls_private_key" "ssh_key_node0" {
  algorithm = "ED25519"
}
