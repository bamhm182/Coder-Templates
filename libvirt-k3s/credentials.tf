# ========== NODE0 ==========

resource "random_integer" "password_length_node0" {
  count = data.coder_workspace.me.start_count
  min   = 40
  max   = 64
}

resource "random_password" "user_node0" {
  count = data.coder_workspace.me.start_count
  length = random_integer.password_length_node0.result
}

resource "random_password" "user_salt_node0" {
  count = data.coder_workspace.me.start_count
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node0" {
  count = data.coder_workspace.me.start_count
  password = random_password.user_node0.result
  salt = random_password.user_salt_node0.result
}

resource "tls_private_key" "ssh_key_node0" {
  count = data.coder_workspace.me.start_count
  algorithm = "ED25519"
}

# ========== NODE1 ==========

resource "random_integer" "password_length_node1" {
  count = data.coder_workspace.me.start_count
  min   = 40
  max   = 64
}

resource "random_password" "user_node1" {
  count = data.coder_workspace.me.start_count
  length = random_integer.password_length_node1.result
}

resource "random_password" "user_salt_node1" {
  count = data.coder_workspace.me.start_count
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node1" {
  count = data.coder_workspace.me.start_count
  password = random_password.user_node1.result
  salt = random_password.user_salt_node1.result
}

resource "tls_private_key" "ssh_key_node1" {
  count = data.coder_workspace.me.start_count
  algorithm = "ED25519"
}

# ========== NODE2 ==========

resource "random_integer" "password_length_node2" {
  count = data.coder_workspace.me.start_count
  min   = 40
  max   = 64
}

resource "random_password" "user_node2" {
  count = data.coder_workspace.me.start_count
  length = random_integer.password_length_node2.result
}

resource "random_password" "user_salt_node2" {
  count = data.coder_workspace.me.start_count
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node2" {
  count = data.coder_workspace.me.start_count
  password = random_password.user_node2.result
  salt = random_password.user_salt_node2.result
}

resource "tls_private_key" "ssh_key_node2" {
  count = data.coder_workspace.me.start_count
  algorithm = "ED25519"
}

# ========== NODE3 ==========

resource "random_integer" "password_length_node3" {
  count = data.coder_workspace.me.start_count
  min   = 40
  max   = 64
}

resource "random_password" "user_node3" {
  count = data.coder_workspace.me.start_count
  length = random_integer.password_length_node3.result
}

resource "random_password" "user_salt_node3" {
  count = data.coder_workspace.me.start_count
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node3" {
  count = data.coder_workspace.me.start_count
  password = random_password.user_node3.result
  salt = random_password.user_salt_node3.result
}

resource "tls_private_key" "ssh_key_node3" {
  count = data.coder_workspace.me.start_count
  algorithm = "ED25519"
}
# ========== NODE4 ==========

resource "random_integer" "password_length_node4" {
  count = data.coder_workspace.me.start_count
  min   = 40
  max   = 64
}

resource "random_password" "user_node4" {
  count = data.coder_workspace.me.start_count
  length = random_integer.password_length_node4.result
}

resource "random_password" "user_salt_node4" {
  count = data.coder_workspace.me.start_count
  length = 8
  override_special = "./"
}

resource "htpasswd_password" "user_node4" {
  count = data.coder_workspace.me.start_count
  password = random_password.user_node4.result
  salt = random_password.user_salt_node4.result
}

resource "tls_private_key" "ssh_key_node4" {
  count = data.coder_workspace.me.start_count
  algorithm = "ED25519"
}
