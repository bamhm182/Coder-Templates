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
  template = templatefile("${path.module}/user-data.cfg", {
    password_hash      = htpasswd_password.user[0].sha512,
    authorized_keys    = chomp(tls_private_key.ssh_key[0].public_key_openssh),
  })
}

resource "libvirt_volume" "root" {
  name             = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}.qcow2")
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "${data.coder_parameter.baseline_image.value}.qcow2"
  base_volume_pool = "baselines"
}

resource "coder_metadata" "libvirt_volume_root" {
  resource_id = libvirt_volume.root.id
  hide        = true
}

# ---

resource "libvirt_domain" "main" {
  name       = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}")
  count      = data.coder_workspace.me.start_count
  memory     = data.coder_parameter.ram_amount.value
  vcpu       = data.coder_parameter.cpu_count.value
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.init[0].id

  timeouts {
    create = "2m"
  }

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.root.id
  }

  boot_device {
    dev = [ "hd" ]
  }

  filesystem {
    source  = "/var/lib/libvirt/shares/coder-${lower(data.coder_workspace.me.owner)}-${lower(data.coder_workspace.me.name)}"
    target  = "out"
    readonly = false
  }

  network_interface {
    macvtap        = data.coder_parameter.vlan.value
    wait_for_lease = true
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
      host        = libvirt_domain.main[0].network_interface.0.addresses.0
      private_key = tls_private_key.ssh_key[0].private_key_openssh
      timeout     = "2m"
    }
  }
}

resource "coder_metadata" "libvirt_domain_main" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_domain.main[0].id
  hide        = true
}

