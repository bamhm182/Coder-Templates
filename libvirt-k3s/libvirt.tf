resource "libvirt_cloudinit_disk" "init" {
  count      = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  name       = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-init-node${count.index}.iso")
  user_data  = data.template_file.user_data[count.index].rendered
  pool       = "working"
}

# ---

data "template_file" "user_data" {
  count             = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  template          = templatefile("${path.module}/cloud-init/nixos/user-data.cfg", {
    password_hash   = htpasswd_password.user[count.index].sha512,
    authorized_keys = chomp(tls_private_key.ssh_key[count.index].public_key_openssh),
  })
}

resource "libvirt_volume" "root" {
  name             = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3s-node${count.index}.qcow2")
  count            = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  pool             = "working"
  format           = "qcow2"
  base_volume_name = count.index == 0 ? "nixos-k3s-server.qcow2" : "nixos-k3s-agent.qcow2"
  base_volume_pool = "baselines"
}

#resource "coder_metadata" "libvirt_volume_root" {
#  count       = data.coder_workspace.me.start_count
#  resource_id = libvirt_volume.root[0].id
#  hide        = true
#}

resource "libvirt_volume" "home" {
  count            = length(local.coder_agents)
  name             = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3s-node${count.index}.home.qcow2")
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "home.ext4.qcow2"
  base_volume_pool = "baselines"
}

#resource "coder_metadata" "libvirt_volume_home" {
#  count       = data.coder_workspace.me.start_count
#  resource_id = libvirt_volume.home[0].id
#  hide        = true
#}

# ---

resource "random_integer" "network" {
  count = 2
  min = 0
  max = 254
}

resource "libvirt_network" "k3snet" {
  name      = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3snet")
  count     = data.coder_workspace.me.start_count
  mode      = "none"
  addresses = [ "127.${random_integer.network[0].result}.${random_integer.network[1].result}.0/24" ]
}

resource "libvirt_domain" "node" {
  name       = lower("coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-k3s-node${count.index}")
  count      = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  memory     = (data.coder_parameter.ram_amount.value * 1024)
  vcpu       = data.coder_parameter.cpu_count.value
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.init[count.index].id

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
    network_id = libvirt_network.k3snet[0].id
    mac = "6B:38:73:00:00:${format("%02X", count.index)}"
  }

  filesystem {
    source  = "/var/lib/libvirt/shares/coder-${lower(data.coder_workspace_owner.me.name)}-${lower(data.coder_workspace.me.name)}-k3s-node0"
    target  = "out"
    readonly = false
  }

}

resource "null_resource" "scripts" {
  count = data.coder_workspace.me.start_count == 0 ? 0 : length(local.coder_agents)
  depends_on = [libvirt_domain.node]

  provisioner "remote-exec" {
    inline = concat([
      "install -d -m 0700 ~/.config/coder",
      "rm ~/.config/coder/*",
      "echo ${data.coder_workspace.me.access_url} > ~/.config/coder/url",
      "echo ${local.coder_agents[count.index].token} > ~/.config/coder/token",
      "chmod 0600 ~/.config/coder/*" ],
      (count.index == 0 ? [
      "install -d -m 0700 ~/.config/k3s",
      "echo ${base64encode(tls_private_key.ca_private_key.private_key_pem)} | base64 -d > ~/.config/k3s/client-ca.key",
      "echo ${base64encode(tls_self_signed_cert.ca_cert.cert_pem)} | base64 -d > ~/.config/k3s/client-ca.crt",
      "echo ${base64encode(tls_private_key.internal.private_key_pem)} | base64 -d > ~/.config/k3s/client-admin.key",
      "echo ${base64encode(tls_locally_signed_cert.internal.cert_pem)} | base64 -d > ~/.config/k3s/client-admin.crt",
      "echo ${base64encode(tls_self_signed_cert.ca_cert.cert_pem)} | base64 -d >> ~/.config/k3s/client-admin.crt" ] : [ ]))

    connection {
      type        = "ssh"
      user        = "user"
      host        = flatten([for nic in libvirt_domain.node[count.index].network_interface :
                              [for addr in nic.addresses : addr if can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", addr))]])[0]
      private_key = tls_private_key.ssh_key[count.index].private_key_openssh
      timeout     = "1m"
    }
  }
}
