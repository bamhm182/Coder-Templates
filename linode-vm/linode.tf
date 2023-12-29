resource "linode_instance" "instance" {
  label = substr("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}", 0, 64)
  count  = data.coder_workspace.me.start_count
  group = "coder-${data.coder_workspace.me.owner}"
  region = data.coder_parameter.linode_region.value
  type = data.coder_parameter.linode_type.value
  private_ip = true
}

resource "coder_metadata" "linode_instance_instance" {
  resource_id = linode_instance.instance[0].id
  count       = data.coder_workspace.me.start_count
  hide = true
  item {
    key = "IP Address"
    value = linode_instance.instance[0].ip_address
  }
}

# ---

resource "linode_instance_disk" "boot" {
  label = "boot"
  count  = data.coder_workspace.me.start_count
  linode_id = linode_instance.instance[0].id
  size = linode_instance.instance[0].specs.0.disk
  image = data.coder_parameter.linode_image.value
  authorized_keys = [ chomp(tls_private_key.ssh_key.public_key_openssh) ]

  stackscript_id = linode_stackscript.script.id
}

resource "coder_metadata" "linde_instance_disk_boot" {
  resource_id = linode_instance_disk.boot[0].id
  count       = data.coder_workspace.me.start_count
  hide = true
}

# ---

resource "linode_volume" "home" {
  label = format("%s%s", substr("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}", 0, 27), "-home")
  region = data.coder_parameter.linode_region.value
}

resource "coder_metadata" "linode_volume_home" {
  resource_id = linode_volume.home.id
  hide = true
}

# ---

resource "linode_instance_config" "config" {
  linode_id = linode_instance.instance[0].id
  count  = data.coder_workspace.me.start_count
  label = "boot"
  kernel = "linode/latest-64bit"
  booted = true

  device {
    device_name = "sda"
    disk_id = linode_instance_disk.boot[0].id
  }

  device {
    device_name = "sdb"
    volume_id = linode_volume.home.id
  }
}

resource "coder_metadata" "linode_instance_config_config" {
  resource_id = linode_instance_config.config[0].id
  count       = data.coder_workspace.me.start_count
  hide = true
}

# ---

resource "linode_stackscript" "script" {
  label = format("%s%s",substr("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}", 0, 120), "-script")
  description = "StackScript for coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name} linode"
  script = templatefile("StackScript.sh", {
    username          = data.coder_workspace.me.owner,
    password_hash     = htpasswd_password.user.sha512,
    hostname          = lower(data.coder_workspace.me.name),
    init_script       = base64encode(coder_agent.main.init_script),
    coder_agent_token = coder_agent.main.token,
  })
  images = [ "any/all" ]
}

resource "coder_metadata" "linode_stackscript_script" {
  resource_id = linode_stackscript.script.id
  # show the coder-agent GUI
  hide = false
}
