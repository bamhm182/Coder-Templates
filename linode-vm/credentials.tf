resource "random_password" "user" {
  length = 42
}

resource "coder_metadata" "random_password_user" {
  resource_id = random_password.user.id
  hide = true
}

resource "random_password" "user_salt" {
  length = 8
  override_special = "./"
}

resource "coder_metadata" "random_password_user_salt" {
  resource_id = random_password.user_salt.id
  hide = true
}

resource "htpasswd_password" "user" {
  password = random_password.user.result
  salt = random_password.user_salt.result
}

resource "coder_metadata" "htpasswd_password_user" {
  resource_id = htpasswd_password.user.id
  hide = true
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "coder_metadata" "tls_private_key_ssh_key" {
  resource_id = tls_private_key.ssh_key.id
  hide = true
}
