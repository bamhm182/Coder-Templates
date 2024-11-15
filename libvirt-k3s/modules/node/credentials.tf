resource "random_integer" "password_length" {
  min = 40
  max = 64
}

resource "random_password" "user" {
  length = random_integer.password_length.result
}

resource "random_password" "user_salt" {
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user" {
  password = random_password.user.result
  salt = random_password.user_salt.result
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}
