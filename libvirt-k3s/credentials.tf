resource "random_integer" "password_length" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  min = 40
  max = 64
}

resource "random_password" "user" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  length = random_integer.password_length[count.index].result
}

resource "coder_metadata" "random_password_user0" {
  count = data.coder_workspace.me.start_count
  resource_id = random_password.user[0].id
  item {
    key = "Password"
    value = random_password.user[0].result
    sensitive = true
  }
}

resource "coder_metadata" "random_password_user1" {
  count = data.coder_workspace.me.start_count
  resource_id = random_password.user[1].id
  item {
    key = "Password"
    value = random_password.user[1].result
    sensitive = true
  }
}

resource "coder_metadata" "random_password_user2" {
  count = data.coder_workspace.me.start_count
  resource_id = random_password.user[2].id
  item {
    key = "Password"
    value = random_password.user[2].result
    sensitive = true
  }
}
resource "random_password" "user_salt" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  length = 8
  override_special = "./"
}

resource "coder_metadata" "random_password_user_salt0" {
  count = data.coder_workspace.me.start_count
  resource_id = random_password.user_salt[0].id
  hide = true
}

resource "coder_metadata" "random_password_user_salt1" {
  count = data.coder_workspace.me.start_count
  resource_id = random_password.user_salt[1].id
  hide = true
}

resource "coder_metadata" "random_password_user_salt2" {
  count = data.coder_workspace.me.start_count
  resource_id = random_password.user_salt[2].id
  hide = true
}

resource "htpasswd_password" "user" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  password = random_password.user[count.index].result
  salt = random_password.user_salt[count.index].result
}

resource "coder_metadata" "htpasswd_password_user0" {
  count = data.coder_workspace.me.start_count
  resource_id = htpasswd_password.user[0].id
  hide = true
}

resource "coder_metadata" "htpasswd_password_user1" {
  count = data.coder_workspace.me.start_count
  resource_id = htpasswd_password.user[1].id
  hide = true
}

resource "coder_metadata" "htpasswd_password_user2" {
  count = data.coder_workspace.me.start_count
  resource_id = htpasswd_password.user[2].id
  hide = true
}

resource "tls_private_key" "ssh_key" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  algorithm = "ED25519"
}

resource "coder_metadata" "tls_private_key_ssh_key0" {
  count = data.coder_workspace.me.start_count
  resource_id = tls_private_key.ssh_key[0].id
  item {
    key = "SSH Key"
    value = tls_private_key.ssh_key[0].private_key_openssh
    sensitive = true
  }
}

resource "coder_metadata" "tls_private_key_ssh_key1" {
  count = data.coder_workspace.me.start_count
  resource_id = tls_private_key.ssh_key[1].id
  item {
    key = "SSH Key"
    value = tls_private_key.ssh_key[1].private_key_openssh
    sensitive = true
  }
}

resource "coder_metadata" "tls_private_key_ssh_key2" {
  count = data.coder_workspace.me.start_count
  resource_id = tls_private_key.ssh_key[2].id
  item {
    key = "SSH Key"
    value = tls_private_key.ssh_key[2].private_key_openssh
    sensitive = true
  }
}
