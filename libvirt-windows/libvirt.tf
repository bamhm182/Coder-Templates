resource "libvirt_volume" "root" {
  name             = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}.qcow2")
  pool             = "working"
  format           = "qcow2"
  base_volume_name = "${data.coder_parameter.baseline_image.value}.qcow2"
  base_volume_pool = "baselines"
}

resource "coder_metadata" "libvirt_volume_root" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_volume.root.id
  hide        = true
}

# ---

data "template_cloudinit_config" "example" {
  count         = data.coder_workspace.me.start_count
  gzip          = false
  base64_encode = false
  part {
    filename     = "testing.ps1"
    content_type = "text/x-shellscript"
    content      = <<-EOF
        Start-Transcript -Append "C:\cloudinit-config-example.ps1.log"
        New-Item -ItemType Directory -Path C:/Users/user/.ssh
        Write-Host ${random_password.user[0].result}
      EOF
  }
  part {
    content_type = "text/cloud-config"
    content      = <<-EOF
      hostname: example
      timezone: Etc/UTC
      users:
        - name: bob
          passwd: password123
          primary_group: Administrators
          ssh_authorized_keys:
            - ${tls_private_key.ssh_key[0].public_key_openssh}
      runcmd:
        - "mkdir C:\testing"
    EOF
  }
}

resource "libvirt_cloudinit_disk" "example_cloudinit" {
  count     = data.coder_workspace.me.start_count
  name      = "${lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}")}.iso"
  meta_data = jsonencode({
    "instance-id" : random_id.example.hex,
  })
  user_data = data.template_cloudinit_config.example[0].rendered
}


# ---

resource "libvirt_domain" "main" {
  name       = lower("coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}")
  count      = data.coder_workspace.me.start_count
  memory     = data.coder_parameter.ram_amount.value
  vcpu       = data.coder_parameter.cpu_count.value
  machine    = "q35"
  firmware   = "/run/libvirt/nix-ovmf/OVMF_CODE.fd"
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.example_cloudinit[0].id

  timeouts {
    create = "2m"
  }

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.root.id
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

//  provisioner "remote-exec" {
//    inline = [
//      "powershell.exe New-Item -ItemType Directory -Path C:/Users/user/.ssh"
//      "New-Item -ItemType Directory -Path C:\\Users\\user\\AppData\\Roaming\\Coder",
//      "Write-Output '${random_password.user[0].result}' | Out-File C:\\Users\\user\\Desktop\\password.txt",
//      "Write-Output '${chomp(tls_private_key.ssh_key[0].public_key_openssh)}' | Out-File C:\\Users\\user\\.ssh\\authorized_keys",
//      "Write-Output '${data.coder_workspace.me.access_url}' | Out-File C:\\Users\\user\\AppData\\Roaming\\Coder\\url",
//      "Write-Output '${coder_agent.main[0].token}' | Out-File C:\\Users\\user\\AppData\\Roaming\\Coder\\token"
//    ]
//    connection {
//      type     = "ssh"
//      user     = "Admin"
//      password = "password"
//      host     = libvirt_domain.main[0].network_interface.0.addresses.0
//      timeout  = "2m"
//    }
//  }
  
  xml {
    xslt = file("tweaks.xsl")
  }
}

resource "coder_metadata" "libvirt_domain_main" {
  count       = data.coder_workspace.me.start_count
  resource_id = libvirt_domain.main[0].id
  hide        = true
}

