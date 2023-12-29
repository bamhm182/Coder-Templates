resource "libvirt_cloudinit_disk" "init" {
  count     = data.coder_workspace.me.start_count
  name      = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-init.iso")
  user_data = data.template_file.user_data[0].rendered
  pool      = "working"
}

resource "coder_metadata" "libvirt_cloudinit_disk_init" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_cloudinit_disk.init[0].id
  hide        = true
}

# ---

data "template_file" "user_data" {
  count = data.coder_workspace.me.start_count
  template = templatefile("${path.module}/user-data.cfg", {
    password_hash      = htpasswd_password.user[0].sha512,
    authorized_keys    = chomp(tls_private_key.ssh_key[0].public_key_openssh),
  })
}

resource "libvirt_volume" "netboot_hdd" {
  name             = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}.qcow2")
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "nixos-netboot.qcow2"
  base_volume_pool = "baselines"
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

resource "coder_metadata" "libvirt_volume_netboot_hdd" {
  resource_id = libvirt_volume.netboot_hdd.id
  hide        = true
}

resource "libvirt_volume" "newbie_hdd" {
  name             = lower("${data.coder_workspace.me.name}.qcow2")
  pool             = "working"
  format           = "qcow2"
  size             = 68719476736  # 64GB
}

resource "coder_metadata" "libvirt_volume_newbie_hdd" {
  resource_id = libvirt_volume.newbie_hdd.id
  hide        = true
}

# ---

resource "libvirt_domain" "netboot" {
  name       = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-netboot")
  count      = data.coder_workspace.me.start_count
  memory     = 1024
  vcpu       = 1
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.init[0].id

  timeouts {
    create = "1m"
  }

  disk {
    volume_id = libvirt_volume.netboot_hdd.id
  }

  disk {
    volume_id = libvirt_volume.home.id
  }

  boot_device {
    dev = [ "hd" ]
  }

  network_interface {
    macvtap        = "clear"
    wait_for_lease = true
  }

  network_interface {
    network_id     = libvirt_network.private[0].id
    wait_for_lease = false
  }

  filesystem {
    source   = "/var/lib/libvirt/shares/coder-${lower(data.coder_workspace.me.owner)}-${lower(data.coder_workspace.me.name)}"
    target   = "out"
    readonly = false
  }

  filesystem {
    source   = "/var/lib/libvirt/images/isos/"
    target   = "isos"
    readonly = false
  }

  provisioner "remote-exec" {
    inline = [
      "install -d -m 0700 ~/.config/coder",
      "rm ~/.config/coder/*",
      "echo ${data.coder_workspace.me.access_url} > ~/.config/coder/url",
      "echo ${coder_agent.main[0].token} > ~/.config/coder/token",
      "chmod 0600 ~/.config/coder/*"
    ]

    connection {
      type        = "ssh"
      user        = "user"
      host        = libvirt_domain.netboot[0].network_interface.0.addresses.0
      private_key = tls_private_key.ssh_key[0].private_key_openssh
      timeout     = "1m"
    }
  }
}

resource "coder_metadata" "libvirt_domain_netboot" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_domain.netboot[0].id
  hide        = true
}

resource "libvirt_domain" "newbie" {
  name       = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-newbie")
  count      = data.coder_workspace.me.start_count
  memory     = 16384
  vcpu       = 4
  qemu_agent = false
  machine    = "q35"
  firmware   = "/run/libvirt/nix-ovmf/OVMF_CODE.fd"
  depends_on = [ libvirt_domain.netboot[0] ]

  cpu {
    mode = "host-passthrough"
  }

  timeouts {
    create = "1m"
  }

  disk {
    volume_id = libvirt_volume.newbie_hdd.id
  }

  disk {
    file = "/var/lib/libvirt/images/isos/windows/11/x64/installer.iso"
  }

  disk {
    file = "/var/lib/libvirt/images/isos/windows/virtio.iso"
  }

#  disk {
#    file = "/var/lib/libvirt/images/isos/windows/autounattend.iso"
#  }

  boot_device {
    dev = [ "hd", "cdrom" ]
  }

  network_interface {
    network_id     = libvirt_network.private[0].id
    wait_for_lease = false
  }
  
  xml {
    xslt = file("tweaks.xsl")
  }
}

resource "coder_metadata" "libvirt_domain_newbie" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_domain.newbie[0].id
  hide        = true
}

resource "libvirt_network" "private" {
  count  = data.coder_workspace.me.start_count
  name   = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-private")
  mode   = "none"
  domain = "netboot.xyz"
}
