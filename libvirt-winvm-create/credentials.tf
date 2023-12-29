resource "random_integer" "password_length" {
  count = data.coder_workspace.me.start_count
  min = 40
  max = 64
}

resource "random_password" "user" {
  count = data.coder_workspace.me.start_count
  length = random_integer.password_length[0].result
}

resource "coder_metadata" "random_password_user" {
  count = data.coder_workspace.me.start_count
  resource_id = random_password.user[0].id
  item {
    key = "Password"
    value = random_password.user[0].result
    sensitive = true
  }
}

resource "random_password" "user_salt" {
  count = data.coder_workspace.me.start_count
  length = 8
  override_special = "./"
}

resource "coder_metadata" "random_password_user_salt" {
  count = data.coder_workspace.me.start_count
  resource_id = random_password.user_salt[0].id
  hide = true
}

resource "htpasswd_password" "user" {
  count = data.coder_workspace.me.start_count
  password = random_password.user[0].result
  salt = random_password.user_salt[0].result
}

resource "coder_metadata" "htpasswd_password_user" {
  count = data.coder_workspace.me.start_count
  resource_id = htpasswd_password.user[0].id
  hide = true
}

resource "tls_private_key" "ssh_key" {
  count = data.coder_workspace.me.start_count
  algorithm = "ED25519"
}

resource "coder_metadata" "tls_private_key_ssh_key" {
  count = data.coder_workspace.me.start_count
  resource_id = tls_private_key.ssh_key[0].id
  item {
    key = "SSH Key"
    value = tls_private_key.ssh_key[0].private_key_openssh
    sensitive = true
  }
}

