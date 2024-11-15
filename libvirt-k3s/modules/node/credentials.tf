resource "random_integer" "password_length" {
  agent_id = var.agent_id
  min = 40
  max = 64
}

resource "random_password" "user" {
  agent_id = var.agent_id
  length = random_integer.password_length.result
}

resource "random_password" "user_salt" {
  agent_id = var.agent_id
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user" {
  agent_id = var.agent_id
  password = random_password.user.result
  salt = random_password.user_salt.result
}

resource "tls_private_key" "ssh_key" {
  agent_id = var.agent_id
  algorithm = "ED25519"
}
