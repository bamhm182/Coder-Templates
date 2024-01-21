resource "ssh_resource" "example" {
  host         = libvirt_domain.main[0].network_interface.0.addresses.0
  count        = data.coder_workspace.me.start_count
  user         = "user"
  private_key = tls_private_key.ssh_key.private_key_openssh

  when         = "create"

  file {
    content     = data.coder_workspace.me.access_url
    destination = "~/.config/coder/url"
    permissions = "0400"
  }

  file {
    content     = coder_agent.main.token
    destination = "~/.config/coder/token"
    permissions = "0400"
  }

  pre_commands = [ 
    "mkdir -p ~/.config/coder",
    "chmod 0700 ~/.config/coder",
  ]
}
