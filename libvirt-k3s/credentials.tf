resource "random_integer" "password_length" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  min = 40
  max = 64
}

resource "random_password" "user" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  length = random_integer.password_length[count.index].result
}

resource "random_password" "user_salt" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  password = random_password.user[count.index].result
  salt = random_password.user_salt[count.index].result
}

resource "tls_private_key" "ssh_key" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  algorithm = "ED25519"
}
