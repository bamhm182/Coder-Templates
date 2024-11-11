resource "null_resource" "iso_deps" {
  provisioner "local-exec" {
    command = "apk update && apk add cdrkit libxslt"
    interpreter = [ "/bin/sh", "-c" ]
  }
}

resource "libvirt_cloudinit_disk" "init" {
  count      = data.coder_workspace.me.start_count
  depends_on = [ null_resource.iso_deps ]
  name       = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-init.iso")
  user_data  = data.template_file.user_data[0].rendered
  pool       = "working"
}

resource "coder_metadata" "libvirt_cloudinit_disk_init" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_cloudinit_disk.init[0].id
  hide        = true
}

# ---

data "template_file" "user_data" {
  count             = data.coder_workspace.me.start_count
  template          = templatefile("${path.module}/cloud-init/nixos/user-data.cfg", {
    password_hash   = htpasswd_password.user[0].sha512,
    authorized_keys = chomp(tls_private_key.ssh_key[0].public_key_openssh),
  })
}

resource "libvirt_volume" "root" {
  name             = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3s-${count.index}.qcow2")
  count            = data.coder_workspace.me.start_count == 0 ? 0 : data.coder_parameter.node_count.value
  pool             = "working"
  format           = "qcow2"
  base_volume_name = count.index == 0 ? "nixos-k8s-server.qcow2" : "nixos-k8s-agent.qcow2"
  base_volume_pool = "baselines"
}

resource "coder_metadata" "libvirt_volume_root" {
  count       = data.coder_workspace.me.start_count == 0 ? 0 : data.coder_parameter.node_count.value
  resource_id = libvirt_volume.root[count.index].id
  hide        = true
}

resource "libvirt_volume" "home" {
  count            = data.coder_parameter.node_count.value
  name             = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3s-${count.index}.home.qcow2")
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "home.ext4.qcow2"
  base_volume_pool = "baselines"
}

resource "coder_metadata" "libvirt_volume_home" {
  count       = data.coder_parameter.node_count.value
  resource_id = libvirt_volume.home[count.index].id
  hide        = true
}

# ---

resource "libvirt_network" "k3snet" {
  name      = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3snet")
  count     = data.coder_workspace.me.start_count
  mode      = "nat"
  domain    = "k3s.local"
  addresses = [ "10.3.3.0/24" ]

  dns {
    enabled    = true
    local_only = false
  }
}

resource "libvirt_domain" "node" {
  name       = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3s-${count.index}")
  count      = data.coder_workspace.me.start_count == 0 ? 0 : data.coder_parameter.node_count.value
  memory     = (data.coder_parameter.ram_amount.value * 1024)
  vcpu       = data.coder_parameter.cpu_count.value
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.init[0].id

  timeouts {
    create = "1m"
  }

  disk {
    volume_id = libvirt_volume.root[count.index].id
  }

  disk {
    volume_id = libvirt_volume.home[count.index].id
  }

  boot_device {
    dev = [ "hd" ]
  }

  network_interface {
    macvtap        = "clear"
    wait_for_lease = true
  }

  network_interface {
    network_id     = libvirt_network.k3snet[0].id
    addresses      = [ "10.3.3.${10 + count.index}" ]
    wait_for_lease = false
  }

  filesystem {
    source  = "/var/lib/libvirt/shares/coder-${lower(data.coder_workspace_owner.me.name)}-${lower(data.coder_workspace.me.name)}"
    target  = "out"
    readonly = false
  }

  provisioner "remote-exec" {
    inline = [
      "install -d -m 0700 ~/.config/coder",
      "rm ~/.config/coder/*",
      "echo ${data.coder_workspace.me.access_url} > ~/.config/coder/url",
      "echo ${coder_agent.main.token} > ~/.config/coder/token",
      "chmod 0600 ~/.config/coder/*"
    ]

    connection {
      type        = "ssh"
      user        = "user"
      host        = libvirt_domain.node[0].network_interface.0.addresses.0
      private_key = tls_private_key.ssh_key[0].private_key_openssh
      timeout     = "1m"
    }
  }
}

resource "coder_metadata" "libvirt_domain_node" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_domain.node[0].id
  hide        = true
}
