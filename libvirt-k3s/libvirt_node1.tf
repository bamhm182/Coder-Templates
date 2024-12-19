resource "libvirt_cloudinit_disk" "init_node1" {
  count      = data.coder_workspace.me.start_count
  name       = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-init-node1.iso")
  user_data  = data.template_file.user_data_node1.rendered
  pool       = "working"
}

# ---

data "template_file" "user_data_node1" {
  count             = data.coder_workspace.me.start_count
  template          = templatefile("${path.module}/cloudinit.cfg.template", {
    password_hash   = htpasswd_password.user_node1.sha512,
    authorized_keys = chomp(tls_private_key.ssh_key_node1.public_key_openssh),
  })
}

resource "libvirt_volume" "root_node1" {
  name             = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3s-node1.qcow2")
  count            = data.coder_workspace.me.start_count
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "nixos-k3s-agent.qcow2"
  base_volume_pool = "baselines"
}

resource "libvirt_volume" "home_node1" {
  count            = 1
  name             = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3s-node1.home.qcow2")
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "home.ext4.qcow2"
  base_volume_pool = "baselines"
}

# ---

resource "libvirt_domain" "node1" {
  name       = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3s-node1")
  count      = data.coder_workspace.me.start_count
  memory     = (data.coder_parameter.ram_amount.value * 1024)
  vcpu       = data.coder_parameter.cpu_count.value
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.init_node1.id

  timeouts {
    create = "1m"
  }

  disk {
    volume_id = libvirt_volume.root_node1.id
  }

  disk {
    volume_id = libvirt_volume.home_node1.id
  }

  boot_device {
    dev = [ "hd" ]
  }

  network_interface {
    macvtap        = "clear"
    wait_for_lease = true
  }

  network_interface {
    network_id = libvirt_network.k3snet.id
    mac = "6E:6F:64:65:73:00"
  }

  filesystem {
    source  = "/var/lib/libvirt/shares/coder-${lower(data.coder_workspace_owner.me.name)}-${lower(data.coder_workspace.me.name)}-k3s-node1"
    target  = "out"
    readonly = false
  }

}

resource "null_resource" "scripts_node1" {
  count = data.coder_workspace.me.start_count
  depends_on = [libvirt_domain.node]

  provisioner "remote-exec" {
    inline = [
      "install -d -m 0700 ~/.config/coder",
      "rm ~/.config/coder/*",
      "echo ${data.coder_workspace.me.access_url} > ~/.config/coder/url",
      "echo ${coder_agent.node1.token} > ~/.config/coder/token",
      "chmod 0600 ~/.config/coder/*"
    ]

    connection {
      type        = "ssh"
      user        = "user"
      host        = flatten([for nic in libvirt_domain.node1.network_interface :
                              [for addr in nic.addresses : addr if can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", addr))]])[0]
      private_key = tls_private_key.ssh_key_node1.private_key_openssh
      timeout     = "1m"
    }
  }
}
