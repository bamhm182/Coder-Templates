resource "digitalocean_volume" "home" {
  region                   = data.coder_parameter.region.value
  name                     = "coder-${data.coder_workspace.me.id}-${data.coder_workspace.me.owner}-home"
  size                     = data.coder_parameter.home_volume_size.value
  initial_filesystem_type  = "ext4"
  initial_filesystem_label = "${data.coder_workspace.me.owner}-home"
  # Protect the volume from being deleted due to changes in attributes.
  lifecycle {
    ignore_changes = all
  }
}

resource "coder_metadata" "digitialocean_volume_home" {
  resource_id = digitalocean_volume.home.id
  hide = true

  item {
    key   = "size"
    value = "${digitalocean_volume.home.size} GiB"
  }
}

# ---

resource "digitalocean_droplet" "workspace" {
  region = data.coder_parameter.region.value
  name   = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
  image  = data.coder_parameter.droplet_image.value
  size   = data.coder_parameter.droplet_size.value

  volume_ids = [
    digitalocean_volume.home.id
  ]
  user_data = templatefile("configs/cloud-config.yaml.tftpl", {
    username          = data.coder_workspace.me.owner
    home_volume_label = digitalocean_volume.home.initial_filesystem_label
    init_script       = base64encode(coder_agent.main.init_script)
    coder_agent_token = coder_agent.main.token
  })
  # Required to provision Fedora.
  ssh_keys = var.step2_do_admin_ssh_key > 0 ? [var.step2_do_admin_ssh_key] : []
}

resource "coder_metadata" "digitalocean_droplet_workspace" {
  resource_id = digitalocean_droplet.workspace.id

  item {
    key   = "region"
    value = digitalocean_droplet.workspace.region
  }
  item {
    key   = "image"
    value = digitalocean_droplet.workspace.image
  }
  item {
    key = "size"
    value = digitalocean_droplet.workspace.size
  }
}

# ---

resource "digitalocean_project_resources" "project" {
  project = var.step1_do_project_id
  # Workaround for terraform plan when using count.
  resources = length(digitalocean_droplet.workspace) > 0 ? [
    digitalocean_volume.home.urn,
    digitalocean_droplet.workspace.urn
    ] : [
    digitalocean_volume.home.urn
  ]
}

resource "coder_metadata" "hide_project" {
  resource_id = digitalocean_project_resources.project.id
  hide = true
}

