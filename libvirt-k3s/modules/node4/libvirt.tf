resource "libvirt_cloudinit_disk" "init_node4" {
  name      = lower("${local.instance_name}.init.iso")
  user_data = data.template_file.user_data.rendered
  pool      = "working"
}

# ---

data "template_file" "user_data_node4" {
  template = templatefile("${path.module}/cloudinit.cfg.template", {
    password_hash   = htpasswd_password.user.sha512,
    authorized_keys = chomp(tls_private_key.ssh_key.public_key_openssh),
  })
}

resource "libvirt_volume" "root_node4" {
  name             = lower("${local.instance_name}.qcow2")
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "nixos-${var.flavor}-${var.type}.qcow2"
  base_volume_pool = "baselines"
}

resource "libvirt_volume" "home_node4" {
  name             = lower("${local.instance_name}.home.qcow2")
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "home.ext4.qcow2"
  base_volume_pool = "baselines"
}

# ---

resource "libvirt_domain" "node4" {
  name       = local.instance_name
  memory     = var.ram
  vcpu       = var.cpu
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.init_node4.id

  timeouts {
    create = "1m"
  }

  disk {
    volume_id = libvirt_volume.root_node4.id
  }

  disk {
    volume_id = libvirt_volume.home_node4.id
  }

  boot_device {
    dev = [ "hd" ]
  }

  network_interface {
    macvtap        = "clear"
    wait_for_lease = true
  }

  network_interface {
    network_id = var.network_id
    mac = "6E:6F:64:65:73:${format("%02X", var.ws_number)}"
  }

  filesystem {
    source  = "/var/lib/libvirt/shares/coder-${lower(var.owner)}-${lower(var.ws_name)}-node0"
    target  = "out"
    readonly = false
  }
}

resource "null_resource" "scripts_node4" {
  depends_on = [libvirt_domain.node4]

  provisioner "remote-exec" {
    inline = concat([
      "install -d -m 0700 ~/.config/coder",
      "rm ~/.config/coder/*",
      "echo ${var.coder_url} > ~/.config/coder/url",
      "echo ${var.agent_token} > ~/.config/coder/token",
      "chmod 0600 ~/.config/coder/*" ],
      (var.type == "server" ? [
      "install -d -m 0700 ~/.config/k3s",
      "echo ${base64encode(tls_private_key.ca_private_key.private_key_pem)} | base64 -d > ~/.config/k3s/client-ca.key",
      "echo ${base64encode(tls_self_signed_cert.ca_cert.cert_pem)} | base64 -d > ~/.config/k3s/client-ca.crt",
      "echo ${base64encode(tls_private_key.internal.private_key_pem)} | base64 -d > ~/.config/k3s/client-admin.key",
      "echo ${base64encode(tls_locally_signed_cert.internal.cert_pem)} | base64 -d > ~/.config/k3s/client-admin.crt",
      "echo ${base64encode(tls_self_signed_cert.ca_cert.cert_pem)} | base64 -d >> ~/.config/k3s/client-admin.crt" ] : [ ]))

    connection {
      type        = "ssh"
      user        = "user"
      host        = flatten([for nic in libvirt_domain.node4.network_interface :
                              [for addr in nic.addresses : addr if can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", addr))]])[0]
      private_key = tls_private_key.ssh_key_node4.private_key_openssh
      timeout     = "1m"
    }
  }
}
