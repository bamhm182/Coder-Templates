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

# ---

resource "libvirt_domain" "main" {
  name       = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}")
  count      = data.coder_workspace.me.start_count
  memory     = data.coder_parameter.ram_amount.value
  vcpu       = data.coder_parameter.cpu_count.value
  machine    = "q35"
  qemu_agent = true

  disk {
    volume_id = libvirt_volume.root[0].id
    scsi = true
  }

  boot_device {
    dev = [ "hd" ]
  }

  network_interface {
    macvtap        = data.coder_parameter.vlan.value
    wait_for_lease = true
  }

  filesystem {
    source  = "/var/lib/libvirt/shares/coder-${lower(data.coder_workspace.me.owner)}-${lower(data.coder_workspace.me.name)}"
    target  = "out"
    readonly = false
  }

  xml {
    xslt = file("cdrom.xsl")
  }
}

resource "coder_metadata" "libvirt_domain_main" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_domain.main[0].id
  hide        = true
}
