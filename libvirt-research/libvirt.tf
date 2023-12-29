resource "libvirt_cloudinit_disk" "init" {
  count = data.coder_workspace.me.start_count
  name      = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-init.iso")
  user_data = data.template_file.user_data[0].rendered
  pool      = "working"
}

resource "coder_metadata" "libvirt_cloudinit_disk_init" {
  count = data.coder_workspace.me.start_count
  resource_id = libvirt_cloudinit_disk.init[0].id
  hide        = true
}

# ---

data "template_file" "user_data" {
  count = data.coder_workspace.me.start_count
  template = templatefile("${path.module}/cloud-init/${split("-", data.coder_parameter.baseline_image.value)[0]}/user-data.cfg", {
    password_hash      = htpasswd_password.user[0].sha512,
    authorized_keys    = chomp(tls_private_key.ssh_key[0].public_key_openssh),
  })
}

resource "libvirt_volume" "root" {
  name             = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}.qcow2")
  count            = data.coder_workspace.me.start_count
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "${data.coder_parameter.baseline_image.value}.qcow2"
  base_volume_pool = "baselines"
}

resource "coder_metadata" "libvirt_volume_root" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_volume.root[0].id
  hide        = true
}

resource "libvirt_volume" "home" {
  name   = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}.home.qcow2")
  pool   = "working"
  format = "qcow2"
  base_volume_name = "home.ext4.qcow2"
  base_volume_pool = "baselines"
}

resource "coder_metadata" "libvirt_volume_home" {
  resource_id = libvirt_volume.home.id
  hide        = true
}

resource "libvirt_volume" "router" {
  name             = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}.router.qcow2")
  count            = data.coder_workspace.me.start_count
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "${data.coder_parameter.router_image.value}.qcow2"
  base_volume_pool = "baselines"
}

resource "coder_metadata" "libvirt_volume_router" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_volume.router[0].id
  hide        = true
}

# ---

resource "libvirt_domain" "main" {
  name       = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}")
  count      = data.coder_workspace.me.start_count
  memory     = 4096
  vcpu       = 2
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.init[0].id

  timeouts {
    create = "1m"
  }

  disk {
    volume_id = libvirt_volume.root[0].id
  }

  disk {
    volume_id = libvirt_volume.home.id
  }

  boot_device {
    dev = [ "hd" ]
  }

  network_interface {
    network_id     = libvirt_network.private[0].id
    wait_for_lease = true
  }

  filesystem {
    source  = "/var/lib/libvirt/shares/coder-${lower(data.coder_workspace.me.owner)}-${lower(data.coder_workspace.me.name)}"
    target  = "out"
    readonly = false
  }

  provisioner "remote-exec" {
    inline = [
      "install -d -m 0700 ~/.config/coder",
      "rm ~/.config/coder/*",
      "echo coder.local > ~/.config/coder/url",
      "echo ${coder_agent.main[0].token} > ~/.config/coder/token",
      "chmod 0600 ~/.config/coder/*"
    ]

    connection {
      type        = "ssh"
      user        = "user"
      host        = libvirt_domain.router[0].network_interface.0.addresses.0
      port        = 2222
      private_key = tls_private_key.ssh_key[0].private_key_openssh
      timeout     = "1m"
    }
  }
}

resource "coder_metadata" "libvirt_domain_main" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_domain.main[0].id
  hide        = true
}

resource "libvirt_domain" "router" {
  name       = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}")
  count      = data.coder_workspace.me.start_count
  memory     = 1024
  vcpu       = 1
  qemu_agent = true

  timeouts {
    create = "1m"
  }

  disk {
    volume_id = libvirt_volume.router[0].id
  }

  boot_device {
    dev = [ "hd" ]
  }

  network_interface {
    macvtap        = data.coder_parameter.vlan.value
    wait_for_lease = true
  }

  network_interface {
    network_id     = libvirt_network.private[0].id
    wait_for_lease = false
  }
}

resource "coder_metadata" "libvirt_domain_router" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_domain.router[0].id
  hide        = true
}

resource "libvirt_network" "private" {
  count  = data.coder_workspace.me.start_count
  name   = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-private")
  mode   = "none"
  domain = "local"
}
